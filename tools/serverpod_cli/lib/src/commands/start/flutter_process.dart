import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/server_process.dart'
    show vmServiceWsUri;
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/vendored/flutter_daemon_protocol.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

/// Thrown by [FlutterProcess.start] when the `flutter` binary cannot be
/// launched (typically because Flutter is not installed or not on `PATH`).
/// Callers should catch this and continue without the Flutter integration
/// rather than aborting `serverpod start`.
class FlutterNotInstalledException implements Exception {
  /// Description of why launching `flutter` failed.
  final String message;

  /// The underlying [ProcessException] (or other cause) for debug output.
  final Object? cause;

  FlutterNotInstalledException(this.message, [this.cause]);

  @override
  String toString() => 'FlutterNotInstalledException: $message';
}

/// Manages a `flutter run --machine` subprocess. Mirrors [ServerProcess]
/// in shape and lifecycle. The VM service URI captured from `app.debugPort`
/// is written to [vmServiceInfoFile] for IDE attach; reload/restart are
/// driven over the daemon's stdin via [FlutterDaemonProtocol].
class FlutterProcess {
  final String _flutterPackageDir;
  final String _flutterExecutable;
  final String _device;
  final List<String> _extraArgs;
  final IOSink _stdout;
  final IOSink _stderr;

  /// Path to write the VM service info JSON to once captured. Sibling of
  /// the pod's `vm-service-info.json` so a single `launch.json` directory
  /// reference covers both.
  final String? _vmServiceInfoFile;

  /// Optional callback for surfacing startup-stage progress (e.g. to the
  /// TUI's tracked-operation indicator or a `log.progress` spinner). Fires
  /// with `'launching'` on successful spawn, `'connecting'` before the VM
  /// service connect attempt, `'ready'` after `app.started`, and verbatim
  /// `app.progress` messages from the Flutter daemon in between.
  final void Function(String stage)? _onProgress;

  /// Test-only override of the spawn args. When non-null, replaces the
  /// default `['run', '--machine', '-d', <device>, ...extraArgs]` list.
  /// Lets unit tests target a Dart shim that emits hand-crafted machine
  /// JSON without needing a Flutter SDK on PATH.
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

  /// Connected `vm_service` client, or `null` before
  /// [connectToVmService] resolves and after [stop].
  VmService? get vmService => _vmService;

  /// HTTP URL the Flutter app is served at, or `null` before
  /// `--machine` emitted `app.webLaunchUrl`.
  String? get flutterAppUrl => _flutterAppUrl;

  /// Completes on the first of `app.debugPort`, `app.webLaunchUrl`, or
  /// process exit. The right gate for "Flutter is up enough to surface
  /// to the user"; decoupled from [connectToVmService] because on
  /// `-d web-server` the daemon withholds `app.debugPort` until a
  /// browser attaches.
  Future<void> get launched => _launchedCompleter.future;

  /// Exit code of the `flutter run` subprocess.
  Future<int> get exitCode => _exitCodeCompleter.future;

