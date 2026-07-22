import 'dart:io';

import 'package:path/path.dart' as p;

import 'interprocess_lock.dart';
import 'sdk_path.dart';

/// Locates the serverpod repository root: walks up from [from] (defaults to
/// the current directory) until `tools/serverpod_cli` is found.
///
/// For the serverpod repository's own test suites. The suites sit at varying
/// depths (e.g. `tests/serverpod_test_server` is two levels below the root
/// but the SQLite server is three), so a fixed number of `..` segments would
/// point at the wrong directory.
String findServerpodHome({Directory? from}) {
  final start = (from ?? Directory.current).absolute;
  for (var dir = start; ; dir = dir.parent) {
    if (Directory(p.join(dir.path, 'tools', 'serverpod_cli')).existsSync()) {
      return p.canonicalize(dir.path);
    }
    if (dir.parent.path == dir.path) {
      throw StateError(
        'Could not locate the serverpod repository root: no '
        'tools/serverpod_cli directory found above ${start.path}.',
      );
    }
  }
}

/// Builds the serverpod repository's in-repo CLI once and returns the path
/// to the executable (`<buildRoot>/bundle/bin/serverpod_cli`).
///
/// For the repository's own test suites, which run the CLI without a
/// globally activated `serverpod`:
/// - A prebuilt bundle is reused when `SERVERPOD_CLI_EXE` points at one
///   (CI's build_cli job builds the CLI once for the whole workflow).
/// - One build per [buildRoot]: concurrent callers (a run's suite isolates
///   sharing a per-run root) elect a single builder via a lock; the rest
///   wait and reuse its output.
/// - Builds against one checkout are serialized across runs (a second lock,
///   keyed on the checkout): `dart pub get` and the compile both touch the
///   shared tools/serverpod_cli/.dart_tool.
Future<String> buildServerpodCli({
  required String buildRoot,
  String? serverpodHome,
}) async {
  final prebuilt = Platform.environment['SERVERPOD_CLI_EXE'];
  if (prebuilt != null && File(prebuilt).existsSync()) return prebuilt;

  final home = serverpodHome ?? findServerpodHome();
  final cliRoot = p.join(home, 'tools', 'serverpod_cli');
  final exePath = p.join(
    buildRoot,
    'bundle',
    'bin',
    Platform.isWindows ? 'serverpod_cli.exe' : 'serverpod_cli',
  );
  if (File(exePath).existsSync()) return exePath;

  await InterProcessLock.withLock(
    '$buildRoot.lock',
    staleWhen: const StaleLockPolicy.processLiveness(
      staleAfter: Duration(minutes: 2),
    ),
    timeout: const Duration(minutes: 10),
    heartbeatInterval: const Duration(seconds: 30),
    () async {
      if (File(exePath).existsSync()) return;

      await InterProcessLock.withLock(
        _treeBuildLockPath(cliRoot),
        staleWhen: const StaleLockPolicy.processLiveness(
          staleAfter: Duration(minutes: 2),
        ),
        timeout: const Duration(minutes: 10),
        heartbeatInterval: const Duration(seconds: 30),
        () async {
          var result = await Process.run(dartExecutablePath, [
            'pub',
            'get',
          ], workingDirectory: cliRoot);
          if (result.exitCode != 0) {
            throw StateError(
              'pub get in $cliRoot failed:'
              '\n${result.stdout}\n${result.stderr}',
            );
          }

          // `dart build cli` (not `dart compile exe`): serverpod_cli pulls
          // sqlite3, whose native-asset build hooks `dart compile exe`
          // rejects.
          result = await Process.run(dartExecutablePath, [
            'build',
            'cli',
            '-t',
            p.join(cliRoot, 'bin', 'serverpod_cli.dart'),
            '-o',
            buildRoot,
          ], workingDirectory: cliRoot);
          if (result.exitCode != 0) {
            throw StateError(
              'dart build cli failed:\n${result.stdout}\n${result.stderr}',
            );
          }
        },
      );
    },
  );

  return exePath;
}

/// Lock serializing CLI builds against one checkout, shared by every run in
/// that tree (the per-run build locks are keyed on their build roots and so
/// do not exclude each other).
String _treeBuildLockPath(String cliRoot) {
  final key = cliRoot.replaceAll(RegExp('[^a-zA-Z0-9]'), '_');
  return p.join(Directory.systemTemp.path, 'serverpod_cli_build_$key.lock');
}
