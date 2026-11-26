// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

/// Typed, immutable models for every response the SDK returns.
///
/// Each class is named after its schema in the OpenAPI contract. Unknown
/// fields in a response are ignored, unknown enum values keep their raw
/// string (see [OpenEnum]), and a field the server did not send is `null`,
/// never a made-up default such as `0`.
///
/// Every forecast value is a [Quantiles] distribution, not a single number.
/// [Quantiles.median] is a convenience, and it is the median, not "the
/// forecast". Values are in the units the request asked for; the SDK never
/// converts response values.
///
/// A few JSON fields that repeat a word of the type holding them have SDK
/// names (BEHAVIOR.md 3.0); each one's documentation starts with its JSON
/// name, and `toJson()` writes the JSON names back.
library;

import 'enums.dart';
import 'json.dart';
import 'model_base.dart';
import 'probabilities.dart';

/// An active weather alert.
final class ActiveAlert {
  /// Creates an [ActiveAlert].
  ActiveAlert({
    required this.id,
    required this.event,
    required this.severity,
    required this.urgency,
    required this.certainty,
    required this.headline,
    this.onset,
    required this.expires,
    this.ends,
    this.sent,
    this.messageType,
    this.references,
    this.senderName,
    this.areaDesc,
    this.description,
    this.instruction,
    this.sourceUrl,
    this.eventKey,
    this.vtecAction,
  });

  /// Decodes an [ActiveAlert] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ActiveAlert.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readActiveAlert);

  /// NWS alert identifier (urn:oid:…).
  final String id;

  /// The `event` field.
  final String event;

  /// The NWS severity, snake_case like every enum (it passed NWS's `Severe`
  /// casing through).
  final AlertSeverity severity;

  /// The NWS urgency, snake_case.
  final AlertUrgency urgency;

  /// The NWS certainty, snake_case (new).
  final AlertCertainty certainty;

  /// The `headline` field.
  final String headline;

  /// Omitted when NWS supplies none.
  final DateTime? onset;

  /// When NWS is due to re-issue this message.
  final DateTime expires;

  /// When the hazard ends; the alert is served up to it while NWS lists it.
  final DateTime? ends;

  /// When NWS issued this message.
  final DateTime? sent;

  /// `alert`, `update` or `cancel`.
  final String? messageType;

  /// The ids of the messages this one replaces.
  final List<String>? references;

  /// The `sender_name` field.
  final String? senderName;

  /// The places this message covers, as NWS words them.
  final String? areaDesc;

  /// The full NWS text, unedited.
  final String? description;

  /// What NWS says to do, unedited.
  final String? instruction;

  /// The NWS forecast page for this location.
  final String? sourceUrl;

  /// The stable identity of this event.
  final String? eventKey;

  /// The VTEC action of this message, lower case.
  final String? vtecAction;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['id'] = id;
    out['event'] = event;
    out['severity'] = severity.value;
    out['urgency'] = urgency.value;
    out['certainty'] = certainty.value;
    out['headline'] = headline;
    if (onset case final v?) {
      out['onset'] = formatDateTime(v);
    }
    out['expires'] = formatDateTime(expires);
    if (ends case final v?) {
      out['ends'] = formatDateTime(v);
    }
    if (sent case final v?) {
      out['sent'] = formatDateTime(v);
    }
    if (messageType case final v?) {
      out['message_type'] = v;
    }
    if (references case final v?) {
      out['references'] = v;
    }
    if (senderName case final v?) {
      out['sender_name'] = v;
    }
    if (areaDesc case final v?) {
      out['area_desc'] = v;
    }
    if (description case final v?) {
      out['description'] = v;
    }
    if (instruction case final v?) {
      out['instruction'] = v;
    }
    if (sourceUrl case final v?) {
      out['source_url'] = v;
    }
    if (eventKey case final v?) {
      out['event_key'] = v;
    }
    if (vtecAction case final v?) {
      out['vtec_action'] = v;
    }
    return out;
  }
}

ActiveAlert _readActiveAlert(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ActiveAlert(
    id: r.req('id', asString),
    event: r.req('event', asString),
    severity: r.req('severity', enumOf(AlertSeverity.new)),
    urgency: r.req('urgency', enumOf(AlertUrgency.new)),
    certainty: r.req('certainty', enumOf(AlertCertainty.new)),
    headline: r.req('headline', asString),
    onset: r.opt('onset', asDateTime),
    expires: r.req('expires', asDateTime),
    ends: r.opt('ends', asDateTime),
    sent: r.opt('sent', asDateTime),
    messageType: r.opt('message_type', asString),
    references: r.opt('references', listOf(asString)),
    senderName: r.opt('sender_name', asString),
    areaDesc: r.opt('area_desc', asString),
    description: r.opt('description', asString),
    instruction: r.opt('instruction', asString),
    sourceUrl: r.opt('source_url', asString),
    eventKey: r.opt('event_key', asString),
    vtecAction: r.opt('vtec_action', asString),
  );
}

/// A GeoJSON `FeatureCollection`.
///
/// (RFC 7946) of the active winter and wind alerts' outlines, with this
/// response's `attribution` as a foreign member.
final class AlertOutlineCollection extends Response {
  /// Creates an [AlertOutlineCollection].
  AlertOutlineCollection({
    required this.type,
    required this.features,
    required this.attribution,
  });

  /// Decodes an [AlertOutlineCollection] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory AlertOutlineCollection.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readAlertOutlineCollection);

  /// The `type` field.
  final String type;

  /// One Feature per alert, ordered by `properties.id`.
  final List<AlertOutlineFeature> features;

  /// The data sources THIS response drew on, and what their licences ask us to
  /// say.
  final ResponseAttribution attribution;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['type'] = type;
    out['features'] = [for (final e in features) e.toJson()];
    out['attribution'] = attribution.toJson();
    return out;
  }
}

AlertOutlineCollection _readAlertOutlineCollection(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return AlertOutlineCollection(
    type: r.req('type', asString),
    features: r.req('features', listOf(_readAlertOutlineFeature)),
    attribution: r.req('attribution', _readResponseAttribution),
  );
}

/// One alert's outline, a GeoJSON `Feature`.
final class AlertOutlineFeature {
  /// Creates an [AlertOutlineFeature].
  AlertOutlineFeature({
    required this.type,
    required this.geometry,
    required this.properties,
  });

  /// Decodes an [AlertOutlineFeature] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory AlertOutlineFeature.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readAlertOutlineFeature);

  /// The `type` field.
  final String type;

  /// A GeoJSON `Polygon` or `MultiPolygon`.
  final AlertOutlineGeometry geometry;

  /// The alert, under the names `ActiveAlert` uses for the same fields, and its
  /// `class`.
  final AlertOutlineProperties properties;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['type'] = type;
    out['geometry'] = geometry.toJson();
    out['properties'] = properties.toJson();
    return out;
  }
}

AlertOutlineFeature _readAlertOutlineFeature(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return AlertOutlineFeature(
    type: r.req('type', asString),
    geometry: r.req('geometry', _readAlertOutlineGeometry),
    properties: r.req('properties', _readAlertOutlineProperties),
  );
}

/// A GeoJSON `Polygon` or `MultiPolygon`.
final class AlertOutlineGeometry {
  /// Creates an [AlertOutlineGeometry].
  AlertOutlineGeometry({
    required this.type,
    required this.coordinates,
  });

  /// Decodes an [AlertOutlineGeometry] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory AlertOutlineGeometry.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readAlertOutlineGeometry);

  /// The `type` field.
  final String type;

  /// The `coordinates` field.
  final List<List<List<Object?>>> coordinates;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['type'] = type;
    out['coordinates'] = coordinates;
    return out;
  }
}

AlertOutlineGeometry _readAlertOutlineGeometry(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return AlertOutlineGeometry(
    type: r.req('type', asString),
    coordinates: r.req('coordinates', listOf(listOf(listOf(asAny)))),
  );
}

/// The alert, under the names `ActiveAlert` uses for the same fields, and its
/// `class`.
final class AlertOutlineProperties {
  /// Creates an [AlertOutlineProperties].
  AlertOutlineProperties({
    required this.id,
    required this.event,
    required this.alertClass,
    required this.severity,
    required this.urgency,
    required this.certainty,
    required this.headline,
    this.onset,
    required this.expires,
    this.ends,
    this.senderName,
    required this.sourceUrl,
  });

  /// Decodes an [AlertOutlineProperties] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory AlertOutlineProperties.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readAlertOutlineProperties);

  /// NWS alert identifier (urn:oid:…), as `ActiveAlert.id`.
  final String id;

  /// The `event` field.
  final String event;

  /// What an alert is about, as far as a map filters on it.
  final AlertClass alertClass;

  /// As `ActiveAlert.severity`.
  final String severity;

  /// As `ActiveAlert.urgency`.
  final String urgency;

  /// As `ActiveAlert.certainty`.
  final String certainty;

  /// The `headline` field.
  final String headline;

  /// When the hazard begins.
  final DateTime? onset;

  /// When NWS is due to re-issue this message; not the alert's end (see
  /// `ActiveAlert.expires`).
  final DateTime expires;

  /// When the hazard ends.
  final DateTime? ends;

  /// The NWS office.
  final String? senderName;

  /// The NWS forecast page of a point inside the outline, which lists the alert
  /// and links to its text: where "view on NWS" goes.
  final String sourceUrl;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['id'] = id;
    out['event'] = event;
    out['class'] = alertClass.value;
    out['severity'] = severity;
    out['urgency'] = urgency;
    out['certainty'] = certainty;
    out['headline'] = headline;
    if (onset case final v?) {
      out['onset'] = formatDateTime(v);
    }
    out['expires'] = formatDateTime(expires);
    if (ends case final v?) {
      out['ends'] = formatDateTime(v);
    }
    if (senderName case final v?) {
      out['sender_name'] = v;
    }
    out['source_url'] = sourceUrl;
    return out;
  }
}

AlertOutlineProperties _readAlertOutlineProperties(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return AlertOutlineProperties(
    id: r.req('id', asString),
    event: r.req('event', asString),
    alertClass: r.req('class', enumOf(AlertClass.new)),
    severity: r.req('severity', asString),
    urgency: r.req('urgency', asString),
    certainty: r.req('certainty', asString),
    headline: r.req('headline', asString),
    onset: r.opt('onset', asDateTime),
    expires: r.req('expires', asDateTime),
    ends: r.opt('ends', asDateTime),
    senderName: r.opt('sender_name', asString),
    sourceUrl: r.req('source_url', asString),
  );
}

/// Active alerts for a location.
final class AlertsResponse extends Response {
  /// Creates an [AlertsResponse].
  AlertsResponse({
    required this.location,
    required this.count,
    required this.asOf,
    required this.items,
    required this.attribution,
  });

  /// Decodes an [AlertsResponse] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory AlertsResponse.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readAlertsResponse);

  /// -- the one location reference.
  final LocationRef location;

  /// (JSON `alert_count`)
  final int count;

  /// Snapshot timestamp (see /current alerts_as_of).
  final DateTime asOf;

  /// (JSON `alerts`) One active NWS alert.
  final List<ActiveAlert> items;

  /// The data sources THIS response drew on, and what their licences ask us to
  /// say.
  final ResponseAttribution attribution;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['location'] = location.toJson();
    out['alert_count'] = count;
    out['as_of'] = formatDateTime(asOf);
    out['alerts'] = [for (final e in items) e.toJson()];
    out['attribution'] = attribution.toJson();
    return out;
  }
}

AlertsResponse _readAlertsResponse(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return AlertsResponse(
    location: r.req('location', _readLocationRef),
    count: r.req('alert_count', asInt),
    asOf: r.req('as_of', asDateTime),
    items: r.req('alerts', listOf(_readActiveAlert)),
    attribution: r.req('attribution', _readResponseAttribution),
  );
}

/// The options the server applied, after clamping to the caller's tier.
final class AppliedOptions {
  /// Creates an [AppliedOptions].
  AppliedOptions({
    this.maxHours,
    this.maxDays,
    required this.clamped,
  });

  /// Decodes an [AppliedOptions] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory AppliedOptions.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readAppliedOptions);

  /// Hours past the first served hour; `null` with `hourly=false`.
  final int? maxHours;

  /// Daily rows served for; `null` with `daily=false`.
  final int? maxDays;

  /// The requested options the server changed, in this order.
  final List<ClampedOption> clamped;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (maxHours case final v?) {
      out['max_hours'] = v;
    }
    if (maxDays case final v?) {
      out['max_days'] = v;
    }
    out['clamped'] = [for (final e in clamped) e.value];
    return out;
  }
}

AppliedOptions _readAppliedOptions(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return AppliedOptions(
    maxHours: r.opt('max_hours', asInt),
    maxDays: r.opt('max_days', asInt),
    clamped: r.req('clamped', listOf(enumOf(ClampedOption.new))),
  );
}

/// One data provider, its licence and its sources.
final class AttributionProvider {
  /// Creates an [AttributionProvider].
  AttributionProvider({
    required this.id,
    required this.name,
    required this.credit,
    required this.licence,
    required this.licenceUrl,
    required this.termsUrl,
    required this.modified,
    required this.notices,
    required this.sources,
  });

  /// Decodes an [AttributionProvider] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory AttributionProvider.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readAttributionProvider);

  /// The `id` field.
  final String id;

  /// The `name` field.
  final String name;

  /// The credit line a response carries for this provider.
  final String credit;

  /// SPDX id where one exists (`CC-BY-4.0`, `CC-BY-3.0`, `ODbL-1.0`); otherwise
  /// `public-domain-us-gov`, `public-domain`, `none-stated`, or the name of the
  /// provider's own terms.
  final String licence;

  /// The `licence_url` field.
  final String licenceUrl;

  /// The page the wording was taken from.
  final String termsUrl;

  /// Ourea serves this provider's data modified and its terms ask that this be
  /// said.
  final bool modified;

  /// Statements the terms require shown in full, beyond `credit`.
  final List<String> notices;

  /// The `sources` field.
  final List<AttributionSource> sources;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['id'] = id;
    out['name'] = name;
    out['credit'] = credit;
    out['licence'] = licence;
    out['licence_url'] = licenceUrl;
    out['terms_url'] = termsUrl;
    out['modified'] = modified;
    out['notices'] = notices;
    out['sources'] = [for (final e in sources) e.toJson()];
    return out;
  }
}

AttributionProvider _readAttributionProvider(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return AttributionProvider(
    id: r.req('id', asString),
    name: r.req('name', asString),
    credit: r.req('credit', asString),
    licence: r.req('licence', asString),
    licenceUrl: r.req('licence_url', asString),
    termsUrl: r.req('terms_url', asString),
    modified: r.req('modified', asBool),
    notices: r.req('notices', listOf(asString)),
    sources: r.req('sources', listOf(_readAttributionSource)),
  );
}

/// Every data provider the API draws on.
final class AttributionRegistry extends Response {
  /// Creates an [AttributionRegistry].
  AttributionRegistry({
    required this.providers,
  });

  /// Decodes an [AttributionRegistry] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory AttributionRegistry.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readAttributionRegistry);

  /// The `providers` field.
  final List<AttributionProvider> providers;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['providers'] = [for (final e in providers) e.toJson()];
    return out;
  }
}

AttributionRegistry _readAttributionRegistry(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return AttributionRegistry(
    providers: r.req('providers', listOf(_readAttributionProvider)),
  );
}

/// One data source in the attribution registry.
final class AttributionSource {
  /// Creates an [AttributionSource].
  AttributionSource({
    required this.id,
    required this.name,
    required this.kind,
    required this.provider,
  });

  /// Decodes an [AttributionSource] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory AttributionSource.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readAttributionSource);

  /// The `id` field.
  final String id;

  /// The `name` field.
  final String name;

  /// The `kind` field.
  final AttributionSourceKind kind;

  /// The `provider` field.
  final String provider;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['id'] = id;
    out['name'] = name;
    out['kind'] = kind.value;
    out['provider'] = provider;
    return out;
  }
}

AttributionSource _readAttributionSource(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return AttributionSource(
    id: r.req('id', asString),
    name: r.req('name', asString),
    kind: r.req('kind', enumOf(AttributionSourceKind.new)),
    provider: r.req('provider', asString),
  );
}

/// The avalanche center's danger rating for the forecast zone the location's
/// point is in.
///
/// From avalanche.org's public map layer.
final class AvalancheForecast {
  /// Creates an [AvalancheForecast].
  AvalancheForecast({
    required this.centerId,
    required this.centerName,
    required this.zoneId,
    required this.zoneName,
    this.dangerLevel,
    this.dangerLabel,
    required this.status,
    this.validFrom,
    this.validUntil,
    required this.url,
    required this.centerUrl,
    required this.attribution,
  });

  /// Decodes an [AvalancheForecast] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory AvalancheForecast.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readAvalancheForecast);

  /// The avalanche center's short id.
  final String centerId;

  /// The `center_name` field.
  final String centerName;

  /// avalanche.org's id for the forecast zone; for a CAIC forecast area, an id
  /// at or above 2^52 derived from CAIC's area id (stable for that grouping of
  /// CAIC's polygons).
  final int zoneId;

  /// The `zone_name` field.
  final String zoneName;

  /// The North American Public Avalanche Danger Scale level, 1-5; present only
  /// when `status` is `rated`.
  final int? dangerLevel;

  /// Display text: the scale's English name for `danger_level` (Low, Moderate,
  /// Considerable, High, Extreme), derived from the level, never the center's
  /// own wording; `null` exactly when `danger_level` is.
  final String? dangerLabel;

  /// `rated`: a current rating.
  final String status;

  /// When the center's current product took effect (UTC), when stated.
  final DateTime? validFrom;

  /// When the center's current product expires (UTC), when stated.
  final DateTime? validUntil;

  /// (JSON `forecast_url`) The center's full forecast for the zone.
  final String url;

  /// The `center_url` field.
  final String centerUrl;

  /// The credit to show with the block: "Avalanche forecast by &lt;center&gt;
  /// via avalanche.org", or "Avalanche forecast by Colorado Avalanche
  /// Information Center via avalanche.state.co.us" for a CAIC area.
  final String attribution;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['center_id'] = centerId;
    out['center_name'] = centerName;
    out['zone_id'] = zoneId;
    out['zone_name'] = zoneName;
    if (dangerLevel case final v?) {
      out['danger_level'] = v;
    }
    if (dangerLabel case final v?) {
      out['danger_label'] = v;
    }
    out['status'] = status;
    if (validFrom case final v?) {
      out['valid_from'] = formatDateTime(v);
    }
    if (validUntil case final v?) {
      out['valid_until'] = formatDateTime(v);
    }
    out['forecast_url'] = url;
    out['center_url'] = centerUrl;
    out['attribution'] = attribution;
    return out;
  }
}

AvalancheForecast _readAvalancheForecast(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return AvalancheForecast(
    centerId: r.req('center_id', asString),
    centerName: r.req('center_name', asString),
    zoneId: r.req('zone_id', asInt),
    zoneName: r.req('zone_name', asString),
    dangerLevel: r.opt('danger_level', asInt),
    dangerLabel: r.opt('danger_label', asString),
    status: r.req('status', asString),
    validFrom: r.opt('valid_from', asDateTime),
    validUntil: r.opt('valid_until', asDateTime),
    url: r.req('forecast_url', asString),
    centerUrl: r.req('center_url', asString),
    attribution: r.req('attribution', asString),
  );
}

/// A GeoJSON `FeatureCollection`.
///
/// (RFC 7946) of the avalanche centers' forecast zones, each with its published
/// rating, and this response's `attribution` as a foreign member.
final class AvalancheZoneCollection extends Response {
  /// Creates an [AvalancheZoneCollection].
  AvalancheZoneCollection({
    required this.type,
    required this.features,
    required this.attribution,
  });

  /// Decodes an [AvalancheZoneCollection] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory AvalancheZoneCollection.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readAvalancheZoneCollection);

  /// The `type` field.
  final String type;

  /// One Feature per zone, the less specific first: where zones overlap, the
  /// one drawn last is the one a point there is served.
  final List<AvalancheZoneFeature> features;

  /// The data sources THIS response drew on, and what their licences ask us to
  /// say.
  final ResponseAttribution attribution;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['type'] = type;
    out['features'] = [for (final e in features) e.toJson()];
    out['attribution'] = attribution.toJson();
    return out;
  }
}

AvalancheZoneCollection _readAvalancheZoneCollection(
    Object? value, String path) {
  final r = JsonReader.of(value, path);
  return AvalancheZoneCollection(
    type: r.req('type', asString),
    features: r.req('features', listOf(_readAvalancheZoneFeature)),
    attribution: r.req('attribution', _readResponseAttribution),
  );
}

/// One forecast zone, a GeoJSON `Feature`.
final class AvalancheZoneFeature {
  /// Creates an [AvalancheZoneFeature].
  AvalancheZoneFeature({
    required this.type,
    required this.id,
    required this.geometry,
    required this.properties,
  });

  /// Decodes an [AvalancheZoneFeature] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory AvalancheZoneFeature.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readAvalancheZoneFeature);

  /// The `type` field.
  final String type;

  /// The zone's id, as `properties.zone_id`.
  final int id;

  /// A GeoJSON `MultiPolygon`: an array of polygons, each an array of rings
  /// (the outer one first, then any holes), each ring closed.
  final AvalancheZoneGeometry geometry;

  /// The avalanche center's danger rating for the forecast zone the location's
  /// point is in, from avalanche.org's public map layer.
  final AvalancheZoneProperties properties;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['type'] = type;
    out['id'] = id;
    out['geometry'] = geometry.toJson();
    out['properties'] = properties.toJson();
    return out;
  }
}

AvalancheZoneFeature _readAvalancheZoneFeature(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return AvalancheZoneFeature(
    type: r.req('type', asString),
    id: r.req('id', asInt),
    geometry: r.req('geometry', _readAvalancheZoneGeometry),
    properties: r.req('properties', _readAvalancheZoneProperties),
  );
}

/// A GeoJSON `MultiPolygon`.
///
/// An array of polygons, each an array of rings (the outer one first, then any
/// holes), each ring closed.
final class AvalancheZoneGeometry {
  /// Creates an [AvalancheZoneGeometry].
  AvalancheZoneGeometry({
    required this.type,
    required this.coordinates,
  });

  /// Decodes an [AvalancheZoneGeometry] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory AvalancheZoneGeometry.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readAvalancheZoneGeometry);

  /// The `type` field.
  final String type;

  /// The `coordinates` field.
  final List<List<List<Object?>>> coordinates;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['type'] = type;
    out['coordinates'] = coordinates;
    return out;
  }
}

AvalancheZoneGeometry _readAvalancheZoneGeometry(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return AvalancheZoneGeometry(
    type: r.req('type', asString),
    coordinates: r.req('coordinates', listOf(listOf(listOf(asAny)))),
  );
}

/// An avalanche zone Feature's `properties`, exactly as the API sends them.
///
/// GeoJSON is passed through untouched (BEHAVIOR.md 3.0), so unlike
/// `AvalancheForecast` the link keeps its wire name `forecast_url`.
final class AvalancheZoneProperties {
  /// Creates an [AvalancheZoneProperties].
  AvalancheZoneProperties({
    required this.centerId,
    required this.centerName,
    required this.zoneId,
    required this.zoneName,
    this.dangerLevel,
    this.dangerLabel,
    required this.status,
    this.validFrom,
    this.validUntil,
    required this.forecastUrl,
    required this.centerUrl,
    required this.attribution,
  });

  /// Decodes an [AvalancheZoneProperties] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory AvalancheZoneProperties.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readAvalancheZoneProperties);

  /// The avalanche center's short id.
  final String centerId;

  /// The `center_name` field.
  final String centerName;

  /// avalanche.org's id for the forecast zone; for a CAIC forecast area, an id
  /// at or above 2^52 derived from CAIC's area id (stable for that grouping of
  /// CAIC's polygons).
  final int zoneId;

  /// The `zone_name` field.
  final String zoneName;

  /// The North American Public Avalanche Danger Scale level, 1-5; present only
  /// when `status` is `rated`.
  final int? dangerLevel;

  /// Display text: the scale's English name for `danger_level` (Low, Moderate,
  /// Considerable, High, Extreme), derived from the level, never the center's
  /// own wording; `null` exactly when `danger_level` is.
  final String? dangerLabel;

  /// `rated`: a current rating.
  final String status;

  /// When the center's current product took effect (UTC), when stated.
  final DateTime? validFrom;

  /// When the center's current product expires (UTC), when stated.
  final DateTime? validUntil;

  /// The center's full forecast for the zone.
  final String forecastUrl;

  /// The `center_url` field.
  final String centerUrl;

  /// The credit to show with the block: "Avalanche forecast by &lt;center&gt;
  /// via avalanche.org", or "Avalanche forecast by Colorado Avalanche
  /// Information Center via avalanche.state.co.us" for a CAIC area.
  final String attribution;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['center_id'] = centerId;
    out['center_name'] = centerName;
    out['zone_id'] = zoneId;
    out['zone_name'] = zoneName;
    if (dangerLevel case final v?) {
      out['danger_level'] = v;
    }
    if (dangerLabel case final v?) {
      out['danger_label'] = v;
    }
    out['status'] = status;
    if (validFrom case final v?) {
      out['valid_from'] = formatDateTime(v);
    }
    if (validUntil case final v?) {
      out['valid_until'] = formatDateTime(v);
    }
    out['forecast_url'] = forecastUrl;
    out['center_url'] = centerUrl;
    out['attribution'] = attribution;
    return out;
  }
}

AvalancheZoneProperties _readAvalancheZoneProperties(
    Object? value, String path) {
  final r = JsonReader.of(value, path);
  return AvalancheZoneProperties(
    centerId: r.req('center_id', asString),
    centerName: r.req('center_name', asString),
    zoneId: r.req('zone_id', asInt),
    zoneName: r.req('zone_name', asString),
    dangerLevel: r.opt('danger_level', asInt),
    dangerLabel: r.opt('danger_label', asString),
    status: r.req('status', asString),
    validFrom: r.opt('valid_from', asDateTime),
    validUntil: r.opt('valid_until', asDateTime),
    forecastUrl: r.req('forecast_url', asString),
    centerUrl: r.req('center_url', asString),
    attribution: r.req('attribution', asString),
  );
}

/// One band's statistics.
///
/// (Hyndman-Fan type 7 over the served member values), each an array aligned to
/// `PlumeBands.valid_time`, `null` where the band is absent at that hour.
final class BandColumns {
  /// Creates a [BandColumns].
  BandColumns({
    required this.mean,
    required this.min,
    required this.p10,
    required this.p25,
    this.p50,
    required this.p75,
    required this.p90,
    required this.max,
  });

  /// Decodes a [BandColumns] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory BandColumns.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readBandColumns);

  /// Numbers aligned to the enclosing block's `valid_time`; `null` = no value
  /// there.
  final List<double?> mean;

  /// Numbers aligned to the enclosing block's `valid_time`; `null` = no value
  /// there.
  final List<double?> min;

  /// Numbers aligned to the enclosing block's `valid_time`; `null` = no value
  /// there.
  final List<double?> p10;

  /// Numbers aligned to the enclosing block's `valid_time`; `null` = no value
  /// there.
  final List<double?> p25;

  /// Numbers aligned to the enclosing block's `valid_time`; `null` = no value
  /// there.
  final List<double?>? p50;

  /// Numbers aligned to the enclosing block's `valid_time`; `null` = no value
  /// there.
  final List<double?> p75;

  /// Numbers aligned to the enclosing block's `valid_time`; `null` = no value
  /// there.
  final List<double?> p90;

  /// Numbers aligned to the enclosing block's `valid_time`; `null` = no value
  /// there.
  final List<double?> max;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['mean'] = mean;
    out['min'] = min;
    out['p10'] = p10;
    out['p25'] = p25;
    if (p50 case final v?) {
      out['p50'] = v;
    }
    out['p75'] = p75;
    out['p90'] = p90;
    out['max'] = max;
    return out;
  }
}

BandColumns _readBandColumns(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return BandColumns(
    mean: r.req('mean', listOf(nullableOf(asDouble))),
    min: r.req('min', listOf(nullableOf(asDouble))),
    p10: r.req('p10', listOf(nullableOf(asDouble))),
    p25: r.req('p25', listOf(nullableOf(asDouble))),
    p50: r.opt('p50', listOf(nullableOf(asDouble))),
    p75: r.req('p75', listOf(nullableOf(asDouble))),
    p90: r.req('p90', listOf(nullableOf(asDouble))),
    max: r.req('max', listOf(nullableOf(asDouble))),
  );
}

/// A resolved content entry (`include=content`).
final class CatalogResolvedEntry {
  /// Creates a [CatalogResolvedEntry].
  CatalogResolvedEntry({
    required this.id,
    required this.contentTypeKey,
    required this.title,
    required this.body,
    required this.slot,
    required this.displayOrder,
    required this.locale,
    required this.updatedAt,
  });

  /// Decodes a [CatalogResolvedEntry] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory CatalogResolvedEntry.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readCatalogResolvedEntry);

  /// The `id` field.
  final String id;

  /// The `content_type_key` field.
  final String contentTypeKey;

  /// The `title` field.
  final String title;

  /// Shaped by the content type's `field_schema`.
  final Map<String, Object?> body;

  /// The template `content_slot` key this entry fills.
  final String slot;

  /// The `display_order` field.
  final int displayOrder;

  /// (JSON `resolved_locale`) The requested locale if ANY field of this entry
  /// carried a translation, else the entry's base locale.
  final String locale;

  /// The `updated_at` field.
  final DateTime updatedAt;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['id'] = id;
    out['content_type_key'] = contentTypeKey;
    out['title'] = title;
    out['body'] = body;
    out['slot'] = slot;
    out['display_order'] = displayOrder;
    out['resolved_locale'] = locale;
    out['updated_at'] = formatDateTime(updatedAt);
    return out;
  }
}

CatalogResolvedEntry _readCatalogResolvedEntry(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return CatalogResolvedEntry(
    id: r.req('id', asString),
    contentTypeKey: r.req('content_type_key', asString),
    title: r.req('title', asString),
    body: r.req('body', mapOf(asAny)),
    slot: r.req('slot', asString),
    displayOrder: r.req('display_order', asInt),
    locale: r.req('resolved_locale', asString),
    updatedAt: r.req('updated_at', asDateTime),
  );
}

/// The page template of a catalog entry (`include=template`).
final class CatalogTemplateSummary {
  /// Creates a [CatalogTemplateSummary].
  CatalogTemplateSummary({
    required this.id,
    this.locationType,
    this.variant,
    required this.spec,
  });

  /// Decodes a [CatalogTemplateSummary] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory CatalogTemplateSummary.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readCatalogTemplateSummary);

  /// The `id` field.
  final String id;

  /// The location type the template is scoped to, snake_case as
  /// `LocationRef.type`.
  final LocationType? locationType;

  /// (JSON `template_variant`) The page-template variant the template is scoped
  /// to, snake_case.
  final TemplateVariant? variant;

  /// One element of a page template's `spec`.
  final List<CmsTemplateSection> spec;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['id'] = id;
    if (locationType case final v?) {
      out['location_type'] = v.value;
    }
    if (variant case final v?) {
      out['template_variant'] = v.value;
    }
    out['spec'] = [for (final e in spec) e.toJson()];
    return out;
  }
}

CatalogTemplateSummary _readCatalogTemplateSummary(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return CatalogTemplateSummary(
    id: r.req('id', asString),
    locationType: r.opt('location_type', enumOf(LocationType.new)),
    variant: r.opt('template_variant', enumOf(TemplateVariant.new)),
    spec: r.req('spec', listOf(_readCmsTemplateSection)),
  );
}

/// The circular distribution of wind direction, in degrees.
///
/// Each sector runs clockwise from `from_` to `to`, so `to` may be numerically
/// less than `from_` (`350` to `20` crosses north); the SDK leaves it as sent.
final class CircularStats {
  /// Creates a [CircularStats].
  CircularStats({
    required this.mean,
    this.stddev,
    required this.sector50,
    required this.sector90,
  });

  /// Decodes a [CircularStats] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory CircularStats.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readCircularStats);

  /// The circular mean direction.
  final double mean;

  /// The circular standard deviation.
  final double? stddev;

  /// The narrowest sector holding half of the members.
  final Sector sector50;

  /// The narrowest sector holding 90 % of the members.
  final Sector sector90;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['mean'] = mean;
    if (stddev case final v?) {
      out['stddev'] = v;
    }
    out['sector_50'] = sector50.toJson();
    out['sector_90'] = sector90.toJson();
    return out;
  }
}

CircularStats _readCircularStats(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return CircularStats(
    mean: r.req('mean', asDouble),
    stddev: r.opt('stddev', asDouble),
    sector50: r.req('sector_50', _readSector),
    sector90: r.req('sector_90', _readSector),
  );
}

/// One section of a catalog page template.
final class CmsTemplateSection {
  /// Creates a [CmsTemplateSection].
  CmsTemplateSection({
    required this.kind,
    required this.key,
    this.config,
  });

  /// Decodes a [CmsTemplateSection] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory CmsTemplateSection.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readCmsTemplateSection);

  /// Closed vocabulary — unknown kinds fail deserialization (`400`).
  final TemplateSectionKind kind;

  /// Kebab-case section key.
  final String key;

  /// Client-defined render hints (`hours`, `by_elevation_band`, media
  /// `source`/`limit`, …) — not backend contract.
  final Map<String, Object?>? config;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['kind'] = kind.value;
    out['key'] = key;
    if (config case final v?) {
      out['config'] = v;
    }
    return out;
  }
}

CmsTemplateSection _readCmsTemplateSection(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return CmsTemplateSection(
    kind: r.req('kind', enumOf(TemplateSectionKind.new)),
    key: r.req('key', asString),
    config: r.opt('config', mapOf(asAny)),
  );
}

/// `GET /api/v1/composition`.
final class CompositionResponse extends Response {
  /// Creates a [CompositionResponse].
  CompositionResponse({
    required this.initializedAt,
    required this.models,
    required this.modelCount,
    required this.totalMembers,
  });

  /// Decodes a [CompositionResponse] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory CompositionResponse.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readCompositionResponse);

  /// The reference init: the newest contributing cycle, a forecast's
  /// `model_run.initialized_at`.
  final DateTime initializedAt;

  /// Each contributing model, its own cycle and its members (`members` absent
  /// only when the cycle's member count is not known).
  final List<ModelEntry> models;

  /// Entries in `models`.
  final int modelCount;

  /// The sum of `models[].members`: the members the blend draws on.
  final int totalMembers;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['initialized_at'] = formatDateTime(initializedAt);
    out['models'] = [for (final e in models) e.toJson()];
    out['model_count'] = modelCount;
    out['total_members'] = totalMembers;
    return out;
  }
}

CompositionResponse _readCompositionResponse(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return CompositionResponse(
    initializedAt: r.req('initialized_at', asDateTime),
    models: r.req('models', listOf(_readModelEntry)),
    modelCount: r.req('model_count', asInt),
    totalMembers: r.req('total_members', asInt),
  );
}

/// Right now: a view of one served hour, never a second forecast.
final class CurrentConditions {
  /// Creates a [CurrentConditions].
  CurrentConditions({
    required this.time,
    required this.temperature,
    this.feelsLike,
    required this.code,
    required this.text,
    required this.icon,
    required this.windSpeed,
    this.windGust,
    required this.windDirection,
    this.relativeHumidity,
    this.dewpoint,
    this.precipitationProbability,
    required this.source,
    this.station,
    this.measured,
    this.cloudCover,
  });

  /// Decodes a [CurrentConditions] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory CurrentConditions.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readCurrentConditions);

  /// `valid_time` of the hour the block is read from.
  final DateTime time;

  /// °C (metric), °F (imperial), K (kelvin).
  final double temperature;

  /// Same unit as `temperature`.
  final double? feelsLike;

  /// (JSON `condition`) The hour's stable condition code, as
  /// `TimeSeriesPoint.condition` (`partly_cloudy`).
  final String code;

  /// (JSON `condition_text`) The display text for `condition`, as
  /// `TimeSeriesPoint.condition_text`.
  final String text;

  /// (JSON `condition_icon`) The icon hint, ONE enum wherever a
  /// `condition_icon` is served (the hourly point, the daily row, `/current`'s
  /// `current` block, the elevation series).
  final ConditionIcon icon;

  /// m/s (metric, kelvin) or mph (imperial).
  final double windSpeed;

  /// Same unit as `wind_speed`.
  final double? windGust;

  /// Degrees clockwise from north, direction the wind blows FROM.
  final double windDirection;

  /// Relative humidity, percent (0–100).
  final double? relativeHumidity;

  /// Same unit as `temperature`.
  final double? dewpoint;

  /// Probability (0–1) of at least 0.254 mm (0.01 in, the NWS measurable event)
  /// in the hour in progress: that hour's `ensemble.precipitation.probability`,
  /// the number its hourly row serves.
  final double? precipitationProbability;

  /// `nowcast` — at least one live observation (surface station, MRMS radar,
  /// GOES cloud mask, with by day the nearest pyranometer beside it) carried
  /// weight at this hour.
  final CurrentSource source;

  /// The surface station whose reading anchored temperature, dewpoint and wind
  /// at this hour.
  final CurrentStation? station;

  /// `true` when the values are a station's measurement, not the forecast.
  final bool? measured;

  /// Cloud cover, percent (0-100), the mean of the hour in progress's
  /// `ensemble.cloud_cover`: the hour `condition` is read from, so the number
  /// and the label describe one hour.
  final double? cloudCover;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['time'] = formatDateTime(time);
    out['temperature'] = temperature;
    if (feelsLike case final v?) {
      out['feels_like'] = v;
    }
    out['condition'] = code;
    out['condition_text'] = text;
    out['condition_icon'] = icon.value;
    out['wind_speed'] = windSpeed;
    if (windGust case final v?) {
      out['wind_gust'] = v;
    }
    out['wind_direction'] = windDirection;
    if (relativeHumidity case final v?) {
      out['relative_humidity'] = v;
    }
    if (dewpoint case final v?) {
      out['dewpoint'] = v;
    }
    if (precipitationProbability case final v?) {
      out['precipitation_probability'] = v;
    }
    out['source'] = source.value;
    if (station case final v?) {
      out['station'] = v.toJson();
    }
    if (measured case final v?) {
      out['measured'] = v;
    }
    if (cloudCover case final v?) {
      out['cloud_cover'] = v;
    }
    return out;
  }
}

CurrentConditions _readCurrentConditions(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return CurrentConditions(
    time: r.req('time', asDateTime),
    temperature: r.req('temperature', asDouble),
    feelsLike: r.opt('feels_like', asDouble),
    code: r.req('condition', asString),
    text: r.req('condition_text', asString),
    icon: r.req('condition_icon', enumOf(ConditionIcon.new)),
    windSpeed: r.req('wind_speed', asDouble),
    windGust: r.opt('wind_gust', asDouble),
    windDirection: r.req('wind_direction', asDouble),
    relativeHumidity: r.opt('relative_humidity', asDouble),
    dewpoint: r.opt('dewpoint', asDouble),
    precipitationProbability: r.opt('precipitation_probability', asDouble),
    source: r.req('source', enumOf(CurrentSource.new)),
    station: r.opt('station', _readCurrentStation),
    measured: r.opt('measured', asBool),
    cloudCover: r.opt('cloud_cover', asDouble),
  );
}