  /// Spawn `flutter run --machine -d <device>` in [flutterPackageDir].
  ///
  /// Throws [FlutterNotInstalledException] when `flutter` isn't on PATH;
  /// caller should catch and continue without Flutter.
  Future<void> start() async {
    if (_process != null) {
      throw StateError('FlutterProcess is already running.');
    }

    final args =
        _argsOverrideForTesting ??
        <String>['run', '--machine', '-d', _device, ..._extraArgs];

    if (_vmServiceInfoFile != null) {
      // Clear any stale info file from a prior run so consumers (IDE,
      // launch.json) don't pick up a dead URI before this run publishes
      // its own.
      await File(_vmServiceInfoFile).deleteIfExists();
    }

    // Skip every wrapper layer (puro/fvm/asdf shim, the flutter shell
    // script, even the AOT snapshot) and invoke flutter_tools.dart
    // through dart directly. That way our `Process.start` child IS
    // the dart process running flutter_tools - `process.kill` reaches
    // the daemon, and the simple SIGINT -> SIGKILL chain in [stop] is
    // sufficient. Falls back to the unresolved executable name when
    // the direct paths can't be located (e.g. an SDK that hasn't been
    // bootstrapped yet, where `pub get` on flutter_tools hasn't run).
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
    // Spawn succeeded - now signal the caller that startup is under way.
    _onProgress?.call('launching');

    // Forward SIGTERM as SIGINT to the child for graceful shutdown.
    if (!Platform.isWindows) {
      _sigtermSub = ProcessSignal.sigterm.watch().listen(
        (_) => process.kill(ProcessSignal.sigint),
      );
    }

    // Route `[`-prefixed lines to the machine parser; forward everything
    // else (including app.log content re-emitted by the parser) as raw
    // text to _stdout. Keeps the configured sink JSON-noise-free.
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
        // Wake daemon-request awaiters before exitCode so they observe
        // the failure rather than racing on exitCode resolving first.
        _daemon?.abort();
        if (!_exitCodeCompleter.isCompleted) {
          _exitCodeCompleter.complete(code);
        }
        await _cleanup();
      }),
    );
  }

  /// Wait for the VM service URI from `app.debugPort`, write it to
  /// [_vmServiceInfoFile] for IDE attach, then open a `vm_service`
  /// client. Best-effort. On `-d web-server` this pends until a
  /// browser attaches.
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

  /// Hot-reload the Flutter app. Returns `true` on daemon-reported
  /// success; logs and returns `false` otherwise. Never throws.
  Future<bool> reload() => _appRestart(fullRestart: false);

  /// Hot-restart the Flutter app: full app reinit, state lost.
  Future<bool> restart() => _appRestart(fullRestart: true);

  Future<bool> _appRestart({required bool fullRestart}) async {
    final op = fullRestart ? 'restart' : 'reload';
    final daemon = _daemon;
    final appId = _appId;
    if (daemon == null || appId == null) {
      log.warning('Flutter $op: daemon not running yet.');
      return false;
    }
    try {
      await daemon.sendRequest('app.restart', <String, Object?>{
        'appId': appId,
        'fullRestart': fullRestart,
        'pause': false,
        'debounce': true,
      });
      return true;
    } on FlutterDaemonException catch (e) {
      log.warning('Flutter $op failed: ${e.error}');
      return false;
    } catch (e) {
      log.warning('Flutter $op: unexpected error: $e');
      return false;
    }
  }

  /// SIGINT -> wait -> SIGKILL. Works because [start] resolves the
  /// real flutter binary path and spawns it directly (see
  /// [_resolveFlutterBin]) - our child is the flutter_tools dart
  /// process, not a wrapper, so signals reach the daemon.
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

  /// Parses one line of `flutter run --machine` output. Most output is
  /// human-readable; machine events are single-line JSON arrays (the
  /// daemon prefixes them with `[`). Silently ignores non-JSON lines so
  /// stdout noise doesn't break startup.
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

    // The daemon usually emits one event per line, but the protocol
    // allows multiple. Walk the whole array so we don't drop events.
    for (final entry in decoded) {
      if (entry is! Map) continue;

      // Daemon responses come back as envelopes with an `id` and no
      // `event` field. Route them to the matching pending request
      // before falling through to event dispatch.
      final envelope = Map<String, Object?>.from(entry);
      if (_daemon?.tryHandleResponse(envelope) ?? false) continue;

      final event = entry['event'];
      if (event is! String) continue;

      final params = entry['params'];
      final paramMap = params is Map ? params : const {};

      // Trace every machine event at debug level - the daemon's actual
      // event ordering on web is opaque (e.g. `app.webLaunchUrl` fires
      // after the cold compile, not when the dev server binds), and
      // surprises here are easier to diagnose with a timeline than by
      // guessing. Cheap: only enabled at debug log level.
      log.debug('flutter[--machine] $event ${jsonEncode(paramMap)}');

      switch (event) {
        case 'app.start':
          final appId = paramMap['appId'];
          if (appId is String) _appId = appId;
        case 'app.debugPort':
          final wsUri = paramMap['wsUri'];
          if (wsUri is String && !_vmServiceUriCompleter.isCompleted) {
            // `--machine` reports the ws URI; the rest of the code path
            // (and IDEs) expects the http form. Strip `/ws` and swap
            // scheme.
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
    // Mirror ServerProcess._cleanup's completer-guard so concurrent stop
    // calls and the exit-listener share one cleanup pass.
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

  /// Cached after first resolution.
  static ({String executable, List<String> baseArgs})? _cachedInvocation;

  /// Resolve a wrapper-free invocation of flutter_tools: probe
  /// `flutter --version --machine` for `flutterRoot`, then construct
  /// the direct `dart <flutter_tools.dart>` command. This cuts
  /// through every layer (puro/fvm/asdf shim, the flutter shell
  /// script, the AOT snapshot) so our spawned process IS the dart
  /// process running flutter_tools - signals reach it directly.
  ///
  /// Cached after first call. Falls back to invoking
  /// [flutterExecutable] verbatim if any of the direct paths is
  /// missing (e.g. an SDK that hasn't been bootstrapped: the flutter
  /// shell script normally runs `pub get` on flutter_tools the
  /// first time, which is what creates the package_config.json).
  static Future<({String executable, List<String> baseArgs})>
  _resolveFlutterInvocation(String flutterExecutable) async {
    final cached = _cachedInvocation;
    if (cached != null) return cached;

    // Fallback isn't cached: a failed probe in one context (e.g. a
    // test with a fake executable) would otherwise poison the cache
    // for later real callers.
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

  /// Converts a Flutter daemon `ws://host:port/ws` URI to the http form
  /// the rest of the code (and IDEs) expect (`http://host:port`).
  /// Strips a trailing `/ws` path component when present.
  @visibleForTesting
  static String httpFromWs(String wsUri) {
    final uri = Uri.parse(wsUri);
    final scheme = uri.isScheme('wss') ? 'https' : 'http';
    var path = uri.path;
    if (path.endsWith('/ws')) path = path.substring(0, path.length - 3);
    return uri.replace(scheme: scheme, path: path).toString();
  }
}

/// Default path for the Flutter VM service info file (sibling of the
/// pod's `vm-service-info.json`). Mirrored in [ServerProcess]'s docs so
/// a single launch.json directory reference covers both:
///
/// ```jsonc
/// {
///   "type": "dart",
///   "request": "attach",
///   "vmServiceInfoFile": "${workspaceFolder}/.dart_tool/serverpod/flutter-vm-service-info.json"
/// }
/// ```
String defaultFlutterVmServiceInfoFile(String serverpodToolDir) =>
    p.join(serverpodToolDir, 'flutter-vm-service-info.json');
