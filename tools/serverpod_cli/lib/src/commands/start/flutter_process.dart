import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/start/flutter_log_event.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart'
    show vmServiceWsUri;
import 'package:serverpod_cli/src/util/browser_launcher.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/vendored/flutter_daemon_protocol.dart';
import 'package:serverpod_cli/src/vm_proxy/proxy.dart';
import 'package:serverpod_shared/log.dart' show LogLevel;
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

/// Flutter's headless web device; serves the app but never opens a
/// browser, so a VM service attach waits for a human to open the URL.
const flutterDeviceWebServer = 'web-server';

const flutterDeviceWebServerWithBrowser = 'web-server-launch-browser';

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
/// IDE attach flows through [flutterProxy] (which owns the stable
/// vm-service URI and the `flutter-vm-service-info.json` file);
/// reload/restart go via [FlutterDaemonProtocol] over daemon stdin.
class FlutterProcess {
  final String _flutterPackageDir;
  final String _flutterExecutable;
  final String _device;
  final List<String> _extraArgs;
  final IOSink _stdout;
  final IOSink _stderr;
  final void Function(FlutterLogEvent event)? _onLog;

  /// IDE-facing proxy. When non-null, the process binds upstream on
  /// VM-service connect and unbinds on shutdown so the IDE sees a
  /// stable attach point regardless of whether the Flutter app is
  /// currently running.
  final VmServiceProxy? _flutterProxy;

  /// Fires `'launching'` on spawn, `'connecting'` before VM-service
  /// connect, plus verbatim `app.progress` messages in between.
  final void Function(String stage)? _onProgress;

  /// Fires on the daemon's `app.started` event, i.e. the app is fully up
  /// on its device. This is the only launch-complete signal on non-web
  /// devices, which never publish an `app.webLaunchUrl`.
  final void Function()? _onStarted;

  /// When true, open [flutterAppUrl] in the default browser once it is
  /// published by the daemon (`app.webLaunchUrl`).
  final bool _launchBrowser;

  /// Test-only spawn args override; replaces the default `flutter run`
  /// arg list when non-null.
  final List<String>? _argsOverrideForTesting;

  /// Production override for `flutter run --machine` arguments.
  final List<String>? _machineArgsOverride;

  /// Test-only override for [BrowserLauncher.openUrl].
  final Future<bool> Function(Uri url)? _openBrowserForTesting;

  Process? _process;
  StreamSubscription<ProcessSignal>? _sigtermSub;
  StreamSubscription<List<int>>? _stdoutBytesSub;
  StreamSubscription<List<int>>? _stderrBytesSub;
  StreamSubscription<String>? _machineLinesSub;
  StreamSubscription<Event>? _loggingSub;
  StreamSubscription<Event>? _stdoutEventSub;
  StreamSubscription<Event>? _stderrEventSub;
  Timer? _vmServiceHeartbeat;
  Timer? _logCoalesceTimer;
  _PendingFlutterLog? _pendingLog;

