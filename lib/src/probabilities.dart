// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

/// Probability terms (`prob=`) and window totals (`totals=`).
///
/// The server computes every probability and every window total from the
/// full ensemble. These classes only *describe* what to ask for; the SDK
/// never derives a probability from quantiles or sums hourly values (that
/// gives wrong answers: per-hour quantiles do not add up to a window total).
///
/// ```dart
/// final snow = Chance.atLeast(Variable.snowfall, 6, unit: Unit.inch);
/// final freeze = Chance.atMost(Variable.temperature, 32,
///     unit: Unit.degF, window: Window(6, 18), aggregation: Aggregation.all);
/// final storm = Total(TotalVariable.snowfall, window: Window.hours(72));
/// ```
library;

import 'enums.dart';
import 'errors.dart';
import 'units.dart';

/// The furthest hour a window may end at.
const int maxWindowHours = 360;

/// Hours [start] to [end] from the forecast's first served hour.
///
/// `Window(0, 24)` (or `Window.hours(24)`) is the first 24 hours. The end may
/// be at most [maxWindowHours].
final class Window {
  /// The hours [start] (inclusive) to [end] (exclusive).
  ///
  /// Throws a [UsageException] unless `0 <= start < end <= 360`.
  Window(this.start, this.end) {
    if (start < 0 || start >= end || end > maxWindowHours) {
      throw UsageException(
        'window must satisfy 0 <= start < end <= $maxWindowHours, '
        'got $start-$end h',
      );
    }
  }

  /// The first [hours] hours: `Window(0, hours)`.
  Window.hours(int hours) : this(0, hours);

  /// The window's first hour.
  final int start;

  /// The window's end hour.
  final int end;

  /// The window's length in hours.
  int get hours => end - start;

  /// The wire form: `24h`, or `6-18h` when it does not start at 0.
  String toQuery() => start == 0 ? '${end}h' : '$start-${end}h';

  @override
  bool operator ==(Object other) =>
      other is Window && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'Window($start, $end)';
}

T _known<T extends OpenEnum>(T value, String what, List<T> values) {
  if (value.isUnknown) {
    final allowed = values.map((v) => v.value).join(', ');
    throw UsageException(
      '"${value.value}" is not a valid $what; expected one of $allowed',
    );
  }
  return value;
}

bool _isAmount(Variable variable) =>
    variable == Variable.precipitation || variable == Variable.snowfall;

/// One probability term: the chance that [variable] [op] [threshold].
final class Chance {
  /// Builds and validates a term. Prefer [Chance.atLeast] and
  /// [Chance.atMost].
  ///
  /// With [unit], the SDK converts [threshold] to the request's units (exact
  /// factors); without, it is already in them. [window] defaults to the
  /// first 24 h. [aggregation] is `total` for precipitation and snowfall
  /// (their only, default, choice) and `any` (default) or `all` for the
  /// others; `null` means the variable's default.
  ///
  /// Throws a [UsageException] for an invalid term; nothing is sent.
  Chance(
    Variable variable,
    Op op,
    num threshold, {
    Unit? unit,
    Window? window,
    Aggregation? aggregation,
  }) : this._(
          _known(variable, 'variable', Variable.values),
          _known(op, 'op', Op.values),
          threshold.toDouble(),
          unit == null ? null : _known(unit, 'unit', Unit.values),
          window ?? Window(0, 24),
          aggregation == null
              ? null
              : _known(aggregation, 'aggregation', Aggregation.values),
        );

  Chance._(
    this.variable,
    this.op,
    this.threshold,
    this.unit,
    this.window,
    this.aggregation,
  ) {
    if (!threshold.isFinite) {
      throw UsageException('threshold must be finite, got $threshold');
    }
    final unit = this.unit;
    if (unit != null) checkUnit(variable, unit);
    final aggregation = this.aggregation;
    if (aggregation != null) {
      if (_isAmount(variable) && aggregation != Aggregation.total) {
        throw UsageException(
          '${variable.value} supports only aggregation "total", '
          'not "${aggregation.value}"',
        );
      }
      if (!_isAmount(variable) && aggregation == Aggregation.total) {
        throw UsageException(
          '${variable.value} supports aggregation "any" or "all", not "total"',
        );
      }
    }
  }

  /// The chance that [variable] is at least [threshold] (`ge`).
  Chance.atLeast(
    Variable variable,
    num threshold, {
    Unit? unit,
    Window? window,
    Aggregation? aggregation,
  }) : this(
          variable,
          Op.ge,
          threshold,
          unit: unit,
          window: window,
          aggregation: aggregation,
        );

  /// The chance that [variable] is at most [threshold] (`le`).
  Chance.atMost(
    Variable variable,
    num threshold, {
    Unit? unit,
    Window? window,
    Aggregation? aggregation,
  }) : this(
          variable,
          Op.le,
          threshold,
          unit: unit,
          window: window,
          aggregation: aggregation,
        );

