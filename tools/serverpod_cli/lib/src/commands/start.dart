import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:args/args.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_parameter_validator.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/sdk_path.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:stream_transform/stream_transform.dart';

/// Options for the `start` command.
enum StartOption<V> implements OptionDefinition<V> {
  watch(
    FlagOption(
      argName: 'watch',
      argAbbrev: 'w',
      defaultsTo: false,
      negatable: false,
      helpText: 'Watch for changes and hot reload the server.',
    ),
  ),
  directory(
    StringOption(
      argName: 'directory',
      argAbbrev: 'd',
      defaultsTo: '',
      helpText:
          'The server directory (defaults to auto-detect from current directory).',
    ),
  ),
  docker(
    FlagOption(
      argName: 'docker',
      defaultsTo: true,
      helpText:
          'Start Docker Compose services if a docker-compose.yaml exists.',
    ),
  );

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
      'Generate code and start the server. '
      'Use --watch to watch for changes and hot reload.';

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
    final watch = commandConfig.value(StartOption.watch);
    final directory = commandConfig.value(StartOption.directory);

    // Get interactive flag from global configuration.
    final interactive = serverpodRunner.globalConfiguration.optionalValue(
      GlobalOption.interactive,
    );

    // Load generator config (also resolves server directory).
    GeneratorConfig config;
    try {
      config = await GeneratorConfig.load(
        serverRootDir: directory,
        interactive: interactive,
      );
    } catch (e) {
      log.error('$e');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
    final docker = commandConfig.value(StartOption.docker);

    // Start Docker Compose services if needed.
    var startedDocker = false;
    if (docker) {
      startedDocker = await _ensureDockerServices(serverDir);
    }

    try {
      // Run initial code generation.
      final success = await log.progress(
        'Generating code',
        () => _generateInIsolate(config),
      );

      if (!success) {
        log.error('Code generation failed.');
        throw ExitException.error();
      }

      // Extract passthrough args (everything after '--').
      final serverArgs = argResults?.rest ?? [];

      if (watch) {
        await _startWithWatch(
          config: config,
          serverDir: serverDir,
          serverArgs: serverArgs,
        );
      } else {
        await _startOnce(
          serverDir: serverDir,
          serverArgs: serverArgs,
        );
      }
    } finally {
      if (startedDocker) {
        await _stopDockerServices(serverDir);
      }
    }
  }

  /// Starts the server once and waits for it to exit.
  Future<void> _startOnce({
    required String serverDir,
    required List<String> serverArgs,
  }) async {
    log.info('Starting server...');

    final serverProcess = ServerProcess(
      serverDir: serverDir,
      serverArgs: serverArgs,
    );

    final exitCode = await serverProcess.start();

    if (exitCode != 0) {
      throw ExitException(exitCode);
    }
  }

