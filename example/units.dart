// The same forecast in metric and imperial units.
//
// The server converts; the SDK never converts response values. Ask for the
// units you want to show.

import 'package:ensemble_weather/ensemble_weather.dart';

Future<void> main() async {
  final client = OureaClient();
  try {
    final metric = await client.getForecast('or/mt-hood-meadows');
    final imperial = await client.getForecast('or/mt-hood-meadows',
        units: UnitSystem.imperial);
    final hours = metric.series.timeseries;
    for (var i = 0;
        i < hours.length && i < imperial.series.timeseries.length;
        i++) {
      final m = hours[i];
      final f = imperial.series.timeseries[i];
      print('${m.validTime.toUtc()}  median ${m.ensemble.temperature.median} °C'
          ' = ${f.ensemble.temperature.median} °F');
    }
  } finally {
    client.close();
  }
}
