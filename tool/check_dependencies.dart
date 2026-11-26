// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

// Fails if pubspec.yaml declares a runtime dependency that CONTRIBUTING.md
// does not justify (SDK-STANDARD "Dependencies"). The "Runtime
// dependencies" list in CONTRIBUTING.md names each one as a bullet starting
// with the package in backticks.

import 'dart:io';

import 'package:yaml/yaml.dart';

void main() {
  final pubspec = loadYaml(File('pubspec.yaml').readAsStringSync()) as YamlMap;
  final declared =
      ((pubspec['dependencies'] as YamlMap?)?.keys ?? const <Object?>[])
          .map((k) => '$k')
          .toSet();
  final contributing = File('CONTRIBUTING.md').readAsStringSync();
  final section =
      contributing.split('### Runtime dependencies').last.split('\n## ').first;
  final bullet = RegExp(r'^- `([A-Za-z0-9_]+)`', multiLine: true);
  final justified = bullet.allMatches(section).map((m) => m.group(1)!).toSet();
  final missing = declared.difference(justified).toList()..sort();
  if (missing.isNotEmpty) {
    stderr.writeln('Runtime dependencies without a justification in '
        'CONTRIBUTING.md:');
    for (final name in missing) {
      stderr.writeln('  - $name');
    }
    exitCode = 1;
    return;
  }
  stdout.writeln('All ${declared.length} runtime dependencies are justified.');
}
