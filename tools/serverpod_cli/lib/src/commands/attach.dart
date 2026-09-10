import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:meta/meta.dart';
import 'package:serverpod_cli/src/analytics/flush_analytics.dart';
import 'package:serverpod_cli/src/commands/attach/log_renderer.dart'
    show attachWithLogStream, formatHistoryEntry;
import 'package:serverpod_cli/src/commands/attach/state_binding.dart';
import 'package:serverpod_cli/src/commands/runner_options.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/status.dart'
    show resolveRunnerOrExit, resolveServerDirectory;
import 'package:serverpod_cli/src/runner/runner_client.dart';
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/util/terminal_modes.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

/// Options for the `attach` command.
enum AttachOption<V> implements OptionDefinition<V> {
  directory<String>(clientDirectoryOption),
  tui(
    FlagOption(
      argName: 'tui',
      defaultsTo: true,
      helpText: 'Show the interactive terminal UI.',
    ),
  ),
  ;

  const AttachOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// The `serverpod runner attach` command. Detaching leaves the runner running.
class AttachCommand extends ServerpodCommand<AttachOption> {
  @override
  final name = 'attach';

  @override
  final description =
      'Attach to the development stack already running for this project.';

  @override
  String get invocation => 'serverpod runner attach';

  AttachCommand() : super(options: AttachOption.values);

  @override
  Future<void> runWithConfig(Configuration<AttachOption> commandConfig) async {
    final serverDir = await resolveServerDirectory(
      commandConfig.optionalValue(AttachOption.directory),
    );

    final resolution = await resolveRunnerOrExit(serverDir.path);
    final String socketPath;
    switch (resolution) {
      case NoRunner():
        log.error(
          'No serverpod runner is running for this project. '
          'Start one with `serverpod start`.',
        );
        throw ExitException.error();
      case IncompatibleRunner(:final message):
        log.error(message);
        throw ExitException.error();
      case LiveRunner(:final tuiSocket, :final versionWarning):
        if (versionWarning != null) log.warning(versionWarning);
        socketPath = tuiSocket;
    }

    final useTui = commandConfig.value(AttachOption.tui) && terminalSupportsTui;
    final exitCode = await attachTo(socketPath, useTui: useTui);
    if (exitCode != 0) throw ExitException(exitCode);
  }
}

/// Renders the runner at [socketPath] and returns the exit code to leave with.
///
/// [waitForRunner] bounds retries after a spawn. Without [onUnreachable], an
/// unreachable runner is logged and the command exits.
Future<int> attachTo(
  String socketPath, {
  required bool useTui,
  Duration? waitForRunner,
  Future<Never> Function(RunnerUnreachableException e)? onUnreachable,
}) async {
  try {
    return useTui
        ? await attachWithTui(socketPath, waitForRunner: waitForRunner)
        : await attachWithLogStream(socketPath, waitForRunner: waitForRunner);
  } on RunnerUnreachableException catch (e) {
    if (onUnreachable != null) await onUnreachable(e);
    log.error('$e');
    throw ExitException.error();
  }
}

/// Renders the runner in the terminal UI and returns the exit code.
Future<int> attachWithTui(String socketPath, {Duration? waitForRunner}) async {
  final holder = StartAppStateHolder(ServerWatchState());
  final client = RunnerClient(
    socketPath: socketPath,
    history: holder.state.history,
    reconnectDeadline: const Duration(seconds: 10),
  );
  await client.attach(waitFor: waitForRunner);

  // A runner stopping before its stack exists explains only in its log.
  var hadStack = _hasStack(client.stage);
  final stageSub = client.events.listen((event) {
    if (event case StageChangedEvent(:final stage) when _hasStack(stage)) {
      hadStack = true;
    }
  });

  final exitCompleter = Completer<int>();
  void requestExit([int code = 0]) {
    if (!exitCompleter.isCompleted) exitCompleter.complete(code);
  }

  final logWriter = TuiLogWriter();
  await closeLogger();
  initializeLoggerWith(ServerpodCliLogger(logWriter));
  logWriter.attach(holder);

  final binding = RunnerStateBinding(
    client: client,
    holder: holder,
    onStopRequested: requestExit,
    onRunnerStopped: requestExit,
  );
  // Bound once mounted, since an exit requested before then crashes.
  holder.onAttached = () {
    holder.onAttached = null;
    binding.bind();
    unawaited(client.gone.then((_) => requestExit(1)));
  };

  final teardown = exitCompleter.future.then((code) async {
    await stageSub.cancel();
    await binding.dispose();
    await client.close();
    await closeLogger();
    initializeLogger();
    shutdownTuiApp(code);
  });

  try {
    await runTuiApp(
      ServerpodWatchApp(holder: holder),
      backend: ServerpodTerminalBackend(preExit: (_) => flushAnalytics()),
      onShutdownSignal: requestExit,
    );
  } finally {
    requestExit();
    await teardown;
  }

  final exitCode = await exitCompleter.future;
  final stoppedBeforeStack = client.stage == RunnerStage.stopping && !hadStack;
  if (exitCode != 0 || stoppedBeforeStack) {
    printLogTail(holder.state.history, stdout);
  }
  return exitCode;
}

bool _hasStack(RunnerStage stage) =>
    stage == RunnerStage.running || stage == RunnerStage.degraded;

/// Prints the last [lines] of the pod's output in [history] to [out].
///
/// Prefers raw lines, the only place an early crash or compile error shows.
@visibleForTesting
void printLogTail(StartLogHistory history, IOSink out, {int lines = 20}) {
  final raw = history.serverLines.toList();
  final output = raw.isNotEmpty
      ? raw
      : history.serverEntries.map(formatHistoryEntry).toList();
  if (output.isEmpty) return;

  final tail = output.length > lines
      ? output.sublist(output.length - lines)
      : output;

  out.writeln('--- the runner stopped. Its last output was ---');
  tail.forEach(out.writeln);
}