  String? _appId;
  FlutterDaemonProtocol? _daemon;
  String? _vmServiceUri;
  String? _flutterAppUrl;
  String? _dtdUri;
  VmService? _vmService;
  bool _browserOpening = false;

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
    VmServiceProxy? flutterProxy,
    void Function(String stage)? onProgress,
    void Function()? onStarted,
    void Function(FlutterLogEvent event)? onLog,
    IOSink? stdoutSink,
    IOSink? stderrSink,
    List<String>? machineArgsOverride,
    @visibleForTesting List<String>? argsOverrideForTesting,
    @visibleForTesting Future<bool> Function(Uri url)? openBrowserForTesting,
  }) : _flutterPackageDir = flutterPackageDir,
       _flutterExecutable = flutterExecutable,
       _device = device,
       _extraArgs = extraArgs,
       _flutterProxy = flutterProxy,
       _onProgress = onProgress,
       _onStarted = onStarted,
       _onLog = onLog,
       _stdout = stdoutSink ?? stdout,
       _stderr = stderrSink ?? stderr,
       _launchBrowser = device == flutterDeviceWebServerWithBrowser,
       _machineArgsOverride = machineArgsOverride,
       _argsOverrideForTesting = argsOverrideForTesting,
       _openBrowserForTesting = openBrowserForTesting;

  /// True between [start] and [stop]/exit.
  bool get isRunning => _process != null;

  /// True once [connectToVmService] resolved the upstream VM service.
  bool get isVmServiceConnected => _vmService != null;

  /// HTTP VM service URI published by the daemon, or `null` before publication.
  String? get vmServiceUri => _vmServiceUri;

  /// Connected `vm_service` client; `null` outside connect..[stop].
  VmService? get vmService => _vmService;

  /// HTTP URL the Flutter app is served at (web targets only).
  String? get flutterAppUrl => _flutterAppUrl;

  /// DTD URI from the daemon's `app.dtd` event.
  String? get dtdUri => _dtdUri;

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

    final device = _launchBrowser ? flutterDeviceWebServer : _device;
    final args =
        _argsOverrideForTesting ??
        _machineArgsOverride ??
        <String>['run', '--machine', '-d', device, ..._extraArgs];

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
        _emitLog(
          FlutterLogEvent(
            time: DateTime.now(),
            level: LogLevel.info,
            message: line,
            source: FlutterLogSource.processStdout,
            levelIsInferred: true,
            timestampIsInferred: true,
            canCoalesce: true,
          ),
        );
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
    final stderrLineBuffer = StringBuffer();
    void routeStderrLine(String line) {
      if (line.isEmpty) return;
      _emitLog(
        FlutterLogEvent(
          time: DateTime.now(),
          level: LogLevel.error,
          message: line,
          source: FlutterLogSource.processStderr,
          levelIsInferred: true,
          timestampIsInferred: true,
          canCoalesce: true,
        ),
      );
    }

    _stderrBytesSub = process.stderr.listen(
      (data) {
        _stderr.add(data);
        stderrLineBuffer.write(utf8.decode(data, allowMalformed: true));
        final bufferStr = stderrLineBuffer.toString();
        final lastNewline = bufferStr.lastIndexOf('\n');
        if (lastNewline == -1) return;
        final ready = bufferStr.substring(0, lastNewline);
        stderrLineBuffer.clear();
        stderrLineBuffer.write(bufferStr.substring(lastNewline + 1));
        lineSplitter.convert(ready).forEach(routeStderrLine);
      },
      onDone: () {
        if (stderrLineBuffer.isNotEmpty) {
          lineSplitter
              .convert(stderrLineBuffer.toString())
              .forEach(routeStderrLine);
          stderrLineBuffer.clear();
        }
      },
    );

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

  /// Connects to the Flutter VM service.
  ///
  /// When set [timeout] caps the wait for the daemon to publish URI.
  ///
  /// Waits for `app.debugPort`, binds [flutterProxy] upstream so IDE
  /// clients can attach, then opens a `vm_service` client.
  Future<void> connectToVmService({Duration? timeout}) async {
    if (_vmService != null) return;
    _onProgress?.call('connecting');

    final String? maybeUri;
    try {
      final pending = _vmServiceUriCompleter.future;
      maybeUri = await (timeout == null ? pending : pending.timeout(timeout));
    } on TimeoutException {
      log.warning(
        'Flutter VM service did not publish within ${timeout!.inSeconds}s; '
        'continuing without an attached VM service. '
        '(Hot reload from the CLI/IDE for the Flutter app will be unavailable.)',
      );
      return;
    }
    if (maybeUri == null) return;

    final wsUri = vmServiceWsUri(maybeUri);
    await _flutterProxy?.setUpstream(Uri.parse(wsUri));

    for (var attempt = 0; attempt < 5; attempt++) {
      try {
        final vm = await vmServiceConnectUri(wsUri);
        _vmService = vm;
        await _subscribeToVmStreams(vm);
        _startVmServiceHeartbeat(vm);
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

  /// Periodic `getVM()` against the [vm].
  ///
  /// Belt-and-suspenders companion to the daemon `app.stop` event
  /// (missing on flutter web).
  void _startVmServiceHeartbeat(VmService vm) {
    _vmServiceHeartbeat?.cancel();
    // Tight loop because DWDS won't tell us when a browser tab
    // detaches (its keep-alive is hardcoded to ~3000 days). 2s
    // interval + 1s timeout lets us notice within ~3s.
    //
    // Both paths need two consecutive bad reads before tearing down
    // (~4s at 2s interval): a hot restart briefly empties the isolate
    // list, and a one-off getVM() failure - blip, GC pause - shouldn't
    // race-kill a live app.
    var emptyReads = 0;
    var failedReads = 0;
    _vmServiceHeartbeat = Timer.periodic(const Duration(seconds: 2), (
      timer,
    ) async {
      if (_vmService != vm) {
        timer.cancel();
        return;
      }
      try {
        final vmInfo = await vm.getVM().timeout(const Duration(seconds: 1));
        // A successful read means the connection is alive; clear failures.
        failedReads = 0;
        if (vmInfo.isolates?.isEmpty ?? true) {
          emptyReads++;
          if (emptyReads >= 2) {
            timer.cancel();
            log.info('Flutter heartbeat: no isolates; tearing down.');
            await _onAppStop();
          }
        } else {
          emptyReads = 0;
        }
      } catch (e) {
        // A failure breaks any empty-isolate streak; keep them consecutive.
        emptyReads = 0;
        failedReads++;
        if (failedReads >= 2) {
          timer.cancel();
          log.info('Flutter heartbeat failed ($e); tearing down.');
          await _onAppStop();
        }
      }
    });
  }

  /// Subscribes to a named [vmService] stream.
  /// - 'Logging' for _dart:developer.log()_,
  /// - 'Stdout' for [stdout] (includes [print])
  /// - 'Stderr' for [stderr]
  Future<void> _subscribeToVmStreams(VmService vmService) async {
    Future<bool> tryListen(String stream) async {
      try {
        await vmService.streamListen(stream);
        return true;
      } on RPCError catch (e) {
        log.warning('Could not subscribe to Flutter $stream stream: $e');
        return false;
      }
    }

    if (await tryListen('Logging')) {
      _loggingSub = vmService.onLoggingEvent.listen((event) {
        final record = event.logRecord;
        final message = _instanceValue(record?.message);
        if (message == null || message.isEmpty) return;
        final name = _instanceValue(record?.loggerName) ?? '';
        final line = name.isEmpty ? message : '[$name] $message';
        final vmLevel = record?.level;
        final hasVmLevel = vmLevel != null && vmLevel >= 0;
        final level = _logLevelFromVmLevel(
          hasVmLevel ? vmLevel : null,
        );
        final sink = switch (level) {
          LogLevel.warning || LogLevel.error || LogLevel.fatal => _stderr,
          _ => _stdout,
        };
        final recordTime = record?.time;
        final hasRecordTime = recordTime != null && recordTime >= 0;
        _emitLog(
          FlutterLogEvent(
            time: hasRecordTime
                ? DateTime.fromMillisecondsSinceEpoch(recordTime)
                : DateTime.now(),
            level: level,
            message: message,
            source: FlutterLogSource.vmLogging,
            loggerName: name.isEmpty ? null : name,
            error: _instanceValue(record?.error),
            stackTrace: _instanceValue(record?.stackTrace),
            metadata: {
              'vmLevel': ?(hasVmLevel ? vmLevel : null),
              'sequenceNumber': ?record?.sequenceNumber,
              'zone': ?_instanceValue(record?.zone),
            },
            levelIsInferred: !hasVmLevel,
            timestampIsInferred: !hasRecordTime,
          ),
        );
        sink.writeln(line);
      });
    }

    if (await tryListen('Stdout')) {
      _stdoutEventSub = vmService.onStdoutEvent.listen(
        (e) => _writeVmStreamEvent(
          _stdout,
          e,
          level: LogLevel.info,
          source: FlutterLogSource.vmStdout,
        ),
      );
    }
    if (await tryListen('Stderr')) {
      _stderrEventSub = vmService.onStderrEvent.listen(
        (e) => _writeVmStreamEvent(
          _stderr,
          e,
          level: LogLevel.error,
          source: FlutterLogSource.vmStderr,
        ),
      );
    }
  }

  /// Decodes a VM service [event] and writes its text to [sink]
  void _writeVmStreamEvent(
    IOSink sink,
    Event event, {
    required LogLevel level,
    required FlutterLogSource source,
  }) {
    final bytes = event.bytes;
    String text;
    if (bytes != null) {
      try {
        text = utf8.decode(base64.decode(bytes), allowMalformed: true);
      } catch (_) {
        return;
      }
    } else {
      // No bytes payload on this VM build
      return;
    }
    if (text.isEmpty) return;
    final message = _withoutTrailingNewline(text);
    if (message.isNotEmpty) {
      _emitLog(
        FlutterLogEvent(
          time: DateTime.now(),
          level: level,
          message: message,
          source: source,
          levelIsInferred: true,
          timestampIsInferred: true,
          canCoalesce: true,
        ),
      );
    }
    sink.write(text);
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

  /// Graceful daemon `app.stop` -> SIGINT -> wait -> SIGKILL. The signals
  /// reach the daemon because [start] spawns flutter_tools directly,
  /// bypassing wrappers.
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

    // Ask the daemon to stop the app first: in --machine mode a bare SIGINT
    // can terminate flutter_tools without device cleanup, leaving e.g. the
    // browser window it spawned open. `app.stop` tears the device session
    // down properly; signals below remain as the fallback.
    final daemon = _daemon;
    final appId = _appId;
    if (daemon != null && appId != null) {
      try {
        await daemon
            .sendRequest('app.stop', <String, Object?>{'appId': appId})
            .timeout(timeout);
        final exitCode = await process.exitCode.timeout(timeout);
        log.debug(
          'Flutter stop: PID ${process.pid} exited gracefully with $exitCode',
        );
        await _cleanup();
        return exitCode;
      } catch (e) {
        log.debug(
          'Flutter stop: app.stop failed ($e); falling back to '
          'signals.',
        );
      }
    }

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
            final httpUri = httpFromWs(wsUri);
            _vmServiceUri = httpUri;
            _vmServiceUriCompleter.complete(httpUri);
          }
          if (!_launchedCompleter.isCompleted) _launchedCompleter.complete();
        case 'app.webLaunchUrl':
          final url = paramMap['url'];
          if (url is String) {
            _flutterAppUrl = url;
            if (!_launchedCompleter.isCompleted) _launchedCompleter.complete();
            if (_launchBrowser) {
              unawaited(_openBrowser(Uri.parse(url)));
            }
          }
        case 'app.dtd':
          final uri = paramMap['uri'];
          if (uri is String && uri.isNotEmpty) {
            _dtdUri = uri;
          }
        case 'app.progress':
          final message = paramMap['message'];
          if (message is String && message.isNotEmpty) {
            _onProgress?.call(message);
          }
        case 'app.started':
          _onStarted?.call();
        case 'app.stop':
          log.debug('Flutter daemon emitted app.stop; tearing down.');
          unawaited(_onAppStop());
        case 'app.log':
          // Native devices report application and platform output here. Keep
          // this alongside the VM streams, which are required for web targets.
          _forwardMachineLog(
            paramMap,
            messageKey: 'log',
            level: paramMap['error'] == true ? LogLevel.error : LogLevel.info,
            source: FlutterLogSource.appLog,
            levelIsInferred: true,
          );
        case 'daemon.logMessage':
          final daemonLevel = paramMap['level'];
          _forwardMachineLog(
            paramMap,
            messageKey: 'message',
            level: _logLevelFromDaemonLevel(daemonLevel),
            source: FlutterLogSource.daemon,
            levelIsInferred: !_isKnownDaemonLevel(daemonLevel),
          );
      }
    }
  }

  void _forwardMachineLog(
    Map<dynamic, dynamic> params, {
    required String messageKey,
    required LogLevel level,
    required FlutterLogSource source,
    bool levelIsInferred = false,
  }) {
    final message = params[messageKey];
    if (message is! String || message.isEmpty) return;

    final stackTrace = params['stackTrace'];
    _emitLog(
      FlutterLogEvent(
        time: DateTime.now(),
        level: level,
        message: message,
        source: source,
        stackTrace: stackTrace is String && stackTrace.isNotEmpty
            ? stackTrace
            : null,
        metadata: source == FlutterLogSource.daemon
            ? {'daemonLevel': params['level']}
            : source == FlutterLogSource.appLog
            ? {'error': params['error'] == true}
            : null,
        levelIsInferred: levelIsInferred,
        timestampIsInferred: true,
      ),
    );

    final sink = switch (level) {
      LogLevel.warning || LogLevel.error || LogLevel.fatal => _stderr,
      _ => _stdout,
    };
    sink.write(message);
    if (!message.endsWith('\n')) sink.writeln();

    if (stackTrace is String && stackTrace.isNotEmpty) {
      sink.write(stackTrace);
      if (!stackTrace.endsWith('\n')) sink.writeln();
    }
  }

  void _emitLog(FlutterLogEvent event) {
    if (_onLog == null) return;

    final canCoalesce =
        event.canCoalesce && event.levelIsInferred && event.timestampIsInferred;
    if (!canCoalesce) {
      _flushPendingLog();
      _dispatchLog(event);
      return;
    }

    final pending = _pendingLog;
    if (pending == null || !pending.canAppend(event)) {
      _flushPendingLog();
      _pendingLog = _PendingFlutterLog(event);
    } else {
      pending.append(event);
    }

    _logCoalesceTimer?.cancel();
    _logCoalesceTimer = Timer(
      const Duration(milliseconds: 50),
      _flushPendingLog,
    );
  }

  void _flushPendingLog() {
    _logCoalesceTimer?.cancel();
    _logCoalesceTimer = null;
    final pending = _pendingLog;
    if (pending == null) return;
    _pendingLog = null;
    _dispatchLog(pending.toEvent());
  }

  void _dispatchLog(FlutterLogEvent event) {
    try {
      _onLog?.call(event);
    } catch (error, stackTrace) {
      log.warning('Flutter log listener failed: $error\n$stackTrace');
    }
  }

  static LogLevel _logLevelFromDaemonLevel(Object? level) {
    return switch (level) {
      'trace' || 'debug' => LogLevel.debug,
      'status' || 'info' => LogLevel.info,
      'warning' || 'warn' => LogLevel.warning,
      'error' => LogLevel.error,
      'fatal' => LogLevel.fatal,
      _ => LogLevel.info,
    };
  }

  static bool _isKnownDaemonLevel(Object? level) {
    return const {
      'trace',
      'debug',
      'status',
      'info',
      'warning',
      'warn',
      'error',
      'fatal',
    }.contains(level);
  }

  static LogLevel _logLevelFromVmLevel(int? level) {
    final value = level ?? 800;
    if (value >= 1200) return LogLevel.fatal;
    if (value >= 1000) return LogLevel.error;
    if (value >= 900) return LogLevel.warning;
    if (value >= 800) return LogLevel.info;
    return LogLevel.debug;
  }

  static String _withoutTrailingNewline(String text) {
    var end = text.length;
    if (end > 0 && text.codeUnitAt(end - 1) == 10) end--;
    if (end > 0 && text.codeUnitAt(end - 1) == 13) end--;
    return text.substring(0, end);
  }

  static String? _instanceValue(InstanceRef? instance) {
    if (instance == null || instance.kind == InstanceKind.kNull) return null;
    return instance.valueAsString;
  }

  Future<void> _openBrowser(Uri url) async {
    if (_browserOpening) return;
    _browserOpening = true;
    final open = _openBrowserForTesting ?? BrowserLauncher.openUrl;
    if (!await open(url)) {
      log.warning('Could not open browser at $url');
    }

    // Reset the flag so we can open the browser again if the app is restarted.
    _browserOpening = false;
  }

  bool _appStopHandled = false;
  Future<void> _onAppStop() async {
    if (_appStopHandled) return;
    _appStopHandled = true;
    log.debug('Flutter teardown begin.');
    await _flutterProxy?.setUpstream(null);
    final process = _process;
    if (process == null) return;
    process.kill(ProcessSignal.sigint);
    await process.exitCode.timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        log.debug('Flutter did not exit on SIGINT; sending SIGKILL.');
        process.kill(ProcessSignal.sigkill);
        return process.exitCode;
      },
    );
    log.debug('Flutter teardown end.');
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
      await _stdoutEventSub?.cancel();
      await _stderrEventSub?.cancel();
      _flushPendingLog();
      _vmServiceHeartbeat?.cancel();
      _stdoutBytesSub = null;
      _stderrBytesSub = null;
      _machineLinesSub = null;
      _sigtermSub = null;
      _loggingSub = null;
      _stdoutEventSub = null;
      _stderrEventSub = null;
      _vmServiceHeartbeat = null;

      await _vmService?.dispose();
      _vmService = null;
      _vmServiceUri = null;
      _dtdUri = null;

      await _flutterProxy?.setUpstream(null);
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

