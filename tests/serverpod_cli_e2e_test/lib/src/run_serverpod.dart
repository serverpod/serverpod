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

      // Guard multiple runs from touching tools/serverpod_cli/.dart_tool concurrently
      await InterProcessLock.withLock(
        _treeBuildLockPath(_cliRoot),
        staleWhen: const StaleLockPolicy.processLiveness(
          staleAfter: Duration(minutes: 2),
        ),
        timeout: const Duration(minutes: 10),
        heartbeatInterval: const Duration(seconds: 30),
        () async {
          var result = await Process.run(
            'dart',
            ['pub', 'get', '--directory', _cliRoot],
          );
          if (result.exitCode != 0) {
            throw StateError(
              'Failed to resolve dependencies:\n${result.stderr}',
            );
          }

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
    },
  );

  return exePath;
}

String _treeBuildLockPath(String cliRoot) {
  final key = cliRoot.replaceAll(RegExp('[^a-zA-Z0-9]'), '_');
  return p.join(Directory.systemTemp.path, 'serverpod_cli_build_$key.lock');
}

final _activatedServerpodCliExe = _activateServerpodCli();
Future<String> _activateServerpodCli() async {
  final result = await Process.run(
    'dart',
    ['pub', 'global', 'activate', '--overwrite', '--source', 'path', _cliRoot],
  );
  if (result.exitCode != 0) {
    throw StateError('Failed to activate serverpod_cli:\n${result.stderr}');
  }
  return 'serverpod';
}

enum RunType {
  dartRun,
  activated,
  compiled,
  installed, // 3.10 feature
}

Future<(String exe, List<String> args)> _resolveCommand(
  List<String> args,
  RunType runType,
) async {
  return switch (runType) {
    RunType.dartRun => ('dart', ['run', _cliPath, ...args]),
    RunType.compiled => (await compiledServerpodCliExe, args),
    RunType.activated => (await _activatedServerpodCliExe, args),
    RunType.installed => throw UnimplementedError(), // 3.10 feature
  };
}

/// Runs `serverpod` with the given arguments.
Future<ProcessResult> runServerpod(
  List<String> args, {
  String? workingDirectory,
  RunType runType = RunType.compiled,
  List<String> implicitArgs = const ['--verbose', '--no-analytics'],
}) async {
  workingDirectory ??= Directory.current.path;
  final (exe, fullArgs) = await _resolveCommand([
    ...args,
    ...implicitArgs,
  ], runType);
  return Process.run(
    exe,
    fullArgs,
    workingDirectory: workingDirectory,
    environment: {'SERVERPOD_HOME': serverpodHome},
  );
}

/// Starts `serverpod` with the given arguments.
///
/// Unlike [runServerpod], this returns a [Process] that can be interacted with
/// (e.g., to send signals or read stdout/stderr incrementally).
Future<Process> startServerpod(
  List<String> args, {
  required String workingDirectory,
  RunType runType = RunType.compiled,
}) async {
  final (exe, fullArgs) = await _resolveCommand(args, runType);
  return Process.start(
    exe,
    fullArgs,
    workingDirectory: workingDirectory,
    environment: {'SERVERPOD_HOME': serverpodHome},
  );
}
