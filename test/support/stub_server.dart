// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

// A tiny local stand-in for the API, so the examples run without network or
// key. It serves the shared vector bodies (spec/vectors/bodies) and answers
// `prob=` / `totals=` with placeholder values (it is a test double, not a
// forecast). Run it by hand with:
//
//   dart run test/support/stub_server.dart   # prints the base URL to export
//   OUREA_BASE_URL=http://127.0.0.1:<port> dart run example/quickstart.dart

import 'dart:convert';
import 'dart:io';

const String _start = '2026-11-15T00:00:00Z';

Map<String, Object?> _body(String name) =>
    jsonDecode(File('spec/vectors/bodies/$name').readAsStringSync())
        as Map<String, Object?>;

String _hoursAfter(int hours) {
  final day = hours ~/ 24;
  final hour = hours % 24;
  return '2026-11-${(15 + day).toString().padLeft(2, '0')}'
      'T${hour.toString().padLeft(2, '0')}:00:00Z';
}

(int, int) _window(String text) {
  final span = text.endsWith('h') ? text.substring(0, text.length - 1) : text;
  if (span.contains('-')) {
    final parts = span.split('-');
    return (int.parse(parts[0]), int.parse(parts[1]));
  }
  return (0, int.parse(span));
}

List<Map<String, Object?>> _probabilities(String spec) => [
      for (final term in spec.split(','))
        () {
          final parts = term.split(':');
          final variable = parts[0];
          final amounts = variable == 'precipitation' || variable == 'snowfall';
          final (start, end) = _window(parts[3]);
          return <String, Object?>{
            'term': term,
            'variable': variable,
            'op': parts[1],
            'threshold': double.parse(parts[2]),
            'window_start_hours': start,
            'window_end_hours': end,
            'aggregation':
                parts.length > 4 ? parts[4] : (amounts ? 'total' : 'any'),
            'from': _hoursAfter(start),
            'to': _hoursAfter(end),
            'probability': 0.42,
            'members': 131,
            'null_reason': null,
          };
        }(),
    ];

List<Map<String, Object?>> _totals(String spec) => [
      for (final item in spec.split(','))
        () {
          final parts = item.split(':');
          final (start, end) = _window(parts[1]);
          return <String, Object?>{
            'term': item,
            'variable': parts[0],
            'window_start_hours': start,
            'window_end_hours': end,
            'aggregation': 'total',
            'from': _hoursAfter(start),
            'to': _hoursAfter(end),
            'quantiles': {
              'mean': 31.0,
              'p10': 12.0,
              'p25': 20.0,
              'p50': 29.0,
              'p75': 40.0,
              'p90': 52.0,
              'min': 4.0,
              'max': 88.0,
            },
            'members': 131,
            'null_reason': null,
          };
        }(),
    ];

Map<String, Object?> _alert() => {
      'id': 'urn:oid:2.49.0.1.840.0.example',
      'event': 'Winter Storm Warning',
      'severity': 'severe',
      'urgency': 'expected',
      'certainty': 'likely',
      'headline': 'Winter Storm Warning until Sunday 4 AM PST',
      'onset': _start,
      'expires': '2026-11-16T12:00:00Z',
    };

Map<String, Object?> _current(Object? location) => {
      'location': location,
      'alerts': [_alert()],
      'alerts_as_of': _start,
      'sensor_count': 0,
      'sensors': <Object?>[],
      'current': {
        'time': _start,
        'temperature': -2.0,
        'condition': 'snow',
        'condition_text': 'Snow',
        'condition_icon': 'night_snow',
        'wind_speed': 6.0,
        'wind_direction': 5.0,
        'source': 'nowcast',
      },
      'as_of': _start,
      'model_run_initialized_at': _start,
      'nowcast_hours': null,
      'units': 'metric',
      'attribution': _body('forecast-metric.json')['attribution'],
    };

Map<String, Object?> _error(String code, String message) => {
      'error': code,
      'message': message,
      'request_id': '01JBQ6ZK3V8M4T2N7XQH5R9W0C',
      'doc_url':
          'https://docs.oureawx.com/features/errors/#${code.toLowerCase()}',
    };

