// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

/// Decoding parsed JSON into the models (SDK-internal).
///
/// Unknown fields are ignored (BEHAVIOR.md 1.5), an absent optional field is
/// `null`, and a body that does not match its schema is a [FormatException]
/// naming the path of the problem (for example `$.forecast.timeseries[3]`).
library;

/// Converts one parsed JSON value found at `path`.
typedef Conv<T> = T Function(Object? value, String path);

Never _fail(String path, String problem) =>
    throw FormatException('$path: $problem');

String _kind(Object? value) => switch (value) {
      null => 'null',
      bool() => 'a boolean',
      num() => 'a number',
      String() => 'a string',
      List<Object?>() => 'an array',
      Map<Object?, Object?>() => 'an object',
      _ => value.runtimeType.toString(),
    };

/// A JSON object.
Map<String, Object?> asObject(Object? value, String path) {
  if (value is Map<String, Object?>) return value;
  if (value is Map) {
    return {
      for (final entry in value.entries)
        if (entry.key is String) entry.key as String: entry.value,
    };
  }
  _fail(path, 'expected an object, got ${_kind(value)}');
}

/// A JSON string.
String asString(Object? value, String path) => value is String
    ? value
    : _fail(path, 'expected a string, got ${_kind(value)}');

/// A JSON boolean.
bool asBool(Object? value, String path) => value is bool
    ? value
    : _fail(path, 'expected a boolean, got ${_kind(value)}');

/// A JSON number that is a whole number (`3` or `3.0`).
int asInt(Object? value, String path) {
  if (value is int) return value;
  if (value is double && value.isFinite && value == value.truncateToDouble()) {
    return value.toInt();
  }
  _fail(
      path, 'expected an integer, got ${value is num ? value : _kind(value)}');
}

/// A JSON number.
double asDouble(Object? value, String path) => value is num
    ? value.toDouble()
    : _fail(path, 'expected a number, got ${_kind(value)}');

/// Any JSON value, kept as parsed.
Object? asAny(Object? value, String path) => value;

/// An RFC 3339 timestamp.
DateTime asDateTime(Object? value, String path) {
  final text = asString(value, path);
  final parsed = DateTime.tryParse(text.trim());
  return parsed ?? _fail(path, 'not a valid timestamp: "$text"');
}

final RegExp _date = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

/// A calendar date (`2026-11-25`), as midnight UTC.
DateTime asDate(Object? value, String path) {
  final text = asString(value, path);
  final match = _date.firstMatch(text);
  if (match == null) _fail(path, 'not a valid date: "$text"');
  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  final date = DateTime.utc(year, month, day);
  if (date.month != month || date.day != day) {
    _fail(path, 'not a valid date: "$text"');
  }
  return date;
}

/// A JSON array whose items are each converted by [item].
Conv<List<T>> listOf<T>(Conv<T> item) => (value, path) {
      if (value is! List) _fail(path, 'expected an array, got ${_kind(value)}');
      return [
        for (var i = 0; i < value.length; i++) item(value[i], '$path[$i]')
      ];
    };

/// A JSON object used as a map, whose values are each converted by [item].
Conv<Map<String, T>> mapOf<T>(Conv<T> item) => (value, path) {
      final object = asObject(value, path);
      return {
        for (final entry in object.entries)
          entry.key: item(entry.value, '$path.${entry.key}'),
      };
    };

/// [item], or `null` for a JSON `null`.
Conv<T?> nullableOf<T>(Conv<T> item) =>
    (value, path) => value == null ? null : item(value, path);

/// An open enumeration, built from its wire string by [make].
Conv<T> enumOf<T>(T Function(String value) make) =>
    (value, path) => make(asString(value, path));

/// Decodes a top-level document with [read].
T decodeRoot<T>(Map<String, Object?> json, Conv<T> read) => read(json, r'$');

/// Reads the fields of one JSON object.
final class JsonReader {
  /// Reads [value], which must be a JSON object, found at [path].
  JsonReader.of(Object? value, this.path) : json = asObject(value, path);

  /// The object.
  final Map<String, Object?> json;

  /// Where the object is in the document.
  final String path;

  /// A required, non-null field.
  T req<T>(String key, Conv<T> conv) {
    if (!json.containsKey(key)) _fail(path, 'missing required field "$key"');
    final value = json[key];
    if (value == null) _fail('$path.$key', 'is null');
    return conv(value, '$path.$key');
  }

  /// A field of any JSON value, kept as parsed (`null` when absent).
  Object? any(String key) => json[key];

  /// An optional field: `null` when absent or JSON `null`.
  T? opt<T>(String key, Conv<T> conv) {
    final value = json[key];
    return value == null ? null : conv(value, '$path.$key');
  }
}

String _two(int n) => n.toString().padLeft(2, '0');

/// A timestamp the way the API writes one: UTC, with a `Z`, and microseconds
/// only when there are any (`2026-11-25T06:00:00Z`).
String formatDateTime(DateTime value) {
  final utc = value.toUtc();
  final year = utc.year.toString().padLeft(4, '0');
  final buffer = StringBuffer()
    ..write('$year-${_two(utc.month)}-${_two(utc.day)}')
    ..write('T${_two(utc.hour)}:${_two(utc.minute)}:${_two(utc.second)}');
  final micros = utc.millisecond * 1000 + utc.microsecond;
  if (micros != 0) buffer.write('.${micros.toString().padLeft(6, '0')}');
  buffer.write('Z');
  return buffer.toString();
}

/// A calendar date as `YYYY-MM-DD`.
String formatDate(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${_two(value.month)}-${_two(value.day)}';
