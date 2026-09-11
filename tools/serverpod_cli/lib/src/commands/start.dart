import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:meta/meta.dart' show visibleForTesting;
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/analytics/session_metrics.dart';
import 'package:serverpod_cli/src/commands/attach.dart' show attachTo;
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/runner_options.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/commands/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/commands/start/flutter_app_manager.dart';
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_cli/src/commands/start/mcp_socket.dart';
import 'package:serverpod_cli/src/commands/start/native_assets_builder.dart';
import 'package:serverpod_cli/src/commands/start/package_dependency_tracker.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/commands/start/watch_loop.dart';
import 'package:serverpod_cli/src/commands/start/watch_session.dart';
import 'package:serverpod_cli/src/commands/status.dart'
    show printServerUris, resolveRunnerOrExit;
import 'package:serverpod_cli/src/commands/watcher.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/config_info/config_info.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/generator/isolated_analyzers.dart';
import 'package:serverpod_cli/src/migrations/cli_migration_runner.dart';
import 'package:serverpod_cli/src/runner/local_runner_api.dart';
import 'package:serverpod_cli/src/runner/port_resolution.dart';
import 'package:serverpod_cli/src/runner/runner_client.dart'
    show RunnerUnreachableException;
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_lock.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_manifest_publisher.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/runner/runner_registry.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_cli/src/runner/runner_socket_server.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';
import 'package:serverpod_cli/src/util/legacy_model_files.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/util/shutdown_signal.dart';
import 'package:serverpod_cli/src/util/terminal_modes.dart';
import 'package:serverpod_cli/src/vm_proxy/proxy.dart';
import 'package:serverpod_cli/src/vm_proxy/serverpod_hooks.dart';
import 'package:serverpod_shared/process_io.dart' show isProcessAlive;
import 'package:serverpod_shared/serverpod_shared.dart' hide ExitException;
import 'package:stream_transform/stream_transform.dart';
import 'package:vm_service/vm_service.dart'
    show Event, EventStreams, RPCError, VmService;
import 'package:vm_service/vm_service_io.dart';

/// Options for the `start` command.
enum StartOption<V> implements OptionDefinition<V> {
  watch<bool>(runnerWatchOption),
  directory<String>(runnerDirectoryOption),
  docker<bool>(runnerDockerOption),
  attach(
    FlagOption(
      argName: 'attach',
      defaultsTo: true,
      helpText:
          'Attach a UI once the stack is up. With --no-attach the runner is '
          'brought up, its address is printed, and the command returns.',
    ),
  ),
  tui(
    FlagOption(
      argName: 'tui',
      defaultsTo: true,
      helpText:
          'Show the interactive terminal UI when attaching. Ignored with '
          '--no-attach, since nothing renders.',
    ),
  ),
  flutter<bool>(runnerFlutterOption),
  ;

  const StartOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// Command to generate code, start the server, and optionally watch for
/// changes.
class StartCommand extends ServerpodCommand<StartOption> {
  @override
  final name = 'start';

  @override
  final description =
      'Start the full development stack with hot reload: generates code, '
      'runs the server, and launches the companion Flutter apps in an '
      'interactive terminal UI.';

  @override
  String get invocation => 'serverpod start [-- <server-args>]';

  StartCommand() : super(options: StartOption.values);

  @override
  Configuration<StartOption> resolveConfiguration(ArgResults? argResults) {
    return Configuration.resolveNoExcept(
      options: options,
      argResults: argResults,
      env: envVariables,
      ignoreUnexpectedPositionalArgs: true,
    );
  }

