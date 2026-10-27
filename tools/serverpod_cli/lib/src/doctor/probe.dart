import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Runs [executable] with [arguments] and returns its result, or `null` if
/// it did not exit and close its output within [timeout]. The process is
/// killed on timeout so it cannot outlive the doctor run.
Future<ProcessResult?> runProbe(
  final String executable,
  final List<String> arguments, {
  final Duration timeout = const Duration(seconds: 10),
}) async {
  final Process process;
  try {
    process = await Process.start(
      executable,
      arguments,
      // Batch wrappers like flutter.bat only run through the shell, while
      // the shell mangles executable paths with spaces.
      runInShell: _isBatchFile(executable),
    );
  } on ProcessException catch (e) {
    log.debug('Could not start $executable: ${e.message}');
    return null;
  }

  final stdout = process.stdout
      .transform(const SystemEncoding().decoder)
      .join();
  final stderr = process.stderr
      .transform(const SystemEncoding().decoder)
      .join();

  try {
    // A wrapper can exit while a child it spawned still holds the output
    // pipes open, so the output must be under the timeout too.
    final (exitCode, out, err) = await (
      process.exitCode,
      stdout,
      stderr,
    ).wait.timeout(timeout);
    return ProcessResult(process.pid, exitCode, out, err);
  } on TimeoutException {
    log.debug('$executable ${arguments.join(' ')} timed out after $timeout.');
    process.kill();
    return null;
  }
}

bool _isBatchFile(final String executable) {
  final lower = executable.toLowerCase();
  return lower.endsWith('.bat') || lower.endsWith('.cmd');
}