class _PendingFlutterLog {
  _PendingFlutterLog(this.first)
    : _message = StringBuffer(first.message),
      _lineCount = _countLines(first.message);

  static const maxLines = 100;
  static const maxCharacters = 64 * 1024;

  final FlutterLogEvent first;
  final StringBuffer _message;
  int _lineCount;

  bool canAppend(FlutterLogEvent event) {
    if (event.source != first.source || event.level != first.level) {
      return false;
    }
    final additionalLines = _countLines(event.message);
    return _lineCount + additionalLines <= maxLines &&
        _message.length + event.message.length + 1 <= maxCharacters;
  }

  void append(FlutterLogEvent event) {
    if (_message.isNotEmpty) _message.writeln();
    _message.write(event.message);
    _lineCount += _countLines(event.message);
  }

  FlutterLogEvent toEvent() {
    return FlutterLogEvent(
      time: first.time,
      level: first.level,
      message: _message.toString(),
      source: first.source,
      loggerName: first.loggerName,
      error: first.error,
      stackTrace: first.stackTrace,
      metadata: {
        ...?first.metadata,
        'coalesced': _lineCount > _countLines(first.message),
        'lineCount': _lineCount,
      },
      levelIsInferred: first.levelIsInferred,
      timestampIsInferred: first.timestampIsInferred,
    );
  }

  static int _countLines(String message) => '\n'.allMatches(message).length + 1;
}
