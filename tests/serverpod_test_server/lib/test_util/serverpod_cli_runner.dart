/// Runs the in-repo serverpod CLI (`tools/serverpod_cli`) for tests, built
/// once per version of its sources (lock-guarded, shared across processes)
/// so nothing needs a globally-activated `serverpod`.
library;

import 'dart:convert';
import 'dart:io';

import 'package:serverpod_shared/process_io.dart';

/// Path to the serverpod root (for SERVERPOD_HOME).
final serverpodHome = findServerpodHome();

/// Path to the compiled serverpod executable.
final compiledServerpodCliExe = buildServerpodCli(serverpodHome: serverpodHome);

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
