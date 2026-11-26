// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

/// The exceptions the SDK throws.
///
/// Everything the SDK throws is an [OureaException]. Errors that come with an
/// HTTP response are [ApiException]s carrying its [ApiException.status],
/// [ApiException.code] (the API's error string, verbatim, even when this SDK
/// does not know it), message, [ApiException.requestId] and
/// [ApiException.docUrl]. Catch the subclass for the category you care
/// about:
///
/// ```dart
/// try {
///   await client.getPointForecast(45.0, 10.0);
/// } on OutsideCoverageException catch (e) {
///   print('${e.code}: ${e.message}');
/// }
/// ```
///
/// The API key never appears in an exception's message or `toString()`.
library;

import 'model_base.dart';
import 'types.dart' show NearestLocation;

/// The base of every exception the SDK throws.
sealed class OureaException implements Exception {
  /// Creates the exception with a human-readable [message].
  OureaException(this.message);

  /// What went wrong.
  final String message;

  /// The BEHAVIOR.md section 8 category, in snake_case (for example
  /// `not_found`).
  String get category;

  @override
  String toString() => message;
}

/// The call was refused before anything was sent.
///
/// For example an aggregation a variable does not support, a threshold unit
/// of the wrong kind, a quantile pair the server does not serve, or a
/// coordinate out of range.
final class UsageException extends OureaException {
  /// Creates the exception.
  UsageException(super.message);

  @override
  String get category => 'usage';
}

/// No HTTP response arrived: DNS, TLS, connection reset or timeout.
final class ApiConnectionException extends OureaException {
  /// Creates the exception.
  ApiConnectionException(super.message);

  @override
  String get category => 'connection';
}

/// A successful response could not be read as the documented model.
class UnexpectedResponseException extends OureaException {
  /// Creates the exception.
  UnexpectedResponseException(super.message);

  @override
  String get category => 'unexpected_response';
}

/// A response body was over the SDK's size bound (64 MiB).
final class ResponseTooLargeException extends UnexpectedResponseException {
  /// Creates the exception for a body over [limit] bytes.
  ResponseTooLargeException(this.limit)
      : super('the response body is larger than '
            '${limit ~/ (1024 * 1024)} MiB');

  /// The bound that was exceeded, in bytes.
  final int limit;
}

/// The API answered with an error status.
class ApiException extends OureaException {
  /// Creates the exception from a response's parts.
  ApiException(
    super.message, {
    required this.status,
    this.code,
    this.requestId,
    this.docUrl,
    this.param,
    this.retryAfter,
    this.rateLimit,
  });

  /// The HTTP status code.
  final int status;

  /// The API's error code (`LOCATION_NOT_FOUND`), verbatim, or `null` when
  /// the body was not the API's JSON error shape (JSON `error`).
  final String? code;

  /// The request's id, for support (the body's `request_id`, else the
  /// `X-Request-Id` header).
  final String? requestId;

  /// The documentation of the error code, when the body names it.
  final String? docUrl;

  /// The query parameter a `400` is about, when it names one.
  final String? param;

  /// How long the server asked the client to wait, if it did.
  final Duration? retryAfter;

  /// The rate-limit state the response reported, if any.
  final RateLimit? rateLimit;

  @override
  String get category => 'api';

  /// `"<status> <code>: <message>"`, plus the request id when there is one.
  @override
  String toString() {
    final label = code == null ? '$status' : '$status $code';
    final id = requestId == null ? '' : ' (request id $requestId)';
    return '$label: $message$id';
  }
}

/// The API key is missing where required, unknown or revoked (401).
final class AuthenticationException extends ApiException {
  /// Creates the exception.
  AuthenticationException(
    super.message, {
    required super.status,
    super.code,
    super.requestId,
    super.docUrl,
    super.param,
    super.retryAfter,
    super.rateLimit,
  });

  @override
  String get category => 'authentication';
}

/// The key's tier does not allow this request, for example `PRO_REQUIRED` or
/// `PLUS_REQUIRED` (403).
final class PermissionDeniedException extends ApiException {
  /// Creates the exception.
  PermissionDeniedException(
    super.message, {
    required super.status,
    super.code,
    super.requestId,
    super.docUrl,
    super.param,
    super.retryAfter,
    super.rateLimit,
    this.nearestLocation,
  });

  /// On a `PRO_REQUIRED` coordinate request, the nearest named location whose
  /// forecast answers without a key, if one is close enough.
  final NearestLocation? nearestLocation;

  @override
  String get category => 'permission';
}

/// The location or resource does not exist (404, 410).
final class NotFoundException extends ApiException {
  /// Creates the exception.
  NotFoundException(
    super.message, {
    required super.status,
    super.code,
    super.requestId,
    super.docUrl,
    super.param,
    super.retryAfter,
    super.rateLimit,
  });

  @override
  String get category => 'not_found';
}

/// The server refused the request's parameters (400).
final class InvalidRequestException extends ApiException {
  /// Creates the exception.
  InvalidRequestException(
    super.message, {
    required super.status,
    super.code,
    super.requestId,
    super.docUrl,
    super.param,
    super.retryAfter,
    super.rateLimit,
  });

  @override
  String get category => 'invalid_request';
}

