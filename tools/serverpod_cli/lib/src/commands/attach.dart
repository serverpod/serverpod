import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:serverpod_cli/src/commands/attach/log_renderer.dart'
    show attachWithLogStream, formatHistoryEntry;
import 'package:serverpod_cli/src/commands/attach/state_binding.dart';
import 'package:serverpod_cli/src/commands/runner_options.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/status.dart'
    show resolveServerDirectory;
import 'package:serverpod_cli/src/runner/runner_client.dart';
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

export 'package:serverpod_cli/src/commands/attach/log_renderer.dart'
    show attachWithLogStream;

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

/// Attaches a UI to a runner that is already up.
///
/// Holds no orchestration: it resolves the server directory, connects to a
/// socket, renders what arrives, and reconnects when the runner restarts.
///
/// Detaching does not stop the runner, whoever started it. The stack is
/// stopped with `serverpod runner stop`, or with `⇧+Q` in the UI, so the same
/// keystroke never means "stop the server" in one session and "leave it
/// running" in another.
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
        socketPath = requireAttachSocket(manifest);
    }

    final useTui = commandConfig.value(AttachOption.tui) && stdout.hasTerminal;
    final exitCode = await attachTo(socketPath, useTui: useTui);
    if (exitCode != 0) throw ExitException(exitCode);
  }
}

/// Renders the runner at [socketPath], returning the exit code to leave with.
///
/// The two commands that attach differ in how they found the runner, not in
/// what they do with it, including what they say when it turns out not to
/// answer: a runner resolves and then goes away between the two, and an
/// unhandled [RunnerUnreachableException] would report that as a crash.
Future<int> attachTo(String socketPath, {required bool useTui}) async {
  try {
    return useTui
        ? await attachWithTui(socketPath)
        : await attachWithLogStream(socketPath);
  } on RunnerUnreachableException catch (e) {
    log.error('$e');
    throw ExitException.error();
  }
}

/// The attach socket [manifest] names.
///
/// A runner aborts its start rather than run without one, so an empty path
/// comes from another build of the CLI. Throws an [ExitException] saying how
/// to replace such a runner.
String requireAttachSocket(RunnerManifest manifest) {
  if (manifest.sockets.tui.isEmpty) {
    log.error(
      'The running runner does not serve an attach socket. '
      'Stop it with `serverpod runner stop` and start it again.',
    );
    throw ExitException.error();
  }
  return manifest.sockets.tui;
}

/// Renders the runner in the terminal UI, returning the exit code to leave
/// with.
///
/// Shared with `serverpod start`, which attaches after bringing the runner up.
///
/// None of the in-process integration this used to need survives the split:
/// with the backend in another process there is no [Completer] handing state
/// back, no logger buffering messages emitted before the UI existed, and no
/// ordering dance to print a crash after the alternate screen is gone.
Future<int> attachWithTui(String socketPath) async {
  final holder = StartAppStateHolder(ServerWatchState());
  final client = RunnerClient(
    socketPath: socketPath,
    history: holder.state.history,
  );
  await client.attach();

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
  )..bind();

  final teardown = exitCompleter.future.then((code) async {
    await binding.dispose();
    await client.close();
    await closeLogger();
    initializeLogger();
    shutdownTuiApp(code);
  });

  try {
    await runTuiApp(
      ServerpodWatchApp(holder: holder),
      backend: ServerpodTerminalBackend(preExit: (_) async {}),
      onShutdownSignal: requestExit,
    );
  } finally {
    requestExit();
    await teardown;
  }

  final exitCode = await exitCompleter.future;
  if (exitCode != 0) _printLogTail(holder.state.history);
  return exitCode;
}

/// Prints the last of what the runner said, once the alternate screen is gone.
///
/// A UI leaving on the runner's exit code takes the screen with it, and with
/// it the error the code is about. This is the replay the in-process UI used
/// to do before exiting.
void _printLogTail(StartLogHistory history, {int lines = 20}) {
  final entries = history.serverEntries.toList();
  if (entries.isEmpty) return;

  final tail = entries.length > lines
      ? entries.sublist(entries.length - lines)
      : entries;

  stdout.writeln('--- the runner stopped; its last log entries were ---');
  for (final entry in tail) {
    stdout.writeln(formatHistoryEntry(entry));
  }
}
