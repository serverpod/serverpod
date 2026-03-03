import 'dart:async';

import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:stream_transform/stream_transform.dart';

/// Runs code generation. Returns true on success.
typedef GenerateAction = Future<bool> Function();

/// Returns true if the given file path is an endpoint file.
typedef EndpointFileCheck = bool Function(String filePath);

/// Creates a new server process, starts it, connects VM service,
/// and returns it ready for use.
typedef ServerProcessFactory = Future<ServerProcess> Function(String dillPath);

/// Orchestrates the watch-mode reload cycle.
///
/// Handles file change events by determining whether code generation,
/// compilation (incremental or full restart), and hot reload or server
/// restart are needed.
class WatchSession {
  final KernelCompiler _compiler;
  final GenerateAction _generate;
  final EndpointFileCheck _isEndpointFile;
  final ServerProcessFactory _createServer;
  final String _initialDill;

  final Completer<int> _done = Completer<int>();

  ServerProcess _server;
  StreamSubscription<void>? _subscription;
  bool _restarting = false;

  WatchSession({
    required KernelCompiler compiler,
    required GenerateAction generate,
    required EndpointFileCheck isEndpointFile,
    required ServerProcessFactory createServer,
    required ServerProcess initialServer,
    required String initialDill,
  }) : _compiler = compiler,
       _generate = generate,
       _isEndpointFile = isEndpointFile,
       _createServer = createServer,
       _server = initialServer,
       _initialDill = initialDill {
    _monitorExit(initialServer);
  }

  /// Completes when the server exits unexpectedly (crash).
  Future<int> get done => _done.future;

  /// Starts listening to file change events.
  ///
  /// Events are serialized via [asyncMapBuffer]: while a reload cycle
  /// is in progress, new events are buffered and merged.
  void listen(Stream<FileChangeEvent> fileChanges) {
    _subscription = fileChanges
        .asyncMapBuffer(
          (events) => handleFileChange(mergeEvents(events)),
        )
        .listen((_) {});
  }

  /// Processes a single (merged) file change event.
  ///
  /// This is the core orchestration logic. It is public so tests can
  /// call it directly without stream plumbing.
  Future<void> handleFileChange(FileChangeEvent event) async {
    final hasDartChanges =
        event.dartFiles.isNotEmpty ||
        event.removedDartFiles.isNotEmpty ||
        event.modelFiles.isNotEmpty ||
        event.packageConfigChanged;

    // Static-only changes (HTML, JS, CSS): no compilation needed,
    // just trigger a reload to bump reloadCount so the browser refreshes.
    if (!hasDartChanges) {
      if (_server.isVmServiceConnected) {
        await _server.reload(_initialDill);
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
        event.dartFiles.any(_isEndpointFile);

    if (needsCodeGen) {
      final genSuccess = await log.progress(
        'Generating code',
        () => _generate(),
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
      // After restart the FES is in initial state, so we do a full compile.
      await _compiler.restart();
      result = await _compile();
    } else {
      result = await _recompile(event.dartFiles);
    }

    if (result == null) {
      return;
    }

    _compiler.accept();

    // Hot reload if VM service is connected, otherwise fall back to restart.
    if (_server.isVmServiceConnected) {
      final reloaded = await _server.reload(result.dillOutput!);
      if (reloaded) {
        log.info('Server reloaded.');
        return;
      }
      log.warning('Hot reload failed, falling back to restart.');
    }

    // Fall back to restart: need a full dill to boot a new process.
    // The incremental dill only contains deltas. Reset the compiler
    // so the next compile produces a complete kernel.
    _compiler.reset();
    final fullResult = await _compile();
    if (fullResult == null) {
      return;
    }
    _compiler.accept();

    _restarting = true;
    await _server.stop();
    _server = await _createServer(fullResult.dillOutput!);
    _monitorExit(_server);
    _restarting = false;
    log.info('Server restarted.');
  }

  /// Disposes the session: cancels subscription, stops server,
  /// disposes compiler.
  Future<void> dispose() async {
    await _subscription?.cancel();
    _restarting = true;
    await _server.stop();
    await _compiler.dispose();
  }

  void _monitorExit(ServerProcess server) {
    unawaited(
      server.exitCode.then((code) {
        if (!_restarting && !_done.isCompleted) {
          _done.complete(code);
        }
      }),
    );
  }

  Future<CompileResult?> _compile() async {
    late CompileResult result;
    final success = await log.progress('Compiling server', () async {
      result = await _compiler.compile();
      return result.errorCount == 0;
    });

    if (!success) {
      for (final line in result.compilerOutputLines) {
        log.error(line);
      }
      await _compiler.reject();
      return null;
    }

    return result;
  }

  Future<CompileResult?> _recompile(Set<String> paths) async {
    late CompileResult result;
    final success = await log.progress('Compiling server', () async {
      result = await _compiler.recompile(paths);
      return result.errorCount == 0;
    });

    if (!success) {
      for (final line in result.compilerOutputLines) {
        log.error(line);
      }
      await _compiler.reject();
      return null;
    }

    return result;
  }
}

/// Merges multiple buffered [FileChangeEvent]s into a single event.
FileChangeEvent mergeEvents(List<FileChangeEvent> events) {
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
