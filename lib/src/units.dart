// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

/// Unit handling for the caller's threshold input (BEHAVIOR.md 4 and 7).
///
/// Only the caller's *input* is converted, with exact factors. Response
/// values are never converted: to get other units, ask the server for them.
library;

import 'enums.dart';
import 'errors.dart';

enum _Kind { depth, temperature, height, speed }

_Kind _unitKind(Unit unit) {
  if (unit == Unit.mm || unit == Unit.inch) return _Kind.depth;
  if (unit == Unit.degC || unit == Unit.degF || unit == Unit.k) {
    return _Kind.temperature;
  }
  if (unit == Unit.m || unit == Unit.ft) return _Kind.height;
  if (unit == Unit.mPerS || unit == Unit.mph) return _Kind.speed;
  throw UsageException('unknown unit "${unit.value}"');
}

_Kind _variableKind(Variable variable) {
  if (variable == Variable.precipitation || variable == Variable.snowfall) {
    return _Kind.depth;
  }
  if (variable == Variable.temperature) return _Kind.temperature;
  if (variable == Variable.snowLevel) return _Kind.height;
  if (variable == Variable.windSpeed) return _Kind.speed;
  throw UsageException('unknown variable "${variable.value}"');
}

/// Throws a [UsageException] if [unit] cannot measure [variable].
void checkUnit(Variable variable, Unit unit) {
  if (_unitKind(unit) != _variableKind(variable)) {
    throw UsageException('${variable.value} cannot be given in ${unit.value}');
  }
}

/// The unit the server reads [variable] thresholds in, for [units].
Unit requestUnit(Variable variable, UnitSystem units) {
  final kind = _variableKind(variable);
  final imperial = units == UnitSystem.imperial;
  return switch (kind) {
    _Kind.depth => imperial ? Unit.inch : Unit.mm,
    _Kind.temperature =>
      imperial ? Unit.degF : (units == UnitSystem.kelvin ? Unit.k : Unit.degC),
    _Kind.height => imperial ? Unit.ft : Unit.m,
    _Kind.speed => imperial ? Unit.mph : Unit.mPerS,
  };
}

// Exact factors to the metric unit of each kind (BEHAVIOR.md 7).
double _toMetric(Unit unit) {
  if (unit == Unit.inch) return 25.4;
  if (unit == Unit.ft) return 0.3048;
  if (unit == Unit.mph) return 0.44704;
  return 1;
}

/// Converts a caller's threshold between two units of the same kind.
double convert(double value, Unit source, Unit target) {
  if (source == target) return value;
  if (_unitKind(source) == _Kind.temperature) {
    var celsius = value;
    if (source == Unit.degF) {
      celsius = (value - 32) * 5 / 9;
    } else if (source == Unit.k) {
      celsius = value - 273.15;
    }
    if (target == Unit.degF) return celsius * 9 / 5 + 32;
    if (target == Unit.k) return celsius + 273.15;
    return celsius;
  }
  final metric = value * _toMetric(source);
  return metric / _toMetric(target);
}

/// The number of decimals the server serves [variable] at.
int precision(Variable variable, UnitSystem units) {
  if (variable == Variable.precipitation || variable == Variable.snowfall) {
    return units == UnitSystem.imperial ? 3 : 2;
  }
  if (variable == Variable.snowLevel) return 0;
  return 1;
}

/// Rounds half away from zero on `value * 10^decimals` and prints it.
///
/// This is the server's own rounding, in IEEE-754 doubles: 0.0625 at 3
/// decimals is `0.063` (banker's rounding would give 0.062), and 1.005 at 2
/// decimals is `1.00` because 1.005 * 100 is 100.4999... A negative zero
/// prints as `0`.
String formatRounded(double value, int decimals) {
  if (!value.isFinite) {
    throw UsageException('threshold must be finite, got $value');
  }
  var scale = 1.0;
  for (var i = 0; i < decimals; i++) {
    scale *= 10;
  }
  final scaled = value * scale;
  var whole = BigInt.from(scaled.truncateToDouble());
  if ((scaled - scaled.truncateToDouble()).abs() >= 0.5) {
    whole += scaled > 0 ? BigInt.one : -BigInt.one;
  }
  if (decimals == 0) return whole.toString();
  final digits = whole.abs().toString().padLeft(decimals + 1, '0');
  final sign = whole.isNegative ? '-' : '';
  final cut = digits.length - decimals;
  return '$sign${digits.substring(0, cut)}.${digits.substring(cut)}';
}
