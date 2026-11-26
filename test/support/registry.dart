// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

// Every model by its schema name: decode, then encode back to JSON.

import 'package:ensemble_weather/ensemble_weather.dart';

/// Schema name -> a function that decodes JSON with that model and encodes it back.
final Map<String, Map<String, Object?> Function(Map<String, Object?>)>
    roundTrip = {
  'ActiveAlert': (json) => ActiveAlert.fromJson(json).toJson(),
  'AlertOutlineCollection': (json) =>
      AlertOutlineCollection.fromJson(json).toJson(),
  'AlertOutlineFeature': (json) => AlertOutlineFeature.fromJson(json).toJson(),
  'AlertOutlineGeometry': (json) =>
      AlertOutlineGeometry.fromJson(json).toJson(),
  'AlertOutlineProperties': (json) =>
      AlertOutlineProperties.fromJson(json).toJson(),
  'AlertsResponse': (json) => AlertsResponse.fromJson(json).toJson(),
  'AppliedOptions': (json) => AppliedOptions.fromJson(json).toJson(),
  'AttributionProvider': (json) => AttributionProvider.fromJson(json).toJson(),
  'AttributionRegistry': (json) => AttributionRegistry.fromJson(json).toJson(),
  'AttributionSource': (json) => AttributionSource.fromJson(json).toJson(),
  'AvalancheForecast': (json) => AvalancheForecast.fromJson(json).toJson(),
  'AvalancheZoneCollection': (json) =>
      AvalancheZoneCollection.fromJson(json).toJson(),
  'AvalancheZoneFeature': (json) =>
      AvalancheZoneFeature.fromJson(json).toJson(),
  'AvalancheZoneGeometry': (json) =>
      AvalancheZoneGeometry.fromJson(json).toJson(),
  'AvalancheZoneProperties': (json) =>
      AvalancheZoneProperties.fromJson(json).toJson(),
  'BandColumns': (json) => BandColumns.fromJson(json).toJson(),
  'CatalogResolvedEntry': (json) =>
      CatalogResolvedEntry.fromJson(json).toJson(),
  'CatalogTemplateSummary': (json) =>
      CatalogTemplateSummary.fromJson(json).toJson(),
  'CircularStats': (json) => CircularStats.fromJson(json).toJson(),
  'CmsTemplateSection': (json) => CmsTemplateSection.fromJson(json).toJson(),
  'CompositionResponse': (json) => CompositionResponse.fromJson(json).toJson(),
  'CurrentConditions': (json) => CurrentConditions.fromJson(json).toJson(),
  'CurrentResponse': (json) => CurrentResponse.fromJson(json).toJson(),
  'CurrentStation': (json) => CurrentStation.fromJson(json).toJson(),
  'DailyAstro': (json) => DailyAstro.fromJson(json).toJson(),
  'DailyForecast': (json) => DailyForecast.fromJson(json).toJson(),
  'DailyWind': (json) => DailyWind.fromJson(json).toJson(),
  'DayClimatology': (json) => DayClimatology.fromJson(json).toJson(),
  'DayDeparture': (json) => DayDeparture.fromJson(json).toJson(),
  'DayNormal': (json) => DayNormal.fromJson(json).toJson(),
  'DayPercentile': (json) => DayPercentile.fromJson(json).toJson(),
  'ElevationForecast': (json) => ElevationForecast.fromJson(json).toJson(),
  'ElevationSummary': (json) => ElevationSummary.fromJson(json).toJson(),
  'EnsembleStats': (json) => EnsembleStats.fromJson(json).toJson(),
  'ExploreItem': (json) => ExploreItem.fromJson(json).toJson(),
  'ExploreResponse': (json) => ExploreResponse.fromJson(json).toJson(),
  'ExploreValue': (json) => ExploreValue.fromJson(json).toJson(),
  'ForecastData': (json) => ForecastData.fromJson(json).toJson(),
  'ForecastLocation': (json) => ForecastLocation.fromJson(json).toJson(),
  'ForecastResponse': (json) => ForecastResponse.fromJson(json).toJson(),
  'FreezingLevel': (json) => FreezingLevel.fromJson(json).toJson(),
  'GapFlow': (json) => GapFlow.fromJson(json).toJson(),
  'HourProvenance': (json) => HourProvenance.fromJson(json).toJson(),
  'InversionInfo': (json) => InversionInfo.fromJson(json).toJson(),
  'LocationRef': (json) => LocationRef.fromJson(json).toJson(),
  'LocationSummary': (json) => LocationSummary.fromJson(json).toJson(),
  'LocationsResponse': (json) => LocationsResponse.fromJson(json).toJson(),
  'MeasuredPrecipitation': (json) =>
      MeasuredPrecipitation.fromJson(json).toJson(),
  'MemberForecast': (json) => MemberForecast.fromJson(json).toJson(),
  'MemberGroup': (json) => MemberGroup.fromJson(json).toJson(),
  'MemberPlume': (json) => MemberPlume.fromJson(json).toJson(),
  'MemberQuantiles': (json) => MemberQuantiles.fromJson(json).toJson(),
  'MembersCumulative': (json) => MembersCumulative.fromJson(json).toJson(),
  'MembersSpread': (json) => MembersSpread.fromJson(json).toJson(),
  'ModelColumns': (json) => ModelColumns.fromJson(json).toJson(),
  'ModelEntry': (json) => ModelEntry.fromJson(json).toJson(),
  'ModelRunInfo': (json) => ModelRunInfo.fromJson(json).toJson(),
  'ModelStats': (json) => ModelStats.fromJson(json).toJson(),
  'NearbyLocation': (json) => NearbyLocation.fromJson(json).toJson(),
  'NearbyLocationsResponse': (json) =>
      NearbyLocationsResponse.fromJson(json).toJson(),
  'NearbyPointResponse': (json) => NearbyPointResponse.fromJson(json).toJson(),
  'NearestLocation': (json) => NearestLocation.fromJson(json).toJson(),
  'NearestSensor': (json) => NearestSensor.fromJson(json).toJson(),
  'PassCamera': (json) => PassCamera.fromJson(json).toJson(),
  'PassChance': (json) => PassChance.fromJson(json).toJson(),
  'PassChances': (json) => PassChances.fromJson(json).toJson(),
  'PassForecast': (json) => PassForecast.fromJson(json).toJson(),
  'PassHour': (json) => PassHour.fromJson(json).toJson(),
  'PassOfficialStatus': (json) => PassOfficialStatus.fromJson(json).toJson(),
  'PassRoadSensor': (json) => PassRoadSensor.fromJson(json).toJson(),
  'PassSnow24h': (json) => PassSnow24h.fromJson(json).toJson(),
  'PassSnowWindow': (json) => PassSnowWindow.fromJson(json).toJson(),
  'PassStatusSegment': (json) => PassStatusSegment.fromJson(json).toJson(),
  'PassTravelWindow': (json) => PassTravelWindow.fromJson(json).toJson(),
  'PassTravelWindows': (json) => PassTravelWindows.fromJson(json).toJson(),
  'PlaceSummary': (json) => PlaceSummary.fromJson(json).toJson(),
  'PlumeBands': (json) => PlumeBands.fromJson(json).toJson(),
  'PlumeHeadline': (json) => PlumeHeadline.fromJson(json).toJson(),
  'PointInfo': (json) => PointInfo.fromJson(json).toJson(),
  'PooledColumns': (json) => PooledColumns.fromJson(json).toJson(),
  'PrecipDisplay': (json) => PrecipDisplay.fromJson(json).toJson(),
  'PrecipOutlook': (json) => PrecipOutlook.fromJson(json).toJson(),
  'PrecipType': (json) => PrecipType.fromJson(json).toJson(),
  'PrecipitationByType': (json) => PrecipitationByType.fromJson(json).toJson(),
  'ProbabilityResult': (json) => ProbabilityResult.fromJson(json).toJson(),
  'ProbabilityThresholds': (json) =>
      ProbabilityThresholds.fromJson(json).toJson(),
  'PublicCatalogElevation': (json) =>
      PublicCatalogElevation.fromJson(json).toJson(),
  'PublicCatalogLocation': (json) =>
      PublicCatalogLocation.fromJson(json).toJson(),
  'PublicCatalogLocationDetail': (json) =>
      PublicCatalogLocationDetail.fromJson(json).toJson(),
  'PublicCatalogLocationPage': (json) =>
      PublicCatalogLocationPage.fromJson(json).toJson(),
  'PublicCatalogNearbyStation': (json) =>
      PublicCatalogNearbyStation.fromJson(json).toJson(),
  'PublicCatalogPhoto': (json) => PublicCatalogPhoto.fromJson(json).toJson(),
  'PublicCatalogPrimaryLocation': (json) =>
      PublicCatalogPrimaryLocation.fromJson(json).toJson(),
  'PublicCatalogStation': (json) =>
      PublicCatalogStation.fromJson(json).toJson(),
  'PublicCatalogStationDetail': (json) =>
      PublicCatalogStationDetail.fromJson(json).toJson(),
  'PublicCatalogStationPage': (json) =>
      PublicCatalogStationPage.fromJson(json).toJson(),
  'PublicCatalogWebcam': (json) => PublicCatalogWebcam.fromJson(json).toJson(),
  'Quantiles': (json) => Quantiles.fromJson(json).toJson(),
  'ResponseAttribution': (json) => ResponseAttribution.fromJson(json).toJson(),
  'RunEntry': (json) => RunEntry.fromJson(json).toJson(),
  'RunsResponse': (json) => RunsResponse.fromJson(json).toJson(),
  'SearchHit': (json) => SearchHit.fromJson(json).toJson(),
  'SearchLocationsResponse': (json) =>
      SearchLocationsResponse.fromJson(json).toJson(),
  'SeasonDay': (json) => SeasonDay.fromJson(json).toJson(),
  'SeasonResponse': (json) => SeasonResponse.fromJson(json).toJson(),
  'SeasonStation': (json) => SeasonStation.fromJson(json).toJson(),
  'SeasonTotal': (json) => SeasonTotal.fromJson(json).toJson(),
  'Sector': (json) => Sector.fromJson(json).toJson(),
  'SensorObservation': (json) => SensorObservation.fromJson(json).toJson(),
  'ServedRun': (json) => ServedRun.fromJson(json).toJson(),
  'SnowLevelRange': (json) => SnowLevelRange.fromJson(json).toJson(),
  'SnowOnGround': (json) => SnowOnGround.fromJson(json).toJson(),
  'SnowOutlook': (json) => SnowOutlook.fromJson(json).toJson(),
  'SnowOutlookQuantiles': (json) =>
      SnowOutlookQuantiles.fromJson(json).toJson(),
  'SnowTrendDay': (json) => SnowTrendDay.fromJson(json).toJson(),
  'SnowTrendGrid': (json) => SnowTrendGrid.fromJson(json).toJson(),
  'SnowTrendResponse': (json) => SnowTrendResponse.fromJson(json).toJson(),
  'SnowTrendResponseElevation': (json) =>
      SnowTrendResponseElevation.fromJson(json).toJson(),
  'SnowTrendRun': (json) => SnowTrendRun.fromJson(json).toJson(),
  'SnowpackAspect': (json) => SnowpackAspect.fromJson(json).toJson(),
  'SnowpackDepth': (json) => SnowpackDepth.fromJson(json).toJson(),
  'SnowpackLayer': (json) => SnowpackLayer.fromJson(json).toJson(),
  'SnowpackModel': (json) => SnowpackModel.fromJson(json).toJson(),
  'SnowpackPlumeDepth': (json) => SnowpackPlumeDepth.fromJson(json).toJson(),
  'SnowpackPlumeModel': (json) => SnowpackPlumeModel.fromJson(json).toJson(),
  'SnowpackPlumeResponse': (json) =>
      SnowpackPlumeResponse.fromJson(json).toJson(),
  'SnowpackResponse': (json) => SnowpackResponse.fromJson(json).toJson(),
  'SnowpackResponseDefinitions': (json) =>
      SnowpackResponseDefinitions.fromJson(json).toJson(),
  'SnowpackRun': (json) => SnowpackRun.fromJson(json).toJson(),
  'SnowpackSpot': (json) => SnowpackSpot.fromJson(json).toJson(),
  'SnowpackSpotAnchor': (json) => SnowpackSpotAnchor.fromJson(json).toJson(),
  'SnowpackStep': (json) => SnowpackStep.fromJson(json).toJson(),
  'SummaryEvent': (json) => SummaryEvent.fromJson(json).toJson(),
  'SummaryValues': (json) => SummaryValues.fromJson(json).toJson(),
  'TimeSeriesPoint': (json) => TimeSeriesPoint.fromJson(json).toJson(),
  'WindowTotal': (json) => WindowTotal.fromJson(json).toJson(),
};
