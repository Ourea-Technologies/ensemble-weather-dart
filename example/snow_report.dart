// Where is it snowing? Rank places, then read one place's season and snow
// trend.
//
// `explore` ranks places by a metric the server computes (here the next five
// days' snowfall); `getSeason` is the observed season to date; `getSnowTrend`
// (Plus or Pro) shows each recent run's daily snowfall, so you can see a
// storm firm up or fade. Anonymous and Free callers get the first two.

import 'package:ensemble_weather/ensemble_weather.dart';

Future<void> main() async {
  final client = OureaClient(units: UnitSystem.imperial);
  try {
    final ranked = await client.explore(ExploreMetric.snow5d, limit: 5);
    print('Most snow in the next 5 days (${ranked.unit}):');
    for (final item in ranked.items) {
      final low = item.p10;
      final high = item.p90;
      final range = low == null || high == null
          ? ''
          : ' (${low.toStringAsFixed(1)} to ${high.toStringAsFixed(1)})';
      print('  ${item.rank}. ${item.location.name}, '
          '${item.location.state.toUpperCase()}: '
          '${item.value.toStringAsFixed(1)}$range');
    }

    final season = await client.getSeason('or/mt-hood-meadows');
    print('\nWater year ${season.waterYear} at ${season.location.name}, '
        'through ${season.through.toUtc()}:');
    final total = season.precipitation;
    if (total != null) {
      final pct = total.percentOfNormal;
      print('  precipitation ${total.amount} ${total.unit}'
          '${pct == null ? '' : ', $pct% of normal'}');
    }

    try {
      final trend = await client.getSnowTrend('or/mt-hood-meadows');
      final grid = trend.grids.first;
      final newest = grid.runs.last;
      print('\nSnow trend (${grid.source}), newest run '
          '${newest.initializedAt.toUtc()}:');
      for (final day in newest.days) {
        if (day != null) print('  ${day.date.toUtc()}: ${day.amount}');
      }
    } on PermissionDeniedException {
      print('\nThe snow trend is part of Plus and Pro (set OUREA_API_KEY).');
    }
  } finally {
    client.close();
  }
}
