// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

/// The enumerations used by requests and responses.
///
/// Every enumeration is *open*: a value the API adds after this SDK was
/// released decodes to an "unknown" value that keeps the raw string, instead
/// of failing. Check [OpenEnum.isUnknown] before relying on a value's
/// identity:
///
/// ```dart
/// if (hit.type?.isUnknown ?? false) print('new location type: ${hit.type}');
/// ```
library;

import 'open_enum.dart';

export 'open_enum.dart';

/// How a probability term combines the hours of its window.
///
/// `total` (the window total) is the only one for precipitation and snowfall.
/// `any` (at some hour, the default) and `all` (at every hour) are for the
/// other variables.
final class Aggregation extends OpenEnum {
  const Aggregation._(super.value) : super.known();
  const Aggregation._unknown(super.value) : super.unknown();

  /// The [Aggregation] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory Aggregation(String value) =>
      _byValue[value] ?? Aggregation._unknown(value);

  /// `total`.
  static const total = Aggregation._('total');

  /// `any`.
  static const any = Aggregation._('any');

  /// `all`.
  static const all = Aggregation._('all');

  /// Every value this SDK version knows, in the API's order.
  static const values = <Aggregation>[
    total,
    any,
    all,
  ];

  static final Map<String, Aggregation> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The certainty of a weather alert (CAP).
final class AlertCertainty extends OpenEnum {
  const AlertCertainty._(super.value) : super.known();
  const AlertCertainty._unknown(super.value) : super.unknown();

  /// The [AlertCertainty] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory AlertCertainty(String value) =>
      _byValue[value] ?? AlertCertainty._unknown(value);

  /// `observed`.
  static const observed = AlertCertainty._('observed');

  /// `likely`.
  static const likely = AlertCertainty._('likely');

  /// `possible`.
  static const possible = AlertCertainty._('possible');

  /// `unlikely`.
  static const unlikely = AlertCertainty._('unlikely');

  /// `unknown`.
  static const unknown = AlertCertainty._('unknown');

  /// Every value this SDK version knows, in the API's order.
  static const values = <AlertCertainty>[
    observed,
    likely,
    possible,
    unlikely,
    unknown,
  ];

  static final Map<String, AlertCertainty> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The class of an alert outline: `winter` or `wind`.
final class AlertClass extends OpenEnum {
  const AlertClass._(super.value) : super.known();
  const AlertClass._unknown(super.value) : super.unknown();

  /// The [AlertClass] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory AlertClass(String value) =>
      _byValue[value] ?? AlertClass._unknown(value);

  /// `wind`.
  static const wind = AlertClass._('wind');

  /// `winter`.
  static const winter = AlertClass._('winter');

  /// Every value this SDK version knows, in the API's order.
  static const values = <AlertClass>[
    wind,
    winter,
  ];

  static final Map<String, AlertClass> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The severity of a weather alert (CAP).
final class AlertSeverity extends OpenEnum {
  const AlertSeverity._(super.value) : super.known();
  const AlertSeverity._unknown(super.value) : super.unknown();

  /// The [AlertSeverity] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory AlertSeverity(String value) =>
      _byValue[value] ?? AlertSeverity._unknown(value);

  /// `extreme`.
  static const extreme = AlertSeverity._('extreme');

  /// `severe`.
  static const severe = AlertSeverity._('severe');

  /// `moderate`.
  static const moderate = AlertSeverity._('moderate');

  /// `minor`.
  static const minor = AlertSeverity._('minor');

  /// `unknown`.
  static const unknown = AlertSeverity._('unknown');

  /// Every value this SDK version knows, in the API's order.
  static const values = <AlertSeverity>[
    extreme,
    severe,
    moderate,
    minor,
    unknown,
  ];

  static final Map<String, AlertSeverity> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The urgency of a weather alert (CAP).
final class AlertUrgency extends OpenEnum {
  const AlertUrgency._(super.value) : super.known();
  const AlertUrgency._unknown(super.value) : super.unknown();

  /// The [AlertUrgency] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory AlertUrgency(String value) =>
      _byValue[value] ?? AlertUrgency._unknown(value);

  /// `immediate`.
  static const immediate = AlertUrgency._('immediate');

  /// `expected`.
  static const expected = AlertUrgency._('expected');

  /// `future`.
  static const future = AlertUrgency._('future');

  /// `past`.
  static const past = AlertUrgency._('past');

  /// `unknown`.
  static const unknown = AlertUrgency._('unknown');

  /// Every value this SDK version knows, in the API's order.
  static const values = <AlertUrgency>[
    immediate,
    expected,
    future,
    past,
    unknown,
  ];

  static final Map<String, AlertUrgency> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The astronomical season of a date.
final class AstronomicalSeason extends OpenEnum {
  const AstronomicalSeason._(super.value) : super.known();
  const AstronomicalSeason._unknown(super.value) : super.unknown();

  /// The [AstronomicalSeason] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory AstronomicalSeason(String value) =>
      _byValue[value] ?? AstronomicalSeason._unknown(value);

  /// `spring`.
  static const spring = AstronomicalSeason._('spring');

  /// `summer`.
  static const summer = AstronomicalSeason._('summer');

  /// `autumn`.
  static const autumn = AstronomicalSeason._('autumn');

  /// `winter`.
  static const winter = AstronomicalSeason._('winter');

  /// Every value this SDK version knows, in the API's order.
  static const values = <AstronomicalSeason>[
    spring,
    summer,
    autumn,
    winter,
  ];

  static final Map<String, AstronomicalSeason> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The kind of a data source in the attribution registry.
final class AttributionSourceKind extends OpenEnum {
  const AttributionSourceKind._(super.value) : super.known();
  const AttributionSourceKind._unknown(super.value) : super.unknown();

  /// The [AttributionSourceKind] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory AttributionSourceKind(String value) =>
      _byValue[value] ?? AttributionSourceKind._unknown(value);

  /// `model`.
  static const model = AttributionSourceKind._('model');

  /// `peer`.
  static const peer = AttributionSourceKind._('peer');

  /// `observation`.
  static const observation = AttributionSourceKind._('observation');

  /// `alerts`.
  static const alerts = AttributionSourceKind._('alerts');

  /// `avalanche_forecast`.
  static const avalancheForecast =
      AttributionSourceKind._('avalanche_forecast');

  /// `climatology`.
  static const climatology = AttributionSourceKind._('climatology');

  /// `terrain`.
  static const terrain = AttributionSourceKind._('terrain');

  /// `places`.
  static const places = AttributionSourceKind._('places');

