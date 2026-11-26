// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

/// The client: builds canonical requests, decides about credentials,
/// redirects, retries and caching, and turns responses into models or
/// exceptions.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'cache.dart';
import 'enums.dart';
import 'errors.dart';
import 'model_base.dart';
import 'platform/platform.dart';
import 'probabilities.dart';
import 'query.dart';
import 'sha256.dart';
import 'types.dart';
import 'version.dart';

/// The API's public base URL.
const String defaultBaseUrl = 'https://api.oureawx.com';

/// The default time allowed for one attempt.
const Duration defaultTimeout = Duration(seconds: 30);

/// The default number of retries after the first attempt.
const int defaultMaxRetries = 2;

/// The most redirects followed for one request.
const int maxRedirects = 5;

/// A response body over this size (64 MiB) is an error, not an
/// out-of-memory.
const int maxBodyBytes = 64 * 1024 * 1024;

const Duration _maxRetryAfter = Duration(seconds: 60);
const String _apiKeyEnv = 'OUREA_API_KEY';
const String _baseUrlEnv = 'OUREA_BASE_URL';
const Set<int> _redirects = {301, 302, 307, 308};
const Set<int> _retryStatuses = {429, 502, 503, 504};
const Set<int> _retryAfterStatuses = {429, 503, 504};

/// A point, in degrees: `(lat: 45.33, lon: -121.66)`.
typedef LatLon = ({double lat, double lon});

/// A bounding box in degrees, as RFC 7946's `bbox`:
/// `(west: -125, south: 41, east: -116, north: 49)`.
typedef BBox = ({double west, double south, double east, double north});

/// What `members=` asks for on a forecast.
enum Members {
  /// No per-member values (`members=false`, the default).
  none('false'),

  /// Every member's values, per hour (`members=true`).
  all('true'),

  /// The plume view (`members=plume`): `series.plume` columns, ready to
  /// draw, instead of per-hour members.
  plume('plume');

  const Members(this.wire);

  /// The value sent as `members=`.
  final String wire;
}

/// The order of a ranking.
enum SortOrder {
  /// The most first (the default).
  desc,

  /// The least first.
  asc,
}

/// Which points of each place `explore` ranks.
enum ExplorePoints {
  /// Each place's own point (the default).
  primary,

  /// Each named elevation too.
  all,
}

/// The API marked an operation as deprecated (`Deprecation` / `Sunset`
/// headers). Reported once per operation per process.
final class DeprecationNotice {
  /// Creates a notice.
  const DeprecationNotice({
    required this.operation,
    this.deprecation,
    this.sunset,
    this.link,
  });

  /// The operation, for example `getLocationForecast`.
  final String operation;

  /// The `Deprecation` header.
  final String? deprecation;

  /// The `Sunset` header.
  final String? sunset;

  /// The `Link rel="deprecation"` URL, if the response gave one.
  final String? link;

  /// One readable line.
  String get message {
    final parts = ['The Ourea API has deprecated $operation'];
    if (deprecation != null) parts.add('Deprecation: $deprecation');
    if (sunset != null) parts.add('Sunset: $sunset');
    if (link != null) parts.add('see $link');
    return '${parts.join('; ')}.';
  }

  @override
  String toString() => message;
}

void _printDeprecation(DeprecationNotice notice) {
  // A library has no warnings channel in Dart; print is visible on every
  // platform (the console, `flutter logs`, the browser console).
  // ignore: avoid_print
  print('ensemble_weather: ${notice.message}');
}

final Set<String> _warned = {};

final RegExp _linkDeprecation =
    RegExp(r'<([^>]*)>\s*;[^,]*rel="?deprecation"?', caseSensitive: false);

/// The SDK's User-Agent, optionally followed by the app's own product
/// token.
String userAgent([String? product]) {
  final base = 'ensemble-weather-dart/$packageVersion (${runtimeLabel()})';
  return product == null || product.isEmpty ? base : '$base $product';
}

// --- one call -------------------------------------------------------------

final class _Call<T extends Response> {
  _Call(
    this.operation,
    this.path,
    this.query,
    this.decode, {
    this.openRoute = false,
    this.prepareJson,
    this.finish,
  });

  final String operation;
  final String path;
  final String query;
  final T Function(Map<String, Object?> json) decode;
  final bool openRoute;
  final Map<String, Object?> Function(Map<String, Object?> json)? prepareJson;
  final void Function(Response result)? finish;
}

final class _Prepared {
  _Prepared(this.url, this.headers, this.cacheKey, this.cached);

  final String url;
  final Map<String, String> headers;
  final String? cacheKey;
  final CacheEntry? cached;
}

final class _Raw {
  _Raw(this.status, this.headers, this.body);

  final int status;
  final Map<String, String> headers;
  final Uint8List body;
}

final class _Retry {
  _Retry(this.delay);

  final Duration delay;
}