/// Current conditions, nearby observations and active alerts.
final class CurrentResponse extends Response {
  /// Creates a [CurrentResponse].
  CurrentResponse({
    required this.location,
    required this.alerts,
    required this.alertsAsOf,
    required this.sensorCount,
    required this.sensors,
    this.now,
    required this.asOf,
    this.modelRunInitializedAt,
    this.nowcastHours,
    required this.units,
    required this.attribution,
    this.nowcastUnavailable,
    this.summary,
    this.pass,
  });

  /// Decodes a [CurrentResponse] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory CurrentResponse.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readCurrentResponse);

  /// The one location reference.
  final LocationRef location;

  /// Active NWS watches/warnings/advisories for this location (zone- and
  /// polygon-matched).
  final List<ActiveAlert> alerts;

  /// Timestamp of the alerts snapshot backing this response (refreshed ~60s;
  /// staleness beyond a few minutes means the alerts pipeline is degraded).
  final DateTime alertsAsOf;

  /// The `sensor_count` field.
  final int sensorCount;

  /// Each sensor's latest reading set (in the request's `units`, under plain
  /// names).
  final List<SensorObservation> sensors;

  /// (JSON `current`) "Right now" flattened: the `nowcast_hours` hour nearest
  /// the request time, read field by field (see the schema).
  final CurrentConditions? now;

  /// When this overlay was assembled (the request time); the `nowcast_hours`
  /// window is relative to it.
  final DateTime asOf;

  /// The reference init of the cycle the band was read from (null when no cycle
  /// is servable).
  final DateTime? modelRunInitializedAt;

  /// The obs-blended forecast hours with valid times in `[as_of − 1 h, as_of +
  /// 10 h]`, shaped like the forecast's `timeseries` points. Present only with
  /// `?include=nowcast_hours`, and then `null` when no cycle is servable;
  /// absent otherwise.
  final List<TimeSeriesPoint>? nowcastHours;

  /// Unit system for response values.
  final UnitSystem units;

  /// The data sources THIS response drew on, and what their licences ask us to
  /// say.
  final ResponseAttribution attribution;

  /// The live nowcast sources `nowcast_hours` and `current` were built without
  /// because their read did not answer in time (or failed).
  final List<NowcastLayer>? nowcastUnavailable;

  /// The place summary, written by the server from served values only, so every
  /// client shows the same words.
  final PlaceSummary? summary;

  /// A mountain pass's forecast (JSON `pass`); `null` elsewhere.
  final PassForecast? pass;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['location'] = location.toJson();
    out['alerts'] = [for (final e in alerts) e.toJson()];
    out['alerts_as_of'] = formatDateTime(alertsAsOf);
    out['sensor_count'] = sensorCount;
    out['sensors'] = [for (final e in sensors) e.toJson()];
    if (now case final v?) {
      out['current'] = v.toJson();
    }
    out['as_of'] = formatDateTime(asOf);
    if (modelRunInitializedAt case final v?) {
      out['model_run_initialized_at'] = formatDateTime(v);
    }
    if (nowcastHours case final v?) {
      out['nowcast_hours'] = [for (final e in v) e.toJson()];
    }
    out['units'] = units.value;
    out['attribution'] = attribution.toJson();
    if (nowcastUnavailable case final v?) {
      out['nowcast_unavailable'] = [for (final e in v) e.value];
    }
    if (summary case final v?) {
      out['summary'] = v.toJson();
    }
    if (pass case final v?) {
      out['pass'] = v.toJson();
    }
    return out;
  }
}

CurrentResponse _readCurrentResponse(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return CurrentResponse(
    location: r.req('location', _readLocationRef),
    alerts: r.req('alerts', listOf(_readActiveAlert)),
    alertsAsOf: r.req('alerts_as_of', asDateTime),
    sensorCount: r.req('sensor_count', asInt),
    sensors: r.req('sensors', listOf(_readSensorObservation)),
    now: r.opt('current', _readCurrentConditions),
    asOf: r.req('as_of', asDateTime),
    modelRunInitializedAt: r.opt('model_run_initialized_at', asDateTime),
    nowcastHours: r.opt('nowcast_hours', listOf(_readTimeSeriesPoint)),
    units: r.req('units', enumOf(UnitSystem.new)),
    attribution: r.req('attribution', _readResponseAttribution),
    nowcastUnavailable:
        r.opt('nowcast_unavailable', listOf(enumOf(NowcastLayer.new))),
    summary: r.opt('summary', _readPlaceSummary),
    pass: r.opt('pass', _readPassForecast),
  );
}

/// The station that anchored current conditions.
final class CurrentStation {
  /// Creates a [CurrentStation].
  CurrentStation({
    required this.id,
    required this.name,
    required this.observationTime,
    this.calm,
  });

  /// Decodes a [CurrentStation] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory CurrentStation.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readCurrentStation);

  /// (JSON `station_id`)
  final String id;

  /// The `name` field.
  final String name;

  /// The `observation_time` field.
  final DateTime observationTime;

  /// `true` when the station reported calm wind.
  final bool? calm;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['station_id'] = id;
    out['name'] = name;
    out['observation_time'] = formatDateTime(observationTime);
    if (calm case final v?) {
      out['calm'] = v;
    }
    return out;
  }
}

CurrentStation _readCurrentStation(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return CurrentStation(
    id: r.req('station_id', asString),
    name: r.req('name', asString),
    observationTime: r.req('observation_time', asDateTime),
    calm: r.opt('calm', asBool),
  );
}

/// Sun and moon for a date.
final class DailyAstro {
  /// Creates a [DailyAstro].
  DailyAstro({
    this.sunrise,
    this.sunset,
    required this.moonPhase,
    required this.moonIllumination,
    required this.astronomicalSeason,
  });

  /// Decodes a [DailyAstro] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory DailyAstro.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readDailyAstro);

  /// Sunrise time at the forecast location, ISO-8601 UTC.
  final DateTime? sunrise;

  /// Sunset time at the forecast location, ISO-8601 UTC.
  final DateTime? sunset;

  /// Eight-way moon phase at local noon on the date.
  final MoonPhase moonPhase;

  /// Fraction of the moon's disc that's illuminated (0.0 = new, 1.0 = full), at
  /// local noon on the date (Meeus, Astronomical Algorithms, ch.
  final double moonIllumination;

  /// Astronomical season by equinox/solstice (not meteorological).
  final AstronomicalSeason astronomicalSeason;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (sunrise case final v?) {
      out['sunrise'] = formatDateTime(v);
    }
    if (sunset case final v?) {
      out['sunset'] = formatDateTime(v);
    }
    out['moon_phase'] = moonPhase.value;
    out['moon_illumination'] = moonIllumination;
    out['astronomical_season'] = astronomicalSeason.value;
    return out;
  }
}

DailyAstro _readDailyAstro(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return DailyAstro(
    sunrise: r.opt('sunrise', asDateTime),
    sunset: r.opt('sunset', asDateTime),
    moonPhase: r.req('moon_phase', enumOf(MoonPhase.new)),
    moonIllumination: r.req('moon_illumination', asDouble),
    astronomicalSeason:
        r.req('astronomical_season', enumOf(AstronomicalSeason.new)),
  );
}

/// One local calendar date's summary.
///
/// `total_precipitation` and `total_snowfall` are the distributions of each
/// member's own day total, computed by the server; they are not sums of hourly
/// quantiles.
final class DailyForecast {
  /// Creates a [DailyForecast].
  DailyForecast({
    required this.date,
    required this.condition,
    required this.conditionText,
    required this.conditionIcon,
    this.precipitationType,
    required this.high,
    required this.low,
    this.feelsLikeHigh,
    this.feelsLikeLow,
    required this.totalPrecipitation,
    this.totalSnowfall,
    required this.precipitationProbability,
    required this.precipitationOccurrenceProbability,
    required this.snowProbability,
    this.snowLevelMean,
    this.snowLevel,
    this.totalPrecipitationIfWet,
    this.totalSnowfallIfWet,
    required this.precipitationDisplay,
    this.cloudCoverMean,
    this.wind,
    this.stormOrientation,
    this.stormOrientationDescription,
    required this.astro,
    this.temperatureClimatology,
    this.coveredFrom,
    this.measuredPrecipitation,
    this.snowCharacter,
    this.slr,
    this.snowLevelRange,
    this.snowLevelWetBulb,
    this.snowLevelWetBulbRange,
    this.normal,
    this.departure,
    this.percentile,
  });

  /// Decodes a [DailyForecast] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory DailyForecast.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readDailyForecast);

  /// The `date` field.
  final DateTime date;

  /// A stable machine code to switch on (`partly_cloudy`,
  /// `rain_snow_mix_likely`).
  final DailyCondition condition;

  /// Human-readable weather condition for the day — a daytime label, on the
  /// same rule as the hourly `condition`.
  final String conditionText;

  /// The icon hint, ONE enum wherever a `condition_icon` is served (the hourly
  /// point, the daily row, `/current`'s `current` block, the elevation series).
  final ConditionIcon conditionIcon;

  /// The day's precipitation type, absent when
  /// `precipitation_occurrence_probability` is under 0.10.
  final PrecipitationType? precipitationType;

  /// Calendar-day maximum: the max over local midnight to midnight on `date`
  /// (earlier releases: 06:00-18:00 only).
  final Quantiles high;

  /// Calendar-day minimum: the min over local midnight to midnight on `date`,
  /// the same hours as `high` (earlier releases: the night that BEGINS on
  /// `date`, 18:00 through 06:00 the next morning).
  final Quantiles low;

  /// Calendar-day maximum of the hourly `feels_like` (the NWS apparent
  /// temperature), per member: each ensemble member's own hourly feels-like,
  /// that member's maximum over the same local calendar day as `high`, and the
  /// statistics across those members' maxima (`mean` their mean; `min`/`max`
  /// the lowest and highest member's).
  final Quantiles? feelsLikeHigh;

  /// Calendar-day minimum of the hourly `feels_like` (the NWS apparent
  /// temperature), per member: each member's own minimum over the same local
  /// calendar day as `low`, and the statistics across those minima.
  final Quantiles? feelsLikeLow;

  /// The day's total: `mean` is the sum of the day's hourly means; the
  /// percentiles are read off the day-total distribution built from the hourly
  /// ensemble ladders -- the SAME distribution `precipitation_probability` and
  /// `precipitation_occurrence_probability` are read off, so a `p50` at or
  /// above a probability's threshold always comes with a probability of at
  /// least 0.5.
  final Quantiles totalPrecipitation;

  /// As `total_precipitation`, for the day's snowfall; the distribution
  /// `snow_probability` is read off.
  final Quantiles? totalSnowfall;

  /// **MEANINGFUL precipitation: `P(day total >= 2.5 mm)`** (0-1) — the
  /// headline number, the chance the day accumulates a tenth of an inch or
  /// more.
  final double precipitationProbability;

  /// **OCCURRENCE: `P(day total >= 1.0 mm)`** (0-1) — the chance the day
  /// precipitates at all, as opposed to `precipitation_probability`'s chance
  /// that it amounts to anything.
  final double precipitationOccurrenceProbability;

  /// **The snow chance: `P(day water >= 1.0 mm AND day snowfall >= 2.5 mm)`**
  /// (0-1), inclusive -- the chance of `precipitation_occurrence_probability`'s
  /// wet day that also leaves at least 2.5 mm (0.1") of snow.
  final double snowProbability;

  /// The day's snow level, `snow_level.mean`.
  final double? snowLevelMean;

  /// The day's snow level -- each rank the mean of the day's hourly ranks (the
  /// day-mean's distribution under the rank coherence the day totals assume).
  final Quantiles? snowLevel;

  /// The day total GIVEN a wet day (total &gt;= the
  /// `daily_precipitation_occurrence_probability` threshold, 1.0 mm): the upper
  /// part of the day-total distribution, renormalized.
  final Quantiles? totalPrecipitationIfWet;

  /// The day's snowfall given a wet day, the same event as
  /// `total_precipitation_if_wet`'s (day water &gt;= the
  /// `daily_precipitation_occurrence_probability` threshold, 1.0 mm): the top
  /// `precipitation_occurrence_probability` of the day's snowfall distribution,
  /// renormalized.
  final Quantiles? totalSnowfallIfWet;

  /// A day's precipitation headline, chosen by the server so every client says
  /// the same thing: `kind` `none` when the chance of a wet day
  /// (`precipitation_occurrence_probability`) is under 10 %, else the day's
  /// `precipitation_type`; `chance` that chance; `amount` the day's mean
  /// snowfall on a `snow` day (`total_snowfall.mean`, equal to `snow_amount`)
  /// and the median liquid if wet on a `rain`, `rain_snow_mix` or
  /// `freezing_rain` day (`total_precipitation_if_wet.p50`, given the same wet
  /// day as `chance`); `snow_amount` the day's mean snowfall, so a
  /// `rain_snow_mix` day, which headlines its liquid, still states its snow.
  final PrecipDisplay precipitationDisplay;

  /// Average cloud cover for the day (0-100%).
  final double? cloudCoverMean;

  /// Daily wind summary.
  final DailyWind? wind;

  /// How SLR changes over a snow storm.
  final StormOrientation? stormOrientation;

  /// Plain-language companion to `storm_orientation`, suitable for direct
  /// display.
  final String? stormOrientationDescription;

  /// The day's sun and moon, grouped.
  final DailyAstro astro;

  /// Served as a daily row's `temperature_climatology`.
  final DayClimatology? temperatureClimatology;

  /// On today's row, the first hour the forecast covers.
  final DateTime? coveredFrom;

  /// Present only on a day part of which is a measurement -- the leading date,
  /// when the radar (MRMS radar-only) measured hours between its local midnight
  /// and the reference init -- and absent otherwise.
  final MeasuredPrecipitation? measuredPrecipitation;

  /// The day's snow character.
  final SnowCharacter? snowCharacter;

  /// The day's snow-to-liquid ratio.
  final double? slr;

  /// The snow level over the day's wet hours -- the hours the day's
  /// `precipitation_type` reads (the hours that serve a precipitation type):
  /// the lowest and highest hourly `ensemble.snow_level.mean` and their
  /// precipitation-weighted mean.
  final SnowLevelRange? snowLevelRange;

  /// The day's snow level on the NWS scale -- the height of the 0.5 C wet-bulb.
  final Quantiles? snowLevelWetBulb;

  /// `Snow_level_range` on the NWS scale -- over the same wet hours, the lowest
  /// and highest hourly `ensemble.snow_level_wet_bulb.mean` and their
  /// precipitation-weighted mean (which is `snow_level_wet_bulb.mean`).
  final SnowLevelRange? snowLevelWetBulbRange;

  /// The day's climate normal at the forecast point: the mean, over the day of
  /// year +/-15 days of every year of the station's record, of the very
  /// quantities this row states -- the local CALENDAR date's maximum hourly
  /// temperature (`high`, the quantity `high` is), its minimum (`low`) and its
  /// precipitation TOTAL (`precipitation`, dry days included; a daily total,
  /// never an hourly amount).
  final DayNormal? normal;

  /// The served headline minus the normal, in the request's units: `high.p50 -
  /// normal.high` and `low.p50 - normal.low`.
  final DayDeparture? departure;

  /// How unusual the day is: where the served headline (`p50`) falls in the
  /// day's climatological distribution, as a percentile 0-100, `Pr{climate <=
  /// forecast}` -- 95 for `precipitation` reads "wetter than 95% of this date's
  /// days".
  final DayPercentile? percentile;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['date'] = formatDate(date);
    out['condition'] = condition.value;
    out['condition_text'] = conditionText;
    out['condition_icon'] = conditionIcon.value;
    if (precipitationType case final v?) {
      out['precipitation_type'] = v.value;
    }
    out['high'] = high.toJson();
    out['low'] = low.toJson();
    if (feelsLikeHigh case final v?) {
      out['feels_like_high'] = v.toJson();
    }
    if (feelsLikeLow case final v?) {
      out['feels_like_low'] = v.toJson();
    }
    out['total_precipitation'] = totalPrecipitation.toJson();
    if (totalSnowfall case final v?) {
      out['total_snowfall'] = v.toJson();
    }
    out['precipitation_probability'] = precipitationProbability;
    out['precipitation_occurrence_probability'] =
        precipitationOccurrenceProbability;
    out['snow_probability'] = snowProbability;
    if (snowLevelMean case final v?) {
      out['snow_level_mean'] = v;
    }
    if (snowLevel case final v?) {
      out['snow_level'] = v.toJson();
    }
    if (totalPrecipitationIfWet case final v?) {
      out['total_precipitation_if_wet'] = v.toJson();
    }
    if (totalSnowfallIfWet case final v?) {
      out['total_snowfall_if_wet'] = v.toJson();
    }
    out['precipitation_display'] = precipitationDisplay.toJson();
    if (cloudCoverMean case final v?) {
      out['cloud_cover_mean'] = v;
    }
    if (wind case final v?) {
      out['wind'] = v.toJson();
    }
    if (stormOrientation case final v?) {
      out['storm_orientation'] = v.value;
    }
    if (stormOrientationDescription case final v?) {
      out['storm_orientation_description'] = v;
    }
    out['astro'] = astro.toJson();
    if (temperatureClimatology case final v?) {
      out['temperature_climatology'] = v.toJson();
    }
    if (coveredFrom case final v?) {
      out['covered_from'] = formatDateTime(v);
    }
    if (measuredPrecipitation case final v?) {
      out['measured_precipitation'] = v.toJson();
    }
    if (snowCharacter case final v?) {
      out['snow_character'] = v.value;
    }
    if (slr case final v?) {
      out['slr'] = v;
    }
    if (snowLevelRange case final v?) {
      out['snow_level_range'] = v.toJson();
    }
    if (snowLevelWetBulb case final v?) {
      out['snow_level_wet_bulb'] = v.toJson();
    }
    if (snowLevelWetBulbRange case final v?) {
      out['snow_level_wet_bulb_range'] = v.toJson();
    }
    if (normal case final v?) {
      out['normal'] = v.toJson();
    }
    if (departure case final v?) {
      out['departure'] = v.toJson();
    }
    if (percentile case final v?) {
      out['percentile'] = v.toJson();
    }
    return out;
  }
}

DailyForecast _readDailyForecast(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return DailyForecast(
    date: r.req('date', asDate),
    condition: r.req('condition', enumOf(DailyCondition.new)),
    conditionText: r.req('condition_text', asString),
    conditionIcon: r.req('condition_icon', enumOf(ConditionIcon.new)),
    precipitationType:
        r.opt('precipitation_type', enumOf(PrecipitationType.new)),
    high: r.req('high', _readQuantiles),
    low: r.req('low', _readQuantiles),
    feelsLikeHigh: r.opt('feels_like_high', _readQuantiles),
    feelsLikeLow: r.opt('feels_like_low', _readQuantiles),
    totalPrecipitation: r.req('total_precipitation', _readQuantiles),
    totalSnowfall: r.opt('total_snowfall', _readQuantiles),
    precipitationProbability: r.req('precipitation_probability', asDouble),
    precipitationOccurrenceProbability:
        r.req('precipitation_occurrence_probability', asDouble),
    snowProbability: r.req('snow_probability', asDouble),
    snowLevelMean: r.opt('snow_level_mean', asDouble),
    snowLevel: r.opt('snow_level', _readQuantiles),
    totalPrecipitationIfWet:
        r.opt('total_precipitation_if_wet', _readQuantiles),
    totalSnowfallIfWet: r.opt('total_snowfall_if_wet', _readQuantiles),
    precipitationDisplay: r.req('precipitation_display', _readPrecipDisplay),
    cloudCoverMean: r.opt('cloud_cover_mean', asDouble),
    wind: r.opt('wind', _readDailyWind),
    stormOrientation: r.opt('storm_orientation', enumOf(StormOrientation.new)),
    stormOrientationDescription:
        r.opt('storm_orientation_description', asString),
    astro: r.req('astro', _readDailyAstro),
    temperatureClimatology:
        r.opt('temperature_climatology', _readDayClimatology),
    coveredFrom: r.opt('covered_from', asDateTime),
    measuredPrecipitation:
        r.opt('measured_precipitation', _readMeasuredPrecipitation),
    snowCharacter: r.opt('snow_character', enumOf(SnowCharacter.new)),
    slr: r.opt('slr', asDouble),
    snowLevelRange: r.opt('snow_level_range', _readSnowLevelRange),
    snowLevelWetBulb: r.opt('snow_level_wet_bulb', _readQuantiles),
    snowLevelWetBulbRange:
        r.opt('snow_level_wet_bulb_range', _readSnowLevelRange),
    normal: r.opt('normal', _readDayNormal),
    departure: r.opt('departure', _readDayDeparture),
    percentile: r.opt('percentile', _readDayPercentile),
  );
}

/// A day's wind summary.
final class DailyWind {
  /// Creates a [DailyWind].
  DailyWind({
    this.status,
    this.peakSpeed,
    this.peakSpeedP90,
    this.isGust,
    this.sustainedSpeed,
  });

  /// Decodes a [DailyWind] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory DailyWind.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readDailyWind);

  /// Wind severity classification based on peak gust/speed.
  final WindStatus? status;

  /// Peak wind for the day (mph imperial, m/s metric): the expected peak — the
  /// mean over the ensemble members of each member's own maximum gust over the
  /// day's hours when gust data is available, otherwise of each member's own
  /// maximum sustained wind.
  final double? peakSpeed;

  /// The 90th-percentile counterpart of peak_speed (the 90th percentile of the
  /// members' own daily maximum gusts), a "gusts could reach" upper band.
  final double? peakSpeedP90;

  /// Whether peak_speed is from gust data (true) or sustained wind (false)
  final bool? isGust;

  /// Peak sustained wind for the day (mph imperial, m/s metric), independent of
  /// gust: the mean of the members' own daily maximum sustained winds.
  final double? sustainedSpeed;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (status case final v?) {
      out['status'] = v.value;
    }
    if (peakSpeed case final v?) {
      out['peak_speed'] = v;
    }
    if (peakSpeedP90 case final v?) {
      out['peak_speed_p90'] = v;
    }
    if (isGust case final v?) {
      out['is_gust'] = v;
    }
    if (sustainedSpeed case final v?) {
      out['sustained_speed'] = v;
    }
    return out;
  }
}

DailyWind _readDailyWind(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return DailyWind(
    status: r.opt('status', enumOf(WindStatus.new)),
    peakSpeed: r.opt('peak_speed', asDouble),
    peakSpeedP90: r.opt('peak_speed_p90', asDouble),
    isGust: r.opt('is_gust', asBool),
    sustainedSpeed: r.opt('sustained_speed', asDouble),
  );
}

/// The climatological temperature for a date.
final class DayClimatology {
  /// Creates a [DayClimatology].
  DayClimatology({
    required this.mean,
    required this.std,
  });

  /// Decodes a [DayClimatology] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory DayClimatology.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readDayClimatology);

  /// Seasonal mean temperature for the date -- PRISM's 1991-2020 normal within
  /// the contiguous US, else the station's or cell's all-hours mean.
  final double mean;

  /// Seasonal standard deviation (includes the diurnal range).
  final double std;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['mean'] = mean;
    out['std'] = std;
    return out;
  }
}

DayClimatology _readDayClimatology(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return DayClimatology(
    mean: r.req('mean', asDouble),
    std: r.req('std', asDouble),
  );
}

/// The served headline minus the normal, in the request's units.
///
/// `high.p50 - normal.high` and `low.p50 - normal.low`.
final class DayDeparture {
  /// Creates a [DayDeparture].
  DayDeparture({
    this.high,
    this.low,
  });

  /// Decodes a [DayDeparture] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory DayDeparture.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readDayDeparture);

  /// The `high` field.
  final double? high;

  /// The `low` field.
  final double? low;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (high case final v?) {
      out['high'] = v;
    }
    if (low case final v?) {
      out['low'] = v;
    }
    return out;
  }
}

DayDeparture _readDayDeparture(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return DayDeparture(
    high: r.opt('high', asDouble),
    low: r.opt('low', asDouble),
  );
}

/// The day's climate normal at the forecast point.
///
/// The mean, over the day of year +/-15 days of every year of the station's
/// record, of the very quantities this row states -- the local CALENDAR date's
/// maximum hourly temperature (`high`, the quantity `high` is), its minimum
/// (`low`) and its precipitation TOTAL (`precipitation`, dry days included; a
/// daily total, never an hourly amount).
final class DayNormal {
  /// Creates a [DayNormal].
  DayNormal({
    this.high,
    this.low,
    this.precipitation,
    required this.source,
    required this.distanceKm,
  });

  /// Decodes a [DayNormal] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory DayNormal.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readDayNormal);

  /// Mean local-calendar-day maximum temperature.
  final double? high;

  /// Mean local-calendar-day minimum temperature.
  final double? low;

  /// Mean local-calendar-day precipitation total, dry days included.
  final double? precipitation;

  /// A climatology station's own record, or the ERA5 cell of the point.
  final String source;

  /// Great-circle distance from the point to the station (or the cell centre),
  /// km.
  final double distanceKm;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (high case final v?) {
      out['high'] = v;
    }
    if (low case final v?) {
      out['low'] = v;
    }
    if (precipitation case final v?) {
      out['precipitation'] = v;
    }
    out['source'] = source;
    out['distance_km'] = distanceKm;
    return out;
  }
}

DayNormal _readDayNormal(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return DayNormal(
    high: r.opt('high', asDouble),
    low: r.opt('low', asDouble),
    precipitation: r.opt('precipitation', asDouble),
    source: r.req('source', asString),
    distanceKm: r.req('distance_km', asDouble),
  );
}

/// How unusual the day is.
///
/// Where the served headline (`p50`) falls in the day's climatological
/// distribution, as a percentile 0-100, `Pr{climate <= forecast}` -- 95 for
/// `precipitation` reads "wetter than 95% of this date's days".
final class DayPercentile {
  /// Creates a [DayPercentile].
  DayPercentile({
    this.high,
    this.low,
    this.precipitation,
  });

  /// Decodes a [DayPercentile] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory DayPercentile.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readDayPercentile);

  /// The `high` field.
  final double? high;

  /// The `low` field.
  final double? low;

  /// The `precipitation` field.
  final double? precipitation;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (high case final v?) {
      out['high'] = v;
    }
    if (low case final v?) {
      out['low'] = v;
    }
    if (precipitation case final v?) {
      out['precipitation'] = v;
    }
    return out;
  }
}

DayPercentile _readDayPercentile(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return DayPercentile(
    high: r.opt('high', asDouble),
    low: r.opt('low', asDouble),
    precipitation: r.opt('precipitation', asDouble),
  );
}

/// A full forecast at one of a location's extra elevations.
final class ElevationForecast {
  /// Creates an [ElevationForecast].
  ElevationForecast({
    required this.name,
    this.displayName,
    required this.height,
    required this.lat,
    required this.lon,
    this.hourly,
    this.daily,
    this.snowOutlook,
    this.precipitationOutlook,
    this.plume,
    this.snowOnGround,
    this.nearestSensors,
  });

  /// Decodes an [ElevationForecast] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ElevationForecast.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readElevationForecast);

  /// The elevation's id, as `location.elevations[].name`.
  final String name;

  /// What the place is called, as `location.elevations[].display_name`; absent
  /// where the catalog has no name for it.
  final String? displayName;

  /// (JSON `elevation`)
  final double height;

  /// Where this elevation was forecast — its own coordinates when the catalog
  /// has them, else the location's.
  final double lat;

  /// The `lon` field.
  final double lon;

  /// The full hourly series at this elevation — the same shape and the same
  /// code as `forecast.timeseries` (never with `model_means`).
  final List<TimeSeriesPoint>? hourly;

  /// Daily summaries at this elevation — the same daily build as
  /// `forecast.daily` (omitted when empty)
  final List<DailyForecast>? daily;

  /// Rolling snow totals at this elevation, as `forecast.snow_outlook` (omitted
  /// when there are no dailies)
  final SnowOutlook? snowOutlook;

  /// -- rolling liquid totals at this elevation, as
  /// `forecast.precipitation_outlook`.
  final PrecipOutlook? precipitationOutlook;

  /// This elevation's members in columns, as `forecast.plume` -- present only
  /// with `members=plume`, instead of `hourly`, `daily`, `snow_outlook` and
  /// `precipitation_outlook`.
  final MemberPlume? plume;

  /// The snow on the ground at this elevation, as the response's own
  /// `snow_on_ground`; absent where no snowpack column runs for it.
  final SnowOnGround? snowOnGround;

  /// A named spot's own nearby observation sensors, ranked around ITS point and
  /// elevation as the location's `nearest_sensors` are around the location's.
  final List<NearestSensor>? nearestSensors;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['name'] = name;
    if (displayName case final v?) {
      out['display_name'] = v;
    }
    out['elevation'] = height;
    out['lat'] = lat;
    out['lon'] = lon;
    if (hourly case final v?) {
      out['hourly'] = [for (final e in v) e.toJson()];
    }
    if (daily case final v?) {
      out['daily'] = [for (final e in v) e.toJson()];
    }
    if (snowOutlook case final v?) {
      out['snow_outlook'] = v.toJson();
    }
    if (precipitationOutlook case final v?) {
      out['precipitation_outlook'] = v.toJson();
    }
    if (plume case final v?) {
      out['plume'] = v.toJson();
    }
    if (snowOnGround case final v?) {
      out['snow_on_ground'] = v.toJson();
    }
    if (nearestSensors case final v?) {
      out['nearest_sensors'] = [for (final e in v) e.toJson()];
    }
    return out;
  }
}

ElevationForecast _readElevationForecast(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ElevationForecast(
    name: r.req('name', asString),
    displayName: r.opt('display_name', asString),
    height: r.req('elevation', asDouble),
    lat: r.req('lat', asDouble),
    lon: r.req('lon', asDouble),
    hourly: r.opt('hourly', listOf(_readTimeSeriesPoint)),
    daily: r.opt('daily', listOf(_readDailyForecast)),
    snowOutlook: r.opt('snow_outlook', _readSnowOutlook),
    precipitationOutlook: r.opt('precipitation_outlook', _readPrecipOutlook),
    plume: r.opt('plume', _readMemberPlume),
    snowOnGround: r.opt('snow_on_ground', _readSnowOnGround),
    nearestSensors: r.opt('nearest_sensors', listOf(_readNearestSensor)),
  );
}

/// One named elevation of a location (ski-area base, mid, summit). Attributes.
///
/// Name: The elevation's id: the name to pass in `elevations=`. display_name:
/// What the place is called, for display ("K-1 Lodge"). elevation: In the
/// request's length units (m, ft), to 0.1. default: `true` on the primary only.
final class ElevationSummary {
  /// Creates an [ElevationSummary].
  ElevationSummary({
    required this.name,
    this.displayName,
    required this.height,
    this.isDefault,
  });

  /// Decodes an [ElevationSummary] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ElevationSummary.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readElevationSummary);

  /// The elevation's id: the name to pass in `?elevations=` (case, `-`, `_` and
  /// spaces ignored).
  final String name;

  /// What the place is called, for display ("K-1 Lodge", "FourRunner Quad
  /// top").
  final String? displayName;

  /// (JSON `elevation`) In the caller's length units (m, ft), to 0.1.
  final double height;

  /// Present (true) on the primary only.
  final bool? isDefault;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['name'] = name;
    if (displayName case final v?) {
      out['display_name'] = v;
    }
    out['elevation'] = height;
    if (isDefault case final v?) {
      out['default'] = v;
    }
    return out;
  }
}

ElevationSummary _readElevationSummary(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ElevationSummary(
    name: r.req('name', asString),
    displayName: r.opt('display_name', asString),
    height: r.req('elevation', asDouble),
    isDefault: r.opt('default', asBool),
  );
}

/// The distribution of every variable at one hour.
final class EnsembleStats {
  /// Creates an [EnsembleStats].
  EnsembleStats({
    required this.temperature,
    this.feelsLike,
    this.dewpoint,
    required this.precipitation,
    required this.windSpeed,
    this.windGust,
    required this.windDirection,
    this.snowLevel,
    this.snowLevelWetBulb,
    this.slr,
    this.snowfall,
    this.cloudCover,
    this.skinTemperature,
    this.mslp,
    this.cape,
    this.relativeHumidity,
  });

  /// Decodes an [EnsembleStats] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory EnsembleStats.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readEnsembleStats);

  /// THE distribution shape -- every ensemble statistic the API serves (hourly
  /// `ensemble.*`, per-model `model_means[].*`, the daily
  /// `high`/`low`/`total_*`/`feels_like_*`, the plume's `members_cumulative`,
  /// `?totals=` windows, `snow_outlook.quantiles` windows, the daily
  /// `snow_level` and `*_if_wet`) is this one object, in the request's units.
  final Quantiles temperature;

  /// Apparent temperature, the NWS convention: the wind chill (NWS 2001,
  /// Osczevski & Bluestein 2005) where the air is at or below 10 C (50 F) and
  /// the 10 m wind above 4.8 km/h (3 mph); the heat index (NWS / Rothfusz 1990)
  /// where the air is at or above 26.7 C (80 F); the air temperature everywhere
  /// else.
  final Quantiles? feelsLike;

  /// THE distribution shape -- every ensemble statistic the API serves (hourly
  /// `ensemble.*`, per-model `model_means[].*`, the daily
  /// `high`/`low`/`total_*`/`feels_like_*`, the plume's `members_cumulative`,
  /// `?totals=` windows, `snow_outlook.quantiles` windows, the daily
  /// `snow_level` and `*_if_wet`) is this one object, in the request's units.
  final Quantiles? dewpoint;

  /// THE distribution shape -- every ensemble statistic the API serves (hourly
  /// `ensemble.*`, per-model `model_means[].*`, the daily
  /// `high`/`low`/`total_*`/`feels_like_*`, the plume's `members_cumulative`,
  /// `?totals=` windows, `snow_outlook.quantiles` windows, the daily
  /// `snow_level` and `*_if_wet`) is this one object, in the request's units.
  final Quantiles precipitation;

  /// THE distribution shape -- every ensemble statistic the API serves (hourly
  /// `ensemble.*`, per-model `model_means[].*`, the daily
  /// `high`/`low`/`total_*`/`feels_like_*`, the plume's `members_cumulative`,
  /// `?totals=` windows, `snow_outlook.quantiles` windows, the daily
  /// `snow_level` and `*_if_wet`) is this one object, in the request's units.
  final Quantiles windSpeed;

  /// Peak gust (same unit as `wind_speed`).
  final Quantiles? windGust;

  /// Circular: see `CircularStats`.
  final CircularStats windDirection;

  /// The RAIN LINE (m MSL, or ft with `units=imperial`): the bottom of the
  /// melting layer, the height by which falling snow has fully melted.
  final Quantiles? snowLevel;

  /// The snow level on the NWS (wet-bulb) scale.
  final Quantiles? snowLevelWetBulb;

  /// Snow-to-liquid ratio (SLR): how many units of snow depth one unit of
  /// liquid water makes, unitless (12 reads "12:1": 1 mm of water, 12 mm of
  /// snow), the same in every unit system.
  final Quantiles? slr;

  /// Hourly snowfall depth at the location's elevation (mm, or inches for
  /// imperial callers): the hour's precipitation times the effective
  /// snow-to-liquid ratio at the point, with `probability` the chance of
  /// measurable snow.
  final Quantiles? snowfall;

  /// Cloud cover percentage (0-100%)
  final Quantiles? cloudCover;

  /// Only with `include=["skin_temperature"]`.
  final Quantiles? skinTemperature;

  /// Only with `include=["mslp"]`.
  final Quantiles? mslp;

  /// Convective available potential energy, J/kg in every unit system.
  final Quantiles? cape;

  /// Relative humidity, percent 0–100 in every unit system, computed like
  /// `feels_like`: for each ensemble member from its own calibrated temperature
  /// and dewpoint, then summarised, so no percentile pairs one member's
  /// temperature with another's dewpoint.
  final Quantiles? relativeHumidity;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['temperature'] = temperature.toJson();
    if (feelsLike case final v?) {
      out['feels_like'] = v.toJson();
    }
    if (dewpoint case final v?) {
      out['dewpoint'] = v.toJson();
    }
    out['precipitation'] = precipitation.toJson();
    out['wind_speed'] = windSpeed.toJson();
    if (windGust case final v?) {
      out['wind_gust'] = v.toJson();
    }
    out['wind_direction'] = windDirection.toJson();
    if (snowLevel case final v?) {
      out['snow_level'] = v.toJson();
    }
    if (snowLevelWetBulb case final v?) {
      out['snow_level_wet_bulb'] = v.toJson();
    }
    if (slr case final v?) {
      out['slr'] = v.toJson();
    }
    if (snowfall case final v?) {
      out['snowfall'] = v.toJson();
    }
    if (cloudCover case final v?) {
      out['cloud_cover'] = v.toJson();
    }
    if (skinTemperature case final v?) {
      out['skin_temperature'] = v.toJson();
    }
    if (mslp case final v?) {
      out['mslp'] = v.toJson();
    }
    if (cape case final v?) {
      out['cape'] = v.toJson();
    }
    if (relativeHumidity case final v?) {
      out['relative_humidity'] = v.toJson();
    }
    return out;
  }
}

EnsembleStats _readEnsembleStats(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return EnsembleStats(
    temperature: r.req('temperature', _readQuantiles),
    feelsLike: r.opt('feels_like', _readQuantiles),
    dewpoint: r.opt('dewpoint', _readQuantiles),
    precipitation: r.req('precipitation', _readQuantiles),
    windSpeed: r.req('wind_speed', _readQuantiles),
    windGust: r.opt('wind_gust', _readQuantiles),
    windDirection: r.req('wind_direction', _readCircularStats),
    snowLevel: r.opt('snow_level', _readQuantiles),
    snowLevelWetBulb: r.opt('snow_level_wet_bulb', _readQuantiles),
    slr: r.opt('slr', _readQuantiles),
    snowfall: r.opt('snowfall', _readQuantiles),
    cloudCover: r.opt('cloud_cover', _readQuantiles),
    skinTemperature: r.opt('skin_temperature', _readQuantiles),
    mslp: r.opt('mslp', _readQuantiles),
    cape: r.opt('cape', _readQuantiles),
    relativeHumidity: r.opt('relative_humidity', _readQuantiles),
  );
}

/// One ranked point of a place.
final class ExploreItem {
  /// Creates an [ExploreItem].
  ExploreItem({
    required this.rank,
    required this.location,
    this.elevationName,
    this.elevationDisplayName,
    required this.elevation,
    required this.value,
    this.p10,
    this.p90,
    required this.asOf,
    this.initializedAt,
    required this.source,
    this.distanceKm,
    required this.path,
  });

  /// Decodes an [ExploreItem] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ExploreItem.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readExploreItem);

  /// 1-based, across pages.
  final int rank;

  /// ONE location reference, the same wherever a place is named -- the
  /// forecast's and `/current`'s `location`, every list and `/nearby` row,
  /// search hits and favorites.
  final LocationRef location;

  /// The named elevation; `null` = the place's own point.
  final String? elevationName;

  /// What the elevation `elevation_name` is called, as
  /// `ElevationSummary.display_name`; absent where it has no name.
  final String? elevationDisplayName;

