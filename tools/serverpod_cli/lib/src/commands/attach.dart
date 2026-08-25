import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:meta/meta.dart';
import 'package:serverpod_cli/src/commands/attach/log_renderer.dart';
import 'package:serverpod_cli/src/commands/attach/state_binding.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/status.dart'
    show resolveServerDirectory;
import 'package:serverpod_cli/src/runner/runner_client.dart';
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

/// Options for the `attach` command.
enum AttachOption<V> implements OptionDefinition<V> {
  directory(
    StringOption(
      argName: 'directory',
      argAbbrev: 'd',
      helpText:
          'The server directory (defaults to auto-detect from current '
          'directory).',
    ),
  ),
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

/// Attaches a UI to a runner that is already up.
///
/// Holds no orchestration: it resolves the server directory, connects to a
/// socket, renders what arrives, and reconnects when the runner restarts.
///
/// Detaching never stops the runner. Only `serverpod stop` and Shift+Q in the
/// UI do, so the same keystroke never means "stop the server" in one session
/// and "leave it running" in another.
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

    final resolution = await resolveRunner(serverDir.path);
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
      case LiveRunner(:final manifest, :final versionWarning):
        if (versionWarning != null) log.warning(versionWarning);
        if (manifest.sockets.tui.isEmpty) {
          log.error(
            'The running runner does not serve an attach socket. '
            'Stop it with `serverpod stop` and start it again.',
          );
          throw ExitException.error();
        }
        socketPath = manifest.sockets.tui;
    }

    final useTui = commandConfig.value(AttachOption.tui) && stdout.hasTerminal;
    final exitCode = await attachTo(socketPath, useTui: useTui);
    if (exitCode != 0) throw ExitException(exitCode);
  }
}

/// Renders the runner at [socketPath], returning the exit code to leave with.
///
/// Whoever resolved the runner may find it gone by the time this connects. An
/// unhandled [RunnerUnreachableException] would report that as a crash.
Future<int> attachTo(String socketPath, {required bool useTui}) async {
  try {
    return useTui
        ? await _attachWithTui(socketPath)
        : await attachWithLogStream(socketPath);
  } on RunnerUnreachableException catch (e) {
    log.error('$e');
    throw ExitException.error();
  }
}

/// Renders the runner in the terminal UI.
Future<int> _attachWithTui(String socketPath) async {
  final holder = StartAppStateHolder(ServerWatchState());
  final client = RunnerClient(
    socketPath: socketPath,
    history: holder.state.history,
    reconnectDeadline: const Duration(seconds: 10),
  );
  await client.attach();

  // Whether the runner had a stack while this client watched. One that stops
  // before it does, an existing server found or a port refused, has said why
  // only in its log, and the tail is shown for it whatever code it leaves
  // with.
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
  // Bound once the app is up: a runner already stopping, or one that went
  // away, requests an exit as soon as it is seen.
  holder.onAttached = () {
    holder.onAttached = null;
    binding.bind();
    // A runner that stops answering for longer than the deadline was killed
    // or crashed rather than stopped, so nothing will announce an exit code.
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
      ServerpodWatchApp(holder: holder, onReady: (_) {}),
      backend: ServerpodTerminalBackend(preExit: (_) async {}),
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

/// Prints the last [lines] of the pod's output from [history], once the
/// alternate screen is gone and has taken the error with it.
///
/// The raw lines, not the structured entries: a pod that failed to compile
/// or crashed before its VM service was up said why on stderr only, and that
/// is what the reader needs. The entries are the fallback for a runner that
/// never got as far as a pod.
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