/// A client for the Ourea probabilistic weather API.
///
/// ```dart
/// final client = OureaClient(); // no key: anonymous calls use the Free tier
/// final forecast = await client.getForecast('or/mt-hood-meadows');
/// client.close();
/// ```
///
/// Every method is asynchronous and returns a typed model. Errors are
/// [OureaException]s. The client works on the Dart VM and in Flutter on
/// every platform, including the web.
final class OureaClient {
  /// Creates a client.
  ///
  /// * [apiKey]: your API key. Defaults to the `OUREA_API_KEY` environment
  ///   variable; with neither, calls are anonymous (Free tier), which is
  ///   valid. The key is sent only as `X-API-Key`, only to the base URL's
  ///   origin, and never on the open routes (search, catalog detail,
  ///   attribution, composition) unless [sendKeyOnOpenRoutes] is set, so
  ///   those share the edge cache with everyone.
  /// * [baseUrl]: the API's base URL. Defaults to `OUREA_BASE_URL`, else
  ///   `https://api.oureawx.com`. A trailing slash is ignored.
  /// * [units]: the default unit system for every request that accepts one.
  /// * [timeout]: the time allowed for each attempt.
  /// * [maxRetries]: retries after the first attempt (0 disables retrying).
  ///   Connection errors, 429, 502, 503 and 504 are retried.
  /// * [cache]: the ETag cache. Defaults to a new in-memory [MemoryCache];
  ///   pass `const NoCache()` to disable caching, or your own [Cache].
  /// * [sendKeyOnOpenRoutes]: send the key on the open routes too, so every
  ///   request is attributed to it (and none is edge-cached).
  /// * [appUserAgent]: your app's product token, appended to the SDK's own
  ///   User-Agent (browsers set their own).
  /// * [httpClient]: the `package:http` client to send with, for proxies and
  ///   tests. The SDK does not close a client you pass. TLS verification is
  ///   always on with the default client, and the SDK has no option to turn
  ///   it off.
  /// * [environment]: where to read `OUREA_API_KEY` and `OUREA_BASE_URL`
  ///   from (default: the process environment; the web has none).
  /// * [onDeprecation]: called once per operation per process when the API
  ///   marks it deprecated (default: print one line).
  ///
  /// Throws a [UsageException] for an invalid setting.
  OureaClient({
    String? apiKey,
    String? baseUrl,
    UnitSystem units = UnitSystem.metric,
    this.timeout = defaultTimeout,
    this.maxRetries = defaultMaxRetries,
    Cache? cache,
    this.sendKeyOnOpenRoutes = false,
    String? appUserAgent,
    http.Client? httpClient,
    Map<String, String>? environment,
    void Function(DeprecationNotice notice)? onDeprecation,
  })  : _http = httpClient ?? http.Client(),
        _ownsHttp = httpClient == null,
        units = _units(units),
        userAgentHeader = userAgent(appUserAgent),
        _onDeprecation = onDeprecation ?? _printDeprecation {
    final env = environment ?? processEnvironment();
    final key = apiKey ?? env[_apiKeyEnv];
    _apiKey = key == null || key.isEmpty ? null : key;
    final base = (baseUrl == null || baseUrl.isEmpty)
        ? ((env[_baseUrlEnv]?.isNotEmpty ?? false)
            ? env[_baseUrlEnv]!
            : defaultBaseUrl)
        : baseUrl;
    this.baseUrl = base.replaceFirst(RegExp(r'/+$'), '');
    _origin = Uri.parse(this.baseUrl);
    if (!_origin.hasScheme || _origin.host.isEmpty) {
      throw UsageException('baseUrl must be an absolute URL, got "$base"');
    }
    if (timeout <= Duration.zero) {
      throw UsageException('timeout must be positive');
    }
    if (maxRetries < 0) throw UsageException('maxRetries must be 0 or more');
    this.cache = cache is NoCache ? null : (cache ?? MemoryCache());
  }

  final http.Client _http;
  final bool _ownsHttp;
  late final String? _apiKey;
  late final Uri _origin;
  final void Function(DeprecationNotice notice) _onDeprecation;

  /// The base URL, without a trailing slash.
  late final String baseUrl;

  /// The default unit system.
  final UnitSystem units;

  /// The time allowed for each attempt.
  final Duration timeout;

  /// Retries after the first attempt.
  final int maxRetries;

  /// The ETag cache in use, or `null` when caching is disabled.
  late final Cache? cache;

  /// Whether the key is also sent on the open routes.
  final bool sendKeyOnOpenRoutes;

  /// The User-Agent header the client sends.
  final String userAgentHeader;

  RateLimit? _rateLimit;

  Future<void> Function(Duration delay) _sleep = Future<void>.delayed;
  double Function() _random = math.Random().nextDouble;
  DateTime Function() _clock = DateTime.now;

  /// Whether a key is configured (the key itself is never exposed).
  bool get hasApiKey => _apiKey != null;

  /// The rate-limit state of the last response, if it reported one.
  RateLimit? get rateLimit => _rateLimit;

  /// Closes the HTTP client, if the SDK created it.
  void close() {
    if (_ownsHttp) _http.close();
  }

  /// Describes the client without revealing the key.
  @override
  String toString() => 'OureaClient(baseUrl: $baseUrl, '
      'apiKey: ${_apiKey == null ? 'none' : 'set'}, units: $units)';

  // --- transport ----------------------------------------------------------

  Future<T> _run<T extends Response>(_Call<T> call) async {
    final prepared = await _prepare(call);
    final fresh = _freshFromCache(call, prepared);
    if (fresh != null) return fresh;
    var attempt = 0;
    while (true) {
      attempt++;
      final _Raw raw;
      try {
        raw = await _send(prepared).timeout(timeout);
      } on OureaException {
        rethrow;
      } on Object catch (error) {
        final retryable = !isTlsVerificationFailure(error) &&
            (error is http.ClientException ||
                error is TimeoutException ||
                isNetworkError(error));
        if (retryable && attempt <= maxRetries) {
          await _sleep(_jitter(attempt));
          continue;
        }
        throw ApiConnectionException(_scrub('${error.runtimeType}: $error'));
      }
      final outcome = await _handle(call, prepared, raw, attempt);
      if (outcome is _Retry) {
        await _sleep(outcome.delay);
        continue;
      }
      return outcome as T;
    }
  }

  Future<_Prepared> _prepare<T extends Response>(_Call<T> call) async {
    final url =
        '$baseUrl${call.path}${call.query.isEmpty ? '' : '?${call.query}'}';
    final headers = <String, String>{
      'User-Agent': userAgentHeader,
      'Accept': 'application/json',
    };
    final key = _apiKey;
    final sendKey = key != null && (!call.openRoute || sendKeyOnOpenRoutes);
    if (sendKey) headers['X-API-Key'] = key;
    String? cacheKey;
    CacheEntry? cached;
    final store = cache;
    if (store != null) {
      final identity = sendKey ? sha256Hex(key).substring(0, 32) : 'anonymous';
      cacheKey = '$url $identity';
      cached = await store.get(cacheKey);
      final etag = cached?.etag;
      if (etag != null) headers['If-None-Match'] = etag;
    }
    return _Prepared(url, headers, cacheKey, cached);
  }

  T? _freshFromCache<T extends Response>(_Call<T> call, _Prepared prepared) {
    final entry = prepared.cached;
    if (entry == null || !entry.isFresh(_clock())) return null;
    return _result(call, prepared, 200, entry.headers, entry.body,
        fromCache: true);
  }

  Future<_Raw> _send(_Prepared prepared) async {
    var url = prepared.url;
    var headers = prepared.headers;
    for (var hop = 0;; hop++) {
      final request = http.Request('GET', Uri.parse(url))
        ..followRedirects = false
        ..headers.addAll(headers);
      final response = await _http.send(request);
      final responseHeaders = {
        for (final e in response.headers.entries) e.key.toLowerCase(): e.value,
      };
      final location = responseHeaders['location'];
      if (_redirects.contains(response.statusCode) &&
          location != null &&
          hop < maxRedirects) {
        await response.stream.drain<void>();
        final target = Uri.parse(url).resolve(location);
        final sameOrigin = target.scheme == _origin.scheme &&
            target.host == _origin.host &&
            target.port == _origin.port;
        headers = Map.of(prepared.headers);
        if (!sameOrigin) {
          headers
            ..remove('X-API-Key')
            ..remove('If-None-Match');
        }
        url = target.toString();
        continue;
      }
      final body = await _readBounded(response);
      return _Raw(response.statusCode, responseHeaders, body);
    }
  }

