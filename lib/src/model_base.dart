// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

/// What every model shares: response metadata, the rate-limit state, and
/// the quantile views.
library;

import 'errors.dart';

/// Anything naming a location: its state and slug.
///
/// Pass `place.state` with `slug: place.slug` to the location methods, for
/// example `OureaClient.getForecast`.
abstract interface class NamedLocation {
  /// The state code, for example `or`.
  String get state;

  /// The location slug, or `null` (a coordinate forecast's location).
  String? get slug;
}

/// The rate-limit state a response reported (the `RateLimit-*` headers).
///
/// The SDK never hard-codes limits: these are what the server said. They are
/// absent on responses the edge may share between callers (anonymous,
/// edge-cacheable ones), so every field may be `null`.
final class RateLimit {
  /// Creates a rate-limit state.
  const RateLimit({this.limit, this.remaining, this.reset, this.policy});

  /// The size of the budget this response counts against.
  final int? limit;

  /// Requests left before the binding limit refuses.
  final int? remaining;

  /// Seconds until the binding limit is whole again.
  final int? reset;

  /// The budgets, for example `"60;w=60, 10000;w=86400"`.
  final String? policy;

  /// Reads the state from response headers (names in lower case), or `null`
  /// if there is none.
  static RateLimit? fromHeaders(Map<String, String> headers) {
    int? number(String name) {
      final raw = headers[name];
      return raw == null ? null : int.tryParse(raw.trim());
    }

    final state = RateLimit(
      limit: number('ratelimit-limit'),
      remaining: number('ratelimit-remaining'),
      reset: number('ratelimit-reset'),
      policy: headers['ratelimit-policy'],
    );
    final empty = state.limit == null &&
        state.remaining == null &&
        state.reset == null &&
        state.policy == null;
    return empty ? null : state;
  }

  @override
  bool operator ==(Object other) =>
      other is RateLimit &&
      other.limit == limit &&
      other.remaining == remaining &&
      other.reset == reset &&
      other.policy == policy;

  @override
  int get hashCode => Object.hash(limit, remaining, reset, policy);

  @override
  String toString() => 'RateLimit(limit: $limit, remaining: $remaining, '
      'reset: $reset, policy: $policy)';
}

/// What the HTTP exchange said about a response, beyond its body.
final class ResponseMeta {
  /// Creates the metadata.
  const ResponseMeta({
    this.status = 200,
    this.url = '',
    this.headers = const {},
    this.requestId,
    this.rateLimit,
    this.etag,
    this.revalidated = false,
    this.fromCache = false,
  });

  /// The final HTTP status (`304` when the server revalidated the cached
  /// body).
  final int status;

  /// The URL the SDK requested.
  final String url;

  /// The final response's headers, with names in lower case.
  final Map<String, String> headers;

  /// The `X-Request-Id` header, for support.
  final String? requestId;

  /// The rate-limit state, if the response reported one.
  final RateLimit? rateLimit;

  /// The representation's entity tag.
  final String? etag;

  /// Whether the server answered `304 Not Modified` and the body came from
  /// the local cache.
  final bool revalidated;

  /// Whether the body came from the local cache.
  final bool fromCache;
}

/// The base of every top-level response: adds [meta].
abstract class Response {
  ResponseMeta _meta = const ResponseMeta();

  /// The HTTP exchange's details: status, headers, rate limit, revalidation.
  ResponseMeta get meta => _meta;

  /// Shortcut for `meta.rateLimit`.
  RateLimit? get rateLimit => _meta.rateLimit;

  /// Shortcut for `meta.revalidated`.
  bool get revalidated => _meta.revalidated;
}

/// Sets the metadata of a decoded response (SDK-internal).
void attachMeta(Response response, ResponseMeta meta) => response._meta = meta;

/// The named views of a distribution: [median] and [range].
///
/// There is no interpolation: only the percentiles the server sent are
/// read, and only the pairs it serves (p10-p90 and p25-p75) are ranges.
mixin QuantileViews {
  /// The 10th percentile.
  double? get p10;

  /// The 25th percentile.
  double? get p25;

  /// The median.
  double? get p50;

  /// The 75th percentile.
  double? get p75;

  /// The 90th percentile.
  double? get p90;

  /// The median (p50). It is the median, not "the forecast".
  double? get median => p50;

  /// The `(low, high)` percentiles, for example `range(10, 90)`.
  ///
  /// Only the pairs the server serves are allowed: 10-90 and 25-75. There is
  /// no interpolation. Returns `null` when the server did not send both
  /// ends. Throws a [UsageException] for any other pair.
  (double, double)? range([int low = 10, int high = 90]) {
    final (double?, double?) ends;
    if (low == 10 && high == 90) {
      ends = (p10, p90);
    } else if (low == 25 && high == 75) {
      ends = (p25, p75);
    } else {
      throw UsageException(
        'the server serves p10-p90 and p25-p75, not p$low-p$high',
      );
    }
    final (lo, hi) = ends;
    return lo == null || hi == null ? null : (lo, hi);
  }
}
