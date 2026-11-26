// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

// Unit tests of the behaviour the vectors do not pin on their own: the
// canonical form's helpers, rounding, the cache, the models' views, the
// errors and the transport's bounds.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ensemble_weather/ensemble_weather.dart';
import 'package:ensemble_weather/src/client.dart'
    show configureClientForTesting, parseRetryAfter;
import 'package:ensemble_weather/src/json.dart' show formatDateTime;
import 'package:ensemble_weather/src/query.dart';
import 'package:ensemble_weather/src/sha256.dart';
import 'package:ensemble_weather/src/units.dart' show formatRounded;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

import 'support/paths.dart';
import 'support/stub_server.dart' show route;

List<int> _bodyFile(String name) =>
    File(specPath('vectors/bodies/$name')).readAsBytesSync();

OureaClient _client(
  MockClient mock, {
  String? apiKey,
  int maxRetries = 2,
  Cache? cache,
  List<Duration>? delays,
}) {
  final client = OureaClient(
    apiKey: apiKey,
    baseUrl: 'https://api.example.test',
    maxRetries: maxRetries,
    cache: cache,
    httpClient: mock,
    environment: const {},
    onDeprecation: (_) {},
  );
  configureClientForTesting(client,
      sleep: (d) async => delays?.add(d), random: () => 1.0);
  return client;
}

http.Response _json(String name,
        {int status = 200, Map<String, String>? headers}) =>
    http.Response.bytes(_bodyFile(name), status,
        headers: {'content-type': 'application/json', ...?headers});