  /// `basemap`.
  static const basemap = AttributionSourceKind._('basemap');

  /// Every value this SDK version knows, in the API's order.
  static const values = <AttributionSourceKind>[
    model,
    peer,
    observation,
    alerts,
    avalancheForecast,
    climatology,
    terrain,
    places,
    basemap,
  ];

  static final Map<String, AttributionSourceKind> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// A request option the server clamped to the caller's tier.
final class ClampedOption extends OpenEnum {
  const ClampedOption._(super.value) : super.known();
  const ClampedOption._unknown(super.value) : super.unknown();

  /// The [ClampedOption] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory ClampedOption(String value) =>
      _byValue[value] ?? ClampedOption._unknown(value);

  /// `max_hours`.
  static const maxHours = ClampedOption._('max_hours');

  /// `max_days`.
  static const maxDays = ClampedOption._('max_days');

  /// Every value this SDK version knows, in the API's order.
  static const values = <ClampedOption>[
    maxHours,
    maxDays,
  ];

  static final Map<String, ClampedOption> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The icon hint of an hour, a day or current conditions (one enum everywhere).
///
/// Night hours take the `night_` forms; a daily row is daytime. Treat an
/// unknown icon as "other".
final class ConditionIcon extends OpenEnum {
  const ConditionIcon._(super.value) : super.known();
  const ConditionIcon._unknown(super.value) : super.unknown();

  /// The [ConditionIcon] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory ConditionIcon(String value) =>
      _byValue[value] ?? ConditionIcon._unknown(value);

  /// `sunny`.
  static const sunny = ConditionIcon._('sunny');

  /// `mostly_sunny`.
  static const mostlySunny = ConditionIcon._('mostly_sunny');

  /// `partly_cloudy`.
  static const partlyCloudy = ConditionIcon._('partly_cloudy');

  /// `mostly_cloudy`.
  static const mostlyCloudy = ConditionIcon._('mostly_cloudy');

  /// `cloudy`.
  static const cloudy = ConditionIcon._('cloudy');

  /// `sun_chance_showers`.
  static const sunChanceShowers = ConditionIcon._('sun_chance_showers');

  /// `sun_showers_likely`.
  static const sunShowersLikely = ConditionIcon._('sun_showers_likely');

  /// `sun_showers`.
  static const sunShowers = ConditionIcon._('sun_showers');

  /// `chance_showers`.
  static const chanceShowers = ConditionIcon._('chance_showers');

  /// `chance_rain`.
  static const chanceRain = ConditionIcon._('chance_rain');

  /// `showers_likely`.
  static const showersLikely = ConditionIcon._('showers_likely');

  /// `rain_likely`.
  static const rainLikely = ConditionIcon._('rain_likely');

  /// `showers`.
  static const showers = ConditionIcon._('showers');

  /// `light_rain`.
  static const lightRain = ConditionIcon._('light_rain');

  /// `rain`.
  static const rain = ConditionIcon._('rain');

  /// `heavy_rain`.
  static const heavyRain = ConditionIcon._('heavy_rain');

  /// `rain_snow_mix`.
  static const rainSnowMix = ConditionIcon._('rain_snow_mix');

  /// `light_snow`.
  static const lightSnow = ConditionIcon._('light_snow');

  /// `snow`.
  static const snow = ConditionIcon._('snow');

  /// `heavy_snow`.
  static const heavySnow = ConditionIcon._('heavy_snow');

  /// `freezing_rain`.
  static const freezingRain = ConditionIcon._('freezing_rain');

  /// `night_clear`.
  static const nightClear = ConditionIcon._('night_clear');

  /// `night_mostly_clear`.
  static const nightMostlyClear = ConditionIcon._('night_mostly_clear');

  /// `night_partly_cloudy`.
  static const nightPartlyCloudy = ConditionIcon._('night_partly_cloudy');

  /// `night_mostly_cloudy`.
  static const nightMostlyCloudy = ConditionIcon._('night_mostly_cloudy');

  /// `night_cloudy`.
  static const nightCloudy = ConditionIcon._('night_cloudy');

  /// `night_moon_chance_showers`.
  static const nightMoonChanceShowers =
      ConditionIcon._('night_moon_chance_showers');

  /// `night_moon_showers_likely`.
  static const nightMoonShowersLikely =
      ConditionIcon._('night_moon_showers_likely');

  /// `night_moon_showers`.
  static const nightMoonShowers = ConditionIcon._('night_moon_showers');

  /// `night_chance_showers`.
  static const nightChanceShowers = ConditionIcon._('night_chance_showers');

  /// `night_chance_rain`.
  static const nightChanceRain = ConditionIcon._('night_chance_rain');

  /// `night_showers_likely`.
  static const nightShowersLikely = ConditionIcon._('night_showers_likely');

  /// `night_rain_likely`.
  static const nightRainLikely = ConditionIcon._('night_rain_likely');

  /// `night_showers`.
  static const nightShowers = ConditionIcon._('night_showers');

  /// `night_light_rain`.
  static const nightLightRain = ConditionIcon._('night_light_rain');

  /// `night_rain`.
  static const nightRain = ConditionIcon._('night_rain');

  /// `night_heavy_rain`.
  static const nightHeavyRain = ConditionIcon._('night_heavy_rain');

  /// `night_rain_snow_mix`.
  static const nightRainSnowMix = ConditionIcon._('night_rain_snow_mix');

  /// `night_light_snow`.
  static const nightLightSnow = ConditionIcon._('night_light_snow');

  /// `night_snow`.
  static const nightSnow = ConditionIcon._('night_snow');

  /// `night_heavy_snow`.
  static const nightHeavySnow = ConditionIcon._('night_heavy_snow');

  /// `night_freezing_rain`.
  static const nightFreezingRain = ConditionIcon._('night_freezing_rain');

  /// Every value this SDK version knows, in the API's order.
  static const values = <ConditionIcon>[
    sunny,
    mostlySunny,
    partlyCloudy,
    mostlyCloudy,
    cloudy,
    sunChanceShowers,
    sunShowersLikely,
    sunShowers,
    chanceShowers,
    chanceRain,
    showersLikely,
    rainLikely,
    showers,
    lightRain,
    rain,
    heavyRain,
    rainSnowMix,
    lightSnow,
    snow,
    heavySnow,
    freezingRain,
    nightClear,
    nightMostlyClear,
    nightPartlyCloudy,
    nightMostlyCloudy,
    nightCloudy,
    nightMoonChanceShowers,
    nightMoonShowersLikely,
    nightMoonShowers,
    nightChanceShowers,
    nightChanceRain,
    nightShowersLikely,
    nightRainLikely,
    nightShowers,
    nightLightRain,
    nightRain,
    nightHeavyRain,
    nightRainSnowMix,
    nightLightSnow,
    nightSnow,
    nightHeavySnow,
    nightFreezingRain,
  ];