  static Future<Uint8List> _readBounded(http.StreamedResponse response) async {
    final declared = response.contentLength;
    if (declared != null && declared > maxBodyBytes) {
      unawaited(response.stream.listen(null).cancel());
      throw ResponseTooLargeException(maxBodyBytes);
    }
    final builder = BytesBuilder(copy: false);
    await for (final chunk in response.stream) {
      builder.add(chunk);
      if (builder.length > maxBodyBytes) {
        throw ResponseTooLargeException(maxBodyBytes);
      }
    }
    return builder.takeBytes();
  }

  Future<Object> _handle<T extends Response>(
    _Call<T> call,
    _Prepared prepared,
    _Raw raw,
    int attempt,
  ) async {
    final status = raw.status;
    final headers = raw.headers;
    _rateLimit = RateLimit.fromHeaders(headers);
    _warnDeprecation(call.operation, headers);
    final cached = prepared.cached;
    if (status == 304 && cached != null) {
      final entry = await _revalidate(prepared, cached, headers);
      return _result(call, prepared, 304, entry.headers, entry.body,
          revalidated: true);
    }
    if (status >= 200 && status < 300) {
      await _store(prepared, headers, raw.body);
      return _result(call, prepared, status, headers, raw.body);
    }
    final error = _error(status, headers, raw.body);
    if (_retryStatuses.contains(status) && attempt <= maxRetries) {
      final wait =
          _retryAfterStatuses.contains(status) ? error.retryAfter : null;
      if (wait != null) {
        if (wait > _maxRetryAfter) throw error;
        return _Retry(wait);
      }
      return _Retry(_jitter(attempt));
    }
    throw error;
  }

  Duration _jitter(int attempt) {
    final cap = math.min(8.0, 0.5 * math.pow(2, attempt - 1));
    final seconds = _random() * cap;
    return Duration(microseconds: (seconds * 1e6).round());
  }

  void _warnDeprecation(String operation, Map<String, String> headers) {
    final deprecation = headers['deprecation'];
    final sunset = headers['sunset'];
    if (deprecation == null && sunset == null) return;
    if (!_warned.add(operation)) return;
    final link = _linkDeprecation.firstMatch(headers['link'] ?? '')?.group(1);
    _onDeprecation(DeprecationNotice(
      operation: operation,
      deprecation: deprecation,
      sunset: sunset,
      link: link,
    ));
  }

  Future<CacheEntry> _revalidate(
    _Prepared prepared,
    CacheEntry old,
    Map<String, String> headers,
  ) async {
    final merged = {...old.headers, ...headers};
    final entry = CacheEntry(
      body: old.body,
      etag: headers['etag'] ?? old.etag,
      headers: merged,
      storedAt: _clock(),
      maxAge: _maxAge(headers),
    );
    final store = cache;
    final key = prepared.cacheKey;
    if (store != null && key != null) {
      if (_cacheControl(headers).containsKey('no-store')) {
        await store.delete(key);
      } else {
        await store.set(key, entry);
      }
    }
    return entry;
  }

  Future<void> _store(
    _Prepared prepared,
    Map<String, String> headers,
    Uint8List body,
  ) async {
    final store = cache;
    final key = prepared.cacheKey;
    if (store == null || key == null) return;
    final etag = headers['etag'];
    final maxAge = _maxAge(headers);
    final noStore = _cacheControl(headers).containsKey('no-store');
    if (noStore ||
        (etag == null && (maxAge == null || maxAge == Duration.zero))) {
      await store.delete(key);
      return;
    }
    await store.set(
      key,
      CacheEntry(
        body: body,
        etag: etag,
        headers: headers,
        storedAt: _clock(),
        maxAge: maxAge,
      ),
    );
  }

  T _result<T extends Response>(
    _Call<T> call,
    _Prepared prepared,
    int status,
    Map<String, String> headers,
    Uint8List body, {
    bool revalidated = false,
    bool fromCache = false,
  }) {
    final T result;
    try {
      final data = jsonDecode(utf8.decode(body));
      if (data is! Map<String, Object?>) {
        throw const FormatException(r'$: expected an object');
      }
      final prepare = call.prepareJson;
      result = call.decode(prepare == null ? data : prepare(data));
    } on FormatException catch (e) {
      throw UnexpectedResponseException(
        '${call.operation}: the response is not a valid ${T.toString()} '
        '(${e.message})',
      );
    }
    attachMeta(
      result,
      ResponseMeta(
        status: status,
        url: prepared.url,
        headers: headers,
        requestId: headers['x-request-id'],
        rateLimit: RateLimit.fromHeaders(headers),
        etag: headers['etag'],
        revalidated: revalidated,
        fromCache: fromCache || revalidated,
      ),
    );
    call.finish?.call(result);
    return result;
  }

  ApiException _error(int status, Map<String, String> headers, Uint8List body) {
    String? code;
    var message = 'HTTP $status';
    final fields = <String, String>{};
    Object? data;
    try {
      data = jsonDecode(utf8.decode(body));
    } on FormatException {
      data = null;
    }
    if (data is Map<String, Object?> && data['error'] is String) {
      code = data['error']! as String;
      final text = data['message'];
      if (text is String) message = text;
      for (final e in data.entries) {
        final v = e.value;
        if (v is String) fields[e.key] = v;
      }
    } else if (body.isNotEmpty) {
      final end = math.min(200, body.length);
      final snippet =
          utf8.decode(body.sublist(0, end), allowMalformed: true).trim();
      if (snippet.isNotEmpty) message = 'HTTP $status: $snippet';
    }
    NearestLocation? nearest;
    if (data is Map<String, Object?>) {
      final raw = data['nearest_location'];
      if (raw is Map<String, Object?>) {
        try {
          nearest = NearestLocation.fromJson(raw);
        } on FormatException {
          nearest = null;
        }
      }
    }
    return apiException(
      _scrub(message),
      status: status,
      code: code,
      requestId: fields['request_id'] ?? headers['x-request-id'],
      docUrl: fields['doc_url'],
      param: fields['param'],
      retryAfter: parseRetryAfter(headers['retry-after'], _clock()),
      rateLimit: RateLimit.fromHeaders(headers),
      nearestLocation: nearest,
    );
  }

