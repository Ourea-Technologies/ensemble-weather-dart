// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

// A short read-only contract run against the live API (nightly live.yml
// only). It talks to OUREA_BASE_URL (default https://api.oureawx.com) with
// the key in OUREA_API_KEY. Never run it from tests or pull requests.

import 'dart:io';

import 'package:ensemble_weather/ensemble_weather.dart';

void check(bool ok, String what) {
  if (!ok) throw StateError('live contract: $what');
}

Future<void> main() async {
  final client = OureaClient(appUserAgent: 'ensemble-weather-ci/live');
  try {
    final forecast = await client.getForecast(
      'or/mt-hood-meadows',
      prob: [
        Chance.atLeast(Variable.snowfall, 6, unit: Unit.inch),
        Chance.atMost(Variable.temperature, 0),
      ],
      totals: [Total(TotalVariable.snowfall, window: Window.hours(72))],
    );
    check(forecast.location.slug == 'mt-hood-meadows', 'forecast location');
    check(forecast.probabilities.length == 2, 'two probabilities');
    check(forecast.windowTotals.length == 1, 'one window total');
    check(
        forecast.probabilities.every((p) => p.term.isNotEmpty), 'terms echoed');
    check(forecast.series.timeseries.isNotEmpty, 'hourly series');
    final hits = await client.searchLocations('hood meadows');
    check(hits.items.any((h) => h.slug == 'mt-hood-meadows'), 'search');
    check((await client.listCatalogLocations(limit: 5)).items.isNotEmpty,
        'catalog');
    check((await client.getAttribution()).providers.isNotEmpty, 'attribution');
    await client.getCurrent('or/mt-hood-meadows');
    await client.getAlerts('or/mt-hood-meadows');
    await client.getRuns(limit: 2);
    await client.listCatalogStations(
        limit: 2); // may be empty: the shape is checked
    // The routes added with spec 7954268 (server 256cd770).
    final plume = await client.getForecast('or/mt-hood-meadows',
        members: Members.plume, maxHours: 12);
    check(plume.series.plume != null, 'plume view');
    final ranked = await client.explore(ExploreMetric.snow5d, limit: 3);
    check(ranked.items.isNotEmpty && ranked.items.first.rank == 1, 'explore');
    final sorted = await client.searchLocations('hood',
        sort: ExploreMetric.snow5d, near: (lat: 45.33, lon: -121.66));
    check(sorted.items.any((h) => h.explore != null), 'metric search');
    check((await client.getComposition()).totalMembers > 0, 'composition');
    check((await client.getSeason('or/mt-hood-meadows')).waterYear >= 2027,
        'season');
    check((await client.getSnowpack('or/mt-hood-meadows')).beta, 'snowpack');
    check((await client.getSnowpackPlume('or/mt-hood-meadows')).beta,
        'snowpack plume');
    final outlines =
        await client.getAlertOutlines(classes: [AlertClass.winter]);
    check(outlines.type == 'FeatureCollection', 'alert outlines');
    check((await client.getAvalancheZones()).features.isNotEmpty,
        'avalanche zones');
    try {
      check((await client.getSnowTrend('or/mt-hood-meadows')).grids.isNotEmpty,
          'snow trend');
    } on PermissionDeniedException {
      // Plus or Pro; else PLUS_REQUIRED.
    }
    try {
      await client.getForecast('or/this-location-does-not-exist');
      check(false, 'an unknown location must be a NotFoundException');
    } on NotFoundException {
      // Expected.
    }
  } finally {
    client.close();
  }
  stdout.writeln('live contract: ok');
}