  /// Starts the server with file watching. On changes, re-generates code
  /// if needed, incrementally recompiles, and restarts the server.
  Future<void> _startWithWatch({
    required GeneratorConfig config,
    required String serverDir,
    required List<String> serverArgs,
  }) async {
    log.info('Starting server in watch mode...');

    // Resolve the dart executable from the SDK to ensure we use the same
    // version that compiled the kernel.
    final sdkRoot = getSdkPath();
    final dartExecutable = p.join(sdkRoot, 'bin', 'dart');

    final watchPaths = _watchPaths(config);
    final ignorePath = p.absolute(
      p.joinAll(config.generatedServeModelPackagePathParts),
    );

    final watcher = FileWatcher(
      watchPaths: watchPaths,
      ignorePath: ignorePath,
    );

    // Set up incremental compiler.
    final entryPoint = p.join(serverDir, 'bin', 'main.dart');
    final initialDill = p.join(
      serverDir,
      '.dart_tool',
      'serverpod',
      'server.dill',
    );
    final compiler = KernelCompiler(
      entryPoint: entryPoint,
      outputDill: initialDill,
    );

    await compiler.start();

    final initialResult = await _compileWithProgress(
      'Compiling server',
      () => compiler.compile(),
    );

    if (initialResult == null) {
      await compiler.dispose();
      log.error('Initial compilation failed.');
      throw ExitException.error();
    }

    compiler.accept();

    // IDE reload callback: compile incrementally and return the dill path.
    Future<String?> onReloadRequested() async {
      compiler.reset();
      final result = await _compileWithProgress(
        'Compiling server (IDE reload)',
        () => compiler.compile(),
        compiler: compiler,
      );
      if (result == null) return null;
      compiler.accept();
      return result.dillOutput ?? initialDill;
    }

    // External reload callback: reset FES so next compile is full.
    void onExternalReload() {
      log.info('External reload detected, resetting compiler.');
      compiler.reset();
    }

    ServerProcess createServerProcess() => ServerProcess(
      serverDir: serverDir,
      serverArgs: serverArgs,
      dartExecutable: dartExecutable,
      enableVmService: true,
      onReloadRequested: onReloadRequested,
      onExternalReload: onExternalReload,
    );

    var serverProcess = createServerProcess();

    // Start server from compiled kernel (don't await - it runs until stopped).
    unawaited(
      serverProcess.start(dillPath: initialDill).then((exitCode) {
        // If the process exits on its own (not during restart), exit the CLI.
        if (serverProcess.isRunning) return;
        log.info('Server exited with code $exitCode.');
      }),
    );

    // Connect to the VM service for hot reload.
    await serverProcess.connectToVmService();

    // Listen for changes, recompile, and reload.
    // asyncMapBuffer serializes processing: while a reload cycle is in
    // progress, new events are buffered and delivered as a batch to the
    // next invocation - no manual locking needed.
    final subscription = watcher.onFilesChanged
        .asyncMapBuffer((events) async {
          final event = _mergeEvents(events);

          // Static-only changes (HTML, JS, CSS): no compilation needed,
          // just trigger a reload to bump reloadCount so the browser
          // refreshes.
          final hasDartChanges =
              event.dartFiles.isNotEmpty ||
              event.removedDartFiles.isNotEmpty ||
              event.modelFiles.isNotEmpty ||
              event.packageConfigChanged;
          if (!hasDartChanges) {
            if (serverProcess.isVmServiceConnected) {
              await serverProcess.reload(initialDill);
              log.info('Browser refresh triggered.');
            }
            return;
          }

          log.info('Files changed, reloading server...');

          // Determine if code generation is needed.
          // Endpoint dispatch tables depend on Endpoint subclasses,
          // so we must regenerate when endpoint files change. Deleted
          // files always trigger code gen since we can't inspect them.
          final needsCodeGen =
              event.modelFiles.isNotEmpty ||
              event.removedDartFiles.isNotEmpty ||
              event.dartFiles.any(
                (f) => EndpointsAnalyzer.isEndpointFile(File(f)),
              );

          if (needsCodeGen) {
            final genSuccess = await log.progress(
              'Generating code',
              () => _generateInIsolate(config),
            );
            if (!genSuccess) {
              log.error('Code generation failed. Server not reloaded.');
              return;
            }
          }

          // Compile changes.
          CompileResult? result;
          if (event.packageConfigChanged) {
            // FES reads package_config.json only at startup - must restart it.
            await compiler.restart();
            result = await _compileWithProgress(
              'Compiling server',
              () => compiler.compile(),
              compiler: compiler,
            );
          } else if (needsCodeGen) {
            // Code generation may have changed generated files -
            // reset and do a full compile.
            compiler.reset();
            result = await _compileWithProgress(
              'Compiling server',
              () => compiler.compile(),
              compiler: compiler,
            );
          } else {
            // Incremental recompile with only the changed files.
            final changedPaths = {
              ...event.dartFiles,
              ...event.removedDartFiles,
            };
            log.debug('Invalidating ${changedPaths.length} files:');
            for (final path in changedPaths) {
              log.debug('  $path');
            }
            result = await _compileWithProgress(
              'Compiling server',
              () => compiler.recompile(changedPaths),
              compiler: compiler,
            );
          }

          if (result == null) {
            log.error('Compilation failed. Server not reloaded.');
            return;
          }

          log.debug(
            'Compile result: errorCount=${result.errorCount}, '
            'dill=${result.dillOutput}, '
            'newSources=${result.newSources.length}, '
            'outputLines=${result.compilerOutputLines.length}',
          );
          for (final line in result.compilerOutputLines) {
            log.debug('  FES: $line');
          }

          compiler.accept();

          // Hot reload if VM service is connected, otherwise fall back to restart.
          final reloadDill = result.dillOutput ?? initialDill;
          if (serverProcess.isVmServiceConnected) {
            log.debug('Sending reload with dill: $reloadDill');
            final reloaded = await serverProcess.reload(reloadDill);
            log.debug('Reload result: $reloaded');
            if (reloaded) {
              log.info('Server reloaded.');
              return;
            }
            log.warning('Hot reload failed, falling back to restart.');
          }

          // Fall back to restart: stop and respawn.
          await serverProcess.stop();

          serverProcess = createServerProcess();

          unawaited(serverProcess.start(dillPath: reloadDill));
          await serverProcess.connectToVmService();
          log.info('Server restarted.');
        })
        .listen((_) {});

    // Wait for SIGINT/SIGTERM to stop watch mode.
    final exitCompleter = Completer<void>();

    final sigintSub = ProcessSignal.sigint.watch().listen((_) {
      if (!exitCompleter.isCompleted) exitCompleter.complete();
    });
    final sigtermSub = ProcessSignal.sigterm.watch().listen((_) {
      if (!exitCompleter.isCompleted) exitCompleter.complete();
    });

    await exitCompleter.future;

    // Clean up.
    await subscription.cancel();
    await serverProcess.stop();
    await compiler.dispose();
    await sigintSub.cancel();
    await sigtermSub.cancel();
  }