  String _scrub(String text) {
    final key = _apiKey;
    return key == null ? text : text.replaceAll(key, '[redacted]');
  }

  UnitSystem _unitsFor(UnitSystem? value) =>
      value == null ? units : _units(value);

  // --- forecasts ----------------------------------------------------------

  _Call<ForecastResponse> _forecastCall(
    String path,
    Query query, {
    required String operation,
    required UnitSystem? units,
    required List<Chance>? prob,
    required List<Total>? totals,
    required int? maxHours,
    required bool? includePast,
    required bool? models,
    required Members? members,
    required bool? daily,
    required int? maxDays,
    required bool? hourly,
    required DateTime? run,
    required List<String>? sources,
    required List<String>? excludeSources,
    required bool? nowcast,
    required List<String>? diagnostics,
    required List<String>? include,
    required List<String>? feelsLike,
  }) {
    final system = _unitsFor(units);
    query
      ..add('units', system, UnitSystem.metric)
      ..add('max_hours', maxHours, 24)
      ..add('include_past', includePast, false)
      ..add('models', models, false)
      ..add('members', members?.wire, 'false')
      ..add('daily', daily, true)
      ..add('max_days', maxDays)
      ..add('hourly', hourly, true)
      ..add('run', run)
      ..addList('sources', sources)
      ..addList('exclude_sources', excludeSources)
      ..add('nowcast', nowcast, true)
      ..addList('diagnostics', diagnostics)
      ..addList('include', include);
    if (feelsLike != null &&
        !(feelsLike.toSet().length == 1 && feelsLike.first == 'nws')) {
      query.addList('feels_like', feelsLike);
    }
    final chances = List<Chance>.of(prob ?? const []);
    final wanted = List<Total>.of(totals ?? const []);
    final (probWire, chanceTerms) = probQuery(chances, system);
    final (totalsWire, totalTerms) = totalsQuery(wanted);
    query
      ..addRaw('prob', probWire)
      ..addRaw('totals', totalsWire);

    // Results are matched to the caller's terms by the canonical `term` the
    // server echoes, never by position (BEHAVIOR.md 4, 5). A response without
    // answers leaves the list empty: nothing is invented.
    var answeredChances = false;
    var answeredTotals = false;
    Map<String, Object?> reorder(Map<String, Object?> json) {
      final out = Map<String, Object?>.of(json);
      List<Object?>? ordered(
          String field, List<String> terms, List<Object> asked) {
        final raw = json[field];
        if (terms.isEmpty || raw is! List || raw.isEmpty) return null;
        final byTerm = <String, Object?>{
          for (final item in raw)
            if (item is Map && item['term'] is String)
              item['term'] as String: item,
        };
        return [
          for (var i = 0; i < terms.length; i++)
            byTerm.containsKey(terms[i])
                ? byTerm[terms[i]]
                : throw UnexpectedResponseException(
                    '$operation: the response has no answer for ${asked[i]}',
                  ),
        ];
      }

      final p = ordered('probabilities', chanceTerms, chances);
      if (p != null) {
        out['probabilities'] = p;
        answeredChances = true;
      }
      final t = ordered('window_totals', totalTerms, wanted);
      if (t != null) {
        out['window_totals'] = t;
        answeredTotals = true;
      }
      return out;
    }

    void finish(Response response) {
      final result = response as ForecastResponse;
      if (answeredChances) {
        for (var i = 0; i < chances.length; i++) {
          bindChance(result.probabilities[i], chances[i]);
        }
      }
      if (answeredTotals) {
        for (var i = 0; i < wanted.length; i++) {
          bindTotal(result.windowTotals[i], wanted[i]);
        }
      }
    }

    final asked = chances.isNotEmpty || wanted.isNotEmpty;
    return _Call(
      operation,
      path,
      query.render(),
      ForecastResponse.fromJson,
      prepareJson: asked ? reorder : null,
      finish: asked ? finish : null,
    );
  }

  /// The forecast for a named location (`getLocationForecast`). Anonymous
  /// OK.
  ///
  /// * [location]: `'or/mt-hood-meadows'`, or the state code with [slug].
  /// * [prob]: probability terms ([Chance]), answered in
  ///   [ForecastResponse.probabilities] in this order.
  /// * [totals]: window totals ([Total]), answered in
  ///   [ForecastResponse.windowTotals] in this order.
  /// * [units]: this request's unit system (default: the client's).
  /// * [maxHours]: hours of hourly series (6-360, default 24).
  /// * [includePast]: start the hourly series at the run's init.
  /// * [models]: per-model breakdowns (Pro).
  /// * [members]: individual member values: [Members.all], or
  ///   [Members.plume] for the plume view (columns in `series.plume`).
  /// * [elevations]: `['all']` or names of the location's extra elevations.
  /// * [daily]: include the daily summaries (default true).
  /// * [maxDays]: the number of daily rows (default: the tier's horizon).
  /// * [hourly]: include the hourly series (default true).
  /// * [run]: a specific model init, for historical queries (Pro).
  /// * [sources] / [excludeSources]: observation sources the nowcast may or
  ///   must not use.
  /// * [nowcast]: blend in the latest observations (default true).
  /// * [diagnostics]: opt-in diagnostics: `provenance`.
  /// * [include]: opt-in variables: `skin_temperature`, `mslp`.
  /// * [feelsLike]: the feels-like index (`nws`, the default and only one).
  ///
  /// Throws a [NotFoundException] when the location does not exist, and a
  /// [UsageException] (nothing sent) for an invalid argument.
  Future<ForecastResponse> getForecast(
    String location, {
    String? slug,
    List<Chance>? prob,
    List<Total>? totals,
    UnitSystem? units,
    int? maxHours,
    bool? includePast,
    bool? models,
    Members? members,
    List<String>? elevations,
    bool? daily,
    int? maxDays,
    bool? hourly,
    DateTime? run,
    List<String>? sources,
    List<String>? excludeSources,
    bool? nowcast,
    List<String>? diagnostics,
    List<String>? include,
    List<String>? feelsLike,
  }) =>
      _defer(() {
        final query = Query()..addList('elevations', elevations);
        return _forecastCall(
          _locationPath(location, slug),
          query,
          operation: 'getLocationForecast',
          units: units,
          prob: prob,
          totals: totals,
          maxHours: maxHours,
          includePast: includePast,
          models: models,
          members: members,
          daily: daily,
          maxDays: maxDays,
          hourly: hourly,
          run: run,
          sources: sources,
          excludeSources: excludeSources,
          nowcast: nowcast,
          diagnostics: diagnostics,
          include: include,
          feelsLike: feelsLike,
        );
      });