  static final Map<String, ConditionIcon> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// Where current conditions came from.
final class CurrentSource extends OpenEnum {
  const CurrentSource._(super.value) : super.known();
  const CurrentSource._unknown(super.value) : super.unknown();

  /// The [CurrentSource] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory CurrentSource(String value) =>
      _byValue[value] ?? CurrentSource._unknown(value);

  /// `nowcast`.
  static const nowcast = CurrentSource._('nowcast');

  /// `model`.
  static const model = CurrentSource._('model');

  /// Every value this SDK version knows, in the API's order.
  static const values = <CurrentSource>[
    nowcast,
    model,
  ];

  static final Map<String, CurrentSource> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The stable sky/precipitation code of one forecast day.
final class DailyCondition extends OpenEnum {
  const DailyCondition._(super.value) : super.known();
  const DailyCondition._unknown(super.value) : super.unknown();

  /// The [DailyCondition] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory DailyCondition(String value) =>
      _byValue[value] ?? DailyCondition._unknown(value);

  /// `sunny`.
  static const sunny = DailyCondition._('sunny');

  /// `mostly_sunny`.
  static const mostlySunny = DailyCondition._('mostly_sunny');

  /// `partly_cloudy`.
  static const partlyCloudy = DailyCondition._('partly_cloudy');

  /// `mostly_cloudy`.
  static const mostlyCloudy = DailyCondition._('mostly_cloudy');

  /// `cloudy`.
  static const cloudy = DailyCondition._('cloudy');

  /// `slight_chance_showers`.
  static const slightChanceShowers = DailyCondition._('slight_chance_showers');

  /// `chance_showers`.
  static const chanceShowers = DailyCondition._('chance_showers');

  /// `chance_rain`.
  static const chanceRain = DailyCondition._('chance_rain');

  /// `showers_likely`.
  static const showersLikely = DailyCondition._('showers_likely');

  /// `rain_likely`.
  static const rainLikely = DailyCondition._('rain_likely');

  /// `showers`.
  static const showers = DailyCondition._('showers');

  /// `rain`.
  static const rain = DailyCondition._('rain');

  /// `slight_chance_rain_snow_mix`.
  static const slightChanceRainSnowMix =
      DailyCondition._('slight_chance_rain_snow_mix');

  /// `chance_rain_snow_mix`.
  static const chanceRainSnowMix = DailyCondition._('chance_rain_snow_mix');

  /// `rain_snow_mix_likely`.
  static const rainSnowMixLikely = DailyCondition._('rain_snow_mix_likely');

  /// `rain_snow_mix`.
  static const rainSnowMix = DailyCondition._('rain_snow_mix');

  /// `slight_chance_snow`.
  static const slightChanceSnow = DailyCondition._('slight_chance_snow');

  /// `chance_snow`.
  static const chanceSnow = DailyCondition._('chance_snow');

  /// `snow_likely`.
  static const snowLikely = DailyCondition._('snow_likely');

  /// `snow`.
  static const snow = DailyCondition._('snow');

  /// Every value this SDK version knows, in the API's order.
  static const values = <DailyCondition>[
    sunny,
    mostlySunny,
    partlyCloudy,
    mostlyCloudy,
    cloudy,
    slightChanceShowers,
    chanceShowers,
    chanceRain,
    showersLikely,
    rainLikely,
    showers,
    rain,
    slightChanceRainSnowMix,
    chanceRainSnowMix,
    rainSnowMixLikely,
    rainSnowMix,
    slightChanceSnow,
    chanceSnow,
    snowLikely,
    snow,
  ];

  static final Map<String, DailyCondition> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// Where a point forecast's elevation came from.
final class ElevationSource extends OpenEnum {
  const ElevationSource._(super.value) : super.known();
  const ElevationSource._unknown(super.value) : super.unknown();

  /// The [ElevationSource] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory ElevationSource(String value) =>
      _byValue[value] ?? ElevationSource._unknown(value);

  /// `request`.
  static const request = ElevationSource._('request');

  /// `dem_3dep_10m`.
  static const dem3dep10m = ElevationSource._('dem_3dep_10m');

  /// Every value this SDK version knows, in the API's order.
  static const values = <ElevationSource>[
    request,
    dem3dep10m,
  ];

  static final Map<String, ElevationSource> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// What `explore` ranks places by (also a search `sort`).
final class ExploreMetric extends OpenEnum {
  const ExploreMetric._(super.value) : super.known();
  const ExploreMetric._unknown(super.value) : super.unknown();

  /// The [ExploreMetric] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory ExploreMetric(String value) =>
      _byValue[value] ?? ExploreMetric._unknown(value);

  /// `base_depth`.
  static const baseDepth = ExploreMetric._('base_depth');

  /// `new_snow_24h`.
  static const newSnow24h = ExploreMetric._('new_snow_24h');

  /// `snow_today`.
  static const snowToday = ExploreMetric._('snow_today');

  /// `snow_5d`.
  static const snow5d = ExploreMetric._('snow_5d');

  /// `snow_10d`.
  static const snow10d = ExploreMetric._('snow_10d');

  /// `snow_14d`.
  static const snow14d = ExploreMetric._('snow_14d');

  /// `precip_today`.
  static const precipToday = ExploreMetric._('precip_today');

  /// `precip_5d`.
  static const precip5d = ExploreMetric._('precip_5d');

  /// `precip_10d`.
  static const precip10d = ExploreMetric._('precip_10d');

  /// `precip_14d`.
  static const precip14d = ExploreMetric._('precip_14d');

  /// `season_precip`.
  static const seasonPrecip = ExploreMetric._('season_precip');

  /// `season_precip_pct_normal`.
  static const seasonPrecipPctNormal =
      ExploreMetric._('season_precip_pct_normal');

  /// `season_snow`.
  static const seasonSnow = ExploreMetric._('season_snow');

  /// Every value this SDK version knows, in the API's order.
  static const values = <ExploreMetric>[
    baseDepth,
    newSnow24h,
    snowToday,
    snow5d,
    snow10d,
    snow14d,
    precipToday,
    precip5d,
    precip10d,
    precip14d,
    seasonPrecip,
    seasonPrecipPctNormal,
    seasonSnow,
  ];

