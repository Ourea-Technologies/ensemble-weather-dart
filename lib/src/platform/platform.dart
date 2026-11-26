// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

/// What differs between the Dart VM (and Flutter on mobile and desktop) and
/// the web (SDK-internal). The VM version uses `dart:io`; the web has no
/// process environment and sets its own User-Agent.
library;

export 'platform_stub.dart' if (dart.library.io) 'platform_io.dart';