  /// The forecast at coordinates (`getPointForecast`). Needs a Pro key.
  ///
  /// [elevationM] forecasts at that elevation instead of the terrain's.
  /// Coordinates are sent exactly as given. The other arguments are as for
  /// [getForecast].
  ///
  /// Throws a [PermissionDeniedException] when the key is not Pro
  /// (`PRO_REQUIRED`), and an [OutsideCoverageException] when the point is
  /// outside the forecast domain.
  Future<ForecastResponse> getPointForecast(
    double lat,
    double lon, {
    double? elevationM,
    List<Chance>? prob,
    List<Total>? totals,
    UnitSystem? units,
    int? maxHours,
    bool? includePast,
    bool? models,
    Members? members,
    bool? daily,
    int? maxDays,
    bool? hourly,
    DateTime? run,
    List<String>? sources,
    List<String>? excludeSources,
    bool? nowcast,
    List<String>? diagnostics,
    List<String>? include,
    List<String>? feelsLike,
  }) =>
      _defer(() {
        final query = _coordinates(lat, lon)..add('elevation_m', elevationM);
        return _forecastCall(
          '/api/v1/forecast',
          query,
          operation: 'getPointForecast',
          units: units,
          prob: prob,
          totals: totals,
          maxHours: maxHours,
          includePast: includePast,
          models: models,
          members: members,
          daily: daily,
          maxDays: maxDays,
          hourly: hourly,
          run: run,
          sources: sources,
          excludeSources: excludeSources,
          nowcast: nowcast,
          diagnostics: diagnostics,
          include: include,
          feelsLike: feelsLike,
        );
      });

  // --- current conditions and alerts --------------------------------------

  _Call<CurrentResponse> _currentCall(
    String path,
    Query query,
    String operation, {
    required UnitSystem? units,
    required List<String>? sources,
    required List<String>? excludeSources,
    required bool includeNowcastHours,
  }) {
    query
      ..add('units', _unitsFor(units), UnitSystem.metric)
      ..addList('sources', sources)
      ..addList('exclude_sources', excludeSources);
    if (includeNowcastHours) query.add('include', 'nowcast_hours');
    return _Call(operation, path, query.render(), CurrentResponse.fromJson);
  }

  /// Current conditions at a named location (`getCurrentConditions`). A
  /// mountain pass also gets `pass`.
  Future<CurrentResponse> getCurrent(
    String location, {
    String? slug,
    UnitSystem? units,
    List<String>? sources,
    List<String>? excludeSources,
    bool includeNowcastHours = false,
  }) =>
      _defer(() => _currentCall(
            '${_locationPath(location, slug)}/current',
            Query(),
            'getCurrentConditions',
            units: units,
            sources: sources,
            excludeSources: excludeSources,
            includeNowcastHours: includeNowcastHours,
          ));

  /// Current conditions at coordinates (`getCurrentByCoordinates`). Pro.
  Future<CurrentResponse> getPointCurrent(
    double lat,
    double lon, {
    double? elevationM,
    UnitSystem? units,
    List<String>? sources,
    List<String>? excludeSources,
    bool includeNowcastHours = false,
  }) =>
      _defer(() => _currentCall(
            '/api/v1/current',
            _coordinates(lat, lon)..add('elevation_m', elevationM),
            'getCurrentByCoordinates',
            units: units,
            sources: sources,
            excludeSources: excludeSources,
            includeNowcastHours: includeNowcastHours,
          ));

  /// Active alerts at a named location (`getLocationAlerts`).
  Future<AlertsResponse> getAlerts(String location, {String? slug}) =>
      _defer(() => _Call(
          'getLocationAlerts',
          '${_locationPath(location, slug)}/alerts',
          '',
          AlertsResponse.fromJson));

  /// Active alerts at coordinates (`getAlertsByCoordinates`). Pro.
  Future<AlertsResponse> getPointAlerts(double lat, double lon) =>
      _defer(() => _Call('getAlertsByCoordinates', '/api/v1/alerts',
          _coordinates(lat, lon).render(), AlertsResponse.fromJson));

  // --- places --------------------------------------------------------------

  /// Locations near a named location (`getNearbyLocations`).
  Future<NearbyLocationsResponse> getNearby(
    String location, {
    String? slug,
    int? limit,
    double? radiusKm,
    UnitSystem? units,
  }) =>
      _defer(() {
        final query = Query()
          ..add('limit', limit, 3)
          ..add('radius_km', radiusKm, 50)
          ..add('units', _unitsFor(units), UnitSystem.metric);
        return _Call(
            'getNearbyLocations',
            '${_locationPath(location, slug)}/nearby',
            query.render(),
            NearbyLocationsResponse.fromJson);
      });

  /// Locations near coordinates (`getNearbyByCoordinates`).
  Future<NearbyPointResponse> getPointNearby(
    double lat,
    double lon, {
    int? limit,
    double? radiusKm,
    UnitSystem? units,
  }) =>
      _defer(() {
        final query = _coordinates(lat, lon)
          ..add('limit', limit, 3)
          ..add('radius_km', radiusKm, 50)
          ..add('units', _unitsFor(units), UnitSystem.metric);
        return _Call('getNearbyByCoordinates', '/api/v1/nearby', query.render(),
            NearbyPointResponse.fromJson);
      });

  /// Searches locations by name (`searchLocations`). Sent without the key.
  ///
  /// * [q]: the query (at least 2 characters).
  /// * [state], [county], [type]: only hits in this state or county, or of
  ///   this type.
  /// * [limit]: the number of hits (default 20).
  /// * [sort]: an [ExploreMetric] to rank by; with one, each hit carries
  ///   `explore`. `null` (the default) is relevance.
  /// * [order]: for a metric sort (default [SortOrder.desc]).
  /// * [near]: only hits within [radiusKm] (default 100) of this point.
  /// * [units]: the units of `explore` values (default: the client's).
  Future<SearchLocationsResponse> searchLocations(
    String q, {
    String? state,
    String? county,
    LocationType? type,
    int? limit,
    ExploreMetric? sort,
    SortOrder? order,
    LatLon? near,
    double? radiusKm,
    UnitSystem? units,
  }) =>
      _defer(() {
        if (q.trim().length < 2) {
          throw UsageException('a search needs at least 2 characters');
        }
        final query = Query()
          ..add('q', q)
          ..add('state', state == null ? null : _state(state))
          ..add('county', county)
          ..add('type', type)
          ..add('limit', limit, 20)
          ..add('sort', sort, 'relevance')
          ..add('order', order?.name, 'desc')
          ..addRaw('near', _near(near))
          ..add('radius_km', radiusKm, 100)
          ..add('units', _unitsFor(units), UnitSystem.metric);
        return _Call('searchLocations', '/api/v1/search/locations',
            query.render(), SearchLocationsResponse.fromJson,
            openRoute: true);
      });