  /// The point's elevation, m or ft by `units`.
  final double elevation;

  /// The metric's value as the place's page serves it, in `unit`.
  final double value;

  /// Present only on `snow_today` (the day's served `total_snowfall.p10`, where
  /// it has a `snow_amount`) and `precip_today`
  /// (`total_precipitation_if_wet.p10`, where the day is not `none`).
  final double? p10;

  /// As `p10`.
  final double? p90;

  /// When the value was taken: the forecast windows when recorded from the
  /// served run, `base_depth` its hour, `new_snow_24h` the snowpack run's first
  /// hour, the season its newest computed day.
  final DateTime asOf;

  /// Forecast windows only, the served run's `model_run.initialized_at`.
  final DateTime? initializedAt;

  /// The `source` field.
  final String source;

  /// With `near` only, from it (0.1 km).
  final double? distanceKm;

  /// The place's forecast route; add `?elevations=<elevation_name>` for a named
  /// point.
  final String path;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['rank'] = rank;
    out['location'] = location.toJson();
    if (elevationName case final v?) {
      out['elevation_name'] = v;
    }
    if (elevationDisplayName case final v?) {
      out['elevation_display_name'] = v;
    }
    out['elevation'] = elevation;
    out['value'] = value;
    if (p10 case final v?) {
      out['p10'] = v;
    }
    if (p90 case final v?) {
      out['p90'] = v;
    }
    out['as_of'] = formatDateTime(asOf);
    if (initializedAt case final v?) {
      out['initialized_at'] = formatDateTime(v);
    }
    out['source'] = source;
    if (distanceKm case final v?) {
      out['distance_km'] = v;
    }
    out['path'] = path;
    return out;
  }
}

ExploreItem _readExploreItem(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ExploreItem(
    rank: r.req('rank', asInt),
    location: r.req('location', _readLocationRef),
    elevationName: r.opt('elevation_name', asString),
    elevationDisplayName: r.opt('elevation_display_name', asString),
    elevation: r.req('elevation', asDouble),
    value: r.req('value', asDouble),
    p10: r.opt('p10', asDouble),
    p90: r.opt('p90', asDouble),
    asOf: r.req('as_of', asDateTime),
    initializedAt: r.opt('initialized_at', asDateTime),
    source: r.req('source', asString),
    distanceKm: r.opt('distance_km', asDouble),
    path: r.req('path', asString),
  );
}

/// One page of a ranking.
final class ExploreResponse extends Response {
  /// Creates an [ExploreResponse].
  ExploreResponse({
    required this.metric,
    required this.order,
    required this.units,
    required this.unit,
    required this.items,
    required this.count,
    this.nextCursor,
  });

  /// Decodes an [ExploreResponse] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ExploreResponse.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readExploreResponse);

  /// The `metric` field.
  final String metric;

  /// The `order` field.
  final String order;

  /// Unit system for response values.
  final UnitSystem units;

  /// The unit of every `value`, `p10` and `p90`.
  final String unit;

  /// One ranked point of a place.
  final List<ExploreItem> items;

  /// Items on this page.
  final int count;

  /// Pass as `?cursor=` (same other parameters) for the next page; null at the
  /// end.
  final String? nextCursor;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['metric'] = metric;
    out['order'] = order;
    out['units'] = units.value;
    out['unit'] = unit;
    out['items'] = [for (final e in items) e.toJson()];
    out['count'] = count;
    if (nextCursor case final v?) {
      out['next_cursor'] = v;
    }
    return out;
  }
}

ExploreResponse _readExploreResponse(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ExploreResponse(
    metric: r.req('metric', asString),
    order: r.req('order', asString),
    units: r.req('units', enumOf(UnitSystem.new)),
    unit: r.req('unit', asString),
    items: r.req('items', listOf(_readExploreItem)),
    count: r.req('count', asInt),
    nextCursor: r.opt('next_cursor', asString),
  );
}

/// A search hit's Explore value; the fields mean what an `ExploreItem`'s do.
final class ExploreValue {
  /// Creates an [ExploreValue].
  ExploreValue({
    required this.metric,
    required this.value,
    required this.unit,
    this.p10,
    this.p90,
    required this.asOf,
    this.initializedAt,
    required this.source,
  });

  /// Decodes an [ExploreValue] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ExploreValue.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readExploreValue);

  /// The `metric` field.
  final String metric;

  /// The `value` field.
  final double value;

  /// The `unit` field.
  final String unit;

  /// The `p10` field.
  final double? p10;

  /// The `p90` field.
  final double? p90;

  /// The `as_of` field.
  final DateTime asOf;

  /// The `initialized_at` field.
  final DateTime? initializedAt;

  /// The `source` field.
  final String source;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['metric'] = metric;
    out['value'] = value;
    out['unit'] = unit;
    if (p10 case final v?) {
      out['p10'] = v;
    }
    if (p90 case final v?) {
      out['p90'] = v;
    }
    out['as_of'] = formatDateTime(asOf);
    if (initializedAt case final v?) {
      out['initialized_at'] = formatDateTime(v);
    }
    out['source'] = source;
    return out;
  }
}

ExploreValue _readExploreValue(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ExploreValue(
    metric: r.req('metric', asString),
    value: r.req('value', asDouble),
    unit: r.req('unit', asString),
    p10: r.opt('p10', asDouble),
    p90: r.opt('p90', asDouble),
    asOf: r.req('as_of', asDateTime),
    initializedAt: r.opt('initialized_at', asDateTime),
    source: r.req('source', asString),
  );
}

/// The hourly series and the daily summaries.
final class ForecastData {
  /// Creates a [ForecastData].
  ForecastData({
    required this.maxHours,
    required this.intervalHours,
    this.timeseries = const [],
    this.daily = const [],
    this.snowOutlook,
    this.precipitationOutlook,
    this.plume,
  });

  /// Decodes a [ForecastData] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ForecastData.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readForecastData);

  /// The last served hour, in hours from the FIRST served one (the current hour
  /// by default, the run's init with `include_past=true` or a pinned `run`) --
  /// the request's `max_hours` clamped to the tier, less when the run ends
  /// first.
  final int maxHours;

  /// The `interval_hours` field.
  final int intervalHours;

  /// The hourly series (empty with `hourly=false`).
  final List<TimeSeriesPoint> timeseries;

  /// The daily summaries (empty with `daily=false`).
  final List<DailyForecast> daily;

  /// Rolling snow-accumulation summary for common UI windows.
  final SnowOutlook? snowOutlook;

  /// Rolling LIQUID totals over `snow_outlook`'s windows (24 h, 48 h, 72 h, 7
  /// days), with their ranges.
  final PrecipOutlook? precipitationOutlook;

  /// The plume view (`members="plume"`): columns, not hourly rows.
  final MemberPlume? plume;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['max_hours'] = maxHours;
    out['interval_hours'] = intervalHours;
    out['timeseries'] = [for (final e in timeseries) e.toJson()];
    out['daily'] = [for (final e in daily) e.toJson()];
    if (snowOutlook case final v?) {
      out['snow_outlook'] = v.toJson();
    }
    if (precipitationOutlook case final v?) {
      out['precipitation_outlook'] = v.toJson();
    }
    if (plume case final v?) {
      out['plume'] = v.toJson();
    }
    return out;
  }
}

ForecastData _readForecastData(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ForecastData(
    maxHours: r.req('max_hours', asInt),
    intervalHours: r.req('interval_hours', asInt),
    timeseries: r.opt('timeseries', listOf(_readTimeSeriesPoint)) ?? const [],
    daily: r.opt('daily', listOf(_readDailyForecast)) ?? const [],
    snowOutlook: r.opt('snow_outlook', _readSnowOutlook),
    precipitationOutlook: r.opt('precipitation_outlook', _readPrecipOutlook),
    plume: r.opt('plume', _readMemberPlume),
  );
}

/// The forecast's `location`.
///
/// The one `LocationRef` (every field where it was) plus what a forecast client
/// labels and picks with, so the forecast body alone is enough to draw a plume
/// or a meteogram at a named elevation (no `/nearby` call, no client-side unit
/// conversion).
final class ForecastLocation implements NamedLocation {
  /// Creates a [ForecastLocation].
  ForecastLocation({
    this.slug,
    required this.state,
    required this.name,
    required this.lat,
    required this.lon,
    required this.elevationM,
    this.type,
    required this.timezone,
    required this.elevation,
    this.elevations,
  });

  /// Decodes a [ForecastLocation] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ForecastLocation.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readForecastLocation);

  /// The location's key: its catalog slug.
  @override
  final String? slug;

  /// The lowercase USPS state code.
  @override
  final String state;

  /// The display name.
  final String name;

  /// The `lat` field.
  final double lat;

  /// The `lon` field.
  final double lon;

  /// Elevation in metres, whatever `units` is (0.1 m).
  final double elevationM;

  /// The primary location type, snake_case.
  final LocationType? type;

  /// The IANA zone the location's local days and hours are kept in -- the zone
  /// `daily` dates, sunrise and sunset are computed in.
  final String timezone;

  /// `elevation_m` in the request's length units (m for `metric`/`kelvin`, ft
  /// for `imperial`), to 0.1 -- the elevation `forecast.timeseries` (and its
  /// members) is served at.
  final double elevation;

  /// The location's named elevations -- exactly the list its `/nearby` and list
  /// rows serve (`LocationSummary.elevations`): the primary first and its ONE
  /// `default: true`, then each other elevation (ski-area base / mid / summit),
  /// in the request's ...
  final List<ElevationSummary>? elevations;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (slug case final v?) {
      out['slug'] = v;
    }
    out['state'] = state;
    out['name'] = name;
    out['lat'] = lat;
    out['lon'] = lon;
    out['elevation_m'] = elevationM;
    if (type case final v?) {
      out['type'] = v.value;
    }
    out['timezone'] = timezone;
    out['elevation'] = elevation;
    if (elevations case final v?) {
      out['elevations'] = [for (final e in v) e.toJson()];
    }
    return out;
  }
}

ForecastLocation _readForecastLocation(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ForecastLocation(
    slug: r.opt('slug', asString),
    state: r.req('state', asString),
    name: r.req('name', asString),
    lat: r.req('lat', asDouble),
    lon: r.req('lon', asDouble),
    elevationM: r.req('elevation_m', asDouble),
    type: r.opt('type', enumOf(LocationType.new)),
    timezone: r.req('timezone', asString),
    elevation: r.req('elevation', asDouble),
    elevations: r.opt('elevations', listOf(_readElevationSummary)),
  );
}

/// A forecast: the hourly series, daily summaries, and what was asked.
///
/// `probabilities` and `window_totals` are in the order of the caller's `prob`
/// and `totals` arguments (the SDK sends them in a canonical order and maps the
/// answers back); duplicate terms share one result.
final class ForecastResponse extends Response {
  /// Creates a [ForecastResponse].
  ForecastResponse({
    this.thresholds,
    this.probabilities = const [],
    this.windowTotals = const [],
    this.applied,
    required this.location,
    required this.modelRun,
    required this.units,
    required this.series,
    this.elevations,
    required this.nowcastApplied,
    this.nowcastUnavailable,
    this.membersView,
    this.gapFlow,
    this.nearestSensors,
    this.point,
    this.current,
    this.snowOnGround,
    this.avalanche,
    required this.attribution,
  });

  /// Decodes a [ForecastResponse] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ForecastResponse.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readForecastResponse);

  /// The event behind each served probability, in the request's units, so no
  /// client hard-codes them: P(amount &gt;= the threshold).
  final ProbabilityThresholds? thresholds;

  /// One result per `prob` term, in the caller's order.
  final List<ProbabilityResult> probabilities;

  /// One result per `totals` request, in the caller's order.
  final List<WindowTotal> windowTotals;

  /// The forecast options the server applied, after the tier clamps and bounds.
  final AppliedOptions? applied;

  /// The forecast's `location` -- the one `LocationRef` (every field where it
  /// was) plus what a forecast client labels and picks with, so the forecast
  /// body alone is enough to draw a plume or a meteogram at a named elevation
  /// (no `/nearby` call, no client-side unit conversion).
  final ForecastLocation location;

  /// The composition the forecast was blended from.
  final ModelRunInfo modelRun;

  /// The unit system every value in this body is in -- the request's `units=`,
  /// `metric` when it is not given.
  final UnitSystem units;

  /// (JSON `forecast`)
  final ForecastData series;

  /// (JSON `elevation_forecasts`) Forecast at one of a location's additional
  /// elevations (ski-area base / mid / summit).
  final List<ElevationForecast>? elevations;

  /// Whether the live nowcast layer is baked in.
  final bool nowcastApplied;

  /// The live nowcast sources this body was built WITHOUT because their read
  /// did not answer in time (or failed): the nearest station's reading
  /// (`observation`), MRMS `radar`, GOES `cloud`, or the `nearest_sensors`
  /// list.
  final List<NowcastLayer>? nowcastUnavailable;

  /// Which member view `forecast.timeseries[*].members` (and
  /// `elevation_forecasts[*].hourly[*].members`) carries; present exactly when
  /// members are.
  final MembersView? membersView;

  /// Columbia Gorge gap flow status at the first served hour, from the forecast
  /// mean-sea-level-pressure difference across the Gorge (The Dalles minus
  /// Portland, each model differenced on its own, then averaged).
  final GapFlow? gapFlow;

  /// Nearby observation sensors ranked by an elevation-weighted distance.
  final List<NearestSensor>? nearestSensors;

  /// Where a coordinate forecast (`GET /api/v1/forecast`) was computed.
  final PointInfo? point;

  /// "Right now" as one flat object: a view of ONE served hourly point, never a
  /// second forecast.
  final CurrentConditions? current;

  /// The snow on the ground at the location's own point at the hour the request
  /// is served, from the snowpack model.
  final SnowOnGround? snowOnGround;

  /// Today's avalanche danger rating for the location's forecast zone, if any.
  final AvalancheForecast? avalanche;

  /// The data sources THIS response drew on, and what their licences ask us to
  /// say.
  final ResponseAttribution attribution;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (thresholds case final v?) {
      out['thresholds'] = v.toJson();
    }
    out['probabilities'] = [for (final e in probabilities) e.toJson()];
    out['window_totals'] = [for (final e in windowTotals) e.toJson()];
    if (applied case final v?) {
      out['applied'] = v.toJson();
    }
    out['location'] = location.toJson();
    out['model_run'] = modelRun.toJson();
    out['units'] = units.value;
    out['forecast'] = series.toJson();
    if (elevations case final v?) {
      out['elevation_forecasts'] = [for (final e in v) e.toJson()];
    }
    out['nowcast_applied'] = nowcastApplied;
    if (nowcastUnavailable case final v?) {
      out['nowcast_unavailable'] = [for (final e in v) e.value];
    }
    if (membersView case final v?) {
      out['members_view'] = v.value;
    }
    if (gapFlow case final v?) {
      out['gap_flow'] = v.toJson();
    }
    if (nearestSensors case final v?) {
      out['nearest_sensors'] = [for (final e in v) e.toJson()];
    }
    if (point case final v?) {
      out['point'] = v.toJson();
    }
    if (current case final v?) {
      out['current'] = v.toJson();
    }
    if (snowOnGround case final v?) {
      out['snow_on_ground'] = v.toJson();
    }
    if (avalanche case final v?) {
      out['avalanche'] = v.toJson();
    }
    out['attribution'] = attribution.toJson();
    return out;
  }
}

ForecastResponse _readForecastResponse(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ForecastResponse(
    thresholds: r.opt('thresholds', _readProbabilityThresholds),
    probabilities:
        r.opt('probabilities', listOf(_readProbabilityResult)) ?? const [],
    windowTotals: r.opt('window_totals', listOf(_readWindowTotal)) ?? const [],
    applied: r.opt('applied', _readAppliedOptions),
    location: r.req('location', _readForecastLocation),
    modelRun: r.req('model_run', _readModelRunInfo),
    units: r.req('units', enumOf(UnitSystem.new)),
    series: r.req('forecast', _readForecastData),
    elevations: r.opt('elevation_forecasts', listOf(_readElevationForecast)),
    nowcastApplied: r.req('nowcast_applied', asBool),
    nowcastUnavailable:
        r.opt('nowcast_unavailable', listOf(enumOf(NowcastLayer.new))),
    membersView: r.opt('members_view', enumOf(MembersView.new)),
    gapFlow: r.opt('gap_flow', _readGapFlow),
    nearestSensors: r.opt('nearest_sensors', listOf(_readNearestSensor)),
    point: r.opt('point', _readPointInfo),
    current: r.opt('current', _readCurrentConditions),
    snowOnGround: r.opt('snow_on_ground', _readSnowOnGround),
    avalanche: r.opt('avalanche', _readAvalancheForecast),
    attribution: r.req('attribution', _readResponseAttribution),
  );
}

/// Where the freezing level is.
///
/// `kind` says which fields apply: `height` (with `height` and
/// `above_freezing_layer_aloft`), `above_profile` (with `top`) or
/// `below_surface` (neither).
final class FreezingLevel {
  /// Creates a [FreezingLevel].
  FreezingLevel({
    required this.kind,
    this.height,
    this.aboveFreezingLayerAloft,
    this.top,
  });

  /// Decodes a [FreezingLevel] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory FreezingLevel.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readFreezingLevel);

  /// The `kind` field.
  final FreezingLevelKind kind;

  /// The `height` field.
  final double? height;

  /// The `above_freezing_layer_aloft` field.
  final bool? aboveFreezingLayerAloft;

  /// The `top` field.
  final double? top;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['kind'] = kind.value;
    if (height case final v?) {
      out['height'] = v;
    }
    if (aboveFreezingLayerAloft case final v?) {
      out['above_freezing_layer_aloft'] = v;
    }
    if (top case final v?) {
      out['top'] = v;
    }
    return out;
  }
}

FreezingLevel _readFreezingLevel(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return FreezingLevel(
    kind: r.req('kind', enumOf(FreezingLevelKind.new)),
    height: r.opt('height', asDouble),
    aboveFreezingLayerAloft: r.opt('above_freezing_layer_aloft', asBool),
    top: r.opt('top', asDouble),
  );
}

/// A gap-flow wind event (Columbia Gorge style).
final class GapFlow {
  /// Creates a [GapFlow].
  GapFlow({
    this.status,
    this.pressureDiffHpa,
    this.windMultiplier,
    this.direction,
  });

  /// Decodes a [GapFlow] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory GapFlow.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readGapFlow);

  /// The `status` field.
  final GapFlowStatus? status;

  /// The `pressure_diff_hpa` field.
  final double? pressureDiffHpa;

  /// The `wind_multiplier` field.
  final double? windMultiplier;

  /// The `direction` field.
  final String? direction;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (status case final v?) {
      out['status'] = v.value;
    }
    if (pressureDiffHpa case final v?) {
      out['pressure_diff_hpa'] = v;
    }
    if (windMultiplier case final v?) {
      out['wind_multiplier'] = v;
    }
    if (direction case final v?) {
      out['direction'] = v;
    }
    return out;
  }
}

GapFlow _readGapFlow(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return GapFlow(
    status: r.opt('status', enumOf(GapFlowStatus.new)),
    pressureDiffHpa: r.opt('pressure_diff_hpa', asDouble),
    windMultiplier: r.opt('wind_multiplier', asDouble),
    direction: r.opt('direction', asString),
  );
}

/// Which post-processing rule shaped each variable (`diagnostics=provenance`).
final class HourProvenance {
  /// Creates a [HourProvenance].
  HourProvenance({
    this.densified,
    this.ngr,
    this.fallback,
    this.borrowed,
    this.spreadFloored,
    this.floorClamped,
    this.bucketSplit,
    this.distributionParameters,
    this.spreadInterpolated,
    this.interpolatedContributor,
    this.momentMatchedFamily,
    this.lapseProfile,
    this.lapseClimatology,
    this.lapsePrism,
    this.spreadClampedLow,
    this.spreadClampedHigh,
    this.gustDressed,
  });

  /// Decodes a [HourProvenance] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory HourProvenance.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readHourProvenance);

  /// This hour sits strictly between two native model steps: its instantaneous
  /// values were linearly interpolated (plus a diurnal bulge), not read from a
  /// model step.
  final bool? densified;

  /// Variables corrected by a fitted NGR / truncated-NGR / censored-gamma model
  /// for this location, variable and lead-time bin.
  final List<ProvenanceVariable>? ngr;

  /// Variables served through the `inflate_around_mean` fallback because no
  /// fitted model was available for that lead-time bin.
  final List<ProvenanceVariable>? fallback;

  /// Variables at a point no fitted station reaches (none within 75 km), served
  /// from the fits of climatologically similar supplemental stations (same
  /// terrain class, ranked by distance and elevation difference, kept apart
  /// from one another) and shrunk toward the fallback.
  final List<ProvenanceVariable>? borrowed;

  /// Variables whose percentile ladder was rebuilt as `N(mean,
  /// min_serve_sigma)` by the serve-time spread floor.
  final List<ProvenanceVariable>? spreadFloored;

  /// Variables whose low tail was truncated by the zero floor.
  final List<ProvenanceVariable>? floorClamped;

  /// Accumulation variables whose value at this hour is an even share of a
  /// wider accumulation, not an independently modelled hourly rate: either a
  /// native multi-hour bucket split across the hours between two model steps,
  /// or a contributor's accumulation spread evenly across the hours that failed
  /// to download before it — the missing hours are served with their share, and
  /// no hour carries a multi-step total.
  final List<ProvenanceVariable>? bucketSplit;

  /// Variables whose blend included a contributor that supplied a two-parameter
  /// predictive distribution (a location and a scale) instead of ensemble
  /// members.
  final List<ProvenanceVariable>? distributionParameters;

  /// Variables whose spread was not measured by ANY contributor at this hour
  /// and was interpolated from the bracketing hours that did measure it.
  final List<ProvenanceVariable>? spreadInterpolated;

  /// Variables whose pool at this hour contains at least one contributor that
  /// did NOT publish at this lead.
  final List<ProvenanceVariable>? interpolatedContributor;

  /// Variables whose served `probability` was computed from a distribution
  /// recovered by METHOD OF MOMENTS from the hour's mean and standard
  /// deviation, rather than from the exact parameters the calibration fit
  /// produced.
  final List<ProvenanceVariable>? momentMatchedFamily;

  /// Variables carried from the location's primary elevation to this point's
  /// elevation by the hour's OWN upper-air lapse rate (the profile bracketed
  /// the layer).
  final List<ProvenanceVariable>? lapseProfile;

  /// Variables carried from the location's primary elevation to this point's
  /// elevation by a CLIMATOLOGICAL lapse rate — for `temperature` because the
  /// hour's profile could not bracket the layer (always the case below the
  /// primary, where the profile starts), the diurnal table; for `dewpoint`
  /// always, a mean 2 °C/km (no upper-air humidity is ingested).
  final List<ProvenanceVariable>? lapseClimatology;

  /// Variables carried from the location's primary elevation to this point's
  /// elevation by the local PRISM precipitation–elevation regression: the PRISM
  /// 800 m climatological normals at the observing stations within 40 km,
  /// regressed on the stations' elevations (distance-weighted, Daly et al.
  final List<ProvenanceVariable>? lapsePrism;

  /// Variables whose calibration fit was accepted and served, but whose fitted
  /// spread fell BELOW the serve-time spread band and was re-inflated to the
  /// band's low edge.
  final List<ProvenanceVariable>? spreadClampedLow;

  /// Variables whose calibration fit was accepted and served, but whose fitted
  /// spread rose ABOVE the serve-time spread band and was cut back to the
  /// band's high edge.
  final List<ProvenanceVariable>? spreadClampedHigh;

  /// Variables whose pool at this hour included a contributor that publishes a
  /// 10 m wind but no gust (the AI ensembles) and was dressed from its mean
  /// wind by the WMO in-land gust factor of 1.75 (Harper, Kepert & Ginger 2010,
  /// WMO/TD-No.
  final List<ProvenanceVariable>? gustDressed;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (densified case final v?) {
      out['densified'] = v;
    }
    if (ngr case final v?) {
      out['ngr'] = [for (final e in v) e.value];
    }
    if (fallback case final v?) {
      out['fallback'] = [for (final e in v) e.value];
    }
    if (borrowed case final v?) {
      out['borrowed'] = [for (final e in v) e.value];
    }
    if (spreadFloored case final v?) {
      out['spread_floored'] = [for (final e in v) e.value];
    }
    if (floorClamped case final v?) {
      out['floor_clamped'] = [for (final e in v) e.value];
    }
    if (bucketSplit case final v?) {
      out['bucket_split'] = [for (final e in v) e.value];
    }
    if (distributionParameters case final v?) {
      out['distribution_parameters'] = [for (final e in v) e.value];
    }
    if (spreadInterpolated case final v?) {
      out['spread_interpolated'] = [for (final e in v) e.value];
    }
    if (interpolatedContributor case final v?) {
      out['interpolated_contributor'] = [for (final e in v) e.value];
    }
    if (momentMatchedFamily case final v?) {
      out['moment_matched_family'] = [for (final e in v) e.value];
    }
    if (lapseProfile case final v?) {
      out['lapse_profile'] = [for (final e in v) e.value];
    }
    if (lapseClimatology case final v?) {
      out['lapse_climatology'] = [for (final e in v) e.value];
    }
    if (lapsePrism case final v?) {
      out['lapse_prism'] = [for (final e in v) e.value];
    }
    if (spreadClampedLow case final v?) {
      out['spread_clamped_low'] = [for (final e in v) e.value];
    }
    if (spreadClampedHigh case final v?) {
      out['spread_clamped_high'] = [for (final e in v) e.value];
    }
    if (gustDressed case final v?) {
      out['gust_dressed'] = [for (final e in v) e.value];
    }
    return out;
  }
}

HourProvenance _readHourProvenance(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return HourProvenance(
    densified: r.opt('densified', asBool),
    ngr: r.opt('ngr', listOf(enumOf(ProvenanceVariable.new))),
    fallback: r.opt('fallback', listOf(enumOf(ProvenanceVariable.new))),
    borrowed: r.opt('borrowed', listOf(enumOf(ProvenanceVariable.new))),
    spreadFloored:
        r.opt('spread_floored', listOf(enumOf(ProvenanceVariable.new))),
    floorClamped:
        r.opt('floor_clamped', listOf(enumOf(ProvenanceVariable.new))),
    bucketSplit: r.opt('bucket_split', listOf(enumOf(ProvenanceVariable.new))),
    distributionParameters: r.opt(
        'distribution_parameters', listOf(enumOf(ProvenanceVariable.new))),
    spreadInterpolated:
        r.opt('spread_interpolated', listOf(enumOf(ProvenanceVariable.new))),
    interpolatedContributor: r.opt(
        'interpolated_contributor', listOf(enumOf(ProvenanceVariable.new))),
    momentMatchedFamily:
        r.opt('moment_matched_family', listOf(enumOf(ProvenanceVariable.new))),
    lapseProfile:
        r.opt('lapse_profile', listOf(enumOf(ProvenanceVariable.new))),
    lapseClimatology:
        r.opt('lapse_climatology', listOf(enumOf(ProvenanceVariable.new))),
    lapsePrism: r.opt('lapse_prism', listOf(enumOf(ProvenanceVariable.new))),
    spreadClampedLow:
        r.opt('spread_clamped_low', listOf(enumOf(ProvenanceVariable.new))),
    spreadClampedHigh:
        r.opt('spread_clamped_high', listOf(enumOf(ProvenanceVariable.new))),
    gustDressed: r.opt('gust_dressed', listOf(enumOf(ProvenanceVariable.new))),
  );
}

/// A temperature inversion at the hour.
final class InversionInfo {
  /// Creates an [InversionInfo].
  InversionInfo({
    required this.kind,
    required this.depth,
    required this.strength,
  });

  /// Decodes an [InversionInfo] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory InversionInfo.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readInversionInfo);

  /// `surface_shallow`: shallow (&lt;300 m) surface-based inversion, common
  /// overnight in calm/clear conditions.
  final InversionKind kind;

  /// Depth of the inversion layer in the caller's length units (meters for
  /// metric, feet for imperial).
  final double depth;

  /// Temperature difference driving the inversion in the caller's temperature
  /// units.
  final double strength;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['kind'] = kind.value;
    out['depth'] = depth;
    out['strength'] = strength;
    return out;
  }
}

InversionInfo _readInversionInfo(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return InversionInfo(
    kind: r.req('kind', enumOf(InversionKind.new)),
    depth: r.req('depth', asDouble),
    strength: r.req('strength', asDouble),
  );
}

/// A named location, as forecasts reference it.
///
/// `state` and `slug` together name it: pass the object itself to `forecast`. A
/// coordinate forecast's location has no `slug` or `type` (both `null`).
final class LocationRef implements NamedLocation {
  /// Creates a [LocationRef].
  LocationRef({
    this.slug,
    required this.state,
    required this.name,
    required this.lat,
    required this.lon,
    required this.elevationM,
    this.type,
    required this.timezone,
  });

  /// Decodes a [LocationRef] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory LocationRef.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readLocationRef);

  /// The location's key: its catalog slug.
  @override
  final String? slug;

  /// The lowercase USPS state code.
  @override
  final String state;

  /// The display name.
  final String name;

  /// The `lat` field.
  final double lat;

  /// The `lon` field.
  final double lon;

  /// Elevation in metres, whatever `units` is (0.1 m).
  final double elevationM;

  /// The primary location type, snake_case.
  final LocationType? type;

  /// The IANA zone the location's local days and hours are kept in -- the zone
  /// `daily` dates, sunrise and sunset are computed in.
  final String timezone;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (slug case final v?) {
      out['slug'] = v;
    }
    out['state'] = state;
    out['name'] = name;
    out['lat'] = lat;
    out['lon'] = lon;
    out['elevation_m'] = elevationM;
    if (type case final v?) {
      out['type'] = v.value;
    }
    out['timezone'] = timezone;
    return out;
  }
}

LocationRef _readLocationRef(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return LocationRef(
    slug: r.opt('slug', asString),
    state: r.req('state', asString),
    name: r.req('name', asString),
    lat: r.req('lat', asDouble),
    lon: r.req('lon', asDouble),
    elevationM: r.req('elevation_m', asDouble),
    type: r.opt('type', enumOf(LocationType.new)),
    timezone: r.req('timezone', asString),
  );
}

/// A row of a location list or of `nearby`.
final class LocationSummary implements NamedLocation {
  /// Creates a [LocationSummary].
  LocationSummary({
    this.slug,
    required this.state,
    required this.name,
    required this.lat,
    required this.lon,
    required this.elevationM,
    this.type,
    required this.timezone,
    required this.county,
    this.description,
    this.elevations,
  });

  /// Decodes a [LocationSummary] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory LocationSummary.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readLocationSummary);

  /// The location's key: its catalog slug.
  @override
  final String? slug;

  /// The lowercase USPS state code.
  @override
  final String state;

  /// The display name.
  final String name;

  /// The `lat` field.
  final double lat;

  /// The `lon` field.
  final double lon;

  /// Elevation in metres, whatever `units` is (0.1 m).
  final double elevationM;

  /// The primary location type, snake_case.
  final LocationType? type;

  /// The IANA zone the location's local days and hours are kept in -- the zone
  /// `daily` dates, sunrise and sunset are computed in.
  final String timezone;

  /// Administrative county.
  final String county;

  /// Free-text blurb from the catalog (when present).
  final String? description;

  /// The location's elevation points (e.g., ski area base / mid / summit), the
  /// primary first.
  final List<ElevationSummary>? elevations;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (slug case final v?) {
      out['slug'] = v;
    }
    out['state'] = state;
    out['name'] = name;
    out['lat'] = lat;
    out['lon'] = lon;
    out['elevation_m'] = elevationM;
    if (type case final v?) {
      out['type'] = v.value;
    }
    out['timezone'] = timezone;
    out['county'] = county;
    if (description case final v?) {
      out['description'] = v;
    }
    if (elevations case final v?) {
      out['elevations'] = [for (final e in v) e.toJson()];
    }
    return out;
  }
}

LocationSummary _readLocationSummary(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return LocationSummary(
    slug: r.opt('slug', asString),
    state: r.req('state', asString),
    name: r.req('name', asString),
    lat: r.req('lat', asDouble),
    lon: r.req('lon', asDouble),
    elevationM: r.req('elevation_m', asDouble),
    type: r.opt('type', enumOf(LocationType.new)),
    timezone: r.req('timezone', asString),
    county: r.req('county', asString),
    description: r.opt('description', asString),
    elevations: r.opt('elevations', listOf(_readElevationSummary)),
  );
}

/// One page of the locations list. `next_cursor` is `null` on the last.
final class LocationsResponse extends Response {
  /// Creates a [LocationsResponse].
  LocationsResponse({
    required this.state,
    required this.count,
    required this.items,
    this.nextCursor,
  });

  /// Decodes a [LocationsResponse] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory LocationsResponse.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readLocationsResponse);

  /// Display label for the scope: `Oregon`, `Washington`, `California` for a
  /// single-state query, or `all` when hitting `/api/v1/locations`.
  final String state;

  /// The `count` field.
  final int count;

  /// (JSON `locations`) A list, `/nearby` or favorite row: the [LocationRef]
  /// fields plus the county, the catalog blurb and the location's named
  /// elevations.
  final List<LocationSummary> items;

  /// Pass it back as `cursor` (with the same `limit` and filters) for the next
  /// page; `null` on the last page.
  final String? nextCursor;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['state'] = state;
    out['count'] = count;
    out['locations'] = [for (final e in items) e.toJson()];
    if (nextCursor case final v?) {
      out['next_cursor'] = v;
    }
    return out;
  }
}

LocationsResponse _readLocationsResponse(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return LocationsResponse(
    state: r.req('state', asString),
    count: r.req('count', asInt),
    items: r.req('locations', listOf(_readLocationSummary)),
    nextCursor: r.opt('next_cursor', asString),
  );
}

/// Present only on a day part of which is a measurement.
///
/// The leading date, when the radar (MRMS radar-only) measured hours between
/// its local midnight and the reference init -- and absent otherwise.
final class MeasuredPrecipitation {
  /// Creates a [MeasuredPrecipitation].
  MeasuredPrecipitation({
    required this.amount,
    required this.through,
  });

  /// Decodes a [MeasuredPrecipitation] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory MeasuredPrecipitation.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readMeasuredPrecipitation);

  /// The `amount` field.
  final double amount;

  /// The `through` field.
  final DateTime through;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['amount'] = amount;
    out['through'] = formatDateTime(through);
    return out;
  }
}

MeasuredPrecipitation _readMeasuredPrecipitation(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return MeasuredPrecipitation(
    amount: r.req('amount', asDouble),
    through: r.req('through', asDateTime),
  );
}

/// One ensemble member's values at an hour (`members=true`).
final class MemberForecast {
  /// Creates a [MemberForecast].
  MemberForecast({
    required this.id,
    this.temperature,
    this.precipitation,
    this.precipitationHours,
    this.windSpeed,
    this.windDirection,
    this.snowLevel,
    this.snowLevelWetBulb,
    this.slr,
    this.snowfall,
    this.cumulativePrecipitation,
    this.cumulativeSnowfall,
  });

  /// Decodes a [MemberForecast] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory MemberForecast.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readMemberForecast);

  /// (JSON `member_id`) The member's position on its model's ensemble axis,
  /// from 0: stable across the hours of a response and across cycles, and
  /// numbered per model (a member is `(model, member_id)`).
  final int id;

  /// `null` when this member published nothing at this hour.
  final double? temperature;

  /// `null` when this member published nothing at this hour.
  final double? precipitation;

  /// How many hours `precipitation` (and `snowfall`) covers, ending at this
  /// hour: back to this model's previous precipitation step (1 for an hourly
  /// model, 6 for a 6-hourly one).
  final int? precipitationHours;

  /// `null` when this member published nothing at this hour.
  final double? windSpeed;

  /// As `wind_speed`, absent in the plume view.
  final double? windDirection;

  /// This member's rain line (the bottom of its melting layer; see
  /// `EnsembleStats.snow_level`), held to the lowest level its own surface
  /// wet-bulb allows.
  final double? snowLevel;

  /// This member's snow level on the NWS scale (the height of the 0.5 C
  /// wet-bulb; see `EnsembleStats.snow_level_wet_bulb`): its `snow_level`
  /// raised by the same fixed 275 m (901 ft), a level at `0` (snow to sea
  /// level) left at `0`.
  final double? snowLevelWetBulb;

  /// Snow-to-liquid ratio for this member (unitless), in both views.
  final double? slr;

  /// Per-member snowfall depth at the location's elevation, computed as
  /// `precipitation × effective_slr(slr, elevation, snow_level)`.
  final double? snowfall;

  /// This member's running precipitation total (mm / in) from the start of the
  /// served window through this hour -- the sum of its `precipitation` over
  /// every served hour up to here.
  final double? cumulativePrecipitation;

  /// This member's running snowfall total (mm / in), by the same window and
  /// share rule as `cumulative_precipitation` over its `snowfall`.
  final double? cumulativeSnowfall;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['member_id'] = id;
    if (temperature case final v?) {
      out['temperature'] = v;
    }
    if (precipitation case final v?) {
      out['precipitation'] = v;
    }
    if (precipitationHours case final v?) {
      out['precipitation_hours'] = v;
    }
    if (windSpeed case final v?) {
      out['wind_speed'] = v;
    }
    if (windDirection case final v?) {
      out['wind_direction'] = v;
    }
    if (snowLevel case final v?) {
      out['snow_level'] = v;
    }
    if (snowLevelWetBulb case final v?) {
      out['snow_level_wet_bulb'] = v;
    }
    if (slr case final v?) {
      out['slr'] = v;
    }
    if (snowfall case final v?) {
      out['snowfall'] = v;
    }
    if (cumulativePrecipitation case final v?) {
      out['cumulative_precipitation'] = v;
    }
    if (cumulativeSnowfall case final v?) {
      out['cumulative_snowfall'] = v;
    }
    return out;
  }
}

MemberForecast _readMemberForecast(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return MemberForecast(
    id: r.req('member_id', asInt),
    temperature: r.opt('temperature', asDouble),
    precipitation: r.opt('precipitation', asDouble),
    precipitationHours: r.opt('precipitation_hours', asInt),
    windSpeed: r.opt('wind_speed', asDouble),
    windDirection: r.opt('wind_direction', asDouble),
    snowLevel: r.opt('snow_level', asDouble),
    snowLevelWetBulb: r.opt('snow_level_wet_bulb', asDouble),
    slr: r.opt('slr', asDouble),
    snowfall: r.opt('snowfall', asDouble),
    cumulativePrecipitation: r.opt('cumulative_precipitation', asDouble),
    cumulativeSnowfall: r.opt('cumulative_snowfall', asDouble),
  );
}

/// One model's members at an hour.
final class MemberGroup {
  /// Creates a [MemberGroup].
  MemberGroup({
    required this.id,
    required this.items,
  });

  /// Decodes a [MemberGroup] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory MemberGroup.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readMemberGroup);

  /// The `id` field.
  final String id;

  /// (JSON `members`)
  final List<MemberForecast> items;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['id'] = id;
    out['members'] = [for (final e in items) e.toJson()];
    return out;
  }
}

MemberGroup _readMemberGroup(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return MemberGroup(
    id: r.req('id', asString),
    items: r.req('members', listOf(_readMemberForecast)),
  );
}

