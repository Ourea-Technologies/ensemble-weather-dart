// Quickstart: an anonymous forecast for Mt. Hood Meadows, with no API key.
//
// Prints each of the next 24 hours' temperature as a range (p10-p90) and the
// chance of at least 6 in (15 cm) of snow in the next 24 hours.

import 'package:ensemble_weather/ensemble_weather.dart';

Future<void> main() async {
  final client = OureaClient(); // no key: anonymous calls use the Free tier
  try {
    final forecast = await client.getForecast(
      'or/mt-hood-meadows',
      units: UnitSystem.imperial,
      prob: [
        Chance.atLeast(Variable.snowfall, 6, unit: Unit.inch)
      ], // the next 24 h
    );

    print(forecast.location.name);
    for (final hour in forecast.series.timeseries.take(24)) {
      final temp = hour.ensemble.temperature;
      print(
          '${hour.validTime.toUtc()}  ${temp.p10} to ${temp.p90} °F (p10-p90)');
    }

    final snow = forecast.probabilities.first;
    final chance = snow.value == null
        ? 'not available'
        : '${(snow.value! * 100).round()}%';
    print('Chance of at least 6 in of snow in the next 24 h: '
        '$chance (${snow.members} members)');
  } finally {
    client.close();
  }
}