  /// Ensures Docker Compose services are running.
  ///
  /// Returns `true` if this method started the containers (meaning we should
  /// stop them on shutdown). Returns `false` if no action was taken.
  Future<bool> _ensureDockerServices(String serverDir) async {
    final composeFile = File(p.join(serverDir, 'docker-compose.yaml'));
    if (!composeFile.existsSync()) return false;

    // Check if containers are already running.
    final ps = await Process.run(
      'docker',
      ['compose', 'ps', '--status', 'running', '-q'],
      workingDirectory: serverDir,
    );

    if (ps.exitCode != 0) {
      log.warning(
        'Docker does not appear to be running. '
        'Start Docker or use --no-docker to skip.',
      );
      return false;
    }

    final running = (ps.stdout as String).trim();
    if (running.isNotEmpty) return false;

    // Start containers.
    log.info('Starting Docker Compose services...');
    final up = await Process.run(
      'docker',
      ['compose', 'up', '-d'],
      workingDirectory: serverDir,
    );

    if (up.exitCode != 0) {
      final error = (up.stderr as String).trim();
      log.warning('Failed to start Docker Compose services: $error');
      return false;
    }

    log.info('Docker Compose services started.');
    return true;
  }

  Future<void> _stopDockerServices(String serverDir) async {
    log.info('Stopping Docker Compose services...');
    await Process.run(
      'docker',
      ['compose', 'stop'],
      workingDirectory: serverDir,
    );
  }

  /// Runs a compilation step with progress feedback.
  ///
  /// Returns the [CompileResult] on success, or `null` if compilation failed.
  /// On failure, logs compiler output and rejects via [compiler].
  Future<CompileResult?> _compileWithProgress(
    String message,
    Future<CompileResult> Function() compile, {
    KernelCompiler? compiler,
  }) async {
    late CompileResult result;
    final success = await log.progress(message, () async {
      result = await compile();
      return result.errorCount == 0;
    });

    if (!success) {
      for (final line in result.compilerOutputLines) {
        log.error(line);
      }
      if (compiler != null) {
        await compiler.reject();
      }
      return null;
    }

    return result;
  }

  List<String> _watchPaths(GeneratorConfig config) {
    final paths = <String>[];

    // Use absolute paths so DirectoryWatcher reports absolute event paths.
    // The Frontend Server needs absolute file:// URIs to match sources.
    final libPath = p.absolute(p.joinAll(config.libSourcePathParts));
    paths.add(libPath);

    for (final pathParts in config.sharedModelsSourcePathsParts.values) {
      final sharedLibPath = p.absolute(
        p.joinAll([
          ...config.serverPackageDirectoryPathParts,
          ...pathParts,
          'lib',
        ]),
      );
      paths.add(sharedLibPath);
    }

    // Watch the web directory for static file changes (HTML, JS, CSS).
    final webPath = p.absolute(
      p.joinAll([...config.serverPackageDirectoryPathParts, 'web']),
    );
    if (Directory(webPath).existsSync()) {
      paths.add(webPath);
    }

    return paths;
  }
}

/// Runs code generation in a fresh isolate.
///
/// Must be a top-level function so the closure passed to [Isolate.run]
/// doesn't capture unsendable objects from the call site's scope
/// (e.g. [KernelCompiler] which holds a [Process]).
Future<bool> _generateInIsolate(GeneratorConfig config) {
  return Isolate.run(() => _runGeneration(config: config));
}

Future<bool> _runGeneration({
  required GeneratorConfig config,
}) async {
  var libDirectory = Directory(p.joinAll(config.libSourcePathParts));
  var endpointsAnalyzer = EndpointsAnalyzer(libDirectory);

  var yamlModels = await ModelHelper.loadProjectYamlModelsFromDisk(config);
  var modelAnalyzer = StatefulAnalyzer(config, yamlModels, (uri, collector) {
    collector.printErrors();
  });

  var parameterValidator = FutureCallMethodParameterValidator(
    modelAnalyzer: modelAnalyzer,
  );

  var futureCallsAnalyzer = FutureCallsAnalyzer(
    directory: libDirectory,
    parameterValidator: parameterValidator,
  );

  return performGenerate(
    config: config,
    endpointsAnalyzer: endpointsAnalyzer,
    modelAnalyzer: modelAnalyzer,
    futureCallsAnalyzer: futureCallsAnalyzer,
  );
}

/// Merges multiple buffered [FileChangeEvent]s into a single event.
FileChangeEvent _mergeEvents(List<FileChangeEvent> events) {
  if (events.length == 1) return events.first;

  final dartFiles = <String>{};
  final removedDartFiles = <String>{};
  final modelFiles = <String>{};
  var packageConfigChanged = false;
  var staticFilesChanged = false;

  for (final event in events) {
    dartFiles.addAll(event.dartFiles);
    removedDartFiles.addAll(event.removedDartFiles);
    modelFiles.addAll(event.modelFiles);
    packageConfigChanged |= event.packageConfigChanged;
    staticFilesChanged |= event.staticFilesChanged;
  }

  // A file that was removed and then re-created is not removed.
  removedDartFiles.removeAll(dartFiles);

  return FileChangeEvent(
    dartFiles: dartFiles,
    removedDartFiles: removedDartFiles,
    modelFiles: modelFiles,
    packageConfigChanged: packageConfigChanged,
    staticFilesChanged: staticFilesChanged,
  );
}
