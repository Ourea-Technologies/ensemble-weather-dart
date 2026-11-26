// Window totals: the distribution of each member's storm total.
//
// Never add up hourly quantiles to get a total: the sum of hourly medians is
// not the median total. Ask the server for the window total instead.

import 'package:ensemble_weather/ensemble_weather.dart';

Future<void> main() async {
  final client = OureaClient();
  try {
    final forecast = await client.getForecast(
      'or/mt-hood-meadows',
      units: UnitSystem.imperial,
      totals: [
        Total(TotalVariable.snowfall, window: Window.hours(72)),
        Total(TotalVariable.precipitation, window: Window(24, 72)),
      ],
    );
    for (final total in forecast.windowTotals) {
      final span = '${total.startHours}-${total.endHours} h';
      final q = total.quantiles;
      if (q == null) {
        print('${total.variable} $span: no distribution (${total.nullReason})');
        continue;
      }
      print('${total.variable} $span: median ${q.median} in, '
          'p10-p90 ${q.range(10, 90)} in');
    }
  } finally {
    client.close();
  }
}