  _Call<LocationsResponse> _locationsCall(
    String? state, {
    required LocationType? type,
    required UnitSystem? units,
    required int? limit,
    required String? cursor,
  }) {
    final query = Query()
      ..add('type', type)
      ..add('units', _unitsFor(units), UnitSystem.metric)
      ..add('limit', limit)
      ..add('cursor', cursor);
    if (state == null) {
      return _Call('getAllLocations', '/api/v1/locations', query.render(),
          LocationsResponse.fromJson);
    }
    return _Call(
        'getLocations',
        '/api/v1/locations/${encodeComponent(_state(state))}',
        query.render(),
        LocationsResponse.fromJson);
  }

  /// One page of locations, in one [state] or all (`getLocations` /
  /// `getAllLocations`).
  ///
  /// Pass the page's `nextCursor` back as [cursor] for the next page, or use
  /// [iterateLocations].
  Future<LocationsResponse> listLocations({
    String? state,
    LocationType? type,
    UnitSystem? units,
    int? limit,
    String? cursor,
  }) =>
      _defer(() => _locationsCall(state,
          type: type, units: units, limit: limit, cursor: cursor));

  /// Every location, fetching pages lazily as the stream is listened to.
  Stream<LocationSummary> iterateLocations({
    String? state,
    LocationType? type,
    UnitSystem? units,
    int? limit,
  }) =>
      _pages(
        (cursor) => listLocations(
            state: state,
            type: type,
            units: units,
            limit: limit,
            cursor: cursor),
        (page) => (page.items, page.nextCursor),
      );

  // --- catalog -------------------------------------------------------------

  /// One page of the location catalog (`listCatalogLocations`).
  ///
  /// Keyed callers keep their own budget here, so the key is sent.
  Future<PublicCatalogLocationPage> listCatalogLocations({
    String? admin1,
    String? country,
    LocationType? type,
    TemplateVariant? template,
    int? limit,
    String? cursor,
  }) =>
      _defer(() {
        final query = Query()
          ..add('admin1', admin1)
          ..add('country', country)
          ..add('type', type)
          ..add('template', template)
          ..add('limit', limit, 20)
          ..add('cursor', cursor);
        return _Call('listCatalogLocations', '/api/v1/catalog/locations',
            query.render(), PublicCatalogLocationPage.fromJson);
      });

  /// Every catalog location, following `nextCursor` lazily.
  Stream<PublicCatalogLocation> iterateCatalogLocations({
    String? admin1,
    String? country,
    LocationType? type,
    TemplateVariant? template,
    int? limit,
  }) =>
      _pages(
        (cursor) => listCatalogLocations(
          admin1: admin1,
          country: country,
          type: type,
          template: template,
          limit: limit,
          cursor: cursor,
        ),
        (page) => (page.items, page.nextCursor),
      );

  /// One catalog location (`getCatalogLocation`). Sent without the key.
  Future<PublicCatalogLocationDetail> getCatalogLocation(
    String slug, {
    List<String>? include,
    String? locale,
  }) =>
      _defer(() {
        final query = Query()
          ..addList('include', include)
          ..add('locale', locale, 'en');
        return _Call(
            'getCatalogLocation',
            '/api/v1/catalog/locations/${encodeComponent(_nonEmpty('slug', slug))}',
            query.render(),
            PublicCatalogLocationDetail.fromJson,
            openRoute: true);
      });

  /// One page of the station catalog (`listCatalogStations`).
  ///
  /// [capabilities] are all required (sent as one `capability` list).
  Future<PublicCatalogStationPage> listCatalogStations({
    String? admin1,
    String? country,
    List<StationNetwork>? network,
    List<String>? capabilities,
    StationStatus? status,
    int? limit,
    String? cursor,
  }) =>
      _defer(() {
        final query = Query()
          ..add('admin1', admin1)
          ..add('country', country)
          ..addList('network', network?.map((n) => n.value))
          ..addList('capability', capabilities)
          ..add('status', status)
          ..add('limit', limit, 20)
          ..add('cursor', cursor);
        return _Call('listCatalogStations', '/api/v1/catalog/stations',
            query.render(), PublicCatalogStationPage.fromJson);
      });

  /// Every catalog station, following `nextCursor` lazily.
  Stream<PublicCatalogStation> iterateCatalogStations({
    String? admin1,
    String? country,
    List<StationNetwork>? network,
    List<String>? capabilities,
    StationStatus? status,
    int? limit,
  }) =>
      _pages(
        (cursor) => listCatalogStations(
          admin1: admin1,
          country: country,
          network: network,
          capabilities: capabilities,
          status: status,
          limit: limit,
          cursor: cursor,
        ),
        (page) => (page.items, page.nextCursor),
      );

  /// One catalog station (`getCatalogStation`). Sent without the key.
  Future<PublicCatalogStationDetail> getCatalogStation(
    String slug, {
    List<String>? include,
    String? locale,
  }) =>
      _defer(() {
        final query = Query()
          ..addList('include', include)
          ..add('locale', locale, 'en');
        return _Call(
            'getCatalogStation',
            '/api/v1/catalog/stations/${encodeComponent(_nonEmpty('slug', slug))}',
            query.render(),
            PublicCatalogStationDetail.fromJson,
            openRoute: true);
      });

  // --- runs, explore, season, snow trend and snowpack -----------------------

  /// The served model run and recent runs (`getAvailableRuns`).
  ///
  /// Pass the page's `nextCursor` back as [cursor] for the next page, or use
  /// [iterateRuns].
  Future<RunsResponse> getRuns({int? limit, String? cursor}) => _defer(() {
        final query = Query()
          ..add('limit', limit, 10)
          ..add('cursor', cursor);
        return _Call('getAvailableRuns', '/api/v1/runs', query.render(),
            RunsResponse.fromJson);
      });

