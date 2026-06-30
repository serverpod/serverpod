/// Runs the in-repo serverpod CLI (`tools/serverpod_cli`) for tests, built once
/// per `dart test` run (lock-guarded, shared across isolates) so nothing needs
/// a globally-activated `serverpod`.
///
/// The build helper below is kept identical to `serverpod_cli_e2e_test`'s
/// `run_serverpod.dart`; the two cannot share a file without a common internal
/// package.
library;

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_shared/process_io.dart';

import 'shared_test_dir.dart';

/// Path to the serverpod root (for SERVERPOD_HOME).
///
/// Found by walking up from the test's working directory until the in-repo CLI
/// is located. The depth varies per suite (e.g. `tests/serverpod_test_server`
/// is two levels below the root, but `serverpod_test_sqlite`'s server is three),
/// so a fixed number of `..` segments would point at the wrong directory.
final serverpodHome = _findServerpodHome();

final _cliRoot = p.join(
  serverpodHome,
  'tools',
  'serverpod_cli',
);

String _findServerpodHome() {
  for (var dir = Directory.current.absolute; ; dir = dir.parent) {
    if (Directory(p.join(dir.path, 'tools', 'serverpod_cli')).existsSync()) {
      return p.canonicalize(dir.path);
    }
    if (dir.parent.path == dir.path) {
      throw StateError(
        'Could not locate the serverpod repository root: no tools/serverpod_cli '
        'directory found above ${Directory.current.path}.',
      );
    }
  }
}

final _cliPath = p.join(
  _cliRoot,
  'bin',
  'serverpod_cli.dart',
);

/// Path to the compiled serverpod executable.
final compiledServerpodCliExe = _compileServerpodCli();
Future<String> _compileServerpodCli() async {
  // A prebuilt CLI bundle can be supplied via SERVERPOD_CLI_EXE (the build_cli
  // CI job builds serverpod_cli once for the whole workflow). When set and
  // present, reuse it so tests don't each recompile the CLI.
  final prebuiltExe = Platform.environment['SERVERPOD_CLI_EXE'];
  if (prebuiltExe != null && File(prebuiltExe).existsSync()) {
    return prebuiltExe;
  }

  // Build the CLI once for all tests.
  final bundleDir = p.join(sharedTestDir.path, 'serverpod_cli_build');
  // `dart build cli -o <dir>` writes the bundle to <dir>/bundle/bin/<exe>.
  final exePath = p.join(bundleDir, 'bundle', 'bin', 'serverpod_cli');
  final lockPath = p.join(sharedTestDir.path, 'serverpod_cli_build.lock');

  // If executable exists, we're done.
  if (File(exePath).existsSync()) {
    return exePath;
  }

  // Build once across the racing test isolates: the lock winner builds, the
  // rest wait and then find the executable already built.
  await InterProcessLock.withLock(
    lockPath,
    staleWhen: const StaleLockPolicy.never(),
    timeout: const Duration(minutes: 10),
    () async {
      if (File(exePath).existsSync()) return;

      var result = await Process.run(
        'dart',
        ['pub', 'get', '--directory', _cliRoot],
      );
      if (result.exitCode != 0) {
        throw StateError('Failed to resolve dependencies:\n${result.stderr}');
      }

      // `dart compile exe` rejects packages with native-asset build hooks, and
      // serverpod_cli pulls in sqlite3 (which uses them). `dart build cli`
      // bundles the executable together with those native libraries.
      result = await Process.run(
        'dart',
        ['build', 'cli', '-t', _cliPath, '-o', bundleDir],
        workingDirectory: _cliRoot,
      );
      if (result.exitCode != 0) {
        throw StateError(
          'Failed to build serverpod_cli:\n${result.stdout}\n${result.stderr}',
        );
      }
    },
  );

  return exePath;
}

/// Runs the serverpod CLI with [args] in [workingDirectory] (defaults to the
/// current directory), streaming its output, and returns the exit code.
Future<int> runServerpodCli(
  List<String> args, {
  Directory? workingDirectory,
}) async {
  final executable = await compiledServerpodCliExe;
  final process = await Process.start(
    executable,
    args,
    workingDirectory: (workingDirectory ?? Directory.current).path,
    environment: {'SERVERPOD_HOME': serverpodHome},
  );
  process.stdout.transform(utf8.decoder).listen(print);
  process.stderr.transform(utf8.decoder).listen(print);
  return process.exitCode;
}
