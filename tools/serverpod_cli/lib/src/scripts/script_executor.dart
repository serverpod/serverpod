import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:serverpod_cli/src/scripts/script.dart';

/// Executes scripts defined in the `serverpod/scripts` section of pubspec.yaml.
class ScriptExecutor {
  /// Executes a script in the specified working directory.
  ///
  /// Returns the exit code of the script execution.
  /// Forwards signals (SIGINT, SIGTERM) to the child process.
  /// Streams stdout and stderr directly to the terminal.
  ///
  /// [script] - The script to execute
  /// [workingDirectory] - The directory in which to execute the script
  static Future<int> executeScript(
    Script script,
    Directory workingDirectory,
  ) async {
    final shell = Platform.isWindows ? 'cmd' : 'bash';
    final shellArg = Platform.isWindows ? '/c' : '-c';

    // NOTE: We invoke a shell instead of the script.command directly (with
    // runInShell: true). This avoid a lot of edge cases regarding quoting,
    // repeated spaces, etc.
    final process = await Process.start(
      shell,
      [shellArg, script.command],
      workingDirectory: workingDirectory.path,
    );

    // Forward signals to child process
    final sigSubscription =
        StreamGroup.merge(
          [
            ProcessSignal.sigint,
            if (!Platform.isWindows) ProcessSignal.sigterm,
          ].map((s) => s.watch()).toList(),
        ).listen((s) {
          process.kill(s);
        });

    // Forward stdin to the child process
    final stdinSubscription = stdin.listen(
      process.stdin.add,
      cancelOnError: true,
      onError: (_) {}, // extremely unlikely, but why not
    );

    // Stream output directly to terminal
    await [
      stdout.addStream(process.stdout),
      stderr.addStream(process.stderr),
    ].wait;
    await process.stdin.close();
    await stdinSubscription.cancel();
    await sigSubscription.cancel();

    return process.exitCode;
  }
}
