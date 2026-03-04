import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

/// Converts a VM service HTTP URI to a WebSocket URI.
String vmServiceWsUri(String httpUri) {
  final wsUri = httpUri
      .replaceFirst('http://', 'ws://')
      .replaceFirst('https://', 'wss://');
  return wsUri.endsWith('/') ? '${wsUri}ws' : '$wsUri/ws';
}

/// Callback for IDE-initiated reload requests.
///
/// Should compile changes and return the dill path on success, or `null`
/// on compilation failure.
typedef ReloadRequestedCallback = Future<String?> Function();

/// Manages the server subprocess lifecycle.
///
/// Handles spawning, signal forwarding, output streaming, graceful shutdown,
/// and optional VM service connection for hot reload.
class ServerProcess {
  final String _serverDir;
  final List<String> _serverArgs;
  final String _dartExecutable;
  final bool _enableVmService;
  final IOSink _stdout;
  final IOSink _stderr;

  /// Callback invoked when an IDE requests a reload via the VM service.
  final ReloadRequestedCallback? _onReloadRequested;

  /// Callback invoked when an external reload is detected (not initiated
  /// by this process). Used to reset FES compiler state.
  final void Function()? _onExternalReload;

  /// Path to write the VM service info JSON file to. When set, the file
  /// is passed to the child via `--write-service-info` and the URI is read
  /// from the file instead of parsing stdout. IDEs can use this path in
  /// their `vmServiceInfoFile` launch configuration to auto-attach.
  final String? _vmServiceInfoFile;

  Process? _process;
  StreamSubscription? _sigtermSub;
  StreamSubscription? _stdoutSub;
  StreamSubscription? _stderrSub;

  VmService? _vmService;
  String? _mainIsolateId;
  StreamSubscription? _isolateEventSub;

  final Completer<int> _exitCodeCompleter = Completer<int>();

  int _initiatedReloads = 0;
  int _observedReloads = 0;

  ServerProcess({
    required String serverDir,
    required List<String> serverArgs,
    String? dartExecutable,
    bool enableVmService = false,
    String? vmServiceInfoFile,
    IOSink? stdoutSink,
    IOSink? stderrSink,
    ReloadRequestedCallback? onReloadRequested,
    void Function()? onExternalReload,
  }) : _serverDir = serverDir,
       _serverArgs = serverArgs,
       _dartExecutable = dartExecutable ?? 'dart',
       _enableVmService = enableVmService,
       _vmServiceInfoFile = vmServiceInfoFile,
       _stdout = stdoutSink ?? stdout,
       _stderr = stderrSink ?? stderr,
       _onReloadRequested = onReloadRequested,
       _onExternalReload = onExternalReload;

  /// Whether the server process is currently running.
  bool get isRunning => _process != null;

  /// Whether the VM service is connected.
  bool get isVmServiceConnected => _vmService != null;

  /// Completes with the process exit code when the server exits.
  Future<int> get exitCode => _exitCodeCompleter.future;

  /// Starts the server subprocess.
  ///
  /// If [dillPath] is provided, the server is started from the compiled
  /// kernel file. Otherwise, `dart run bin/main.dart` is used.
  ///
  /// Use [exitCode] to wait for the process to exit.
  Future<void> start({String? dillPath}) async {
    if (_process != null) {
      throw StateError('Server process is already running.');
    }

    final args = <String>[];

    // Enable VM service for hot reload support.
    if (_enableVmService) {
      args.add('--enable-vm-service=0');
      if (_vmServiceInfoFile != null) {
        args.add('--write-service-info=$_vmServiceInfoFile');
      }
    }

    if (dillPath != null) {
      args.addAll([dillPath, ..._serverArgs]);
    } else {
      args.addAll(['run', 'bin/main.dart', ..._serverArgs]);
    }

    final process = await Process.start(
      _dartExecutable,
      args,
      workingDirectory: _serverDir,
    );
    _process = process;

    // The child process inherits the parent's process group, so terminal
    // signals (SIGINT) are delivered to both processes by the OS. Forwarding
    // SIGINT would cause double-delivery, which triggers Serverpod's force-exit.
    // Only forward SIGTERM, which is sent to a specific process (e.g. by kill).
    _sigtermSub = ProcessSignal.sigterm.watch().listen(
      (_) => process.kill(ProcessSignal.sigterm),
    );

    // Forward process output without exclusively binding the sinks,
    // so that the CLI logger can still write to stdout/stderr.
    _stdoutSub = process.stdout.listen(_stdout.add);
    _stderrSub = process.stderr.listen(_stderr.add);

    // Handle process exit asynchronously.
    unawaited(
      process.exitCode.then((code) async {
        _exitCodeCompleter.complete(code);
        await _cleanup();
      }),
    );
  }

