import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Manages the flutter run subprocess lifecycle.
/// Handles spawning, signal forwarding, output streaming and graceful shutdown.
class FlutterProcess {
  FlutterProcess({
    required String flutterPackageDir,
    required bool spawnFromTui,
    IOSink? stdoutSink,
    IOSink? stderrSink,
  }) : _spawnFromTui = spawnFromTui,
       _flutterPackageDir = flutterPackageDir,
       _stdout = stdoutSink ?? stdout,
       _stderr = stderrSink ?? stderr;

  /// Whether the process was spawn from tui mode.
  final bool _spawnFromTui;
  final String _flutterPackageDir;
  final IOSink _stdout;
  final IOSink _stderr;

  Process? _process;
  StreamSubscription? _sigtermSub;
  StreamSubscription? _stdinSub;
  StreamSubscription? _stdoutSub;
  StreamSubscription? _stderrSub;

  bool? originalEchoMode;
  bool? originalLineMode;

  /// Matches the `flutter run` output that points to the
  /// URL where the app is served.
  late final _hostRegex = RegExp(r'served\s+at\s+(http:\/\/localhost:\d+)');

  Future<void> start() async {
    if (_process != null) return;

    final progressCompleter = Completer<bool>();

    unawaited(
      log.progress('Launching Flutter app', () async {
        return await progressCompleter.future;
      }),
    );

    // Enable raw keyboard input if process is spawn
    // in --no-tui mode.
    if (!_spawnFromTui && stdin.hasTerminal) {
      originalEchoMode = stdin.echoMode;
      originalLineMode = stdin.lineMode;
      stdin.echoMode = false;
      stdin.lineMode = false;
    }

    final process = await Process.start(
      'flutter',
      ['run', '-d', 'web-server'],
      workingDirectory: _flutterPackageDir,
    );
    _process = process;

    if (!Platform.isWindows) {
      _sigtermSub = ProcessSignal.sigterm.watch().listen(
        (_) => process.kill(ProcessSignal.sigint),
      );
    }

    // Forward stdin if process is spawn in --no-tui mode.
    if (!_spawnFromTui) {
      _stdinSub = stdin.listen((data) {
        process.stdin.add(data);
      });
    }

    // Forward process output without exclusively binding the sinks,
    // so that the CLI logger can still write to stdout/stderr.
    _stdoutSub = process.stdout.listen((data) {
      _stdout.add(data);

      final line = utf8.decode(data);
      final match = _hostRegex.firstMatch(line);
      final url = match?.group(1);
      if (url != null) {
        log.info('Flutter app is running at $url');
        if (!progressCompleter.isCompleted) {
          progressCompleter.complete(true);
        }
      }
    });

    _stderrSub = process.stderr.listen((data) {
      if (!progressCompleter.isCompleted) {
        progressCompleter.complete(false);
      }
      _stderr.add(data);
    });

    // Handle process exit asynchronously.
    unawaited(
      process.exitCode.then((code) async {
        if (!progressCompleter.isCompleted) {
          progressCompleter.complete(false);
        }
        await _cleanup();
      }),
    );
  }

  void reload() {
    if (_process == null) return;
    _process?.stdin.write('r');
    log.info(flutterAppReloaded);
  }

  void restart() {
    if (_process == null) return;
    _process?.stdin.write('R');
    log.info(flutterAppRestarted);
  }

  void _restoreTerminal() {
    try {
      stdin.echoMode = originalEchoMode!;
      stdin.lineMode = originalLineMode!;
    } catch (_) {}
  }

  Future<void> _cleanup() async {
    _process = null;
    await _stdoutSub?.cancel();
    await _stderrSub?.cancel();
    await _sigtermSub?.cancel();
    await _stdinSub?.cancel();
    _stdoutSub = null;
    _stderrSub = null;
    _sigtermSub = null;
    _stdinSub = null;
    _restoreTerminal();
  }

  Future<void> stop() async {
    final process = _process;
    // Cancel signal forwarding before sending our own signal.
    await _sigtermSub?.cancel();
    _sigtermSub = null;

    if (process != null) {
      // Use SIGINT rather than SIGTERM: on Windows SIGTERM maps to
      // TerminateProcess (immediate kill), while SIGINT sends CTRL_C_EVENT
      // which allows the server to shut down gracefully.
      process.kill(ProcessSignal.sigint);
    }
    await _cleanup();
  }
}
