// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

/// Canonical request URLs (BEHAVIOR.md 3.1): one request, one edge-cache
/// entry.
///
/// * a parameter the caller did not set, or set to its default, is omitted;
/// * parameters are sorted by name and each appears once;
/// * a comma list (`sources`, `include`, `network`, `capability`, ...) is
///   sorted and de-duplicated, its items joined by a literal `,`;
/// * values are RFC 3986 percent-encoded (space as `%20`, uppercase hex),
///   except that `prob` and `totals` keep `:` and `,` literal, and comma
///   lists, `near` and `bbox` keep their separating `,`;
/// * numbers are the shortest decimal that round-trips, never an exponent.
library;

import 'dart:convert';

import 'errors.dart';
import 'json.dart';
import 'open_enum.dart';

const String _hex = '0123456789ABCDEF';

bool _unreserved(int byte) =>
    (byte >= 0x41 && byte <= 0x5A) || // A-Z
    (byte >= 0x61 && byte <= 0x7A) || // a-z
    (byte >= 0x30 && byte <= 0x39) || // 0-9
    byte == 0x2D || // -
    byte == 0x2E || // .
    byte == 0x5F || // _
    byte == 0x7E; // ~

/// Percent-encodes one path segment or query value: RFC 3986 unreserved
/// characters as they are, every other byte of its UTF-8 as `%XX`.
String encodeComponent(String value) {
  final out = StringBuffer();
  for (final byte in utf8.encode(value)) {
    if (_unreserved(byte)) {
      out.writeCharCode(byte);
    } else {
      out
        ..write('%')
        ..write(_hex[byte >> 4])
        ..write(_hex[byte & 0x0F]);
    }
  }
  return out.toString();
}

final RegExp _exponent = RegExp(r'^(-?)(\d)(?:\.(\d+))?e([+-]\d+)$');

/// The shortest decimal that round-trips, without an exponent.
///
/// A whole number prints without `.0` (`1661.0` is `1661`), as every other
/// SDK prints it, so the URL is the same cache key everywhere.
String formatNumber(num value) {
  if (value is int) return value.toString();
  final v = value.toDouble();
  if (!v.isFinite) throw UsageException('expected a finite number, got $v');
  if (v == v.truncateToDouble() && v.abs() < 1e21) {
    return BigInt.from(v).toString();
  }
  final text = v.toString();
  final match = _exponent.firstMatch(text);
  if (match == null) return text;
  final sign = match.group(1)!;
  final digits = match.group(2)! + (match.group(3) ?? '');
  final exponent = int.parse(match.group(4)!);
  final point = 1 + exponent; // digits before the decimal point
  if (point <= 0) return '${sign}0.${'0' * -point}$digits';
  if (point >= digits.length) {
    return '$sign$digits${'0' * (point - digits.length)}';
  }
  return '$sign${digits.substring(0, point)}.${digits.substring(point)}';
}

/// Formats one query value (before percent-encoding).
String formatValue(Object value) => switch (value) {
      bool() => value ? 'true' : 'false',
      OpenEnum() => value.value,
      String() => value,
      DateTime() => formatDateTime(value),
      num() => formatNumber(value),
      _ => throw UsageException('unsupported query value $value'),
    };

/// Collects a request's parameters and renders the canonical query string.
final class Query {
  final Map<String, String> _params = {};
  final Set<String> _raw = {};

  /// Adds `name=value` unless [value] is unset or equals [fallback] (the
  /// route's default).
  void add(String name, Object? value, [Object? fallback]) {
    if (value == null) return;
    final text = formatValue(value);
    if (fallback != null && text == formatValue(fallback)) return;
    _params[name] = text;
    _raw.remove(name);
  }

  /// Adds a comma list, sorted, de-duplicated and joined by a literal `,`.
  ///
  /// That is the server's canonical form; any other is a 301 (BEHAVIOR.md
  /// 3.1).
  void addList(String name, Iterable<String>? values) {
    if (values == null) return;
    final items = values.toSet().toList()..sort();
    if (items.isEmpty) return;
    _params[name] = items.map(encodeComponent).join(',');
    _raw.add(name);
  }

  /// Adds a pre-built value sent without percent-encoding (`prob`, `totals`,
  /// `near`, `bbox`).
  void addRaw(String name, String value) {
    if (value.isEmpty) return;
    _params[name] = value;
    _raw.add(name);
  }

  /// The query string, without `?`, in canonical order.
  String render() {
    final names = _params.keys.toList()..sort();
    return [
      for (final name in names)
        '$name=${_raw.contains(name) ? _params[name] : encodeComponent(_params[name]!)}',
    ].join('&');
  }
}