  static final Map<String, ExploreMetric> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// Where the freezing level is.
final class FreezingLevelKind extends OpenEnum {
  const FreezingLevelKind._(super.value) : super.known();
  const FreezingLevelKind._unknown(super.value) : super.unknown();

  /// The [FreezingLevelKind] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory FreezingLevelKind(String value) =>
      _byValue[value] ?? FreezingLevelKind._unknown(value);

  /// `below_surface`.
  static const belowSurface = FreezingLevelKind._('below_surface');

  /// `height`.
  static const height = FreezingLevelKind._('height');

  /// `above_profile`.
  static const aboveProfile = FreezingLevelKind._('above_profile');

  /// Every value this SDK version knows, in the API's order.
  static const values = <FreezingLevelKind>[
    belowSurface,
    height,
    aboveProfile,
  ];

  static final Map<String, FreezingLevelKind> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The strength of a gap-flow wind event.
final class GapFlowStatus extends OpenEnum {
  const GapFlowStatus._(super.value) : super.known();
  const GapFlowStatus._unknown(super.value) : super.unknown();

  /// The [GapFlowStatus] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory GapFlowStatus(String value) =>
      _byValue[value] ?? GapFlowStatus._unknown(value);

  /// `none`.
  static const none = GapFlowStatus._('none');

  /// `moderate`.
  static const moderate = GapFlowStatus._('moderate');

  /// `strong`.
  static const strong = GapFlowStatus._('strong');

  /// `extreme`.
  static const extreme = GapFlowStatus._('extreme');

  /// Every value this SDK version knows, in the API's order.
  static const values = <GapFlowStatus>[
    none,
    moderate,
    strong,
    extreme,
  ];

  static final Map<String, GapFlowStatus> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The stable sky/precipitation code of one forecast hour.
final class HourlyCondition extends OpenEnum {
  const HourlyCondition._(super.value) : super.known();
  const HourlyCondition._unknown(super.value) : super.unknown();

  /// The [HourlyCondition] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory HourlyCondition(String value) =>
      _byValue[value] ?? HourlyCondition._unknown(value);

  /// `sunny`.
  static const sunny = HourlyCondition._('sunny');

  /// `mostly_sunny`.
  static const mostlySunny = HourlyCondition._('mostly_sunny');

  /// `partly_cloudy`.
  static const partlyCloudy = HourlyCondition._('partly_cloudy');

  /// `mostly_cloudy`.
  static const mostlyCloudy = HourlyCondition._('mostly_cloudy');

  /// `cloudy`.
  static const cloudy = HourlyCondition._('cloudy');

  /// `clear`.
  static const clear = HourlyCondition._('clear');

  /// `mostly_clear`.
  static const mostlyClear = HourlyCondition._('mostly_clear');

  /// `slight_chance_showers`.
  static const slightChanceShowers = HourlyCondition._('slight_chance_showers');

  /// `chance_showers`.
  static const chanceShowers = HourlyCondition._('chance_showers');

  /// `showers_likely`.
  static const showersLikely = HourlyCondition._('showers_likely');

  /// `rain`.
  static const rain = HourlyCondition._('rain');

  /// `light_rain`.
  static const lightRain = HourlyCondition._('light_rain');

  /// `heavy_rain`.
  static const heavyRain = HourlyCondition._('heavy_rain');

  /// `slight_chance_rain_snow_mix`.
  static const slightChanceRainSnowMix =
      HourlyCondition._('slight_chance_rain_snow_mix');

  /// `chance_rain_snow_mix`.
  static const chanceRainSnowMix = HourlyCondition._('chance_rain_snow_mix');

  /// `rain_snow_mix_likely`.
  static const rainSnowMixLikely = HourlyCondition._('rain_snow_mix_likely');

  /// `rain_snow_mix`.
  static const rainSnowMix = HourlyCondition._('rain_snow_mix');

  /// `slight_chance_snow`.
  static const slightChanceSnow = HourlyCondition._('slight_chance_snow');

  /// `chance_snow`.
  static const chanceSnow = HourlyCondition._('chance_snow');

  /// `snow_likely`.
  static const snowLikely = HourlyCondition._('snow_likely');

  /// `snow`.
  static const snow = HourlyCondition._('snow');

  /// `light_snow`.
  static const lightSnow = HourlyCondition._('light_snow');

  /// `heavy_snow`.
  static const heavySnow = HourlyCondition._('heavy_snow');

  /// `slight_chance_freezing_rain`.
  static const slightChanceFreezingRain =
      HourlyCondition._('slight_chance_freezing_rain');

  /// `chance_freezing_rain`.
  static const chanceFreezingRain = HourlyCondition._('chance_freezing_rain');

  /// `freezing_rain_likely`.
  static const freezingRainLikely = HourlyCondition._('freezing_rain_likely');

  /// `freezing_rain`.
  static const freezingRain = HourlyCondition._('freezing_rain');

  /// Every value this SDK version knows, in the API's order.
  static const values = <HourlyCondition>[
    sunny,
    mostlySunny,
    partlyCloudy,
    mostlyCloudy,
    cloudy,
    clear,
    mostlyClear,
    slightChanceShowers,
    chanceShowers,
    showersLikely,
    rain,
    lightRain,
    heavyRain,
    slightChanceRainSnowMix,
    chanceRainSnowMix,
    rainSnowMixLikely,
    rainSnowMix,
    slightChanceSnow,
    chanceSnow,
    snowLikely,
    snow,
    lightSnow,
    heavySnow,
    slightChanceFreezingRain,
    chanceFreezingRain,
    freezingRainLikely,
    freezingRain,
  ];

  static final Map<String, HourlyCondition> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The kind of a temperature inversion.
final class InversionKind extends OpenEnum {
  const InversionKind._(super.value) : super.known();
  const InversionKind._unknown(super.value) : super.unknown();

  /// The [InversionKind] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory InversionKind(String value) =>
      _byValue[value] ?? InversionKind._unknown(value);

  /// `surface_shallow`.
  static const surfaceShallow = InversionKind._('surface_shallow');

  /// `cold_pool`.
  static const coldPool = InversionKind._('cold_pool');

  /// `elevated`.
  static const elevated = InversionKind._('elevated');

  /// Every value this SDK version knows, in the API's order.
  static const values = <InversionKind>[
    surfaceShallow,
    coldPool,
    elevated,
  ];

  static final Map<String, InversionKind> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The primary type of a named location.
final class LocationType extends OpenEnum {
  const LocationType._(super.value) : super.known();
  const LocationType._unknown(super.value) : super.unknown();

