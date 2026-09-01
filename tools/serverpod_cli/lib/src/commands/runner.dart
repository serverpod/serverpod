import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/attach.dart';
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/runner_options.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/commands/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_cli/src/commands/start/watch_loop.dart';
import 'package:serverpod_cli/src/commands/status.dart';
import 'package:serverpod_cli/src/commands/stop.dart';
import 'package:serverpod_cli/src/runner/runner_log_file.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_shared/log.dart' show MultiLogWriter;

/// The commands that act on the development stack: the runner itself, and the
/// clients that drive one.
///
/// A group rather than a command. `runner` names the thing acted on, and each
/// verb under it is an action on that runner.
class RunnerCommand extends ServerpodCommand<OptionDefinition> {
  RunnerCommand() : super(options: const []) {
    addSubcommand(RunnerStartCommand());
    addSubcommand(AttachCommand());
    addSubcommand(StatusCommand());
    addSubcommand(StopCommand());
    addSubcommand(RunnerServeCommand());
  }

  @override
  final name = 'runner';

  @override
  final description = 'Manage the development stack for this project.';

  @override
  void runWithConfig(Configuration<OptionDefinition> commandConfig) {}
}

/// Options for `serverpod runner start`.
///
/// The stack-shaping half of `start` and nothing else. The command brings a
/// runner up and returns, so UI options have nothing to act on.
enum RunnerStartOption<V> implements OptionDefinition<V> {
  watch<bool>(runnerWatchOption),
  directory<String>(runnerDirectoryOption),
  docker<bool>(runnerDockerOption),
  flutter<bool>(runnerFlutterOption),
  ;

  const RunnerStartOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// Brings a runner up for this project and returns, leaving it running.
///
/// The same work `serverpod start` does before attaching, and idempotent the
/// same way. A runner already serving this project is reported, not replaced.
/// Attaching is `serverpod runner attach`, or `serverpod start`, which does
/// both.
class RunnerStartCommand extends ServerpodCommand<RunnerStartOption> {
  @override
  final name = 'start';

  @override
  final description =
      'Start the development stack for this project and return, leaving it '
      'running in the background.';

  @override
  String get invocation => 'serverpod runner start [-- <server-args>]';

  RunnerStartCommand() : super(options: RunnerStartOption.values);

  @override
  Configuration<RunnerStartOption> resolveConfiguration(
    ArgResults? argResults,
  ) {
    return Configuration.resolveNoExcept(
      options: options,
      argResults: argResults,
      env: envVariables,
      ignoreUnexpectedPositionalArgs: true,
    );
  }

  @override
  Future<void> runWithConfig(
    Configuration<RunnerStartOption> commandConfig,
  ) async {
    final config = await loadRunnerProjectConfig(
      directory: commandConfig.value(RunnerStartOption.directory),
      interactive: serverpodRunner.globalConfiguration.optionalValue(
        GlobalOption.interactive,
      ),
    );
    final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);

    final manifest = await ensureRunner(
      config: config,
      serverDir: serverDir,
      asked: RunnerConfig(
        watch: commandConfig.value(RunnerStartOption.watch),
        flutter: commandConfig.value(RunnerStartOption.flutter),
        docker: commandConfig.optionalValue(RunnerStartOption.docker),
        serverArgs: argResults?.rest ?? const [],
      ),
      useTui: false,
    );

    reportRunnerReady(await awaitStackUp(serverDir, manifest));
  }
}

/// Options for the hidden `runner serve` command.
///
/// Mirrors the stack-shaping half of `start`. Client options have no meaning
/// here.
enum RunnerServeOption<V> implements OptionDefinition<V> {
  watch<bool>(runnerWatchOption),
  directory<String>(runnerDirectoryOption),
  docker<bool>(runnerDockerOption),
  flutter<bool>(runnerFlutterOption),
  detached(
    FlagOption(
      argName: 'detached',
      defaultsTo: false,
      helpText:
          'Write this process\'s output to .dart_tool/serverpod/runner.log '
          'instead of stdout. Passed by `serverpod start`, which spawns the '
          'runner with no stdio to inherit.',
    ),
  ),
  ;

