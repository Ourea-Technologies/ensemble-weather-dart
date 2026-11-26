// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

// The vectors runner's field lookup: SDK name (snake_case, as the vectors
// write paths) to the Dart getter. Scaffolded from the models; keep in step.

import 'package:ensemble_weather/ensemble_weather.dart';

/// The field [name] (an SDK name in snake_case) of [model].
Object? readField(Object model, String name) {
  switch (model) {
    case final ActiveAlert m:
      switch (name) {
        case 'id':
          return m.id;
        case 'event':
          return m.event;
        case 'severity':
          return m.severity;
        case 'urgency':
          return m.urgency;
        case 'certainty':
          return m.certainty;
        case 'headline':
          return m.headline;
        case 'onset':
          return m.onset;
        case 'expires':
          return m.expires;
        case 'ends':
          return m.ends;
        case 'sent':
          return m.sent;
        case 'message_type':
          return m.messageType;
        case 'references':
          return m.references;
        case 'sender_name':
          return m.senderName;
        case 'area_desc':
          return m.areaDesc;
        case 'description':
          return m.description;
        case 'instruction':
          return m.instruction;
        case 'source_url':
          return m.sourceUrl;
        case 'event_key':
          return m.eventKey;
        case 'vtec_action':
          return m.vtecAction;
      }
    case final AlertOutlineCollection m:
      switch (name) {
        case 'type':
          return m.type;
        case 'features':
          return m.features;
        case 'attribution':
          return m.attribution;
      }
    case final AlertOutlineFeature m:
      switch (name) {
        case 'type':
          return m.type;
        case 'geometry':
          return m.geometry;
        case 'properties':
          return m.properties;
      }
    case final AlertOutlineGeometry m:
      switch (name) {
        case 'type':
          return m.type;
        case 'coordinates':
          return m.coordinates;
      }
    case final AlertOutlineProperties m:
      switch (name) {
        case 'id':
          return m.id;
        case 'event':
          return m.event;
        case 'class':
          return m.alertClass;
        case 'severity':
          return m.severity;
        case 'urgency':
          return m.urgency;
        case 'certainty':
          return m.certainty;
        case 'headline':
          return m.headline;
        case 'onset':
          return m.onset;
        case 'expires':
          return m.expires;
        case 'ends':
          return m.ends;
        case 'sender_name':
          return m.senderName;
        case 'source_url':
          return m.sourceUrl;
      }
    case final AlertsResponse m:
      switch (name) {
        case 'location':
          return m.location;
        case 'count':
          return m.count;
        case 'as_of':
          return m.asOf;
        case 'items':
          return m.items;
        case 'attribution':
          return m.attribution;
      }
    case final AppliedOptions m:
      switch (name) {
        case 'max_hours':
          return m.maxHours;
        case 'max_days':
          return m.maxDays;
        case 'clamped':
          return m.clamped;
      }
    case final AttributionProvider m:
      switch (name) {
        case 'id':
          return m.id;
        case 'name':
          return m.name;
        case 'credit':
          return m.credit;
        case 'licence':
          return m.licence;
        case 'licence_url':
          return m.licenceUrl;
        case 'terms_url':
          return m.termsUrl;
        case 'modified':
          return m.modified;
        case 'notices':
          return m.notices;
        case 'sources':
          return m.sources;
      }
    case final AttributionRegistry m:
      switch (name) {
        case 'providers':
          return m.providers;
      }
    case final AttributionSource m:
      switch (name) {
        case 'id':
          return m.id;
        case 'name':
          return m.name;
        case 'kind':
          return m.kind;
        case 'provider':
          return m.provider;
      }
    case final AvalancheForecast m:
      switch (name) {
        case 'center_id':
          return m.centerId;
        case 'center_name':
          return m.centerName;
        case 'zone_id':
          return m.zoneId;
        case 'zone_name':
          return m.zoneName;
        case 'danger_level':
          return m.dangerLevel;
        case 'danger_label':
          return m.dangerLabel;
        case 'status':
          return m.status;
        case 'valid_from':
          return m.validFrom;
        case 'valid_until':
          return m.validUntil;
        case 'url':
          return m.url;
        case 'center_url':
          return m.centerUrl;
        case 'attribution':
          return m.attribution;
      }
    case final AvalancheZoneCollection m:
      switch (name) {
        case 'type':
          return m.type;
        case 'features':
          return m.features;
        case 'attribution':
          return m.attribution;
      }
    case final AvalancheZoneFeature m:
      switch (name) {
        case 'type':
          return m.type;
        case 'id':
          return m.id;
        case 'geometry':
          return m.geometry;
        case 'properties':
          return m.properties;
      }
    case final AvalancheZoneGeometry m:
      switch (name) {
        case 'type':
          return m.type;
        case 'coordinates':
          return m.coordinates;
      }
    case final AvalancheZoneProperties m:
      switch (name) {
        case 'center_id':
          return m.centerId;
        case 'center_name':
          return m.centerName;
        case 'zone_id':
          return m.zoneId;
        case 'zone_name':
          return m.zoneName;
        case 'danger_level':
          return m.dangerLevel;
        case 'danger_label':
          return m.dangerLabel;
        case 'status':
          return m.status;
        case 'valid_from':
          return m.validFrom;
        case 'valid_until':
          return m.validUntil;
        case 'forecast_url':
          return m.forecastUrl;
        case 'center_url':
          return m.centerUrl;
        case 'attribution':
          return m.attribution;
      }
    case final BandColumns m:
      switch (name) {
        case 'mean':
          return m.mean;
        case 'min':
          return m.min;
        case 'p10':
          return m.p10;
        case 'p25':
          return m.p25;
        case 'p50':
          return m.p50;
        case 'p75':
          return m.p75;
        case 'p90':
          return m.p90;
        case 'max':
          return m.max;
      }
    case final CatalogResolvedEntry m:
      switch (name) {
        case 'id':
          return m.id;
        case 'content_type_key':
          return m.contentTypeKey;
        case 'title':
          return m.title;
        case 'body':
          return m.body;
        case 'slot':
          return m.slot;
        case 'display_order':
          return m.displayOrder;
        case 'locale':
          return m.locale;
        case 'updated_at':
          return m.updatedAt;
      }
    case final CatalogTemplateSummary m:
      switch (name) {
        case 'id':
          return m.id;
        case 'location_type':
          return m.locationType;
        case 'variant':
          return m.variant;
        case 'spec':
          return m.spec;
      }
    case final CircularStats m:
      switch (name) {
        case 'mean':
          return m.mean;
        case 'stddev':
          return m.stddev;
        case 'sector_50':
          return m.sector50;
        case 'sector_90':
          return m.sector90;
      }
    case final CmsTemplateSection m:
      switch (name) {
        case 'kind':
          return m.kind;
        case 'key':
          return m.key;
        case 'config':
          return m.config;
      }
    case final CompositionResponse m:
      switch (name) {
        case 'initialized_at':
          return m.initializedAt;
        case 'models':
          return m.models;
        case 'model_count':
          return m.modelCount;
        case 'total_members':
          return m.totalMembers;
      }
    case final CurrentConditions m:
      switch (name) {
        case 'time':
          return m.time;
        case 'temperature':
          return m.temperature;
        case 'feels_like':
          return m.feelsLike;
        case 'code':
          return m.code;
        case 'text':
          return m.text;
        case 'icon':
          return m.icon;
        case 'wind_speed':
          return m.windSpeed;
        case 'wind_gust':
          return m.windGust;
        case 'wind_direction':
          return m.windDirection;
        case 'relative_humidity':
          return m.relativeHumidity;
        case 'dewpoint':
          return m.dewpoint;
        case 'precipitation_probability':
          return m.precipitationProbability;
        case 'source':
          return m.source;
        case 'station':
          return m.station;
        case 'measured':
          return m.measured;
        case 'cloud_cover':
          return m.cloudCover;
      }
    case final CurrentResponse m:
      switch (name) {
        case 'location':
          return m.location;
        case 'alerts':
          return m.alerts;
        case 'alerts_as_of':
          return m.alertsAsOf;
        case 'sensor_count':
          return m.sensorCount;
        case 'sensors':
          return m.sensors;
        case 'now':
          return m.now;
        case 'as_of':
          return m.asOf;
        case 'model_run_initialized_at':
          return m.modelRunInitializedAt;
        case 'nowcast_hours':
          return m.nowcastHours;
        case 'units':
          return m.units;
        case 'attribution':
          return m.attribution;
        case 'nowcast_unavailable':
          return m.nowcastUnavailable;
        case 'summary':
          return m.summary;
        case 'pass':
          return m.pass;
      }
    case final CurrentStation m:
      switch (name) {
        case 'id':
          return m.id;
        case 'name':
          return m.name;
        case 'observation_time':
          return m.observationTime;
        case 'calm':
          return m.calm;
      }
    case final DailyAstro m:
      switch (name) {
        case 'sunrise':
          return m.sunrise;
        case 'sunset':
          return m.sunset;
        case 'moon_phase':
          return m.moonPhase;
        case 'moon_illumination':
          return m.moonIllumination;
        case 'astronomical_season':
          return m.astronomicalSeason;
      }
    case final DailyForecast m:
      switch (name) {
        case 'date':
          return m.date;
        case 'condition':
          return m.condition;
        case 'condition_text':
          return m.conditionText;
        case 'condition_icon':
          return m.conditionIcon;
        case 'precipitation_type':
          return m.precipitationType;
        case 'high':
          return m.high;
        case 'low':
          return m.low;
        case 'feels_like_high':
          return m.feelsLikeHigh;
        case 'feels_like_low':
          return m.feelsLikeLow;
        case 'total_precipitation':
          return m.totalPrecipitation;
        case 'total_snowfall':
          return m.totalSnowfall;
        case 'precipitation_probability':
          return m.precipitationProbability;
        case 'precipitation_occurrence_probability':
          return m.precipitationOccurrenceProbability;
        case 'snow_probability':
          return m.snowProbability;
        case 'snow_level_mean':
          return m.snowLevelMean;
        case 'snow_level':
          return m.snowLevel;
        case 'total_precipitation_if_wet':
          return m.totalPrecipitationIfWet;
        case 'total_snowfall_if_wet':
          return m.totalSnowfallIfWet;
        case 'precipitation_display':
          return m.precipitationDisplay;
        case 'cloud_cover_mean':
          return m.cloudCoverMean;
        case 'wind':
          return m.wind;
        case 'storm_orientation':
          return m.stormOrientation;
        case 'storm_orientation_description':
          return m.stormOrientationDescription;
        case 'astro':
          return m.astro;
        case 'temperature_climatology':
          return m.temperatureClimatology;
        case 'covered_from':
          return m.coveredFrom;
        case 'measured_precipitation':
          return m.measuredPrecipitation;
        case 'snow_character':
          return m.snowCharacter;
        case 'slr':
          return m.slr;
        case 'snow_level_range':
          return m.snowLevelRange;
        case 'snow_level_wet_bulb':
          return m.snowLevelWetBulb;
        case 'snow_level_wet_bulb_range':
          return m.snowLevelWetBulbRange;
        case 'normal':
          return m.normal;
        case 'departure':
          return m.departure;
        case 'percentile':
          return m.percentile;
      }
    case final DailyWind m:
      switch (name) {
        case 'status':
          return m.status;
        case 'peak_speed':
          return m.peakSpeed;
        case 'peak_speed_p90':
          return m.peakSpeedP90;
        case 'is_gust':
          return m.isGust;
        case 'sustained_speed':
          return m.sustainedSpeed;
      }
    case final DayClimatology m:
      switch (name) {
        case 'mean':
          return m.mean;
        case 'std':
          return m.std;
      }
    case final DayDeparture m:
      switch (name) {
        case 'high':
          return m.high;
        case 'low':
          return m.low;
      }
    case final DayNormal m:
      switch (name) {
        case 'high':
          return m.high;
        case 'low':
          return m.low;
        case 'precipitation':
          return m.precipitation;
        case 'source':
          return m.source;
        case 'distance_km':
          return m.distanceKm;
      }
    case final DayPercentile m:
      switch (name) {
        case 'high':
          return m.high;
        case 'low':
          return m.low;
        case 'precipitation':
          return m.precipitation;
      }
    case final ElevationForecast m:
      switch (name) {
        case 'name':
          return m.name;
        case 'display_name':
          return m.displayName;
        case 'height':
          return m.height;
        case 'lat':
          return m.lat;
        case 'lon':
          return m.lon;
        case 'hourly':
          return m.hourly;
        case 'daily':
          return m.daily;
        case 'snow_outlook':
          return m.snowOutlook;
        case 'precipitation_outlook':
          return m.precipitationOutlook;
        case 'plume':
          return m.plume;
        case 'snow_on_ground':
          return m.snowOnGround;
        case 'nearest_sensors':
          return m.nearestSensors;
      }
    case final ElevationSummary m:
      switch (name) {
        case 'name':
          return m.name;
        case 'display_name':
          return m.displayName;
        case 'height':
          return m.height;
        case 'default':
          return m.isDefault;
      }
    case final EnsembleStats m:
      switch (name) {
        case 'temperature':
          return m.temperature;
        case 'feels_like':
          return m.feelsLike;
        case 'dewpoint':
          return m.dewpoint;
        case 'precipitation':
          return m.precipitation;
        case 'wind_speed':
          return m.windSpeed;
        case 'wind_gust':
          return m.windGust;
        case 'wind_direction':
          return m.windDirection;
        case 'snow_level':
          return m.snowLevel;
        case 'snow_level_wet_bulb':
          return m.snowLevelWetBulb;
        case 'slr':
          return m.slr;
        case 'snowfall':
          return m.snowfall;
        case 'cloud_cover':
          return m.cloudCover;
        case 'skin_temperature':
          return m.skinTemperature;
        case 'mslp':
          return m.mslp;
        case 'cape':
          return m.cape;
        case 'relative_humidity':
          return m.relativeHumidity;
      }
    case final ExploreItem m:
      switch (name) {
        case 'rank':
          return m.rank;
        case 'location':
          return m.location;
        case 'elevation_name':
          return m.elevationName;
        case 'elevation_display_name':
          return m.elevationDisplayName;
        case 'elevation':
          return m.elevation;
        case 'value':
          return m.value;
        case 'p10':
          return m.p10;
        case 'p90':
          return m.p90;
        case 'as_of':
          return m.asOf;
        case 'initialized_at':
          return m.initializedAt;
        case 'source':
          return m.source;
        case 'distance_km':
          return m.distanceKm;
        case 'path':
          return m.path;
      }
    case final ExploreResponse m:
      switch (name) {
        case 'metric':
          return m.metric;
        case 'order':
          return m.order;
        case 'units':
          return m.units;
        case 'unit':
          return m.unit;
        case 'items':
          return m.items;
        case 'count':
          return m.count;
        case 'next_cursor':
          return m.nextCursor;
      }
    case final ExploreValue m:
      switch (name) {
        case 'metric':
          return m.metric;
        case 'value':
          return m.value;
        case 'unit':
          return m.unit;
        case 'p10':
          return m.p10;
        case 'p90':
          return m.p90;
        case 'as_of':
          return m.asOf;
        case 'initialized_at':
          return m.initializedAt;
        case 'source':
          return m.source;
      }
    case final ForecastData m:
      switch (name) {
        case 'max_hours':
          return m.maxHours;
        case 'interval_hours':
          return m.intervalHours;
        case 'timeseries':
          return m.timeseries;
        case 'daily':
          return m.daily;
        case 'snow_outlook':
          return m.snowOutlook;
        case 'precipitation_outlook':
          return m.precipitationOutlook;
        case 'plume':
          return m.plume;
      }
    case final ForecastLocation m:
      switch (name) {
        case 'slug':
          return m.slug;
        case 'state':
          return m.state;
        case 'name':
          return m.name;
        case 'lat':
          return m.lat;
        case 'lon':
          return m.lon;
        case 'elevation_m':
          return m.elevationM;
        case 'type':
          return m.type;
        case 'timezone':
          return m.timezone;
        case 'elevation':
          return m.elevation;
        case 'elevations':
          return m.elevations;
      }
    case final ForecastResponse m:
      switch (name) {
        case 'thresholds':
          return m.thresholds;
        case 'probabilities':
          return m.probabilities;
        case 'window_totals':
          return m.windowTotals;
        case 'applied':
          return m.applied;
        case 'location':
          return m.location;
        case 'model_run':
          return m.modelRun;
        case 'units':
          return m.units;
        case 'series':
          return m.series;
        case 'elevations':
          return m.elevations;
        case 'nowcast_applied':
          return m.nowcastApplied;
        case 'nowcast_unavailable':
          return m.nowcastUnavailable;
        case 'members_view':
          return m.membersView;
        case 'gap_flow':
          return m.gapFlow;
        case 'nearest_sensors':
          return m.nearestSensors;
        case 'point':
          return m.point;
        case 'current':
          return m.current;
        case 'snow_on_ground':
          return m.snowOnGround;
        case 'avalanche':
          return m.avalanche;
        case 'attribution':
          return m.attribution;
      }
    case final FreezingLevel m:
      switch (name) {
        case 'kind':
          return m.kind;
        case 'height':
          return m.height;
        case 'above_freezing_layer_aloft':
          return m.aboveFreezingLayerAloft;
        case 'top':
          return m.top;
      }
    case final GapFlow m:
      switch (name) {
        case 'status':
          return m.status;
        case 'pressure_diff_hpa':
          return m.pressureDiffHpa;
        case 'wind_multiplier':
          return m.windMultiplier;
        case 'direction':
          return m.direction;
      }
    case final HourProvenance m:
      switch (name) {
        case 'densified':
          return m.densified;
        case 'ngr':
          return m.ngr;
        case 'fallback':
          return m.fallback;
        case 'borrowed':
          return m.borrowed;
        case 'spread_floored':
          return m.spreadFloored;
        case 'floor_clamped':
          return m.floorClamped;
        case 'bucket_split':
          return m.bucketSplit;
        case 'distribution_parameters':
          return m.distributionParameters;
        case 'spread_interpolated':
          return m.spreadInterpolated;
        case 'interpolated_contributor':
          return m.interpolatedContributor;
        case 'moment_matched_family':
          return m.momentMatchedFamily;
        case 'lapse_profile':
          return m.lapseProfile;
        case 'lapse_climatology':
          return m.lapseClimatology;
        case 'lapse_prism':
          return m.lapsePrism;
        case 'spread_clamped_low':
          return m.spreadClampedLow;
        case 'spread_clamped_high':
          return m.spreadClampedHigh;
        case 'gust_dressed':
          return m.gustDressed;
      }
    case final InversionInfo m:
      switch (name) {
        case 'kind':
          return m.kind;
        case 'depth':
          return m.depth;
        case 'strength':
          return m.strength;
      }
    case final LocationRef m:
      switch (name) {
        case 'slug':
          return m.slug;
        case 'state':
          return m.state;
        case 'name':
          return m.name;
        case 'lat':
          return m.lat;
        case 'lon':
          return m.lon;
        case 'elevation_m':
          return m.elevationM;
        case 'type':
          return m.type;
        case 'timezone':
          return m.timezone;
      }
    case final LocationSummary m:
      switch (name) {
        case 'slug':
          return m.slug;
        case 'state':
          return m.state;
        case 'name':
          return m.name;
        case 'lat':
          return m.lat;
        case 'lon':
          return m.lon;
        case 'elevation_m':
          return m.elevationM;
        case 'type':
          return m.type;
        case 'timezone':
          return m.timezone;
        case 'county':
          return m.county;
        case 'description':
          return m.description;
        case 'elevations':
          return m.elevations;
      }
    case final LocationsResponse m:
      switch (name) {
        case 'state':
          return m.state;
        case 'count':
          return m.count;
        case 'items':
          return m.items;
        case 'next_cursor':
          return m.nextCursor;
      }
    case final MeasuredPrecipitation m:
      switch (name) {
        case 'amount':
          return m.amount;
        case 'through':
          return m.through;
      }
    case final MemberForecast m:
      switch (name) {
        case 'id':
          return m.id;
        case 'temperature':
          return m.temperature;
        case 'precipitation':
          return m.precipitation;
        case 'precipitation_hours':
          return m.precipitationHours;
        case 'wind_speed':
          return m.windSpeed;
        case 'wind_direction':
          return m.windDirection;
        case 'snow_level':
          return m.snowLevel;
        case 'snow_level_wet_bulb':
          return m.snowLevelWetBulb;
        case 'slr':
          return m.slr;
        case 'snowfall':
          return m.snowfall;
        case 'cumulative_precipitation':
          return m.cumulativePrecipitation;
        case 'cumulative_snowfall':
          return m.cumulativeSnowfall;
      }
    case final MemberGroup m:
      switch (name) {
        case 'id':
          return m.id;
        case 'items':
          return m.items;
      }
    case final MemberPlume m:
      switch (name) {
        case 'headline':
          return m.headline;
        case 'bands':
          return m.bands;
        case 'models':
          return m.models;
        case 'pool':
          return m.pool;
      }
    case final MemberQuantiles m:
      switch (name) {
        case 'mean':
          return m.mean;
        case 'p10':
          return m.p10;
        case 'p25':
          return m.p25;
        case 'p50':
          return m.p50;
        case 'p75':
          return m.p75;
        case 'p90':
          return m.p90;
        case 'min':
          return m.min;
        case 'max':
          return m.max;
        case 'probability':
          return m.probability;
      }
    case final MembersCumulative m:
      switch (name) {
        case 'precipitation':
          return m.precipitation;
        case 'snowfall':
          return m.snowfall;
      }
    case final MembersSpread m:
      switch (name) {
        case 'temperature':
          return m.temperature;
        case 'snow_level':
          return m.snowLevel;
        case 'snow_level_wet_bulb':
          return m.snowLevelWetBulb;
        case 'slr':
          return m.slr;
        case 'wind_speed':
          return m.windSpeed;
      }
    case final ModelColumns m:
      switch (name) {
        case 'id':
          return m.id;
        case 'valid_time':
          return m.validTime;
        case 'member_ids':
          return m.memberIds;
        case 'temperature':
          return m.temperature;
        case 'precipitation':
          return m.precipitation;
        case 'precipitation_hours':
          return m.precipitationHours;
        case 'cumulative_precipitation':
          return m.cumulativePrecipitation;
        case 'snow_level':
          return m.snowLevel;
        case 'snow_level_wet_bulb':
          return m.snowLevelWetBulb;
        case 'snowfall':
          return m.snowfall;
        case 'cumulative_snowfall':
          return m.cumulativeSnowfall;
        case 'cumulative_snowfall_p50':
          return m.cumulativeSnowfallP50;
        case 'cumulative_snowfall_10to1_p50':
          return m.cumulativeSnowfall10to1P50;
        case 'temperature_mean':
          return m.temperatureMean;
        case 'precipitation_mean':
          return m.precipitationMean;
        case 'cumulative_precipitation_mean':
          return m.cumulativePrecipitationMean;
        case 'snow_level_mean':
          return m.snowLevelMean;
        case 'snow_level_wet_bulb_mean':
          return m.snowLevelWetBulbMean;
        case 'snowfall_mean':
          return m.snowfallMean;
        case 'cumulative_snowfall_mean':
          return m.cumulativeSnowfallMean;
        case 'cumulative_snowfall_10to1_mean':
          return m.cumulativeSnowfall10to1Mean;
        case 'wind_speed_mean':
          return m.windSpeedMean;
        case 'cumulative_precipitation_band_member_ids':
          return m.cumulativePrecipitationBandMemberIds;
        case 'cumulative_snowfall_band_member_ids':
          return m.cumulativeSnowfallBandMemberIds;
        case 'cumulative_snowfall_10to1_band_member_ids':
          return m.cumulativeSnowfall10to1BandMemberIds;
        case 'wind_speed':
          return m.windSpeed;
        case 'wind_direction':
          return m.windDirection;
        case 'slr':
          return m.slr;
      }
    case final ModelEntry m:
      switch (name) {
        case 'id':
          return m.id;
        case 'cycle':
          return m.cycle;
        case 'members':
          return m.members;
        case 'display_members':
          return m.displayMembers;
        case 'display_members_snowfall':
          return m.displayMembersSnowfall;
      }
    case final ModelRunInfo m:
      switch (name) {
        case 'initialized_at':
          return m.initializedAt;
        case 'total_members':
          return m.totalMembers;
        case 'models':
          return m.models;
      }
    case final ModelStats m:
      switch (name) {
        case 'id':
          return m.id;
        case 'temperature':
          return m.temperature;
        case 'dewpoint':
          return m.dewpoint;
        case 'precipitation':
          return m.precipitation;
        case 'wind_speed':
          return m.windSpeed;
        case 'wind_direction':
          return m.windDirection;
        case 'snow_level':
          return m.snowLevel;
        case 'snow_level_wet_bulb':
          return m.snowLevelWetBulb;
        case 'slr':
          return m.slr;
        case 'snowfall':
          return m.snowfall;
        case 'interpolated':
          return m.interpolated;
      }
    case final NearbyLocation m:
      switch (name) {
        case 'slug':
          return m.slug;
        case 'state':
          return m.state;
        case 'name':
          return m.name;
        case 'lat':
          return m.lat;
        case 'lon':
          return m.lon;
        case 'elevation_m':
          return m.elevationM;
        case 'type':
          return m.type;
        case 'timezone':
          return m.timezone;
        case 'county':
          return m.county;
        case 'description':
          return m.description;
        case 'elevations':
          return m.elevations;
        case 'distance_km':
          return m.distanceKm;
      }
    case final NearbyLocationsResponse m:
      switch (name) {
        case 'origin':
          return m.origin;
        case 'radius_km':
          return m.radiusKm;
        case 'count':
          return m.count;
        case 'items':
          return m.items;
      }
    case final NearbyPointResponse m:
      switch (name) {
        case 'lat':
          return m.lat;
        case 'lon':
          return m.lon;
        case 'radius_km':
          return m.radiusKm;
        case 'count':
          return m.count;
        case 'items':
          return m.items;
      }
    case final NearestLocation m:
      switch (name) {
        case 'slug':
          return m.slug;
        case 'url':
          return m.url;
        case 'distance_km':
          return m.distanceKm;
        case 'elevation_m':
          return m.elevationM;
      }
    case final NearestSensor m:
      switch (name) {
        case 'station_id':
          return m.stationId;
        case 'name':
          return m.name;
        case 'source':
          return m.source;
        case 'distance_km':
          return m.distanceKm;
        case 'elevation_diff':
          return m.elevationDiff;
        case 'effective_distance_km':
          return m.effectiveDistanceKm;
        case 'observation_time':
          return m.observationTime;
      }
    case final PassCamera m:
      switch (name) {
        case 'id':
          return m.id;
        case 'title':
          return m.title;
        case 'image_url':
          return m.imageUrl;
        case 'url':
          return m.url;
        case 'captured_at':
          return m.capturedAt;
        case 'stale':
          return m.stale;
        case 'source':
          return m.source;
        case 'attribution':
          return m.attribution;
      }
    case final PassChance m:
      switch (name) {
        case 'probability':
          return m.probability;
        case 'threshold':
          return m.threshold;
        case 'precipitation_threshold':
          return m.precipitationThreshold;
        case 'members':
          return m.members;
        case 'method':
          return m.method;
        case 'null_reason':
          return m.nullReason;
      }
    case final PassChances m:
      switch (name) {
        case 'window_hours':
          return m.windowHours;
        case 'from':
          return m.from;
        case 'to':
          return m.to;
        case 'p_snow_ge_1in':
          return m.pSnowGe1in;
        case 'p_snow_ge_6in':
          return m.pSnowGe6in;
        case 'p_wet_below_freezing':
          return m.pWetBelowFreezing;
        case 'p_gust_gt_40mph':
          return m.pGustGt40mph;
      }
    case final PassForecast m:
      switch (name) {
        case 'elevation':
          return m.elevation;
        case 'elevation_m':
          return m.elevationM;
        case 'from':
          return m.from;
        case 'snow_24h':
          return m.snow24h;
        case 'chances':
          return m.chances;
        case 'snow_windows':
          return m.snowWindows;
        case 'hours':
          return m.hours;
        case 'windows':
          return m.windows;
        case 'official_status':
          return m.officialStatus;
        case 'road_sensors':
          return m.roadSensors;
        case 'cameras':
          return m.cameras;
      }
    case final PassHour m:
      switch (name) {
        case 'time':
          return m.time;
        case 'temperature':
          return m.temperature;
        case 'precipitation':
          return m.precipitation;
        case 'precipitation_probability':
          return m.precipitationProbability;
        case 'precipitation_type':
          return m.precipitationType;
        case 'snowfall':
          return m.snowfall;
        case 'snow_level':
          return m.snowLevel;
        case 'snow_level_margin':
          return m.snowLevelMargin;
        case 'freezing_on_wet_road':
          return m.freezingOnWetRoad;
        case 'wind_speed':
          return m.windSpeed;
        case 'wind_gust':
          return m.windGust;
        case 'gust_over_40mph':
          return m.gustOver40mph;
        case 'blowing_snow':
          return m.blowingSnow;
      }
    case final PassOfficialStatus m:
      switch (name) {
        case 'source':
          return m.source;
        case 'attribution':
          return m.attribution;
        case 'url':
          return m.url;
        case 'checked_at':
          return m.checkedAt;
        case 'stale':
          return m.stale;
        case 'level':
          return m.level;
        case 'segments':
          return m.segments;
      }
    case final PassRoadSensor m:
      switch (name) {
        case 'station_id':
          return m.stationId;
        case 'name':
          return m.name;
        case 'source':
          return m.source;
        case 'attribution':
          return m.attribution;
        case 'distance_km':
          return m.distanceKm;
        case 'elevation':
          return m.elevation;
        case 'elevation_m':
          return m.elevationM;
        case 'observed_at':
          return m.observedAt;
        case 'stale':
          return m.stale;
        case 'pavement_condition':
          return m.pavementCondition;
        case 'pavement_temp':
          return m.pavementTemp;
        case 'subsurface_temp':
          return m.subsurfaceTemp;
        case 'temperature':
          return m.temperature;
        case 'wind_speed':
          return m.windSpeed;
        case 'wind_gust':
          return m.windGust;
        case 'wind_direction':
          return m.windDirection;
        case 'visibility':
          return m.visibility;
      }
    case final PassSnow24h m:
      switch (name) {
        case 'total':
          return m.total;
        case 'p10':
          return m.p10;
        case 'p90':
          return m.p90;
        case 'starts_at':
          return m.startsAt;
      }
    case final PassSnowWindow m:
      switch (name) {
        case 'start':
          return m.start;
        case 'end':
          return m.end;
        case 'total':
          return m.total;
        case 'p10':
          return m.p10;
        case 'p90':
          return m.p90;
        case 'p_ge_1in':
          return m.pGe1in;
      }
    case final PassStatusSegment m:
      switch (name) {
        case 'id':
          return m.id;
        case 'route':
          return m.route;
        case 'direction':
          return m.direction;
        case 'location':
          return m.location;
        case 'state':
          return m.state;
        case 'level':
          return m.level;
        case 'text':
          return m.text;
        case 'updated_at':
          return m.updatedAt;
        case 'lat':
          return m.lat;
        case 'lon':
          return m.lon;
        case 'road_condition':
          return m.roadCondition;
        case 'weather_condition':
          return m.weatherCondition;
      }
    case final PassTravelWindow m:
      switch (name) {
        case 'start':
          return m.start;
        case 'end':
          return m.end;
        case 'snowfall':
          return m.snowfall;
        case 'freezing_on_wet_road_hours':
          return m.freezingOnWetRoadHours;
        case 'max_wind_gust':
          return m.maxWindGust;
      }
    case final PassTravelWindows m:
      switch (name) {
        case 'horizon_hours':
          return m.horizonHours;
        case 'least_weather':
          return m.leastWeather;
        case 'most_weather':
          return m.mostWeather;
      }
    case final PlaceSummary m:
      switch (name) {
        case 'short':
          return m.short;
        case 'long':
          return m.long;
        case 'events':
          return m.events;
        case 'elevation_name':
          return m.elevationName;
        case 'elevation':
          return m.elevation;
        case 'run':
          return m.run;
        case 'generated_at':
          return m.generatedAt;
      }
    case final PlumeBands m:
      switch (name) {
        case 'valid_time':
          return m.validTime;
        case 'cumulative_precipitation':
          return m.cumulativePrecipitation;
        case 'cumulative_snowfall':
          return m.cumulativeSnowfall;
        case 'cumulative_snowfall_10to1':
          return m.cumulativeSnowfall10to1;
        case 'temperature':
          return m.temperature;
        case 'snow_level':
          return m.snowLevel;
        case 'snow_level_wet_bulb':
          return m.snowLevelWetBulb;
        case 'precipitation_6h':
          return m.precipitation6h;
        case 'snowfall_6h':
          return m.snowfall6h;
        case 'slr':
          return m.slr;
        case 'wind_speed':
          return m.windSpeed;
      }
    case final PlumeHeadline m:
      switch (name) {
        case 'valid_time':
          return m.validTime;
        case 'temperature':
          return m.temperature;
        case 'snow_level':
          return m.snowLevel;
        case 'snow_level_wet_bulb':
          return m.snowLevelWetBulb;
        case 'cumulative_precipitation':
          return m.cumulativePrecipitation;
        case 'cumulative_snowfall':
          return m.cumulativeSnowfall;
        case 'cumulative_snowfall_10to1':
          return m.cumulativeSnowfall10to1;
        case 'wind_speed':
          return m.windSpeed;
        case 'snowfall_6h':
          return m.snowfall6h;
      }
    case final PointInfo m:
      switch (name) {
        case 'requested_lat':
          return m.requestedLat;
        case 'requested_lon':
          return m.requestedLon;
        case 'lat':
          return m.lat;
        case 'lon':
          return m.lon;
        case 'resolution_deg':
          return m.resolutionDeg;
        case 'elevation':
          return m.elevation;
        case 'elevation_source':
          return m.elevationSource;
        case 'state':
          return m.state;
      }
    case final PooledColumns m:
      switch (name) {
        case 'valid_time':
          return m.validTime;
        case 'temperature':
          return m.temperature;
        case 'precipitation':
          return m.precipitation;
        case 'precipitation_hours':
          return m.precipitationHours;
        case 'cumulative_precipitation':
          return m.cumulativePrecipitation;
        case 'snow_level':
          return m.snowLevel;
        case 'snow_level_wet_bulb':
          return m.snowLevelWetBulb;
        case 'snowfall':
          return m.snowfall;
        case 'cumulative_snowfall':
          return m.cumulativeSnowfall;
        case 'slr':
          return m.slr;
        case 'cumulative_precipitation_band_members':
          return m.cumulativePrecipitationBandMembers;
        case 'cumulative_snowfall_band_members':
          return m.cumulativeSnowfallBandMembers;
        case 'cumulative_snowfall_10to1_band_members':
          return m.cumulativeSnowfall10to1BandMembers;
      }
    case final PrecipDisplay m:
      switch (name) {
        case 'kind':
          return m.kind;
        case 'chance':
          return m.chance;
        case 'amount':
          return m.amount;
        case 'snow_amount':
          return m.snowAmount;
      }
    case final PrecipOutlook m:
      switch (name) {
        case 'next_24h':
          return m.next24h;
        case 'next_48h':
          return m.next48h;
        case 'next_72h':
          return m.next72h;
        case 'next_7d':
          return m.next7d;
        case 'quantiles':
          return m.quantiles;
      }
    case final PrecipType m:
      switch (name) {
        case 'type':
          return m.type;
        case 'snow_probability':
          return m.snowProbability;
        case 'rain_probability':
          return m.rainProbability;
      }
    case final PrecipitationByType m:
      switch (name) {
        case 'rain':
          return m.rain;
        case 'snow':
          return m.snow;
        case 'rain_snow_mix':
          return m.rainSnowMix;
        case 'freezing_rain':
          return m.freezingRain;
      }
    case final ProbabilityResult m:
      switch (name) {
        case 'term':
          return m.term;
        case 'variable':
          return m.variable;
        case 'op':
          return m.op;
        case 'threshold':
          return m.threshold;
        case 'window_start_hours':
          return m.windowStartHours;
        case 'window_end_hours':
          return m.windowEndHours;
        case 'aggregation':
          return m.aggregation;
        case 'from':
          return m.from;
        case 'to':
          return m.to;
        case 'value':
          return m.value;
        case 'members':
          return m.members;
        case 'null_reason':
          return m.nullReason;
        case 'request':
          return m.request;
      }
    case final ProbabilityThresholds m:
      switch (name) {
        case 'hourly_precipitation':
          return m.hourlyPrecipitation;
        case 'hourly_snowfall':
          return m.hourlySnowfall;
        case 'daily_precipitation':
          return m.dailyPrecipitation;
        case 'daily_precipitation_occurrence':
          return m.dailyPrecipitationOccurrence;
        case 'daily_snow':
          return m.dailySnow;
      }
    case final PublicCatalogElevation m:
      switch (name) {
        case 'label':
          return m.label;
        case 'display_name':
          return m.displayName;
        case 'height_m':
          return m.heightM;
        case 'lat_override':
          return m.latOverride;
        case 'lon_override':
          return m.lonOverride;
        case 'is_default':
          return m.isDefault;
      }
    case final PublicCatalogLocation m:
      switch (name) {
        case 'slug':
          return m.slug;
        case 'state':
          return m.state;
        case 'name':
          return m.name;
        case 'lat':
          return m.lat;
        case 'lon':
          return m.lon;
        case 'elevation_m':
          return m.elevationM;
        case 'type':
          return m.type;
        case 'timezone':
          return m.timezone;
        case 'county':
          return m.county;
        case 'country':
          return m.country;
        case 'aliases':
          return m.aliases;
        case 'description_short':
          return m.descriptionShort;
        case 'description_long':
          return m.descriptionLong;
        case 'microclimate_notes':
          return m.microclimateNotes;
        case 'meta_title':
          return m.metaTitle;
        case 'meta_description':
          return m.metaDescription;
        case 'best_seasons':
          return m.bestSeasons;
        case 'key_factors':
          return m.keyFactors;
        case 'tags':
          return m.tags;
        case 'external_links':
          return m.externalLinks;
        case 'is_featured':
          return m.isFeatured;
      }
    case final PublicCatalogLocationDetail m:
      switch (name) {
        case 'slug':
          return m.slug;
        case 'state':
          return m.state;
        case 'name':
          return m.name;
        case 'lat':
          return m.lat;
        case 'lon':
          return m.lon;
        case 'elevation_m':
          return m.elevationM;
        case 'type':
          return m.type;
        case 'timezone':
          return m.timezone;
        case 'county':
          return m.county;
        case 'country':
          return m.country;
        case 'aliases':
          return m.aliases;
        case 'description_short':
          return m.descriptionShort;
        case 'description_long':
          return m.descriptionLong;
        case 'microclimate_notes':
          return m.microclimateNotes;
        case 'meta_title':
          return m.metaTitle;
        case 'meta_description':
          return m.metaDescription;
        case 'best_seasons':
          return m.bestSeasons;
        case 'key_factors':
          return m.keyFactors;
        case 'tags':
          return m.tags;
        case 'external_links':
          return m.externalLinks;
        case 'is_featured':
          return m.isFeatured;
        case 'elevations':
          return m.elevations;
        case 'photos':
          return m.photos;
        case 'webcams':
          return m.webcams;
        case 'nearby_stations':
          return m.nearbyStations;
        case 'template':
          return m.template;
        case 'content':
          return m.content;
      }
    case final PublicCatalogLocationPage m:
      switch (name) {
        case 'items':
          return m.items;
        case 'next_cursor':
          return m.nextCursor;
      }
    case final PublicCatalogNearbyStation m:
      switch (name) {
        case 'slug':
          return m.slug;
        case 'name':
          return m.name;
        case 'network':
          return m.network;
        case 'status':
          return m.status;
        case 'distance_km':
          return m.distanceKm;
        case 'elevation_diff_m':
          return m.elevationDiffM;
        case 'is_primary':
          return m.isPrimary;
      }
    case final PublicCatalogPhoto m:
      switch (name) {
        case 'url':
          return m.url;
        case 'caption':
          return m.caption;
        case 'credit':
          return m.credit;
        case 'alt_text':
          return m.altText;
        case 'license':
          return m.license;
        case 'license_url':
          return m.licenseUrl;
      }
    case final PublicCatalogPrimaryLocation m:
      switch (name) {
        case 'slug':
          return m.slug;
        case 'name':
          return m.name;
        case 'lat':
          return m.lat;
        case 'lon':
          return m.lon;
        case 'elevation_m':
          return m.elevationM;
        case 'type':
          return m.type;
      }
    case final PublicCatalogStation m:
      switch (name) {
        case 'slug':
          return m.slug;
        case 'state':
          return m.state;
        case 'name':
          return m.name;
        case 'lat':
          return m.lat;
        case 'lon':
          return m.lon;
        case 'elevation_m':
          return m.elevationM;
        case 'type':
          return m.type;
        case 'timezone':
          return m.timezone;
        case 'county':
          return m.county;
        case 'country':
          return m.country;
        case 'aliases':
          return m.aliases;
        case 'network':
          return m.network;
        case 'source_id':
          return m.sourceId;
        case 'elevation_msl_m':
          return m.elevationMslM;
        case 'sensor_height_agl_m':
          return m.sensorHeightAglM;
        case 'sensor_capabilities':
          return m.sensorCapabilities;
        case 'status':
          return m.status;
        case 'last_report_at':
          return m.lastReportAt;
        case 'last_report_summary':
          return m.lastReportSummary;
        case 'install_date':
          return m.installDate;
        case 'decommission_date':
          return m.decommissionDate;
        case 'update_frequency_minutes':
          return m.updateFrequencyMinutes;
        case 'url':
          return m.url;
        case 'data_url':
          return m.dataUrl;
        case 'description_short':
          return m.descriptionShort;
        case 'description_long':
          return m.descriptionLong;
        case 'meta_title':
          return m.metaTitle;
        case 'meta_description':
          return m.metaDescription;
        case 'tags':
          return m.tags;
        case 'is_featured':
          return m.isFeatured;
      }
    case final PublicCatalogStationDetail m:
      switch (name) {
        case 'slug':
          return m.slug;
        case 'state':
          return m.state;
        case 'name':
          return m.name;
        case 'lat':
          return m.lat;
        case 'lon':
          return m.lon;
        case 'elevation_m':
          return m.elevationM;
        case 'type':
          return m.type;
        case 'timezone':
          return m.timezone;
        case 'county':
          return m.county;
        case 'country':
          return m.country;
        case 'aliases':
          return m.aliases;
        case 'network':
          return m.network;
        case 'source_id':
          return m.sourceId;
        case 'elevation_msl_m':
          return m.elevationMslM;
        case 'sensor_height_agl_m':
          return m.sensorHeightAglM;
        case 'sensor_capabilities':
          return m.sensorCapabilities;
        case 'status':
          return m.status;
        case 'last_report_at':
          return m.lastReportAt;
        case 'last_report_summary':
          return m.lastReportSummary;
        case 'install_date':
          return m.installDate;
        case 'decommission_date':
          return m.decommissionDate;
        case 'update_frequency_minutes':
          return m.updateFrequencyMinutes;
        case 'url':
          return m.url;
        case 'data_url':
          return m.dataUrl;
        case 'description_short':
          return m.descriptionShort;
        case 'description_long':
          return m.descriptionLong;
        case 'meta_title':
          return m.metaTitle;
        case 'meta_description':
          return m.metaDescription;
        case 'tags':
          return m.tags;
        case 'is_featured':
          return m.isFeatured;
        case 'photos':
          return m.photos;
        case 'webcams':
          return m.webcams;
        case 'indexable':
          return m.indexable;
        case 'primary_location':
          return m.primaryLocation;
        case 'template':
          return m.template;
        case 'content':
          return m.content;
      }
    case final PublicCatalogStationPage m:
      switch (name) {
        case 'items':
          return m.items;
        case 'next_cursor':
          return m.nextCursor;
      }
    case final PublicCatalogWebcam m:
      switch (name) {
        case 'name':
          return m.name;
        case 'url':
          return m.url;
        case 'embed_type':
          return m.embedType;
        case 'provider':
          return m.provider;
        case 'refresh_interval_seconds':
          return m.refreshIntervalSeconds;
      }
    case final Quantiles m:
      switch (name) {
        case 'mean':
          return m.mean;
        case 'p10':
          return m.p10;
        case 'p25':
          return m.p25;
        case 'p50':
          return m.p50;
        case 'p75':
          return m.p75;
        case 'p90':
          return m.p90;
        case 'min':
          return m.min;
        case 'max':
          return m.max;
        case 'probability':
          return m.probability;
      }
    case final ResponseAttribution m:
      switch (name) {
        case 'sources':
          return m.sources;
        case 'credit':
          return m.credit;
        case 'url':
          return m.url;
      }
    case final RunEntry m:
      switch (name) {
        case 'initialized_at':
          return m.initializedAt;
      }
    case final RunsResponse m:
      switch (name) {
        case 'served':
          return m.served;
        case 'items':
          return m.items;
        case 'count':
          return m.count;
        case 'next_cursor':
          return m.nextCursor;
      }
    case final SearchHit m:
      switch (name) {
        case 'slug':
          return m.slug;
        case 'state':
          return m.state;
        case 'name':
          return m.name;
        case 'lat':
          return m.lat;
        case 'lon':
          return m.lon;
        case 'elevation_m':
          return m.elevationM;
        case 'type':
          return m.type;
        case 'timezone':
          return m.timezone;
        case 'key':
          return m.key;
        case 'county':
          return m.county;
        case 'explore':
          return m.explore;
      }
    case final SearchLocationsResponse m:
      switch (name) {
        case 'items':
          return m.items;
        case 'count':
          return m.count;
      }
    case final SeasonDay m:
      switch (name) {
        case 'date':
          return m.date;
        case 'precipitation':
          return m.precipitation;
        case 'snowfall':
          return m.snowfall;
        case 'provisional':
          return m.provisional;
      }
    case final SeasonResponse m:
      switch (name) {
        case 'location':
          return m.location;
        case 'water_year':
          return m.waterYear;
        case 'starts':
          return m.starts;
        case 'through':
          return m.through;
        case 'as_of':
          return m.asOf;
        case 'units':
          return m.units;
        case 'precipitation':
          return m.precipitation;
        case 'snowfall':
          return m.snowfall;
        case 'station':
          return m.station;
        case 'daily':
          return m.daily;
        case 'attribution':
          return m.attribution;
      }
    case final SeasonStation m:
      switch (name) {
        case 'id':
          return m.id;
        case 'network':
          return m.network;
        case 'name':
          return m.name;
        case 'distance_km':
          return m.distanceKm;
        case 'elevation_m':
          return m.elevationM;
        case 'precipitation_total':
          return m.precipitationTotal;
        case 'precipitation_percent_of_median':
          return m.precipitationPercentOfMedian;
        case 'swe':
          return m.swe;
        case 'swe_percent_of_median':
          return m.swePercentOfMedian;
        case 'snow_depth':
          return m.snowDepth;
        case 'through':
          return m.through;
      }
    case final SeasonTotal m:
      switch (name) {
        case 'amount':
          return m.amount;
        case 'unit':
          return m.unit;
        case 'source':
          return m.source;
        case 'days_covered':
          return m.daysCovered;
        case 'days_missing':
          return m.daysMissing;
        case 'provisional_days':
          return m.provisionalDays;
        case 'normal_to_date':
          return m.normalToDate;
        case 'percent_of_normal':
          return m.percentOfNormal;
        case 'normal_source':
          return m.normalSource;
      }
    case final Sector m:
      switch (name) {
        case 'from':
          return m.from;
        case 'to':
          return m.to;
      }
    case final SensorObservation m:
      switch (name) {
        case 'station_id':
          return m.stationId;
        case 'name':
          return m.name;
        case 'source':
          return m.source;
        case 'observed_at':
          return m.observedAt;
        case 'distance_km':
          return m.distanceKm;
        case 'elevation_diff':
          return m.elevationDiff;
        case 'temperature':
          return m.temperature;
        case 'dewpoint':
          return m.dewpoint;
        case 'relative_humidity':
          return m.relativeHumidity;
        case 'wind_speed':
          return m.windSpeed;
        case 'wind_gust':
          return m.windGust;
        case 'wind_direction':
          return m.windDirection;
        case 'pressure':
          return m.pressure;
        case 'precipitation':
          return m.precipitation;
        case 'precipitation_rate':
          return m.precipitationRate;
        case 'reflectivity':
          return m.reflectivity;
        case 'pavement_temp':
          return m.pavementTemp;
        case 'subsurface_temp':
          return m.subsurfaceTemp;
        case 'visibility':
          return m.visibility;
        case 'cloud_cover':
          return m.cloudCover;
        case 'ceiling_height':
          return m.ceilingHeight;
        case 'snow_depth':
          return m.snowDepth;
        case 'swe':
          return m.swe;
        case 'swe_percent_of_median':
          return m.swePercentOfMedian;
        case 'snowfall':
          return m.snowfall;
        case 'solar_radiation':
          return m.solarRadiation;
        case 'pavement_condition':
          return m.pavementCondition;
      }
    case final ServedRun m:
      switch (name) {
        case 'initialized_at':
          return m.initializedAt;
        case 'models':
          return m.models;
      }
    case final SnowLevelRange m:
      switch (name) {
        case 'low':
          return m.low;
        case 'high':
          return m.high;
        case 'mean':
          return m.mean;
      }
    case final SnowOnGround m:
      switch (name) {
        case 'beta':
          return m.beta;
        case 'depth':
          return m.depth;
        case 'basis':
          return m.basis;
        case 'surface':
          return m.surface;
        case 'valid_time':
          return m.validTime;
        case 'generated_at':
          return m.generatedAt;
      }
    case final SnowOutlook m:
      switch (name) {
        case 'next_24h':
          return m.next24h;
        case 'next_48h':
          return m.next48h;
        case 'next_72h':
          return m.next72h;
        case 'next_7d':
          return m.next7d;
        case 'overnight_4pm_9am':
          return m.overnight4pm9am;
        case 'quantiles':
          return m.quantiles;
      }
    case final SnowOutlookQuantiles m:
      switch (name) {
        case 'next_24h':
          return m.next24h;
        case 'next_48h':
          return m.next48h;
        case 'next_72h':
          return m.next72h;
        case 'next_7d':
          return m.next7d;
      }
    case final SnowTrendDay m:
      switch (name) {
        case 'date':
          return m.date;
        case 'amount':
          return m.amount;
        case 'partial':
          return m.partial;
        case 'p10':
          return m.p10;
        case 'p90':
          return m.p90;
        case 'kind':
          return m.kind;
      }
    case final SnowTrendGrid m:
      switch (name) {
        case 'source':
          return m.source;
        case 'runs':
          return m.runs;
      }
    case final SnowTrendResponse m:
      switch (name) {
        case 'location':
          return m.location;
        case 'units':
          return m.units;
        case 'elevation':
          return m.elevation;
        case 'retention_days':
          return m.retentionDays;
        case 'dates':
          return m.dates;
        case 'grids':
          return m.grids;
      }
    case final SnowTrendResponseElevation m:
      switch (name) {
        case 'name':
          return m.name;
        case 'display_name':
          return m.displayName;
        case 'height':
          return m.height;
      }
    case final SnowTrendRun m:
      switch (name) {
        case 'backfilled':
          return m.backfilled;
        case 'initialized_at':
          return m.initializedAt;
        case 'days':
          return m.days;
      }
    case final SnowpackAspect m:
      switch (name) {
        case 'aspect':
          return m.aspect;
        case 'slope_angle_deg':
          return m.slopeAngleDeg;
        case 'depth':
          return m.depth;
        case 'depth_change_24h':
          return m.depthChange24h;
        case 'steps':
          return m.steps;
        case 'layers':
          return m.layers;
      }
    case final SnowpackDepth m:
      switch (name) {
        case 'start_time':
          return m.startTime;
        case 'interval_hours':
          return m.intervalHours;
        case 'basis':
          return m.basis;
        case 'p10':
          return m.p10;
        case 'p50':
          return m.p50;
        case 'p90':
          return m.p90;
      }
    case final SnowpackLayer m:
      switch (name) {
        case 'form':
          return m.form;
        case 'thickness':
          return m.thickness;
        case 'depth':
          return m.depth;
        case 'formed':
          return m.formed;
      }
    case final SnowpackModel m:
      switch (name) {
        case 'name':
          return m.name;
        case 'by':
          return m.by;
        case 'license':
          return m.license;
        case 'version':
          return m.version;
      }
    case final SnowpackPlumeDepth m:
      switch (name) {
        case 'start_time':
          return m.startTime;
        case 'interval_hours':
          return m.intervalHours;
        case 'members':
          return m.members;
        case 'p50':
          return m.p50;
        case 'mean':
          return m.mean;
        case 'p10':
          return m.p10;
        case 'p25':
          return m.p25;
        case 'p75':
          return m.p75;
        case 'p90':
          return m.p90;
      }
    case final SnowpackPlumeModel m:
      switch (name) {
        case 'id':
          return m.id;
        case 'member_ids':
          return m.memberIds;
        case 'depth':
          return m.depth;
        case 'depth_mean':
          return m.depthMean;
        case 'members_skipped':
          return m.membersSkipped;
      }
    case final SnowpackPlumeResponse m:
      switch (name) {
        case 'beta':
          return m.beta;
        case 'location':
          return m.location;
        case 'units':
          return m.units;
        case 'model_run':
          return m.modelRun;
        case 'stale':
          return m.stale;
        case 'depth':
          return m.depth;
        case 'models':
          return m.models;
        case 'member_depths':
          return m.memberDepths;
        case 'spread':
          return m.spread;
      }
    case final SnowpackResponse m:
      switch (name) {
        case 'beta':
          return m.beta;
        case 'location':
          return m.location;
        case 'units':
          return m.units;
        case 'model_run':
          return m.modelRun;
        case 'stale':
          return m.stale;
        case 'spots':
          return m.spots;
        case 'definitions':
          return m.definitions;
      }
    case final SnowpackResponseDefinitions m:
      switch (name) {
        case 'surface':
          return m.surface;
        case 'layer_form':
          return m.layerForm;
      }
    case final SnowpackRun m:
      switch (name) {
        case 'initialized_at':
          return m.initializedAt;
        case 'generated_at':
          return m.generatedAt;
        case 'model':
          return m.model;
      }
    case final SnowpackSpot m:
      switch (name) {
        case 'name':
          return m.name;
        case 'display_name':
          return m.displayName;
        case 'elevation':
          return m.elevation;
        case 'elevation_m':
          return m.elevationM;
        case 'initialized_at':
          return m.initializedAt;
        case 'anchor':
          return m.anchor;
        case 'depth':
          return m.depth;
        case 'depth_change_24h':
          return m.depthChange24h;
        case 'swe':
          return m.swe;
        case 'steps':
          return m.steps;
        case 'layers':
          return m.layers;
        case 'aspects':
          return m.aspects;
      }
    case final SnowpackSpotAnchor m:
      switch (name) {
        case 'station':
          return m.station;
        case 'name':
          return m.name;
        case 'network':
          return m.network;
      }
    case final SnowpackStep m:
      switch (name) {
        case 'valid_time':
          return m.validTime;
        case 'surface':
          return m.surface;
        case 'new_snow_24h':
          return m.newSnow24h;
        case 'new_snow_density_kg_m3':
          return m.newSnowDensityKgM3;
        case 'settlement_24h':
          return m.settlement24h;
      }
    case final SummaryEvent m:
      switch (name) {
        case 'kind':
          return m.kind;
        case 'template':
          return m.template;
        case 'at':
          return m.at;
        case 'until':
          return m.until;
        case 'alert_id':
          return m.alertId;
        case 'values':
          return m.values;
      }
    case final SummaryValues m:
      switch (name) {
        case 'snowfall':
          return m.snowfall;
        case 'snowfall_p10':
          return m.snowfallP10;
        case 'snowfall_p90':
          return m.snowfallP90;
        case 'snowfall_window':
          return m.snowfallWindow;
        case 'temperature':
          return m.temperature;
        case 'wind_gust':
          return m.windGust;
        case 'precipitation_probability':
          return m.precipitationProbability;
      }
    case final TimeSeriesPoint m:
      switch (name) {
        case 'valid_time':
          return m.validTime;
        case 'lead_time_hours':
          return m.leadTimeHours;
        case 'is_night':
          return m.isNight;
        case 'measured':
          return m.measured;
        case 'condition':
          return m.condition;
        case 'condition_text':
          return m.conditionText;
        case 'condition_icon':
          return m.conditionIcon;
        case 'gust_notable':
          return m.gustNotable;
        case 'precipitation_type':
          return m.precipitationType;
        case 'inversion':
          return m.inversion;
        case 'freezing_level':
          return m.freezingLevel;
        case 'ensemble':
          return m.ensemble;
        case 'provenance':
          return m.provenance;
        case 'model_means':
          return m.modelMeans;
        case 'members':
          return m.members;
        case 'members_cumulative':
          return m.membersCumulative;
        case 'members_6h':
          return m.members6h;
        case 'members_spread':
          return m.membersSpread;
        case 'cumulative_precipitation':
          return m.cumulativePrecipitation;
        case 'cumulative_snowfall':
          return m.cumulativeSnowfall;
        case 'snow_character':
          return m.snowCharacter;
        case 'precipitation_by_type':
          return m.precipitationByType;
      }
    case final WindowTotal m:
      switch (name) {
        case 'term':
          return m.term;
        case 'variable':
          return m.variable;
        case 'start_hours':
          return m.startHours;
        case 'end_hours':
          return m.endHours;
        case 'aggregation':
          return m.aggregation;
        case 'from':
          return m.from;
        case 'to':
          return m.to;
        case 'quantiles':
          return m.quantiles;
        case 'members':
          return m.members;
        case 'method':
          return m.method;
        case 'null_reason':
          return m.nullReason;
        case 'request':
          return m.request;
      }
  }
  throw ArgumentError('${model.runtimeType} has no field $name');
}
