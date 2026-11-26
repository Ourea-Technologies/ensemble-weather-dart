// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

// The web (and any platform without dart:io).

/// The process environment: none on the web.
Map<String, String> processEnvironment() => const {};

/// The runtime for the User-Agent.
String runtimeLabel() => 'Dart/web';

/// Whether [error] is a TLS certificate verification failure (never retried).
bool isTlsVerificationFailure(Object error) =>
    error.toString().contains('CERTIFICATE_VERIFY_FAILED');

/// Whether [error] is a network failure worth retrying.
bool isNetworkError(Object error) => false;
