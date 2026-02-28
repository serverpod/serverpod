import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

/// Pattern matching the VM service listening line in process output.
final _vmServiceUriPattern = RegExp(
  r'The Dart VM service is listening on (http\S+)',
);

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

  Process? _process;
  StreamSubscription? _sigtermSub;
  StreamSubscription? _stdoutSub;
  StreamSubscription? _stderrSub;

  VmService? _vmService;
  String? _mainIsolateId;
  Completer<String?>? _vmServiceUriCompleter;

  ServerProcess({
    required String serverDir,
    required List<String> serverArgs,
    String? dartExecutable,
    bool enableVmService = false,
    IOSink? stdoutSink,
    IOSink? stderrSink,
  }) : _serverDir = serverDir,
       _serverArgs = serverArgs,
       _dartExecutable = dartExecutable ?? 'dart',
       _enableVmService = enableVmService,
       _stdout = stdoutSink ?? stdout,
       _stderr = stderrSink ?? stderr;

  /// Whether the server process is currently running.
  bool get isRunning => _process != null;

  /// Whether the VM service is connected.
  bool get isVmServiceConnected => _vmService != null;

  /// Starts the server subprocess.
  ///
  /// If [dillPath] is provided, the server is started from the compiled
  /// kernel file. Otherwise, `dart run bin/main.dart` is used.
  ///
  /// Returns a future that completes with the exit code when the
  /// process exits on its own (not via [stop]).
  Future<int> start({String? dillPath}) async {
    if (_process != null) {
      throw StateError('Server process is already running.');
    }

    final args = <String>[];

    // Enable VM service for hot reload support.
    if (_enableVmService) {
      args.add('--enable-vm-service=0');
      _vmServiceUriCompleter = Completer<String?>();
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

    // For VM service mode, intercept both stdout and stderr to extract the
    // service URI (Dart may print it on either stream depending on version).
    if (_enableVmService) {
      _stdoutSub = process.stdout.transform(utf8.decoder).listen((chunk) {
        _tryExtractVmServiceUri(chunk);
        _stdout.write(chunk);
      });
      _stderrSub = process.stderr.transform(utf8.decoder).listen((chunk) {
        _tryExtractVmServiceUri(chunk);
        _stderr.write(chunk);
      });
    } else {
      // Forward process output without exclusively binding the sinks,
      // so that the CLI logger can still write to stdout/stderr.
      _stdoutSub = process.stdout.listen(_stdout.add);
      _stderrSub = process.stderr.listen(_stderr.add);
    }

    final exitCode = await process.exitCode;

    // If VM service URI was never found, complete with null.
    if (_vmServiceUriCompleter != null &&
        !_vmServiceUriCompleter!.isCompleted) {
      _vmServiceUriCompleter!.complete(null);
    }

    await _cleanup();
    return exitCode;
  }

  void _tryExtractVmServiceUri(String chunk) {
    if (_vmServiceUriCompleter != null &&
        !_vmServiceUriCompleter!.isCompleted) {
      final match = _vmServiceUriPattern.firstMatch(chunk);
      if (match != null) {
        _vmServiceUriCompleter!.complete(match.group(1));
      }
    }
  }

  /// Connects to the server's VM service.
  ///
  /// Must be called after [start] and only when `enableVmService` is true.
  /// Waits for the VM service URI to appear in the process output.
  Future<void> connectToVmService() async {
    final completer = _vmServiceUriCompleter;
    if (completer == null) {
      throw StateError(
        'Cannot connect to VM service: enableVmService was not set.',
      );
    }

    final httpUri = await completer.future;
    if (httpUri == null) {
      log.warning('VM service URI not found in server output.');
      return;
    }

    // Convert HTTP URI to WebSocket URI.
    final wsUri = httpUri
        .replaceFirst('http://', 'ws://')
        .replaceFirst('https://', 'wss://');
    final wsUriWithSuffix = wsUri.endsWith('/') ? '${wsUri}ws' : '$wsUri/ws';

    // The VM service may not be fully ready immediately after printing
    // its URI. Retry a few times with a short delay.
    const maxRetries = 5;
    for (var attempt = 0; attempt < maxRetries; attempt++) {
      try {
        _vmService = await vmServiceConnectUri(wsUriWithSuffix);
        break;
      } on Exception {
        if (attempt == maxRetries - 1) rethrow;
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
    }

    final vm = await _vmService!.getVM();
    _mainIsolateId = vm.isolates!.first.id!;
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

  Future<void> _cleanup() async {
    // Guard: both start() and stop() may call _cleanup() concurrently.
    if (_process == null) return;
    _process = null;
    await _vmService?.dispose();
    _vmService = null;
    _mainIsolateId = null;
    _vmServiceUriCompleter = null;
    await _stdoutSub?.cancel();
    await _stderrSub?.cancel();
    await _sigtermSub?.cancel();
    _stdoutSub = null;
    _stderrSub = null;
    _sigtermSub = null;
  }
}
