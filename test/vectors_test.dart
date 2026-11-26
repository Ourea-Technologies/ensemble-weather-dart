// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

// Runs every shared vector in spec/vectors/ (BEHAVIOR.md section 13) against
// a package:http MockClient that replays the vector's responses and records
// the requests. A vector this runner cannot execute fails; nothing is
// skipped.
//
// The only per-language code is `_invoke`, which maps a vector's semantic
// operation and arguments onto this SDK's methods.

import 'dart:convert';
import 'dart:io';

import 'package:ensemble_weather/ensemble_weather.dart';
import 'package:ensemble_weather/src/client.dart'
    show configureClientForTesting, resetDeprecationNotices;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

import 'support/fields.dart';
import 'support/paths.dart';

const int expectedVectorCount = 58;

final Directory vectors = Directory(specPath('vectors'));

List<File> _cases() {
  final files = vectors
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .where((f) => !f.path
          .contains('${Platform.pathSeparator}bodies${Platform.pathSeparator}'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  return files;
}

String _name(File file) {
  final rel = file.path.substring(vectors.path.length + 1);
  return rel.substring(0, rel.length - '.json'.length);
}

// --- the mock transport --------------------------------------------------------

final class _Replay {
  _Replay(List<Object?> responses) : _responses = List.of(responses);

  final List<Object?> _responses;
  final List<http.Request> requests = [];

  Future<http.Response> call(http.Request request) async {
    requests.add(request);
    if (_responses.isEmpty) {
      throw StateError(
          'unexpected request #${requests.length}: ${request.url}');
    }
    final spec = _responses.removeAt(0)! as Map<String, Object?>;
    final List<int> body;
    if (spec['body_file'] case final String file) {
      body = File('${vectors.path}/$file').readAsBytesSync();
    } else {
      body = utf8.encode((spec['body'] as String?) ?? '');
    }
    final headers = <String, String>{
      for (final e
          in ((spec['headers'] as Map<String, Object?>?) ?? {}).entries)
        e.key.toLowerCase(): e.value! as String,
    };
    return http.Response.bytes(body, spec['status']! as int,
        headers: headers, request: request);
  }
}

// --- mapping a vector call onto the SDK (the per-language part) ------------------

Window _window(Object? spec) {
  if (spec == null) return Window(0, 24);
  final w = spec as Map<String, Object?>;
  if (w['hours'] case final int hours) return Window.hours(hours);
  return Window(w['start_hours']! as int, w['end_hours']! as int);
}

Chance _chance(Map<String, Object?> term) {
  final threshold = term['threshold']! as Map<String, Object?>;
  final unit = threshold['unit'] as String?;
  final aggregation = term['aggregation'] as String?;
  return Chance(
    Variable(term['variable']! as String),
    Op(term['op']! as String),
    threshold['value']! as num,
    unit: unit == null ? null : Unit(unit),
    window: _window(term['window']),
    aggregation: aggregation == null ? null : Aggregation(aggregation),
  );
}

List<String>? _strings(Object? value) => switch (value) {
      null => null,
      final String s => [s],
      final List<Object?> l => [for (final x in l) x! as String],
      _ => throw ArgumentError('not a string list: $value'),
    };

double? _number(Object? value) => (value as num?)?.toDouble();

UnitSystem? _units(Object? value) =>
    value == null ? null : UnitSystem(value as String);

LatLon? _near(Object? value) {
  if (value == null) return null;
  final m = value as Map<String, Object?>;
  return (
    lat: (m['lat']! as num).toDouble(),
    lon: (m['lon']! as num).toDouble()
  );
}

Members? _members(Object? value) => switch (value) {
      null => null,
      true => Members.all,
      false => Members.none,
      'plume' => Members.plume,
      _ => throw ArgumentError('members: $value'),
    };

SortOrder? _order(Object? value) => switch (value) {
      null => null,
      'asc' => SortOrder.asc,
      'desc' => SortOrder.desc,
      _ => throw ArgumentError('order: $value'),
    };

/// Runs one vector call; returns the result (a list when iterating).
Future<Object?> _invoke(OureaClient client, Map<String, Object?> call) async {
  final op = call['operation']! as String;
  final a =
      Map<String, Object?>.of((call['args'] as Map<String, Object?>?) ?? {});
  final iterate = a.remove('iterate') == true;
  final location = a['location'] as String? ?? a['state'] as String?;
  final slug = a['location'] == null ? a['slug'] as String? : null;
  Object? used(String key) => a[key];

  switch (op) {
    case 'getLocationForecast' || 'getPointForecast':
      final prob = (used('prob') as List<Object?>?)
          ?.map((t) => _chance(t! as Map<String, Object?>))
          .toList();
      final totals = (used('totals') as List<Object?>?)
          ?.map((t) => t! as Map<String, Object?>)
          .map((t) => Total(TotalVariable(t['variable']! as String),
              window: _window(t['window'])))
          .toList();
      if (op == 'getPointForecast') {
        return client.getPointForecast(
          _number(a['lat'])!,
          _number(a['lon'])!,
          elevationM: _number(a['elevation_m']),
          prob: prob,
          totals: totals,
          units: _units(a['units']),
          maxHours: a['max_hours'] as int?,
          includePast: a['include_past'] as bool?,
          models: a['models'] as bool?,
          members: _members(a['members']),
          daily: a['daily'] as bool?,
          hourly: a['hourly'] as bool?,
          sources: _strings(a['sources']),
          excludeSources: _strings(a['exclude_sources']),
          nowcast: a['nowcast'] as bool?,
          include: _strings(a['include']),
        );
      }
      return client.getForecast(
        location!,
        slug: slug,
        prob: prob,
        totals: totals,
        units: _units(a['units']),
        maxHours: a['max_hours'] as int?,
        includePast: a['include_past'] as bool?,
        models: a['models'] as bool?,
        members: _members(a['members']),
        elevations: _strings(a['elevations']),
        daily: a['daily'] as bool?,
        hourly: a['hourly'] as bool?,
        sources: _strings(a['sources']),
        excludeSources: _strings(a['exclude_sources']),
        nowcast: a['nowcast'] as bool?,
        include: _strings(a['include']),
      );
    case 'getCurrentConditions':
      return client.getCurrent(location!,
          slug: slug, units: _units(a['units']));
    case 'getCurrentByCoordinates':
      return client.getPointCurrent(_number(a['lat'])!, _number(a['lon'])!);
    case 'getLocationAlerts':
      return client.getAlerts(location!, slug: slug);
    case 'getAlertsByCoordinates':
      return client.getPointAlerts(_number(a['lat'])!, _number(a['lon'])!);
    case 'getNearbyLocations':
      return client.getNearby(location!, slug: slug);
    case 'getNearbyByCoordinates':
      return client.getPointNearby(_number(a['lat'])!, _number(a['lon'])!);
    case 'searchLocations':
      final sort = a['sort'] as String?;
      return client.searchLocations(
        a['q']! as String,
        state: a['state'] as String?,
        sort: sort == null || sort == 'relevance' ? null : ExploreMetric(sort),
        order: _order(a['order']),
        near: _near(a['near']),
        radiusKm: _number(a['radius_km']),
        units: _units(a['units']),
      );
    case 'getAllLocations' || 'getLocations':
      return client.listLocations(
          state: a['state'] as String?, limit: a['limit'] as int?);
    case 'listCatalogLocations':
      if (iterate) return client.iterateCatalogLocations().toList();
      return client.listCatalogLocations(limit: a['limit'] as int?);
    case 'getCatalogLocation':
      return client.getCatalogLocation(a['slug']! as String,
          include: _strings(a['include']));
    case 'listCatalogStations':
      if (iterate) return client.iterateCatalogStations().toList();
      return client.listCatalogStations();
    case 'getCatalogStation':
      return client.getCatalogStation(a['slug']! as String);
    case 'getAvailableRuns':
      return client.getRuns(limit: a['limit'] as int?);
    case 'getAttribution':
      return client.getAttribution();
    case 'explore':
      final type = a['type'] as String?;
      final points = a['points'] as String?;
      return client.explore(
        ExploreMetric(a['metric']! as String),
        order: _order(a['order']),
        type: type == null ? null : LocationType(type),
        state: a['state'] as String?,
        near: _near(a['near']),
        radiusKm: _number(a['radius_km']),
        elevationMin: _number(a['elevation_min']),
        elevationMax: _number(a['elevation_max']),
        points: points == null ? null : ExplorePoints.values.byName(points),
        limit: a['limit'] as int?,
        cursor: a['cursor'] as String?,
        units: _units(a['units']),
      );
    case 'getComposition':
      return client.getComposition();
    case 'getLocationSeason':
      return client.getSeason(
        location!,
        slug: slug,
        waterYear: a['water_year'] as int?,
        includeDaily: _strings(a['include'])?.contains('daily') ?? false,
        units: _units(a['units']),
      );
    case 'getLocationSnowTrend':
      return client.getSnowTrend(location!,
          slug: slug,
          elevation: a['elevation'] as String?,
          units: _units(a['units']));
    case 'getLocationSnowpack':
      return client.getSnowpack(location!, slug: slug);
    case 'getLocationSnowpackPlume':
      return client.getSnowpackPlume(location!, slug: slug);
    case 'getAlertOutlines':
      final box = a['bbox'] as Map<String, Object?>?;
      return client.getAlertOutlines(
        classes: _strings(a['classes'])?.map(AlertClass.new).toList(),
        bbox: box == null
            ? null
            : (
                west: _number(box['west'])!,
                south: _number(box['south'])!,
                east: _number(box['east'])!,
                north: _number(box['north'])!,
              ),
      );
    case 'getAvalancheZones':
      return client.getAvalancheZones();
  }
  throw StateError('the runner has no mapping for $op');
}

// --- checking ---------------------------------------------------------------------

final RegExp _token = RegExp(r'([^.\[\]]+)|\[(\d+)\]');

Object? _resolve(Object? result, String path) {
  var value = result;
  var first = true;
  for (final m in _token.allMatches(path)) {
    if (value == null) return null;
    final name = m.group(1);
    final index = m.group(2);
    if (index != null) {
      value = (value as List<Object?>)[int.parse(index)];
    } else if (first && name == 'revalidated') {
      value = (value as Response).meta.revalidated;
    } else if (first && name == 'rate_limit') {
      value = (value as Response).meta.rateLimit;
    } else if (value is RateLimit) {
      value = switch (name) {
        'limit' => value.limit,
        'remaining' => value.remaining,
        'reset' => value.reset,
        'policy' => value.policy,
        _ => throw ArgumentError(name),
      };
    } else {
      value = readField(value, name!);
    }
    first = false;
  }
  return value;
}

void _checkValue(String path, Object? actual, Object? expected) {
  if (expected is Map &&
      expected.keys.toSet().containsAll(['unknown']) &&
      expected.length == 1) {
    expect(actual, isA<OpenEnum>(), reason: path);
    final e = actual! as OpenEnum;
    expect(e.isUnknown, isTrue, reason: '$path: $actual is not unknown');
    expect(e.value, expected['unknown'], reason: path);
  } else if (expected == null) {
    expect(actual, isNull, reason: '$path: expected absent');
  } else if (expected is bool) {
    expect(actual, expected, reason: path);
  } else if (expected is num) {
    expect(actual, isA<num>(), reason: '$path: $actual is not a number');
    expect((actual! as num).toDouble(),
        closeTo(expected.toDouble(), expected.abs() * 1e-12),
        reason: path);
  } else if (actual is DateTime && expected is String) {
    // BEHAVIOR.md 13: a timestamp matches the expected string as an instant.
    expect(actual.isAtSameMomentAs(DateTime.parse(expected)), isTrue,
        reason: '$path: expected $expected, got $actual');
  } else if (actual is OpenEnum && expected is String) {
    expect(actual.value, expected, reason: path);
  } else {
    expect(actual, expected, reason: path);
  }
}

void _checkResult(Object? result, Map<String, Object?> expected) {
  for (final e in expected.entries) {
    _checkValue(e.key, _resolve(result, e.key), e.value);
  }
}

String? _header(http.Request request, String name) {
  for (final e in request.headers.entries) {
    if (e.key.toLowerCase() == name.toLowerCase()) return e.value;
  }
  return null;
}

void _checkRequest(http.Request request, Map<String, Object?> expected) {
  final label = '${request.method} ${request.url}';
  final url = request.url.toString();
  final raw = url.contains('?') ? url.substring(url.indexOf('?') + 1) : '';
  final path = url.contains('?') ? url.substring(0, url.indexOf('?')) : url;
  if (expected['method'] case final String m) {
    expect(request.method, m, reason: label);
  }
  if (expected['path'] case final String p) {
    expect(Uri.parse(path).path, p, reason: label);
  }
  if (expected['url_prefix'] case final String prefix) {
    expect(url.startsWith(prefix), isTrue, reason: label);
  }
  if (expected['query_string'] case final String q) {
    expect(raw, q, reason: label);
  }
  final pairs = <(String, String)>[
    if (raw.isNotEmpty)
      for (final part in raw.split('&'))
        (
          Uri.decodeComponent(part.split('=').first),
          Uri.decodeComponent(
              part.contains('=') ? part.substring(part.indexOf('=') + 1) : ''),
        ),
  ];
  final names = pairs.map((p) => p.$1).toList();
  expect(names.toSet().length, names.length,
      reason: '$label: a parameter is repeated');
  for (final e
      in ((expected['query'] as Map<String, Object?>?) ?? {}).entries) {
    expect(pairs.contains((e.key, e.value! as String)), isTrue,
        reason: '$label: expected ${e.key}=${e.value}');
  }
  for (final name in (expected['query_absent'] as List<Object?>?) ?? const []) {
    expect(names.contains(name), isFalse,
        reason: '$label: $name must be absent');
  }
  for (final e
      in ((expected['headers'] as Map<String, Object?>?) ?? {}).entries) {
    expect(_header(request, e.key), e.value, reason: '$label: header ${e.key}');
  }
  for (final name
      in (expected['headers_absent'] as List<Object?>?) ?? const []) {
    expect(_header(request, name! as String), isNull,
        reason: '$label: header $name must be absent');
  }
  for (final e
      in ((expected['headers_match'] as Map<String, Object?>?) ?? {}).entries) {
    expect(
        RegExp(e.value! as String).matchAsPrefix(_header(request, e.key) ?? ''),
        isNotNull,
        reason: '$label: header ${e.key}');
  }
}

void _checkError(OureaException error, Map<String, Object?> expected) {
  expect(error.category, expected['category'],
      reason: '${error.runtimeType}: $error');
  final api = error is ApiException ? error : null;
  if (expected.containsKey('code')) {
    _checkValue('code', api?.code, expected['code']);
  }
  if (expected.containsKey('status')) {
    _checkValue('status', api?.status, expected['status']);
  }
  if (expected.containsKey('retry_after')) {
    final wait = api?.retryAfter;
    _checkValue('retry_after', wait == null ? null : wait.inMicroseconds / 1e6,
        expected['retry_after']);
  }
  if (expected['string_excludes'] case final String secret) {
    for (final text in [error.toString(), error.message]) {
      expect(text.contains(secret), isFalse,
          reason: 'the error shows the secret');
    }
  }
}

// --- running ----------------------------------------------------------------------

Future<void> _run(Map<String, Object?> vector) async {
  final spec = (vector['client'] as Map<String, Object?>?) ?? {};
  final env = <String, String>{
    for (final e in ((spec['env'] as Map<String, Object?>?) ?? {}).entries)
      e.key: e.value! as String,
  };
  resetDeprecationNotices();
  final replay = _Replay((vector['responses'] as List<Object?>?) ?? const []);
  final mock = MockClient(replay.call);
  final delays = <Duration>[];
  final notices = <DeprecationNotice>[];

  OureaClient make({String? apiKey, Cache? cache}) {
    final client = OureaClient(
      apiKey: apiKey ?? spec['api_key'] as String?,
      baseUrl: spec['base_url'] as String?,
      maxRetries: (spec['max_retries'] as int?) ?? defaultMaxRetries,
      cache: cache ?? (spec['cache'] == false ? const NoCache() : null),
      sendKeyOnOpenRoutes: (spec['send_key_on_open_routes'] as bool?) ?? false,
      httpClient: mock,
      environment: env,
      onDeprecation: notices.add,
    );
    configureClientForTesting(client,
        sleep: (d) async => delays.add(d), random: () => 1.0);
    return client;
  }

  final main = make();
  final results = <Object?>[];
  OureaException? error;
  final calls = (vector['calls'] as List<Object?>?) ?? [vector['call']];
  try {
    for (final raw in calls) {
      final call = raw! as Map<String, Object?>;
      var client = main;
      if (call['with_api_key'] case final String key) {
        client = make(apiKey: key, cache: main.cache ?? const NoCache());
      }
      results.add(await _invoke(client, call));
    }
  } on OureaException catch (e) {
    error = e;
  }

  final expectation = (vector['expect'] as Map<String, Object?>?) ?? {};
  if (expectation['error'] case final Map<String, Object?> wanted) {
    expect(error, isNotNull, reason: 'expected an error');
    _checkError(error!, wanted);
  } else if (error != null) {
    fail('unexpected ${error.runtimeType}: $error');
  }

  final requests = replay.requests;
  if (vector.containsKey('expect_request')) {
    final wanted = vector['expect_request'];
    if (wanted == null) {
      expect(requests, isEmpty);
    } else {
      expect(requests, isNotEmpty, reason: 'no request was sent');
      for (final r in requests) {
        _checkRequest(r, wanted as Map<String, Object?>);
      }
    }
  }
  if (vector['expect_requests'] case final List<Object?> wanted) {
    expect(requests.length, wanted.length);
    for (var i = 0; i < wanted.length; i++) {
      _checkRequest(requests[i], wanted[i]! as Map<String, Object?>);
    }
  }
  if (expectation['requests'] case final int n) expect(requests.length, n);
  if (expectation['delays_s'] case final List<Object?> wanted) {
    expect(delays.length, wanted.length);
    for (var i = 0; i < wanted.length; i++) {
      expect(delays[i].inMicroseconds / 1e6,
          closeTo((wanted[i]! as num).toDouble(), 1e-9));
    }
  }
  if (expectation['result'] case final Map<String, Object?> wanted) {
    _checkResult(results.first, wanted);
  }
  if (expectation['results'] case final List<Object?> wanted) {
    expect(results.length, wanted.length);
    for (var i = 0; i < wanted.length; i++) {
      _checkResult(results[i], wanted[i]! as Map<String, Object?>);
    }
  }
  if (expectation['items'] case final List<Object?> wanted) {
    final items = results.last! as List<Object?>;
    expect([for (final item in items) readField(item!, 'slug')], wanted);
  }
  final warnings = (expectation['warnings'] as List<Object?>?) ?? const [];
  expect(notices.length, warnings.length, reason: 'deprecation notices');
  for (var i = 0; i < warnings.length; i++) {
    final wanted =
        (warnings[i]! as Map<String, Object?>)['contains']! as String;
    expect(notices[i].message, contains(wanted));
  }
  main.close();
}

void main() {
  final cases = _cases();

  test('every vector is collected', () {
    expect(cases.length, expectedVectorCount);
  });

  for (final file in cases) {
    test(_name(file), () async {
      final vector =
          jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
      await _run(vector);
    });
  }
}
