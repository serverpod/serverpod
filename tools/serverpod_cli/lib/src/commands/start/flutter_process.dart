import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/server_process.dart'
    show vmServiceWsUri;
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
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

/// Manages a `flutter run --machine` subprocess.
///
/// Mirrors [ServerProcess] in shape and lifecycle. The VM service URI is
/// captured from `--machine`'s `app.debugPort` event (Flutter has no
/// `--write-service-info` flag), and reload is driven through the VM
/// service rather than stdin keystrokes - giving a real `Future<bool>`
/// with success/failure semantics. The captured URI is also written to a
/// file at [vmServiceInfoFile], allowing IDEs to auto-attach via the
/// `vmServiceInfoFile` field in their launch configuration.
///
/// v2 follow-up: a `pubspec.yaml` / asset change watcher can call
/// `stop()` + `start()` on this class to compose a full process respawn
/// (level 3 - pubspec / asset bundle changes need a full re-spawn, not
/// just a hot restart, because the package_config and asset manifest are
/// read at VM start). The level-2 hot-restart (main isolate only) is
/// intentionally not exposed here; that lands in a separate change.
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

  VmService? _vmService;
  String? _flutterIsolateId;

  /// Service-method prefix used by Flutter to register `hotReload` /
  /// `hotRestart` on the VM service (e.g. `s0`). Discovered at connect
  /// time via [VmService.getSupportedProtocols] / probing; `null` when
  /// the optimized path isn't available and we fall back to
  /// `reloadSources` + `ext.flutter.reassemble`.
  String? _flutterServicePrefix;

  String? _vmServiceUri;
  String? _flutterAppUrl;

  // Completes with the http VM service URI once `app.debugPort` arrives,
  // or with `null` if the process exits first. Using a nullable result
  // (rather than completing with an error) keeps the future safely
  // awaitable even when nothing called connectToVmService().
  final Completer<String?> _vmServiceUriCompleter = Completer<String?>();
  final Completer<int> _exitCodeCompleter = Completer<int>();
  final Completer<void> _vmServiceReady = Completer<void>();

  // Completes on the first of `app.debugPort` (mobile/desktop, and
  // `-d chrome` on web) or `app.webLaunchUrl` (web devices). Also
  // completes when the process exits, so awaiters wake up on failure
  // - check [isRunning] / [flutterAppUrl] / [vmServiceUri] to see
  // which signal fired. See [launched].
  final Completer<void> _launchedCompleter = Completer<void>();

  Completer<void>? _cleanupCompleter;

  FlutterProcess({
    required String flutterPackageDir,
    String flutterExecutable = 'flutter',
    String device = 'web-server',
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

  /// HTTP URL the Flutter app is served at (e.g.
  /// `http://localhost:54321`), or `null` before `--machine` emitted
  /// `app.webLaunchUrl`.
  String? get flutterAppUrl => _flutterAppUrl;

  /// Completes once the VM service is connected and the Flutter isolate
  /// id is known. Never completes if startup fails - pair with [exitCode]
  /// to detect crashes.
  Future<void> get vmServiceReady => _vmServiceReady.future;

  /// Completes when Flutter has reported a usable state - the first of
  /// `app.debugPort` (mobile/desktop, `-d chrome`) or `app.webLaunchUrl`
  /// (web devices) - OR when the process exits.
  ///
  /// This is the right gate for "Flutter is up enough to surface to the
  /// user." It is intentionally decoupled from [connectToVmService] /
  /// [vmServiceReady]: on `-d web-server` the Flutter daemon withholds
  /// `app.debugPort` until a browser actually attaches to the served
  /// URL, so blocking on the VM service URI hides the web URL from the
  /// user - they'd have nothing to open. Wait on [launched] to log /
  /// surface the URL, then kick [connectToVmService] off in the
  /// background.
  ///
  /// After this resolves, check [isRunning] (false if the process
  /// exited before launch) and [flutterAppUrl] / [vmServiceUri] to see
  /// which signal fired.
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

    Process process;
    try {
      // `flutter` on Windows is a batch file; Process.start handles `.bat`
      // resolution when invoking through the shell. Direct invocation
      // works on POSIX and is the cheaper path. Caveat: with
      // `runInShell: true`, `Process.kill(SIGINT)` targets the cmd.exe
      // wrapper rather than the wrapped daemon - the 5s SIGKILL fallback
      // in `stop()` covers the case where SIGINT doesn't propagate.
      process = await Process.start(
        _flutterExecutable,
        args,
        workingDirectory: _flutterPackageDir,
      );
    } on ProcessException catch (e) {
      throw FlutterNotInstalledException(
        'Failed to launch `$_flutterExecutable`: ${e.message}. '
        'Install Flutter (https://flutter.dev) or pass `--no-flutter`.',
        e,
      );
    }
    _process = process;
    // Spawn succeeded - now signal the caller that startup is under way.
    _onProgress?.call('launching');

    // Forward SIGTERM as SIGINT to the child for graceful shutdown.
    if (!Platform.isWindows) {
      _sigtermSub = ProcessSignal.sigterm.watch().listen(
        (_) => process.kill(ProcessSignal.sigint),
      );
    }

    // process.stdout is single-subscription, so fan out from one listen:
    // forward raw bytes to the configured sink (TUI Flutter tab keeps
    // full output) AND feed line-wise UTF-8 through the --machine JSON
    // parser.
    final stdoutLines = StreamController<String>();
    const lineSplitter = LineSplitter();
    final lineBuffer = StringBuffer();
    _stdoutBytesSub = process.stdout.listen(
      (data) {
        _stdout.add(data);
        lineBuffer.write(utf8.decode(data, allowMalformed: true));
        // Drain only complete lines; keep the tail in the buffer.
        final bufferStr = lineBuffer.toString();
        final lastNewline = bufferStr.lastIndexOf('\n');
        if (lastNewline == -1) return;
        final ready = bufferStr.substring(0, lastNewline);
        lineBuffer.clear();
        lineBuffer.write(bufferStr.substring(lastNewline + 1));
        for (final line in lineSplitter.convert(ready)) {
          stdoutLines.add(line);
        }
      },
      onDone: () {
        if (lineBuffer.isNotEmpty) {
          for (final line in lineSplitter.convert(lineBuffer.toString())) {
            stdoutLines.add(line);
          }
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
        if (!_exitCodeCompleter.isCompleted) {
          _exitCodeCompleter.complete(code);
        }
        await _cleanup();
      }),
    );
  }

  /// Wait for the `--machine` stream to publish the VM service URI, then
  /// open a `vm_service` connection. Resolves the Flutter isolate id and
  /// probes the `sN.hotReload` optimization. Best-effort - logs warnings
  /// when the connection itself fails; silent when the URI never arrives
  /// (the process exits and the completer resolves to `null`).
  ///
  /// Returns immediately if already connected, so multiple background
  /// callers don't race each other.
  ///
  /// Waits indefinitely for the URI. On `-d web-server` this may pend
  /// until a browser connects, which is exactly the right behavior -
  /// hot reload becomes available the moment DWDS reports a URI, even
  /// if that's minutes after spawn. Run this unawaited from the caller
  /// so launch progress isn't gated on it.
  Future<void> connectToVmService() async {
    if (_vmService != null) return;
    _onProgress?.call('connecting');

    final maybeUri = await _vmServiceUriCompleter.future;
    if (maybeUri == null) {
      // Process exited before publishing - silent return, the exit
      // listener has already wound things down.
      return;
    }
    final httpUri = maybeUri;
    _vmServiceUri = httpUri;

    if (_vmServiceInfoFile != null) {
      try {
        await File(
          _vmServiceInfoFile,
        ).writeAsString(jsonEncode({'uri': httpUri}));
      } on FileSystemException catch (e) {
        log.warning('Could not write Flutter VM service info file: $e');
      }
    }

    final wsUri = vmServiceWsUri(httpUri);
    const maxRetries = 5;
    for (var attempt = 0; attempt < maxRetries; attempt++) {
      try {
        _vmService = await vmServiceConnectUri(wsUri);
        break;
      } on Exception {
        if (attempt == maxRetries - 1) {
          log.warning('Could not connect to Flutter VM service at $wsUri');
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
    }

    final vmService = _vmService;
    if (vmService == null) return;

    try {
      final vm = await vmService.getVM();
      final isolates = vm.isolates ?? const [];
      if (isolates.isEmpty) {
        log.warning('Flutter VM has no isolates yet; reload will be limited.');
        return;
      }
      _flutterIsolateId = isolates.first.id;
      _flutterServicePrefix = await _probeFlutterServicePrefix(vmService);
    } on RPCError catch (e) {
      log.warning('Flutter VM service initialization error: $e');
      return;
    }

    if (!_vmServiceReady.isCompleted) _vmServiceReady.complete();
  }

  /// Hot-reload the Flutter app via the VM service.
  ///
  /// Prefers `<prefix>.hotReload` (single round-trip, matches what the
  /// `flutter` CLI itself does) and falls back to `reloadSources` +
  /// `ext.flutter.reassemble` when that prefix isn't registered.
  /// Returns `true` on framework-reported success, `false` otherwise.
  /// Never throws - a disposed connection or any RPC error becomes
  /// `false` so the caller's chain isn't broken by Flutter-side issues.
  Future<bool> reload() async {
    final vmService = _vmService;
    final isolateId = _flutterIsolateId;
    if (vmService == null || isolateId == null) return false;

    try {
      final prefix = _flutterServicePrefix;
      if (prefix != null) {
        final res = await vmService.callMethod(
          '$prefix.hotReload',
          args: {'isolateId': isolateId, 'pause': false},
        );
        // Flutter daemon returns `{ "type": "Success" }` on success.
        return res.json?['type'] == 'Success';
      }
      return await _fallbackReload(vmService, isolateId);
    } on RPCError {
      // If the optimized path is no longer registered, try once via
      // fallback before giving up.
      try {
        return await _fallbackReload(vmService, isolateId);
      } on Exception {
        return false;
      }
    } on Exception {
      return false;
    }
  }

  Future<bool> _fallbackReload(VmService vmService, String isolateId) async {
    final report = await vmService.reloadSources(isolateId);
    if (report.success != true) return false;
    await vmService.callServiceExtension(
      'ext.flutter.reassemble',
      isolateId: isolateId,
    );
    return true;
  }

  /// Smart shutdown: SIGINT -> wait -> SIGKILL (mirrors ServerProcess).
  /// Idempotent; safe to call from multiple paths (signal handler, exit
  /// listener, watch-session dispose).
  Future<int> stop({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final process = _process;
    if (process == null) return 0;

    await _sigtermSub?.cancel();
    _sigtermSub = null;

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
      final event = entry['event'];
      if (event is! String) continue;

      final params = entry['params'];
      final paramMap = params is Map ? params : const {};

      switch (event) {
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
      }
    }
  }

  /// Probes the Flutter daemon's registered service prefix for
  /// `hotReload` by calling [VmService.getSupportedProtocols] and
  /// scanning the response. Returns the prefix (typically `s0`) when
  /// found, `null` otherwise.
  Future<String?> _probeFlutterServicePrefix(VmService vmService) async {
    try {
      final protocols = await vmService.getSupportedProtocols();
      final entries = protocols.protocols ?? const <Protocol>[];
      for (final protocol in entries) {
        final name = protocol.protocolName;
        // Flutter registers a domain like "DDS" plus per-view domains
        // such as "s0" or "s1". The hot-reload method lives under the
        // view domain; we pick the first non-DDS/non-VM protocol.
        if (name != null &&
            name != 'VM Service' &&
            name != 'DDS' &&
            RegExp(r'^s\d+$').hasMatch(name)) {
          return name;
        }
      }
    } on RPCError {
      // Older Flutter or non-standard daemons: fall back gracefully.
    } on Exception {
      // Network blip during probe - caller will fall back to
      // reloadSources + reassemble on the actual reload attempt.
    }
    return null;
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
      await _vmService?.dispose();
      _vmService = null;
      _flutterIsolateId = null;
      await _stdoutBytesSub?.cancel();
      await _stderrBytesSub?.cancel();
      await _machineLinesSub?.cancel();
      await _sigtermSub?.cancel();
      _stdoutBytesSub = null;
      _stderrBytesSub = null;
      _machineLinesSub = null;
      _sigtermSub = null;

      if (_vmServiceInfoFile != null) {
        await File(_vmServiceInfoFile).deleteIfExists();
      }
    } finally {
      completer.complete();
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