/// One served series' members in columns (`members=plume`).
final class MemberPlume {
  /// Creates a [MemberPlume].
  MemberPlume({
    required this.headline,
    required this.bands,
    required this.models,
    this.pool,
  });

  /// Decodes a [MemberPlume] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory MemberPlume.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readMemberPlume);

  /// The lines a plume draws over its members, at every served hour
  /// (`valid_time`): the blend's `temperature` and `snow_level` means
  /// (`ensemble.*.mean`) and its running totals (`cumulative_precipitation`,
  /// `cumulative_snowfall`: the "Ourea forecast" line), and that snowfall line
  /// at a 10:1 snow-to-liquid ratio (`cumulative_snowfall_10to1`), and its
  /// `wind_speed` mean and its snowfall in each 6 hours (`snowfall_6h`).
  final PlumeHeadline headline;

  /// The members' distributions, at the served hours that carry at least one
  /// (`valid_time`; the synoptic hours in practice): `cumulative_precipitation`
  /// / `cumulative_snowfall` are the row form's `members_cumulative` (the
  /// spread of the members' running totals, never a sum of hourly percentiles),
  /// `temperature` / `snow_level` its `members_spread`, `precipitation_6h` /
  /// `snowfall_6h` its `members_6h` (6-hour totals ending at a 00/06/12/18Z
  /// hour), `slr` its `members_spread.slr` (the key is absent when no hour
  /// carries it), and `cumulative_snowfall_10to1` the spread of the members'
  /// running snowfall at 10:1.
  final PlumeBands bands;

  /// One entry per model with members in the served window, in the order aifs,
  /// aigefs, gefs, ifs_ens, rrfs.
  final List<ModelColumns> models;

  /// (JSON `members`) The members as ONE unlabelled pool, for a caller without
  /// the plume's paid detail (Free and anonymous; `members_view: pool`).
  final PooledColumns? pool;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['headline'] = headline.toJson();
    out['bands'] = bands.toJson();
    out['models'] = [for (final e in models) e.toJson()];
    if (pool case final v?) {
      out['members'] = v.toJson();
    }
    return out;
  }
}

MemberPlume _readMemberPlume(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return MemberPlume(
    headline: r.req('headline', _readPlumeHeadline),
    bands: r.req('bands', _readPlumeBands),
    models: r.req('models', listOf(_readModelColumns)),
    pool: r.opt('members', _readPooledColumns),
  );
}

/// A distribution over the ensemble MEMBERS.
///
/// (`members_cumulative`, `members_spread`, `members_6h`): the `Quantiles`
/// shape.
final class MemberQuantiles with QuantileViews {
  /// Creates a [MemberQuantiles].
  MemberQuantiles({
    this.mean,
    this.p10,
    this.p25,
    this.p50,
    this.p75,
    this.p90,
    this.min,
    this.max,
    this.probability,
  });

  /// Decodes a [MemberQuantiles] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory MemberQuantiles.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readMemberQuantiles);

  /// The `mean` field.
  final double? mean;

  /// The `p10` field.
  @override
  final double? p10;

  /// The `p25` field.
  @override
  final double? p25;

  /// The members' median.
  @override
  final double? p50;

  /// The `p75` field.
  @override
  final double? p75;

  /// The `p90` field.
  @override
  final double? p90;

  /// The `min` field.
  final double? min;

  /// The `max` field.
  final double? max;

  /// As `Quantiles.probability`, where the use says.
  final double? probability;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (mean case final v?) {
      out['mean'] = v;
    }
    if (p10 case final v?) {
      out['p10'] = v;
    }
    if (p25 case final v?) {
      out['p25'] = v;
    }
    if (p50 case final v?) {
      out['p50'] = v;
    }
    if (p75 case final v?) {
      out['p75'] = v;
    }
    if (p90 case final v?) {
      out['p90'] = v;
    }
    if (min case final v?) {
      out['min'] = v;
    }
    if (max case final v?) {
      out['max'] = v;
    }
    if (probability case final v?) {
      out['probability'] = v;
    }
    return out;
  }
}

MemberQuantiles _readMemberQuantiles(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return MemberQuantiles(
    mean: r.opt('mean', asDouble),
    p10: r.opt('p10', asDouble),
    p25: r.opt('p25', asDouble),
    p50: r.opt('p50', asDouble),
    p75: r.opt('p75', asDouble),
    p90: r.opt('p90', asDouble),
    min: r.opt('min', asDouble),
    max: r.opt('max', asDouble),
    probability: r.opt('probability', asDouble),
  );
}

/// The distribution of the members' running totals at an hour.
final class MembersCumulative {
  /// Creates a [MembersCumulative].
  MembersCumulative({
    this.precipitation,
    this.snowfall,
  });

  /// Decodes a [MembersCumulative] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory MembersCumulative.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readMembersCumulative);

  /// A distribution over the ensemble MEMBERS (`members_cumulative`,
  /// `members_spread`, `members_6h`): the `Quantiles` shape.
  final MemberQuantiles? precipitation;

  /// A distribution over the ensemble MEMBERS (`members_cumulative`,
  /// `members_spread`, `members_6h`): the `Quantiles` shape.
  final MemberQuantiles? snowfall;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (precipitation case final v?) {
      out['precipitation'] = v.toJson();
    }
    if (snowfall case final v?) {
      out['snowfall'] = v.toJson();
    }
    return out;
  }
}

MembersCumulative _readMembersCumulative(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return MembersCumulative(
    precipitation: r.opt('precipitation', _readMemberQuantiles),
    snowfall: r.opt('snowfall', _readMemberQuantiles),
  );
}

/// The members' spread at this hour for the plume's instantaneous variables.
///
/// The Quantiles of every member's own `temperature` (temperature unit) and
/// `snow_level` (length unit) here, over the members as served.
final class MembersSpread {
  /// Creates a [MembersSpread].
  MembersSpread({
    this.temperature,
    this.snowLevel,
    this.snowLevelWetBulb,
    this.slr,
    this.windSpeed,
  });

  /// Decodes a [MembersSpread] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory MembersSpread.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readMembersSpread);

  /// A distribution over the ensemble MEMBERS (`members_cumulative`,
  /// `members_spread`, `members_6h`): the `Quantiles` shape.
  final MemberQuantiles? temperature;

  /// A distribution over the ensemble MEMBERS (`members_cumulative`,
  /// `members_spread`, `members_6h`): the `Quantiles` shape.
  final MemberQuantiles? snowLevel;

  /// The Quantiles of the members' own `snow_level_wet_bulb` (the snow level on
  /// the NWS scale), over the members `snow_level` is over.
  final MemberQuantiles? snowLevelWetBulb;

  /// The snow-to-liquid ratio over the members SNOWING at this hour (their own
  /// `snowfall` above 0), at 00/06/12/18Z only, in both member views.
  final MemberQuantiles? slr;

  /// The members' own wind speed at this hour, in the wind unit.
  final MemberQuantiles? windSpeed;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (temperature case final v?) {
      out['temperature'] = v.toJson();
    }
    if (snowLevel case final v?) {
      out['snow_level'] = v.toJson();
    }
    if (snowLevelWetBulb case final v?) {
      out['snow_level_wet_bulb'] = v.toJson();
    }
    if (slr case final v?) {
      out['slr'] = v.toJson();
    }
    if (windSpeed case final v?) {
      out['wind_speed'] = v.toJson();
    }
    return out;
  }
}

MembersSpread _readMembersSpread(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return MembersSpread(
    temperature: r.opt('temperature', _readMemberQuantiles),
    snowLevel: r.opt('snow_level', _readMemberQuantiles),
    snowLevelWetBulb: r.opt('snow_level_wet_bulb', _readMemberQuantiles),
    slr: r.opt('slr', _readMemberQuantiles),
    windSpeed: r.opt('wind_speed', _readMemberQuantiles),
  );
}

/// One model's members over its NATIVE steps inside the served window
/// (`valid_time`.
///
/// The hours at which a member of the model carries a value -- every hour for
/// RRFS, every sixth for the global ensembles; never padded to the hourly
/// series).
final class ModelColumns {
  /// Creates a [ModelColumns].
  ModelColumns({
    required this.id,
    required this.validTime,
    required this.memberIds,
    required this.temperature,
    required this.precipitation,
    required this.precipitationHours,
    required this.cumulativePrecipitation,
    required this.snowLevel,
    required this.snowLevelWetBulb,
    required this.snowfall,
    required this.cumulativeSnowfall,
    required this.cumulativeSnowfallP50,
    required this.cumulativeSnowfall10to1P50,
    required this.temperatureMean,
    required this.precipitationMean,
    required this.cumulativePrecipitationMean,
    required this.snowLevelMean,
    required this.snowLevelWetBulbMean,
    required this.snowfallMean,
    required this.cumulativeSnowfallMean,
    required this.cumulativeSnowfall10to1Mean,
    this.windSpeedMean,
    required this.cumulativePrecipitationBandMemberIds,
    required this.cumulativeSnowfallBandMemberIds,
    required this.cumulativeSnowfall10to1BandMemberIds,
    this.windSpeed,
    this.windDirection,
    this.slr,
  });

  /// Decodes a [ModelColumns] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ModelColumns.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readModelColumns);

  /// The `id` field.
  final String id;

  /// The `valid_time` field.
  final List<DateTime> validTime;

  /// The members, ascending (`MemberForecast.member_id`).
  final List<int> memberIds;

  /// `[member][step]`: one array per member (`member_ids` order) over the
  /// model's `valid_time`; `null` = no value at that step.
  final List<List<double?>> temperature;

  /// `[member][step]`: one array per member (`member_ids` order) over the
  /// model's `valid_time`; `null` = no value at that step.
  final List<List<double?>> precipitation;

  /// `[member][step]`: the hours each `precipitation` value covers; `null`
  /// where it is absent or its span unknown.
  final List<List<int?>> precipitationHours;

  /// `[member][step]`: one array per member (`member_ids` order) over the
  /// model's `valid_time`; `null` = no value at that step.
  final List<List<double?>> cumulativePrecipitation;

  /// `[member][step]`: one array per member (`member_ids` order) over the
  /// model's `valid_time`; `null` = no value at that step.
  final List<List<double?>> snowLevel;

  /// `[Member][step]`, each member's `MemberForecast.snow_level_wet_bulb` (the
  /// snow level on the NWS scale); `null` exactly where its `snow_level` is.
  final List<List<double?>> snowLevelWetBulb;

  /// `[member][step]`: one array per member (`member_ids` order) over the
  /// model's `valid_time`; `null` = no value at that step.
  final List<List<double?>> snowfall;

  /// `[member][step]`: one array per member (`member_ids` order) over the
  /// model's `valid_time`; `null` = no value at that step.
  final List<List<double?>> cumulativeSnowfall;

  /// One value per `valid_time` step (not per member): the median of the
  /// model's members' `cumulative_snowfall` there (Hyndman-Fan type 7, as
  /// `bands`: the middle value, or the midpoint of the two middle ones; a
  /// single-member model's own total), ...
  final List<double?> cumulativeSnowfallP50;

  /// As `cumulative_snowfall_p50`, over the members' running snowfall at 10:1
  /// (see `PlumeBands.cumulative_snowfall_10to1`).
  final List<double?> cumulativeSnowfall10to1P50;

  /// The model's mean lines.
  final List<double?> temperatureMean;

  /// The mean of `precipitation` (see `temperature_mean`).
  final List<double?> precipitationMean;

  /// The mean of `cumulative_precipitation` (see `temperature_mean`).
  final List<double?> cumulativePrecipitationMean;

  /// The mean of `snow_level` (see `temperature_mean`).
  final List<double?> snowLevelMean;

  /// The mean of `snow_level_wet_bulb` (see `temperature_mean`).
  final List<double?> snowLevelWetBulbMean;

  /// The mean of `snowfall` (see `temperature_mean`).
  final List<double?> snowfallMean;

  /// The mean of `cumulative_snowfall` (see `temperature_mean`), beside its
  /// median `cumulative_snowfall_p50`.
  final List<double?> cumulativeSnowfallMean;

  /// The mean of the members' running snowfall at 10:1, beside
  /// `cumulative_snowfall_10to1_p50` (the members' 10:1 column itself is not
  /// served).
  final List<double?> cumulativeSnowfall10to1Mean;

  /// The mean of `wind_speed` (see `temperature_mean`).
  final List<double?>? windSpeedMean;

  /// Which of this model's `member_ids` are in
  /// `bands.cumulative_precipitation`, ascending.
  final List<int> cumulativePrecipitationBandMemberIds;

  /// As `cumulative_precipitation_band_member_ids`, for
  /// `bands.cumulative_snowfall`.
  final List<int> cumulativeSnowfallBandMemberIds;

  /// As `cumulative_precipitation_band_member_ids`, for
  /// `bands.cumulative_snowfall_10to1`.
  final List<int> cumulativeSnowfall10to1BandMemberIds;

  /// Pro (`members_view: full`) only; absent in the plume view.
  final List<List<double?>>? windSpeed;

  /// Pro only; absent in the plume view.
  final List<List<double?>>? windDirection;

  /// In both views.
  final List<List<double?>>? slr;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['id'] = id;
    out['valid_time'] = [for (final e in validTime) formatDateTime(e)];
    out['member_ids'] = memberIds;
    out['temperature'] = temperature;
    out['precipitation'] = precipitation;
    out['precipitation_hours'] = precipitationHours;
    out['cumulative_precipitation'] = cumulativePrecipitation;
    out['snow_level'] = snowLevel;
    out['snow_level_wet_bulb'] = snowLevelWetBulb;
    out['snowfall'] = snowfall;
    out['cumulative_snowfall'] = cumulativeSnowfall;
    out['cumulative_snowfall_p50'] = cumulativeSnowfallP50;
    out['cumulative_snowfall_10to1_p50'] = cumulativeSnowfall10to1P50;
    out['temperature_mean'] = temperatureMean;
    out['precipitation_mean'] = precipitationMean;
    out['cumulative_precipitation_mean'] = cumulativePrecipitationMean;
    out['snow_level_mean'] = snowLevelMean;
    out['snow_level_wet_bulb_mean'] = snowLevelWetBulbMean;
    out['snowfall_mean'] = snowfallMean;
    out['cumulative_snowfall_mean'] = cumulativeSnowfallMean;
    out['cumulative_snowfall_10to1_mean'] = cumulativeSnowfall10to1Mean;
    if (windSpeedMean case final v?) {
      out['wind_speed_mean'] = v;
    }
    out['cumulative_precipitation_band_member_ids'] =
        cumulativePrecipitationBandMemberIds;
    out['cumulative_snowfall_band_member_ids'] =
        cumulativeSnowfallBandMemberIds;
    out['cumulative_snowfall_10to1_band_member_ids'] =
        cumulativeSnowfall10to1BandMemberIds;
    if (windSpeed case final v?) {
      out['wind_speed'] = v;
    }
    if (windDirection case final v?) {
      out['wind_direction'] = v;
    }
    if (slr case final v?) {
      out['slr'] = v;
    }
    return out;
  }
}

ModelColumns _readModelColumns(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ModelColumns(
    id: r.req('id', asString),
    validTime: r.req('valid_time', listOf(asDateTime)),
    memberIds: r.req('member_ids', listOf(asInt)),
    temperature: r.req('temperature', listOf(listOf(nullableOf(asDouble)))),
    precipitation: r.req('precipitation', listOf(listOf(nullableOf(asDouble)))),
    precipitationHours:
        r.req('precipitation_hours', listOf(listOf(nullableOf(asInt)))),
    cumulativePrecipitation:
        r.req('cumulative_precipitation', listOf(listOf(nullableOf(asDouble)))),
    snowLevel: r.req('snow_level', listOf(listOf(nullableOf(asDouble)))),
    snowLevelWetBulb:
        r.req('snow_level_wet_bulb', listOf(listOf(nullableOf(asDouble)))),
    snowfall: r.req('snowfall', listOf(listOf(nullableOf(asDouble)))),
    cumulativeSnowfall:
        r.req('cumulative_snowfall', listOf(listOf(nullableOf(asDouble)))),
    cumulativeSnowfallP50:
        r.req('cumulative_snowfall_p50', listOf(nullableOf(asDouble))),
    cumulativeSnowfall10to1P50:
        r.req('cumulative_snowfall_10to1_p50', listOf(nullableOf(asDouble))),
    temperatureMean: r.req('temperature_mean', listOf(nullableOf(asDouble))),
    precipitationMean:
        r.req('precipitation_mean', listOf(nullableOf(asDouble))),
    cumulativePrecipitationMean:
        r.req('cumulative_precipitation_mean', listOf(nullableOf(asDouble))),
    snowLevelMean: r.req('snow_level_mean', listOf(nullableOf(asDouble))),
    snowLevelWetBulbMean:
        r.req('snow_level_wet_bulb_mean', listOf(nullableOf(asDouble))),
    snowfallMean: r.req('snowfall_mean', listOf(nullableOf(asDouble))),
    cumulativeSnowfallMean:
        r.req('cumulative_snowfall_mean', listOf(nullableOf(asDouble))),
    cumulativeSnowfall10to1Mean:
        r.req('cumulative_snowfall_10to1_mean', listOf(nullableOf(asDouble))),
    windSpeedMean: r.opt('wind_speed_mean', listOf(nullableOf(asDouble))),
    cumulativePrecipitationBandMemberIds:
        r.req('cumulative_precipitation_band_member_ids', listOf(asInt)),
    cumulativeSnowfallBandMemberIds:
        r.req('cumulative_snowfall_band_member_ids', listOf(asInt)),
    cumulativeSnowfall10to1BandMemberIds:
        r.req('cumulative_snowfall_10to1_band_member_ids', listOf(asInt)),
    windSpeed: r.opt('wind_speed', listOf(listOf(nullableOf(asDouble)))),
    windDirection:
        r.opt('wind_direction', listOf(listOf(nullableOf(asDouble)))),
    slr: r.opt('slr', listOf(listOf(nullableOf(asDouble)))),
  );
}

/// One contributing model and its own cycle.
final class ModelEntry {
  /// Creates a [ModelEntry].
  ModelEntry({
    required this.id,
    this.cycle,
    this.members,
    this.displayMembers,
    this.displayMembersSnowfall,
  });

  /// Decodes a [ModelEntry] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ModelEntry.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readModelEntry);

  /// The model id (`aifs`, `aigefs`, `gefs`, `ifs_ens`, `rrfs`; treat others as
  /// additive).
  final String id;

  /// The model's own cycle init (per-model-latest).
  final DateTime? cycle;

  /// How many of its members the forecast carries (in `model_run`): the members
  /// served at each of its steps in the plume, and the ensemble its statistics
  /// and probabilities are taken over -- GEFS is 31, the control and 30
  /// perturbed members.
  final int? members;

  /// Display-only members (plumes and charts), not in the blend.
  final List<int>? displayMembers;

  /// `borrowed_from_deterministic` when the display members' snowfall is
  /// borrowed.
  final String? displayMembersSnowfall;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['id'] = id;
    if (cycle case final v?) {
      out['cycle'] = formatDateTime(v);
    }
    if (members case final v?) {
      out['members'] = v;
    }
    if (displayMembers case final v?) {
      out['display_members'] = v;
    }
    if (displayMembersSnowfall case final v?) {
      out['display_members_snowfall'] = v;
    }
    return out;
  }
}

ModelEntry _readModelEntry(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ModelEntry(
    id: r.req('id', asString),
    cycle: r.opt('cycle', asDateTime),
    members: r.opt('members', asInt),
    displayMembers: r.opt('display_members', listOf(asInt)),
    displayMembersSnowfall: r.opt('display_members_snowfall', asString),
  );
}

/// The model run a forecast was built from.
final class ModelRunInfo {
  /// Creates a [ModelRunInfo].
  ModelRunInfo({
    required this.initializedAt,
    required this.totalMembers,
    required this.models,
  });

  /// Decodes a [ModelRunInfo] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ModelRunInfo.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readModelRunInfo);

  /// The reference init: the NEWEST contributing model's cycle.
  final DateTime initializedAt;

  /// The sum of `models[].members`.
  final int totalMembers;

  /// One entry per contributing model, in the order `aifs`, `aigefs`, `gefs`,
  /// `ifs_ens`, `rrfs` (a model added later follows, by id): a new model is a
  /// new element, never a new key.
  final List<ModelEntry> models;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['initialized_at'] = formatDateTime(initializedAt);
    out['total_members'] = totalMembers;
    out['models'] = [for (final e in models) e.toJson()];
    return out;
  }
}

ModelRunInfo _readModelRunInfo(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ModelRunInfo(
    initializedAt: r.req('initialized_at', asDateTime),
    totalMembers: r.req('total_members', asInt),
    models: r.req('models', listOf(_readModelEntry)),
  );
}

/// One model's statistics at an hour (`models=true`).
final class ModelStats {
  /// Creates a [ModelStats].
  ModelStats({
    required this.id,
    this.temperature,
    this.dewpoint,
    this.precipitation,
    this.windSpeed,
    this.windDirection,
    this.snowLevel,
    this.snowLevelWetBulb,
    this.slr,
    this.snowfall,
    this.interpolated,
  });

  /// Decodes a [ModelStats] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ModelStats.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readModelStats);

  /// The `id` field.
  final String id;

  /// Absent when this model published nothing for the hour; never 0.
  final Quantiles? temperature;

  /// Always absent for `aigefs`, which publishes no 2 m humidity and no surface
  /// pressure: the blended dewpoint, relative humidity and feels-like are
  /// pooled from the models that publish one, their weights renormalised over
  /// them.
  final Quantiles? dewpoint;

  /// Absent when this model published nothing for the hour; never 0.
  final Quantiles? precipitation;

  /// Absent when this model published nothing for the hour; never 0.
  final Quantiles? windSpeed;

  /// Absent when this model published nothing for the hour.
  final CircularStats? windDirection;

  /// The model's own rain line (the bottom of the melting layer; see
  /// `EnsembleStats.snow_level`), as its members give it.
  final Quantiles? snowLevel;

  /// The model's own snow level on the NWS scale (the height of the 0.5 C
  /// wet-bulb), as `EnsembleStats.snow_level_wet_bulb` is the blend's: its
  /// `snow_level` with every quantile raised by 275 m (901 ft), a quantile at
  /// `0` left at `0`.
  final Quantiles? snowLevelWetBulb;

  /// THE distribution shape -- every ensemble statistic the API serves (hourly
  /// `ensemble.*`, per-model `model_means[].*`, the daily
  /// `high`/`low`/`total_*`/`feels_like_*`, the plume's `members_cumulative`,
  /// `?totals=` windows, `snow_outlook.quantiles` windows, the daily
  /// `snow_level` and `*_if_wet`) is this one object, in the request's units.
  final Quantiles? slr;

  /// THE distribution shape -- every ensemble statistic the API serves (hourly
  /// `ensemble.*`, per-model `model_means[].*`, the daily
  /// `high`/`low`/`total_*`/`feels_like_*`, the plume's `members_cumulative`,
  /// `?totals=` windows, `snow_outlook.quantiles` windows, the daily
  /// `snow_level` and `*_if_wet`) is this one object, in the request's units.
  final Quantiles? snowfall;

  /// `true` when this model did not publish at this lead and the stats above
  /// were interpolated from its two bracketing native steps, so the blend pools
  /// the same set of contributors at every lead.
  final bool? interpolated;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['id'] = id;
    if (temperature case final v?) {
      out['temperature'] = v.toJson();
    }
    if (dewpoint case final v?) {
      out['dewpoint'] = v.toJson();
    }
    if (precipitation case final v?) {
      out['precipitation'] = v.toJson();
    }
    if (windSpeed case final v?) {
      out['wind_speed'] = v.toJson();
    }
    if (windDirection case final v?) {
      out['wind_direction'] = v.toJson();
    }
    if (snowLevel case final v?) {
      out['snow_level'] = v.toJson();
    }
    if (snowLevelWetBulb case final v?) {
      out['snow_level_wet_bulb'] = v.toJson();
    }
    if (slr case final v?) {
      out['slr'] = v.toJson();
    }
    if (snowfall case final v?) {
      out['snowfall'] = v.toJson();
    }
    if (interpolated case final v?) {
      out['interpolated'] = v;
    }
    return out;
  }
}

ModelStats _readModelStats(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ModelStats(
    id: r.req('id', asString),
    temperature: r.opt('temperature', _readQuantiles),
    dewpoint: r.opt('dewpoint', _readQuantiles),
    precipitation: r.opt('precipitation', _readQuantiles),
    windSpeed: r.opt('wind_speed', _readQuantiles),
    windDirection: r.opt('wind_direction', _readCircularStats),
    snowLevel: r.opt('snow_level', _readQuantiles),
    snowLevelWetBulb: r.opt('snow_level_wet_bulb', _readQuantiles),
    slr: r.opt('slr', _readQuantiles),
    snowfall: r.opt('snowfall', _readQuantiles),
    interpolated: r.opt('interpolated', asBool),
  );
}

/// A nearby location and its distance.
final class NearbyLocation implements NamedLocation {
  /// Creates a [NearbyLocation].
  NearbyLocation({
    this.slug,
    required this.state,
    required this.name,
    required this.lat,
    required this.lon,
    required this.elevationM,
    this.type,
    required this.timezone,
    required this.county,
    this.description,
    this.elevations,
    required this.distanceKm,
  });

  /// Decodes a [NearbyLocation] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory NearbyLocation.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readNearbyLocation);

  /// The location's key: its catalog slug.
  @override
  final String? slug;

  /// The lowercase USPS state code.
  @override
  final String state;

  /// The display name.
  final String name;

  /// The `lat` field.
  final double lat;

  /// The `lon` field.
  final double lon;

  /// Elevation in metres, whatever `units` is (0.1 m).
  final double elevationM;

  /// The primary location type, snake_case.
  final LocationType? type;

  /// The IANA zone the location's local days and hours are kept in -- the zone
  /// `daily` dates, sunrise and sunset are computed in.
  final String timezone;

  /// Administrative county.
  final String county;

  /// Free-text blurb from the catalog (when present).
  final String? description;

  /// The location's elevation points (e.g., ski area base / mid / summit), the
  /// primary first.
  final List<ElevationSummary>? elevations;

  /// Great-circle distance from the location, km.
  final double distanceKm;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (slug case final v?) {
      out['slug'] = v;
    }
    out['state'] = state;
    out['name'] = name;
    out['lat'] = lat;
    out['lon'] = lon;
    out['elevation_m'] = elevationM;
    if (type case final v?) {
      out['type'] = v.value;
    }
    out['timezone'] = timezone;
    out['county'] = county;
    if (description case final v?) {
      out['description'] = v;
    }
    if (elevations case final v?) {
      out['elevations'] = [for (final e in v) e.toJson()];
    }
    out['distance_km'] = distanceKm;
    return out;
  }
}

NearbyLocation _readNearbyLocation(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return NearbyLocation(
    slug: r.opt('slug', asString),
    state: r.req('state', asString),
    name: r.req('name', asString),
    lat: r.req('lat', asDouble),
    lon: r.req('lon', asDouble),
    elevationM: r.req('elevation_m', asDouble),
    type: r.opt('type', enumOf(LocationType.new)),
    timezone: r.req('timezone', asString),
    county: r.req('county', asString),
    description: r.opt('description', asString),
    elevations: r.opt('elevations', listOf(_readElevationSummary)),
    distanceKm: r.req('distance_km', asDouble),
  );
}

/// Locations near a named location.
final class NearbyLocationsResponse extends Response {
  /// Creates a [NearbyLocationsResponse].
  NearbyLocationsResponse({
    required this.origin,
    required this.radiusKm,
    required this.count,
    required this.items,
  });

  /// Decodes a [NearbyLocationsResponse] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory NearbyLocationsResponse.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readNearbyLocationsResponse);

  /// (JSON `location`) A list, `/nearby` or favorite row: the [LocationRef]
  /// fields plus the county, the catalog blurb and the location's named
  /// elevations.
  final LocationSummary origin;

  /// The radius applied, after the cap.
  final double radiusKm;

  /// Neighbours in this response (the location itself is not counted).
  final int count;

  /// (JSON `locations`) Nearest first.
  final List<NearbyLocation> items;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['location'] = origin.toJson();
    out['radius_km'] = radiusKm;
    out['count'] = count;
    out['locations'] = [for (final e in items) e.toJson()];
    return out;
  }
}

NearbyLocationsResponse _readNearbyLocationsResponse(
    Object? value, String path) {
  final r = JsonReader.of(value, path);
  return NearbyLocationsResponse(
    origin: r.req('location', _readLocationSummary),
    radiusKm: r.req('radius_km', asDouble),
    count: r.req('count', asInt),
    items: r.req('locations', listOf(_readNearbyLocation)),
  );
}

/// Locations near a coordinate.
final class NearbyPointResponse extends Response {
  /// Creates a [NearbyPointResponse].
  NearbyPointResponse({
    required this.lat,
    required this.lon,
    required this.radiusKm,
    required this.count,
    required this.items,
  });

  /// Decodes a [NearbyPointResponse] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory NearbyPointResponse.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readNearbyPointResponse);

  /// The `lat` field.
  final double lat;

  /// The `lon` field.
  final double lon;

  /// The `radius_km` field.
  final double radiusKm;

  /// The `count` field.
  final int count;

  /// (JSON `locations`)
  final List<NearbyLocation> items;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['lat'] = lat;
    out['lon'] = lon;
    out['radius_km'] = radiusKm;
    out['count'] = count;
    out['locations'] = [for (final e in items) e.toJson()];
    return out;
  }
}

NearbyPointResponse _readNearbyPointResponse(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return NearbyPointResponse(
    lat: r.req('lat', asDouble),
    lon: r.req('lon', asDouble),
    radiusKm: r.req('radius_km', asDouble),
    count: r.req('count', asInt),
    items: r.req('locations', listOf(_readNearbyLocation)),
  );
}

/// A named location near a refused coordinate, answered without a key.
///
/// Carried by `PermissionDeniedError` on a `PRO_REQUIRED` coordinate request,
/// when one is within 10 km and 300 m of elevation. Pass `slug` with the state
/// from `url` to `forecast`.
final class NearestLocation {
  /// Creates a [NearestLocation].
  NearestLocation({
    required this.slug,
    required this.url,
    required this.distanceKm,
    required this.elevationM,
  });

  /// Decodes a [NearestLocation] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory NearestLocation.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readNearestLocation);

  /// The location's slug.
  final String slug;

  /// The location route's path on this API.
  final String url;

  /// Its distance from the requested point.
  final double distanceKm;

  /// Its elevation, metres.
  final double elevationM;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['slug'] = slug;
    out['url'] = url;
    out['distance_km'] = distanceKm;
    out['elevation_m'] = elevationM;
    return out;
  }
}

NearestLocation _readNearestLocation(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return NearestLocation(
    slug: r.req('slug', asString),
    url: r.req('url', asString),
    distanceKm: r.req('distance_km', asDouble),
    elevationM: r.req('elevation_m', asDouble),
  );
}

/// An observing station used by the nowcast blend.
final class NearestSensor {
  /// Creates a [NearestSensor].
  NearestSensor({
    required this.stationId,
    required this.name,
    required this.source,
    required this.distanceKm,
    required this.elevationDiff,
    required this.effectiveDistanceKm,
    required this.observationTime,
  });

  /// Decodes a [NearestSensor] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory NearestSensor.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readNearestSensor);

  /// -- the station's id in its network.
  final String stationId;

  /// -- the station's name from the stations registry, else its id.
  final String name;

  /// Observation network (snotel, nws, raws, rwis, cdec, tempest, etc.)
  final String source;

  /// Straight-line surface distance in km.
  final double distanceKm;

  /// Sensor elevation minus forecast-location elevation, in the caller's length
  /// units (m metric, ft imperial).
  final double elevationDiff;

  /// `distance_km + |elevation_diff_m| / 100`.
  final double effectiveDistanceKm;

  /// The `observation_time` field.
  final DateTime observationTime;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['station_id'] = stationId;
    out['name'] = name;
    out['source'] = source;
    out['distance_km'] = distanceKm;
    out['elevation_diff'] = elevationDiff;
    out['effective_distance_km'] = effectiveDistanceKm;
    out['observation_time'] = formatDateTime(observationTime);
    return out;
  }
}

NearestSensor _readNearestSensor(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return NearestSensor(
    stationId: r.req('station_id', asString),
    name: r.req('name', asString),
    source: r.req('source', asString),
    distanceKm: r.req('distance_km', asDouble),
    elevationDiff: r.req('elevation_diff', asDouble),
    effectiveDistanceKm: r.req('effective_distance_km', asDouble),
    observationTime: r.req('observation_time', asDateTime),
  );
}

/// One DOT camera, a still image the DOT refreshes about once a minute.
final class PassCamera {
  /// Creates a [PassCamera].
  PassCamera({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.url,
    this.capturedAt,
    required this.stale,
    required this.source,
    required this.attribution,
  });

  /// Decodes a [PassCamera] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PassCamera.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPassCamera);

  /// The `id` field.
  final String id;

  /// The DOT's name for the camera.
  final String title;

  /// The DOT's current still image.
  final String imageUrl;

  /// The DOT's own page for the camera, to link out to.
  final String url;

  /// The image's time (its Last-Modified) when Ourea last checked it, every 15
  /// minutes; the image at `image_url` may be newer.
  final DateTime? capturedAt;

  /// `captured_at` is unknown or more than 60 minutes before `as_of`: the
  /// camera may be frozen.
  final bool stale;

  /// The `source` field.
  final String source;

  /// The `attribution` field.
  final String attribution;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['id'] = id;
    out['title'] = title;
    out['image_url'] = imageUrl;
    out['url'] = url;
    if (capturedAt case final v?) {
      out['captured_at'] = formatDateTime(v);
    }
    out['stale'] = stale;
    out['source'] = source;
    out['attribution'] = attribution;
    return out;
  }
}

PassCamera _readPassCamera(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PassCamera(
    id: r.req('id', asString),
    title: r.req('title', asString),
    imageUrl: r.req('image_url', asString),
    url: r.req('url', asString),
    capturedAt: r.opt('captured_at', asDateTime),
    stale: r.req('stale', asBool),
    source: r.req('source', asString),
    attribution: r.req('attribution', asString),
  );
}

/// One pass chance: a probability with its threshold and members, never a bare
/// number.
final class PassChance {
  /// Creates a [PassChance].
  PassChance({
    this.probability,
    required this.threshold,
    this.precipitationThreshold,
    required this.members,
    required this.method,
    this.nullReason,
  });

  /// Decodes a [PassChance] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PassChance.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPassChance);

  /// 0-1 (0.001); null when it cannot be answered (`null_reason`).
  final double? probability;

  /// The event's threshold, in the response's units.
  final double threshold;

  /// For `p_wet_below_freezing`, the precipitation that makes an hour wet, in
  /// the response's units.
  final double? precipitationThreshold;

  /// The members that voted (0 for `hourly_gust_distribution`).
  final int members;

  /// The `method` field.
  final String method;

  /// The `null_reason` field.
  final String? nullReason;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (probability case final v?) {
      out['probability'] = v;
    }
    out['threshold'] = threshold;
    if (precipitationThreshold case final v?) {
      out['precipitation_threshold'] = v;
    }
    out['members'] = members;
    out['method'] = method;
    if (nullReason case final v?) {
      out['null_reason'] = v;
    }
    return out;
  }
}

PassChance _readPassChance(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PassChance(
    probability: r.opt('probability', asDouble),
    threshold: r.req('threshold', asDouble),
    precipitationThreshold: r.opt('precipitation_threshold', asDouble),
    members: r.req('members', asInt),
    method: r.req('method', asString),
    nullReason: r.opt('null_reason', asString),
  );
}

/// Chances at the pass over the next `window_hours` hours.
///
/// Each the share of the forecast's members meeting the event (the `?prob=`
/// machinery), except the gust chance (see its `method`).
final class PassChances {
  /// Creates a [PassChances].
  PassChances({
    required this.windowHours,
    required this.from,
    required this.to,
    required this.pSnowGe1in,
    required this.pSnowGe6in,
    required this.pWetBelowFreezing,
    required this.pGustGt40mph,
  });

  /// Decodes a [PassChances] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PassChances.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPassChances);

  /// The window's length, 24.
  final int windowHours;

  /// The `from` field.
  final DateTime from;

  /// The `to` field.
  final DateTime to;

  /// Snowfall total over the window of 1 in (25.4 mm) or more:
  /// `prob=snowfall:ge:<1 in>:24h`.
  final PassChance pSnowGe1in;

  /// Snowfall total over the window of 6 in (152.4 mm) or more.
  final PassChance pSnowGe6in;

  /// Some hour of the window in which the member is at or below freezing
  /// (`threshold`: 0 C, 32 F) with precipitation of at least
  /// `precipitation_threshold` (0.254 mm, 0.01 in) in the member's value ending
  /// at that hour: a wet road at or below ...
  final PassChance pWetBelowFreezing;

  /// A gust over 40 mph (17.9 m/s; threshold fixed, does not change with units)
  /// in the window.
  final PassChance pGustGt40mph;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['window_hours'] = windowHours;
    out['from'] = formatDateTime(from);
    out['to'] = formatDateTime(to);
    out['p_snow_ge_1in'] = pSnowGe1in.toJson();
    out['p_snow_ge_6in'] = pSnowGe6in.toJson();
    out['p_wet_below_freezing'] = pWetBelowFreezing.toJson();
    out['p_gust_gt_40mph'] = pGustGt40mph.toJson();
    return out;
  }
}

PassChances _readPassChances(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PassChances(
    windowHours: r.req('window_hours', asInt),
    from: r.req('from', asDateTime),
    to: r.req('to', asDateTime),
    pSnowGe1in: r.req('p_snow_ge_1in', _readPassChance),
    pSnowGe6in: r.req('p_snow_ge_6in', _readPassChance),
    pWetBelowFreezing: r.req('p_wet_below_freezing', _readPassChance),
    pGustGt40mph: r.req('p_gust_gt_40mph', _readPassChance),
  );
}

/// Is the pass getting weather? At the pass's own point and elevation.
///
/// Forecast quantities only, in the response's units.
final class PassForecast {
  /// Creates a [PassForecast].
  PassForecast({
    required this.elevation,
    required this.elevationM,
    required this.from,
    required this.snow24h,
    required this.chances,
    required this.snowWindows,
    required this.hours,
    required this.windows,
    this.officialStatus,
    this.roadSensors,
    this.cameras,
  });

  /// Decodes a [PassForecast] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PassForecast.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPassForecast);

  /// The pass's elevation, in the response's length units (m, ft).
  final double elevation;

  /// The pass's elevation in metres, whatever `units` is.
  final double elevationM;

  /// The first hour of `hours` (the hour containing now); the 24 h and 48 h
  /// windows open here.
  final DateTime from;

  /// The next 24 h of snow at the pass: exactly the default forecast's own
  /// `snow_outlook.next_24h` and `snow_outlook.quantiles.next_24h` (unpinned,
  /// the nowcast on, the same cycle), so the pass page, the passes board and
  /// search state one number.
  final PassSnow24h snow24h;

  /// Chances at the pass over the next `window_hours` hours, each the share of
  /// the forecast's members meeting the event (the `?prob=` machinery), except
  /// the gust chance (see its `method`).
  final PassChances chances;