  /// Connects to the server's VM service.
  ///
  /// Must be called after [start] and only when `enableVmService` is true.
  /// Reads the VM service URI from the service info file written by the
  /// child process via `--write-service-info`.
  Future<void> connectToVmService() async {
    final infoPath = _vmServiceInfoFile;
    if (infoPath == null) {
      throw StateError(
        'Cannot connect to VM service: vmServiceInfoFile was not set.',
      );
    }

    final httpUri = await _readVmServiceUri(infoPath);
    if (httpUri == null) {
      log.warning('VM service URI not found in service info file.');
      return;
    }

    // The VM service may not be fully ready immediately after printing
    // its URI. Retry a few times with a short delay.
    final wsUri = vmServiceWsUri(httpUri);
    const maxRetries = 5;
    for (var attempt = 0; attempt < maxRetries; attempt++) {
      try {
        _vmService = await vmServiceConnectUri(wsUri);
        break;
      } on Exception {
        if (attempt == maxRetries - 1) rethrow;
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
    }

    log.info('The Dart VM service is listening on $httpUri');

    final vmService = _vmService!;
    final vm = await vmService.getVM();
    _mainIsolateId = vm.isolates!.first.id!;

    // Register custom reloadSources service so IDE reload requests
    // go through the FES compilation pipeline.
    if (_onReloadRequested != null) {
      vmService.registerServiceCallback('reloadSources', (params) async {
        final dillPath = await _onReloadRequested();
        if (dillPath == null) {
          return {'type': 'ReloadReport', 'success': false};
        }
        _initiatedReloads++;
        final dillUri = Uri.file(p.absolute(dillPath)).toString();
        final report = await vmService.reloadSources(
          _mainIsolateId!,
          rootLibUri: dillUri,
        );
        return report.json!;
      });
      await vmService.registerService('reloadSources', 'serverpod-cli');
    }

    // Listen for isolate reload events to detect external reloads
    // (e.g., from an IDE that bypasses our custom service).
    if (_onExternalReload != null) {
      await vmService.streamListen(EventStreams.kIsolate);
      _isolateEventSub = vmService.onIsolateEvent.listen((event) {
        if (event.kind == EventKind.kIsolateReload) {
          _observedReloads++;
          if (_observedReloads > _initiatedReloads) {
            _onExternalReload();
          }
        }
      });
    }
  }

  /// Hot reloads the server with a new kernel file.
  ///
  /// Returns `true` if the reload was successful.
  Future<bool> reload(String dillPath) async {
    final vmService = _vmService;
    final isolateId = _mainIsolateId;
    if (vmService == null || isolateId == null) {
      return false;
    }

    _initiatedReloads++;
    final dillUri = Uri.file(p.absolute(dillPath)).toString();
    final report = await vmService.reloadSources(
      isolateId,
      rootLibUri: dillUri,
    );
    return report.success == true;
  }

  /// Stops the server process gracefully with SIGTERM.
  ///
  /// Cancels signal forwarding first to prevent double-delivery (e.g. the
  /// CLI receiving SIGINT and both the forwarder and [stop] sending signals).
  ///
  /// Returns the exit code. Falls back to SIGKILL after [timeout].
  Future<int> stop({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final process = _process;
    if (process == null) return 0;

    // Cancel signal forwarding before sending our own signal.
    await _sigtermSub?.cancel();
    _sigtermSub = null;

    process.kill(ProcessSignal.sigterm);

    final exitCode = await process.exitCode.timeout(
      timeout,
      onTimeout: () {
        log.warning(
          'Server did not stop within ${timeout.inSeconds}s, '
          'sending SIGKILL.',
        );
        process.kill(ProcessSignal.sigkill);
        return process.exitCode;
      },
    );

    await _cleanup();
    return exitCode;
  }

  /// Reads the VM service URI from the service info JSON file.
  ///
  /// The file is written by the child process via `--write-service-info`
  /// and may not appear immediately. Polls with a short delay.
  Future<String?> _readVmServiceUri(String path) async {
    final file = File(path);
    const maxAttempts = 50;
    const delay = Duration(milliseconds: 100);

    for (var i = 0; i < maxAttempts; i++) {
      if (!isRunning) return null;
      if (file.existsSync()) {
        try {
          final contents = file.readAsStringSync();
          final json = jsonDecode(contents) as Map<String, dynamic>;
          final uri = json['uri'] as String?;
          if (uri != null) return uri;
        } on FormatException {
          // File may be partially written; retry.
        }
      }
      await Future<void>.delayed(delay);
    }

    return null;
  }

  Future<void> _cleanup() async {
    // Guard: both start() and stop() may call _cleanup() concurrently.
    if (_process == null) return;
    _process = null;
    await _isolateEventSub?.cancel();
    _isolateEventSub = null;
    await _vmService?.dispose();
    _vmService = null;
    _mainIsolateId = null;
    _initiatedReloads = 0;
    _observedReloads = 0;
    await _stdoutSub?.cancel();
    await _stderrSub?.cancel();
    await _sigtermSub?.cancel();
    _stdoutSub = null;
    _stderrSub = null;
    _sigtermSub = null;

    // Clean up the service info file so stale URIs are not picked up.
    if (_vmServiceInfoFile != null) {
      try {
        File(_vmServiceInfoFile).deleteSync();
      } on FileSystemException {
        // May already be deleted or never created.
      }
    }
  }
}
