// Several probability terms in one call, each with its window and member
// count.
//
// The server computes every probability from the full ensemble; the SDK only
// asks. Results come back in the order you asked, whatever order is sent.

import 'package:ensemble_weather/ensemble_weather.dart';

Future<void> main() async {
  final terms = [
    Chance.atLeast(Variable.snowfall, 6, unit: Unit.inch), // the next 24 h
    Chance.atLeast(Variable.snowfall, 12,
        unit: Unit.inch, window: Window.hours(72)), // the next 72 h
    Chance.atMost(Variable.temperature, 32,
        unit: Unit.degF, window: Window(6, 18), aggregation: Aggregation.all),
    Chance.atLeast(Variable.windSpeed, 15,
        unit: Unit.mPerS, window: Window(12, 36)),
  ];
  final client = OureaClient();
  try {
    final forecast =
        await client.getForecast('or/mt-hood-meadows', prob: terms);
    for (final result in forecast.probabilities) {
      final value = result.value;
      final chance = value == null ? 'n/a' : '${(value * 100).round()}%';
      print('P(${result.variable} ${result.op} ${result.threshold} '
          '(${forecast.units} units), '
          '${result.windowStartHours}-${result.windowEndHours} h, '
          '${result.aggregation}) = $chance from ${result.members} members');
    }
  } finally {
    client.close();
  }
}
