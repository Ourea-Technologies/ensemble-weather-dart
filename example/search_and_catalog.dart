// Search for a location, then page through the catalog with the cursor.

import 'package:ensemble_weather/ensemble_weather.dart';

Future<void> main() async {
  final client = OureaClient();
  try {
    final hits = await client.searchLocations('hood meadows');
    for (final hit in hits.items) {
      print('${hit.key}: ${hit.name} (${hit.type}), ${hit.county} County');
    }
    if (hits.items.isNotEmpty) {
      final hit = hits.items.first; // any hit names a location
      final forecast = await client.getForecast(hit.state, slug: hit.slug);
      print('${forecast.location.name}: '
          '${forecast.series.timeseries.length} hours');
    }

    // The lazy stream follows nextCursor until the last page.
    await for (final entry in client.iterateCatalogLocations(limit: 20)) {
      print('catalog: ${entry.state}/${entry.slug} ${entry.name}');
    }

    // Or one page at a time:
    final page = await client.listCatalogLocations(limit: 20);
    print('first page: ${page.items.length} entries, '
        'next cursor ${page.nextCursor}');
  } finally {
    client.close();
  }
}
