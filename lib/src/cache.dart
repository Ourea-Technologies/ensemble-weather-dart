// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

/// The local ETag cache (BEHAVIOR.md 10).
///
/// The cache is on by default: an in-memory LRU of 256 entries and 32 MiB.
/// For a stored entry the client sends `If-None-Match` with the ETag exactly
/// as received, and a `304 Not Modified` answer returns the stored body.
/// Entries are keyed by the full URL plus a hash of the API key (never the
/// key itself), so keyless and keyed entries never mix.
///
/// The SDK is a private cache: it honours `max-age` (which the API sets to
/// 0, so every call revalidates) and ignores `s-maxage` and
/// `stale-while-revalidate`, which are for the edge. A `no-store` response
/// is never stored.
///
/// To share a cache, implement [Cache] over your own store and pass it as
/// `OureaClient(cache: ...)`. Pass `cache: const NoCache()` to disable
/// caching.
library;

import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

/// The default bound on the number of entries of a [MemoryCache].
const int defaultCacheEntries = 256;

/// The default bound on the stored bytes of a [MemoryCache] (32 MiB).
const int defaultCacheBytes = 32 * 1024 * 1024;

/// One stored response.
final class CacheEntry {
  /// Creates an entry.
  const CacheEntry({
    required this.body,
    required this.etag,
    required this.headers,
    required this.storedAt,
    this.maxAge,
  });

  /// The response body, as received.
  final Uint8List body;

  /// The `ETag` header, byte for byte (`W/` included).
  final String? etag;

  /// The response headers, with names in lower case.
  final Map<String, String> headers;

  /// When the entry was stored or last revalidated.
  final DateTime storedAt;

  /// The `max-age` freshness lifetime, if the response gave one.
  final Duration? maxAge;

  /// Whether the entry may be served at [now] without revalidating.
  bool isFresh(DateTime now) {
    final age = maxAge;
    return age != null && age > Duration.zero && now.difference(storedAt) < age;
  }
}

/// A store for cached responses.
///
/// Each method may answer synchronously or with a [Future], so a store can
/// sit on disk or in another process.
abstract interface class Cache {
  /// The entry stored under [key], if any.
  FutureOr<CacheEntry?> get(String key);

  /// Stores [entry] under [key], replacing any previous one.
  FutureOr<void> set(String key, CacheEntry entry);

  /// Removes the entry under [key], if any.
  FutureOr<void> delete(String key);
}

/// A [Cache] that stores nothing: pass `cache: const NoCache()` to disable
/// caching.
final class NoCache implements Cache {
  /// Creates the no-op cache.
  const NoCache();

  @override
  CacheEntry? get(String key) => null;

  @override
  void set(String key, CacheEntry entry) {}

  @override
  void delete(String key) {}
}

/// An in-memory LRU cache bounded by entries and bytes.
final class MemoryCache implements Cache {
  /// An empty cache holding at most [maxEntries] entries and [maxBytes] bytes
  /// of bodies.
  MemoryCache({
    this.maxEntries = defaultCacheEntries,
    this.maxBytes = defaultCacheBytes,
  }) {
    if (maxEntries < 1 || maxBytes < 1) {
      throw ArgumentError('cache bounds must be positive');
    }
  }

  /// The most entries kept.
  final int maxEntries;

  /// The most body bytes kept.
  final int maxBytes;

  // A LinkedHashMap iterates in insertion order; re-inserting on use makes
  // the first key the least recently used.
  final LinkedHashMap<String, CacheEntry> _entries = LinkedHashMap();
  int _bytes = 0;

  /// The number of stored entries.
  int get length => _entries.length;

  /// The total size of the stored bodies.
  int get sizeBytes => _bytes;

  @override
  CacheEntry? get(String key) {
    final entry = _entries.remove(key);
    if (entry != null) _entries[key] = entry;
    return entry;
  }

  @override
  void set(String key, CacheEntry entry) {
    _remove(key);
    final size = entry.body.length;
    if (size > maxBytes) return;
    _entries[key] = entry;
    _bytes += size;
    while (_entries.length > maxEntries || _bytes > maxBytes) {
      _remove(_entries.keys.first);
    }
  }

  @override
  void delete(String key) => _remove(key);

  /// Removes every entry.
  void clear() {
    _entries.clear();
    _bytes = 0;
  }

  void _remove(String key) {
    final old = _entries.remove(key);
    if (old != null) _bytes -= old.body.length;
  }
}
