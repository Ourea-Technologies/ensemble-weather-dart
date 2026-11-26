// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

/// The official Dart SDK for the [Ourea](https://oureawx.com) probabilistic
/// weather API.
///
/// ```dart
/// import 'package:ensemble_weather/ensemble_weather.dart';
///
/// Future<void> main() async {
///   final client = OureaClient(); // no key: anonymous calls use the Free tier
///   final forecast = await client.getForecast(
///     'or/mt-hood-meadows',
///     prob: [Chance.atLeast(Variable.snowfall, 6, unit: Unit.inch)],
///   );
///   print(forecast.probabilities.first.value);
///   client.close();
/// }
/// ```
///
/// Every forecast value is a distribution ([Quantiles]) computed by the
/// server from the full ensemble; ask for probabilities with [Chance] and
/// storm totals with [Total]. Everything the SDK throws is an
/// [OureaException]. Pure Dart: it runs on the VM and in Flutter on every
/// platform, including the web.
library;

export 'src/cache.dart'
    show
        Cache,
        CacheEntry,
        MemoryCache,
        NoCache,
        defaultCacheBytes,
        defaultCacheEntries;
export 'src/client.dart'
    show
        BBox,
        DeprecationNotice,
        ExplorePoints,
        LatLon,
        Members,
        OureaClient,
        SortOrder,
        defaultBaseUrl,
        defaultMaxRetries,
        defaultTimeout,
        maxBodyBytes,
        maxRedirects,
        userAgent;
export 'src/enums.dart';
export 'src/errors.dart' hide apiException, isKnownErrorCode;
export 'src/model_base.dart' hide attachMeta;
export 'src/probabilities.dart' show Chance, Total, Window, maxWindowHours;
export 'src/types.dart' hide bindChance, bindTotal;
export 'src/version.dart';