  @override
  Future<void> runWithConfig(
    Configuration<StartOption> commandConfig,
  ) async {
    final config = await loadRunnerProjectConfig(
      directory: commandConfig.value(StartOption.directory),
      interactive: serverpodRunner.globalConfiguration.optionalValue(
        GlobalOption.interactive,
      ),
    );
    final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
    final asked = RunnerConfig(
      watch: commandConfig.value(StartOption.watch),
      flutter: commandConfig.value(StartOption.flutter),
      docker: commandConfig.optionalValue(StartOption.docker),
      serverArgs: argResults?.rest ?? const [],
    );

    final attaching = commandConfig.value(StartOption.attach);
    final useTui = commandConfig.value(StartOption.tui) && terminalSupportsTui;
    final manifest = await ensureRunner(
      config: config,
      serverDir: serverDir,
      asked: asked,
      useTui: useTui,
      globalArgs: runnerServeGlobalArgs(serverpodRunner.globalConfiguration),
    );

    if (!attaching) {
      reportRunnerReady(await awaitStackUp(serverDir, manifest));
      return;
    }

    final exitCode = await attachTo(
      runnerSocketPath(
        serverDir,
        serverpodTuiSocketName,
        projectId: manifest.projectId,
      ),
      useTui: useTui,
      waitForRunner: const Duration(seconds: 5),
      onUnreachable: (e) => explainUnreachableRunner(serverDir, manifest, e),
    );
    if (exitCode != 0) throw ExitException(exitCode);
  }
}

/// Exits for a runner [ensureRunner] resolved and [attachTo] cannot reach.
///
/// Uses the exit code a runner that stopped meanwhile left in its manifest.
@visibleForTesting
Future<Never> explainUnreachableRunner(
  String serverDir,
  RunnerManifest resolved,
  RunnerUnreachableException e,
) async {
  final left = await RunnerManifest.readFrom(serverDir);
  if (left != null && left.pid == resolved.pid && left.isFinished) {
    await _leaveWithAbortedStart(
      serverDir,
      pid: left.pid,
      exitCode: left.exitCode ?? 1,
    );
  }
  log.error('$e');
  throw ExitException.error();
}

/// Loads the project configuration, and exits when it cannot.
Future<GeneratorConfig> loadRunnerProjectConfig({
  required String directory,
  required bool? interactive,
}) async {
  late final GeneratorConfig config;
  try {
    await log.progress('Loading project configuration', () async {
      config = await GeneratorConfig.load(
        serverRootDir: directory,
        interactive: interactive,
      );
      return true;
    });
  } catch (e) {
    log.error('$e');
    throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
  }

  if (await LegacyModelFiles.report(config)) throw ExitException.error();

  return config;
}

/// Returns the manifest of the runner serving [serverDir], spawning one.
///
/// Exits for a runner with options other than [asked], or one stopping, whose
/// stage change a client attaching now would never see.
Future<RunnerManifest> ensureRunner({
  required GeneratorConfig config,
  required String serverDir,
  required RunnerConfig asked,
  required bool useTui,
  List<String> globalArgs = const [],
}) async {
  switch (await resolveRunnerOrExit(serverDir)) {
    case IncompatibleRunner(:final message):
      log.error(message);
      throw ExitException.error();

    // A replacement would die on the lock the runner still holds.
    case LiveRunner(:final manifest)
        when manifest.stage == RunnerStage.stopping:
    case NoRunner(staleManifest: final manifest?, lockHeld: true):
      log.error(
        'A serverpod runner for "${config.name}" (pid ${manifest.pid}) is '
        'shutting down or not answering. Run this again once it has '
        'stopped, or stop it with `serverpod runner stop`.',
      );
      throw ExitException.error();

    case LiveRunner(:final manifest, :final versionWarning):
      if (versionWarning != null) log.warning(versionWarning);
      final differences = manifest.config.differencesFrom(asked);
      if (differences.isNotEmpty) {
        log.error(
          'A serverpod runner is already running for "${config.name}", '
          'started with different options: ${differences.join(', ')}. '
          'Stop it with `serverpod runner stop` and start it again to change '
          'them.',
        );
        throw ExitException.error();
      }
      return manifest;

    case NoRunner():
      // The runner would report this only in its log, and exit with zero.
      final existingUri = await _checkExistingServer(
        userVmServiceInfoPath(serverDir),
      );
      if (existingUri != null) {
        log.info('Existing server found.');
        log.info('VM service proxy listening on $existingUri');
        throw ExitException(0);
      }

      return await _spawnRunner(
            config: config,
            serverDir: serverDir,
            asked: asked,
            globalArgs: globalArgs,
            useTui: useTui,
          ) ??
          await ensureRunner(
            config: config,
            serverDir: serverDir,
            asked: asked,
            useTui: useTui,
            globalArgs: globalArgs,
          );
  }
}

/// Waits until the stack behind [manifest] leaves [RunnerStage.starting].
///
/// Has no deadline, since a cold start takes minutes.
Future<RunnerManifest> awaitStackUp(
  String serverDir,
  RunnerManifest manifest, {
  Duration addressTimeout = const Duration(seconds: 10),
}) async {
  var current = manifest;
  // A running stage can precede the manifest carrying the bound addresses.
  DateTime? addressDeadline;
  bool comingUp(RunnerManifest manifest) => switch (manifest.stage) {
    RunnerStage.starting => true,
    RunnerStage.running when manifest.servers == null =>
      DateTime.now().isBefore(
        addressDeadline ??= DateTime.now().add(addressTimeout),
      ),
    _ => false,
  };
  while (comingUp(current)) {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    switch (await resolveRunner(serverDir)) {
      case LiveRunner(:final manifest):
        current = manifest;
      case NoRunner(:final staleManifest, lockHeld: true)
          when staleManifest?.pid == current.pid:
        // A probe can fail while the runner lives on.
        continue;
      case NoRunner(:final staleManifest):
        await _leaveWithAbortedStart(
          serverDir,
          pid: current.pid,
          exitCode: staleManifest?.pid == current.pid
              ? staleManifest?.exitCode ?? 1
              : 1,
        );
      case IncompatibleRunner(:final message):
        log.error(message);
        throw ExitException.error();
    }
  }
  if (current.stage == RunnerStage.stopping) {
    await _leaveWithAbortedStart(
      serverDir,
      pid: current.pid,
      exitCode: current.exitCode ?? 1,
    );
  }
  return current;
}

/// Reports how to reach a runner with its stack up, or exits when degraded.
void reportRunnerReady(RunnerManifest manifest) {
  if (manifest.stage == RunnerStage.degraded) {
    log.error(
      'The runner (pid ${manifest.pid}) is up, but the project failed to '
      'build, so no server is running.',
    );
    log.info(
      manifest.config.watch
          ? 'It starts the server once a change makes the project build. '
                'Watch it with `serverpod runner attach`, or stop it with '
                '`serverpod runner stop`.'
          : 'Fix the errors and rebuild from `serverpod runner attach`, or '
                'stop it with `serverpod runner stop`.',
    );
    throw ExitException.error();
  }
  log.info('Runner ready (pid ${manifest.pid}).');
  if (manifest.servers case final servers?) printServerUris(servers);
  log.info(
    'Attach with `serverpod runner attach`, '
    'stop with `serverpod runner stop`.',
  );
}

/// Reports a runner that stopped during startup and exits with its exit code.
Future<Never> _leaveWithAbortedStart(
  String serverDir, {
  required int pid,
  required int exitCode,
}) async {
  final what = 'The runner (pid $pid) stopped during startup';
  if (exitCode == 0) {
    log.info('$what.');
  } else {
    log.error('$what with exit code $exitCode.');
  }
  await printRunnerLogTail(serverDir, from: _runnerLogFrom);
  throw ExitException(exitCode);
}

/// The global options of this command that a spawned runner runs with.
///
/// `--no-analytics` carries over, since the runner records its own invocation.
List<String> runnerServeGlobalArgs(Configuration<GlobalOption> global) => [
  if (global.value(GlobalOption.verbose)) '--verbose',
  if (global.value(GlobalOption.quiet)) '--quiet',
  if (!global.value(GlobalOption.analytics)) '--no-analytics',
  for (final feature in global.value(GlobalOption.experimentalFeatures)) ...[
    '--experimental-features',
    feature.name,
  ],
];

/// The runner log's length at spawn, where this run's output starts.
int _runnerLogFrom = 0;

/// Prints and returns the last [lines] of the runner's log past byte [from].
@visibleForTesting
Future<List<String>> printRunnerLogTail(
  String serverDir, {
  int from = 0,
  int lines = 20,
}) async {
  final file = File(serverpodRunnerLogPath(serverDir));
  if (!file.existsSync()) return const [];
  // A file shorter than from was rotated, so all of it is this run's.
  if (from > file.lengthSync()) from = 0;
  final all = await file
      .openRead(from)
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .toList();
  final tail = all.length > lines ? all.sublist(all.length - lines) : all;
  if (tail.isEmpty) return tail;
  log.info('The last of ${file.path}:');
  for (final line in tail) {
    log.info('  $line');
  }
  return tail;
}

/// Spawns the runner detached and waits for it to publish its manifest.
///
/// Returns null when a runner spawned by another start took the lock.
Future<RunnerManifest?> _spawnRunner({
  required GeneratorConfig config,
  required String serverDir,
  required RunnerConfig asked,
  required bool useTui,
  required List<String> globalArgs,
}) async {
  unawaited(
    _captureSessionStartAnalytics(
      config: config,
      watchMode: asked.watch,
      docker: asked.docker,
      useTui: useTui,
      launchFlutterApp: asked.flutter,
    ),
  );

  final logFile = File(serverpodRunnerLogPath(serverDir));
  _runnerLogFrom = logFile.existsSync() ? logFile.lengthSync() : 0;
  final process = await Process.start(
    Platform.resolvedExecutable,
    [
      if (_runsOnDartVm) Platform.script.toFilePath(),
      ...globalArgs,
      'runner',
      'serve',
      '--detached',
      ...asked.toServeArgs(directory: serverDir),
    ],
    // Sockets bind by relative path, which fits the socket address limit.
    workingDirectory: serverDir,
    mode: ProcessStartMode.detached,
  );

  switch (await awaitRunnerManifest(serverDir, pid: process.pid)) {
    case RunnerPublished(:final manifest):
      return manifest;
    case RunnerTaken():
      return null;
    case RunnerAborted(:final exitCode):
      await _leaveWithAbortedStart(
        serverDir,
        pid: process.pid,
        exitCode: exitCode,
      );
    case RunnerTimedOut():
      // Left alone, it could come up later and hold the project.
      process.kill();
      log.error(
        'The runner (pid ${process.pid}) did not come up in time and was '
        'stopped. Its output is in ${serverpodRunnerLogPath(serverDir)}.',
      );
      await printRunnerLogTail(serverDir, from: _runnerLogFrom);
      throw ExitException.error();
  }
}

void Function(String line)? _appLineEcho(
  void Function(String appId, String line)? echo,
  String appId,
) => echo == null ? null : (line) => echo(appId, line);

/// Whether this process is the Dart VM running a script, not a compiled CLI.
bool get _runsOnDartVm =>
    p.basenameWithoutExtension(Platform.resolvedExecutable) == 'dart';

/// What became of a runner this process spawned.
sealed class RunnerStartOutcome {
  const RunnerStartOutcome();
}

/// The runner is answering on its socket. Its stack may still be starting.
final class RunnerPublished extends RunnerStartOutcome {
  const RunnerPublished(this.manifest);