  /// The [LocationType] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory LocationType(String value) =>
      _byValue[value] ?? LocationType._unknown(value);

  /// `airport`.
  static const airport = LocationType._('airport');

  /// `backcountry`.
  static const backcountry = LocationType._('backcountry');

  /// `beach_coast`.
  static const beachCoast = LocationType._('beach_coast');

  /// `campground`.
  static const campground = LocationType._('campground');

  /// `city_town`.
  static const cityTown = LocationType._('city_town');

  /// `climbing_area`.
  static const climbingArea = LocationType._('climbing_area');

  /// `coastal_point`.
  static const coastalPoint = LocationType._('coastal_point');

  /// `event_venue`.
  static const eventVenue = LocationType._('event_venue');

  /// `fire_lookout`.
  static const fireLookout = LocationType._('fire_lookout');

  /// `fishing_river_access`.
  static const fishingRiverAccess = LocationType._('fishing_river_access');

  /// `golf_course`.
  static const golfCourse = LocationType._('golf_course');

  /// `hot_spring`.
  static const hotSpring = LocationType._('hot_spring');

  /// `lake`.
  static const lake = LocationType._('lake');

  /// `mountain_pass`.
  static const mountainPass = LocationType._('mountain_pass');

  /// `national_park`.
  static const nationalPark = LocationType._('national_park');

  /// `observation_station`.
  static const observationStation = LocationType._('observation_station');

  /// `other`.
  static const other = LocationType._('other');

  /// `park`.
  static const park = LocationType._('park');

  /// `recreation_area`.
  static const recreationArea = LocationType._('recreation_area');

  /// `reservoir_lake`.
  static const reservoirLake = LocationType._('reservoir_lake');

  /// `scenic_tourist`.
  static const scenicTourist = LocationType._('scenic_tourist');

  /// `ski_area`.
  static const skiArea = LocationType._('ski_area');

  /// `state_park`.
  static const statePark = LocationType._('state_park');

  /// `summit`.
  static const summit = LocationType._('summit');

  /// `trailhead`.
  static const trailhead = LocationType._('trailhead');

  /// `volcano`.
  static const volcano = LocationType._('volcano');

  /// `waterfall`.
  static const waterfall = LocationType._('waterfall');

  /// `wine_agritourism`.
  static const wineAgritourism = LocationType._('wine_agritourism');

  /// Every value this SDK version knows, in the API's order.
  static const values = <LocationType>[
    airport,
    backcountry,
    beachCoast,
    campground,
    cityTown,
    climbingArea,
    coastalPoint,
    eventVenue,
    fireLookout,
    fishingRiverAccess,
    golfCourse,
    hotSpring,
    lake,
    mountainPass,
    nationalPark,
    observationStation,
    other,
    park,
    recreationArea,
    reservoirLake,
    scenicTourist,
    skiArea,
    statePark,
    summit,
    trailhead,
    volcano,
    waterfall,
    wineAgritourism,
  ];

  static final Map<String, LocationType> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// Which member view a forecast carries (`pool`, `plume` or `full`).
final class MembersView extends OpenEnum {
  const MembersView._(super.value) : super.known();
  const MembersView._unknown(super.value) : super.unknown();

  /// The [MembersView] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory MembersView(String value) =>
      _byValue[value] ?? MembersView._unknown(value);

  /// `pool`.
  static const pool = MembersView._('pool');

  /// `plume`.
  static const plume = MembersView._('plume');

  /// `full`.
  static const full = MembersView._('full');

  /// Every value this SDK version knows, in the API's order.
  static const values = <MembersView>[
    pool,
    plume,
    full,
  ];

  static final Map<String, MembersView> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The moon's phase on a date.
final class MoonPhase extends OpenEnum {
  const MoonPhase._(super.value) : super.known();
  const MoonPhase._unknown(super.value) : super.unknown();

  /// The [MoonPhase] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory MoonPhase(String value) =>
      _byValue[value] ?? MoonPhase._unknown(value);

  /// `new_moon`.
  static const newMoon = MoonPhase._('new_moon');

  /// `waxing_crescent`.
  static const waxingCrescent = MoonPhase._('waxing_crescent');

  /// `first_quarter`.
  static const firstQuarter = MoonPhase._('first_quarter');

  /// `waxing_gibbous`.
  static const waxingGibbous = MoonPhase._('waxing_gibbous');

  /// `full_moon`.
  static const fullMoon = MoonPhase._('full_moon');

  /// `waning_gibbous`.
  static const waningGibbous = MoonPhase._('waning_gibbous');

  /// `last_quarter`.
  static const lastQuarter = MoonPhase._('last_quarter');

  /// `waning_crescent`.
  static const waningCrescent = MoonPhase._('waning_crescent');

  /// Every value this SDK version knows, in the API's order.
  static const values = <MoonPhase>[
    newMoon,
    waxingCrescent,
    firstQuarter,
    waxingGibbous,
    fullMoon,
    waningGibbous,
    lastQuarter,
    waningCrescent,
  ];

  static final Map<String, MoonPhase> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// A nowcast input that was unavailable for a response.
final class NowcastLayer extends OpenEnum {
  const NowcastLayer._(super.value) : super.known();
  const NowcastLayer._unknown(super.value) : super.unknown();

  /// The [NowcastLayer] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory NowcastLayer(String value) =>
      _byValue[value] ?? NowcastLayer._unknown(value);

  /// `observation`.
  static const observation = NowcastLayer._('observation');

  /// `radar`.
  static const radar = NowcastLayer._('radar');

  /// `cloud`.
  static const cloud = NowcastLayer._('cloud');

  /// `nearest_sensors`.
  static const nearestSensors = NowcastLayer._('nearest_sensors');

  /// Every value this SDK version knows, in the API's order.
  static const values = <NowcastLayer>[
    observation,
    radar,
    cloud,
    nearestSensors,
  ];

  static final Map<String, NowcastLayer> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// Why a probability or a window total is `null`.
///
/// `window_not_covered`: the served series does not reach the window's end (ask
/// for more `max_hours`). `too_few_members`: fewer than two members cover the
/// window. `variable_unavailable`: no member carries the variable through the
/// window (e.g. `hourly=false`).
final class NullReason extends OpenEnum {
  const NullReason._(super.value) : super.known();
  const NullReason._unknown(super.value) : super.unknown();

  /// The [NullReason] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory NullReason(String value) =>
      _byValue[value] ?? NullReason._unknown(value);

  /// `window_not_covered`.
  static const windowNotCovered = NullReason._('window_not_covered');

