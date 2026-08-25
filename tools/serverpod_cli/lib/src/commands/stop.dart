import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:meta/meta.dart';
import 'package:serverpod_cli/src/commands/runner_options.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/commands/status.dart'
    show resolveRunnerOrExit, resolveServerDirectory;
import 'package:serverpod_cli/src/runner/runner_client.dart';
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_lock.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_stage.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Options for the `stop` command.
enum StopOption<V> implements OptionDefinition<V> {
  directory<String>(clientDirectoryOption),
  ;

  const StopOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// Shuts the runner down.
///
/// This and Shift+Q in the UI are the only things that stop the stack.
/// Detaching never does.
class StopCommand extends ServerpodCommand<StopOption> {
  @override
  final name = 'stop';

  @override
  final description = 'Stop the development stack running for this project.';

  @override
  String get invocation => 'serverpod runner stop';

  StopCommand() : super(options: StopOption.values);

  @override
  Future<void> runWithConfig(Configuration<StopOption> commandConfig) async {
    final serverDir = await resolveServerDirectory(
      commandConfig.optionalValue(StopOption.directory),
    );

    final resolution = await resolveRunnerOrExit(serverDir.path);
    switch (resolution) {
      case NoRunner(lockHeld: false) || NoRunner(staleManifest: null):
        log.info('No serverpod runner is running for this project.');

      case NoRunner(staleManifest: final manifest?, lockHeld: true)
          when manifest.stage == RunnerStage.stopping:
        log.info('The runner (pid ${manifest.pid}) is already stopping.');
        await _reportShutdown(serverDir.path);

      case NoRunner(staleManifest: final manifest?, lockHeld: true):
      case IncompatibleRunner(:final manifest):
        await _stopByPid(manifest.pid, serverDir.path);

      case LiveRunner(:final manifest):
        if (manifest.sockets.tui.isEmpty) {
          await _stopByPid(manifest.pid, serverDir.path);
          return;
        }
        await _stopOverSocket(manifest.sockets.tui, serverDir.path);
    }
  }

  Future<void> _stopOverSocket(String socketPath, String serverDir) async {
    final client = RunnerClient(socketPath: socketPath);
    try {
      await client.connect();
    } on RunnerUnreachableException {
      log.info('No serverpod runner is running for this project.');
      return;
    }

    try {
      await client.stop();
    } catch (_) {}
    await client.close();
    await _reportShutdown(serverDir);
  }

  Future<void> _reportShutdown(String serverDir) async {
    if (await awaitRunnerShutdown(serverDir)) {
      log.info('Server stopped.');
    } else {
      log.warning(
        'The runner accepted the stop but is still shutting down. '
        'Check `serverpod runner status`.',
      );
    }
  }

  /// Signals the runner directly, for a runner this CLI cannot ask to stop.
  ///
  /// The pid comes from the manifest and names the process as the runner saw
  /// itself, which in a container may be a namespace this machine does not
  /// share.
  Future<void> _stopByPid(int pid, String serverDir) async {
    if (pid <= 0) {
      log.error(
        'The runner cannot be reached and its manifest names no process. '
        'Stop it by hand and remove .dart_tool/serverpod/runner.json.',
      );
      throw ExitException.error();
    }
    log.info('Stopping the runner (pid $pid).');
    if (!Process.killPid(pid, ProcessSignal.sigterm)) {
      log.error(
        'Could not signal pid $pid. It may already be gone; '
        'check `serverpod runner status`.',
      );
      throw ExitException.error();
    }

    if (await awaitRunnerShutdown(serverDir)) {
      log.info('Server stopped.');
      return;
    }
    log.error(
      'The runner is still running after the signal. Its manifest may name a '
      'process this machine cannot signal, such as a runner inside a '
      'container. Stop it where it runs and remove '
      '.dart_tool/serverpod/runner.json.',
    );
    throw ExitException.error();
  }
}

/// Polls until the runner serving [serverDir] is down, or [timeout] passes.
///
/// Down is a manifest that is gone or that carries an exit code. A manifest
/// whose runner no longer holds the lock is one a kill left behind: it is
/// removed here, and counts as down.
@visibleForTesting
Future<bool> awaitRunnerShutdown(
  String serverDir, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    final manifest = await RunnerManifest.readFrom(serverDir);
    if (manifest == null || manifest.isFinished) return true;
    if (!await RunnerLock.isHeld(serverDir)) {
      await RunnerManifest.deleteFrom(serverDir);
      return true;
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  return false;
}
