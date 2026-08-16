import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_shared/process_io.dart';

/// Path to the serverpod root (for SERVERPOD_HOME).
final serverpodHome = findServerpodHome();

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
final compiledServerpodCliExe = buildServerpodCli(
  buildRoot: p.join(sharedTestDir.path, 'serverpod_cli_build'),
  serverpodHome: serverpodHome,
);

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
  Map<String, String> environment = const {},
}) async {
  final (exe, fullArgs) = await _resolveCommand(args, runType);
  return Process.start(
    exe,
    fullArgs,
    workingDirectory: workingDirectory,
    environment: {'SERVERPOD_HOME': serverpodHome, ...environment},
  );
}