Map<String, Object?> _forecast(Map<String, String> query) {
  final body = _body(query['units'] == 'imperial'
      ? 'forecast-imperial.json'
      : 'forecast-metric.json');
  if (query['prob'] case final String prob) {
    body['probabilities'] = _probabilities(prob);
  }
  if (query['totals'] case final String totals) {
    body['window_totals'] = _totals(totals);
  }
  return body;
}

/// Answers one GET request: (status, JSON body).
(int, Map<String, Object?>) route(
    String path, Map<String, String> query, bool keyed) {
  final location = _body('forecast-metric.json')['location'];
  final parts = path
      .split('/')
      .where((p) => p.isNotEmpty)
      .map(Uri.decodeComponent)
      .skip(2) // "api", "v1"
      .toList();
  final joined = parts.join('/');
  if (parts.isNotEmpty && parts.first == 'locations' && parts.length == 3) {
    if (parts[1] != 'or' || parts[2] != 'mt-hood-meadows') {
      return (
        404,
        _error('LOCATION_NOT_FOUND', 'No location ${parts[1]}/${parts[2]}.')
      );
    }
    return (200, _forecast(query));
  }
  if (parts.isNotEmpty && parts.first == 'locations' && parts.length >= 4) {
    final sub = parts.skip(3).join('/');
    if (sub == 'snow-trend' && !keyed) {
      return (403, _body('error-pro-required.json'));
    }
    const bodies = {
      'season': 'season.json',
      'snow-trend': 'snow-trend.json',
      'snowpack': 'snowpack.json',
      'snowpack/plume': 'snowpack-plume.json',
    };
    if (bodies[sub] case final String name) return (200, _body(name));
    if (sub == 'current') return (200, _current(location));
    if (sub == 'alerts') {
      return (
        200,
        {
          'location': location,
          'alert_count': 1,
          'as_of': _start,
          'alerts': [_alert()],
          'attribution': _body('forecast-metric.json')['attribution'],
        }
      );
    }
  }
  if (joined == 'forecast') {
    if (!keyed) return (403, _body('error-pro-required.json'));
    if (double.parse(query['lon'] ?? '0') > -60) {
      return (404, _body('error-outside-coverage.json'));
    }
    return (200, _forecast(query));
  }
  if (joined == 'search/locations') return (200, _body('search.json'));
  if (joined == 'catalog/locations') {
    return (
      200,
      _body(query.containsKey('cursor')
          ? 'catalog-page-2.json'
          : 'catalog-page-1.json')
    );
  }
  const simple = {
    'explore': 'explore.json',
    'composition': 'composition.json',
    'alerts/outlines': 'alert-outlines.json',
    'avalanche/zones': 'avalanche-zones.json',
    'attribution': 'attribution.json',
  };
  if (simple[joined] case final String name) return (200, _body(name));
  return (404, _error('NOT_FOUND', 'No route $path.'));
}

/// The stub on a free local port.
final class StubServer {
  StubServer._(this._server);

  final HttpServer _server;

  /// Starts the stub on 127.0.0.1.
  static Future<StubServer> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      final keyed = request.headers.value('x-api-key') != null;
      final (status, body) =
          route(request.uri.path, request.uri.queryParameters, keyed);
      final payload = utf8.encode(jsonEncode(body));
      final response = request.response
        ..statusCode = status
        ..headers.contentType = ContentType.json
        ..headers.contentLength = payload.length;
      if (keyed) {
        response.headers
          ..set('Cache-Control', 'private, max-age=0')
          ..set('RateLimit-Limit', '60')
          ..set('RateLimit-Remaining', '59')
          ..set('RateLimit-Reset', '1')
          ..set('RateLimit-Policy', '60;w=60');
      } else {
        response.headers.set('Cache-Control', 'public, max-age=0, s-maxage=60');
      }
      response.add(payload);
      await response.close();
    });
    return StubServer._(server);
  }

  /// The base URL to point the SDK at.
  String get url => 'http://${_server.address.address}:${_server.port}';

  /// Stops the stub.
  Future<void> close() => _server.close(force: true);
}

Future<void> main() async {
  final stub = await StubServer.start();
  stdout.writeln('export OUREA_BASE_URL=${stub.url}');
}