  const RunnerServeOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// The long-lived development stack, with no UI attached.
///
/// Spawned by `serverpod runner start`, detached and in a session of its own.
/// Hidden, since typing it only takes over a terminal without rendering
/// anything.
///
/// Everything a client needs to find it goes into
/// `.dart_tool/serverpod/runner.json`, and everything it says into
/// `.dart_tool/serverpod/runner.log`, a detached process having no stdio to
/// inherit.
class RunnerServeCommand extends ServerpodCommand<RunnerServeOption> {
  @override
  final name = 'serve';

  @override
  final description =
      'Be the development stack. Spawned by `serverpod runner start`.';

  @override
  bool get hidden => true;

  @override
  String get invocation => 'serverpod runner serve [-- <server-args>]';

  RunnerServeCommand() : super(options: RunnerServeOption.values);

  @override
  Configuration<RunnerServeOption> resolveConfiguration(
    ArgResults? argResults,
  ) {
    return Configuration.resolveNoExcept(
      options: options,
      argResults: argResults,
      env: envVariables,
      ignoreUnexpectedPositionalArgs: true,
    );
  }

  @override
  Future<void> runWithConfig(
    Configuration<RunnerServeOption> commandConfig,
  ) async {
    final directory = commandConfig.value(RunnerServeOption.directory);
    final detached = commandConfig.value(RunnerServeOption.detached);

    // Closed by [closeLogger] at exit rather than here. The writer below is
    // still the logger's, and a detached runner's last words, the exit-path
    // error, come after this command returns.
    final logFile = RunnerLogFile.forServer(directory);
    final logHistory = StartLogHistory();
    if (detached) await logFile.open();
    if (detached || loggerIsDefault) {
      await closeLogger();
      initializeLoggerWith(
        ServerpodCliLogger(
          MultiLogWriter([
            StartLogHistoryWriter(logHistory),
            if (detached) RunnerLogFileWriter(logFile) else stdOutLogWriter(),
          ]),
        ),
      );
    }

    final shutdown = ShutdownSignal();
    try {
      final config = await GeneratorConfig.load(
        serverRootDir: directory,
        interactive: false,
      );
      final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);

      final result = await setupWatchLoop(
        config: config,
        serverDir: serverDir,
        serverArgs: ServerArgsRef(argResults?.rest ?? []),
        watch: commandConfig.value(RunnerServeOption.watch),
        docker: commandConfig.optionalValue(RunnerServeOption.docker),
        launchFlutterApp: commandConfig.value(RunnerServeOption.flutter),
        shutdown: shutdown,
        logHistory: logHistory,
        serverStdoutSink: logHistory.serverOutputSink(
          forwardTo: detached ? null : stdout,
          echoLine: detached ? logFile.writeLine : null,
        ),
        serverStderrSink: logHistory.serverOutputSink(
          forwardTo: detached ? null : stderr,
          echoLine: detached
              ? (line) => logFile.writeLine('stderr: $line')
              : null,
        ),
        flutterStdoutEchoFor: detached
            ? (appId) => logFile.lineSink(prefix: 'flutter[$appId]: ')
            : (_) => stdout,
        flutterStderrEchoFor: detached
            ? (appId) => logFile.lineSink(prefix: 'flutter[$appId]: ')
            : (_) => stderr,
      );

      switch (result) {
        case WatchLoopAborted(:final exitCode):
          if (exitCode != 0) throw ExitException(exitCode);
          return;
        case WatchLoopReady(:final ctx):
          if (ctx.session.isRunning) log.info(serverRunning);
          final exitCode = await shutdown.future;
          log.info('Server stopped (exitCode: $exitCode).');
          await ctx.dispose(exitCode: exitCode);
          if (exitCode != 0) throw ExitException(exitCode);
      }
    } finally {
      shutdown.dispose();
    }
  }
}