  /// `too_few_members`.
  static const tooFewMembers = NullReason._('too_few_members');

  /// `variable_unavailable`.
  static const variableUnavailable = NullReason._('variable_unavailable');

  /// Every value this SDK version knows, in the API's order.
  static const values = <NullReason>[
    windowNotCovered,
    tooFewMembers,
    variableUnavailable,
  ];

  static final Map<String, NullReason> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The comparison of a probability term.
final class Op extends OpenEnum {
  const Op._(super.value) : super.known();
  const Op._unknown(super.value) : super.unknown();

  /// The [Op] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory Op(String value) => _byValue[value] ?? Op._unknown(value);

  /// At least the threshold.
  static const ge = Op._('ge');

  /// At most the threshold.
  static const le = Op._('le');

  /// Every value this SDK version knows, in the API's order.
  static const values = <Op>[
    ge,
    le,
  ];

  static final Map<String, Op> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// A mountain pass's official road status, from least to most restrictive.
final class PassStatusLevel extends OpenEnum {
  const PassStatusLevel._(super.value) : super.known();
  const PassStatusLevel._unknown(super.value) : super.unknown();

  /// The [PassStatusLevel] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory PassStatusLevel(String value) =>
      _byValue[value] ?? PassStatusLevel._unknown(value);

  /// `none`.
  static const none = PassStatusLevel._('none');

  /// `advisory`.
  static const advisory = PassStatusLevel._('advisory');

  /// `traction`.
  static const traction = PassStatusLevel._('traction');

  /// `r1`.
  static const r1 = PassStatusLevel._('r1');

  /// `r2`.
  static const r2 = PassStatusLevel._('r2');

  /// `r3`.
  static const r3 = PassStatusLevel._('r3');

  /// `chains`.
  static const chains = PassStatusLevel._('chains');

  /// `closed`.
  static const closed = PassStatusLevel._('closed');

  /// Every value this SDK version knows, in the API's order.
  static const values = <PassStatusLevel>[
    none,
    advisory,
    traction,
    r1,
    r2,
    r3,
    chains,
    closed,
  ];

  static final Map<String, PassStatusLevel> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// What a day's precipitation display shows.
final class PrecipKind extends OpenEnum {
  const PrecipKind._(super.value) : super.known();
  const PrecipKind._unknown(super.value) : super.unknown();

  /// The [PrecipKind] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory PrecipKind(String value) =>
      _byValue[value] ?? PrecipKind._unknown(value);

  /// `none`.
  static const none = PrecipKind._('none');

  /// `rain`.
  static const rain = PrecipKind._('rain');

  /// `snow`.
  static const snow = PrecipKind._('snow');

  /// `rain_snow_mix`.
  static const rainSnowMix = PrecipKind._('rain_snow_mix');

  /// `freezing_rain`.
  static const freezingRain = PrecipKind._('freezing_rain');

  /// Every value this SDK version knows, in the API's order.
  static const values = <PrecipKind>[
    none,
    rain,
    snow,
    rainSnowMix,
    freezingRain,
  ];

  static final Map<String, PrecipKind> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// A precipitation type.
final class PrecipitationType extends OpenEnum {
  const PrecipitationType._(super.value) : super.known();
  const PrecipitationType._unknown(super.value) : super.unknown();

  /// The [PrecipitationType] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory PrecipitationType(String value) =>
      _byValue[value] ?? PrecipitationType._unknown(value);

  /// `rain`.
  static const rain = PrecipitationType._('rain');

  /// `snow`.
  static const snow = PrecipitationType._('snow');

  /// `rain_snow_mix`.
  static const rainSnowMix = PrecipitationType._('rain_snow_mix');

  /// `freezing_rain`.
  static const freezingRain = PrecipitationType._('freezing_rain');

  /// Every value this SDK version knows, in the API's order.
  static const values = <PrecipitationType>[
    rain,
    snow,
    rainSnowMix,
    freezingRain,
  ];

  static final Map<String, PrecipitationType> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// A variable named in an hour's provenance tags.
final class ProvenanceVariable extends OpenEnum {
  const ProvenanceVariable._(super.value) : super.known();
  const ProvenanceVariable._unknown(super.value) : super.unknown();

  /// The [ProvenanceVariable] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory ProvenanceVariable(String value) =>
      _byValue[value] ?? ProvenanceVariable._unknown(value);

  /// `temperature`.
  static const temperature = ProvenanceVariable._('temperature');

  /// `dewpoint`.
  static const dewpoint = ProvenanceVariable._('dewpoint');

  /// `precipitation`.
  static const precipitation = ProvenanceVariable._('precipitation');

  /// `snowfall`.
  static const snowfall = ProvenanceVariable._('snowfall');

  /// `wind_speed`.
  static const windSpeed = ProvenanceVariable._('wind_speed');

  /// `wind_gust`.
  static const windGust = ProvenanceVariable._('wind_gust');

  /// `snow_level`.
  static const snowLevel = ProvenanceVariable._('snow_level');

  /// `cloud_cover`.
  static const cloudCover = ProvenanceVariable._('cloud_cover');

  /// Every value this SDK version knows, in the API's order.
  static const values = <ProvenanceVariable>[
    temperature,
    dewpoint,
    precipitation,
    snowfall,
    windSpeed,
    windGust,
    snowLevel,
    cloudCover,
  ];

  static final Map<String, ProvenanceVariable> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The character of falling snow, from its snow-to-liquid ratio.
///
/// Labels: wet (sticky), dense (heavy), average, dry (powder), very dry (cold
/// smoke).
final class SnowCharacter extends OpenEnum {
  const SnowCharacter._(super.value) : super.known();
  const SnowCharacter._unknown(super.value) : super.unknown();

  /// The [SnowCharacter] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory SnowCharacter(String value) =>
      _byValue[value] ?? SnowCharacter._unknown(value);

  /// `wet`.
  static const wet = SnowCharacter._('wet');

  /// `dense`.
  static const dense = SnowCharacter._('dense');

  /// `average`.
  static const average = SnowCharacter._('average');

  /// `dry`.
  static const dry = SnowCharacter._('dry');

  /// `very_dry`.
  static const veryDry = SnowCharacter._('very_dry');

  /// Every value this SDK version knows, in the API's order.
  static const values = <SnowCharacter>[
    wet,
    dense,
    average,
    dry,
    veryDry,
  ];

  static final Map<String, SnowCharacter> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The observation network of a catalog station.
final class StationNetwork extends OpenEnum {
  const StationNetwork._(super.value) : super.known();
  const StationNetwork._unknown(super.value) : super.unknown();

