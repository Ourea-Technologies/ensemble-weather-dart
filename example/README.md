# Examples

Each file is a complete program: `dart run example/<name>.dart`. They need no
API key except `point_forecast.dart` (a Pro key in `OUREA_API_KEY`; without
one it says so and exits).

| Example | Shows |
|---|---|
| [`quickstart.dart`](quickstart.dart) | an anonymous forecast: the next 24 h's temperature range and the chance of 6 in of snow |
| [`point_forecast.dart`](point_forecast.dart) | a forecast at coordinates and an elevation (Pro) |
| [`chance_of_snow.dart`](chance_of_snow.dart) | several `prob` terms in one call, with windows and member counts |
| [`storm_total.dart`](storm_total.dart) | `totals` window distributions for precipitation and snowfall |
| [`search_and_catalog.dart`](search_and_catalog.dart) | search, then page through the catalog with the cursor |
| [`current_and_alerts.dart`](current_and_alerts.dart) | current conditions and active alerts for a location |
| [`error_handling.dart`](error_handling.dart) | catching errors by category or code; reading rate-limit state |
| [`units.dart`](units.dart) | the same forecast in metric and imperial |
| [`snow_report.dart`](snow_report.dart) | `explore` rankings, a season to date, and the run-by-run snow trend |