  /// Every recent run, following `nextCursor` lazily.
  Stream<RunEntry> iterateRuns({int? limit}) => _pages(
        (cursor) => getRuns(limit: limit, cursor: cursor),
        (page) => (page.items, page.nextCursor),
      );

  /// One page of places ranked by a [metric] (`explore`).
  ///
  /// * [metric]: what to rank by, for example [ExploreMetric.snow5d] or
  ///   [ExploreMetric.baseDepth].
  /// * [order]: [SortOrder.desc] (default, the most first) or
  ///   [SortOrder.asc].
  /// * [type]: only places of this type.
  /// * [state]: only places in this state (code or name).
  /// * [near]: only places within [radiusKm] (default 100, at most 1000) of
  ///   this point.
  /// * [elevationMin] / [elevationMax]: point elevation bounds, in the
  ///   response's height unit.
  /// * [points]: [ExplorePoints.primary] (default, each place's own point)
  ///   or [ExplorePoints.all] (each named elevation too).
  /// * [limit]: rows per page (1-100, default 25).
  /// * [cursor]: a previous page's `nextCursor`; or use [iterateExplore].
  /// * [units]: this request's unit system (default: the client's).
  Future<ExploreResponse> explore(
    ExploreMetric metric, {
    SortOrder? order,
    LocationType? type,
    String? state,
    LatLon? near,
    double? radiusKm,
    double? elevationMin,
    double? elevationMax,
    ExplorePoints? points,
    int? limit,
    String? cursor,
    UnitSystem? units,
  }) =>
      _defer(() {
        final query = Query()
          ..add('metric', _nonEmpty('metric', metric.value))
          ..add('order', order?.name, 'desc')
          ..add('type', type)
          ..add('state', state == null ? null : _state(state))
          ..addRaw('near', _near(near))
          ..add('radius_km', radiusKm, 100)
          ..add('elevation_min', elevationMin)
          ..add('elevation_max', elevationMax)
          ..add('points', points?.name, 'primary')
          ..add('limit', limit, 25)
          ..add('cursor', cursor)
          ..add('units', _unitsFor(units), UnitSystem.metric);
        return _Call('explore', '/api/v1/explore', query.render(),
            ExploreResponse.fromJson);
      });

  /// Every ranked place, following `nextCursor` lazily (see [explore]).
  Stream<ExploreItem> iterateExplore(
    ExploreMetric metric, {
    SortOrder? order,
    LocationType? type,
    String? state,
    LatLon? near,
    double? radiusKm,
    double? elevationMin,
    double? elevationMax,
    ExplorePoints? points,
    int? limit,
    UnitSystem? units,
  }) =>
      _pages(
        (cursor) => explore(
          metric,
          order: order,
          type: type,
          state: state,
          near: near,
          radiusKm: radiusKm,
          elevationMin: elevationMin,
          elevationMax: elevationMax,
          points: points,
          limit: limit,
          cursor: cursor,
          units: units,
        ),
        (page) => (page.items, page.nextCursor),
      );

  /// Observed season-to-date precipitation and snowfall
  /// (`getLocationSeason`).
  ///
  /// [waterYear] is the water year (October to September) named by the year
  /// it ends in (default: the current one); [includeDaily] also returns the
  /// day-by-day record.
  Future<SeasonResponse> getSeason(
    String location, {
    String? slug,
    int? waterYear,
    bool includeDaily = false,
    UnitSystem? units,
  }) =>
      _defer(() {
        final query = Query()..add('water_year', waterYear);
        if (includeDaily) query.addList('include', const ['daily']);
        query.add('units', _unitsFor(units), UnitSystem.metric);
        return _Call(
            'getLocationSeason',
            '${_locationPath(location, slug)}/season',
            query.render(),
            SeasonResponse.fromJson);
      });

  /// Each recent run's daily snowfall, as a grid (`getLocationSnowTrend`).
  /// Plus or Pro.
  ///
  /// Read down a column to see a storm firm up or fade as the runs come in.
  /// With a Pro key the body also carries one grid per model. Anonymous and
  /// Free callers get a [PermissionDeniedException] (`PLUS_REQUIRED`).
  /// [elevation] is one of the location's named elevations (default: its
  /// primary).
  Future<SnowTrendResponse> getSnowTrend(
    String location, {
    String? slug,
    String? elevation,
    UnitSystem? units,
  }) =>
      _defer(() {
        final query = Query()
          ..add('elevation', elevation)
          ..add('units', _unitsFor(units), UnitSystem.metric);
        return _Call(
            'getLocationSnowTrend',
            '${_locationPath(location, slug)}/snow-trend',
            query.render(),
            SnowTrendResponse.fromJson);
      });

  /// The snowpack forecast of a location's spots (`getLocationSnowpack`,
  /// beta).
  Future<SnowpackResponse> getSnowpack(
    String location, {
    String? slug,
    UnitSystem? units,
  }) =>
      _defer(() {
        final query = Query()
          ..add('units', _unitsFor(units), UnitSystem.metric);
        return _Call(
            'getLocationSnowpack',
            '${_locationPath(location, slug)}/snowpack',
            query.render(),
            SnowpackResponse.fromJson);
      });

  /// The snow-depth plume of a location (`getLocationSnowpackPlume`, beta).
  Future<SnowpackPlumeResponse> getSnowpackPlume(
    String location, {
    String? slug,
    UnitSystem? units,
  }) =>
      _defer(() {
        final query = Query()
          ..add('units', _unitsFor(units), UnitSystem.metric);
        return _Call(
            'getLocationSnowpackPlume',
            '${_locationPath(location, slug)}/snowpack/plume',
            query.render(),
            SnowpackPlumeResponse.fromJson);
      });

  // --- map layers, composition and attribution -----------------------------

  /// The active winter and wind alerts' outlines, as GeoJSON
  /// (`getAlertOutlines`).
  ///
  /// [classes] limits the classes (default: every class); [bbox] keeps only
  /// alerts whose bounding box touches it. Features are served whole, not
  /// clipped, and their keys are the API's own.
  Future<AlertOutlineCollection> getAlertOutlines({
    List<AlertClass>? classes,
    BBox? bbox,
  }) =>
      _defer(() {
        final query = Query()
          ..addList('class', classes?.map((c) => c.value))
          ..addRaw('bbox', _bbox(bbox));
        return _Call('getAlertOutlines', '/api/v1/alerts/outlines',
            query.render(), AlertOutlineCollection.fromJson);
      });

