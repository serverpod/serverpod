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
import 'package:serverpod_cli/src/util/shutdown_signal.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_shared/log.dart' show MultiLogWriter;

/// The `runner` command group.
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

/// The options of `serverpod start` that shape the stack.
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

/// Brings a runner up and returns once its stack is up, leaving it running.
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
      globalArgs: runnerServeGlobalArgs(serverpodRunner.globalConfiguration),
    );

    reportRunnerReady(await awaitStackUp(serverDir, manifest));
  }
}

/// The options of `serverpod runner start`, plus `--detached`.
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
/// Hidden. `serverpod start` spawns it, and by hand it renders nothing.
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

    // Resolved before the log opens. GeneratorConfig.load reports a failure.
    var serverRootDir = directory;
    try {
      serverRootDir = await GeneratorConfig.resolveServerRootDir(
        directory,
        interactive: false,
      );
    } catch (_) {}

    // closeLogger closes it at exit, after the exit-path error is logged.
    final logFile = RunnerLogFile.forServer(serverRootDir);
    final logHistory = StartLogHistory();
    if (detached) await logFile.open();
    if (detached || loggerIsDefault) {
      final level = log.logLevel;
      await closeLogger();
      initializeLoggerWith(
        ServerpodCliLogger(
          MultiLogWriter([
            StartLogHistoryWriter(logHistory),
            if (detached) RunnerLogFileWriter(logFile) else stdOutLogWriter(),
          ]),
        ),
      );
      log.logLevel = level;
    }

    await runWithShutdownSignals((shutdown) async {
      final config = await GeneratorConfig.load(
        serverRootDir: serverRootDir,
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
        flutterStdoutEchoFor: detached ? null : (_) => stdout,
        flutterStderrEchoFor: detached ? null : (_) => stderr,
        flutterEchoLine: detached
            ? (appId, line) => logFile.writeLine('flutter[$appId]: $line')
            : null,
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
    });
  }
}