/// The coordinates are outside the forecast domain (`OUTSIDE_COVERAGE`, a
/// 404).
final class OutsideCoverageException extends ApiException {
  /// Creates the exception.
  OutsideCoverageException(
    super.message, {
    required super.status,
    super.code,
    super.requestId,
    super.docUrl,
    super.param,
    super.retryAfter,
    super.rateLimit,
  });

  @override
  String get category => 'outside_coverage';
}

/// Too many requests (429). See [ApiException.retryAfter].
final class RateLimitException extends ApiException {
  /// Creates the exception.
  RateLimitException(
    super.message, {
    required super.status,
    super.code,
    super.requestId,
    super.docUrl,
    super.param,
    super.retryAfter,
    super.rateLimit,
  });

  @override
  String get category => 'rate_limited';
}

/// The API could not answer right now (5xx), for example
/// `FORECAST_UNAVAILABLE`.
final class UnavailableException extends ApiException {
  /// Creates the exception.
  UnavailableException(
    super.message, {
    required super.status,
    super.code,
    super.requestId,
    super.docUrl,
    super.param,
    super.retryAfter,
    super.rateLimit,
  });

  @override
  String get category => 'unavailable';
}

enum _Kind {
  authentication,
  permission,
  notFound,
  invalidRequest,
  outsideCoverage,
  rateLimited,
  unavailable,
  other,
}

// The public spec's ErrorResponse.error codes (BEHAVIOR.md 8). Any other code
// keeps its string and maps by status.
const Map<String, _Kind> _byCode = {
  'INVALID_API_KEY': _Kind.authentication,
  'UNAUTHORIZED': _Kind.authentication,
  'PRO_REQUIRED': _Kind.permission,
  'PLUS_REQUIRED': _Kind.permission,
  'LOCATION_NOT_FOUND': _Kind.notFound,
  'NOT_FOUND': _Kind.notFound,
  'BAD_REQUEST': _Kind.invalidRequest,
  'INVALID_COORDINATES': _Kind.invalidRequest,
  'INVALID_ELEVATION': _Kind.invalidRequest,
  'ELEVATION_REQUIRED': _Kind.invalidRequest,
  'OUTSIDE_COVERAGE': _Kind.outsideCoverage,
  'TOO_MANY_REQUESTS': _Kind.rateLimited,
  'FORECAST_UNAVAILABLE': _Kind.unavailable,
  'TIMEOUT': _Kind.unavailable,
  'INTERNAL_ERROR': _Kind.unavailable,
  'DATABASE_ERROR': _Kind.unavailable,
  'AUTH_UNAVAILABLE': _Kind.unavailable,
};

const Map<int, _Kind> _byStatus = {
  400: _Kind.invalidRequest,
  401: _Kind.authentication,
  403: _Kind.permission,
  404: _Kind.notFound,
  410: _Kind.notFound,
  429: _Kind.rateLimited,
};

/// Whether [code] is one of the error codes this SDK maps by name.
bool isKnownErrorCode(String code) => _byCode.containsKey(code);

/// The exception for an error response: by code first, then by status
/// (SDK-internal).
ApiException apiException(
  String message, {
  required int status,
  String? code,
  String? requestId,
  String? docUrl,
  String? param,
  Duration? retryAfter,
  RateLimit? rateLimit,
  NearestLocation? nearestLocation,
}) {
  final kind = (code == null ? null : _byCode[code]) ??
      _byStatus[status] ??
      (status >= 500 && status <= 599 ? _Kind.unavailable : _Kind.other);
  return switch (kind) {
    _Kind.authentication => AuthenticationException(message,
        status: status,
        code: code,
        requestId: requestId,
        docUrl: docUrl,
        param: param,
        retryAfter: retryAfter,
        rateLimit: rateLimit),
    _Kind.permission => PermissionDeniedException(message,
        status: status,
        code: code,
        requestId: requestId,
        docUrl: docUrl,
        param: param,
        retryAfter: retryAfter,
        rateLimit: rateLimit,
        nearestLocation: nearestLocation),
    _Kind.notFound => NotFoundException(message,
        status: status,
        code: code,
        requestId: requestId,
        docUrl: docUrl,
        param: param,
        retryAfter: retryAfter,
        rateLimit: rateLimit),
    _Kind.invalidRequest => InvalidRequestException(message,
        status: status,
        code: code,
        requestId: requestId,
        docUrl: docUrl,
        param: param,
        retryAfter: retryAfter,
        rateLimit: rateLimit),
    _Kind.outsideCoverage => OutsideCoverageException(message,
        status: status,
        code: code,
        requestId: requestId,
        docUrl: docUrl,
        param: param,
        retryAfter: retryAfter,
        rateLimit: rateLimit),
    _Kind.rateLimited => RateLimitException(message,
        status: status,
        code: code,
        requestId: requestId,
        docUrl: docUrl,
        param: param,
        retryAfter: retryAfter,
        rateLimit: rateLimit),
    _Kind.unavailable => UnavailableException(message,
        status: status,
        code: code,
        requestId: requestId,
        docUrl: docUrl,
        param: param,
        retryAfter: retryAfter,
        rateLimit: rateLimit),
    _Kind.other => ApiException(message,
        status: status,
        code: code,
        requestId: requestId,
        docUrl: docUrl,
        param: param,
        retryAfter: retryAfter,
        rateLimit: rateLimit),
  };
}