  /// Every avalanche center's forecast zones with today's rating, as GeoJSON
  /// (`getAvalancheZones`).
  Future<AvalancheZoneCollection> getAvalancheZones() => _defer(() => _Call(
      'getAvalancheZones',
      '/api/v1/avalanche/zones',
      '',
      AvalancheZoneCollection.fromJson));

  /// The blend's served models and members (`getComposition`). Sent without
  /// the key.
  Future<CompositionResponse> getComposition() => _defer(() => _Call(
      'getComposition', '/api/v1/composition', '', CompositionResponse.fromJson,
      openRoute: true));

  /// Every data provider and its licence (`getAttribution`). Sent without
  /// the key.
  Future<AttributionRegistry> getAttribution() => _defer(() => _Call(
      'getAttribution', '/api/v1/attribution', '', AttributionRegistry.fromJson,
      openRoute: true));

  // --- helpers ---------------------------------------------------------------

  /// Builds the call (a [UsageException] surfaces as the future's error, not
  /// synchronously), then runs it.
  Future<T> _defer<T extends Response>(_Call<T> Function() build) =>
      Future.sync(() => _run(build()));

  Stream<I> _pages<P, I>(
    Future<P> Function(String? cursor) fetch,
    (List<I>, String?) Function(P page) parts,
  ) async* {
    String? cursor;
    while (true) {
      final (items, next) = parts(await fetch(cursor));
      for (final item in items) {
        yield item;
      }
      if (next == null || next.isEmpty) return;
      cursor = next;
    }
  }
}

/// Test hooks (SDK-internal): a fake sleep, random source and clock.
void configureClientForTesting(
  OureaClient client, {
  Future<void> Function(Duration delay)? sleep,
  double Function()? random,
  DateTime Function()? clock,
}) {
  if (sleep != null) client._sleep = sleep;
  if (random != null) client._random = random;
  if (clock != null) client._clock = clock;
}

/// Forgets which operations already reported a deprecation (for tests).
void resetDeprecationNotices() => _warned.clear();

// --- argument helpers --------------------------------------------------------

UnitSystem _units(UnitSystem value) {
  if (value.isUnknown) {
    throw UsageException(
      'units must be metric, imperial or kelvin, not "${value.value}"',
    );
  }
  return value;
}

String _nonEmpty(String what, String value) {
  if (value.isEmpty) throw UsageException('$what must be a non-empty string');
  return value;
}

final RegExp _usps = RegExp(r'^[A-Za-z]{2}$');

/// Lowercases a two-letter USPS code; passes anything else through.
String _state(String state) {
  _nonEmpty('state', state);
  return _usps.hasMatch(state) ? state.toLowerCase() : state;
}

String _locationPath(String location, String? slug) {
  final String state;
  final String name;
  if (slug != null) {
    state = location;
    name = slug;
  } else {
    final parts = location.split('/');
    if (parts.length != 2) {
      throw UsageException(
        "a location is 'state/slug' (for example 'or/mt-hood-meadows'), "
        "got '$location'",
      );
    }
    state = parts[0];
    name = parts[1];
  }
  return '/api/v1/locations/${encodeComponent(_state(state))}/'
      '${encodeComponent(_nonEmpty('slug', name))}';
}

String _degrees(String name, double value, double bound) {
  if (!value.isFinite || value < -bound || value > bound) {
    throw UsageException('$name must be within +/-${formatNumber(bound)}, '
        'got $value');
  }
  return formatNumber(value);
}

Query _coordinates(double lat, double lon) {
  _degrees('lat', lat, 90);
  _degrees('lon', lon, 180);
  return Query()
    ..add('lat', lat)
    ..add('lon', lon);
}

/// `lat,lon` with a literal comma (BEHAVIOR.md 3), or `''` when unset.
String _near(LatLon? near) {
  if (near == null) return '';
  return '${_degrees('near lat', near.lat, 90)},'
      '${_degrees('near lon', near.lon, 180)}';
}

/// `west,south,east,north` with literal commas, or `''` when unset.
String _bbox(BBox? bbox) {
  if (bbox == null) return '';
  if (bbox.west > bbox.east || bbox.south > bbox.north) {
    throw UsageException(
      'a bbox is (west, south, east, north), west <= east and south <= north',
    );
  }
  return [
    _degrees('west', bbox.west, 180),
    _degrees('south', bbox.south, 90),
    _degrees('east', bbox.east, 180),
    _degrees('north', bbox.north, 90),
  ].join(',');
}

Map<String, String?> _cacheControl(Map<String, String> headers) {
  final out = <String, String?>{};
  for (final part in (headers['cache-control'] ?? '').split(',')) {
    final text = part.trim();
    if (text.isEmpty) continue;
    final eq = text.indexOf('=');
    final name = (eq < 0 ? text : text.substring(0, eq)).toLowerCase();
    final value = eq < 0 ? null : text.substring(eq + 1).replaceAll('"', '');
    out[name] = value;
  }
  return out;
}

final RegExp _digits = RegExp(r'^\d+$');

Duration? _maxAge(Map<String, String> headers) {
  final directives = _cacheControl(headers);
  if (directives.containsKey('no-cache')) return Duration.zero;
  final raw = directives['max-age'];
  if (raw == null || !_digits.hasMatch(raw)) return null;
  return Duration(seconds: int.parse(raw));
}

const List<String> _months = [
  'jan', 'feb', 'mar', 'apr', 'may', 'jun', //
  'jul', 'aug', 'sep', 'oct', 'nov', 'dec',
];

final RegExp _httpDate = RegExp(
  r'^[A-Za-z]{3},\s*(\d{1,2})\s+([A-Za-z]{3})\s+(\d{4})\s+(\d{2}):(\d{2}):(\d{2})\s+GMT$',
);

/// How long to wait from a `Retry-After` header (delta-seconds or an
/// HTTP-date), or `null` (SDK-internal).
Duration? parseRetryAfter(String? value, DateTime now) {
  if (value == null) return null;
  final text = value.trim();
  if (_digits.hasMatch(text)) return Duration(seconds: int.parse(text));
  final match = _httpDate.firstMatch(text);
  if (match == null) return null;
  final month = _months.indexOf(match.group(2)!.toLowerCase());
  if (month < 0) return null;
  final when = DateTime.utc(
    int.parse(match.group(3)!),
    month + 1,
    int.parse(match.group(1)!),
    int.parse(match.group(4)!),
    int.parse(match.group(5)!),
    int.parse(match.group(6)!),
  );
  final wait = when.difference(now);
  return wait.isNegative ? Duration.zero : wait;
}
