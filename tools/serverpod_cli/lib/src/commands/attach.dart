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
/// Resolves the server directory, connects to the runner's socket, renders
/// what arrives, and reconnects when the runner restarts.
///
/// Detaching never stops the runner. Only `serverpod runner stop` and Shift+Q
/// in the UI do.
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
/// [useTui] picks the terminal UI over the plain log stream. [waitForRunner]
/// bounds how long a refused connection is retried, for a caller that just
/// brought the runner up and knows the socket is coming.
Future<int> attachTo(
  String socketPath, {
  required bool useTui,
  Duration? waitForRunner,
}) async {
  try {
    return useTui
        ? await attachWithTui(socketPath, waitForRunner: waitForRunner)
        : await attachWithLogStream(socketPath, waitForRunner: waitForRunner);
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
Future<int> attachWithTui(String socketPath, {Duration? waitForRunner}) async {
  final holder = StartAppStateHolder(ServerWatchState());
  final client = RunnerClient(
    socketPath: socketPath,
    history: holder.state.history,
  );
  await client.attach(waitFor: waitForRunner);

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

/// Prints the last [lines] server entries of [history], once the alternate
/// screen is gone and has taken the error with it.
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