  /// Each spell of snow at the pass in the next 48 h, in time order; empty when
  /// none.
  final List<PassSnowWindow> snowWindows;

  /// The next 48 hours at the pass, from `from`, one per hour.
  final List<PassHour> hours;

  /// The quietest and the busiest stretch of weather at the pass in the next
  /// `horizon_hours`, by one fixed rule on the hours above: an hour has weather
  /// when it is snowing (`snowfall` at least 0.04 in, 1 mm),
  /// `freezing_on_wet_road`, or `gust_over_40mph`.
  final PassTravelWindows windows;

  /// The DOT's own status for the road over the pass -- chain controls and
  /// closures as the DOT publishes them, its wording verbatim.
  final PassOfficialStatus? officialStatus;

  /// The state DOT road-weather stations nearest the pass, nearest first: at
  /// most 3, within 25 km, each with its newest reading in the last 3 h.
  final List<PassRoadSensor>? roadSensors;

  /// The DOT's own cameras at the pass, in the order the pass's curation lists
  /// them.
  final List<PassCamera>? cameras;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['elevation'] = elevation;
    out['elevation_m'] = elevationM;
    out['from'] = formatDateTime(from);
    out['snow_24h'] = snow24h.toJson();
    out['chances'] = chances.toJson();
    out['snow_windows'] = [for (final e in snowWindows) e.toJson()];
    out['hours'] = [for (final e in hours) e.toJson()];
    out['windows'] = windows.toJson();
    if (officialStatus case final v?) {
      out['official_status'] = v.toJson();
    }
    if (roadSensors case final v?) {
      out['road_sensors'] = [for (final e in v) e.toJson()];
    }
    if (cameras case final v?) {
      out['cameras'] = [for (final e in v) e.toJson()];
    }
    return out;
  }
}

PassForecast _readPassForecast(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PassForecast(
    elevation: r.req('elevation', asDouble),
    elevationM: r.req('elevation_m', asDouble),
    from: r.req('from', asDateTime),
    snow24h: r.req('snow_24h', _readPassSnow24h),
    chances: r.req('chances', _readPassChances),
    snowWindows: r.req('snow_windows', listOf(_readPassSnowWindow)),
    hours: r.req('hours', listOf(_readPassHour)),
    windows: r.req('windows', _readPassTravelWindows),
    officialStatus: r.opt('official_status', _readPassOfficialStatus),
    roadSensors: r.opt('road_sensors', listOf(_readPassRoadSensor)),
    cameras: r.opt('cameras', listOf(_readPassCamera)),
  );
}

/// One hour at the pass: the road-relevant forecast values.
final class PassHour {
  /// Creates a [PassHour].
  PassHour({
    required this.time,
    required this.temperature,
    required this.precipitation,
    this.precipitationProbability,
    this.precipitationType,
    required this.snowfall,
    this.snowLevel,
    this.snowLevelMargin,
    required this.freezingOnWetRoad,
    required this.windSpeed,
    this.windGust,
    required this.gustOver40mph,
    required this.blowingSnow,
  });

  /// Decodes a [PassHour] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PassHour.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPassHour);

  /// The hour's `valid_time`; amounts are over the hour ending then.
  final DateTime time;

  /// `ensemble.temperature.mean`.
  final double temperature;

  /// `ensemble.precipitation.mean` (mm, in).
  final double precipitation;

  /// `ensemble.precipitation.probability`, 0-1.
  final double? precipitationProbability;

  /// The hour's served `precipitation_type.type`; omitted on a dry hour.
  final String? precipitationType;

  /// `ensemble.snowfall.mean` (mm, in); 0 without snow.
  final double snowfall;

  /// `ensemble.snow_level.mean` (m, ft); omitted where not served.
  final double? snowLevel;

  /// (JSON `snow_level_above_pass`) `snow_level` minus the pass's elevation (m,
  /// ft). Above 0 the snow level is above the pass (rain at the pass when wet),
  /// below 0 it is under it.
  final double? snowLevelMargin;

  /// The hour is at or below freezing (temperature mean at or below 0 C, 32 F)
  /// and wet: precipitation of at least 0.254 mm (0.01 in) in this hour or one
  /// of the two before it.
  final bool freezingOnWetRoad;

  /// `ensemble.wind_speed.mean`.
  final double windSpeed;

  /// `ensemble.wind_gust.mean`; omitted where not served.
  final double? windGust;

  /// `wind_gust` is over 40 mph (17.9 m/s); threshold fixed, does not change
  /// with units.
  final bool gustOver40mph;

  /// Gusts of 25 mph (11.2 m/s) or more at or below freezing with loose snow to
  /// move: snow falling this hour, 1 in (25.4 mm) or more fallen in the 24
  /// served hours before it, or snow on the ground at the pass
  /// (`snow_on_ground`).
  final bool blowingSnow;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['time'] = formatDateTime(time);
    out['temperature'] = temperature;
    out['precipitation'] = precipitation;
    if (precipitationProbability case final v?) {
      out['precipitation_probability'] = v;
    }
    if (precipitationType case final v?) {
      out['precipitation_type'] = v;
    }
    out['snowfall'] = snowfall;
    if (snowLevel case final v?) {
      out['snow_level'] = v;
    }
    if (snowLevelMargin case final v?) {
      out['snow_level_above_pass'] = v;
    }
    out['freezing_on_wet_road'] = freezingOnWetRoad;
    out['wind_speed'] = windSpeed;
    if (windGust case final v?) {
      out['wind_gust'] = v;
    }
    out['gust_over_40mph'] = gustOver40mph;
    out['blowing_snow'] = blowingSnow;
    return out;
  }
}

PassHour _readPassHour(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PassHour(
    time: r.req('time', asDateTime),
    temperature: r.req('temperature', asDouble),
    precipitation: r.req('precipitation', asDouble),
    precipitationProbability: r.opt('precipitation_probability', asDouble),
    precipitationType: r.opt('precipitation_type', asString),
    snowfall: r.req('snowfall', asDouble),
    snowLevel: r.opt('snow_level', asDouble),
    snowLevelMargin: r.opt('snow_level_above_pass', asDouble),
    freezingOnWetRoad: r.req('freezing_on_wet_road', asBool),
    windSpeed: r.req('wind_speed', asDouble),
    windGust: r.opt('wind_gust', asDouble),
    gustOver40mph: r.req('gust_over_40mph', asBool),
    blowingSnow: r.req('blowing_snow', asBool),
  );
}

/// The DOT's own status for the road over the pass.
///
/// Chain controls and closures as the DOT publishes them, its wording verbatim.
final class PassOfficialStatus {
  /// Creates a [PassOfficialStatus].
  PassOfficialStatus({
    required this.source,
    required this.attribution,
    required this.url,
    required this.checkedAt,
    required this.stale,
    required this.level,
    required this.segments,
  });

  /// Decodes a [PassOfficialStatus] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PassOfficialStatus.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPassOfficialStatus);

  /// The DOT feed.
  final String source;

  /// Who to credit, as the client shows it.
  final String attribution;

  /// The DOT's own page for this road, to link out to.
  final String url;

  /// How fresh the DOT's feed behind these segments was at Ourea's last read:
  /// the time the DOT wrote the file Ourea last read (Caltrans rewrites it
  /// every minute; Ourea reads it every 5), and the older of two when the
  /// segments span two DOT ...
  final DateTime checkedAt;

  /// `checked_at` is more than 30 minutes before `as_of`.
  final bool stale;

  /// The DOT's own restriction, as an enum, for ordering and colour only: the
  /// words a client shows are the DOT's `status` and `status_text`.
  final PassStatusLevel level;

  /// The DOT's chain-control and closure points on the road over the pass, each
  /// direction, in the pass's curated order.
  final List<PassStatusSegment> segments;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['source'] = source;
    out['attribution'] = attribution;
    out['url'] = url;
    out['checked_at'] = formatDateTime(checkedAt);
    out['stale'] = stale;
    out['level'] = level.value;
    out['segments'] = [for (final e in segments) e.toJson()];
    return out;
  }
}

PassOfficialStatus _readPassOfficialStatus(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PassOfficialStatus(
    source: r.req('source', asString),
    attribution: r.req('attribution', asString),
    url: r.req('url', asString),
    checkedAt: r.req('checked_at', asDateTime),
    stale: r.req('stale', asBool),
    level: r.req('level', enumOf(PassStatusLevel.new)),
    segments: r.req('segments', listOf(_readPassStatusSegment)),
  );
}

/// One state DOT road-weather station's newest reading, in the response's
/// units.
final class PassRoadSensor {
  /// Creates a [PassRoadSensor].
  PassRoadSensor({
    required this.stationId,
    required this.name,
    required this.source,
    required this.attribution,
    required this.distanceKm,
    this.elevation,
    this.elevationM,
    required this.observedAt,
    required this.stale,
    this.pavementCondition,
    this.pavementTemp,
    this.subsurfaceTemp,
    this.temperature,
    this.windSpeed,
    this.windGust,
    this.windDirection,
    this.visibility,
  });

  /// Decodes a [PassRoadSensor] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PassRoadSensor.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPassRoadSensor);

  /// The station's id in its network.
  final String stationId;

  /// The station's registry name, else its id.
  final String name;

  /// The feed: `rwis` (Caltrans CWWP2 RWIS) or `wsdot`.
  final String source;

  /// Who measured it, as the client credits it.
  final String attribution;

  /// Straight-line distance from the pass, km.
  final double distanceKm;

  /// The station's registry elevation in the response's length units (m, ft).
  final double? elevation;

  /// The station's registry elevation in metres.
  final double? elevationM;

  /// The `observed_at` field.
  final DateTime observedAt;

  /// `observed_at` is more than 60 minutes before `as_of`.
  final bool stale;

  /// The pavement state the sensor reports (NTCIP 1204 essSurfaceStatus as
  /// `/current` sensors serve it: dry, trace_moisture, wet, chemically_wet,
  /// ice_warning, ice_watch, snow_warning, snow_watch, absorption, dew, frost,
  /// absorption_at_dewpoint).
  final String? pavementCondition;

  /// Pavement surface temperature: °C, °F (imperial) or K (kelvin).
  final double? pavementTemp;

  /// As `pavement_temp`.
  final double? subsurfaceTemp;

  /// Air temperature, as `pavement_temp`.
  final double? temperature;

  /// m/s or mph (imperial).
  final double? windSpeed;

  /// As `wind_speed`.
  final double? windGust;

  /// Degrees clockwise from north.
  final double? windDirection;

  /// m, or statute miles (imperial).
  final double? visibility;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['station_id'] = stationId;
    out['name'] = name;
    out['source'] = source;
    out['attribution'] = attribution;
    out['distance_km'] = distanceKm;
    if (elevation case final v?) {
      out['elevation'] = v;
    }
    if (elevationM case final v?) {
      out['elevation_m'] = v;
    }
    out['observed_at'] = formatDateTime(observedAt);
    out['stale'] = stale;
    if (pavementCondition case final v?) {
      out['pavement_condition'] = v;
    }
    if (pavementTemp case final v?) {
      out['pavement_temp'] = v;
    }
    if (subsurfaceTemp case final v?) {
      out['subsurface_temp'] = v;
    }
    if (temperature case final v?) {
      out['temperature'] = v;
    }
    if (windSpeed case final v?) {
      out['wind_speed'] = v;
    }
    if (windGust case final v?) {
      out['wind_gust'] = v;
    }
    if (windDirection case final v?) {
      out['wind_direction'] = v;
    }
    if (visibility case final v?) {
      out['visibility'] = v;
    }
    return out;
  }
}

PassRoadSensor _readPassRoadSensor(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PassRoadSensor(
    stationId: r.req('station_id', asString),
    name: r.req('name', asString),
    source: r.req('source', asString),
    attribution: r.req('attribution', asString),
    distanceKm: r.req('distance_km', asDouble),
    elevation: r.opt('elevation', asDouble),
    elevationM: r.opt('elevation_m', asDouble),
    observedAt: r.req('observed_at', asDateTime),
    stale: r.req('stale', asBool),
    pavementCondition: r.opt('pavement_condition', asString),
    pavementTemp: r.opt('pavement_temp', asDouble),
    subsurfaceTemp: r.opt('subsurface_temp', asDouble),
    temperature: r.opt('temperature', asDouble),
    windSpeed: r.opt('wind_speed', asDouble),
    windGust: r.opt('wind_gust', asDouble),
    windDirection: r.opt('wind_direction', asDouble),
    visibility: r.opt('visibility', asDouble),
  );
}

/// The next 24 h of snow at the pass.
///
/// Exactly the default forecast's own `snow_outlook.next_24h` and
/// `snow_outlook.quantiles.next_24h` (unpinned, the nowcast on, the same
/// cycle), so the pass page, the passes board and search state one number.
final class PassSnow24h {
  /// Creates a [PassSnow24h].
  PassSnow24h({
    this.total,
    this.p10,
    this.p90,
    this.startsAt,
  });

  /// Decodes a [PassSnow24h] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PassSnow24h.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPassSnow24h);

  /// `snow_outlook.next_24h` (mm, in); null where the forecast does not reach
  /// 24 h.
  final double? total;

  /// `snow_outlook.quantiles.next_24h.p10`; null without members covering the
  /// window.
  final double? p10;

  /// `snow_outlook.quantiles.next_24h.p90`.
  final double? p90;

  /// The start of the first snow spell (`snow_windows[0].start`) when it begins
  /// inside the 24 h; null otherwise.
  final DateTime? startsAt;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (total case final v?) {
      out['total'] = v;
    }
    if (p10 case final v?) {
      out['p10'] = v;
    }
    if (p90 case final v?) {
      out['p90'] = v;
    }
    if (startsAt case final v?) {
      out['starts_at'] = formatDateTime(v);
    }
    return out;
  }
}

PassSnow24h _readPassSnow24h(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PassSnow24h(
    total: r.opt('total', asDouble),
    p10: r.opt('p10', asDouble),
    p90: r.opt('p90', asDouble),
    startsAt: r.opt('starts_at', asDateTime),
  );
}

/// One window of snow at the pass: its start, end and snowfall range.
final class PassSnowWindow {
  /// Creates a [PassSnowWindow].
  PassSnowWindow({
    required this.start,
    required this.end,
    required this.total,
    this.p10,
    this.p90,
    this.pGe1in,
  });

  /// Decodes a [PassSnowWindow] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PassSnowWindow.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPassSnowWindow);

  /// When the first snowing hour begins (its `valid_time` minus 1 h).
  final DateTime start;

  /// When the last snowing hour ends (its `valid_time`).
  final DateTime end;

  /// The sum of the hourly snowfall means over the spell (mm, in), as
  /// `snow_outlook` sums its windows.
  final double total;

  /// The p10 of the members' own totals over the spell (`?totals=` machinery);
  /// omitted without enough members.
  final double? p10;

  /// The p90 of the members' own totals over the spell.
  final double? p90;

  /// The share of members whose own total over the spell is 1 in (25.4 mm) or
  /// more; threshold fixed, does not change with units.
  final double? pGe1in;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['start'] = formatDateTime(start);
    out['end'] = formatDateTime(end);
    out['total'] = total;
    if (p10 case final v?) {
      out['p10'] = v;
    }
    if (p90 case final v?) {
      out['p90'] = v;
    }
    if (pGe1in case final v?) {
      out['p_ge_1in'] = v;
    }
    return out;
  }
}

PassSnowWindow _readPassSnowWindow(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PassSnowWindow(
    start: r.req('start', asDateTime),
    end: r.req('end', asDateTime),
    total: r.req('total', asDouble),
    p10: r.opt('p10', asDouble),
    p90: r.opt('p90', asDouble),
    pGe1in: r.opt('p_ge_1in', asDouble),
  );
}

/// One DOT chain-control or closure point, as the DOT publishes it.
final class PassStatusSegment {
  /// Creates a [PassStatusSegment].
  PassStatusSegment({
    required this.id,
    required this.route,
    required this.direction,
    required this.location,
    required this.state,
    required this.level,
    required this.text,
    required this.updatedAt,
    required this.lat,
    required this.lon,
    this.roadCondition,
    this.weatherCondition,
  });

  /// Decodes a [PassStatusSegment] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PassStatusSegment.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPassStatusSegment);

  /// The DOT's own id for the point.
  final String id;

  /// The `route` field.
  final String route;

  /// The direction the point controls, as the DOT names it.
  final String direction;

  /// The DOT's name for the point (its trailing field padding removed).
  final String location;

  /// (JSON `status`) The DOT's status code, verbatim.
  final String state;

  /// The DOT's own restriction, as an enum, for ordering and colour only: the
  /// words a client shows are the DOT's `status` and `status_text`.
  final PassStatusLevel level;

  /// (JSON `status_text`) The DOT's own description of the status, verbatim.
  final String text;

  /// When the DOT set this status.
  final DateTime updatedAt;

  /// The `lat` field.
  final double lat;

  /// The `lon` field.
  final double lon;

  /// The DOT's own report of the road surface there, verbatim, where it gives
  /// one beside the restriction (WSDOT, ODOT).
  final String? roadCondition;

  /// The DOT's own report of the weather there, verbatim (WSDOT, ODOT).
  final String? weatherCondition;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['id'] = id;
    out['route'] = route;
    out['direction'] = direction;
    out['location'] = location;
    out['status'] = state;
    out['level'] = level.value;
    out['status_text'] = text;
    out['updated_at'] = formatDateTime(updatedAt);
    out['lat'] = lat;
    out['lon'] = lon;
    if (roadCondition case final v?) {
      out['road_condition'] = v;
    }
    if (weatherCondition case final v?) {
      out['weather_condition'] = v;
    }
    return out;
  }
}

PassStatusSegment _readPassStatusSegment(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PassStatusSegment(
    id: r.req('id', asString),
    route: r.req('route', asString),
    direction: r.req('direction', asString),
    location: r.req('location', asString),
    state: r.req('status', asString),
    level: r.req('level', enumOf(PassStatusLevel.new)),
    text: r.req('status_text', asString),
    updatedAt: r.req('updated_at', asDateTime),
    lat: r.req('lat', asDouble),
    lon: r.req('lon', asDouble),
    roadCondition: r.opt('road_condition', asString),
    weatherCondition: r.opt('weather_condition', asString),
  );
}

/// One travel window: its start, end and the weather it holds.
final class PassTravelWindow {
  /// Creates a [PassTravelWindow].
  PassTravelWindow({
    required this.start,
    required this.end,
    required this.snowfall,
    required this.freezingOnWetRoadHours,
    this.maxWindGust,
  });

  /// Decodes a [PassTravelWindow] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PassTravelWindow.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPassTravelWindow);

  /// When the run's first hour begins.
  final DateTime start;

  /// When its last hour ends.
  final DateTime end;

  /// The sum of the hourly snowfall means over the run (mm, in).
  final double snowfall;

  /// The `freezing_on_wet_road_hours` field.
  final int freezingOnWetRoadHours;

  /// The highest hourly gust mean in the run; omitted where no gust is served.
  final double? maxWindGust;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['start'] = formatDateTime(start);
    out['end'] = formatDateTime(end);
    out['snowfall'] = snowfall;
    out['freezing_on_wet_road_hours'] = freezingOnWetRoadHours;
    if (maxWindGust case final v?) {
      out['max_wind_gust'] = v;
    }
    return out;
  }
}

PassTravelWindow _readPassTravelWindow(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PassTravelWindow(
    start: r.req('start', asDateTime),
    end: r.req('end', asDateTime),
    snowfall: r.req('snowfall', asDouble),
    freezingOnWetRoadHours: r.req('freezing_on_wet_road_hours', asInt),
    maxWindGust: r.opt('max_wind_gust', asDouble),
  );
}

/// The least- and most-weather travel windows at the pass.
///
/// The quietest and the busiest stretch of weather at the pass in the next
/// `horizon_hours`, by one fixed rule on the hours above: an hour has weather
/// when it is snowing (`snowfall` at least 0.04 in, 1 mm),
/// `freezing_on_wet_road`, or `gust_over_40mph`.
final class PassTravelWindows {
  /// Creates a [PassTravelWindows].
  PassTravelWindows({
    required this.horizonHours,
    this.leastWeather,
    this.mostWeather,
  });

  /// Decodes a [PassTravelWindows] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PassTravelWindows.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPassTravelWindows);

  /// The horizon's length in hours, 24.
  final int horizonHours;

  /// Null when every hour has weather.
  final PassTravelWindow? leastWeather;

  /// Null when no hour has weather.
  final PassTravelWindow? mostWeather;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['horizon_hours'] = horizonHours;
    if (leastWeather case final v?) {
      out['least_weather'] = v.toJson();
    }
    if (mostWeather case final v?) {
      out['most_weather'] = v.toJson();
    }
    return out;
  }
}

PassTravelWindows _readPassTravelWindows(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PassTravelWindows(
    horizonHours: r.req('horizon_hours', asInt),
    leastWeather: r.opt('least_weather', _readPassTravelWindow),
    mostWeather: r.opt('most_weather', _readPassTravelWindow),
  );
}

/// A short plain-language summary of what is coming at a place.
///
/// Written by the server from templates filled with served values (never free
/// text from a model).
final class PlaceSummary {
  /// Creates a [PlaceSummary].
  PlaceSummary({
    required this.short,
    required this.long,
    required this.events,
    this.elevationName,
    required this.elevation,
    required this.run,
    required this.generatedAt,
  });

  /// Decodes a [PlaceSummary] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PlaceSummary.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPlaceSummary);

  /// One sentence: the most important thing at the place, by priority (an NWS
  /// alert, precipitation starting or stopping soon, snow coming, wind or a
  /// large temperature change, then the day's headline).
  final String short;

  /// One to three sentences for the location page, each from a different kind
  /// of event.
  final List<String> long;

  /// The event behind each sentence of `long`, in the same order (`events[i]`
  /// wrote `long[i]`), so a client can style a sentence (an alert chip, a snow
  /// icon) without parsing text.
  final List<SummaryEvent> events;

  /// The served elevation the sentences describe: its display name where the
  /// catalog has one, else its name.
  final String? elevationName;

  /// The height the sentences describe, in the response's length units (m, ft).
  final double elevation;

  /// The init of the forecast run the sentences were written from.
  final DateTime run;

  /// When the sentences were written (the request's now); the "updated" stamp.
  final DateTime generatedAt;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['short'] = short;
    out['long'] = long;
    out['events'] = [for (final e in events) e.toJson()];
    if (elevationName case final v?) {
      out['elevation_name'] = v;
    }
    out['elevation'] = elevation;
    out['run'] = formatDateTime(run);
    out['generated_at'] = formatDateTime(generatedAt);
    return out;
  }
}

PlaceSummary _readPlaceSummary(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PlaceSummary(
    short: r.req('short', asString),
    long: r.req('long', listOf(asString)),
    events: r.req('events', listOf(_readSummaryEvent)),
    elevationName: r.opt('elevation_name', asString),
    elevation: r.req('elevation', asDouble),
    run: r.req('run', asDateTime),
    generatedAt: r.req('generated_at', asDateTime),
  );
}

/// The members' distributions, at the served hours that carry at least one
/// (`valid_time`.
///
/// The synoptic hours in practice): `cumulative_precipitation` /
/// `cumulative_snowfall` are the row form's `members_cumulative` (the spread of
/// the members' running totals, never a sum of hourly percentiles),
/// `temperature` / `snow_level` its `members_spread`, `precipitation_6h` /
/// `snowfall_6h` its `members_6h` ...
final class PlumeBands {
  /// Creates a [PlumeBands].
  PlumeBands({
    required this.validTime,
    required this.cumulativePrecipitation,
    required this.cumulativeSnowfall,
    required this.cumulativeSnowfall10to1,
    required this.temperature,
    required this.snowLevel,
    required this.snowLevelWetBulb,
    required this.precipitation6h,
    required this.snowfall6h,
    this.slr,
    this.windSpeed,
  });

  /// Decodes a [PlumeBands] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PlumeBands.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPlumeBands);

  /// The `valid_time` field.
  final List<DateTime> validTime;

  /// One band's statistics (Hyndman-Fan type 7 over the served member values),
  /// each an array aligned to `PlumeBands.valid_time`, `null` where the band is
  /// absent at that hour.
  final BandColumns cumulativePrecipitation;

  /// One band's statistics (Hyndman-Fan type 7 over the served member values),
  /// each an array aligned to `PlumeBands.valid_time`, `null` where the band is
  /// absent at that hour.
  final BandColumns cumulativeSnowfall;

  /// The members' running snowfall at 10:1 -- each member's snowfall with its
  /// SLR replaced by 10 (its snowing liquid x 10, every phase gate of its
  /// `snowfall` kept, the `snowfall_total_10to1` map's member rule), totalled
  /// as `cumulative_snowfall` ...
  final BandColumns cumulativeSnowfall10to1;

  /// One band's statistics (Hyndman-Fan type 7 over the served member values),
  /// each an array aligned to `PlumeBands.valid_time`, `null` where the band is
  /// absent at that hour.
  final BandColumns temperature;

  /// One band's statistics (Hyndman-Fan type 7 over the served member values),
  /// each an array aligned to `PlumeBands.valid_time`, `null` where the band is
  /// absent at that hour.
  final BandColumns snowLevel;

  /// The row form's `members_spread.snow_level_wet_bulb` -- the members' snow
  /// level on the NWS scale, at the hours `snow_level` carries a band.
  final BandColumns snowLevelWetBulb;

  /// One band's statistics (Hyndman-Fan type 7 over the served member values),
  /// each an array aligned to `PlumeBands.valid_time`, `null` where the band is
  /// absent at that hour.
  final BandColumns precipitation6h;

  /// One band's statistics (Hyndman-Fan type 7 over the served member values),
  /// each an array aligned to `PlumeBands.valid_time`, `null` where the band is
  /// absent at that hour.
  final BandColumns snowfall6h;

  /// One band's statistics (Hyndman-Fan type 7 over the served member values),
  /// each an array aligned to `PlumeBands.valid_time`, `null` where the band is
  /// absent at that hour.
  final BandColumns? slr;

  /// `members_spread.wind_speed`.
  final BandColumns? windSpeed;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['valid_time'] = [for (final e in validTime) formatDateTime(e)];
    out['cumulative_precipitation'] = cumulativePrecipitation.toJson();
    out['cumulative_snowfall'] = cumulativeSnowfall.toJson();
    out['cumulative_snowfall_10to1'] = cumulativeSnowfall10to1.toJson();
    out['temperature'] = temperature.toJson();
    out['snow_level'] = snowLevel.toJson();
    out['snow_level_wet_bulb'] = snowLevelWetBulb.toJson();
    out['precipitation_6h'] = precipitation6h.toJson();
    out['snowfall_6h'] = snowfall6h.toJson();
    if (slr case final v?) {
      out['slr'] = v.toJson();
    }
    if (windSpeed case final v?) {
      out['wind_speed'] = v.toJson();
    }
    return out;
  }
}

PlumeBands _readPlumeBands(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PlumeBands(
    validTime: r.req('valid_time', listOf(asDateTime)),
    cumulativePrecipitation:
        r.req('cumulative_precipitation', _readBandColumns),
    cumulativeSnowfall: r.req('cumulative_snowfall', _readBandColumns),
    cumulativeSnowfall10to1:
        r.req('cumulative_snowfall_10to1', _readBandColumns),
    temperature: r.req('temperature', _readBandColumns),
    snowLevel: r.req('snow_level', _readBandColumns),
    snowLevelWetBulb: r.req('snow_level_wet_bulb', _readBandColumns),
    precipitation6h: r.req('precipitation_6h', _readBandColumns),
    snowfall6h: r.req('snowfall_6h', _readBandColumns),
    slr: r.opt('slr', _readBandColumns),
    windSpeed: r.opt('wind_speed', _readBandColumns),
  );
}

/// The lines a plume draws over its members, at every served hour
/// (`valid_time`).
///
/// The blend's `temperature` and `snow_level` means (`ensemble.*.mean`) and its
/// running totals (`cumulative_precipitation`, `cumulative_snowfall`: the
/// "Ourea forecast" line), and that snowfall line at a 10:1 snow-to-liquid
/// ratio (`cumulative_snowfall_10to1`), and its `wind_speed` mean and its
/// snowfall in each 6 hours ...
final class PlumeHeadline {
  /// Creates a [PlumeHeadline].
  PlumeHeadline({
    required this.validTime,
    required this.temperature,
    required this.snowLevel,
    required this.snowLevelWetBulb,
    required this.cumulativePrecipitation,
    required this.cumulativeSnowfall,
    required this.cumulativeSnowfall10to1,
    required this.windSpeed,
    required this.snowfall6h,
  });

  /// Decodes a [PlumeHeadline] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PlumeHeadline.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPlumeHeadline);

  /// The `valid_time` field.
  final List<DateTime> validTime;

  /// Numbers aligned to the enclosing block's `valid_time`; `null` = no value
  /// there.
  final List<double?> temperature;

  /// Numbers aligned to the enclosing block's `valid_time`; `null` = no value
  /// there.
  final List<double?> snowLevel;

  /// The blend's snow level on the NWS scale
  /// (`ensemble.snow_level_wet_bulb.mean`, the height of the 0.5 C wet-bulb);
  /// `snow_level` is the rain line.
  final List<double?> snowLevelWetBulb;

  /// Numbers aligned to the enclosing block's `valid_time`; `null` = no value
  /// there.
  final List<double?> cumulativePrecipitation;

  /// The hourly series' `cumulative_snowfall`: the running sum of the day
  /// cards' snowfall (`daily[].precipitation_display.snow_amount`), spread
  /// inside each local date by the blend's hourly mean snowfall, so at the end
  /// of each date served whole ...
  final List<double?> cumulativeSnowfall;

  /// The headline's running snowfall at a fixed 10:1 snow-to-liquid ratio, in
  /// the snowfall units (in / mm), at the amount precision: each hour's served
  /// snowfall with its SLR (`ensemble.slr.mean`) replaced by 10 -- the liquid
  /// that falls as snow, ...
  final List<double?> cumulativeSnowfall10to1;

  /// The forecast's hourly wind speed, the hourly series'
  /// `ensemble.wind_speed.mean`, in the wind unit (mph / km/h / m/s as `units`
  /// says) at the wind precision (0.1), at every served hour.
  final List<double?> windSpeed;

  /// The forecast's snowfall in the 6 hours ending at each 00/06/12/18Z hour,
  /// in the snowfall units (in / mm) at the amount precision: the rise of
  /// `cumulative_snowfall` over `(valid_time - 6 h, valid_time]`, computed here
  /// so no client ...
  final List<double?> snowfall6h;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['valid_time'] = [for (final e in validTime) formatDateTime(e)];
    out['temperature'] = temperature;
    out['snow_level'] = snowLevel;
    out['snow_level_wet_bulb'] = snowLevelWetBulb;
    out['cumulative_precipitation'] = cumulativePrecipitation;
    out['cumulative_snowfall'] = cumulativeSnowfall;
    out['cumulative_snowfall_10to1'] = cumulativeSnowfall10to1;
    out['wind_speed'] = windSpeed;
    out['snowfall_6h'] = snowfall6h;
    return out;
  }
}

PlumeHeadline _readPlumeHeadline(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PlumeHeadline(
    validTime: r.req('valid_time', listOf(asDateTime)),
    temperature: r.req('temperature', listOf(nullableOf(asDouble))),
    snowLevel: r.req('snow_level', listOf(nullableOf(asDouble))),
    snowLevelWetBulb:
        r.req('snow_level_wet_bulb', listOf(nullableOf(asDouble))),
    cumulativePrecipitation:
        r.req('cumulative_precipitation', listOf(nullableOf(asDouble))),
    cumulativeSnowfall:
        r.req('cumulative_snowfall', listOf(nullableOf(asDouble))),
    cumulativeSnowfall10to1:
        r.req('cumulative_snowfall_10to1', listOf(nullableOf(asDouble))),
    windSpeed: r.req('wind_speed', listOf(nullableOf(asDouble))),
    snowfall6h: r.req('snowfall_6h', listOf(nullableOf(asDouble))),
  );
}

/// Where a coordinate forecast was computed.
final class PointInfo {
  /// Creates a [PointInfo].
  PointInfo({
    required this.requestedLat,
    required this.requestedLon,
    required this.lat,
    required this.lon,
    required this.resolutionDeg,
    required this.elevation,
    required this.elevationSource,
    required this.state,
  });

  /// Decodes a [PointInfo] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PointInfo.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPointInfo);

  /// Latitude as sent.
  final double requestedLat;

  /// Longitude as sent.
  final double requestedLon;

  /// The quantized latitude the forecast was computed at.
  final double lat;

  /// The quantized longitude the forecast was computed at.
  final double lon;

  /// Quantization step in degrees (0.01).
  final double resolutionDeg;

  /// Elevation the forecast was computed at, in the response's length unit (m;
  /// ft for `units=imperial`); `location.elevation_m` is the same height in
  /// metres.
  final double elevation;

  /// `request` = the caller's `elevation_m` (it always wins); `dem_3dep_10m` =
  /// no `elevation_m` was sent, and this is the USGS 3DEP 1/3 arc-second (~10
  /// m) DEM, bilinear at the quantized point.
  final ElevationSource elevationSource;

  /// The lowercase USPS code of the state the point is in (sets the daily
  /// summaries' timezone), as `location.state`.
  final String state;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['requested_lat'] = requestedLat;
    out['requested_lon'] = requestedLon;
    out['lat'] = lat;
    out['lon'] = lon;
    out['resolution_deg'] = resolutionDeg;
    out['elevation'] = elevation;
    out['elevation_source'] = elevationSource.value;
    out['state'] = state;
    return out;
  }
}

PointInfo _readPointInfo(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PointInfo(
    requestedLat: r.req('requested_lat', asDouble),
    requestedLon: r.req('requested_lon', asDouble),
    lat: r.req('lat', asDouble),
    lon: r.req('lon', asDouble),
    resolutionDeg: r.req('resolution_deg', asDouble),
    elevation: r.req('elevation', asDouble),
    elevationSource: r.req('elevation_source', enumOf(ElevationSource.new)),
    state: r.req('state', asString),
  );
}

/// The members as ONE unlabelled pool, for a caller without the plume's paid
/// detail.
///
/// (Free and anonymous; `members_view: pool`).
final class PooledColumns {
  /// Creates a [PooledColumns].
  PooledColumns({
    required this.validTime,
    required this.temperature,
    required this.precipitation,
    required this.precipitationHours,
    required this.cumulativePrecipitation,
    required this.snowLevel,
    required this.snowLevelWetBulb,
    required this.snowfall,
    required this.cumulativeSnowfall,
    required this.slr,
    required this.cumulativePrecipitationBandMembers,
    required this.cumulativeSnowfallBandMembers,
    required this.cumulativeSnowfall10to1BandMembers,
  });

  /// Decodes a [PooledColumns] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PooledColumns.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPooledColumns);

  /// The `valid_time` field.
  final List<DateTime> validTime;

  /// `[member][step]`: one array per member (`member_ids` order) over the
  /// model's `valid_time`; `null` = no value at that step.
  final List<List<double?>> temperature;

  /// `[member][step]`: one array per member (`member_ids` order) over the
  /// model's `valid_time`; `null` = no value at that step.
  final List<List<double?>> precipitation;

  /// `[member][step]`: the hours each `precipitation` and `snowfall` value
  /// covers: the grid step (6), less where a member's first value covers less;
  /// `null` where the value is absent.
  final List<List<int?>> precipitationHours;

  /// `[member][step]`: one array per member (`member_ids` order) over the
  /// model's `valid_time`; `null` = no value at that step.
  final List<List<double?>> cumulativePrecipitation;

  /// `[member][step]`: one array per member (`member_ids` order) over the
  /// model's `valid_time`; `null` = no value at that step.
  final List<List<double?>> snowLevel;

  /// `[member][step]`: one array per member (`member_ids` order) over the
  /// model's `valid_time`; `null` = no value at that step.
  final List<List<double?>> snowLevelWetBulb;

  /// `[member][step]`: one array per member (`member_ids` order) over the
  /// model's `valid_time`; `null` = no value at that step.
  final List<List<double?>> snowfall;

  /// `[member][step]`: one array per member (`member_ids` order) over the
  /// model's `valid_time`; `null` = no value at that step.
  final List<List<double?>> cumulativeSnowfall;

  /// `[member][step]`: one array per member (`member_ids` order) over the
  /// model's `valid_time`; `null` = no value at that step.
  final List<List<double?>> slr;

  /// The rows (indices into every column) in `bands.cumulative_precipitation`'s
  /// fixed population, ascending: that band's `mean` is the mean of these rows'
  /// running totals.
  final List<int> cumulativePrecipitationBandMembers;

  /// Likewise for `bands.cumulative_snowfall`.
  final List<int> cumulativeSnowfallBandMembers;

  /// Likewise for `bands.cumulative_snowfall_10to1`.
  final List<int> cumulativeSnowfall10to1BandMembers;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['valid_time'] = [for (final e in validTime) formatDateTime(e)];
    out['temperature'] = temperature;
    out['precipitation'] = precipitation;
    out['precipitation_hours'] = precipitationHours;
    out['cumulative_precipitation'] = cumulativePrecipitation;
    out['snow_level'] = snowLevel;
    out['snow_level_wet_bulb'] = snowLevelWetBulb;
    out['snowfall'] = snowfall;
    out['cumulative_snowfall'] = cumulativeSnowfall;
    out['slr'] = slr;
    out['cumulative_precipitation_band_members'] =
        cumulativePrecipitationBandMembers;
    out['cumulative_snowfall_band_members'] = cumulativeSnowfallBandMembers;
    out['cumulative_snowfall_10to1_band_members'] =
        cumulativeSnowfall10to1BandMembers;
    return out;
  }
}

PooledColumns _readPooledColumns(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PooledColumns(
    validTime: r.req('valid_time', listOf(asDateTime)),
    temperature: r.req('temperature', listOf(listOf(nullableOf(asDouble)))),
    precipitation: r.req('precipitation', listOf(listOf(nullableOf(asDouble)))),
    precipitationHours:
        r.req('precipitation_hours', listOf(listOf(nullableOf(asInt)))),
    cumulativePrecipitation:
        r.req('cumulative_precipitation', listOf(listOf(nullableOf(asDouble)))),
    snowLevel: r.req('snow_level', listOf(listOf(nullableOf(asDouble)))),
    snowLevelWetBulb:
        r.req('snow_level_wet_bulb', listOf(listOf(nullableOf(asDouble)))),
    snowfall: r.req('snowfall', listOf(listOf(nullableOf(asDouble)))),
    cumulativeSnowfall:
        r.req('cumulative_snowfall', listOf(listOf(nullableOf(asDouble)))),
    slr: r.req('slr', listOf(listOf(nullableOf(asDouble)))),
    cumulativePrecipitationBandMembers:
        r.req('cumulative_precipitation_band_members', listOf(asInt)),
    cumulativeSnowfallBandMembers:
        r.req('cumulative_snowfall_band_members', listOf(asInt)),
    cumulativeSnowfall10to1BandMembers:
        r.req('cumulative_snowfall_10to1_band_members', listOf(asInt)),
  );
}

