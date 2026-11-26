// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

// Spec drift against the pinned spec/openapi/v1/openapi.yaml (SDK-STANDARD
// "Tests"): every operation is exposed, every schema has a model, every
// schema field is read and written back under its wire name, every example
// round-trips, and the BEHAVIOR.md 3.0 rename table is applied exactly.

import 'dart:convert';
import 'dart:io';

import 'package:ensemble_weather/ensemble_weather.dart';
import 'package:ensemble_weather/src/errors.dart' show isKnownErrorCode;
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'support/paths.dart';
import 'support/registry.dart';

final Map<String, Object?> openapi = _plain(
  loadYaml(File(specPath('openapi/v1/openapi.yaml')).readAsStringSync()),
)! as Map<String, Object?>;

final Map<String, Object?> schemas = (openapi['components']!
    as Map<String, Object?>)['schemas']! as Map<String, Object?>;

Object? _plain(Object? yaml) => switch (yaml) {
      YamlMap() => {
          for (final e in yaml.entries) e.key.toString(): _plain(e.value)
        },
      YamlList() => [for (final v in yaml) _plain(v)],
      _ => yaml,
    };

/// getMapsToken is a web-map credential, out of SDK scope for 0.x
/// (BEHAVIOR.md 3).
const Set<String> outOfScope = {'getMapsToken'};

/// Schemas modelled another way. ErrorResponse is the exceptions; these are
/// enums; NextCursor is `String?`; MemberColumn and NullableNumbers are
/// `List<List<double?>>` and `List<double?>`; ModelMeans is a list of
/// ModelStats; the three FreezingLevel variants are one FreezingLevel model
/// discriminated by `kind`.
const Set<String> elsewhere = {
  'ErrorResponse',
  'UnitSystem',
  'ConditionIcon',
  'NullReason',
  'AlertClass',
  'SnowCharacter',
  'PassStatusLevel',
  'MemberColumn',
  'NullableNumbers',
  'NextCursor',
  'ModelMeans',
  'FreezingLevelBelowSurface',
  'FreezingLevelHeight',
  'FreezingLevelAboveProfile',
};

/// Variant schemas read by another model.
const Map<String, String> readAs = {
  'FreezingLevelBelowSurface': 'FreezingLevel',
  'FreezingLevelHeight': 'FreezingLevel',
  'FreezingLevelAboveProfile': 'FreezingLevel',
};

Map<String, Map<String, Object?>> _operations() => {
      for (final item in (openapi['paths']! as Map<String, Object?>).values)
        for (final e in (item! as Map<String, Object?>).entries)
          if (e.key == 'get')
            (e.value! as Map<String, Object?>)['operationId']! as String:
                e.value! as Map<String, Object?>,
    };

Map<String, Object?> _schema(String ref) =>
    schemas[ref.split('/').last]! as Map<String, Object?>;

