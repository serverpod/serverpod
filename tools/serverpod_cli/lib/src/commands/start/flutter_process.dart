import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart'
    show vmServiceWsUri;
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/vendored/flutter_daemon_protocol.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

/// Thrown by [FlutterProcess.start] when `flutter` cannot be launched.
class FlutterNotInstalledException implements Exception {
  /// Reason `flutter` could not be launched.
  final String message;

  /// Underlying [ProcessException] or other cause.
  final Object? cause;

  FlutterNotInstalledException(this.message, [this.cause]);

  @override
  String toString() => 'FlutterNotInstalledException: $message';
}

/// Manages a `flutter run --machine` subprocess. Mirrors [ServerProcess].
/// VM service URI is written to [vmServiceInfoFile] for IDE attach;
/// reload/restart go via [FlutterDaemonProtocol] over daemon stdin.
class FlutterProcess {
  final String _flutterPackageDir;
  final String _flutterExecutable;
  final String _device;
  final List<String> _extraArgs;
  final IOSink _stdout;
  final IOSink _stderr;

  /// Sibling of the pod's `vm-service-info.json` so one launch.json
  /// directory reference covers both.
  final String? _vmServiceInfoFile;

  /// Fires `'launching'` on spawn, `'connecting'` before VM-service
  /// connect, `'ready'` on `app.started`, plus verbatim `app.progress`
  /// messages in between.
  final void Function(String stage)? _onProgress;

  /// Test-only spawn args override; replaces the default `flutter run`
  /// arg list when non-null.
  final List<String>? _argsOverrideForTesting;

  Process? _process;
  StreamSubscription<ProcessSignal>? _sigtermSub;
  StreamSubscription<List<int>>? _stdoutBytesSub;
  StreamSubscription<List<int>>? _stderrBytesSub;
  StreamSubscription<String>? _machineLinesSub;
  StreamSubscription<Event>? _loggingSub;

  String? _appId;
  FlutterDaemonProtocol? _daemon;
  String? _vmServiceUri;
  String? _flutterAppUrl;
  VmService? _vmService;

  // `null` result means the process exited before publishing a URI.
  final Completer<String?> _vmServiceUriCompleter = Completer<String?>();
  final Completer<int> _exitCodeCompleter = Completer<int>();
  final Completer<void> _launchedCompleter = Completer<void>();

  Completer<void>? _cleanupCompleter;

  FlutterProcess({
    required String flutterPackageDir,
    required String device,
    String flutterExecutable = 'flutter',
    List<String> extraArgs = const [],
    String? vmServiceInfoFile,
    void Function(String stage)? onProgress,
    IOSink? stdoutSink,
    IOSink? stderrSink,
    @visibleForTesting List<String>? argsOverrideForTesting,
  }) : _flutterPackageDir = flutterPackageDir,
       _flutterExecutable = flutterExecutable,
       _device = device,
       _extraArgs = extraArgs,
       _vmServiceInfoFile = vmServiceInfoFile,
       _onProgress = onProgress,
       _stdout = stdoutSink ?? stdout,
       _stderr = stderrSink ?? stderr,
       _argsOverrideForTesting = argsOverrideForTesting;

  /// True between [start] and [stop]/exit.
  bool get isRunning => _process != null;

  /// True once [connectToVmService] resolved the upstream VM service.
  bool get isVmServiceConnected => _vmService != null;

  /// HTTP VM service URI, or `null` before [connectToVmService] resolves.
  String? get vmServiceUri => _vmServiceUri;

  /// Connected `vm_service` client; `null` outside connect..[stop].
  VmService? get vmService => _vmService;

  /// HTTP URL the Flutter app is served at (web targets only).
  String? get flutterAppUrl => _flutterAppUrl;

  /// First of `app.debugPort`, `app.webLaunchUrl`, or process exit.
  /// Decoupled from [connectToVmService]: on `-d web-server` the
  /// daemon withholds `app.debugPort` until a browser attaches.
  Future<void> get launched => _launchedCompleter.future;

  /// Exit code of the `flutter run` subprocess.
  Future<int> get exitCode => _exitCodeCompleter.future;