void main() {
  group('canonical form', () {
    test('numbers are the shortest round-trip decimal, never an exponent', () {
      expect(formatNumber(1661.0), '1661');
      expect(formatNumber(1661), '1661');
      expect(formatNumber(45.3311), '45.3311');
      expect(formatNumber(-121.6649), '-121.6649');
      expect(formatNumber(2500.5), '2500.5');
      expect(formatNumber(0.1), '0.1');
      expect(formatNumber(1e-7), '0.0000001');
      expect(formatNumber(-1.5e-7), '-0.00000015');
      expect(formatNumber(1e21), '1000000000000000000000');
      expect(formatNumber(1.25e22), '12500000000000000000000');
      expect(() => formatNumber(double.nan), throwsA(isA<UsageException>()));
    });

    test('values are RFC 3986 percent-encoded', () {
      expect(encodeComponent('a b&c'), 'a%20b%26c');
      expect(
          encodeComponent('Mt. Hood & co/ñ'), 'Mt.%20Hood%20%26%20co%2F%C3%B1');
      expect(encodeComponent("-._~!*'()"), '-._~%21%2A%27%28%29');
      expect(encodeComponent('a+b'), 'a%2Bb');
    });

    test('a query is sorted, de-duplicated and omits defaults', () {
      final q = Query()
        ..add('units', UnitSystem.metric, UnitSystem.metric)
        ..add('max_hours', 48, 24)
        ..addList('sources', ['snotel', 'asos', 'snotel'])
        ..add('include_past', true, false)
        ..addRaw('prob', 'snowfall:ge:6.00:24h');
      expect(q.render(),
          'include_past=true&max_hours=48&prob=snowfall:ge:6.00:24h&sources=asos,snotel');
    });

    test('timestamps are written as the API writes them', () {
      expect(formatDateTime(DateTime.utc(2026, 11, 25, 6)),
          '2026-11-25T06:00:00Z');
      expect(formatDateTime(DateTime.utc(2026, 11, 25, 6, 0, 0, 1, 2)),
          '2026-11-25T06:00:00.001002Z');
    });
  });

  group('thresholds', () {
    test('round half away from zero, as the server does', () {
      expect(formatRounded(0.0625, 3), '0.063');
      expect(formatRounded(1.005, 2), '1.00');
      expect(formatRounded(2.5, 0), '3');
      expect(formatRounded(-2.5, 0), '-3');
      expect(formatRounded(-0.04, 1), '0.0');
      expect(formatRounded(152.4, 2), '152.40');
    });

    test('a term is refused before anything is sent', () {
      expect(
          () => Chance.atLeast(Variable.snowfall, 6,
              aggregation: Aggregation.any),
          throwsA(isA<UsageException>()));
      expect(
          () => Chance.atLeast(Variable.temperature, 0,
              aggregation: Aggregation.total),
          throwsA(isA<UsageException>()));
      expect(() => Chance.atLeast(Variable.snowfall, 6, unit: Unit.degF),
          throwsA(isA<UsageException>()));
      expect(() => Chance.atLeast(Variable('rain_rate'), 1),
          throwsA(isA<UsageException>()));
      expect(() => Chance.atLeast(Variable.snowfall, double.infinity),
          throwsA(isA<UsageException>()));
    });

    test('windows are 0 <= start < end <= 360', () {
      expect(Window(6, 18).toQuery(), '6-18h');
      expect(Window.hours(72).toQuery(), '72h');
      expect(() => Window(0, 361), throwsA(isA<UsageException>()));
      expect(() => Window(12, 12), throwsA(isA<UsageException>()));
      expect(() => Window(-1, 6), throwsA(isA<UsageException>()));
    });
  });

  group('models', () {
    test('quantile views read only what the server sent', () {
      final q = Quantiles.fromJson(const {'p10': 1.0, 'p50': 2.0, 'p90': 3.0});
      expect(q.median, 2.0);
      expect(q.range(), (1.0, 3.0));
      expect(q.range(25, 75), isNull);
      expect(q.mean, isNull, reason: 'a missing quantile is absent, not 0');
      expect(() => q.range(5, 95), throwsA(isA<UsageException>()));
    });

    test('an unknown enum value keeps its raw string', () {
      final type = LocationType('a_type_added_later');
      expect(type.isUnknown, isTrue);
      expect(type.value, 'a_type_added_later');
      expect(LocationType('ski_area'), LocationType.skiArea);
      expect(LocationType.skiArea.isUnknown, isFalse);
    });

    test('a body that does not match its schema names the path', () {
      expect(
        () => Quantiles.fromJson(const {'p10': 'warm'}),
        throwsA(isA<FormatException>()
            .having((e) => e.message, 'message', contains(r'$.p10'))),
      );
    });

    test('wind direction stays circular', () {
      final data = jsonDecode(utf8.decode(_bodyFile('forecast-metric.json')))
          as Map<String, Object?>;
      final f = ForecastResponse.fromJson(data);
      final wind = f.series.timeseries.first.ensemble.windDirection;
      expect(wind.sector50.from, isA<double>());
    });
  });

  group('cache', () {
    CacheEntry entry(int size) => CacheEntry(
        body: Uint8List(size),
        etag: '"x"',
        headers: const {},
        storedAt: DateTime.utc(2026));

    test('the memory cache evicts the least recently used', () {
      final cache = MemoryCache(maxEntries: 2)
        ..set('a', entry(1))
        ..set('b', entry(1));
      cache.get('a');
      cache.set('c', entry(1));
      expect(cache.get('b'), isNull);
      expect(cache.get('a'), isNotNull);
      expect(cache.length, 2);
    });

    test('the memory cache is bounded by bytes', () {
      final cache = MemoryCache(maxBytes: 10)
        ..set('a', entry(6))
        ..set('b', entry(6));
      expect(cache.get('a'), isNull);
      expect(cache.sizeBytes, 6);
      cache.set('huge', entry(11));
      expect(cache.get('huge'), isNull);
    });

    test('max-age decides freshness', () {
      final e = CacheEntry(
          body: Uint8List(1),
          etag: null,
          headers: const {},
          storedAt: DateTime.utc(2026),
          maxAge: const Duration(seconds: 60));
      expect(e.isFresh(DateTime.utc(2026).add(const Duration(seconds: 30))),
          isTrue);
      expect(e.isFresh(DateTime.utc(2026).add(const Duration(seconds: 61))),
          isFalse);
    });
  });

  group('security', () {
    test('sha256 matches the FIPS 180-4 examples', () {
      expect(sha256Hex(''),
          'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855');
      expect(sha256Hex('abc'),
          'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad');
      expect(
          sha256Hex('abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq'),
          '248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1');
    });

    test('the key is not in toString', () {
      final client =
          OureaClient(apiKey: 'ow_secret_value', environment: const {});
      expect(client.toString(), isNot(contains('ow_secret_value')));
      expect(client.hasApiKey, isTrue);
      client.close();
    });

    test('a connection error never shows the key', () async {
      final mock = MockClient((request) async {
        throw http.ClientException(
            'failed for ${request.headers['X-API-Key']}');
      });
      final delays = <Duration>[];
      final client = _client(mock, apiKey: 'ow_secret_value', delays: delays);
      await expectLater(
        client.getForecast('or/mt-hood-meadows'),
        throwsA(isA<ApiConnectionException>().having(
            (e) => e.toString(), 'text', isNot(contains('ow_secret_value')))),
      );
      expect(delays.length, 2, reason: 'connection errors are retried');
    });

    test('a body over 64 MiB is an error, not an out-of-memory', () async {
      final mock = MockClient.streaming((request, body) async =>
          http.StreamedResponse(const Stream.empty(), 200,
              contentLength: maxBodyBytes + 1, request: request));
      final client = _client(mock);
      await expectLater(
          client.getComposition(), throwsA(isA<ResponseTooLargeException>()));
    });

    test('a streamed body over the bound stops being read', () async {
      Stream<List<int>> chunks() async* {
        for (var i = 0; i < 65; i++) {
          yield List<int>.filled(1024 * 1024, 32);
        }
      }

      final mock = MockClient.streaming((request, body) async =>
          http.StreamedResponse(chunks(), 200, request: request));
      final client = _client(mock);
      await expectLater(
          client.getComposition(), throwsA(isA<ResponseTooLargeException>()));
    });

    test('the User-Agent names the SDK and the runtime', () {
      expect(userAgent(),
          matches(RegExp(r'^ensemble-weather-dart/0\.1\.0 \(Dart/\S+\)$')));
      expect(userAgent('my-app/2.0'), endsWith(' my-app/2.0'));
    });
  });

  group('transport', () {
    test('Retry-After reads delta-seconds and HTTP-dates', () {
      final now = DateTime.utc(2027, 12, 1);
      expect(parseRetryAfter('3', now), const Duration(seconds: 3));
      expect(parseRetryAfter('Wed, 01 Dec 2027 00:01:00 GMT', now),
          const Duration(minutes: 1));
      expect(parseRetryAfter('soon', now), isNull);
    });

    test('redirects stop after five hops', () async {
      var n = 0;
      final mock = MockClient((request) async {
        n++;
        return http.Response('', 302,
            headers: {'location': '/api/v1/composition?hop=$n'});
      });
      final client = _client(mock);
      await expectLater(client.getComposition(), throwsA(isA<ApiException>()));
      expect(n, 6);
    });

    test('a usage error surfaces as the future error and sends nothing',
        () async {
      var sent = 0;
      final mock = MockClient((request) async {
        sent++;
        return http.Response('{}', 200);
      });
      final client = _client(mock);
      await expectLater(client.getForecast('mt-hood-meadows'),
          throwsA(isA<UsageException>()));
      await expectLater(
          client.getPointForecast(91, 0), throwsA(isA<UsageException>()));
      await expectLater(
          client.searchLocations('a'), throwsA(isA<UsageException>()));
      await expectLater(
          client.getAlertOutlines(
              bbox: (west: 10, south: 0, east: -10, north: 1)),
          throwsA(isA<UsageException>()));
      expect(sent, 0);
    });

    test('answers are matched to the caller terms by term', () async {
      final mock = MockClient((request) async {
        final (status, body) =
            route(request.url.path, request.url.queryParameters, false);
        return http.Response(jsonEncode(body), status,
            headers: {'content-type': 'application/json'});
      });
      final client = _client(mock);
      final terms = [
        Chance.atMost(Variable.temperature, 32, unit: Unit.degF),
        Chance.atLeast(Variable.snowfall, 6, unit: Unit.inch),
        Chance.atLeast(Variable.snowfall, 6, unit: Unit.inch),
      ];
      final f = await client.getForecast('or/mt-hood-meadows', prob: terms);
      expect(f.probabilities.map((p) => p.term), [
        'temperature:le:0.0:24h',
        'snowfall:ge:152.40:24h',
        'snowfall:ge:152.40:24h'
      ]);
      for (var i = 0; i < terms.length; i++) {
        expect(f.probabilities[i].request, same(terms[i]));
      }
      expect(f.probabilities.first.window, Window(0, 24));
    });

    test('the iterators follow the cursor', () async {
      final mock = MockClient((request) async =>
          request.url.queryParameters['cursor'] == null
              ? _json('catalog-page-1.json')
              : _json('catalog-page-2.json'));
      final client = _client(mock);
      final slugs =
          await client.iterateCatalogLocations().map((e) => e.slug).toList();
      expect(slugs, isNotEmpty);
    });

    test('a timeout is a connection error', () async {
      final mock = MockClient((request) => Completer<http.Response>().future);
      final client = OureaClient(
        baseUrl: 'https://api.example.test',
        timeout: const Duration(milliseconds: 20),
        maxRetries: 0,
        httpClient: mock,
        environment: const {},
      );
      await expectLater(
          client.getComposition(), throwsA(isA<ApiConnectionException>()));
    });

    test('settings are validated', () {
      expect(() => OureaClient(maxRetries: -1, environment: const {}),
          throwsA(isA<UsageException>()));
      expect(() => OureaClient(timeout: Duration.zero, environment: const {}),
          throwsA(isA<UsageException>()));
      expect(
          () =>
              OureaClient(units: UnitSystem('furlongs'), environment: const {}),
          throwsA(isA<UsageException>()));
      expect(() => OureaClient(baseUrl: 'not a url', environment: const {}),
          throwsA(isA<UsageException>()));
    });
  });

  test('the version matches pubspec.yaml', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final version = RegExp(r'^version: (\S+)$', multiLine: true)
        .firstMatch(pubspec)!
        .group(1);
    expect(packageVersion, version);
  });
}