/// A complete instance of [schema]: every property, each with a valid value.
Object? synth(Map<String, Object?> schema, [int depth = 0]) {
  if (depth > 60) return null;
  if (schema[r'$ref'] case final String ref) {
    return synth(_schema(ref), depth + 1);
  }
  for (final key in ['oneOf', 'anyOf']) {
    if (schema[key] case final List<Object?> alternatives) {
      final options = alternatives
          .cast<Map<String, Object?>>()
          .where((s) => s['type'] != 'null')
          .toList();
      if (options.isNotEmpty) return synth(options.first, depth + 1);
    }
  }
  if (schema['allOf'] case final List<Object?> parts) {
    final out = <String, Object?>{};
    for (final part in parts.cast<Map<String, Object?>>()) {
      final value = synth(part, depth + 1);
      if (value is! Map<String, Object?>) return value;
      out.addAll(value);
    }
    final own = Map<String, Object?>.of(schema)..remove('allOf');
    final rest = synth(own, depth + 1);
    if (rest is Map<String, Object?>) out.addAll(rest);
    return out;
  }
  var type = schema['type'];
  if (type is List) {
    type = type.firstWhere((t) => t != 'null', orElse: () => null);
  }
  if (schema['enum'] case final List<Object?> values) {
    return values.firstWhere((v) => v != null, orElse: () => null);
  }
  if (type == null && schema.containsKey('properties')) type = 'object';
  switch (type) {
    case 'string':
      return switch (schema['format']) {
        'date-time' => '2026-11-25T06:00:00Z',
        'date' => '2026-11-25',
        _ => 'text',
      };
    case 'integer':
      return 7;
    case 'number':
      return 1.5;
    case 'boolean':
      return true;
    case 'array':
      final items = schema['items'];
      if (items is! Map<String, Object?>) return <Object?>[];
      final item = synth(items, depth + 1);
      return item == null ? <Object?>[] : [item];
    case 'object':
      final out = <String, Object?>{};
      final props = (schema['properties'] as Map<String, Object?>?) ?? {};
      for (final e in props.entries) {
        final value = synth(e.value! as Map<String, Object?>, depth + 1);
        if (value != null) out[e.key] = value;
      }
      if (schema['additionalProperties']
          case final Map<String, Object?> extra) {
        final value = synth(extra, depth + 1);
        if (value != null) out['key'] = value;
      }
      return out;
  }
  return null;
}

/// Keys of [example] (non-null) that [encoded] lacks, as paths.
List<String> missingKeys(Object? example, Object? encoded, String path) {
  final out = <String>[];
  if (example is Map<String, Object?> && encoded is Map<String, Object?>) {
    for (final e in example.entries) {
      if (e.value == null) continue;
      if (!encoded.containsKey(e.key)) {
        out.add('$path.${e.key}');
      } else {
        out.addAll(missingKeys(e.value, encoded[e.key], '$path.${e.key}'));
      }
    }
  } else if (example is List<Object?> && encoded is List<Object?>) {
    for (var i = 0; i < example.length && i < encoded.length; i++) {
      out.addAll(missingKeys(example[i], encoded[i], '$path[$i]'));
    }
  }
  return out;
}

Map<String, Object?> _json(Object? value) =>
    jsonDecode(jsonEncode(value)) as Map<String, Object?>;

String _camel(String snake) {
  final parts = snake.split('_').where((p) => p.isNotEmpty).toList();
  return parts.first +
      parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
}

/// (class, wire name) -> Dart field, read from the models' source (each
/// `_readX` decoder names its fields `dartName: r.req('wire', ...)`).
Map<(String, String), String> _modelNames() {
  final source = File('lib/src/types.dart').readAsStringSync();
  final readers = RegExp(r'^\w+ _read(\w+)\(', multiLine: true)
      .allMatches(source)
      .map((m) => (m.start, m.group(1)!))
      .toList();
  final field = RegExp(r"(\w+):\s*r\.(?:req|opt|any)\(\s*'([^']+)'");
  final out = <(String, String), String>{};
  for (final m in field.allMatches(source)) {
    final owner =
        readers.lastWhere((r) => r.$1 < m.start, orElse: () => (-1, ''));
    if (owner.$1 < 0) continue;
    out[(owner.$2, m.group(2)!)] = m.group(1)!;
  }
  return out;
}

/// Names Dart forbids, so the field takes another name (language idiom).
const Map<String, String> keywordNames = {
  'class': 'alertClass',
  'default': 'isDefault',
};