/// What a day's precipitation summary shows.
final class PrecipDisplay {
  /// Creates a [PrecipDisplay].
  PrecipDisplay({
    required this.kind,
    required this.chance,
    this.amount,
    this.snowAmount,
  });

  /// Decodes a [PrecipDisplay] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PrecipDisplay.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPrecipDisplay);

  /// The `kind` field.
  final PrecipKind kind;

  /// The `chance` field.
  final double chance;

  /// Absent with `kind` `none`.
  final double? amount;

  /// The day's snowfall to show (the mean of `total_snowfall`).
  final double? snowAmount;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['kind'] = kind.value;
    out['chance'] = chance;
    if (amount case final v?) {
      out['amount'] = v;
    }
    if (snowAmount case final v?) {
      out['snow_amount'] = v;
    }
    return out;
  }
}

PrecipDisplay _readPrecipDisplay(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PrecipDisplay(
    kind: r.req('kind', enumOf(PrecipKind.new)),
    chance: r.req('chance', asDouble),
    amount: r.opt('amount', asDouble),
    snowAmount: r.opt('snow_amount', asDouble),
  );
}

/// Rolling liquid-equivalent totals over the same windows as `snow_outlook`.
///
/// For places where rain is the story (the favorites cards' "0.6 in rain" with
/// its range).
final class PrecipOutlook {
  /// Creates a [PrecipOutlook].
  PrecipOutlook({
    this.next24h,
    this.next48h,
    this.next72h,
    this.next7d,
    this.quantiles,
  });

  /// Decodes a [PrecipOutlook] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PrecipOutlook.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPrecipOutlook);

  /// Sum of the hourly precipitation means over the 24 h from the first served
  /// hour; `null` when not covered.
  final double? next24h;

  /// The same over 48 h.
  final double? next48h;

  /// The same over 72 h.
  final double? next72h;

  /// The same over 168 h.
  final double? next7d;

  /// The RANGE of each `snow_outlook` window's snowfall total, on the default
  /// response (no `members` needed) and on every
  /// `elevation_forecasts[].snow_outlook`.
  final SnowOutlookQuantiles? quantiles;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (next24h case final v?) {
      out['next_24h'] = v;
    }
    if (next48h case final v?) {
      out['next_48h'] = v;
    }
    if (next72h case final v?) {
      out['next_72h'] = v;
    }
    if (next7d case final v?) {
      out['next_7d'] = v;
    }
    if (quantiles case final v?) {
      out['quantiles'] = v.toJson();
    }
    return out;
  }
}

PrecipOutlook _readPrecipOutlook(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PrecipOutlook(
    next24h: r.opt('next_24h', asDouble),
    next48h: r.opt('next_48h', asDouble),
    next72h: r.opt('next_72h', asDouble),
    next7d: r.opt('next_7d', asDouble),
    quantiles: r.opt('quantiles', _readSnowOutlookQuantiles),
  );
}

/// An hour's most likely precipitation type and its chances.
final class PrecipType {
  /// Creates a [PrecipType].
  PrecipType({
    required this.type,
    required this.snowProbability,
    required this.rainProbability,
  });

  /// Decodes a [PrecipType] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PrecipType.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPrecipType);

  /// The most likely phase, read off `snow_probability`: `snow` from 0.60 (and
  /// at most 2 °C) -- where snow is at least twice as likely as rain in six
  /// winters of precipitation-type reports -- `rain_snow_mix` strictly between
  /// 0 and 0.60 (either phase substantially likely; not necessarily both
  /// falling), `rain` or `freezing_rain` at 0.
  final PrecipitationType type;

  /// Share of the hour's precipitation that falls as snow (0-1): the melting
  /// layer's snow fraction at the location (0 at and below the snow level, 1
  /// from about 127 m above it, linear in melting energy between) times the
  /// surface snow share — all snow at or below 2 °C air temperature, none at or
  /// above 4 °C, and the surface wet-bulb fade (none at or above 2 °C
  /// wet-bulb).
  final double snowProbability;

  /// `1 - snow_probability` (0-1).
  final double rainProbability;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['type'] = type.value;
    out['snow_probability'] = snowProbability;
    out['rain_probability'] = rainProbability;
    return out;
  }
}

PrecipType _readPrecipType(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PrecipType(
    type: r.req('type', enumOf(PrecipitationType.new)),
    snowProbability: r.req('snow_probability', asDouble),
    rainProbability: r.req('rain_probability', asDouble),
  );
}

/// This hour's headline precipitation.
///
/// (`ensemble.precipitation.mean`) split by phase, in the precipitation units
/// -- `rain + snow + rain_snow_mix + freezing_rain` is the hour's mean (to the
/// served precision), so a stacked bar is the headline bar.
final class PrecipitationByType {
  /// Creates a [PrecipitationByType].
  PrecipitationByType({
    required this.rain,
    required this.snow,
    required this.rainSnowMix,
    required this.freezingRain,
  });

  /// Decodes a [PrecipitationByType] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PrecipitationByType.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPrecipitationByType);

  /// The `rain` field.
  final double rain;

  /// The liquid that falls as snow (not snow depth; that is
  /// `ensemble.snowfall`).
  final double snow;

  /// The `rain_snow_mix` field.
  final double rainSnowMix;

  /// -- liquid that freezes on contact (counted in `rain` before).
  final double freezingRain;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['rain'] = rain;
    out['snow'] = snow;
    out['rain_snow_mix'] = rainSnowMix;
    out['freezing_rain'] = freezingRain;
    return out;
  }
}

PrecipitationByType _readPrecipitationByType(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PrecipitationByType(
    rain: r.req('rain', asDouble),
    snow: r.req('snow', asDouble),
    rainSnowMix: r.req('rain_snow_mix', asDouble),
    freezingRain: r.req('freezing_rain', asDouble),
  );
}

/// One answered probability term, with its full reference class.
final class ProbabilityResult {
  /// Creates a [ProbabilityResult].
  ProbabilityResult({
    required this.term,
    required this.variable,
    required this.op,
    required this.threshold,
    required this.windowStartHours,
    required this.windowEndHours,
    required this.aggregation,
    this.from,
    this.to,
    this.value,
    required this.members,
    this.nullReason,
  });

  /// Decodes a [ProbabilityResult] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ProbabilityResult.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readProbabilityResult);

  /// The canonical term the SDK sent (`"snowfall:ge:6.000:24h"`); the SDK
  /// matches each result to the caller's term by it.
  final String term;

  /// The variable asked about.
  final Variable variable;

  /// `ge` or `le`.
  final Op op;

  /// In the request's units, at the variable's served precision.
  final double threshold;

  /// The window's first hour.
  final int windowStartHours;

  /// The window's end hour.
  final int windowEndHours;

  /// How the window's hours were combined.
  final Aggregation aggregation;

  /// The window's first instant (JSON `from`).
  final DateTime? from;

  /// The window's end (exclusive).
  final DateTime? to;

  /// (JSON `probability`) The share of members meeting the term, 0..1 (0.001);
  /// `null` when the served series does not reach the window's end or carries
  /// no members (`hourly=false`).
  final double? value;

  /// The members that voted.
  final int members;

  /// Why `value` is `null`; `null` otherwise.
  final NullReason? nullReason;

  Chance? _request;

  /// The [Chance] this answers, as the caller wrote it (`null` when the
  /// result was decoded on its own).
  Chance? get request => _request;

  /// The window as a [Window].
  Window get window => Window(windowStartHours, windowEndHours);

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['term'] = term;
    out['variable'] = variable.value;
    out['op'] = op.value;
    out['threshold'] = threshold;
    out['window_start_hours'] = windowStartHours;
    out['window_end_hours'] = windowEndHours;
    out['aggregation'] = aggregation.value;
    if (from case final v?) {
      out['from'] = formatDateTime(v);
    }
    if (to case final v?) {
      out['to'] = formatDateTime(v);
    }
    if (value case final v?) {
      out['probability'] = v;
    }
    out['members'] = members;
    if (nullReason case final v?) {
      out['null_reason'] = v.value;
    }
    return out;
  }
}

ProbabilityResult _readProbabilityResult(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ProbabilityResult(
    term: r.req('term', asString),
    variable: r.req('variable', enumOf(Variable.new)),
    op: r.req('op', enumOf(Op.new)),
    threshold: r.req('threshold', asDouble),
    windowStartHours: r.req('window_start_hours', asInt),
    windowEndHours: r.req('window_end_hours', asInt),
    aggregation: r.req('aggregation', enumOf(Aggregation.new)),
    from: r.opt('from', asDateTime),
    to: r.opt('to', asDateTime),
    value: r.opt('probability', asDouble),
    members: r.req('members', asInt),
    nullReason: r.opt('null_reason', enumOf(NullReason.new)),
  );
}

/// The thresholds behind the headline probabilities, in the request's units.
final class ProbabilityThresholds {
  /// Creates a [ProbabilityThresholds].
  ProbabilityThresholds({
    required this.hourlyPrecipitation,
    required this.hourlySnowfall,
    required this.dailyPrecipitation,
    required this.dailyPrecipitationOccurrence,
    required this.dailySnow,
  });

  /// Decodes a [ProbabilityThresholds] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ProbabilityThresholds.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readProbabilityThresholds);

  /// `ensemble.precipitation.probability`'s threshold (0.254 mm).
  final double hourlyPrecipitation;

  /// `ensemble.snowfall.probability`'s snowfall threshold (0.254 mm).
  final double hourlySnowfall;

  /// (JSON `daily_precipitation_probability`)
  /// `daily[].precipitation_probability`'s day-total threshold (2.5 mm).
  final double dailyPrecipitation;

  /// (JSON `daily_precipitation_occurrence_probability`)
  /// `daily[].precipitation_occurrence_probability`'s threshold (1.0 mm), also
  /// the "if wet" condition.
  final double dailyPrecipitationOccurrence;

  /// (JSON `daily_snow_probability`) `daily[].snow_probability`'s day-snowfall
  /// threshold (2.5 mm).
  final double dailySnow;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['hourly_precipitation'] = hourlyPrecipitation;
    out['hourly_snowfall'] = hourlySnowfall;
    out['daily_precipitation_probability'] = dailyPrecipitation;
    out['daily_precipitation_occurrence_probability'] =
        dailyPrecipitationOccurrence;
    out['daily_snow_probability'] = dailySnow;
    return out;
  }
}

ProbabilityThresholds _readProbabilityThresholds(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ProbabilityThresholds(
    hourlyPrecipitation: r.req('hourly_precipitation', asDouble),
    hourlySnowfall: r.req('hourly_snowfall', asDouble),
    dailyPrecipitation: r.req('daily_precipitation_probability', asDouble),
    dailyPrecipitationOccurrence:
        r.req('daily_precipitation_occurrence_probability', asDouble),
    dailySnow: r.req('daily_snow_probability', asDouble),
  );
}

/// One named elevation in the catalog.
final class PublicCatalogElevation {
  /// Creates a [PublicCatalogElevation].
  PublicCatalogElevation({
    required this.label,
    this.displayName,
    required this.heightM,
    this.latOverride,
    this.lonOverride,
    required this.isDefault,
  });

  /// Decodes a [PublicCatalogElevation] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PublicCatalogElevation.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPublicCatalogElevation);

  /// The `label` field.
  final String label;

  /// What the place is called, for display.
  final String? displayName;

  /// (JSON `elevation_m`) Metres, to 0.1 m.
  final double heightM;

  /// To 5 decimals.
  final double? latOverride;

  /// To 5 decimals.
  final double? lonOverride;

  /// Whether this is the default elevation to show in the UI.
  final bool isDefault;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['label'] = label;
    if (displayName case final v?) {
      out['display_name'] = v;
    }
    out['elevation_m'] = heightM;
    if (latOverride case final v?) {
      out['lat_override'] = v;
    }
    if (lonOverride case final v?) {
      out['lon_override'] = v;
    }
    out['is_default'] = isDefault;
    return out;
  }
}

PublicCatalogElevation _readPublicCatalogElevation(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PublicCatalogElevation(
    label: r.req('label', asString),
    displayName: r.opt('display_name', asString),
    heightM: r.req('elevation_m', asDouble),
    latOverride: r.opt('lat_override', asDouble),
    lonOverride: r.opt('lon_override', asDouble),
    isDefault: r.req('is_default', asBool),
  );
}

/// A catalog location with its public content.
final class PublicCatalogLocation implements NamedLocation {
  /// Creates a [PublicCatalogLocation].
  PublicCatalogLocation({
    this.slug,
    required this.state,
    required this.name,
    required this.lat,
    required this.lon,
    required this.elevationM,
    this.type,
    required this.timezone,
    this.county,
    this.country,
    this.aliases,
    this.descriptionShort,
    this.descriptionLong,
    this.microclimateNotes,
    this.metaTitle,
    this.metaDescription,
    this.bestSeasons,
    this.keyFactors,
    this.tags,
    this.externalLinks,
    this.isFeatured,
  });

  /// Decodes a [PublicCatalogLocation] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PublicCatalogLocation.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPublicCatalogLocation);

  /// The location's key: its catalog slug.
  @override
  final String? slug;

  /// The lowercase USPS state code.
  @override
  final String state;

  /// The display name.
  final String name;

  /// The `lat` field.
  final double lat;

  /// The `lon` field.
  final double lon;

  /// Elevation in metres, whatever `units` is (0.1 m).
  final double elevationM;

  /// The primary location type, snake_case.
  final LocationType? type;

  /// The IANA zone the location's local days and hours are kept in -- the zone
  /// `daily` dates, sunrise and sunset are computed in.
  final String timezone;

  /// The `county` field.
  final String? county;

  /// The `country` field.
  final String? country;

  /// The `aliases` field.
  final List<String>? aliases;

  /// The `description_short` field.
  final String? descriptionShort;

  /// The `description_long` field.
  final String? descriptionLong;

  /// The `microclimate_notes` field.
  final String? microclimateNotes;

  /// The `meta_title` field.
  final String? metaTitle;

  /// The `meta_description` field.
  final String? metaDescription;

  /// The `best_seasons` field.
  final List<String>? bestSeasons;

  /// The `key_factors` field.
  final List<String>? keyFactors;

  /// The `tags` field.
  final List<String>? tags;

  /// Free-form JSON of labelled links.
  final Object? externalLinks;

  /// The `is_featured` field.
  final bool? isFeatured;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (slug case final v?) {
      out['slug'] = v;
    }
    out['state'] = state;
    out['name'] = name;
    out['lat'] = lat;
    out['lon'] = lon;
    out['elevation_m'] = elevationM;
    if (type case final v?) {
      out['type'] = v.value;
    }
    out['timezone'] = timezone;
    if (county case final v?) {
      out['county'] = v;
    }
    if (country case final v?) {
      out['country'] = v;
    }
    if (aliases case final v?) {
      out['aliases'] = v;
    }
    if (descriptionShort case final v?) {
      out['description_short'] = v;
    }
    if (descriptionLong case final v?) {
      out['description_long'] = v;
    }
    if (microclimateNotes case final v?) {
      out['microclimate_notes'] = v;
    }
    if (metaTitle case final v?) {
      out['meta_title'] = v;
    }
    if (metaDescription case final v?) {
      out['meta_description'] = v;
    }
    if (bestSeasons case final v?) {
      out['best_seasons'] = v;
    }
    if (keyFactors case final v?) {
      out['key_factors'] = v;
    }
    if (tags case final v?) {
      out['tags'] = v;
    }
    if (externalLinks != null) {
      out['external_links'] = externalLinks;
    }
    if (isFeatured case final v?) {
      out['is_featured'] = v;
    }
    return out;
  }
}

PublicCatalogLocation _readPublicCatalogLocation(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PublicCatalogLocation(
    slug: r.opt('slug', asString),
    state: r.req('state', asString),
    name: r.req('name', asString),
    lat: r.req('lat', asDouble),
    lon: r.req('lon', asDouble),
    elevationM: r.req('elevation_m', asDouble),
    type: r.opt('type', enumOf(LocationType.new)),
    timezone: r.req('timezone', asString),
    county: r.opt('county', asString),
    country: r.opt('country', asString),
    aliases: r.opt('aliases', listOf(asString)),
    descriptionShort: r.opt('description_short', asString),
    descriptionLong: r.opt('description_long', asString),
    microclimateNotes: r.opt('microclimate_notes', asString),
    metaTitle: r.opt('meta_title', asString),
    metaDescription: r.opt('meta_description', asString),
    bestSeasons: r.opt('best_seasons', listOf(asString)),
    keyFactors: r.opt('key_factors', listOf(asString)),
    tags: r.opt('tags', listOf(asString)),
    externalLinks: r.any('external_links'),
    isFeatured: r.opt('is_featured', asBool),
  );
}

/// A catalog location with its elevations, media and nearby stations.
final class PublicCatalogLocationDetail extends Response
    implements NamedLocation {
  /// Creates a [PublicCatalogLocationDetail].
  PublicCatalogLocationDetail({
    this.slug,
    required this.state,
    required this.name,
    required this.lat,
    required this.lon,
    required this.elevationM,
    this.type,
    required this.timezone,
    this.county,
    this.country,
    this.aliases,
    this.descriptionShort,
    this.descriptionLong,
    this.microclimateNotes,
    this.metaTitle,
    this.metaDescription,
    this.bestSeasons,
    this.keyFactors,
    this.tags,
    this.externalLinks,
    this.isFeatured,
    required this.elevations,
    required this.photos,
    required this.webcams,
    required this.nearbyStations,
    this.template,
    this.content,
  });

  /// Decodes a [PublicCatalogLocationDetail] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PublicCatalogLocationDetail.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPublicCatalogLocationDetail);

  /// The location's key: its catalog slug.
  @override
  final String? slug;

  /// The lowercase USPS state code.
  @override
  final String state;

  /// The display name.
  final String name;

  /// The `lat` field.
  final double lat;

  /// The `lon` field.
  final double lon;

  /// Elevation in metres, whatever `units` is (0.1 m).
  final double elevationM;

  /// The primary location type, snake_case.
  final LocationType? type;

  /// The IANA zone the location's local days and hours are kept in -- the zone
  /// `daily` dates, sunrise and sunset are computed in.
  final String timezone;

  /// The `county` field.
  final String? county;

  /// The `country` field.
  final String? country;

  /// The `aliases` field.
  final List<String>? aliases;

  /// The `description_short` field.
  final String? descriptionShort;

  /// The `description_long` field.
  final String? descriptionLong;

  /// The `microclimate_notes` field.
  final String? microclimateNotes;

  /// The `meta_title` field.
  final String? metaTitle;

  /// The `meta_description` field.
  final String? metaDescription;

  /// The `best_seasons` field.
  final List<String>? bestSeasons;

  /// The `key_factors` field.
  final List<String>? keyFactors;

  /// The `tags` field.
  final List<String>? tags;

  /// Free-form JSON of labelled links.
  final Object? externalLinks;

  /// The `is_featured` field.
  final bool? isFeatured;

  /// The `elevations` field.
  final List<PublicCatalogElevation> elevations;

  /// Photo with the storage backend already resolved to a single public `url`
  /// (GCS object or external link).
  final List<PublicCatalogPhoto> photos;

  /// The `webcams` field.
  final List<PublicCatalogWebcam> webcams;

  /// Inlined summary of a station near a catalog location — enough to render a
  /// list; full detail requires a follow-up GET against
  /// `/api/v1/catalog/stations/{slug}`.
  final List<PublicCatalogNearbyStation> nearbyStations;

  /// The resolved page template as the public API serves it — identity + scope
  /// + spec; editorial audit fields stay internal.
  final CatalogTemplateSummary? template;

  /// One published content entry as the public catalog detail serves it: entry
  /// fields + the attachment's slot/order + which locale the read path actually
  /// resolved.
  final List<CatalogResolvedEntry>? content;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (slug case final v?) {
      out['slug'] = v;
    }
    out['state'] = state;
    out['name'] = name;
    out['lat'] = lat;
    out['lon'] = lon;
    out['elevation_m'] = elevationM;
    if (type case final v?) {
      out['type'] = v.value;
    }
    out['timezone'] = timezone;
    if (county case final v?) {
      out['county'] = v;
    }
    if (country case final v?) {
      out['country'] = v;
    }
    if (aliases case final v?) {
      out['aliases'] = v;
    }
    if (descriptionShort case final v?) {
      out['description_short'] = v;
    }
    if (descriptionLong case final v?) {
      out['description_long'] = v;
    }
    if (microclimateNotes case final v?) {
      out['microclimate_notes'] = v;
    }
    if (metaTitle case final v?) {
      out['meta_title'] = v;
    }
    if (metaDescription case final v?) {
      out['meta_description'] = v;
    }
    if (bestSeasons case final v?) {
      out['best_seasons'] = v;
    }
    if (keyFactors case final v?) {
      out['key_factors'] = v;
    }
    if (tags case final v?) {
      out['tags'] = v;
    }
    if (externalLinks != null) {
      out['external_links'] = externalLinks;
    }
    if (isFeatured case final v?) {
      out['is_featured'] = v;
    }
    out['elevations'] = [for (final e in elevations) e.toJson()];
    out['photos'] = [for (final e in photos) e.toJson()];
    out['webcams'] = [for (final e in webcams) e.toJson()];
    out['nearby_stations'] = [for (final e in nearbyStations) e.toJson()];
    if (template case final v?) {
      out['template'] = v.toJson();
    }
    if (content case final v?) {
      out['content'] = [for (final e in v) e.toJson()];
    }
    return out;
  }
}

PublicCatalogLocationDetail _readPublicCatalogLocationDetail(
    Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PublicCatalogLocationDetail(
    slug: r.opt('slug', asString),
    state: r.req('state', asString),
    name: r.req('name', asString),
    lat: r.req('lat', asDouble),
    lon: r.req('lon', asDouble),
    elevationM: r.req('elevation_m', asDouble),
    type: r.opt('type', enumOf(LocationType.new)),
    timezone: r.req('timezone', asString),
    county: r.opt('county', asString),
    country: r.opt('country', asString),
    aliases: r.opt('aliases', listOf(asString)),
    descriptionShort: r.opt('description_short', asString),
    descriptionLong: r.opt('description_long', asString),
    microclimateNotes: r.opt('microclimate_notes', asString),
    metaTitle: r.opt('meta_title', asString),
    metaDescription: r.opt('meta_description', asString),
    bestSeasons: r.opt('best_seasons', listOf(asString)),
    keyFactors: r.opt('key_factors', listOf(asString)),
    tags: r.opt('tags', listOf(asString)),
    externalLinks: r.any('external_links'),
    isFeatured: r.opt('is_featured', asBool),
    elevations: r.req('elevations', listOf(_readPublicCatalogElevation)),
    photos: r.req('photos', listOf(_readPublicCatalogPhoto)),
    webcams: r.req('webcams', listOf(_readPublicCatalogWebcam)),
    nearbyStations:
        r.req('nearby_stations', listOf(_readPublicCatalogNearbyStation)),
    template: r.opt('template', _readCatalogTemplateSummary),
    content: r.opt('content', listOf(_readCatalogResolvedEntry)),
  );
}

/// One page of the location catalog. `next_cursor` is `null` on the last.
final class PublicCatalogLocationPage extends Response {
  /// Creates a [PublicCatalogLocationPage].
  PublicCatalogLocationPage({
    required this.items,
    this.nextCursor,
  });

  /// Decodes a [PublicCatalogLocationPage] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PublicCatalogLocationPage.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPublicCatalogLocationPage);

  /// A catalog location's PUBLIC projection -- the one [LocationRef] plus the
  /// catalog's public content, by an allowlist: the CMS internals (row ids,
  /// `created_by`, `updated_by`, `created_at`, `updated_at`, `deleted_at`,
  /// `is_published`, `enrichment_tier`, `view_count_*`, `template_variant`) are
  /// not served.
  final List<PublicCatalogLocation> items;

  /// Pass as `?cursor=` for the next page; null at the end.
  final String? nextCursor;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['items'] = [for (final e in items) e.toJson()];
    if (nextCursor case final v?) {
      out['next_cursor'] = v;
    }
    return out;
  }
}

PublicCatalogLocationPage _readPublicCatalogLocationPage(
    Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PublicCatalogLocationPage(
    items: r.req('items', listOf(_readPublicCatalogLocation)),
    nextCursor: r.opt('next_cursor', asString),
  );
}

/// An observing station near a catalog location.
final class PublicCatalogNearbyStation {
  /// Creates a [PublicCatalogNearbyStation].
  PublicCatalogNearbyStation({
    required this.slug,
    required this.name,
    required this.network,
    required this.status,
    this.distanceKm,
    this.elevationDiffM,
    required this.isPrimary,
  });

  /// Decodes a [PublicCatalogNearbyStation] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PublicCatalogNearbyStation.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPublicCatalogNearbyStation);

  /// The `slug` field.
  final String slug;

  /// The `name` field.
  final String name;

  /// Observation network, snake_case (was the CMS enum's `Snotel`).
  final StationNetwork network;

  /// (JSON `station_status`) Live-feed status, snake_case (was `Active`).
  final StationStatus status;

  /// The `distance_km` field.
  final double? distanceKm;

  /// The `elevation_diff_m` field.
  final double? elevationDiffM;

  /// The `is_primary` field.
  final bool isPrimary;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['slug'] = slug;
    out['name'] = name;
    out['network'] = network.value;
    out['station_status'] = status.value;
    if (distanceKm case final v?) {
      out['distance_km'] = v;
    }
    if (elevationDiffM case final v?) {
      out['elevation_diff_m'] = v;
    }
    out['is_primary'] = isPrimary;
    return out;
  }
}

PublicCatalogNearbyStation _readPublicCatalogNearbyStation(
    Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PublicCatalogNearbyStation(
    slug: r.req('slug', asString),
    name: r.req('name', asString),
    network: r.req('network', enumOf(StationNetwork.new)),
    status: r.req('station_status', enumOf(StationStatus.new)),
    distanceKm: r.opt('distance_km', asDouble),
    elevationDiffM: r.opt('elevation_diff_m', asDouble),
    isPrimary: r.req('is_primary', asBool),
  );
}

/// A catalog photo and its licence.
final class PublicCatalogPhoto {
  /// Creates a [PublicCatalogPhoto].
  PublicCatalogPhoto({
    required this.url,
    this.caption,
    this.credit,
    this.altText,
    this.license,
    this.licenseUrl,
  });

  /// Decodes a [PublicCatalogPhoto] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PublicCatalogPhoto.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPublicCatalogPhoto);

  /// The `url` field.
  final String url;

  /// The `caption` field.
  final String? caption;

  /// The `credit` field.
  final String? credit;

  /// The `alt_text` field.
  final String? altText;

  /// The `license` field.
  final String? license;

  /// The `license_url` field.
  final String? licenseUrl;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['url'] = url;
    if (caption case final v?) {
      out['caption'] = v;
    }
    if (credit case final v?) {
      out['credit'] = v;
    }
    if (altText case final v?) {
      out['alt_text'] = v;
    }
    if (license case final v?) {
      out['license'] = v;
    }
    if (licenseUrl case final v?) {
      out['license_url'] = v;
    }
    return out;
  }
}

PublicCatalogPhoto _readPublicCatalogPhoto(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PublicCatalogPhoto(
    url: r.req('url', asString),
    caption: r.opt('caption', asString),
    credit: r.opt('credit', asString),
    altText: r.opt('alt_text', asString),
    license: r.opt('license', asString),
    licenseUrl: r.opt('license_url', asString),
  );
}

/// The location a station primarily serves.
final class PublicCatalogPrimaryLocation {
  /// Creates a [PublicCatalogPrimaryLocation].
  PublicCatalogPrimaryLocation({
    required this.slug,
    required this.name,
    required this.lat,
    required this.lon,
    required this.elevationM,
    required this.type,
  });

  /// Decodes a [PublicCatalogPrimaryLocation] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PublicCatalogPrimaryLocation.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPublicCatalogPrimaryLocation);

  /// The `slug` field.
  final String slug;

  /// The `name` field.
  final String name;

  /// The `lat` field.
  final double lat;

  /// The `lon` field.
  final double lon;

  /// The `elevation_m` field.
  final double elevationM;

  /// The `type` field.
  final String type;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['slug'] = slug;
    out['name'] = name;
    out['lat'] = lat;
    out['lon'] = lon;
    out['elevation_m'] = elevationM;
    out['type'] = type;
    return out;
  }
}

PublicCatalogPrimaryLocation _readPublicCatalogPrimaryLocation(
    Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PublicCatalogPrimaryLocation(
    slug: r.req('slug', asString),
    name: r.req('name', asString),
    lat: r.req('lat', asDouble),
    lon: r.req('lon', asDouble),
    elevationM: r.req('elevation_m', asDouble),
    type: r.req('type', asString),
  );
}

/// A catalog observing station.
final class PublicCatalogStation implements NamedLocation {
  /// Creates a [PublicCatalogStation].
  PublicCatalogStation({
    this.slug,
    required this.state,
    required this.name,
    required this.lat,
    required this.lon,
    required this.elevationM,
    this.type,
    required this.timezone,
    this.county,
    this.country,
    this.aliases,
    this.network,
    this.sourceId,
    this.elevationMslM,
    this.sensorHeightAglM,
    this.sensorCapabilities,
    this.status,
    this.lastReportAt,
    this.lastReportSummary,
    this.installDate,
    this.decommissionDate,
    this.updateFrequencyMinutes,
    this.url,
    this.dataUrl,
    this.descriptionShort,
    this.descriptionLong,
    this.metaTitle,
    this.metaDescription,
    this.tags,
    this.isFeatured,
  });

  /// Decodes a [PublicCatalogStation] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PublicCatalogStation.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPublicCatalogStation);

  /// The location's key: its catalog slug.
  @override
  final String? slug;

  /// The lowercase USPS state code.
  @override
  final String state;

  /// The display name.
  final String name;

  /// The `lat` field.
  final double lat;

  /// The `lon` field.
  final double lon;

  /// Elevation in metres, whatever `units` is (0.1 m).
  final double elevationM;

  /// The primary location type, snake_case.
  final LocationType? type;

  /// The IANA zone the location's local days and hours are kept in -- the zone
  /// `daily` dates, sunrise and sunset are computed in.
  final String timezone;

  /// The `county` field.
  final String? county;

  /// The `country` field.
  final String? country;

  /// The `aliases` field.
  final List<String>? aliases;

  /// Observation network, snake_case (was the CMS enum's `Snotel`).
  final StationNetwork? network;

  /// (JSON `source_station_id`)
  final String? sourceId;

  /// The `elevation_msl_m` field.
  final double? elevationMslM;

  /// The `sensor_height_agl_m` field.
  final double? sensorHeightAglM;

  /// The `sensor_capabilities` field.
  final List<String>? sensorCapabilities;

  /// (JSON `station_status`) Live-feed status, snake_case (was `Active`).
  final StationStatus? status;

  /// The `last_report_at` field.
  final DateTime? lastReportAt;

  /// Free-form JSON of the last report.
  final Object? lastReportSummary;

  /// The `install_date` field.
  final DateTime? installDate;

  /// The `decommission_date` field.
  final DateTime? decommissionDate;

  /// The `update_frequency_minutes` field.
  final int? updateFrequencyMinutes;

  /// (JSON `station_url`)
  final String? url;

  /// The `data_url` field.
  final String? dataUrl;

  /// The `description_short` field.
  final String? descriptionShort;

  /// The `description_long` field.
  final String? descriptionLong;

  /// The `meta_title` field.
  final String? metaTitle;

  /// The `meta_description` field.
  final String? metaDescription;

  /// The `tags` field.
  final List<String>? tags;

  /// The `is_featured` field.
  final bool? isFeatured;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (slug case final v?) {
      out['slug'] = v;
    }
    out['state'] = state;
    out['name'] = name;
    out['lat'] = lat;
    out['lon'] = lon;
    out['elevation_m'] = elevationM;
    if (type case final v?) {
      out['type'] = v.value;
    }
    out['timezone'] = timezone;
    if (county case final v?) {
      out['county'] = v;
    }
    if (country case final v?) {
      out['country'] = v;
    }
    if (aliases case final v?) {
      out['aliases'] = v;
    }
    if (network case final v?) {
      out['network'] = v.value;
    }
    if (sourceId case final v?) {
      out['source_station_id'] = v;
    }
    if (elevationMslM case final v?) {
      out['elevation_msl_m'] = v;
    }
    if (sensorHeightAglM case final v?) {
      out['sensor_height_agl_m'] = v;
    }
    if (sensorCapabilities case final v?) {
      out['sensor_capabilities'] = v;
    }
    if (status case final v?) {
      out['station_status'] = v.value;
    }
    if (lastReportAt case final v?) {
      out['last_report_at'] = formatDateTime(v);
    }
    if (lastReportSummary != null) {
      out['last_report_summary'] = lastReportSummary;
    }
    if (installDate case final v?) {
      out['install_date'] = formatDate(v);
    }
    if (decommissionDate case final v?) {
      out['decommission_date'] = formatDate(v);
    }
    if (updateFrequencyMinutes case final v?) {
      out['update_frequency_minutes'] = v;
    }
    if (url case final v?) {
      out['station_url'] = v;
    }
    if (dataUrl case final v?) {
      out['data_url'] = v;
    }
    if (descriptionShort case final v?) {
      out['description_short'] = v;
    }
    if (descriptionLong case final v?) {
      out['description_long'] = v;
    }
    if (metaTitle case final v?) {
      out['meta_title'] = v;
    }
    if (metaDescription case final v?) {
      out['meta_description'] = v;
    }
    if (tags case final v?) {
      out['tags'] = v;
    }
    if (isFeatured case final v?) {
      out['is_featured'] = v;
    }
    return out;
  }
}

PublicCatalogStation _readPublicCatalogStation(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PublicCatalogStation(
    slug: r.opt('slug', asString),
    state: r.req('state', asString),
    name: r.req('name', asString),
    lat: r.req('lat', asDouble),
    lon: r.req('lon', asDouble),
    elevationM: r.req('elevation_m', asDouble),
    type: r.opt('type', enumOf(LocationType.new)),
    timezone: r.req('timezone', asString),
    county: r.opt('county', asString),
    country: r.opt('country', asString),
    aliases: r.opt('aliases', listOf(asString)),
    network: r.opt('network', enumOf(StationNetwork.new)),
    sourceId: r.opt('source_station_id', asString),
    elevationMslM: r.opt('elevation_msl_m', asDouble),
    sensorHeightAglM: r.opt('sensor_height_agl_m', asDouble),
    sensorCapabilities: r.opt('sensor_capabilities', listOf(asString)),
    status: r.opt('station_status', enumOf(StationStatus.new)),
    lastReportAt: r.opt('last_report_at', asDateTime),
    lastReportSummary: r.any('last_report_summary'),
    installDate: r.opt('install_date', asDate),
    decommissionDate: r.opt('decommission_date', asDate),
    updateFrequencyMinutes: r.opt('update_frequency_minutes', asInt),
    url: r.opt('station_url', asString),
    dataUrl: r.opt('data_url', asString),
    descriptionShort: r.opt('description_short', asString),
    descriptionLong: r.opt('description_long', asString),
    metaTitle: r.opt('meta_title', asString),
    metaDescription: r.opt('meta_description', asString),
    tags: r.opt('tags', listOf(asString)),
    isFeatured: r.opt('is_featured', asBool),
  );
}

/// A catalog station with its media and primary location.
final class PublicCatalogStationDetail extends Response
    implements NamedLocation {
  /// Creates a [PublicCatalogStationDetail].
  PublicCatalogStationDetail({
    this.slug,
    required this.state,
    required this.name,
    required this.lat,
    required this.lon,
    required this.elevationM,
    this.type,
    required this.timezone,
    this.county,
    this.country,
    this.aliases,
    this.network,
    this.sourceId,
    this.elevationMslM,
    this.sensorHeightAglM,
    this.sensorCapabilities,
    this.status,
    this.lastReportAt,
    this.lastReportSummary,
    this.installDate,
    this.decommissionDate,
    this.updateFrequencyMinutes,
    this.url,
    this.dataUrl,
    this.descriptionShort,
    this.descriptionLong,
    this.metaTitle,
    this.metaDescription,
    this.tags,
    this.isFeatured,
    required this.photos,
    required this.webcams,
    this.indexable,
    this.primaryLocation,
    this.template,
    this.content,
  });

  /// Decodes a [PublicCatalogStationDetail] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PublicCatalogStationDetail.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPublicCatalogStationDetail);

  /// The location's key: its catalog slug.
  @override
  final String? slug;

  /// The lowercase USPS state code.
  @override
  final String state;

  /// The display name.
  final String name;

  /// The `lat` field.
  final double lat;

  /// The `lon` field.
  final double lon;

  /// Elevation in metres, whatever `units` is (0.1 m).
  final double elevationM;

  /// The primary location type, snake_case.
  final LocationType? type;

  /// The IANA zone the location's local days and hours are kept in -- the zone
  /// `daily` dates, sunrise and sunset are computed in.
  final String timezone;

  /// The `county` field.
  final String? county;

  /// The `country` field.
  final String? country;

  /// The `aliases` field.
  final List<String>? aliases;

  /// Observation network, snake_case (was the CMS enum's `Snotel`).
  final StationNetwork? network;

  /// (JSON `source_station_id`)
  final String? sourceId;

  /// The `elevation_msl_m` field.
  final double? elevationMslM;

  /// The `sensor_height_agl_m` field.
  final double? sensorHeightAglM;

  /// The `sensor_capabilities` field.
  final List<String>? sensorCapabilities;

  /// (JSON `station_status`) Live-feed status, snake_case (was `Active`).
  final StationStatus? status;

  /// The `last_report_at` field.
  final DateTime? lastReportAt;

  /// Free-form JSON of the last report.
  final Object? lastReportSummary;

  /// The `install_date` field.
  final DateTime? installDate;

  /// The `decommission_date` field.
  final DateTime? decommissionDate;

  /// The `update_frequency_minutes` field.
  final int? updateFrequencyMinutes;

  /// (JSON `station_url`)
  final String? url;

  /// The `data_url` field.
  final String? dataUrl;

  /// The `description_short` field.
  final String? descriptionShort;

  /// The `description_long` field.
  final String? descriptionLong;

  /// The `meta_title` field.
  final String? metaTitle;

  /// The `meta_description` field.
  final String? metaDescription;

  /// The `tags` field.
  final List<String>? tags;

  /// The `is_featured` field.
  final bool? isFeatured;

  /// Photo with the storage backend already resolved to a single public `url`
  /// (GCS object or external link).
  final List<PublicCatalogPhoto> photos;

  /// The `webcams` field.
  final List<PublicCatalogWebcam> webcams;

  /// Whether search engines should index this station's page.
  final bool? indexable;

  /// A station's parent location, by reference.
  final PublicCatalogPrimaryLocation? primaryLocation;

  /// The resolved page template as the public API serves it — identity + scope
  /// + spec; editorial audit fields stay internal.
  final CatalogTemplateSummary? template;

  /// One published content entry as the public catalog detail serves it: entry
  /// fields + the attachment's slot/order + which locale the read path actually
  /// resolved.
  final List<CatalogResolvedEntry>? content;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (slug case final v?) {
      out['slug'] = v;
    }
    out['state'] = state;
    out['name'] = name;
    out['lat'] = lat;
    out['lon'] = lon;
    out['elevation_m'] = elevationM;
    if (type case final v?) {
      out['type'] = v.value;
    }
    out['timezone'] = timezone;
    if (county case final v?) {
      out['county'] = v;
    }
    if (country case final v?) {
      out['country'] = v;
    }
    if (aliases case final v?) {
      out['aliases'] = v;
    }
    if (network case final v?) {
      out['network'] = v.value;
    }
    if (sourceId case final v?) {
      out['source_station_id'] = v;
    }
    if (elevationMslM case final v?) {
      out['elevation_msl_m'] = v;
    }
    if (sensorHeightAglM case final v?) {
      out['sensor_height_agl_m'] = v;
    }
    if (sensorCapabilities case final v?) {
      out['sensor_capabilities'] = v;
    }
    if (status case final v?) {
      out['station_status'] = v.value;
    }
    if (lastReportAt case final v?) {
      out['last_report_at'] = formatDateTime(v);
    }
    if (lastReportSummary != null) {
      out['last_report_summary'] = lastReportSummary;
    }
    if (installDate case final v?) {
      out['install_date'] = formatDate(v);
    }
    if (decommissionDate case final v?) {
      out['decommission_date'] = formatDate(v);
    }
    if (updateFrequencyMinutes case final v?) {
      out['update_frequency_minutes'] = v;
    }
    if (url case final v?) {
      out['station_url'] = v;
    }
    if (dataUrl case final v?) {
      out['data_url'] = v;
    }
    if (descriptionShort case final v?) {
      out['description_short'] = v;
    }
    if (descriptionLong case final v?) {
      out['description_long'] = v;
    }
    if (metaTitle case final v?) {
      out['meta_title'] = v;
    }
    if (metaDescription case final v?) {
      out['meta_description'] = v;
    }
    if (tags case final v?) {
      out['tags'] = v;
    }
    if (isFeatured case final v?) {
      out['is_featured'] = v;
    }
    out['photos'] = [for (final e in photos) e.toJson()];
    out['webcams'] = [for (final e in webcams) e.toJson()];
    if (indexable case final v?) {
      out['indexable'] = v;
    }
    if (primaryLocation case final v?) {
      out['primary_location'] = v.toJson();
    }
    if (template case final v?) {
      out['template'] = v.toJson();
    }
    if (content case final v?) {
      out['content'] = [for (final e in v) e.toJson()];
    }
    return out;
  }
}

