# ensemble_weather

Official Dart SDK for the [Ourea](https://oureawx.com) probabilistic weather API.

[![CI](https://github.com/Ourea-Technologies/ensemble-weather-dart/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/Ourea-Technologies/ensemble-weather-dart/actions/workflows/ci.yml)
[![Security](https://github.com/Ourea-Technologies/ensemble-weather-dart/actions/workflows/security.yml/badge.svg?branch=main)](https://github.com/Ourea-Technologies/ensemble-weather-dart/actions/workflows/security.yml)
[![pub.dev](https://img.shields.io/pub/v/ensemble_weather)](https://pub.dev/packages/ensemble_weather)
[![Dart SDK](https://img.shields.io/badge/dart-%3E%3D3.6-blue)](https://pub.dev/packages/ensemble_weather)
[![Licence: BSD-2-Clause](https://img.shields.io/badge/licence-BSD--2--Clause-blue)](LICENSE)
[![Docs](https://img.shields.io/badge/docs-pub.dev-blue)](https://pub.dev/documentation/ensemble_weather/latest/)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/Ourea-Technologies/ensemble-weather-dart/badge)](https://scorecard.dev/viewer/?uri=github.com/Ourea-Technologies/ensemble-weather-dart)

Pure Dart, async/await, typed models for every response. It runs on the
Dart VM and in Flutter on every platform: Android, iOS, macOS, Windows,
Linux and the web.

## Install

```sh
dart pub add ensemble_weather
```

(In a Flutter app: `flutter pub add ensemble_weather`.)

## Quickstart

No signup and no API key: anonymous calls use the Free tier.

```dart
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
```

This is [`example/quickstart.dart`](example/quickstart.dart); CI runs it.

## Authentication

Pass a key to the constructor, or set `OUREA_API_KEY`:

```sh
export OUREA_API_KEY=ow_...   # or: OureaClient(apiKey: 'ow_...')
```

On the web there is no process environment: pass the key, or pass
`environment:` (for example the map your app loads its configuration into).

- **Anonymous** (no key): forecasts, current conditions and alerts for named
  locations at the Free tier (10-day horizon, latest run, the members'
  plume view), plus search and the catalog.
- **Free key**: the same, with your own rate-limit budget.
- **Plus key**: adds the run-by-run snow trend (`getSnowTrend`).
- **Pro key**: the 15-day horizon, forecasts and current conditions at any
  coordinates (`getPointForecast`, `getPointCurrent`), every member variable,
  per-model breakdowns and historical runs.

See [pricing](https://oureawx.com/pricing). The key is sent only as
`X-API-Key`, only to the API's own origin, and never on the open routes
(search, catalog detail, attribution, composition), so those share the edge
cache with everyone; pass `sendKeyOnOpenRoutes: true` to attribute every
request to your key. The key never appears in errors or `toString()`. Do
not ship a paid key inside a public app: anything in an app binary can be
read.

## Probabilities, not single numbers

Every forecast value is a distribution (`Quantiles`) computed by the server
from the full ensemble. Ask for a **chance** of crossing a threshold:

```dart
final forecast = await client.getForecast('or/mt-hood-meadows', prob: [
  // P(0-72 h snowfall >= 12 in)
  Chance.atLeast(Variable.snowfall, 12, unit: Unit.inch, window: Window.hours(72)),
  // P(the temperature stays at or below 32 °F for all of hours 6-18)
  Chance.atMost(Variable.temperature, 32,
      unit: Unit.degF, window: Window(6, 18), aggregation: Aggregation.all),
]);
for (final p in forecast.probabilities) {
  // In your order, each with its reference class.
  print('${p.variable} ${p.op} ${p.threshold} ${p.window} ${p.aggregation} '
      '${p.value} ${p.members}');
}
```

For a **storm total**, ask for the window total's distribution:

```dart
final storm = await client.getForecast('or/mt-hood-meadows',
    totals: [Total(TotalVariable.snowfall, window: Window.hours(72))]);
final total = storm.windowTotals.first.quantiles; // null (see nullReason) when not covered
```

Read **quantiles** directly; `median` is the p50, not "the forecast":

```dart
final temp = forecast.series.timeseries.first.ensemble.temperature;
print('${temp.p10} ${temp.median} ${temp.p90} ${temp.range(25, 75)}');
```

The SDK never sums, averages or interpolates quantiles, and never derives a
probability from them: the sum of hourly medians is not the median total.
A threshold you give in another unit is converted exactly into the
request's units before sending; response values are never converted. More in
[Probabilities](https://docs.oureawx.com/concepts/probabilities).

## Names that differ from the API's JSON

Fields are the JSON names in Dart's lowerCamelCase (`valid_time` is
`validTime`). A JSON field that repeats a word of the type holding it would
read twice (`forecast.forecast`, `current.current`), so the SDK names it
differently. There is one table for every Ourea SDK (ensemble-weather-spec
BEHAVIOR.md 3.0). The decoder maps the names, each field's documentation
starts with its JSON name, and `toJson()` writes the JSON names back. Two
more fields are named for Dart, whose keywords they are: `class` is
`alertClass` and `default` is `isDefault`. The GeoJSON routes
(`getAlertOutlines`, `getAvalancheZones`) are otherwise untouched: an
avalanche zone's `properties.forecast_url` is `forecastUrl`, and
`toJson()` gives the API's own keys back for a map library.

| Type | JSON field | SDK field |
|---|---|---|
| `ForecastResponse` | `forecast` | `series` |
| `ForecastResponse` | `elevation_forecasts` | `elevations` |
| `CurrentResponse` | `current` | `now` |
| `CurrentConditions` | `condition` | `code` |
| `CurrentConditions` | `condition_text` | `text` |
| `CurrentConditions` | `condition_icon` | `icon` |
| `CurrentConditions.station` | `station_id` | `id` |
| `ProbabilityResult` | `probability` | `value` |
| `ProbabilityThresholds` | `daily_precipitation_probability` | `dailyPrecipitation` |
| `ProbabilityThresholds` | `daily_precipitation_occurrence_probability` | `dailyPrecipitationOccurrence` |
| `ProbabilityThresholds` | `daily_snow_probability` | `dailySnow` |
| `WindowTotal` | `window_start_hours` | `startHours` |
| `WindowTotal` | `window_end_hours` | `endHours` |
| `TimeSeriesPoint.members[]` (a model's members) | `members` | `items` |
| `MemberForecast` | `member_id` | `id` |
| `MemberPlume` | `members` | `pool` |
| `AlertsResponse` | `alerts` | `items` |
| `AlertsResponse` | `alert_count` | `count` |
| `LocationsResponse` | `locations` | `items` |
| `NearbyLocationsResponse` | `location` | `origin` |
| `NearbyLocationsResponse` | `locations` | `items` |
| `NearbyPointResponse` | `locations` | `items` |
| `RunsResponse` | `runs` | `items` |
| `ElevationForecast`, `ElevationSummary`, `SnowTrendResponse.elevation` | `elevation` | `height` |
| `PublicCatalogElevation` | `elevation_m` | `heightM` |
| `PublicCatalogStation`, `PublicCatalogStationDetail` | `source_station_id` | `sourceId` |
| `PublicCatalogStation`, `PublicCatalogStationDetail` | `station_status` | `status` |
| `PublicCatalogStation`, `PublicCatalogStationDetail` | `station_url` | `url` |
| `PublicCatalogNearbyStation` | `station_status` | `status` |
| `CatalogTemplateSummary` | `template_variant` | `variant` |
| `CatalogResolvedEntry` | `resolved_locale` | `locale` |
| `SensorObservation` | `observation_time` | `observedAt` |
| `PassHour` | `snow_level_above_pass` | `snowLevelMargin` |
| `PassStatusSegment` | `status` | `state` |
| `PassStatusSegment` | `status_text` | `text` |
| `AvalancheForecast` | `forecast_url` | `url` |
| `SeasonTotal` | `total` | `amount` |
| `SnowTrendDay` | `snow` | `amount` |
| `ErrorResponse` | `error` | `ApiException.code` |

## Every route

| Method (on `OureaClient`) | Route | Access |
|---|---|---|
| `getForecast`, `getPointForecast` | a named location's forecast; one at coordinates | anonymous; Pro |
| `getCurrent`, `getPointCurrent` | current conditions (a mountain pass also gets `pass`) | anonymous; Pro |
| `getAlerts`, `getPointAlerts` | active alerts | anonymous; Pro |
| `getNearby`, `getPointNearby` | nearby locations | anonymous |
| `searchLocations` | search by name, optionally `sort` by a metric and `near` a point | anonymous |
| `explore`, `iterateExplore` | places ranked by a metric (`snow5d`, `baseDepth`, `seasonPrecip`, ...) | anonymous |
| `getSeason` | observed season-to-date precipitation and snowfall | anonymous |
| `getSnowTrend` | each recent run's daily snowfall, run by run | Plus or Pro |
| `getSnowpack`, `getSnowpackPlume` | the modelled snowpack and its snow-depth plume (beta) | anonymous |
| `getAlertOutlines`, `getAvalancheZones` | GeoJSON for maps: alert outlines, avalanche zones and ratings | anonymous |
| `listLocations`, `iterateLocations` | every location, paged | anonymous |
| `listCatalogLocations`, `iterateCatalogLocations`, `getCatalogLocation`, `listCatalogStations`, `iterateCatalogStations`, `getCatalogStation` | the catalog | anonymous |
| `getRuns`, `iterateRuns`, `getComposition`, `getAttribution` | served runs, the blend's models and members, data credits | anonymous |

The `iterate*` methods return a lazy `Stream` that follows `nextCursor`.
`members: Members.plume` on a forecast returns the plume view: columns in
`series.plume`, ready to draw.

## More examples

| Example | Shows |
|---|---|
| [`quickstart.dart`](example/quickstart.dart) | the program above, anonymous |
| [`point_forecast.dart`](example/point_forecast.dart) | a forecast at coordinates and an elevation (Pro key from `OUREA_API_KEY`) |
| [`chance_of_snow.dart`](example/chance_of_snow.dart) | several `prob` terms in one call, with windows and member counts |
| [`storm_total.dart`](example/storm_total.dart) | `totals` window distributions for precipitation and snowfall |
| [`search_and_catalog.dart`](example/search_and_catalog.dart) | search, then page through the catalog with the cursor |
| [`current_and_alerts.dart`](example/current_and_alerts.dart) | current conditions and active alerts for a location |
| [`error_handling.dart`](example/error_handling.dart) | catching an out-of-coverage error, the keyless alternative to `PRO_REQUIRED`; reading rate-limit state |
| [`units.dart`](example/units.dart) | the same forecast in metric and imperial |
| [`snow_report.dart`](example/snow_report.dart) | `explore` rankings, a season to date, and the run-by-run snow trend |

## Errors, retries and rate limits

Everything the SDK throws is an `OureaException` (a sealed class, so a
`switch` can be exhaustive). HTTP errors are `ApiException`s with `status`,
`code` (the API's string, verbatim), `message`, `requestId` and `docUrl`, in
one subclass per category: `AuthenticationException`,
`PermissionDeniedException`, `NotFoundException`, `InvalidRequestException`,
`OutsideCoverageException`, `RateLimitException` (with `retryAfter`) and
`UnavailableException`. With no response at all you get
`ApiConnectionException`; a call refused before sending (an invalid term, say)
fails with `UsageException`.

```dart
try {
  await client.getPointForecast(45.0, 10.0);
} on OutsideCoverageException catch (e) {
  print('${e.code}: ${e.message}');
}
```

Connection errors, 429, 502, 503 and 504 are retried up to `maxRetries`
(default 2) with full-jitter backoff, honouring `Retry-After` (on 429, 503
and 504) up to 60 s. Nothing else is retried. The rate-limit state the
server reported is on `result.rateLimit` and `client.rateLimit` (`limit`,
`remaining`, `reset`, `policy`); the SDK never hard-codes limits.

Responses are cached locally by `ETag` (in memory, 256 entries / 32 MiB) and
revalidated on every call, so an unchanged forecast costs a `304`. Pass
`cache: const NoCache()` to disable it, or your own `Cache` to share one.

## Documentation

- Guides: https://docs.oureawx.com
- This SDK's guide: https://docs.oureawx.com/dart
- API reference: https://pub.dev/documentation/ensemble_weather/latest/
- The OpenAPI contract: [ensemble-weather-spec](https://github.com/Ourea-Technologies/ensemble-weather-spec/blob/main/openapi/v1/openapi.yaml)
  (a pinned copy is in [`spec/`](spec/))

This SDK targets API contract **v1**.

## Supported versions

Dart 3.6 and later (CI tests 3.6, the current stable and beta on Linux, and
stable on macOS and Windows), and Flutter releases that ship one of those
Dart versions. The one runtime dependency is
[`http`](https://pub.dev/packages/http), the Dart team's HTTP client, which
works on every platform.

On the web the browser follows redirects itself and sets its own
User-Agent, so the SDK's redirect rules (at most 5, the key dropped on
another host) and User-Agent apply on the VM and in Flutter on mobile and
desktop.

## Contributing and community

This SDK is open source and we want it to be the best weather SDK in Dart
and Flutter. Bug reports, feature requests, docs fixes and pull requests are
all welcome, including small ones.

- **Report a bug**: [the bug form](https://github.com/Ourea-Technologies/ensemble-weather-dart/issues/new?template=bug_report.yml).
- **Request a feature** or an API capability: [the feature form](https://github.com/Ourea-Technologies/ensemble-weather-dart/issues/new?template=feature_request.yml).
- **Ask a question or share what you built**: [GitHub Discussions](https://github.com/Ourea-Technologies/ensemble-weather-dart/discussions).
- **Contribute code or docs**: [CONTRIBUTING.md](CONTRIBUTING.md) and the
  [`good first issue`](https://github.com/Ourea-Technologies/ensemble-weather-dart/labels/good%20first%20issue) label.
- **Security issues**: never in public issues; see [SECURITY.md](SECURITY.md).

Licence: [BSD-2-Clause](LICENSE), Copyright (c) 2026 Ourea Technologies.
