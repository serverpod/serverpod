import 'dart:io';

import 'package:path/path.dart' as p;

import 'shared_test_dir.dart';

/// Path to the serverpod root (for SERVERPOD_HOME).
final serverpodHome = p.canonicalize(
  p.join(Directory.current.path, '..', '..'),
);

final _cliRoot = p.join(
  serverpodHome,
  'tools',
  'serverpod_cli',
);

final _cliPath = p.join(
  _cliRoot,
  'bin',
  'serverpod_cli.dart',
);

/// Path to the compiled serverpod executable.
final compiledServerpodCliExe = _compileServerpodCli();
Future<String> _compileServerpodCli() async {
  // Compile the CLI once for all tests
  const exeName = 'serverpod_cli_test.exe';
  final exePath = p.join(sharedTestDir.path, exeName);
  final lockPath = p.join(sharedTestDir.path, '$exeName.lock');
  final lockFile = File(lockPath);

  // If executable exists, we're done
  if (File(exePath).existsSync()) {
    return exePath;
  }

  // Try to create lock file exclusively - only one isolate succeeds
  try {
    lockFile.createSync(exclusive: true);
  } on FileSystemException {
    // Another isolate is compiling, wait for lock to be released
    while (lockFile.existsSync()) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    return exePath;
  }

  try {
    var result = await Process.run(
      'dart',
      ['pub', 'get', '--directory', _cliRoot],
    );
    if (result.exitCode != 0) {
      throw StateError('Failed to resolve dependencies:\n${result.stderr}');
    }

    result = await Process.run(
      'dart',
      ['compile', 'exe', _cliPath, '-o', exePath],
    );
    if (result.exitCode != 0) {
      throw StateError('Failed to compile serverpod_cli:\n${result.stderr}');
    }
  } finally {
    lockFile.deleteSync();
  }

  return exePath;
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
}) async {
  workingDirectory ??= Directory.current.path;
  final (exe, fullArgs) = await _resolveCommand(args, runType);
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