PublicCatalogStationDetail _readPublicCatalogStationDetail(
    Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PublicCatalogStationDetail(
    slug: r.opt('slug', asString),
    state: r.req('state', asString),
    name: r.req('name', asString),
    lat: r.req('lat', asDouble),
    lon: r.req('lon', asDouble),
    elevationM: r.req('elevation_m', asDouble),
    type: r.opt('type', enumOf(LocationType.new)),
    timezone: r.req('timezone', asString),
    county: r.opt('county', asString),
    country: r.opt('country', asString),
    aliases: r.opt('aliases', listOf(asString)),
    network: r.opt('network', enumOf(StationNetwork.new)),
    sourceId: r.opt('source_station_id', asString),
    elevationMslM: r.opt('elevation_msl_m', asDouble),
    sensorHeightAglM: r.opt('sensor_height_agl_m', asDouble),
    sensorCapabilities: r.opt('sensor_capabilities', listOf(asString)),
    status: r.opt('station_status', enumOf(StationStatus.new)),
    lastReportAt: r.opt('last_report_at', asDateTime),
    lastReportSummary: r.any('last_report_summary'),
    installDate: r.opt('install_date', asDate),
    decommissionDate: r.opt('decommission_date', asDate),
    updateFrequencyMinutes: r.opt('update_frequency_minutes', asInt),
    url: r.opt('station_url', asString),
    dataUrl: r.opt('data_url', asString),
    descriptionShort: r.opt('description_short', asString),
    descriptionLong: r.opt('description_long', asString),
    metaTitle: r.opt('meta_title', asString),
    metaDescription: r.opt('meta_description', asString),
    tags: r.opt('tags', listOf(asString)),
    isFeatured: r.opt('is_featured', asBool),
    photos: r.req('photos', listOf(_readPublicCatalogPhoto)),
    webcams: r.req('webcams', listOf(_readPublicCatalogWebcam)),
    indexable: r.opt('indexable', asBool),
    primaryLocation:
        r.opt('primary_location', _readPublicCatalogPrimaryLocation),
    template: r.opt('template', _readCatalogTemplateSummary),
    content: r.opt('content', listOf(_readCatalogResolvedEntry)),
  );
}

/// One page of the station catalog. `next_cursor` is `null` on the last.
final class PublicCatalogStationPage extends Response {
  /// Creates a [PublicCatalogStationPage].
  PublicCatalogStationPage({
    required this.items,
    this.nextCursor,
  });

  /// Decodes a [PublicCatalogStationPage] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PublicCatalogStationPage.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPublicCatalogStationPage);

  /// A catalog station's PUBLIC projection -- the [LocationRef] fields
  /// (`type` is `observation_station`) plus the station's public facts, by an
  /// allowlist; the CMS internals are not served.
  final List<PublicCatalogStation> items;

  /// The `next_cursor` field.
  final String? nextCursor;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['items'] = [for (final e in items) e.toJson()];
    if (nextCursor case final v?) {
      out['next_cursor'] = v;
    }
    return out;
  }
}

PublicCatalogStationPage _readPublicCatalogStationPage(
    Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PublicCatalogStationPage(
    items: r.req('items', listOf(_readPublicCatalogStation)),
    nextCursor: r.opt('next_cursor', asString),
  );
}

/// A webcam at a catalog entry.
final class PublicCatalogWebcam {
  /// Creates a [PublicCatalogWebcam].
  PublicCatalogWebcam({
    required this.name,
    required this.url,
    this.embedType,
    this.provider,
    this.refreshIntervalSeconds,
  });

  /// Decodes a [PublicCatalogWebcam] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory PublicCatalogWebcam.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readPublicCatalogWebcam);

  /// The `name` field.
  final String name;

  /// The `url` field.
  final String url;

  /// The `embed_type` field.
  final String? embedType;

  /// The `provider` field.
  final String? provider;

  /// The `refresh_interval_seconds` field.
  final int? refreshIntervalSeconds;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['name'] = name;
    out['url'] = url;
    if (embedType case final v?) {
      out['embed_type'] = v;
    }
    if (provider case final v?) {
      out['provider'] = v;
    }
    if (refreshIntervalSeconds case final v?) {
      out['refresh_interval_seconds'] = v;
    }
    return out;
  }
}

PublicCatalogWebcam _readPublicCatalogWebcam(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return PublicCatalogWebcam(
    name: r.req('name', asString),
    url: r.req('url', asString),
    embedType: r.opt('embed_type', asString),
    provider: r.opt('provider', asString),
    refreshIntervalSeconds: r.opt('refresh_interval_seconds', asInt),
  );
}

/// A distribution over the ensemble's members, as the server computed it.
///
/// Every field is optional: a percentile the server did not send is `null`, not
/// `0`. Wind direction is not a `Quantiles` but a `CircularStats`.
final class Quantiles with QuantileViews {
  /// Creates a [Quantiles].
  Quantiles({
    this.mean,
    this.p10,
    this.p25,
    this.p50,
    this.p75,
    this.p90,
    this.min,
    this.max,
    this.probability,
  });

  /// Decodes a [Quantiles] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory Quantiles.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readQuantiles);

  /// The ensemble mean.
  final double? mean;

  /// The 10th percentile.
  @override
  final double? p10;

  /// The 25th percentile.
  @override
  final double? p25;

  /// The median.
  @override
  final double? p50;

  /// The 75th percentile.
  @override
  final double? p75;

  /// The 90th percentile.
  @override
  final double? p90;

  /// The lowest member.
  final double? min;

  /// The highest member.
  final double? max;

  /// For precipitation, the chance of a measurable amount.
  final double? probability;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (mean case final v?) {
      out['mean'] = v;
    }
    if (p10 case final v?) {
      out['p10'] = v;
    }
    if (p25 case final v?) {
      out['p25'] = v;
    }
    if (p50 case final v?) {
      out['p50'] = v;
    }
    if (p75 case final v?) {
      out['p75'] = v;
    }
    if (p90 case final v?) {
      out['p90'] = v;
    }
    if (min case final v?) {
      out['min'] = v;
    }
    if (max case final v?) {
      out['max'] = v;
    }
    if (probability case final v?) {
      out['probability'] = v;
    }
    return out;
  }
}

Quantiles _readQuantiles(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return Quantiles(
    mean: r.opt('mean', asDouble),
    p10: r.opt('p10', asDouble),
    p25: r.opt('p25', asDouble),
    p50: r.opt('p50', asDouble),
    p75: r.opt('p75', asDouble),
    p90: r.opt('p90', asDouble),
    min: r.opt('min', asDouble),
    max: r.opt('max', asDouble),
    probability: r.opt('probability', asDouble),
  );
}

/// The credit line every response carries. Show it with the data.
final class ResponseAttribution {
  /// Creates a [ResponseAttribution].
  ResponseAttribution({
    required this.sources,
    required this.credit,
    required this.url,
  });

  /// Decodes a [ResponseAttribution] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ResponseAttribution.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readResponseAttribution);

  /// Source ids from `GET /api/v1/attribution`, in registry order.
  final List<String> sources;

  /// The `credit` field.
  final String credit;

  /// Path of the full registry.
  final String url;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['sources'] = sources;
    out['credit'] = credit;
    out['url'] = url;
    return out;
  }
}

ResponseAttribution _readResponseAttribution(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ResponseAttribution(
    sources: r.req('sources', listOf(asString)),
    credit: r.req('credit', asString),
    url: r.req('url', asString),
  );
}

/// An init time at least two models completed.
final class RunEntry {
  /// Creates a [RunEntry].
  RunEntry({
    required this.initializedAt,
  });

  /// Decodes a [RunEntry] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory RunEntry.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readRunEntry);

  /// The `initialized_at` field.
  final DateTime initializedAt;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['initialized_at'] = formatDateTime(initializedAt);
    return out;
  }
}

RunEntry _readRunEntry(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return RunEntry(
    initializedAt: r.req('initialized_at', asDateTime),
  );
}

/// The served run and the recent runs, newest first.
///
/// `next_cursor` is `null` on the last page.
final class RunsResponse extends Response {
  /// Creates a [RunsResponse].
  RunsResponse({
    this.served,
    required this.items,
    required this.count,
    this.nextCursor,
  });

  /// Decodes a [RunsResponse] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory RunsResponse.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readRunsResponse);

  /// What a forecast request serves now; `null` when no cycle is servable.
  final ServedRun? served;

  /// (JSON `runs`) Init times at least two models completed, newest first.
  final List<RunEntry> items;

  /// The `count` field.
  final int count;

  /// Pass it back as `cursor` (with the same `limit` and filters) for the next
  /// page; `null` on the last page.
  final String? nextCursor;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (served case final v?) {
      out['served'] = v.toJson();
    }
    out['runs'] = [for (final e in items) e.toJson()];
    out['count'] = count;
    if (nextCursor case final v?) {
      out['next_cursor'] = v;
    }
    return out;
  }
}

RunsResponse _readRunsResponse(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return RunsResponse(
    served: r.opt('served', _readServedRun),
    items: r.req('runs', listOf(_readRunEntry)),
    count: r.req('count', asInt),
    nextCursor: r.opt('next_cursor', asString),
  );
}

/// One location search result.
final class SearchHit implements NamedLocation {
  /// Creates a [SearchHit].
  SearchHit({
    this.slug,
    required this.state,
    required this.name,
    required this.lat,
    required this.lon,
    required this.elevationM,
    this.type,
    required this.timezone,
    required this.key,
    required this.county,
    this.explore,
  });

  /// Decodes a [SearchHit] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SearchHit.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSearchHit);

  /// The location's catalog slug.
  @override
  final String? slug;

  /// The lowercase USPS state code.
  @override
  final String state;

  /// The display name.
  final String name;

  /// The `lat` field.
  final double lat;

  /// The `lon` field.
  final double lon;

  /// Elevation in metres, whatever `units` is (0.1 m).
  final double elevationM;

  /// The primary location type, snake_case.
  final LocationType? type;

  /// The IANA zone the location's local days and hours are kept in -- the zone
  /// `daily` dates, sunrise and sunset are computed in.
  final String timezone;

  /// The hit's identity.
  final String key;

  /// The `county` field.
  final String county;

  /// With a metric `sort`, the hit's value of that metric.
  final ExploreValue? explore;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (slug case final v?) {
      out['slug'] = v;
    }
    out['state'] = state;
    out['name'] = name;
    out['lat'] = lat;
    out['lon'] = lon;
    out['elevation_m'] = elevationM;
    if (type case final v?) {
      out['type'] = v.value;
    }
    out['timezone'] = timezone;
    out['key'] = key;
    out['county'] = county;
    if (explore case final v?) {
      out['explore'] = v.toJson();
    }
    return out;
  }
}

SearchHit _readSearchHit(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SearchHit(
    slug: r.opt('slug', asString),
    state: r.req('state', asString),
    name: r.req('name', asString),
    lat: r.req('lat', asDouble),
    lon: r.req('lon', asDouble),
    elevationM: r.req('elevation_m', asDouble),
    type: r.opt('type', enumOf(LocationType.new)),
    timezone: r.req('timezone', asString),
    key: r.req('key', asString),
    county: r.req('county', asString),
    explore: r.opt('explore', _readExploreValue),
  );
}

/// Location search results.
final class SearchLocationsResponse extends Response {
  /// Creates a [SearchLocationsResponse].
  SearchLocationsResponse({
    required this.items,
    required this.count,
  });

  /// Decodes a [SearchLocationsResponse] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SearchLocationsResponse.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSearchLocationsResponse);

  /// One location search result: the [LocationRef] fields, the county and
  /// `key`.
  final List<SearchHit> items;

  /// The `count` field.
  final int count;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['items'] = [for (final e in items) e.toJson()];
    out['count'] = count;
    return out;
  }
}

SearchLocationsResponse _readSearchLocationsResponse(
    Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SearchLocationsResponse(
    items: r.req('items', listOf(_readSearchHit)),
    count: r.req('count', asInt),
  );
}

/// One day of the season's daily record (`include=daily`).
final class SeasonDay {
  /// Creates a [SeasonDay].
  SeasonDay({
    required this.date,
    this.precipitation,
    this.snowfall,
    required this.provisional,
  });

  /// Decodes a [SeasonDay] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SeasonDay.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSeasonDay);

  /// The `date` field.
  final DateTime date;

  /// The day's total; null when an hour was not observed.
  final double? precipitation;

  /// Always null for now.
  final double? snowfall;

  /// The `provisional` field.
  final bool provisional;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['date'] = formatDate(date);
    if (precipitation case final v?) {
      out['precipitation'] = v;
    }
    if (snowfall case final v?) {
      out['snowfall'] = v;
    }
    out['provisional'] = provisional;
    return out;
  }
}

SeasonDay _readSeasonDay(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SeasonDay(
    date: r.req('date', asDate),
    precipitation: r.opt('precipitation', asDouble),
    snowfall: r.opt('snowfall', asDouble),
    provisional: r.req('provisional', asBool),
  );
}

/// -- observed season-to-date precipitation at a location.
final class SeasonResponse extends Response {
  /// Creates a [SeasonResponse].
  SeasonResponse({
    required this.location,
    required this.waterYear,
    required this.starts,
    required this.through,
    this.asOf,
    required this.units,
    this.precipitation,
    this.snowfall,
    this.station,
    this.daily,
    required this.attribution,
  });

  /// Decodes a [SeasonResponse] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SeasonResponse.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSeasonResponse);

  /// ONE location reference, the same wherever a place is named -- the
  /// forecast's and `/current`'s `location`, every list and `/nearby` row,
  /// search hits and favorites.
  final LocationRef location;

  /// The water year by its ending year.
  final int waterYear;

  /// The first local day of the water year.
  final DateTime starts;

  /// The last local day with an observed row (the day before `starts` when
  /// there is none).
  final DateTime through;

  /// When the newest day row was computed; null with no rows.
  final DateTime? asOf;

  /// Unit system for response values.
  final UnitSystem units;

  /// Null until the location has an observed day.
  final SeasonTotal? precipitation;

  /// Always null for now; season snowfall is not served yet.
  final SeasonTotal? snowfall;

  /// The nearest SNOTEL or SCAN gauge within 25 km and 300 m with rows this
  /// water year, or null.
  final SeasonStation? station;

  /// Only with `include=daily`.
  final List<SeasonDay>? daily;

  /// The data sources THIS response drew on, and what their licences ask us to
  /// say.
  final ResponseAttribution attribution;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['location'] = location.toJson();
    out['water_year'] = waterYear;
    out['starts'] = formatDate(starts);
    out['through'] = formatDate(through);
    if (asOf case final v?) {
      out['as_of'] = formatDateTime(v);
    }
    out['units'] = units.value;
    if (precipitation case final v?) {
      out['precipitation'] = v.toJson();
    }
    if (snowfall case final v?) {
      out['snowfall'] = v.toJson();
    }
    if (station case final v?) {
      out['station'] = v.toJson();
    }
    if (daily case final v?) {
      out['daily'] = [for (final e in v) e.toJson()];
    }
    out['attribution'] = attribution.toJson();
    return out;
  }
}

SeasonResponse _readSeasonResponse(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SeasonResponse(
    location: r.req('location', _readLocationRef),
    waterYear: r.req('water_year', asInt),
    starts: r.req('starts', asDate),
    through: r.req('through', asDate),
    asOf: r.opt('as_of', asDateTime),
    units: r.req('units', enumOf(UnitSystem.new)),
    precipitation: r.opt('precipitation', _readSeasonTotal),
    snowfall: r.opt('snowfall', _readSeasonTotal),
    station: r.opt('station', _readSeasonStation),
    daily: r.opt('daily', listOf(_readSeasonDay)),
    attribution: r.req('attribution', _readResponseAttribution),
  );
}

/// The station whose season-to-date record is shown beside the total.
final class SeasonStation {
  /// Creates a [SeasonStation].
  SeasonStation({
    required this.id,
    required this.network,
    required this.name,
    required this.distanceKm,
    required this.elevationM,
    this.precipitationTotal,
    this.precipitationPercentOfMedian,
    this.swe,
    this.swePercentOfMedian,
    this.snowDepth,
    required this.through,
  });

  /// Decodes a [SeasonStation] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SeasonStation.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSeasonStation);

  /// The NRCS station triplet.
  final String id;

  /// The `network` field.
  final String network;

  /// The `name` field.
  final String name;

  /// The `distance_km` field.
  final double distanceKm;

  /// The `elevation_m` field.
  final double elevationM;

  /// The gauge's water-year accumulator on `through` (mm or in).
  final double? precipitationTotal;

  /// The `precipitation_percent_of_median` field.
  final int? precipitationPercentOfMedian;

  /// Snow water equivalent on `through` (mm or in).
  final double? swe;

  /// The `swe_percent_of_median` field.
  final int? swePercentOfMedian;

  /// Snow depth on `through` (cm or in).
  final double? snowDepth;

  /// The gauge's newest day.
  final DateTime through;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['id'] = id;
    out['network'] = network;
    out['name'] = name;
    out['distance_km'] = distanceKm;
    out['elevation_m'] = elevationM;
    if (precipitationTotal case final v?) {
      out['precipitation_total'] = v;
    }
    if (precipitationPercentOfMedian case final v?) {
      out['precipitation_percent_of_median'] = v;
    }
    if (swe case final v?) {
      out['swe'] = v;
    }
    if (swePercentOfMedian case final v?) {
      out['swe_percent_of_median'] = v;
    }
    if (snowDepth case final v?) {
      out['snow_depth'] = v;
    }
    out['through'] = formatDate(through);
    return out;
  }
}

SeasonStation _readSeasonStation(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SeasonStation(
    id: r.req('id', asString),
    network: r.req('network', asString),
    name: r.req('name', asString),
    distanceKm: r.req('distance_km', asDouble),
    elevationM: r.req('elevation_m', asDouble),
    precipitationTotal: r.opt('precipitation_total', asDouble),
    precipitationPercentOfMedian:
        r.opt('precipitation_percent_of_median', asInt),
    swe: r.opt('swe', asDouble),
    swePercentOfMedian: r.opt('swe_percent_of_median', asInt),
    snowDepth: r.opt('snow_depth', asDouble),
    through: r.req('through', asDate),
  );
}

/// A season-to-date total: the amount, its source, coverage and normal.
final class SeasonTotal {
  /// Creates a [SeasonTotal].
  SeasonTotal({
    required this.amount,
    required this.unit,
    required this.source,
    required this.daysCovered,
    required this.daysMissing,
    required this.provisionalDays,
    this.normalToDate,
    this.percentOfNormal,
    this.normalSource,
  });

  /// Decodes a [SeasonTotal] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SeasonTotal.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSeasonTotal);

  /// (JSON `total`) Sum over the covered days, in `unit`.
  final double amount;

  /// The `unit` field.
  final String unit;

  /// `mrms_multisensor`: the gridded analysis at the location; `station_gauge`:
  /// the location is a gauge site and this is the gauge's accumulator.
  final String source;

  /// The `days_covered` field.
  final int daysCovered;

  /// Days since `starts` with no complete observation; not counted as dry.
  final int daysMissing;

  /// Covered days still inside the 7-day restate window.
  final int provisionalDays;

  /// PRISM 1991-2020 over the covered days, in `unit`; null where no normal is
  /// loaded.
  final double? normalToDate;

  /// The `percent_of_normal` field.
  final int? percentOfNormal;

  /// The `normal_source` field.
  final String? normalSource;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['total'] = amount;
    out['unit'] = unit;
    out['source'] = source;
    out['days_covered'] = daysCovered;
    out['days_missing'] = daysMissing;
    out['provisional_days'] = provisionalDays;
    if (normalToDate case final v?) {
      out['normal_to_date'] = v;
    }
    if (percentOfNormal case final v?) {
      out['percent_of_normal'] = v;
    }
    if (normalSource case final v?) {
      out['normal_source'] = v;
    }
    return out;
  }
}

SeasonTotal _readSeasonTotal(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SeasonTotal(
    amount: r.req('total', asDouble),
    unit: r.req('unit', asString),
    source: r.req('source', asString),
    daysCovered: r.req('days_covered', asInt),
    daysMissing: r.req('days_missing', asInt),
    provisionalDays: r.req('provisional_days', asInt),
    normalToDate: r.opt('normal_to_date', asDouble),
    percentOfNormal: r.opt('percent_of_normal', asInt),
    normalSource: r.opt('normal_source', asString),
  );
}

/// A circular sector, in degrees, clockwise from `from_` to `to`.
final class Sector {
  /// Creates a [Sector].
  Sector({
    required this.from,
    required this.to,
  });

  /// Decodes a [Sector] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory Sector.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSector);

  /// The `from` field.
  final double from;

  /// The `to` field.
  final double to;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['from'] = from;
    out['to'] = to;
    return out;
  }
}

Sector _readSector(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return Sector(
    from: r.req('from', asDouble),
    to: r.req('to', asDouble),
  );
}

/// A recent observation from a nearby station.
final class SensorObservation {
  /// Creates a [SensorObservation].
  SensorObservation({
    required this.stationId,
    required this.name,
    required this.source,
    required this.observedAt,
    this.distanceKm,
    this.elevationDiff,
    this.temperature,
    this.dewpoint,
    this.relativeHumidity,
    this.windSpeed,
    this.windGust,
    this.windDirection,
    this.pressure,
    this.precipitation,
    this.precipitationRate,
    this.reflectivity,
    this.pavementTemp,
    this.subsurfaceTemp,
    this.visibility,
    this.cloudCover,
    this.ceilingHeight,
    this.snowDepth,
    this.swe,
    this.swePercentOfMedian,
    this.snowfall,
    this.solarRadiation,
    this.pavementCondition,
  });

  /// Decodes a [SensorObservation] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SensorObservation.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSensorObservation);

  /// The station's id in its network.
  final String stationId;

  /// The station's registry name, else its id.
  final String name;

  /// The `source` field.
  final String source;

  /// (JSON `observation_time`)
  final DateTime observedAt;

  /// The station's distance from the location.
  final double? distanceKm;

  /// The station's elevation minus the location's, in the length unit.
  final double? elevationDiff;

  /// °C, °F (imperial) or K (kelvin).
  final double? temperature;

  /// As `temperature`.
  final double? dewpoint;

  /// Percent.
  final double? relativeHumidity;

  /// m/s or mph (imperial).
  final double? windSpeed;

  /// As `wind_speed`.
  final double? windGust;

  /// Degrees clockwise from north.
  final double? windDirection;

  /// Station pressure: hPa, or inHg (imperial).
  final double? pressure;

  /// The last reporting period's precipitation: mm, or in (imperial).
  final double? precipitation;

  /// Radar precipitation rate: mm/h, or in/h (imperial).
  final double? precipitationRate;

  /// Radar reflectivity, dBZ.
  final double? reflectivity;

  /// As `temperature`.
  final double? pavementTemp;

  /// As `temperature`.
  final double? subsurfaceTemp;

  /// m, or statute miles (imperial; it was ft).
  final double? visibility;

  /// Percent: the largest reported layer, each at the middle of the okta range
  /// its code reports (FEW 18.75, SCT 43.75, BKN 75, OVC 100; older stored
  /// reports read FEW 25 and SCT 50), rounded to a whole percent, so FEW reads
  /// 19 and SCT 44.
  final double? cloudCover;

  /// m, or ft (imperial).
  final double? ceilingHeight;

  /// cm, or in (imperial).
  final double? snowDepth;

  /// Snow water equivalent: mm, or in (imperial).
  final double? swe;

  /// SWE as a percent of the station's median for the date.
  final double? swePercentOfMedian;

  /// mm, or in (imperial).
  final double? snowfall;

  /// W/m².
  final double? solarRadiation;

  /// Road-weather pavement state as the network reports it.
  final String? pavementCondition;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['station_id'] = stationId;
    out['name'] = name;
    out['source'] = source;
    out['observation_time'] = formatDateTime(observedAt);
    if (distanceKm case final v?) {
      out['distance_km'] = v;
    }
    if (elevationDiff case final v?) {
      out['elevation_diff'] = v;
    }
    if (temperature case final v?) {
      out['temperature'] = v;
    }
    if (dewpoint case final v?) {
      out['dewpoint'] = v;
    }
    if (relativeHumidity case final v?) {
      out['relative_humidity'] = v;
    }
    if (windSpeed case final v?) {
      out['wind_speed'] = v;
    }
    if (windGust case final v?) {
      out['wind_gust'] = v;
    }
    if (windDirection case final v?) {
      out['wind_direction'] = v;
    }
    if (pressure case final v?) {
      out['pressure'] = v;
    }
    if (precipitation case final v?) {
      out['precipitation'] = v;
    }
    if (precipitationRate case final v?) {
      out['precipitation_rate'] = v;
    }
    if (reflectivity case final v?) {
      out['reflectivity'] = v;
    }
    if (pavementTemp case final v?) {
      out['pavement_temp'] = v;
    }
    if (subsurfaceTemp case final v?) {
      out['subsurface_temp'] = v;
    }
    if (visibility case final v?) {
      out['visibility'] = v;
    }
    if (cloudCover case final v?) {
      out['cloud_cover'] = v;
    }
    if (ceilingHeight case final v?) {
      out['ceiling_height'] = v;
    }
    if (snowDepth case final v?) {
      out['snow_depth'] = v;
    }
    if (swe case final v?) {
      out['swe'] = v;
    }
    if (swePercentOfMedian case final v?) {
      out['swe_percent_of_median'] = v;
    }
    if (snowfall case final v?) {
      out['snowfall'] = v;
    }
    if (solarRadiation case final v?) {
      out['solar_radiation'] = v;
    }
    if (pavementCondition case final v?) {
      out['pavement_condition'] = v;
    }
    return out;
  }
}

SensorObservation _readSensorObservation(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SensorObservation(
    stationId: r.req('station_id', asString),
    name: r.req('name', asString),
    source: r.req('source', asString),
    observedAt: r.req('observation_time', asDateTime),
    distanceKm: r.opt('distance_km', asDouble),
    elevationDiff: r.opt('elevation_diff', asDouble),
    temperature: r.opt('temperature', asDouble),
    dewpoint: r.opt('dewpoint', asDouble),
    relativeHumidity: r.opt('relative_humidity', asDouble),
    windSpeed: r.opt('wind_speed', asDouble),
    windGust: r.opt('wind_gust', asDouble),
    windDirection: r.opt('wind_direction', asDouble),
    pressure: r.opt('pressure', asDouble),
    precipitation: r.opt('precipitation', asDouble),
    precipitationRate: r.opt('precipitation_rate', asDouble),
    reflectivity: r.opt('reflectivity', asDouble),
    pavementTemp: r.opt('pavement_temp', asDouble),
    subsurfaceTemp: r.opt('subsurface_temp', asDouble),
    visibility: r.opt('visibility', asDouble),
    cloudCover: r.opt('cloud_cover', asDouble),
    ceilingHeight: r.opt('ceiling_height', asDouble),
    snowDepth: r.opt('snow_depth', asDouble),
    swe: r.opt('swe', asDouble),
    swePercentOfMedian: r.opt('swe_percent_of_median', asDouble),
    snowfall: r.opt('snowfall', asDouble),
    solarRadiation: r.opt('solar_radiation', asDouble),
    pavementCondition: r.opt('pavement_condition', asString),
  );
}

/// What a forecast request serves now.
final class ServedRun {
  /// Creates a [ServedRun].
  ServedRun({
    required this.initializedAt,
    required this.models,
  });

  /// Decodes a [ServedRun] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory ServedRun.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readServedRun);

  /// The `initialized_at` field.
  final DateTime initializedAt;

  /// The `models` field.
  final List<ModelEntry> models;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['initialized_at'] = formatDateTime(initializedAt);
    out['models'] = [for (final e in models) e.toJson()];
    return out;
  }
}

ServedRun _readServedRun(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return ServedRun(
    initializedAt: r.req('initialized_at', asDateTime),
    models: r.req('models', listOf(_readModelEntry)),
  );
}

/// A day's snow level over its wet hours (m, or ft with `units=imperial`).
///
/// The lowest and highest hourly ensemble-mean snow level among them, and their
/// precipitation-weighted mean.
final class SnowLevelRange {
  /// Creates a [SnowLevelRange].
  SnowLevelRange({
    required this.low,
    required this.high,
    required this.mean,
  });

  /// Decodes a [SnowLevelRange] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowLevelRange.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowLevelRange);

  /// The lowest hourly snow level among the wet hours.
  final double low;

  /// The highest hourly snow level among the wet hours.
  final double high;

  /// The wet hours' snow level, weighted by their precipitation.
  final double mean;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['low'] = low;
    out['high'] = high;
    out['mean'] = mean;
    return out;
  }
}

SnowLevelRange _readSnowLevelRange(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowLevelRange(
    low: r.req('low', asDouble),
    high: r.req('high', asDouble),
    mean: r.req('mean', asDouble),
  );
}

/// What the snowpack model states is on the ground at a spot at one hour.
final class SnowOnGround {
  /// Creates a [SnowOnGround].
  SnowOnGround({
    required this.beta,
    required this.depth,
    required this.basis,
    this.surface,
    required this.validTime,
    required this.generatedAt,
  });

  /// Decodes a [SnowOnGround] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowOnGround.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowOnGround);

  /// Always `true` while the product is a beta; fields may be added.
  final bool beta;

  /// Snow depth: cm, or in (imperial).
  final double depth;

  /// `measured`: the run started from a snow-depth sensor at the spot.
  final String basis;

  /// The surface class at the hour; `/snowpack`'s `definitions.surface` carries
  /// the text of each value (an open set).
  final String? surface;

  /// The hour the depth is for.
  final DateTime validTime;

  /// When the snowpack run that produced it finished.
  final DateTime generatedAt;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['beta'] = beta;
    out['depth'] = depth;
    out['basis'] = basis;
    if (surface case final v?) {
      out['surface'] = v;
    }
    out['valid_time'] = formatDateTime(validTime);
    out['generated_at'] = formatDateTime(generatedAt);
    return out;
  }
}

SnowOnGround _readSnowOnGround(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowOnGround(
    beta: r.req('beta', asBool),
    depth: r.req('depth', asDouble),
    basis: r.req('basis', asString),
    surface: r.opt('surface', asString),
    validTime: r.req('valid_time', asDateTime),
    generatedAt: r.req('generated_at', asDateTime),
  );
}

/// Snowfall over the next 24 h, 48 h and 7 days, computed by the server.
final class SnowOutlook {
  /// Creates a [SnowOutlook].
  SnowOutlook({
    this.next24h,
    this.next48h,
    this.next72h,
    this.next7d,
    this.overnight4pm9am,
    this.quantiles,
  });

  /// Decodes a [SnowOutlook] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowOutlook.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowOutlook);

  /// Sum of the hourly snowfall means over the 24 h from the first served hour;
  /// `null` when the forecast does not reach its end.
  final double? next24h;

  /// Sum of the hourly snowfall means over the first 48 h; `null` when not
  /// covered.
  final double? next48h;

  /// Sum of the hourly snowfall means over the first 72 h (the favorites' "next
  /// 3 days"); `null` when not covered.
  final double? next72h;

  /// Sum of the hourly snowfall means over the first 168 h; `null` when not
  /// covered.
  final double? next7d;

  /// Snow expected overnight, local 16:00 today → 09:00 tomorrow: the sum of
  /// the hourly snowfall means in the window, read from the forecast whatever
  /// `max_hours` is.
  final double? overnight4pm9am;

  /// The RANGE of each `snow_outlook` window's snowfall total, on the default
  /// response (no `members` needed) and on every
  /// `elevation_forecasts[].snow_outlook`.
  final SnowOutlookQuantiles? quantiles;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (next24h case final v?) {
      out['next_24h'] = v;
    }
    if (next48h case final v?) {
      out['next_48h'] = v;
    }
    if (next72h case final v?) {
      out['next_72h'] = v;
    }
    if (next7d case final v?) {
      out['next_7d'] = v;
    }
    if (overnight4pm9am case final v?) {
      out['overnight_4pm_9am'] = v;
    }
    if (quantiles case final v?) {
      out['quantiles'] = v.toJson();
    }
    return out;
  }
}

SnowOutlook _readSnowOutlook(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowOutlook(
    next24h: r.opt('next_24h', asDouble),
    next48h: r.opt('next_48h', asDouble),
    next72h: r.opt('next_72h', asDouble),
    next7d: r.opt('next_7d', asDouble),
    overnight4pm9am: r.opt('overnight_4pm_9am', asDouble),
    quantiles: r.opt('quantiles', _readSnowOutlookQuantiles),
  );
}

/// The distributions behind `SnowOutlook`'s headline numbers.
final class SnowOutlookQuantiles {
  /// Creates a [SnowOutlookQuantiles].
  SnowOutlookQuantiles({
    this.next24h,
    this.next48h,
    this.next72h,
    this.next7d,
  });

  /// Decodes a [SnowOutlookQuantiles] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowOutlookQuantiles.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowOutlookQuantiles);

  /// THE distribution shape -- every ensemble statistic the API serves (hourly
  /// `ensemble.*`, per-model `model_means[].*`, the daily
  /// `high`/`low`/`total_*`/`feels_like_*`, the plume's `members_cumulative`,
  /// `?totals=` windows, `snow_outlook.quantiles` windows, the daily
  /// `snow_level` and `*_if_wet`) is this one object, in the request's units.
  final Quantiles? next24h;

  /// THE distribution shape -- every ensemble statistic the API serves (hourly
  /// `ensemble.*`, per-model `model_means[].*`, the daily
  /// `high`/`low`/`total_*`/`feels_like_*`, the plume's `members_cumulative`,
  /// `?totals=` windows, `snow_outlook.quantiles` windows, the daily
  /// `snow_level` and `*_if_wet`) is this one object, in the request's units.
  final Quantiles? next48h;

  /// Built as the other windows are.
  final Quantiles? next72h;

  /// THE distribution shape -- every ensemble statistic the API serves (hourly
  /// `ensemble.*`, per-model `model_means[].*`, the daily
  /// `high`/`low`/`total_*`/`feels_like_*`, the plume's `members_cumulative`,
  /// `?totals=` windows, `snow_outlook.quantiles` windows, the daily
  /// `snow_level` and `*_if_wet`) is this one object, in the request's units.
  final Quantiles? next7d;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (next24h case final v?) {
      out['next_24h'] = v.toJson();
    }
    if (next48h case final v?) {
      out['next_48h'] = v.toJson();
    }
    if (next72h case final v?) {
      out['next_72h'] = v.toJson();
    }
    if (next7d case final v?) {
      out['next_7d'] = v.toJson();
    }
    return out;
  }
}

SnowOutlookQuantiles _readSnowOutlookQuantiles(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowOutlookQuantiles(
    next24h: r.opt('next_24h', _readQuantiles),
    next48h: r.opt('next_48h', _readQuantiles),
    next72h: r.opt('next_72h', _readQuantiles),
    next7d: r.opt('next_7d', _readQuantiles),
  );
}

/// One cell of the grid: a run's snowfall for one local day.
final class SnowTrendDay {
  /// Creates a [SnowTrendDay].
  SnowTrendDay({
    required this.date,
    this.amount,
    required this.partial,
    this.p10,
    this.p90,
    this.kind,
  });

  /// Decodes a [SnowTrendDay] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowTrendDay.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowTrendDay);

  /// The `dates` entry this day is for.
  final DateTime date;

  /// (JSON `snow`) The day's snowfall in mm (metric) or inches (imperial), at
  /// the served amount precision.
  final double? amount;

  /// The run covers only part of this local day.
  final bool partial;

  /// The range's low end.
  final double? p10;

  /// The range's high end, as `p10`.
  final double? p90;

  /// `ourea` only: the day's `precipitation_display.kind`.
  final String? kind;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['date'] = formatDate(date);
    if (amount case final v?) {
      out['snow'] = v;
    }
    out['partial'] = partial;
    if (p10 case final v?) {
      out['p10'] = v;
    }
    if (p90 case final v?) {
      out['p90'] = v;
    }
    if (kind case final v?) {
      out['kind'] = v;
    }
    return out;
  }
}

SnowTrendDay _readSnowTrendDay(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowTrendDay(
    date: r.req('date', asDate),
    amount: r.opt('snow', asDouble),
    partial: r.req('partial', asBool),
    p10: r.opt('p10', asDouble),
    p90: r.opt('p90', asDouble),
    kind: r.opt('kind', asString),
  );
}

/// One source's grid: `ourea` (the served forecast) or a model (Pro).
final class SnowTrendGrid {
  /// Creates a [SnowTrendGrid].
  SnowTrendGrid({
    required this.source,
    required this.runs,
  });

  /// Decodes a [SnowTrendGrid] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowTrendGrid.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowTrendGrid);

  /// `ourea`, or a model id.
  final String source;

  /// Oldest first; the last is the newest.
  final List<SnowTrendRun> runs;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['source'] = source;
    out['runs'] = [for (final e in runs) e.toJson()];
    return out;
  }
}

SnowTrendGrid _readSnowTrendGrid(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowTrendGrid(
    source: r.req('source', asString),
    runs: r.req('runs', listOf(_readSnowTrendRun)),
  );
}