  /// The [StationNetwork] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory StationNetwork(String value) =>
      _byValue[value] ?? StationNetwork._unknown(value);

  /// `snotel`.
  static const snotel = StationNetwork._('snotel');

  /// `snolite`.
  static const snolite = StationNetwork._('snolite');

  /// `raws`.
  static const raws = StationNetwork._('raws');

  /// `asos`.
  static const asos = StationNetwork._('asos');

  /// `awos`.
  static const awos = StationNetwork._('awos');

  /// `metar`.
  static const metar = StationNetwork._('metar');

  /// `rwis_wsdot`.
  static const rwisWsdot = StationNetwork._('rwis_wsdot');

  /// `rwis_odot`.
  static const rwisOdot = StationNetwork._('rwis_odot');

  /// `rwis_caltrans`.
  static const rwisCaltrans = StationNetwork._('rwis_caltrans');

  /// `rwis_idot`.
  static const rwisIdot = StationNetwork._('rwis_idot');

  /// `rwis_ndot`.
  static const rwisNdot = StationNetwork._('rwis_ndot');

  /// `rwis_udot`.
  static const rwisUdot = StationNetwork._('rwis_udot');

  /// `rwis_cdot`.
  static const rwisCdot = StationNetwork._('rwis_cdot');

  /// `rwis_mdt`.
  static const rwisMdt = StationNetwork._('rwis_mdt');

  /// `rwis_wydot`.
  static const rwisWydot = StationNetwork._('rwis_wydot');

  /// `rwis_other`.
  static const rwisOther = StationNetwork._('rwis_other');

  /// `agrimet`.
  static const agrimet = StationNetwork._('agrimet');

  /// `agweathernet`.
  static const agweathernet = StationNetwork._('agweathernet');

  /// `cocorahs`.
  static const cocorahs = StationNetwork._('cocorahs');

  /// `coop`.
  static const coop = StationNetwork._('coop');

  /// `usgs`.
  static const usgs = StationNetwork._('usgs');

  /// `tempest`.
  static const tempest = StationNetwork._('tempest');

  /// `davis`.
  static const davis = StationNetwork._('davis');

  /// `wxflow`.
  static const wxflow = StationNetwork._('wxflow');

  /// `cdec`.
  static const cdec = StationNetwork._('cdec');

  /// `cimis`.
  static const cimis = StationNetwork._('cimis');

  /// `mesonet_oregon`.
  static const mesonetOregon = StationNetwork._('mesonet_oregon');

  /// `mesonet_synoptic`.
  static const mesonetSynoptic = StationNetwork._('mesonet_synoptic');

  /// `mesonet_other`.
  static const mesonetOther = StationNetwork._('mesonet_other');

  /// `ndbc_buoy`.
  static const ndbcBuoy = StationNetwork._('ndbc_buoy');

  /// `other`.
  static const other = StationNetwork._('other');

  /// `hads`.
  static const hads = StationNetwork._('hads');

  /// `madis`.
  static const madis = StationNetwork._('madis');

  /// `nwac`.
  static const nwac = StationNetwork._('nwac');

  /// `mt_mesonet`.
  static const mtMesonet = StationNetwork._('mt_mesonet');

  /// `rain_gauge`.
  static const rainGauge = StationNetwork._('rain_gauge');

  /// `surfrad`.
  static const surfrad = StationNetwork._('surfrad');

  /// Every value this SDK version knows, in the API's order.
  static const values = <StationNetwork>[
    snotel,
    snolite,
    raws,
    asos,
    awos,
    metar,
    rwisWsdot,
    rwisOdot,
    rwisCaltrans,
    rwisIdot,
    rwisNdot,
    rwisUdot,
    rwisCdot,
    rwisMdt,
    rwisWydot,
    rwisOther,
    agrimet,
    agweathernet,
    cocorahs,
    coop,
    usgs,
    tempest,
    davis,
    wxflow,
    cdec,
    cimis,
    mesonetOregon,
    mesonetSynoptic,
    mesonetOther,
    ndbcBuoy,
    other,
    hads,
    madis,
    nwac,
    mtMesonet,
    rainGauge,
    surfrad,
  ];

  static final Map<String, StationNetwork> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The reporting status of a catalog station.
final class StationStatus extends OpenEnum {
  const StationStatus._(super.value) : super.known();
  const StationStatus._unknown(super.value) : super.unknown();

  /// The [StationStatus] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory StationStatus(String value) =>
      _byValue[value] ?? StationStatus._unknown(value);

  /// `active`.
  static const active = StationStatus._('active');

  /// `intermittent`.
  static const intermittent = StationStatus._('intermittent');

  /// `inactive`.
  static const inactive = StationStatus._('inactive');

  /// `decommissioned`.
  static const decommissioned = StationStatus._('decommissioned');

  /// `unknown`.
  static const unknown = StationStatus._('unknown');

  /// Every value this SDK version knows, in the API's order.
  static const values = <StationStatus>[
    active,
    intermittent,
    inactive,
    decommissioned,
    unknown,
  ];

  static final Map<String, StationStatus> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// How snow density changes through a storm.
final class StormOrientation extends OpenEnum {
  const StormOrientation._(super.value) : super.known();
  const StormOrientation._unknown(super.value) : super.unknown();

  /// The [StormOrientation] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory StormOrientation(String value) =>
      _byValue[value] ?? StormOrientation._unknown(value);

  /// `right_side_up`.
  static const rightSideUp = StormOrientation._('right_side_up');

  /// `upside_down`.
  static const upsideDown = StormOrientation._('upside_down');

  /// `mixed`.
  static const mixed = StormOrientation._('mixed');

  /// Every value this SDK version knows, in the API's order.
  static const values = <StormOrientation>[
    rightSideUp,
    upsideDown,
    mixed,
  ];

  static final Map<String, StormOrientation> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The kind of one section of a catalog page template.
final class TemplateSectionKind extends OpenEnum {
  const TemplateSectionKind._(super.value) : super.known();
  const TemplateSectionKind._unknown(super.value) : super.unknown();

  /// The [TemplateSectionKind] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory TemplateSectionKind(String value) =>
      _byValue[value] ?? TemplateSectionKind._unknown(value);

  /// `weather_panel`.
  static const weatherPanel = TemplateSectionKind._('weather_panel');

  /// `content_slot`.
  static const contentSlot = TemplateSectionKind._('content_slot');

  /// `ad_slot`.
  static const adSlot = TemplateSectionKind._('ad_slot');

  /// `media`.
  static const media = TemplateSectionKind._('media');