  /// What to ask about.
  final Variable variable;

  /// `ge` (at least) or `le` (at most).
  final Op op;

  /// The threshold, in [unit] or else in the request's units.
  final double threshold;

  /// The threshold's unit, or `null` for the request's units.
  final Unit? unit;

  /// The hours the term covers.
  final Window window;

  /// The aggregation asked for, or `null` for the variable's default.
  final Aggregation? aggregation;

  /// The aggregation the server applies (the variable's default if unset).
  Aggregation get effectiveAggregation =>
      aggregation ??
      (_isAmount(variable) ? Aggregation.total : Aggregation.any);

  @override
  String toString() => 'Chance(variable: $variable, op: $op, '
      'threshold: $threshold, unit: $unit, window: $window, '
      'aggregation: $aggregation)';
}

/// One window total: the distribution of each member's total over a window.
///
/// This is the only storm total the SDK offers. Never add up hourly
/// quantiles instead: the sum of per-hour medians is not the median total.
final class Total {
  /// The [variable]'s total over [window] (default: the first 24 h).
  Total(TotalVariable variable, {Window? window})
      : variable = _known(variable, 'total variable', TotalVariable.values),
        window = window ?? Window(0, 24);

  /// `precipitation` or `snowfall`.
  final TotalVariable variable;

  /// The hours the total covers.
  final Window window;

  @override
  String toString() => 'Total(variable: $variable, window: $window)';
}

// --- wire form -----------------------------------------------------------

typedef _ChanceKey = (
  String variable,
  String op,
  String threshold,
  int start,
  int end,
  String aggregation,
);

_ChanceKey _chanceKey(Chance chance, UnitSystem units) {
  final target = requestUnit(chance.variable, units);
  var value = chance.threshold;
  final unit = chance.unit;
  if (unit != null) value = convert(value, unit, target);
  final threshold = formatRounded(value, precision(chance.variable, units));
  return (
    chance.variable.value,
    chance.op.value,
    threshold,
    chance.window.start,
    chance.window.end,
    chance.effectiveAggregation.value,
  );
}

String _windowQuery(int start, int end) =>
    start == 0 ? '${end}h' : '$start-${end}h';

String _chanceWire(_ChanceKey key) {
  final (variable, op, threshold, start, end, aggregation) = key;
  final text = '$variable:$op:$threshold:${_windowQuery(start, end)}';
  final amount = variable == 'precipitation' || variable == 'snowfall';
  final fallback = amount ? 'total' : 'any';
  return aggregation == fallback ? text : '$text:$aggregation';
}

const Map<String, int> _opOrder = {'ge': 0, 'le': 1};
const Map<String, int> _aggregationOrder = {'total': 0, 'any': 1, 'all': 2};

int _compareChance(_ChanceKey a, _ChanceKey b) {
  var c = a.$1.compareTo(b.$1);
  if (c != 0) return c;
  c = _opOrder[a.$2]!.compareTo(_opOrder[b.$2]!);
  if (c != 0) return c;
  c = a.$4.compareTo(b.$4);
  if (c != 0) return c;
  c = a.$5.compareTo(b.$5);
  if (c != 0) return c;
  c = _aggregationOrder[a.$6]!.compareTo(_aggregationOrder[b.$6]!);
  if (c != 0) return c;
  return double.parse(a.$3).compareTo(double.parse(b.$3));
}

/// The canonical `prob=` value, and each caller term's canonical spelling in
/// order (SDK-internal).
///
/// The server echoes that spelling as `ProbabilityResult.term`, so results
/// are matched to the caller's terms by it (BEHAVIOR.md 4).
(String, List<String>) probQuery(List<Chance> chances, UnitSystem units) {
  final keys = [for (final c in chances) _chanceKey(c, units)];
  final unique = keys.toSet().toList()..sort(_compareChance);
  return (
    unique.map(_chanceWire).join(','),
    [for (final k in keys) _chanceWire(k)],
  );
}

/// The canonical `totals=` value, and each caller request's canonical
/// spelling (SDK-internal; BEHAVIOR.md 5).
(String, List<String>) totalsQuery(List<Total> totals) {
  final keys = [
    for (final t in totals) (t.variable.value, t.window.start, t.window.end),
  ];
  final unique = keys.toSet().toList()
    ..sort((a, b) {
      var c = a.$1.compareTo(b.$1);
      if (c != 0) return c;
      c = a.$2.compareTo(b.$2);
      return c != 0 ? c : a.$3.compareTo(b.$3);
    });
  String wire((String, int, int) k) => '${k.$1}:${_windowQuery(k.$2, k.$3)}';
  return (unique.map(wire).join(','), [for (final k in keys) wire(k)]);
}