void main() {
  group('operations', () {
    test('every spec operation is exposed', () {
      final client = OureaClient(environment: const {});
      final exposed = <String, Function>{
        'getLocationForecast': client.getForecast,
        'getPointForecast': client.getPointForecast,
        'getCurrentConditions': client.getCurrent,
        'getCurrentByCoordinates': client.getPointCurrent,
        'getLocationAlerts': client.getAlerts,
        'getAlertsByCoordinates': client.getPointAlerts,
        'getNearbyLocations': client.getNearby,
        'getNearbyByCoordinates': client.getPointNearby,
        'searchLocations': client.searchLocations,
        'getAllLocations': client.listLocations,
        'getLocations': client.listLocations,
        'listCatalogLocations': client.listCatalogLocations,
        'getCatalogLocation': client.getCatalogLocation,
        'listCatalogStations': client.listCatalogStations,
        'getCatalogStation': client.getCatalogStation,
        'getAvailableRuns': client.getRuns,
        'getAttribution': client.getAttribution,
        'explore': client.explore,
        'getComposition': client.getComposition,
        'getLocationSeason': client.getSeason,
        'getLocationSnowTrend': client.getSnowTrend,
        'getLocationSnowpack': client.getSnowpack,
        'getLocationSnowpackPlume': client.getSnowpackPlume,
        'getAlertOutlines': client.getAlertOutlines,
        'getAvalancheZones': client.getAvalancheZones,
      };
      final missing = _operations()
          .keys
          .toSet()
          .difference(outOfScope)
          .difference(exposed.keys.toSet());
      expect(missing, isEmpty, reason: 'operations the SDK does not expose');
      client.close();
    });

    test('every error code maps to a category', () {
      final error = (schemas['ErrorResponse']!
          as Map<String, Object?>)['properties']! as Map<String, Object?>;
      final codes =
          ((error['error']! as Map<String, Object?>)['enum']! as List<Object?>)
              .cast<String>();
      expect(codes.where((c) => !isKnownErrorCode(c)), isEmpty);
    });
  });

  group('models', () {
    test('every schema has a model', () {
      final missing = schemas.keys
          .where((n) => !elsewhere.contains(n) && !roundTrip.containsKey(n))
          .toList();
      expect(missing, isEmpty, reason: 'schemas without a model');
    });

    test('every schema field is read and written back', () {
      final problems = <String>[];
      for (final name in schemas.keys) {
        final model = roundTrip[readAs[name] ?? name];
        if (model == null) continue;
        final example = synth(schemas[name]! as Map<String, Object?>);
        if (example is! Map<String, Object?>) continue;
        // A ModelStats always sits in ModelMeans, which adds its model `id`.
        if (name == 'ModelStats') example['id'] = 'aifs';
        try {
          final encoded = _json(model(example));
          problems.addAll(missingKeys(example, encoded, name));
        } on FormatException catch (e) {
          problems.add('$name: ${e.message}');
        }
      }
      expect(problems, isEmpty, reason: 'spec fields the models drop');
    });

    final examples = <(String, String, Map<String, Object?>)>[];
    final ops = _operations();
    for (final id in (ops.keys.toList()..sort())) {
      if (outOfScope.contains(id)) continue;
      final ok = ((ops[id]!['responses']! as Map<String, Object?>)['200']
          as Map<String, Object?>?);
      final content = (ok?['content'] as Map<String, Object?>?) ?? {};
      final body = (content['application/json'] ??
          content['application/geo+json']) as Map<String, Object?>?;
      if (body == null) continue;
      final ref =
          ((body['schema'] as Map<String, Object?>?)?[r'$ref'] as String?) ??
              '';
      final schema = ref.split('/').last;
      final named = (body['examples'] as Map<String, Object?>?) ?? {};
      if (body['example'] case final Map<String, Object?> one) {
        examples.add((id, schema, one));
      }
      for (final e in named.entries) {
        final value = (e.value! as Map<String, Object?>)['value'];
        if (value is Map<String, Object?>) {
          examples.add(('$id-${e.key}', schema, value));
        }
      }
    }

    test('the spec has response examples', () {
      expect(examples, isNotEmpty);
    });

    for (final (id, schema, example) in examples) {
      test('the $id example round-trips as $schema', () {
        final model = roundTrip[schema]!;
        final encoded = _json(model(example));
        expect(missingKeys(example, encoded, r'$'), isEmpty,
            reason: 'example fields the model drops');
        expect(_json(model(encoded)), encoded);
      });
    }

    for (final name in [
      'forecast-metric.json',
      'forecast-prob-mixed.json',
      'forecast-totals.json',
      'forecast-plume.json',
      'forecast-full.json',
    ]) {
      test('vector body $name round-trips', () {
        final data = jsonDecode(
                File(specPath('vectors/bodies/$name')).readAsStringSync())
            as Map<String, Object?>;
        final encoded = _json(ForecastResponse.fromJson(data).toJson());
        expect(missingKeys(data, encoded, r'$'), isEmpty);
        expect(_json(ForecastResponse.fromJson(encoded).toJson()), encoded);
      });
    }
  });

  group('names (BEHAVIOR.md 3.0)', () {
    final behaviour = File(specPath('BEHAVIOR.md')).readAsStringSync();
    final table = behaviour
        .split('| Schema (where the field sits) | Wire name | SDK name |')[1];
    final rows = <String>[];
    for (final line in const LineSplitter().convert(table).skip(2)) {
      if (!line.startsWith('|')) break;
      rows.add(line);
    }
    final names = _modelNames();

    test('the table is read from the pinned spec', () {
      expect(rows.length, greaterThan(25));
      expect(names.length, greaterThan(500));
    });

    final renamed = {
      for (final e in names.entries)
        if (e.value != _camel(e.key.$2) && keywordNames[e.key.$2] != e.value)
          e.key: e.value,
    };

    test('every rename in the table is applied', () {
      final wireNames = renamed.keys.map((k) => k.$2).toSet();
      for (final row in rows) {
        final cells = row.split('|');
        final wires = cells[2]
            .split(',')
            .map((w) => w.trim().replaceAll('`', ''))
            .toList();
        final sdks = cells[3]
            .split('(')
            .first
            .split(',')
            .map((s) => s.trim().replaceAll('`', ''))
            .toList();
        if (wires.length == 1 && wires.first == 'error') {
          continue; // the exceptions' code
        }
        expect(wires.length, sdks.length, reason: row);
        for (var i = 0; i < wires.length; i++) {
          expect(wireNames, contains(wires[i]),
              reason: '${wires[i]} is renamed nowhere');
          expect(
            renamed.entries
                .any((e) => e.key.$2 == wires[i] && e.value == _camel(sdks[i])),
            isTrue,
            reason: '${wires[i]} -> ${sdks[i]}',
          );
        }
      }
    });

    test('nothing is renamed that the table does not list', () {
      final tableWires = <String>{
        for (final row in rows)
          ...row
              .split('|')[2]
              .split(',')
              .map((w) => w.trim().replaceAll('`', '')),
      };
      final extra =
          renamed.keys.map((k) => k.$2).toSet().difference(tableWires);
      expect(extra, isEmpty, reason: 'renames for taste');
    });

    test('GeoJSON keeps its wire names', () {
      expect(names[('AvalancheZoneProperties', 'forecast_url')], 'forecastUrl');
      final zone = AvalancheZoneProperties.fromJson(const {
        'center_id': 'NWAC',
        'center_name': 'Northwest Avalanche Center',
        'zone_id': 1,
        'zone_name': 'Mt Hood',
        'status': 'rated',
        'forecast_url': 'https://nwac.us/',
        'center_url': 'https://nwac.us/',
        'attribution': 'NWAC',
        'danger_level': 3,
      });
      expect(zone.toJson()['forecast_url'], 'https://nwac.us/');
      expect(zone.toJson()['danger_level'], 3);
    });

    test('renamed fields decode and encode their wire names', () {
      final data = jsonDecode(
          File(specPath('vectors/bodies/forecast-metric.json'))
              .readAsStringSync()) as Map<String, Object?>;
      final forecast = ForecastResponse.fromJson(data);
      final wireSeries = data['forecast']! as Map<String, Object?>;
      final first = (wireSeries['timeseries']! as List<Object?>).first!
          as Map<String, Object?>;
      expect(forecast.series.timeseries.first.leadTimeHours,
          first['lead_time_hours']);
      final encoded = forecast.toJson();
      expect(encoded.containsKey('forecast'), isTrue);
      expect(encoded.containsKey('series'), isFalse);
    });
  });
}