  /// Throws [FlutterNotInstalledException] when `flutter` isn't on PATH.
  Future<void> start() async {
    if (_process != null) {
      throw StateError('FlutterProcess is already running.');
    }

    final args =
        _argsOverrideForTesting ??
        <String>['run', '--machine', '-d', _device, ..._extraArgs];

    if (_vmServiceInfoFile != null) {
      // A stale info file would mislead IDE attach.
      await File(_vmServiceInfoFile).deleteIfExists();
    }

    final invocation = await _resolveFlutterInvocation(_flutterExecutable);

    Process process;
    try {
      process = await Process.start(
        invocation.executable,
        [...invocation.baseArgs, ...args],
        workingDirectory: _flutterPackageDir,
      );
    } on ProcessException catch (e) {
      throw FlutterNotInstalledException(
        'Failed to launch `${invocation.executable}`: ${e.message}. '
        'Install Flutter (https://flutter.dev) or pass `--no-flutter`.',
        e,
      );
    }
    _process = process;
    _daemon = FlutterDaemonProtocol(process);
    _onProgress?.call(flutterAppLaunching);

    // Forward SIGTERM as SIGINT for graceful shutdown.
    if (!Platform.isWindows) {
      _sigtermSub = ProcessSignal.sigterm.watch().listen(
        (_) => process.kill(ProcessSignal.sigint),
      );
    }

    // `[`-prefixed lines -> machine parser; rest -> _stdout as text.
    final stdoutLines = StreamController<String>();
    const lineSplitter = LineSplitter();
    final lineBuffer = StringBuffer();
    void routeLine(String line) {
      if (line.startsWith('[')) {
        stdoutLines.add(line);
      } else if (line.isNotEmpty) {
        _stdout.writeln(line);
      }
    }

    _stdoutBytesSub = process.stdout.listen(
      (data) {
        lineBuffer.write(utf8.decode(data, allowMalformed: true));
        final bufferStr = lineBuffer.toString();
        final lastNewline = bufferStr.lastIndexOf('\n');
        if (lastNewline == -1) return;
        final ready = bufferStr.substring(0, lastNewline);
        lineBuffer.clear();
        lineBuffer.write(bufferStr.substring(lastNewline + 1));
        lineSplitter.convert(ready).forEach(routeLine);
      },
      onDone: () {
        if (lineBuffer.isNotEmpty) {
          lineSplitter.convert(lineBuffer.toString()).forEach(routeLine);
          lineBuffer.clear();
        }
        stdoutLines.close();
      },
    );
    _machineLinesSub = stdoutLines.stream.listen(handleMachineLine);
    _stderrBytesSub = process.stderr.listen(_stderr.add);

    unawaited(
      process.exitCode.then((code) async {
        if (!_vmServiceUriCompleter.isCompleted) {
          _vmServiceUriCompleter.complete(null);
        }
        if (!_launchedCompleter.isCompleted) {
          _launchedCompleter.complete();
        }
        // Abort before exitCode so request awaiters see the failure.
        _daemon?.abort();
        if (!_exitCodeCompleter.isCompleted) {
          _exitCodeCompleter.complete(code);
        }
        await _cleanup();
      }),
    );
  }