/// -- each recent run's daily snowfall at a location's point, by source.
final class SnowTrendResponse extends Response {
  /// Creates a [SnowTrendResponse].
  SnowTrendResponse({
    required this.location,
    required this.units,
    required this.elevation,
    required this.retentionDays,
    required this.dates,
    required this.grids,
  });

  /// Decodes a [SnowTrendResponse] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowTrendResponse.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowTrendResponse);

  /// ONE location reference, the same wherever a place is named -- the
  /// forecast's and `/current`'s `location`, every list and `/nearby` row,
  /// search hits and favorites.
  final LocationRef location;

  /// Unit system for response values.
  final UnitSystem units;

  /// The point the grids are for.
  final SnowTrendResponseElevation elevation;

  /// How many days back runs are kept.
  final int retentionDays;

  /// The columns, location-local dates ascending.
  final List<DateTime> dates;

  /// `ourea` first; with the `model_data` entitlement then `aifs`, `aigefs`,
  /// `gefs`, `ifs_ens` and `rrfs`.
  final List<SnowTrendGrid> grids;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['location'] = location.toJson();
    out['units'] = units.value;
    out['elevation'] = elevation.toJson();
    out['retention_days'] = retentionDays;
    out['dates'] = [for (final e in dates) formatDate(e)];
    out['grids'] = [for (final e in grids) e.toJson()];
    return out;
  }
}

SnowTrendResponse _readSnowTrendResponse(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowTrendResponse(
    location: r.req('location', _readLocationRef),
    units: r.req('units', enumOf(UnitSystem.new)),
    elevation: r.req('elevation', _readSnowTrendResponseElevation),
    retentionDays: r.req('retention_days', asInt),
    dates: r.req('dates', listOf(asDate)),
    grids: r.req('grids', listOf(_readSnowTrendGrid)),
  );
}

/// The point the grids are for.
final class SnowTrendResponseElevation {
  /// Creates a [SnowTrendResponseElevation].
  SnowTrendResponseElevation({
    this.name,
    this.displayName,
    required this.height,
  });

  /// Decodes a [SnowTrendResponseElevation] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowTrendResponseElevation.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowTrendResponseElevation);

  /// The named elevation; `null` for a location with one point.
  final String? name;

  /// What that elevation is called, as `ElevationSummary.display_name`; absent
  /// where it has no name.
  final String? displayName;

  /// (JSON `elevation`) Its elevation, in m (metric) or ft (imperial).
  final double height;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (name case final v?) {
      out['name'] = v;
    }
    if (displayName case final v?) {
      out['display_name'] = v;
    }
    out['elevation'] = height;
    return out;
  }
}

SnowTrendResponseElevation _readSnowTrendResponseElevation(
    Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowTrendResponseElevation(
    name: r.opt('name', asString),
    displayName: r.opt('display_name', asString),
    height: r.req('elevation', asDouble),
  );
}

/// One run's row of the grid: its init and one cell per date.
final class SnowTrendRun {
  /// Creates a [SnowTrendRun].
  SnowTrendRun({
    required this.backfilled,
    required this.initializedAt,
    required this.days,
  });

  /// Decodes a [SnowTrendRun] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowTrendRun.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowTrendRun);

  /// `true`: re-rendered after the fact from the pinned run
  /// (`?run=<initialized_at>`) by the post-deploy backfill -- today's
  /// calibration and no live nowcast, so it can differ slightly from what was
  /// served then.
  final bool backfilled;

  /// `ourea`: the served body's `model_run.initialized_at`.
  final DateTime initializedAt;

  /// One entry per `dates` entry, in order; `null` where the run has no value.
  final List<SnowTrendDay?> days;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['backfilled'] = backfilled;
    out['initialized_at'] = formatDateTime(initializedAt);
    out['days'] = [for (final e in days) e?.toJson()];
    return out;
  }
}

SnowTrendRun _readSnowTrendRun(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowTrendRun(
    backfilled: r.req('backfilled', asBool),
    initializedAt: r.req('initialized_at', asDateTime),
    days: r.req('days', listOf(nullableOf(_readSnowTrendDay))),
  );
}

/// The snow on one slope at a spot, described as the spot's flat ground is.
///
/// The model run on a slope of `slope_angle_deg` facing `aspect`, with the flat
/// ground's snowfall and the slope's own sun.
final class SnowpackAspect {
  /// Creates a [SnowpackAspect].
  SnowpackAspect({
    required this.aspect,
    required this.slopeAngleDeg,
    required this.depth,
    this.depthChange24h,
    required this.steps,
    required this.layers,
  });

  /// Decodes a [SnowpackAspect] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowpackAspect.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowpackAspect);

  /// The way the slope faces: `north`, `east`, `south` or `west`.
  final String aspect;

  /// How steep the slope is, degrees from horizontal.
  final double slopeAngleDeg;

  /// Hourly snow depth on the slope, measured vertically as the flat depth is.
  final SnowpackDepth depth;

  /// As the spot's `depth_change_24h`, this slope's own (open loop on both
  /// sides), read from the same earlier run as the spot's and from no other.
  final double? depthChange24h;

  /// One entry every six hours, at the spot's own `steps[].valid_time`.
  final List<SnowpackStep> steps;

  /// Buried layers on the slope at `depth.start_time`, at most three.
  final List<SnowpackLayer> layers;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['aspect'] = aspect;
    out['slope_angle_deg'] = slopeAngleDeg;
    out['depth'] = depth.toJson();
    if (depthChange24h case final v?) {
      out['depth_change_24h'] = v;
    }
    out['steps'] = [for (final e in steps) e.toJson()];
    out['layers'] = [for (final e in layers) e.toJson()];
    return out;
  }
}

SnowpackAspect _readSnowpackAspect(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowpackAspect(
    aspect: r.req('aspect', asString),
    slopeAngleDeg: r.req('slope_angle_deg', asDouble),
    depth: r.req('depth', _readSnowpackDepth),
    depthChange24h: r.opt('depth_change_24h', asDouble),
    steps: r.req('steps', listOf(_readSnowpackStep)),
    layers: r.req('layers', listOf(_readSnowpackLayer)),
  );
}

/// Hourly snow depth from `start_time` (cm or in).
final class SnowpackDepth {
  /// Creates a [SnowpackDepth].
  SnowpackDepth({
    required this.startTime,
    required this.intervalHours,
    required this.basis,
    this.p10,
    required this.p50,
    this.p90,
  });

  /// Decodes a [SnowpackDepth] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowpackDepth.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowpackDepth);

  /// The `start_time` field.
  final DateTime startTime;

  /// The `interval_hours` field.
  final int intervalHours;

  /// `measured`: started from a sensor reading at the spot.
  final String basis;

  /// The `p10` field.
  final List<double>? p10;

  /// The `p50` field.
  final List<double> p50;

  /// The `p90` field.
  final List<double>? p90;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['start_time'] = formatDateTime(startTime);
    out['interval_hours'] = intervalHours;
    out['basis'] = basis;
    if (p10 case final v?) {
      out['p10'] = v;
    }
    out['p50'] = p50;
    if (p90 case final v?) {
      out['p90'] = v;
    }
    return out;
  }
}

SnowpackDepth _readSnowpackDepth(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowpackDepth(
    startTime: r.req('start_time', asDateTime),
    intervalHours: r.req('interval_hours', asInt),
    basis: r.req('basis', asString),
    p10: r.opt('p10', listOf(asDouble)),
    p50: r.req('p50', listOf(asDouble)),
    p90: r.opt('p90', listOf(asDouble)),
  );
}

/// One layer of a spot's modelled snowpack.
final class SnowpackLayer {
  /// Creates a [SnowpackLayer].
  SnowpackLayer({
    required this.form,
    required this.thickness,
    required this.depth,
    required this.formed,
  });

  /// Decodes a [SnowpackLayer] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowpackLayer.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowpackLayer);

  /// A key of `definitions.layer_form`: today `faceted_grains`, `depth_hoar`,
  /// `buried_surface_hoar`, `melt_freeze_crust`, `ice_layer` or
  /// `rounding_facets`.
  final String form;

  /// cm or in.
  final double thickness;

  /// From the surface down to the layer's top (cm or in).
  final double depth;

  /// The `formed` field.
  final DateTime formed;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['form'] = form;
    out['thickness'] = thickness;
    out['depth'] = depth;
    out['formed'] = formatDate(formed);
    return out;
  }
}

SnowpackLayer _readSnowpackLayer(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowpackLayer(
    form: r.req('form', asString),
    thickness: r.req('thickness', asDouble),
    depth: r.req('depth', asDouble),
    formed: r.req('formed', asDate),
  );
}

/// The snow model that produced the run, and its licence.
final class SnowpackModel {
  /// Creates a [SnowpackModel].
  SnowpackModel({
    required this.name,
    required this.by,
    required this.license,
    this.version,
  });

  /// Decodes a [SnowpackModel] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowpackModel.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowpackModel);

  /// The `name` field.
  final String name;

  /// The `by` field.
  final String by;

  /// The `license` field.
  final String license;

  /// The build that ran: the commits of Ourea's SNOWPACK and MeteoIO source it
  /// was built from, as `snowpack <commit> meteoio <commit>`.
  final String? version;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['name'] = name;
    out['by'] = by;
    out['license'] = license;
    if (version case final v?) {
      out['version'] = v;
    }
    return out;
  }
}

SnowpackModel _readSnowpackModel(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowpackModel(
    name: r.req('name', asString),
    by: r.req('by', asString),
    license: r.req('license', asString),
    version: r.opt('version', asString),
  );
}

/// The members' depth at each step.
final class SnowpackPlumeDepth {
  /// Creates a [SnowpackPlumeDepth].
  SnowpackPlumeDepth({
    required this.startTime,
    required this.intervalHours,
    required this.members,
    this.p50,
    required this.mean,
    required this.p10,
    required this.p25,
    required this.p75,
    required this.p90,
  });

  /// Decodes a [SnowpackPlumeDepth] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowpackPlumeDepth.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowpackPlumeDepth);

  /// The time of the first value of every series in the body.
  final DateTime startTime;

  /// Hours between values (3).
  final int intervalHours;

  /// Members that reach each step; it falls where a model's horizon ends.
  final List<int> members;

  /// The members' median depth, in the response's units.
  final List<double>? p50;

  /// Served to every caller, as the bands are.
  final List<double> mean;

  /// Every caller (Plus and Pro only before).
  final List<double> p10;

  /// Every caller (Plus and Pro only before).
  final List<double> p25;

  /// Every caller (Plus and Pro only before).
  final List<double> p75;

  /// Every caller (Plus and Pro only before).
  final List<double> p90;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['start_time'] = formatDateTime(startTime);
    out['interval_hours'] = intervalHours;
    out['members'] = members;
    if (p50 case final v?) {
      out['p50'] = v;
    }
    out['mean'] = mean;
    out['p10'] = p10;
    out['p25'] = p25;
    out['p75'] = p75;
    out['p90'] = p90;
    return out;
  }
}

SnowpackPlumeDepth _readSnowpackPlumeDepth(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowpackPlumeDepth(
    startTime: r.req('start_time', asDateTime),
    intervalHours: r.req('interval_hours', asInt),
    members: r.req('members', listOf(asInt)),
    p50: r.opt('p50', listOf(asDouble)),
    mean: r.req('mean', listOf(asDouble)),
    p10: r.req('p10', listOf(asDouble)),
    p25: r.req('p25', listOf(asDouble)),
    p75: r.req('p75', listOf(asDouble)),
    p90: r.req('p90', listOf(asDouble)),
  );
}

/// One model's members in the snow-depth plume.
final class SnowpackPlumeModel {
  /// Creates a [SnowpackPlumeModel].
  SnowpackPlumeModel({
    required this.id,
    required this.memberIds,
    required this.depth,
    required this.depthMean,
    required this.membersSkipped,
  });

  /// Decodes a [SnowpackPlumeModel] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowpackPlumeModel.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowpackPlumeModel);

  /// `aifs`, `aigefs`, `gefs` or `ifs_ens`; tolerate one this SDK does not
  /// know.
  final String id;

  /// The model's own member numbers, in the order of `depth`.
  final List<int> memberIds;

  /// One series per member, from `depth.start_time` every
  /// `depth.interval_hours`.
  final List<List<double>> depth;

  /// The equal-weight mean of this model's members' `depth` at each of the
  /// model's own steps (from `depth.start_time` every `depth.interval_hours`,
  /// to the model's horizon: the length of its members' series), in the
  /// response's units.
  final List<double> depthMean;

  /// Members not run because the ground starts bare and they bring no snow;
  /// their series is 0 throughout.
  final int membersSkipped;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['id'] = id;
    out['member_ids'] = memberIds;
    out['depth'] = depth;
    out['depth_mean'] = depthMean;
    out['members_skipped'] = membersSkipped;
    return out;
  }
}

SnowpackPlumeModel _readSnowpackPlumeModel(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowpackPlumeModel(
    id: r.req('id', asString),
    memberIds: r.req('member_ids', listOf(asInt)),
    depth: r.req('depth', listOf(listOf(asDouble))),
    depthMean: r.req('depth_mean', listOf(asDouble)),
    membersSkipped: r.req('members_skipped', asInt),
  );
}

/// A location's snow-depth plume.
final class SnowpackPlumeResponse extends Response {
  /// Creates a [SnowpackPlumeResponse].
  SnowpackPlumeResponse({
    required this.beta,
    required this.location,
    required this.units,
    this.modelRun,
    required this.stale,
    this.depth,
    this.models,
    this.memberDepths,
    required this.spread,
  });

  /// Decodes a [SnowpackPlumeResponse] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowpackPlumeResponse.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowpackPlumeResponse);

  /// Always `true` while the product is a beta; fields may be added.
  final bool beta;

  /// ONE location reference, the same wherever a place is named -- the
  /// forecast's and `/current`'s `location`, every list and `/nearby` row,
  /// search hits and favorites.
  final LocationRef location;

  /// Unit system for response values.
  final UnitSystem units;

  /// The run the plume is from: the 12Z blend cycle the members were read from.
  final SnowpackRun? modelRun;

  /// The plume's blend cycle is more than 24 h old.
  final bool stale;

  /// The members' depth at each step.
  final SnowpackPlumeDepth? depth;

  /// Every member's own series, by model, each model to its own horizon.
  final List<SnowpackPlumeModel>? models;

  /// Every member's depth as ONE unlabelled pool, for Free and anonymous
  /// callers (absent for Plus and Pro, who are served `models`).
  final List<List<double>>? memberDepths;

  /// What the bands are, in a sentence a client may show beside them.
  final String spread;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['beta'] = beta;
    out['location'] = location.toJson();
    out['units'] = units.value;
    if (modelRun case final v?) {
      out['model_run'] = v.toJson();
    }
    out['stale'] = stale;
    if (depth case final v?) {
      out['depth'] = v.toJson();
    }
    if (models case final v?) {
      out['models'] = [for (final e in v) e.toJson()];
    }
    if (memberDepths case final v?) {
      out['member_depths'] = v;
    }
    out['spread'] = spread;
    return out;
  }
}

SnowpackPlumeResponse _readSnowpackPlumeResponse(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowpackPlumeResponse(
    beta: r.req('beta', asBool),
    location: r.req('location', _readLocationRef),
    units: r.req('units', enumOf(UnitSystem.new)),
    modelRun: r.opt('model_run', _readSnowpackRun),
    stale: r.req('stale', asBool),
    depth: r.opt('depth', _readSnowpackPlumeDepth),
    models: r.opt('models', listOf(_readSnowpackPlumeModel)),
    memberDepths: r.opt('member_depths', listOf(listOf(asDouble))),
    spread: r.req('spread', asString),
  );
}

/// The snowpack forecast of a location's spots.
final class SnowpackResponse extends Response {
  /// Creates a [SnowpackResponse].
  SnowpackResponse({
    required this.beta,
    required this.location,
    required this.units,
    this.modelRun,
    required this.stale,
    required this.spots,
    required this.definitions,
  });

  /// Decodes a [SnowpackResponse] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowpackResponse.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowpackResponse);

  /// Always `true` while the product is a beta; fields may be added.
  final bool beta;

  /// ONE location reference, the same wherever a place is named -- the
  /// forecast's and `/current`'s `location`, every list and `/nearby` row,
  /// search hits and favorites.
  final LocationRef location;

  /// Unit system for response values.
  final UnitSystem units;

  /// The newest snowpack run among the spots served.
  final SnowpackRun? modelRun;

  /// The newest run's blend cycle is more than 24 h old.
  final bool stale;

  /// The location's own point first, then its named elevations in their display
  /// order.
  final List<SnowpackSpot> spots;

  /// The `definitions` field.
  final SnowpackResponseDefinitions definitions;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['beta'] = beta;
    out['location'] = location.toJson();
    out['units'] = units.value;
    if (modelRun case final v?) {
      out['model_run'] = v.toJson();
    }
    out['stale'] = stale;
    out['spots'] = [for (final e in spots) e.toJson()];
    out['definitions'] = definitions.toJson();
    return out;
  }
}

SnowpackResponse _readSnowpackResponse(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowpackResponse(
    beta: r.req('beta', asBool),
    location: r.req('location', _readLocationRef),
    units: r.req('units', enumOf(UnitSystem.new)),
    modelRun: r.opt('model_run', _readSnowpackRun),
    stale: r.req('stale', asBool),
    spots: r.req('spots', listOf(_readSnowpackSpot)),
    definitions: r.req('definitions', _readSnowpackResponseDefinitions),
  );
}

/// What the snowpack codes (surface, grain form) mean, for display.
final class SnowpackResponseDefinitions {
  /// Creates a [SnowpackResponseDefinitions].
  SnowpackResponseDefinitions({
    required this.surface,
    required this.layerForm,
  });

  /// Decodes a [SnowpackResponseDefinitions] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowpackResponseDefinitions.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowpackResponseDefinitions);

  /// Each surface class and what it means.
  final Map<String, String> surface;

  /// Each layer form and what it is.
  final Map<String, String> layerForm;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['surface'] = surface;
    out['layer_form'] = layerForm;
    return out;
  }
}

SnowpackResponseDefinitions _readSnowpackResponseDefinitions(
    Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowpackResponseDefinitions(
    surface: r.req('surface', mapOf(asString)),
    layerForm: r.req('layer_form', mapOf(asString)),
  );
}

/// The newest snowpack run among the spots served.
final class SnowpackRun {
  /// Creates a [SnowpackRun].
  SnowpackRun({
    required this.initializedAt,
    required this.generatedAt,
    required this.model,
  });

  /// Decodes a [SnowpackRun] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowpackRun.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowpackRun);

  /// The blend cycle the snowpack model was driven with.
  final DateTime initializedAt;

  /// The `generated_at` field.
  final DateTime generatedAt;

  /// The `model` field.
  final SnowpackModel model;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['initialized_at'] = formatDateTime(initializedAt);
    out['generated_at'] = formatDateTime(generatedAt);
    out['model'] = model.toJson();
    return out;
  }
}

SnowpackRun _readSnowpackRun(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowpackRun(
    initializedAt: r.req('initialized_at', asDateTime),
    generatedAt: r.req('generated_at', asDateTime),
    model: r.req('model', _readSnowpackModel),
  );
}

/// The snowpack at one of a location's spots (an elevation).
final class SnowpackSpot {
  /// Creates a [SnowpackSpot].
  SnowpackSpot({
    this.name,
    this.displayName,
    required this.elevation,
    required this.elevationM,
    required this.initializedAt,
    this.anchor,
    required this.depth,
    this.depthChange24h,
    required this.swe,
    required this.steps,
    required this.layers,
    this.aspects,
  });

  /// Decodes a [SnowpackSpot] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowpackSpot.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowpackSpot);

  /// The named elevation (`location.elevations[].name`); `null` is the
  /// location's own point.
  final String? name;

  /// What the named elevation is called, as `ElevationSummary.display_name`;
  /// absent for the location's own point and where the catalog has no name for
  /// the elevation.
  final String? displayName;

  /// In the response's units (m or ft).
  final double elevation;

  /// The `elevation_m` field.
  final double elevationM;

  /// The blend cycle this spot's forecast was driven with; older than
  /// `model_run.initialized_at` when the newest run did not reach the spot.
  final DateTime initializedAt;

  /// The snow-depth sensor at the spot.
  final SnowpackSpotAnchor? anchor;

  /// Hourly snow depth from `start_time` (cm or in).
  final SnowpackDepth depth;

  /// The depth at `depth.start_time` less this spot's modelled depth 24 h
  /// before, in the depth's units and rounding (cm or in; a loss is negative):
  /// the model's own change, snowfall, settlement and melt together.
  final double? depthChange24h;

  /// Hourly snow water equivalent (mm or in), parallel to `depth.p50`.
  final List<double> swe;

  /// One entry every six hours.
  final List<SnowpackStep> steps;

  /// Buried layers at `depth.start_time`, at most three.
  final List<SnowpackLayer> layers;

  /// The snow on a 38° slope at the spot facing each way, in the order north,
  /// east, south, west.
  final List<SnowpackAspect>? aspects;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (name case final v?) {
      out['name'] = v;
    }
    if (displayName case final v?) {
      out['display_name'] = v;
    }
    out['elevation'] = elevation;
    out['elevation_m'] = elevationM;
    out['initialized_at'] = formatDateTime(initializedAt);
    if (anchor case final v?) {
      out['anchor'] = v.toJson();
    }
    out['depth'] = depth.toJson();
    if (depthChange24h case final v?) {
      out['depth_change_24h'] = v;
    }
    out['swe'] = swe;
    out['steps'] = [for (final e in steps) e.toJson()];
    out['layers'] = [for (final e in layers) e.toJson()];
    if (aspects case final v?) {
      out['aspects'] = [for (final e in v) e.toJson()];
    }
    return out;
  }
}

SnowpackSpot _readSnowpackSpot(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowpackSpot(
    name: r.opt('name', asString),
    displayName: r.opt('display_name', asString),
    elevation: r.req('elevation', asDouble),
    elevationM: r.req('elevation_m', asDouble),
    initializedAt: r.req('initialized_at', asDateTime),
    anchor: r.opt('anchor', _readSnowpackSpotAnchor),
    depth: r.req('depth', _readSnowpackDepth),
    depthChange24h: r.opt('depth_change_24h', asDouble),
    swe: r.req('swe', listOf(asDouble)),
    steps: r.req('steps', listOf(_readSnowpackStep)),
    layers: r.req('layers', listOf(_readSnowpackLayer)),
    aspects: r.opt('aspects', listOf(_readSnowpackAspect)),
  );
}

/// The snow-depth sensor at the spot.
final class SnowpackSpotAnchor {
  /// Creates a [SnowpackSpotAnchor].
  SnowpackSpotAnchor({
    required this.station,
    required this.name,
    required this.network,
  });

  /// Decodes a [SnowpackSpotAnchor] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowpackSpotAnchor.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowpackSpotAnchor);

  /// The station's catalog slug.
  final String station;

  /// The `name` field.
  final String name;

  /// The `network` field.
  final String network;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['station'] = station;
    out['name'] = name;
    out['network'] = network;
    return out;
  }
}

SnowpackSpotAnchor _readSnowpackSpotAnchor(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowpackSpotAnchor(
    station: r.req('station', asString),
    name: r.req('name', asString),
    network: r.req('network', asString),
  );
}

/// One time step of a spot's snowpack: its surface and new snow.
final class SnowpackStep {
  /// Creates a [SnowpackStep].
  SnowpackStep({
    required this.validTime,
    required this.surface,
    required this.newSnow24h,
    this.newSnowDensityKgM3,
    this.settlement24h,
  });

  /// Decodes a [SnowpackStep] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SnowpackStep.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSnowpackStep);

  /// The `valid_time` field.
  final DateTime validTime;

  /// A key of `definitions.surface`: today `none`, `powder`, `wind_affected`,
  /// `settled`, `wet`, `crust` or `ice_crust`.
  final String surface;

  /// New snow of the 24 h to `valid_time`, as it lies (cm or in).
  final double newSnow24h;

  /// Its density.
  final double? newSnowDensityKgM3;

  /// How far the snow on the ground 24 h earlier settled (cm or in).
  final double? settlement24h;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['valid_time'] = formatDateTime(validTime);
    out['surface'] = surface;
    out['new_snow_24h'] = newSnow24h;
    if (newSnowDensityKgM3 case final v?) {
      out['new_snow_density_kg_m3'] = v;
    }
    if (settlement24h case final v?) {
      out['settlement_24h'] = v;
    }
    return out;
  }
}

SnowpackStep _readSnowpackStep(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SnowpackStep(
    validTime: r.req('valid_time', asDateTime),
    surface: r.req('surface', asString),
    newSnow24h: r.req('new_snow_24h', asDouble),
    newSnowDensityKgM3: r.opt('new_snow_density_kg_m3', asDouble),
    settlement24h: r.opt('settlement_24h', asDouble),
  );
}

/// One event behind a place summary's sentences (its template and values).
final class SummaryEvent {
  /// Creates a [SummaryEvent].
  SummaryEvent({
    required this.kind,
    required this.template,
    this.at,
    this.until,
    this.alertId,
    this.values,
  });

  /// Decodes a [SummaryEvent] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SummaryEvent.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSummaryEvent);

  /// What the sentence is about.
  final String kind;

  /// The phrasing used, `<template>.<variant>` (`snow_coming.v1.3`), stable
  /// across releases so sentences can be counted, reviewed and later
  /// translated.
  final String template;

  /// The hour the event begins (precipitation starting or stopping, an alert's
  /// onset, a pass event).
  final DateTime? at;

  /// When the event ends, where the sentence says so (an alert's end, a snow
  /// window's end).
  final DateTime? until;

  /// The `alerts[].id` an `alert` event states.
  final String? alertId;

  /// The served numbers the sentence states, unrounded, in the response's
  /// units.
  final SummaryValues? values;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['kind'] = kind;
    out['template'] = template;
    if (at case final v?) {
      out['at'] = formatDateTime(v);
    }
    if (until case final v?) {
      out['until'] = formatDateTime(v);
    }
    if (alertId case final v?) {
      out['alert_id'] = v;
    }
    if (values case final v?) {
      out['values'] = v.toJson();
    }
    return out;
  }
}

SummaryEvent _readSummaryEvent(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SummaryEvent(
    kind: r.req('kind', asString),
    template: r.req('template', asString),
    at: r.opt('at', asDateTime),
    until: r.opt('until', asDateTime),
    alertId: r.opt('alert_id', asString),
    values: r.opt('values', _readSummaryValues),
  );
}

/// Each number a summary sentence states, as served.
final class SummaryValues {
  /// Creates a [SummaryValues].
  SummaryValues({
    this.snowfall,
    this.snowfallP10,
    this.snowfallP90,
    this.snowfallWindow,
    this.temperature,
    this.windGust,
    this.precipitationProbability,
  });

  /// Decodes a [SummaryValues] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory SummaryValues.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readSummaryValues);

  /// The window's headline snowfall total (mm, in): for `snow_coming` the
  /// forecast's `snow_outlook.<snowfall_window>`; for `pass_snow_starts` the
  /// window's `pass.snow_windows[].total`.
  final double? snowfall;

  /// The window's served p10 (`snow_outlook.quantiles.<window>.p10`, or the
  /// pass window's `p10`).
  final double? snowfallP10;

  /// The window's served p90.
  final double? snowfallP90;

  /// Which window `snowfall` totals.
  final String? snowfallWindow;

  /// A day's served high (`daily[].high.mean`) a `day_headline` or
  /// `temperature_change` states.
  final double? temperature;

  /// The served hourly gust mean (`ensemble.wind_gust.mean`) a `wind` sentence
  /// states.
  final double? windGust;

  /// The served chance (0-1) behind the sentence's likelihood word.
  final double? precipitationProbability;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (snowfall case final v?) {
      out['snowfall'] = v;
    }
    if (snowfallP10 case final v?) {
      out['snowfall_p10'] = v;
    }
    if (snowfallP90 case final v?) {
      out['snowfall_p90'] = v;
    }
    if (snowfallWindow case final v?) {
      out['snowfall_window'] = v;
    }
    if (temperature case final v?) {
      out['temperature'] = v;
    }
    if (windGust case final v?) {
      out['wind_gust'] = v;
    }
    if (precipitationProbability case final v?) {
      out['precipitation_probability'] = v;
    }
    return out;
  }
}

SummaryValues _readSummaryValues(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return SummaryValues(
    snowfall: r.opt('snowfall', asDouble),
    snowfallP10: r.opt('snowfall_p10', asDouble),
    snowfallP90: r.opt('snowfall_p90', asDouble),
    snowfallWindow: r.opt('snowfall_window', asString),
    temperature: r.opt('temperature', asDouble),
    windGust: r.opt('wind_gust', asDouble),
    precipitationProbability: r.opt('precipitation_probability', asDouble),
  );
}

/// One forecast hour.
final class TimeSeriesPoint {
  /// Creates a [TimeSeriesPoint].
  TimeSeriesPoint({
    required this.validTime,
    required this.leadTimeHours,
    required this.isNight,
    this.measured,
    required this.condition,
    required this.conditionText,
    required this.conditionIcon,
    this.gustNotable,
    this.precipitationType,
    this.inversion,
    this.freezingLevel,
    required this.ensemble,
    this.provenance,
    this.modelMeans,
    this.members,
    this.membersCumulative,
    this.members6h,
    this.membersSpread,
    this.cumulativePrecipitation,
    this.cumulativeSnowfall,
    this.snowCharacter,
    this.precipitationByType,
  });

  /// Decodes a [TimeSeriesPoint] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory TimeSeriesPoint.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readTimeSeriesPoint);

  /// The `valid_time` field.
  final DateTime validTime;

  /// The `lead_time_hours` field.
  final int leadTimeHours;

  /// Whether this hour is nighttime at the forecast location
  final bool isNight;

  /// `true` on an hour whose values are observed, not forecast.
  final bool? measured;

  /// A stable machine code to switch on (`partly_cloudy`,
  /// `rain_snow_mix_likely`).
  final HourlyCondition condition;

  /// Human-readable weather condition for the hour, day/night aware.
  final String conditionText;

  /// The icon hint, ONE enum wherever a `condition_icon` is served (the hourly
  /// point, the daily row, `/current`'s `current` block, the elevation series).
  final ConditionIcon conditionIcon;

  /// Whether the hour's gust is worth showing beside the wind -- its median at
  /// least 1.3 times the wind's median and at least 5 mph (2.2 m/s) above it.
  final bool? gustNotable;

  /// Present when the hour's mean precipitation, at its metric served precision
  /// (0.01 mm), is at least 0.1 mm (the WMO trace), or the hour serves
  /// snowfall; absent otherwise, including a wet hour below 0.1 mm (an ensemble
  /// mean under it is a few members' drizzle, and no phase is stated for it).
  final PrecipType? precipitationType;

  /// Present only when a temperature inversion or cold pool is detected for
  /// this hour
  final InversionInfo? inversion;

  /// The hour's freezing level.
  final FreezingLevel? freezingLevel;

  /// The `ensemble` field.
  final EnsembleStats ensemble;

  /// Present only with `?diagnostics=provenance` -- which post-processing rule
  /// shaped each variable this hour.
  final HourProvenance? provenance;

  /// One entry per model with statistics at this hour, `{id, <ModelStats>}`, in
  /// `model_run.models` order.
  final List<ModelStats>? modelMeans;

  /// Per-member ensemble values, one `{id, members}` per model with members at
  /// this hour, in `model_run.models` order.
  final List<MemberGroup>? members;

  /// The distribution of the members' running totals at this hour -- for each
  /// quantity, percentiles over every member's `cumulative_precipitation` /
  /// `cumulative_snowfall` here.
  final MembersCumulative? membersCumulative;

  /// The members' 6-hour totals ending at this hour (00/06/12/18Z).
  final MembersCumulative? members6h;

  /// The members' spread at this hour for the plume's instantaneous variables
  /// -- the Quantiles of every member's own `temperature` (temperature unit)
  /// and `snow_level` (length unit) here, over the members as served.
  final MembersSpread? membersSpread;

  /// The HEADLINE's running precipitation total -- the sum of
  /// `ensemble.precipitation.mean` from the first served hour ("now") through
  /// this one, in the request's units.
  final double? cumulativePrecipitation;

  /// The headline's running snowfall total, the running sum of the day cards'
  /// snowfall (`daily[].precipitation_display.snow_amount`, the same statistic
  /// the cards show), in the request's units.
  final double? cumulativeSnowfall;

  /// The hour's snow character.
  final SnowCharacter? snowCharacter;

  /// This hour's headline precipitation (`ensemble.precipitation.mean`) split
  /// by phase, in the precipitation units -- `rain + snow + rain_snow_mix +
  /// freezing_rain` is the hour's mean (to the served precision), so a stacked
  /// bar is the headline bar.
  final PrecipitationByType? precipitationByType;

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['valid_time'] = formatDateTime(validTime);
    out['lead_time_hours'] = leadTimeHours;
    out['is_night'] = isNight;
    if (measured case final v?) {
      out['measured'] = v;
    }
    out['condition'] = condition.value;
    out['condition_text'] = conditionText;
    out['condition_icon'] = conditionIcon.value;
    if (gustNotable case final v?) {
      out['gust_notable'] = v;
    }
    if (precipitationType case final v?) {
      out['precipitation_type'] = v.toJson();
    }
    if (inversion case final v?) {
      out['inversion'] = v.toJson();
    }
    if (freezingLevel case final v?) {
      out['freezing_level'] = v.toJson();
    }
    out['ensemble'] = ensemble.toJson();
    if (provenance case final v?) {
      out['provenance'] = v.toJson();
    }
    if (modelMeans case final v?) {
      out['model_means'] = [for (final e in v) e.toJson()];
    }
    if (members case final v?) {
      out['members'] = [for (final e in v) e.toJson()];
    }
    if (membersCumulative case final v?) {
      out['members_cumulative'] = v.toJson();
    }
    if (members6h case final v?) {
      out['members_6h'] = v.toJson();
    }
    if (membersSpread case final v?) {
      out['members_spread'] = v.toJson();
    }
    if (cumulativePrecipitation case final v?) {
      out['cumulative_precipitation'] = v;
    }
    if (cumulativeSnowfall case final v?) {
      out['cumulative_snowfall'] = v;
    }
    if (snowCharacter case final v?) {
      out['snow_character'] = v.value;
    }
    if (precipitationByType case final v?) {
      out['precipitation_by_type'] = v.toJson();
    }
    return out;
  }
}

TimeSeriesPoint _readTimeSeriesPoint(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return TimeSeriesPoint(
    validTime: r.req('valid_time', asDateTime),
    leadTimeHours: r.req('lead_time_hours', asInt),
    isNight: r.req('is_night', asBool),
    measured: r.opt('measured', asBool),
    condition: r.req('condition', enumOf(HourlyCondition.new)),
    conditionText: r.req('condition_text', asString),
    conditionIcon: r.req('condition_icon', enumOf(ConditionIcon.new)),
    gustNotable: r.opt('gust_notable', asBool),
    precipitationType: r.opt('precipitation_type', _readPrecipType),
    inversion: r.opt('inversion', _readInversionInfo),
    freezingLevel: r.opt('freezing_level', _readFreezingLevel),
    ensemble: r.req('ensemble', _readEnsembleStats),
    provenance: r.opt('provenance', _readHourProvenance),
    modelMeans: r.opt('model_means', listOf(_readModelStats)),
    members: r.opt('members', listOf(_readMemberGroup)),
    membersCumulative: r.opt('members_cumulative', _readMembersCumulative),
    members6h: r.opt('members_6h', _readMembersCumulative),
    membersSpread: r.opt('members_spread', _readMembersSpread),
    cumulativePrecipitation: r.opt('cumulative_precipitation', asDouble),
    cumulativeSnowfall: r.opt('cumulative_snowfall', asDouble),
    snowCharacter: r.opt('snow_character', enumOf(SnowCharacter.new)),
    precipitationByType:
        r.opt('precipitation_by_type', _readPrecipitationByType),
  );
}

/// One answered window total: the distribution of each member's total.
final class WindowTotal {
  /// Creates a [WindowTotal].
  WindowTotal({
    required this.term,
    required this.variable,
    required this.startHours,
    required this.endHours,
    required this.aggregation,
    this.from,
    this.to,
    this.quantiles,
    required this.members,
    this.method,
    this.nullReason,
  });

  /// Decodes a [WindowTotal] from parsed JSON (unknown fields are ignored).
  ///
  /// Throws a [FormatException] when [json] does not match the schema.
  factory WindowTotal.fromJson(Map<String, Object?> json) =>
      decodeRoot(json, _readWindowTotal);

  /// The canonical term the SDK sent (`"precipitation:48h"`); the SDK matches
  /// each result to the caller's request by it.
  final String term;

  /// `precipitation` or `snowfall`.
  final TotalVariable variable;

  /// (JSON `window_start_hours`)
  final int startHours;

  /// (JSON `window_end_hours`)
  final int endHours;

  /// `total` for precipitation and snowfall.
  final TotalAggregation aggregation;

  /// The window's first instant (JSON `from`).
  final DateTime? from;

  /// The window's end (exclusive).
  final DateTime? to;

  /// The distribution, or `null` (see `null_reason`).
  final Quantiles? quantiles;

  /// The members whose values cover the whole window.
  final int members;

  /// How the total was computed: `members` or `ensemble_moments`.
  final String? method;

  /// Why `quantiles` is `null`; `null` otherwise.
  final NullReason? nullReason;

  Total? _request;

  /// The [Total] this answers, as the caller wrote it (`null` when the
  /// result was decoded on its own).
  Total? get request => _request;

  /// The window as a [Window].
  Window get window => Window(startHours, endHours);

  /// The JSON form, with the API's own field names (`null` fields left out).
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    out['term'] = term;
    out['variable'] = variable.value;
    out['window_start_hours'] = startHours;
    out['window_end_hours'] = endHours;
    out['aggregation'] = aggregation.value;
    if (from case final v?) {
      out['from'] = formatDateTime(v);
    }
    if (to case final v?) {
      out['to'] = formatDateTime(v);
    }
    if (quantiles case final v?) {
      out['quantiles'] = v.toJson();
    }
    out['members'] = members;
    if (method case final v?) {
      out['method'] = v;
    }
    if (nullReason case final v?) {
      out['null_reason'] = v.value;
    }
    return out;
  }
}

WindowTotal _readWindowTotal(Object? value, String path) {
  final r = JsonReader.of(value, path);
  return WindowTotal(
    term: r.req('term', asString),
    variable: r.req('variable', enumOf(TotalVariable.new)),
    startHours: r.req('window_start_hours', asInt),
    endHours: r.req('window_end_hours', asInt),
    aggregation: r.req('aggregation', enumOf(TotalAggregation.new)),
    from: r.opt('from', asDateTime),
    to: r.opt('to', asDateTime),
    quantiles: r.opt('quantiles', _readQuantiles),
    members: r.req('members', asInt),
    method: r.opt('method', asString),
    nullReason: r.opt('null_reason', enumOf(NullReason.new)),
  );
}

/// Records the caller's [Chance] on its answer (SDK-internal).
void bindChance(ProbabilityResult result, Chance chance) =>
    result._request = chance;

/// Records the caller's [Total] on its answer (SDK-internal).
void bindTotal(WindowTotal result, Total total) => result._request = total;
