// A forecast at coordinates and a chosen elevation (needs a Pro key).
//
// Reads the key from OUREA_API_KEY; without one it says so and exits 0.

import 'dart:io';

import 'package:ensemble_weather/ensemble_weather.dart';

Future<void> main() async {
  if ((Platform.environment['OUREA_API_KEY'] ?? '').isEmpty) {
    print(
        'point_forecast: set OUREA_API_KEY to a Pro key to run this example.');
    return;
  }
  final client = OureaClient();
  try {
    final forecast = await client.getPointForecast(45.3311, -121.6649,
        elevationM: 2000, maxHours: 48);
    final point = forecast.point;
    if (point != null) {
      print('Forecast at ${point.lat}, ${point.lon}, ${point.elevation} m '
          '(${point.elevationSource})');
    }
    for (final hour in forecast.series.timeseries) {
      final wind = hour.ensemble.windSpeed;
      print('${hour.validTime.toUtc()}  median wind ${wind.median} m/s, '
          'p90 ${wind.p90} m/s');
    }
  } finally {
    client.close();
  }
}
