// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

// Copies ensemble-weather-spec into spec/ at the ref named in spec/VERSION.
//
//   dart run tool/sync_spec.dart            # rewrite spec/ from spec/VERSION
//   dart run tool/sync_spec.dart 8467faf    # pin a new ref, then rewrite spec/
//   dart run tool/sync_spec.dart --check    # exit 1 if spec/ differs from it
//
// The source repository is OUREA_SPEC_REPO when set (a URL or a local path),
// else https://github.com/Ourea-Technologies/ensemble-weather-spec.

import 'dart:io';

const String defaultRepo =
    'https://github.com/Ourea-Technologies/ensemble-weather-spec';

Future<void> _git(List<String> args, {String? cwd}) async {
  final result = await Process.run('git', args, workingDirectory: cwd);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    throw ProcessException('git', args, '${result.stderr}', result.exitCode);
  }
}

/// Writes the tree of [repo] at [ref] into [dest] (no .git).
Future<void> _export(String repo, String ref, Directory dest) async {
  final tmp = await Directory.systemTemp.createTemp('ourea-spec-');
  try {
    final clone = '${tmp.path}/spec';
    await _git(['clone', '--quiet', '--no-checkout', repo, clone]);
    final archive = '${tmp.path}/spec.tar';
    await _git(['archive', '--format=tar', '-o', archive, ref], cwd: clone);
    final untar = await Process.run('tar', ['-xf', archive, '-C', dest.path]);
    if (untar.exitCode != 0) throw StateError('tar failed: ${untar.stderr}');
  } finally {
    await tmp.delete(recursive: true);
  }
}

Map<String, List<int>> _files(Directory root) {
  final out = <String, List<int>>{};
  for (final entity in root.listSync(recursive: true)) {
    if (entity is File) {
      out[entity.path.substring(root.path.length + 1)] =
          entity.readAsBytesSync();
    }
  }
  return out;
}

bool _same(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

Future<void> main(List<String> args) async {
  final check = args.contains('--check');
  final refs = args.where((a) => !a.startsWith('--')).toList();
  final specDir = Directory('spec');
  final versionFile = File('spec/VERSION');
  final ref =
      refs.isNotEmpty ? refs.first : versionFile.readAsStringSync().trim();
  final repo = Platform.environment['OUREA_SPEC_REPO'] ?? defaultRepo;

  final tmp = await Directory.systemTemp.createTemp('ourea-spec-fresh-');
  try {
    await _export(repo, ref, tmp);
    if (check) {
      final have = _files(specDir)..remove('VERSION');
      final want = _files(tmp);
      final diffs = <String>[
        for (final name in have.keys)
          if (!want.containsKey(name)) '$name (only in spec/)',
        for (final name in want.keys)
          if (!have.containsKey(name))
            '$name (missing from spec/)'
          else if (!_same(have[name]!, want[name]!))
            '$name (differs)',
      ]..sort();
      if (diffs.isNotEmpty) {
        stderr.writeln('spec/ does not match $repo at $ref:');
        for (final line in diffs) {
          stderr.writeln('  $line');
        }
        exitCode = 1;
        return;
      }
      stdout.writeln('spec/ matches $ref');
      return;
    }
    if (specDir.existsSync()) specDir.deleteSync(recursive: true);
    specDir.createSync();
    for (final entry in _files(tmp).entries) {
      File('spec/${entry.key}')
        ..createSync(recursive: true)
        ..writeAsBytesSync(entry.value);
    }
    versionFile.writeAsStringSync('$ref\n');
    stdout.writeln('spec/ synced to $ref');
  } finally {
    await tmp.delete(recursive: true);
  }
}
