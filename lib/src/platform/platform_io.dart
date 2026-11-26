// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

// The Dart VM: command line, server, and Flutter on mobile and desktop.

import 'dart:io';

/// The process environment.
Map<String, String> processEnvironment() => Platform.environment;

/// The runtime for the User-Agent, for example `Dart/3.10.0`.
String runtimeLabel() => 'Dart/${Platform.version.split(' ').first}';

/// Whether [error] is a TLS certificate verification failure (never retried).
bool isTlsVerificationFailure(Object error) =>
    error is HandshakeException ||
    error is CertificateException ||
    error.toString().contains('CERTIFICATE_VERIFY_FAILED');

/// Whether [error] is a network failure worth retrying.
bool isNetworkError(Object error) =>
    error is SocketException || error is HttpException;