  final RunnerManifest manifest;
}

/// A runner spawned by another start took the lock first and published.
final class RunnerTaken extends RunnerStartOutcome {
  const RunnerTaken();
}

/// The runner stopped early, with its manifest's exit code or 1 without one.
final class RunnerAborted extends RunnerStartOutcome {
  const RunnerAborted(this.exitCode);

  final int exitCode;
}

/// Nothing was heard from the runner within the deadline.
final class RunnerTimedOut extends RunnerStartOutcome {
  const RunnerTimedOut();
}

/// Waits until the runner spawned as [pid] answers, stops, dies or times out.
///
/// A detached runner has no exit code to await, so this watches its [pid].
/// A dead [pid] while the lock is held lost the race, so the wait goes on.
@visibleForTesting
Future<RunnerStartOutcome> awaitRunnerManifest(
  String serverDir, {
  required int pid,
  Duration timeout = _runnerStartTimeout,
}) async {
  final deadline = DateTime.now().add(timeout);
  while (true) {
    switch (await resolveRunner(serverDir)) {
      case LiveRunner(:final manifest) when manifest.pid != pid:
        return const RunnerTaken();
      case LiveRunner(:final manifest)
          when manifest.stage == RunnerStage.stopping:
        return RunnerAborted(manifest.exitCode ?? 1);
      case LiveRunner(:final manifest):
        return RunnerPublished(manifest);
      case NoRunner(:final staleManifest)
          when staleManifest?.pid == pid &&
              staleManifest?.stage == RunnerStage.stopping:
        return RunnerAborted(staleManifest?.exitCode ?? 1);
      case NoRunner() || IncompatibleRunner():
        break;
    }
    if (!isProcessAlive(pid) && !await RunnerLock.isHeld(serverDir)) {
      return const RunnerAborted(1);
    }
    if (DateTime.now().isAfter(deadline)) return const RunnerTimedOut();
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}

/// How long a runner gets to publish, which it does before the slow startup.
const _runnerStartTimeout = Duration(seconds: 30);

/// Constructs a [NativeAssetsBuilder] for the server at [serverDir]. The
/// builder discovers `package_config.json` itself (walking up to a workspace
/// root if needed).
NativeAssetsBuilder _createNativeAssetsBuilder({
  required String serverDir,
  required String projectRoot,
  required String serverpodToolDir,
  required String dartExecutable,
}) {
  return NativeAssetsBuilder(
    dartExecutable: dartExecutable,
    serverDir: serverDir,
    projectRoot: projectRoot,
    outputDir: p.join(serverpodToolDir, 'native_assets'),
  );
}

/// Runs build hooks via [builder] and applies the result to [compiler].
/// Returns false on hook failure (an error has been logged).
///
/// Wraps [NativeAssetsBuilder.applyTo] for the start.dart paths that don't
/// care about the restart-distinction (initial-build callers and the IDE
/// reload callback). The watch-loop and migration paths switch on the
/// outcome directly to read [NativeAssetsApplySuccess.restarted].
Future<bool> _runHooksFor(
  NativeAssetsBuilder builder,
  KernelCompiler compiler,
) async {
  final outcome = await builder.applyTo(compiler);
  switch (outcome) {
    case NativeAssetsApplySuccess():
      return true;
    case NativeAssetsApplyFailure(:final message):
      log.error(message);
      return false;
  }
}

Future<void> _captureSessionStartAnalytics({
  required GeneratorConfig config,
  required bool watchMode,
  required bool? docker,
  required bool useTui,
  required bool launchFlutterApp,
}) async {
  if (!cliAnalytics.enabled) return;

  await cliAnalytics.captureSessionStart(
    config: config,
    watchMode: watchMode,
    tuiEnabled: useTui,
    flutterEnabled: launchFlutterApp,
    dockerMode: switch (docker) {
      true => DockerStartMode.on,
      false => DockerStartMode.off,
      null => DockerStartMode.auto,
    },
    dockerComposePresent:
        _findComposeFile(p.joinAll(config.serverPackageDirectoryPathParts)) !=
        null,
  );
}

/// Compose file names Docker Compose resolves by default, in its own lookup
/// order.
const _composeFileNames = [
  'compose.yaml',
  'compose.yml',
  'docker-compose.yaml',
  'docker-compose.yml',
];

File? _findComposeFile(String serverDir) {
  for (final name in _composeFileNames) {
    final file = File(p.join(serverDir, name));
    if (file.existsSync()) return file;
  }
  return null;
}

/// Whether the stack serves web, and so whether a reload refreshes a browser.
bool stackServesWeb(ServerpodAddresses? addresses, ServerpodConfig? config) {
  if (addresses != null) return addresses.web != null;
  return config == null || config.webServer != null;
}

/// The server's resolved configuration, or null when it cannot be read.
///
/// Null is normal mid-setup, and callers fall back to their defaults.
ServerpodConfig? _loadServerConfig({
  required String serverDir,
  required String runMode,
}) {
  try {
    return ServerpodConfig.load(
      runMode,
      null,
      PasswordManager(runMode: runMode).loadPasswords(serverDir: serverDir),
      serverDir: serverDir,
    );
  } catch (_) {
    return null;
  }
}

bool _resolveStartDocker({
  required bool? dockerFlag,
  required String serverDir,
  required ServerpodConfig? serverConfig,
}) {
  if (dockerFlag != null) return dockerFlag;

  // Projects without a compose file (e.g. using a remote or natively
  // installed database) have nothing for Docker Compose to start. Only an
  // explicit --docker treats a missing compose file as an error.
  if (_findComposeFile(serverDir) == null) return false;

  if (serverConfig == null) return false;

  final database = serverConfig.database;
  if (database is! PostgresDatabaseConfig || database.dataPath != null) {
    return false;
  }
  return database.host.toLowerCase() == 'localhost' ||
      database.host == '127.0.0.1';
}

/// The pod's port environment overrides, and the ports this runner claims.
typedef _ResolvedPorts = ({
  Map<String, String> environment,
  Map<String, int> claimed,
});

/// The pod's port overrides and this runner's claim, or null on a conflict.
///
/// Port-zero listeners always get an override, so later spawns can pin them.
Future<_ResolvedPorts?> _resolvePortEnvironment({
  required String serverDir,
  required String runMode,
  required ServerpodConfig? serverConfig,
}) async {
  // Claim nothing rather than stay undecided, which moves siblings aside.
  if (serverConfig == null) {
    return (
      environment: const <String, String>{},
      claimed: const <String, int>{},
    );
  }

  final ports = {
    'api': serverConfig.apiServer.port,
    if (serverConfig.insightsServer != null)
      'insights': serverConfig.insightsServer!.port,
    if (serverConfig.webServer != null) 'web': serverConfig.webServer!.port,
  };

  if (runMode != 'development') {
    return (environment: const <String, String>{}, claimed: fixedPorts(ports));
  }

  final resolution = await resolvePorts(serverDir: serverDir, ports: ports);

  if (resolution.hasConflicts) {
    for (final conflict in resolution.conflicts.entries) {
      log.error(
        'The ${conflict.key} server port ${conflict.value} is in use by '
        'something that is not a Serverpod runner. Free it, or change the '
        'port in config/$runMode.yaml.',
      );
    }
    return null;
  }

  if (resolution.useEphemeral) {
    if (resolution.unattributed.isEmpty) {
      log.info(
        'Another Serverpod runner holds the configured ports, or is starting '
        'and may take them. Binding ephemeral ports instead. '
        '`serverpod runner status` prints them.',
      );
    } else {
      final held = resolution.unattributed.entries
          .map((port) => '${port.key} (${port.value})')
          .join(', ');
      log.warning(
        'Another Serverpod runner is starting and has not said which ports it '
        'took, so $held could be its or something else\'s. Binding ephemeral '
        'ports instead. `serverpod runner status` prints them. If no other '
        'runner is meant to hold them, free them or change the ports in '
        'config/$runMode.yaml.',
      );
    }
  }
  return (
    environment: ephemeralPortEnvironment(resolution.ephemeralListeners(ports)),
    claimed: resolution.claimedPorts(ports),
  );
}

/// Ensures Docker Compose services are running.
///
/// Returns `true` if this method started the containers (meaning we should
/// stop them on shutdown), `false` if they were already running, and `null`
/// when Docker cannot be used.
Future<bool?> _ensureDockerServices(String serverDir) async {
  if (_findComposeFile(serverDir) == null) {
    log.error(dockerComposeFileMissing);
    return null;
  }

  // Check if containers are already running.
  final ps = await _runDocker(
    ['compose', 'ps', '--status', 'running', '-q'],
    serverDir,
  );

  if (ps == null) {
    log.error(dockerNotInstalled);
    return null;
  }

  if (ps.exitCode != 0) {
    log.error(dockerNotRunning);
    return null;
  }

  final running = (ps.stdout as String).trim();
  if (running.isNotEmpty) return false;

  // Start containers.
  final up = await _runDocker(['compose', 'up', '-d'], serverDir);

  if (up == null) {
    log.error(dockerNotInstalled);
    return null;
  }

  if (up.exitCode != 0) {
    final error = (up.stderr as String).trim();
    log.error('$dockerComposeStartFailed\n\n$error');
    return null;
  }

  log.info('Docker Compose services started.');
  return true;
}

/// Runs `docker` with [arguments] in [serverDir]. Returns `null` when the
/// binary cannot be launched (Docker not installed or not on PATH).
Future<ProcessResult?> _runDocker(
  List<String> arguments,
  String serverDir,
) async {
  try {
    return await Process.run(
      'docker',
      arguments,
      workingDirectory: serverDir,
    );
  } on ProcessException {
    return null;
  }
}

Future<void> _stopDockerServices(String serverDir) async {
  log.info('Stopping Docker Compose services...');
  await _runDocker(['compose', 'stop'], serverDir);
}

/// Prepends `--apply-migrations` to [serverArgs] unless it is already present.
List<String> _withApplyMigrations(List<String> serverArgs) {
  if (serverArgs.contains('--apply-migrations')) return serverArgs;
  return ['--apply-migrations', ...serverArgs];
}

/// Watch-session [ApplyMigrationsAction] that applies pending and repair
/// migrations by calling the running pod's `applyMigrations` endpoint. The
/// pod runs the migration in-process. The CLI only triggers it.
Future<void> _applyMigrationsForSession({
  required String serverDir,
  required String runMode,
}) async {
  final client = ConfigInfo(
    runMode,
    serverDir: serverDir,
  ).createServiceClient();
  try {
    await client.insights.applyMigrations(
      applyRepairMigration: true,
      applyMigrations: true,
    );
  } finally {
    client.close();
  }
}

/// Brings the development stack up and returns the context that owns it.
Future<WatchLoopSetupResult> setupWatchLoop({
  required GeneratorConfig config,
  required String serverDir,
  required ServerArgsRef serverArgs,
  required bool watch,
  required bool? docker,
  required bool launchFlutterApp,
  required ShutdownSignal shutdown,
  // Session-wide log retention. Filled here rather than by the presentation
  // layer, so the MCP log tools serve the same content with and without the
  // TUI. See [StartLogHistory].
  required StartLogHistory logHistory,
  IOSink? Function(String appId)? flutterStdoutEchoFor,
  IOSink? Function(String appId)? flutterStderrEchoFor,
  void Function(String appId, String line)? flutterEchoLine,
  IOSink? serverStdoutSink,
  IOSink? serverStderrSink,
}) async {
  void Function(ServerpodAddresses)? onServerAddresses;
  ServerpodAddresses? lastServerAddresses;
  void reportServerAddresses(ServerpodAddresses addresses) {
    lastServerAddresses = addresses;
    onServerAddresses?.call(addresses);
  }

  log.info(watch ? 'Starting server in watch mode...' : 'Starting server...');

  final RunnerLock lock;
  try {
    lock = await RunnerLock.acquire(serverDir);
  } on RunnerLockedException catch (e) {
    log.error('$e');
    return const WatchLoopAborted(1);
  }

  final runMode = runModeFromServerArgs(serverArgs.value);
  final runnerApi = LocalRunnerApi(
    logHistory: logHistory,
    requestShutdown: shutdown.complete,
    watchModeEnabled: watch,
    runMode: runMode,
  );

  final attachSocket = RunnerSocketServer(serverDir: serverDir);

  final serverConfig = _loadServerConfig(
    serverDir: serverDir,
    runMode: runMode,
  );

  final startDocker = _resolveStartDocker(
    dockerFlag: docker,
    serverDir: serverDir,
    serverConfig: serverConfig,
  );

  final requestedServerArgs = [...serverArgs.value];

  final manifestPublisher = RunnerManifestPublisher(
    serverDir: serverDir,
    manifest: RunnerManifest(
      pid: pid,
      stage: RunnerStage.starting,
      projectId: RunnerRegistry.idFor(serverDir),
      config: RunnerConfig(
        watch: watch,
        flutter: launchFlutterApp,
        docker: startDocker,
        serverArgs: requestedServerArgs,
      ),
    ),
  );
  Future<void> releaseRunnerHold({required int exitCode}) async {
    runnerApi.setStage(RunnerStage.stopping, exitCode: exitCode);
    await manifestPublisher.leaveBehind(
      manifestPublisher.manifest.copyWith(
        stage: RunnerStage.stopping,
        exitCode: exitCode,
      ),
    );
    await attachSocket.close();
    await lock.release();
  }

  final serverpodToolDir = serverpodToolDirPath(serverDir);
  final vmServiceInfoFile = userVmServiceInfoPath(serverDir);
  // The pod writes its raw VM service URI to a separate file. The user-facing
  // vm-service-info.json gets the proxy URI from _mountOrRetargetProxy.
  final podInfoFile = p.join(serverpodToolDir, 'vm-service-info.pod.json');

  // Replaces any stale manifest before the socket binds, so the two never pair.
  await manifestPublisher.publish();

  try {
    await attachSocket.start();
    attachSocket.connect(runnerApi);
  } on SocketException catch (e) {
    log.error(
      'Failed to serve the attach socket ${attachSocket.socketPath}: $e',
    );
    await releaseRunnerHold(exitCode: 1);
    return const WatchLoopAborted(1);
  }

  // Grows with each resource below, so the final catch releases what is held.
  Future<void> Function({int exitCode}) rollback = ({exitCode = 1}) =>
      releaseRunnerHold(exitCode: exitCode);

  try {
    final existingUri = await _checkExistingServer(vmServiceInfoFile);
    if (existingUri != null) {
      log.info('Existing server found.');
      log.info('VM service proxy listening on $existingUri');
      await releaseRunnerHold(exitCode: 0);
      return const WatchLoopAborted(0);
    }

    final resolvedPorts = await _resolvePortEnvironment(
      serverDir: serverDir,
      runMode: runMode,
      serverConfig: serverConfig,
    );
    if (resolvedPorts == null) {
      await releaseRunnerHold(exitCode: 1);
      return const WatchLoopAborted(1);
    }
    // Read per spawn, and pinned once the first pod reports its ports.
    var portEnvironment = resolvedPorts.environment;
    // Claimed before Docker, so a sibling resolving ports sees the decision.
    await manifestPublisher.replace(
      manifestPublisher.manifest.copyWith(ports: resolvedPorts.claimed),
    );

    var startedDocker = false;
    if (startDocker) {
      bool? dockerStarted;
      await log.progress(startingDockerServices, () async {
        dockerStarted = await _ensureDockerServices(serverDir);
        return dockerStarted != null;
      });
      if (dockerStarted == null) {
        await releaseRunnerHold(exitCode: 1);
        return const WatchLoopAborted(1);
      }
      startedDocker = dockerStarted!;
    }

    Future<void> stopDockerIfStarted() async {
      if (startedDocker) await _stopDockerServices(serverDir);
    }

    Future<void> rollbackProvisioning({int exitCode = 1}) async {
      await stopDockerIfStarted();
      await releaseRunnerHold(exitCode: exitCode);
    }

    rollback = rollbackProvisioning;

    if (shutdown.isShutdown) {
      await rollbackProvisioning(exitCode: 0);
      return const WatchLoopAborted(0);
    }

    serverArgs.value = _withApplyMigrations(serverArgs.value);

    // Unprimed, to overlap the staleness check. generateIfStale primes it.
    final analyzersFuture = IsolatedAnalyzers.create(config, prime: false);
    Future<void> closeAnalyzers() async => (await analyzersFuture).close();

    // A failed analyzer future must not skip the rest of the rollback.
    Future<void> rollbackStartup({int exitCode = 1}) async {
      try {
        await closeAnalyzers();
      } catch (_) {}
      await rollbackProvisioning(exitCode: exitCode);
    }

    rollback = rollbackStartup;

    final genResult = await generateIfStale(
      config: config,
      keepPrimedWhenFresh: true,
      createAnalyzers: () async {
        late final IsolatedAnalyzers analyzers;
        await log.progress('Initializing analyzers', () async {
          analyzers = await analyzersFuture;
          return true;
        });
        return analyzers;
      },
    );

    // A failed generation leaves the runner degraded instead of aborting.
    var buildOk = genResult.success;
    if (!buildOk) {
      log.error('Code generation failed.');
    } else if (genResult.upToDate) {
      log.info(generatedCodeAlreadyUpToDate, type: TextLogType.success);
    }

    if (shutdown.isShutdown) {
      await rollbackStartup(exitCode: 0);
      return const WatchLoopAborted(0);
    }

    KernelCompiler? compiler;
    NativeAssetsBuilder? nativeAssetsBuilder;
    String? dartExecutable;
    String? serverDartToolDir;
    // Null reloads the pod on every package_config.json change.
    PackageDependencyTracker? serverDependencyTracker;
    if (watch) {
      final entryPoint = p.join(serverDir, 'bin', 'main.dart');
      final initialDill = p.join(serverpodToolDir, 'server.dill');
      // One root for compiler, hooks and watcher. KernelCompiler says why.
      final projectRoot = await discoverProjectRootFrom(serverDir);
      serverDartToolDir = p.join(projectRoot, '.dart_tool');
      final packageConfigPath = p.join(
        serverDartToolDir,
        'package_config.json',
      );
      final localCompiler = KernelCompiler(
        entryPoint: entryPoint,
        outputDill: initialDill,
        packagesPath: packageConfigPath,
      );
      rollback = ({int exitCode = 1}) async {
        await localCompiler.dispose();
        await rollbackStartup(exitCode: exitCode);
      };

      final localBuilder = _createNativeAssetsBuilder(
        serverDir: serverDir,
        projectRoot: projectRoot,
        serverpodToolDir: serverpodToolDir,
        dartExecutable: localCompiler.dartExecutable,
      );
      late final bool hooksOk;
      await log.progress('Running build hooks', () async {
        hooksOk = await _runHooksFor(localBuilder, localCompiler);
        return hooksOk;
      });
      if (!hooksOk) {
        await rollback();
        return const WatchLoopAborted(1);
      }

      await localCompiler.start();

      if (buildOk) {
        if (!await localCompiler.compileIfNeeded(
          config.watchPaths(includeWeb: true, includeClientPackage: true),
        )) {
          // Back to the empty state, so recovery does a full compile.
          await localCompiler.reject();
          log.error('Initial compilation failed.');
          buildOk = false;
        }
      }

      if (shutdown.isShutdown) {
        await rollback(exitCode: 0);
        return const WatchLoopAborted(0);
      }

      compiler = localCompiler;
      nativeAssetsBuilder = localBuilder;
      dartExecutable = localCompiler.dartExecutable;

      // Built now, so the first package_config.json change has a baseline.
      final serverResolutionDartTool =
          PackageDependencyTracker.resolveDartToolDir(
            serverDir,
            packageName: config.serverPackage,
          );
      serverDependencyTracker = serverResolutionDartTool == null
          ? null
          : PackageDependencyTracker(
              dartToolDir: serverResolutionDartTool,
              packageName: config.serverPackage,
            );
    }

    // Initialized even without `--flutter`, for the apps' IDE info files.
    final serverPubspecFile = File(p.join(serverDir, 'pubspec.yaml'));
    final flutterManager = FlutterAppManager(
      runMode: runMode,
      projectName: config.name,
      autoLaunchArmed: false,
      serverpodToolDir: serverpodToolDir,
      serverPubspecFile: serverPubspecFile,
      serverPackageDirectoryPathParts: config.serverPackageDirectoryPathParts,
      onReady: (app, url) => runnerApi.recordFlutterAppState(app.id, url: url),
      onStart: (app, process) => _recordExtensionEvents(
        process.vmService,
        (event) => logHistory.recordFlutterExtensionEvent(app.id, event),
      ),
      onStop: (app) => runnerApi.recordFlutterAppState(app.id),
      onLaunchFailed: (app) => runnerApi.recordFlutterAppState(app.id),
      onLaunching: (app) => runnerApi.recordFlutterAppState(app.id),
      onProgress: (app, stage) =>
          runnerApi.recordFlutterAppState(app.id, launchStage: stage),
      onLog: (app, event) => logHistory.recordFlutterLogEvent(app.id, event),
      stdoutSinkFor: (app) => logHistory.flutterOutputSink(
        app.id,
        forwardTo: flutterStdoutEchoFor?.call(app.id),
        echoLine: _appLineEcho(flutterEchoLine, app.id),
      ),
      stderrSinkFor: (app) => logHistory.flutterOutputSink(
        app.id,
        forwardTo: flutterStderrEchoFor?.call(app.id),
        echoLine: _appLineEcho(flutterEchoLine, app.id),
      ),
    );
    final rollbackBeforeFlutter = rollback;
    rollback = ({int exitCode = 1}) async {
      await flutterManager.dispose();
      await rollbackBeforeFlutter(exitCode: exitCode);
    };
    await flutterManager.initialize();

    if (shutdown.isShutdown) {
      await rollback(exitCode: 0);
      return const WatchLoopAborted(0);
    }

    late final WatchSession session;
    VmServiceProxy? proxy;
    Future<ServerProcess> serverProcessFactory(String? dillPath) async {
      final serverProcess = ServerProcess(
        serverDir: serverDir,
        serverArgs: serverArgs.value,
        dartExecutable: dartExecutable,
        enableVmService: true,
        vmServiceInfoFile: podInfoFile,
        stdoutSink: serverStdoutSink,
        stderrSink: serverStderrSink,
        onDispose: logHistory.discardActiveServerScopes,
        environment: portEnvironment.isEmpty ? null : portEnvironment,
      );
      await serverProcess.start(dillPath: dillPath);
      await serverProcess.connectToVmService();
      await _recordExtensionEvents(serverProcess.vmService, (event) {
        logHistory.recordServerLogEvent(event);
        if (event.extensionKind == serverpodAddressesEvent) {
          reportServerAddresses(
            ServerpodAddresses.fromJson(event.extensionData?.data ?? const {}),
          );
        }
      });
      runnerApi.setStage(RunnerStage.running);
      proxy = await _mountOrRetargetProxy(
        serverProcess: serverProcess,
        existing: proxy,
        userInfoFile: vmServiceInfoFile,
        reload: watch ? () => session.forceReload() : null,
      );
      return serverProcess;
    }

    ServerProcess? initialServerProcess;
    if (buildOk) {
      initialServerProcess = await bootInitialServer(
        initialDill: watch ? p.join(serverpodToolDir, 'server.dill') : null,
        startServer: serverProcessFactory,
        compiler: compiler,
      );
      if (initialServerProcess case final server?) {
        final rollbackBeforeBoot = rollback;
        rollback = ({int exitCode = 1}) async {
          await server.stop();
          await rollbackBeforeBoot(exitCode: exitCode);
        };
      } else {
        log.error('Initial compilation failed.');
        buildOk = false;
      }
    }
    if (!buildOk) {
      log.warning(
        watch ? startBlockedByErrorsWatch : startBlockedByErrorsManual,
      );
    }

    // A stop can arrive over the attach socket at any point in the boot.
    if (shutdown.isShutdown) {
      await rollback(exitCode: 0);
      return const WatchLoopAborted(0);
    }

    StreamSubscription<void>? fileChangeSub;

    /// Replaces the file watcher that feeds [WatchSession.handleFileChange].
    void setupFileWatcher() {
      fileChangeSub?.cancel();
      if (!watch) return;
      final currentApps = flutterManager.apps.toList();
      final flutterPackageGraphPaths = [
        for (final app in currentApps)
          ?flutterManager.packageGraphPathFor(app.id),
      ];
      final watcher = FileWatcher(
        watchPaths: buildWatchPaths(
          config: config,
          flutterApps: currentApps,
          serverDartToolDir: serverDartToolDir,
          flutterPackageGraphPaths: flutterPackageGraphPaths,
        ),
        // Exact files, so one resolution's change never runs another's action.
        packageConfigPath: serverDartToolDir == null
            ? null
            : p.join(serverDartToolDir, 'package_config.json'),
        packageGraphPaths: {
          ...flutterPackageGraphPaths,
        },
      );
      fileChangeSub = watcher.onFilesChanged
          .asyncMapBuffer((events) => session.handleFileChange(events.merge()))
          .listen((_) {});
    }

    session = WatchSession(
      compiler: compiler,
      nativeAssetsBuilder: nativeAssetsBuilder,
      generate: (affectedPaths, requirements) async {
        return analyzeAndGenerate(
          analyzers: await analyzersFuture,
          config: config,
          affectedPaths: affectedPaths,
          incremental: true,
          requirements: requirements,
        );
      },
      fullGenerate: () async {
        final allSources = await enumerateSourceFiles(config);
        return analyzeAndGenerate(
          analyzers: await analyzersFuture,
          config: config,
          affectedPaths: allSources.keys.toSet(),
          incremental: false,
          verifyStaleness: false,
          sourceStats: allSources,
        );
      },
      createServer: serverProcessFactory,
      initialServer: initialServerProcess,
      generatedDirPaths: config.generatedDirPaths,
      serverDependencyTracker: serverDependencyTracker,
      flutterManager: flutterManager,
      flutterAppsLoader: () async {
        await flutterManager.loadApps();
        runnerApi.recordFlutterApps(flutterManager.apps.toList());
        setupFileWatcher();
      },
      applyMigrationsAction: () => _applyMigrationsForSession(
        serverDir: serverDir,
        runMode: runMode,
      ),
      servesWeb: () => stackServesWeb(lastServerAddresses, serverConfig),
    );

    // Through the session, so an IDE-triggered launch waits behind any reload.
    flutterManager.launchOnWaitingClient = session.spawnFlutterApp;

    unawaited(session.done.then(shutdown.complete));

    runnerApi.bindStack(
      session: session,
      flutterManager: flutterManager,
      config: config,
      vmServiceUri: () => proxy?.httpUri.toString(),
    );

    runnerApi.setStage(
      session.isRunning ? RunnerStage.running : RunnerStage.degraded,
    );
    runnerApi.recordFlutterApps(flutterManager.apps.toList());

    // Apps launch once a UI attaches and, on ephemeral ports, the pod reports.
    var clientAttached = false;
    var appsLaunched = false;
    var explainedTheWait = false;
    void launchAppsIfReady() {
      if (appsLaunched || !clientAttached) return;
      if (portEnvironment.isNotEmpty && flutterManager.resolvedApiUrl == null) {
        if (explainedTheWait) return;
        explainedTheWait = true;
        log.info(
          'The Flutter apps start once the server reports the port it bound: '
          'the configured ports were taken, so they are built against the '
          'ephemeral one rather than another project\'s server.',
        );
        return;
      }
      appsLaunched = true;
      unawaited(session.launchAutoLaunchApps());
    }

    if (launchFlutterApp) {
      attachSocket.onFirstClientAttached = () {
        clientAttached = true;
        launchAppsIfReady();
      };
    }

    McpSocketServer? mcpSocket = McpSocketServer(serverDir: serverDir);
    try {
      await mcpSocket.start();
      mcpSocket.connect(runnerApi);
      log.info('MCP server listening on ${mcpSocket.socketPath}');
    } on SocketException catch (e) {
      log.warning('Failed to start MCP server: $e');
      mcpSocket = null;
    }

    setupFileWatcher();

    await manifestPublisher.replace(
      manifestPublisher.manifest.copyWith(
        stage: runnerApi.stage,
        vmService: RunnerVmServiceUris(proxy: proxy?.httpUri.toString()),
        docker: startDocker
            ? RunnerDocker(
                startedByRunner: startedDocker,
                project: composeProjectName(serverDir),
              )
            : null,
      ),
    );
    onServerAddresses = (addresses) {
      final servers = addresses;
      // Configured ports keep the apps' own config, which may name a LAN host.
      if (portEnvironment.isNotEmpty) {
        flutterManager.resolvedApiUrl = servers.api;
      }
      portEnvironment = pinResolvedPorts(portEnvironment, addresses);
      final updated = manifestPublisher.manifest.copyWith(servers: servers);
      runnerApi.recordManifest(updated);
      unawaited(manifestPublisher.replace(updated));
      launchAppsIfReady();
    };
    if (lastServerAddresses case final addresses?) {
      onServerAddresses(addresses);
    }

    manifestPublisher.republishOn(
      runnerApi.events.where((event) => event is StageChangedEvent),
      (current) => current.copyWith(stage: runnerApi.stage),
    );

    manifestPublisher.republishOn(session.vmServiceUriChanges, (current) {
      final updated = current.copyWith(
        vmService: RunnerVmServiceUris(proxy: proxy?.httpUri.toString()),
      );
      runnerApi.recordManifest(updated);
      return updated;
    });

    return WatchLoopReady(
      WatchLoopContext(
        session: session,
        runnerApi: runnerApi,
        proxy: () => proxy,
        flutterManager: flutterManager,
        mcpSocket: mcpSocket,
        attachSocket: attachSocket,
        closeAnalyzers: closeAnalyzers,
        announceStopping: (exitCode) =>
            runnerApi.setStage(RunnerStage.stopping, exitCode: exitCode),
        stopFileWatcher: () => fileChangeSub?.cancel(),
        stopDocker: startedDocker ? () => _stopDockerServices(serverDir) : null,
        vmServiceInfoFile: vmServiceInfoFile,
        manifestPublisher: manifestPublisher,
        lock: lock,
      ),
    );
  } catch (error, stackTrace) {
    // Logged first, so the log tail `serverpod start` prints includes it.
    printInternalError(error, stackTrace);
    await rollback();
    throw ExitException.error();
  }
}

/// Forwards [vmService]'s `Extension` events to [onEvent] for as long as the
/// process is connected.
///
/// Returns false when the subscription fails. It listens first, because DDS
/// replays history before answering and vm_service drops unheard events.
Future<bool> _recordExtensionEvents(
  VmService? vmService,
  void Function(Event event) onEvent,
) async {
  if (vmService == null) return false;
  final subscription = vmService.onExtensionEvent.listen(onEvent);
  try {
    await vmService.streamListen(EventStreams.kExtension);
  } on RPCError catch (e) {
    await subscription.cancel();
    log.warning('Could not subscribe to the VM service log stream: $e');
    return false;
  }
  return true;
}

/// Boots the initial server process, recovering once from a corrupt cached
/// dill (a pod that dies before publishing its VM service URI never got past
/// kernel loading). Returns `null` if the recovery recompile fails.
@visibleForTesting
Future<ServerProcess?> bootInitialServer({
  required String? initialDill,
  required Future<ServerProcess> Function(String? dillPath) startServer,
  required KernelCompiler? compiler,
}) async {
  Future<ServerProcess> boot() async {
    late ServerProcess server;
    await log.progress('Starting server', () async {
      server = await startServer(initialDill);
      return true;
    });
    return server;
  }

  final server = await boot();
  if (compiler == null) return server;

  // exitCode is already completed whenever isRunning is false.
  final crashedLoadingKernel =
      server.vmServiceUri == null &&
      !server.isRunning &&
      await server.exitCode != 0;
  if (!crashedLoadingKernel) return server;

  log.warning(cachedBuildCrashedOnBoot);
  await compiler.invalidateCachedDill();
  // Ensure a complete kernel, not an incremental delta.
  await compiler.reset();
  final result = await compileWithProgress(
    'Compiling server',
    compiler,
    rejectOnFailure: true,
  );
  if (result == null) return null;
  await compiler.accept();
  return boot();
}

/// The paths the watch-mode [FileWatcher] observes: server/shared/client
/// source, the server's web dir, each Flutter app's lib and pubspec.yaml, and
/// the exact `package_config.json` / `package_graph.json` files of the
/// resolution `.dart_tool`(s).
///
/// [serverDartToolDir] is the server's resolution `.dart_tool` (workspace root
/// or the package itself); watching its `package_config.json` is what makes a
/// dependency change reload the server in place. [flutterPackageGraphPaths]
/// contains the resolved or expected graph path for every Flutter app.
///
/// The pub artifacts are watched as exact files rather than their `.dart_tool`
/// directories: those directories also hold large, churning build state (e.g.
/// `flutter_build` intermediates when a Flutter app builds, or the server's
/// dill), and a recursive directory watch has to scan and re-list that tree on
/// every build - heavy disk I/O for events that would all be discarded anyway.
@visibleForTesting
Set<String> buildWatchPaths({
  required GeneratorConfig config,
  List<FlutterAppConfig> flutterApps = const [],
  String? serverDartToolDir,
  Iterable<String> flutterPackageGraphPaths = const [],
}) {
  return {
    p.absolute(p.joinAll(config.libSourcePathParts)),
    ...config.sharedModelsLibSourcePaths.map(p.absolute),
    p.absolute(p.joinAll([...config.clientPackagePathParts, 'lib'])),
    p.absolute(p.joinAll([...config.serverPackageDirectoryPathParts, 'web'])),
    // The server's pubspec.yaml watched for changes to the flutter_apps config.
    p.absolute(
      p.joinAll([...config.serverPackageDirectoryPathParts, 'pubspec.yaml']),
    ),
    for (final app in flutterApps) ...[
      p.absolute(p.joinAll([...app.pathParts, 'lib'])),
      // The app's pubspec.yaml, watched as an exact file (it lives in the app
      // root, not under lib/) so an assets/fonts/dependency change triggers a
      // full Flutter relaunch.
      p.absolute(p.joinAll([...app.pathParts, 'pubspec.yaml'])),
    ],
    // The server resolution's package_config.json, reloaded into the FES in
    // place on dependency changes. The exact-file watcher persists across an
    // initial absence or deletion without scanning the rest of .dart_tool.
    if (serverDartToolDir != null)
      p.absolute(p.join(serverDartToolDir, 'package_config.json')),
    // Each Flutter resolution's package_graph.json, watched to detect Flutter
    // dependency changes (workspace root or, in a non-workspace project, the
    // Flutter package's own .dart_tool).
    ...flutterPackageGraphPaths.map(p.absolute),
  };
}

/// Mounts a fresh [VmServiceProxy] in front of [serverProcess] (writing
/// the proxy's URI to [userInfoFile]), or retargets [existing] in place
/// when called for a subsequent pod restart so the published proxy URI
/// stays stable across pod swaps.
///
/// When [reload] is non-null, IDE-initiated `reloadSources` requests are
/// intercepted and routed through it (so the FES + codegen pipeline runs
/// before the VM reloads). When `null` - i.e. `--no-watch` mode, where
/// there is no FES to drive - reloadSources passes through verbatim so
/// the IDE keeps full request/response fidelity (notices, `pause`, etc.)
/// against the VM's own kernel service.
///
/// Returns the (possibly retargeted) proxy on success, or [existing] when
/// the pod hasn't published a VM service URI - the watch session keeps
/// running without an attachable proxy in that case.
Future<VmServiceProxy?> _mountOrRetargetProxy({
  required ServerProcess serverProcess,
  required VmServiceProxy? existing,
  required String userInfoFile,
  required Future<void> Function()? reload,
}) async {
  final podHttp = serverProcess.vmServiceUri;
  if (podHttp == null) {
    log.warning(
      'Pod did not publish a VM service URI; IDE attach will not be '
      'available for this pod. (Reload, restart, and the rest of the '
      'watch loop continue to work.)',
    );
    return existing;
  }
  final podWs = Uri.parse(vmServiceWsUri(podHttp));

  if (existing != null) {
    await existing.setUpstream(podWs);
    return existing;
  }

  final proxy = VmServiceProxy(
    upstreamWs: podWs,
    interceptor: reload == null ? null : reloadSourcesInterceptor(reload),
  );
  await proxy.bind();
  await File(userInfoFile).writeAsString(
    jsonEncode({'uri': proxy.httpUri.toString()}),
  );
  log.info('VM service proxy listening on ${proxy.httpUri}');
  return proxy;
}

/// The file an IDE reads the pod's VM service URI from.
///
/// It names the runner's proxy, or the pod itself when started by hand.
String userVmServiceInfoPath(String serverDir) =>
    p.join(serverpodToolDirPath(serverDir), 'vm-service-info.json');

/// The `uri` string of the JSON object in [content], or null for anything else.
///
/// The file holds whatever was left at the path, so bad content is no error.
@visibleForTesting
String? vmServiceUriFrom(String content) {
  final Object? json;
  try {
    json = jsonDecode(content);
  } on FormatException {
    return null;
  }
  return switch (json) {
    {'uri': final String uri} => uri,
    _ => null,
  };
}

/// Checks if a server is already running by reading the VM service info file
/// and attempting to connect. Returns the URI if reachable, `null` otherwise.
/// Cleans up stale files.
Future<String?> _checkExistingServer(String infoPath) async {
  final file = File(infoPath);
  if (!file.existsSync()) return null;

  try {
    final uri = vmServiceUriFrom(file.readAsStringSync());
    if (uri == null) {
      await file.deleteIfExists();
      return null;
    }

    final vmService = await vmServiceConnectUri(vmServiceWsUri(uri)).timeout(
      const Duration(seconds: 3),
    );
    await vmService.dispose();
    return uri;
  } on Exception {
    // Stale or unreachable - clean up and proceed with normal startup.
    await file.deleteIfExists();
    return null;
  }
}
