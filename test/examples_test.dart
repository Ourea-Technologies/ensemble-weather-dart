// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

// Every example runs, against the local stub server (never the real API),
// anonymous and with a key, and the README quickstart is the example
// verbatim.

@TestOn('vm')
library;

import 'dart:io';

import 'package:test/test.dart';

import 'support/stub_server.dart';

const Set<String> required = {
  'quickstart',
  'point_forecast',
  'chance_of_snow',
  'storm_total',
  'search_and_catalog',
  'current_and_alerts',
  'error_handling',
  'units',
};

const String ciKey = 'ow_ci_example_key';

List<File> _examples() => Directory('example')
    .listSync()
    .whereType<File>()
    .where((f) => f.path.endsWith('.dart'))
    .toList()
  ..sort((a, b) => a.path.compareTo(b.path));

String _stem(File f) => f.uri.pathSegments.last.replaceAll('.dart', '');

Future<ProcessResult> _run(File example, StubServer stub, String? apiKey) {
  final env = {
    for (final e in Platform.environment.entries)
      if (!e.key.startsWith('OUREA_')) e.key: e.value,
    'OUREA_BASE_URL': stub.url,
    if (apiKey != null) 'OUREA_API_KEY': apiKey,
  };
  return Process.run(
    Platform.resolvedExecutable,
    ['run', example.path],
    environment: env,
    includeParentEnvironment: false,
  ).timeout(const Duration(minutes: 2));
}

void main() {
  late StubServer stub;
  setUpAll(() async => stub = await StubServer.start());
  tearDownAll(() => stub.close());

  test('every required example exists', () {
    expect(_examples().map(_stem).toSet(), containsAll(required));
  });

  test('every example starts with a header comment', () {
    for (final f in _examples()) {
      expect(f.readAsStringSync().startsWith('// '), isTrue, reason: f.path);
    }
  });

  test('the README quickstart is example/quickstart.dart verbatim', () {
    final readme =
        File('README.md').readAsStringSync().replaceAll('\r\n', '\n');
    final block = RegExp(r'```dart\n(.*?)```', dotAll: true).firstMatch(readme);
    expect(block, isNotNull, reason: 'README has no Dart code');
    expect(
        block!.group(1),
        File('example/quickstart.dart')
            .readAsStringSync()
            .replaceAll('\r\n', '\n'));
  });

  for (final example in _examples()) {
    for (final key in [null, ciKey]) {
      test('${_stem(example)} runs ${key == null ? 'anonymous' : 'keyed'}',
          () async {
        final done = await _run(example, stub, key);
        expect(done.exitCode, 0, reason: '${done.stderr}');
        final out = '${done.stdout}';
        expect(out.trim(), isNotEmpty,
            reason: 'an example prints what it shows');
        expect('$out${done.stderr}'.contains(ciKey), isFalse);
      }, timeout: const Timeout(Duration(minutes: 3)));
    }
  }

  test('point_forecast without a key says so', () async {
    final done = await _run(File('example/point_forecast.dart'), stub, null);
    expect(done.exitCode, 0);
    expect('${done.stdout}', contains('OUREA_API_KEY'));
  });
}