  /// Every value this SDK version knows, in the API's order.
  static const values = <TemplateSectionKind>[
    weatherPanel,
    contentSlot,
    adSlot,
    media,
  ];

  static final Map<String, TemplateSectionKind> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The page-template variant of a catalog entry.
final class TemplateVariant extends OpenEnum {
  const TemplateVariant._(super.value) : super.known();
  const TemplateVariant._unknown(super.value) : super.unknown();

  /// The [TemplateVariant] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory TemplateVariant(String value) =>
      _byValue[value] ?? TemplateVariant._unknown(value);

  /// `mountain`.
  static const mountain = TemplateVariant._('mountain');

  /// `coastal`.
  static const coastal = TemplateVariant._('coastal');

  /// `trail`.
  static const trail = TemplateVariant._('trail');

  /// `pass`.
  static const pass = TemplateVariant._('pass');

  /// `generic`.
  static const generic = TemplateVariant._('generic');

  /// `station`.
  static const station = TemplateVariant._('station');

  /// Every value this SDK version knows, in the API's order.
  static const values = <TemplateVariant>[
    mountain,
    coastal,
    trail,
    pass,
    generic,
    station,
  ];

  static final Map<String, TemplateVariant> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// How a window total combines each member's hours (`total` for amounts).
final class TotalAggregation extends OpenEnum {
  const TotalAggregation._(super.value) : super.known();
  const TotalAggregation._unknown(super.value) : super.unknown();

  /// The [TotalAggregation] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory TotalAggregation(String value) =>
      _byValue[value] ?? TotalAggregation._unknown(value);

  /// `total`.
  static const total = TotalAggregation._('total');

  /// `min`.
  static const min = TotalAggregation._('min');

  /// `max`.
  static const max = TotalAggregation._('max');

  /// Every value this SDK version knows, in the API's order.
  static const values = <TotalAggregation>[
    total,
    min,
    max,
  ];

  static final Map<String, TotalAggregation> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// A variable a window total (`totals=`) can ask about.
final class TotalVariable extends OpenEnum {
  const TotalVariable._(super.value) : super.known();
  const TotalVariable._unknown(super.value) : super.unknown();

  /// The [TotalVariable] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory TotalVariable(String value) =>
      _byValue[value] ?? TotalVariable._unknown(value);

  /// `precipitation`.
  static const precipitation = TotalVariable._('precipitation');

  /// `snowfall`.
  static const snowfall = TotalVariable._('snowfall');

  /// Every value this SDK version knows, in the API's order.
  static const values = <TotalVariable>[
    precipitation,
    snowfall,
  ];

  static final Map<String, TotalVariable> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// A unit for a probability threshold given by the caller.
final class Unit extends OpenEnum {
  const Unit._(super.value) : super.known();
  const Unit._unknown(super.value) : super.unknown();

  /// The [Unit] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory Unit(String value) => _byValue[value] ?? Unit._unknown(value);

  /// `mm`.
  static const mm = Unit._('mm');

  /// `in`.
  static const inch = Unit._('in');

  /// `degC`.
  static const degC = Unit._('degC');

  /// `degF`.
  static const degF = Unit._('degF');

  /// `K`.
  static const k = Unit._('K');

  /// `m`.
  static const m = Unit._('m');

  /// `ft`.
  static const ft = Unit._('ft');

  /// `m/s`.
  static const mPerS = Unit._('m/s');

  /// `mph`.
  static const mph = Unit._('mph');

  /// Every value this SDK version knows, in the API's order.
  static const values = <Unit>[
    mm,
    inch,
    degC,
    degF,
    k,
    m,
    ft,
    mPerS,
    mph,
  ];

  static final Map<String, Unit> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// The unit system of a request and its response.
///
/// `metric` is °C, mm, m/s and m; `imperial` is °F, in, mph and ft; `kelvin` is
/// metric with temperatures in K.
final class UnitSystem extends OpenEnum {
  const UnitSystem._(super.value) : super.known();
  const UnitSystem._unknown(super.value) : super.unknown();

  /// The [UnitSystem] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory UnitSystem(String value) =>
      _byValue[value] ?? UnitSystem._unknown(value);

  /// `metric`.
  static const metric = UnitSystem._('metric');

  /// `imperial`.
  static const imperial = UnitSystem._('imperial');

  /// `kelvin`.
  static const kelvin = UnitSystem._('kelvin');

  /// Every value this SDK version knows, in the API's order.
  static const values = <UnitSystem>[
    metric,
    imperial,
    kelvin,
  ];

  static final Map<String, UnitSystem> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// A variable a probability term (`prob=`) can ask about.
final class Variable extends OpenEnum {
  const Variable._(super.value) : super.known();
  const Variable._unknown(super.value) : super.unknown();

  /// The [Variable] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory Variable(String value) => _byValue[value] ?? Variable._unknown(value);

  /// `temperature`.
  static const temperature = Variable._('temperature');

  /// `wind_speed`.
  static const windSpeed = Variable._('wind_speed');

  /// `snow_level`.
  static const snowLevel = Variable._('snow_level');

  /// `precipitation`.
  static const precipitation = Variable._('precipitation');

  /// `snowfall`.
  static const snowfall = Variable._('snowfall');

  /// Every value this SDK version knows, in the API's order.
  static const values = <Variable>[
    temperature,
    windSpeed,
    snowLevel,
    precipitation,
    snowfall,
  ];

  static final Map<String, Variable> _byValue = {
    for (final v in values) v.value: v,
  };
}

/// A day's wind category.
final class WindStatus extends OpenEnum {
  const WindStatus._(super.value) : super.known();
  const WindStatus._unknown(super.value) : super.unknown();

  /// The [WindStatus] for [value]: a known value, or one with
  /// [isUnknown] set that keeps the raw string.
  factory WindStatus(String value) =>
      _byValue[value] ?? WindStatus._unknown(value);

  /// `calm`.
  static const calm = WindStatus._('calm');

  /// `light`.
  static const light = WindStatus._('light');

  /// `moderate`.
  static const moderate = WindStatus._('moderate');

  /// `strong`.
  static const strong = WindStatus._('strong');

  /// `very_strong`.
  static const veryStrong = WindStatus._('very_strong');

  /// `extreme`.
  static const extreme = WindStatus._('extreme');

  /// Every value this SDK version knows, in the API's order.
  static const values = <WindStatus>[
    calm,
    light,
    moderate,
    strong,
    veryStrong,
    extreme,
  ];

  static final Map<String, WindStatus> _byValue = {
    for (final v in values) v.value: v,
  };
}