  /// Wait for `app.debugPort`, write the info file, open a `vm_service`
  /// client. Best-effort. On `-d web-server` pends until a browser attaches.
  Future<void> connectToVmService() async {
    if (_vmService != null) return;
    _onProgress?.call('connecting');

    final maybeUri = await _vmServiceUriCompleter.future;
    if (maybeUri == null) return;
    _vmServiceUri = maybeUri;

    if (_vmServiceInfoFile != null) {
      try {
        await File(
          _vmServiceInfoFile,
        ).writeAsString(jsonEncode({'uri': maybeUri}));
      } on FileSystemException catch (e) {
        log.warning('Could not write Flutter VM service info file: $e');
      }
    }

    final wsUri = vmServiceWsUri(maybeUri);
    for (var attempt = 0; attempt < 5; attempt++) {
      try {
        _vmService = await vmServiceConnectUri(wsUri);
        await _subscribeToLogging(_vmService!);
        return;
      } on Exception {
        if (attempt == 4) {
          log.warning('Could not connect to Flutter VM service at $wsUri');
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
    }
  }

  /// `--machine` doesn't forward `dart:developer.log()`; `Logging` does.
  Future<void> _subscribeToLogging(VmService vmService) async {
    try {
      await vmService.streamListen('Logging');
    } on RPCError catch (e) {
      log.debug('Could not subscribe to Flutter Logging stream: $e');
      return;
    }
    const severeLevel = 1000;
    _loggingSub = vmService.onLoggingEvent.listen((event) {
      final record = event.logRecord;
      final message = record?.message?.valueAsString;
      if (message == null || message.isEmpty) return;
      final name = record?.loggerName?.valueAsString ?? '';
      final line = name.isEmpty ? message : '[$name] $message';
      final sink = (record?.level ?? 0) >= severeLevel ? _stderr : _stdout;
      sink.writeln(line);
    });
  }

  /// Hot reload. Daemon-reported success; never throws.
  Future<bool> reload() => _appRestart(fullRestart: false);

  /// Hot restart: full app reinit, state lost.
  Future<bool> restart() => _appRestart(fullRestart: true);

  Future<bool> _appRestart({required bool fullRestart}) async {
    final op = fullRestart ? 'restart' : 'reload';
    final daemon = _daemon;
    final appId = _appId;
    if (daemon == null || appId == null) {
      log.warning('Flutter $op: daemon not running yet.');
      return false;
    }
    const requestTimeout = Duration(seconds: 30);
    try {
      await daemon
          .sendRequest('app.restart', <String, Object?>{
            'appId': appId,
            'fullRestart': fullRestart,
            'pause': false,
            'debounce': true,
          })
          .timeout(requestTimeout);
      return true;
    } on TimeoutException {
      log.warning('Flutter $op timed out after ${requestTimeout.inSeconds}s.');
      return false;
    } on FlutterDaemonException catch (e) {
      log.warning('Flutter $op failed: ${e.error}');
      return false;
    } catch (e) {
      log.warning('Flutter $op: unexpected error: $e');
      return false;
    }
  }

  /// SIGINT -> wait -> SIGKILL. Reaches the daemon because [start]
  /// spawns flutter_tools directly, bypassing wrappers.
  Future<int> stop({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final process = _process;
    if (process == null) {
      log.debug('Flutter stop: no process.');
      return 0;
    }

    await _sigtermSub?.cancel();
    _sigtermSub = null;

    log.debug('Flutter stop: sending SIGINT to PID ${process.pid}');
    process.kill(ProcessSignal.sigint);

    final exitCode = await process.exitCode.timeout(
      timeout,
      onTimeout: () {
        log.warning(
          'Flutter did not stop within ${timeout.inSeconds}s, sending SIGKILL.',
        );
        process.kill(ProcessSignal.sigkill);
        return process.exitCode;
      },
    );
    log.debug('Flutter stop: PID ${process.pid} exited with $exitCode');

    await _cleanup();
    return exitCode;
  }

  /// Parses one `flutter run --machine` line. Machine events are
  /// `[`-prefixed single-line JSON arrays; other lines are ignored.
  @visibleForTesting
  void handleMachineLine(String line) {
    if (!line.startsWith('[')) return;

    final Object? decoded;
    try {
      decoded = jsonDecode(line);
    } on FormatException {
      return;
    }
    if (decoded is! List) return;

    // Protocol allows multiple events per line.
    for (final entry in decoded) {
      if (entry is! Map) continue;

      // Response envelope (`id`, no `event`) -> pending request.
      final envelope = Map<String, Object?>.from(entry);
      if (_daemon?.tryHandleResponse(envelope) ?? false) continue;

      final event = entry['event'];
      if (event is! String) continue;

      final params = entry['params'];
      final paramMap = params is Map ? params : const {};

      log.debug('flutter[--machine] $event ${jsonEncode(paramMap)}');

      switch (event) {
        case 'app.start':
          final appId = paramMap['appId'];
          if (appId is String) _appId = appId;
        case 'app.debugPort':
          final wsUri = paramMap['wsUri'];
          if (wsUri is String && !_vmServiceUriCompleter.isCompleted) {
            // IDEs and callers expect the http form.
            _vmServiceUriCompleter.complete(httpFromWs(wsUri));
          }
          if (!_launchedCompleter.isCompleted) _launchedCompleter.complete();
        case 'app.webLaunchUrl':
          final url = paramMap['url'];
          if (url is String) {
            _flutterAppUrl = url;
            if (!_launchedCompleter.isCompleted) _launchedCompleter.complete();
          }
        case 'app.progress':
          final message = paramMap['message'];
          if (message is String && message.isNotEmpty) {
            _onProgress?.call(message);
          }
        case 'app.started':
          _onProgress?.call('ready');
        case 'app.log':
          final logText = paramMap['log'];
          if (logText is! String || logText.isEmpty) break;
          final sink = paramMap['error'] == true ? _stderr : _stdout;
          sink.writeln(logText);
        case 'daemon.logMessage':
          final message = paramMap['message'];
          if (message is String) log.debug('flutter[daemon] $message');
      }
    }
  }

  Future<void> _cleanup() async {
    // Completer guard: concurrent stop + exit-listener share one pass.
    if (_cleanupCompleter != null) return _cleanupCompleter!.future;
    if (_process == null) return;

    final completer = Completer<void>();
    _cleanupCompleter = completer;

    try {
      _process = null;
      await _stdoutBytesSub?.cancel();
      await _stderrBytesSub?.cancel();
      await _machineLinesSub?.cancel();
      await _sigtermSub?.cancel();
      await _loggingSub?.cancel();
      _stdoutBytesSub = null;
      _stderrBytesSub = null;
      _machineLinesSub = null;
      _sigtermSub = null;
      _loggingSub = null;

      await _vmService?.dispose();
      _vmService = null;

      if (_vmServiceInfoFile != null) {
        await File(_vmServiceInfoFile).deleteIfExists();
      }
    } finally {
      completer.complete();
    }
  }

  static ({String executable, List<String> baseArgs})? _cachedInvocation;

  /// Probe `flutter --version --machine` for `flutterRoot`, then return
  /// `dart <flutterRoot>/.../flutter_tools.dart` so signals bypass
  /// puro/fvm/asdf wrappers and reach the daemon. Falls back to
  /// invoking [flutterExecutable] verbatim if the SDK paths are missing.
  static Future<({String executable, List<String> baseArgs})>
  _resolveFlutterInvocation(String flutterExecutable) async {
    final cached = _cachedInvocation;
    if (cached != null) return cached;

    // Don't cache the fallback: a fake-executable test probe would
    // poison the cache for later real callers.
    final fallback = (executable: flutterExecutable, baseArgs: <String>[]);
    try {
      final result = await Process.run(
        flutterExecutable,
        ['--version', '--machine'],
        runInShell: Platform.isWindows,
      );
      if (result.exitCode != 0) return fallback;
      final decoded = jsonDecode(result.stdout as String);
      if (decoded is! Map || decoded['flutterRoot'] is! String) {
        return fallback;
      }
      final root = decoded['flutterRoot'] as String;
      final dartBin = p.join(
        root,
        'bin',
        'cache',
        'dart-sdk',
        'bin',
        Platform.isWindows ? 'dart.exe' : 'dart',
      );
      final packages = p.join(
        root,
        'packages',
        'flutter_tools',
        '.dart_tool',
        'package_config.json',
      );
      final entry = p.join(
        root,
        'packages',
        'flutter_tools',
        'bin',
        'flutter_tools.dart',
      );
      if (!File(dartBin).existsSync() ||
          !File(packages).existsSync() ||
          !File(entry).existsSync()) {
        return fallback;
      }
      return _cachedInvocation = (
        executable: dartBin,
        baseArgs: ['--disable-dart-dev', '--packages=$packages', entry],
      );
    } catch (_) {
      return fallback;
    }
  }

  /// `ws://host:port/ws` -> `http://host:port` (also wss -> https).
  @visibleForTesting
  static String httpFromWs(String wsUri) {
    final uri = Uri.parse(wsUri);
    final scheme = uri.isScheme('wss') ? 'https' : 'http';
    var path = uri.path;
    if (path.endsWith('/ws')) path = path.substring(0, path.length - 3);
    return uri.replace(scheme: scheme, path: path).toString();
  }
}

/// Default Flutter VM-service info file, sibling of the pod's info file.
String defaultFlutterVmServiceInfoFile(String serverpodToolDir) =>
    p.join(serverpodToolDir, 'flutter-vm-service-info.json');
