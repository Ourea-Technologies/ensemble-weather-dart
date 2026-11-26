# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html). The SDK
version is independent of the API version; this release targets API
contract v1.

## [Unreleased]

## [0.1.0] - unreleased

The first release on pub.dev. Targets the v1 contract at
ensemble-weather-spec 7954268 (the server's public spec at 256cd770, byte
for byte).

### Added

- `OureaClient`: one async method per API operation (BEHAVIOR.md 3), in
  pure Dart on the `http` package, so it runs on the Dart VM and in Flutter
  on every platform, including the web.
  - Forecasts: `getForecast` (a named location, anonymous) and
    `getPointForecast` (coordinates and an elevation, Pro), with `prob`
    terms (`Chance`), window totals (`Total`), `members` (`Members.all` or
    the plume view, `Members.plume`), per-model breakdowns, extra
    elevations, historical runs and the nowcast options.
  - `getCurrent` / `getPointCurrent` (a mountain pass also gets `pass`),
    `getAlerts` / `getPointAlerts`, `getNearby` / `getPointNearby`.
  - `searchLocations` with `sort` by an `ExploreMetric`, `order`, `near` and
    `radiusKm`; `explore` and `iterateExplore` (places ranked by a metric).
  - `getSeason`, `getSnowTrend` (Plus or Pro), `getSnowpack` and
    `getSnowpackPlume` (beta), `getComposition`, `getAttribution`, and the
    GeoJSON routes `getAlertOutlines` and `getAvalancheZones`.
  - Paging: `listLocations`, `listCatalogLocations`, `listCatalogStations`,
    `getRuns` and `explore` return one page; `iterateLocations`,
    `iterateCatalogLocations`, `iterateCatalogStations`, `iterateRuns` and
    `iterateExplore` are lazy `Stream`s that follow `nextCursor`.
- Typed, immutable models for every schema in the spec, with `fromJson`
  and `toJson`; open enumerations that keep unknown values; `Quantiles`
  with `median` and `range` (served pairs only, no interpolation).
- The canonical request form (BEHAVIOR.md 3.1): defaults omitted, sorted
  parameters, RFC 3986 encoding, literal commas in comma lists, `near` and
  `bbox`, the shortest round-trip numbers, thresholds converted with exact
  factors and rounded half away from zero as the server does.
- The open routes are sent without the key (BEHAVIOR.md 3.2);
  `sendKeyOnOpenRoutes` sends it everywhere.
- Retries with full jitter and `Retry-After` (at most 60 s), same-host
  redirects (the key dropped on any other origin), a 64 MiB body bound, an
  in-memory ETag cache (256 entries / 32 MiB) behind a pluggable `Cache`,
  deprecation notices once per operation, and the rate-limit state.
- One exception hierarchy, `OureaException` (sealed), with a subclass per
  BEHAVIOR.md 8 category; `PLUS_REQUIRED` is a `PermissionDeniedException`.
- JSON fields that repeat a word of their own type have SDK names
  (BEHAVIOR.md 3.0, one table for every Ourea SDK). The decoder maps them,
  and `toJson()` writes the JSON names back.
- All 58 shared vectors, a spec-drift test against the pinned spec, nine
  examples run against a local stub server, and a nightly live contract run.
