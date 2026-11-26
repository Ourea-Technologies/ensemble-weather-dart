// Catching errors by category or code, and reading the rate-limit state.

import 'package:ensemble_weather/ensemble_weather.dart';

Future<void> main() async {
  final client = OureaClient();
  try {
    // Coordinates outside the forecast domain (CONUS).
    try {
      await client.getPointForecast(45.0, 10.0);
    } on OutsideCoverageException catch (e) {
      print('outside coverage: ${e.code}: ${e.message}');
    } on PermissionDeniedException catch (e) {
      // No Pro key: PRO_REQUIRED comes first.
      print('needs Pro: ${e.code}: ${e.message}');
    }

    // A refused coordinate request may name a nearby location that needs no
    // key.
    try {
      await client.getPointForecast(45.33, -121.67);
    } on PermissionDeniedException catch (e) {
      final near = e.nearestLocation;
      if (near != null) {
        print('try ${near.url} (${near.slug}, ${near.distanceKm} km away) '
            'without a key');
      }
    } on OutsideCoverageException {
      // Not reached with a Pro key inside the domain.
    }

    // Any API error carries the status, the code (verbatim) and a request id.
    try {
      await client.getForecast('or/no-such-place');
    } on NotFoundException catch (e) {
      print('${e.status} ${e.code}: ${e.message} (request id ${e.requestId})');
      print('see ${e.docUrl}');
    } on RateLimitException catch (e) {
      print('rate limited; retry after ${e.retryAfter}');
    } on ApiException catch (e) {
      print('API error ${e.status} ${e.code}');
    }

    // Rate-limit state is what the server reported on the last response. It
    // is absent on anonymous responses the edge may share between callers.
    final forecast = await client.getForecast('or/mt-hood-meadows');
    final limit = forecast.rateLimit ?? client.rateLimit;
    if (limit == null) {
      print('rate limit: not reported on this (edge-cacheable) response');
    } else {
      print('rate limit: ${limit.remaining} of ${limit.limit} left, '
          'resets in ${limit.reset} s');
    }
  } finally {
    client.close();
  }
}
