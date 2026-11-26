// Current conditions and active alerts for a named location.

import 'package:ensemble_weather/ensemble_weather.dart';

Future<void> main() async {
  final client = OureaClient();
  try {
    final current = await client.getCurrent('or/mt-hood-meadows');
    final alerts = await client.getAlerts('or/mt-hood-meadows');
    final now = current.now;
    if (now == null) {
      print('No current conditions are served right now.');
    } else {
      print('${current.location.name} at ${now.time.toUtc()}: '
          '${now.text}, ${now.temperature} °C');
      print('wind ${now.windSpeed} m/s from ${now.windDirection}°, '
          'source: ${now.source}');
    }
    print('${alerts.count} active alert(s)');
    for (final alert in alerts.items) {
      print('- ${alert.event} (${alert.severity}, ${alert.certainty}): '
          '${alert.headline}');
    }
  } finally {
    client.close();
  }
}
