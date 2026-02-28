import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Manages the server subprocess lifecycle.
///
/// Handles spawning, signal forwarding, output streaming, and graceful
/// shutdown. Later steps extend this with VM service connection and
/// hot reload support.
class ServerProcess {
  final String _serverDir;
  final List<String> _serverArgs;
  final IOSink _stdout;
  final IOSink _stderr;

  Process? _process;
  StreamSubscription? _sigtermSub;
  StreamSubscription? _stdoutSub;
  StreamSubscription? _stderrSub;

  ServerProcess({
    required String serverDir,
    required List<String> serverArgs,
    IOSink? stdoutSink,
    IOSink? stderrSink,
  }) : _serverDir = serverDir,
       _serverArgs = serverArgs,
       _stdout = stdoutSink ?? stdout,
       _stderr = stderrSink ?? stderr;

  /// Whether the server process is currently running.
  bool get isRunning => _process != null;

  /// Starts the server subprocess.
  ///
  /// Returns a future that completes with the exit code when the
  /// process exits on its own (not via [stop]).
  Future<int> start() async {
    if (_process != null) {
      throw StateError('Server process is already running.');
    }

    final process = await Process.start(
      'dart',
      ['run', 'bin/main.dart', ..._serverArgs],
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

    final exitCode = await process.exitCode;
    await _cleanup();
    return exitCode;
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
    await _stdoutSub?.cancel();
    await _stderrSub?.cancel();
    await _sigtermSub?.cancel();
    _stdoutSub = null;
    _stderrSub = null;
    _sigtermSub = null;
  }
}
