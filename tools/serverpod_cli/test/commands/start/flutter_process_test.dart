import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/start/flutter_log_event.dart';
import 'package:serverpod_cli/src/commands/start/flutter_process.dart';
import 'package:serverpod_cli/src/vm_proxy/proxy.dart';
import 'package:serverpod_shared/log.dart' show LogLevel;
import 'package:test/test.dart';

/// Path of a Dart shim under `test/commands/start/flutter_shims/`.
String _shimPath(String name) => p.join(
  Directory.current.path,
  'test',
  'commands',
  'start',
  'flutter_shims',
  name,
);

String _dartExecutable() {
  return Platform.resolvedExecutable;
}

/// Minimal WebSocket server that accepts a connect and ignores any RPC.
/// Enough to populate `vmServiceUri`; do not use for getVM-style calls.
Future<({HttpServer server, String wsUri})> _startFakeVmService() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.transform(WebSocketTransformer()).listen((socket) async {
    socket.listen(
      (data) {},
      onDone: () => socket.close(),
    );
  });
  return (
    server: server,
    wsUri: 'ws://127.0.0.1:${server.port}/ws',
  );
}

Future<({HttpServer server, String wsUri})> _startFakeLoggingVmService({
  int? loggingLevel = 800,
  List<List<int>> stdoutChunks = const [],
  Duration stdoutChunkInterval = Duration.zero,
}) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.transform(WebSocketTransformer()).listen((socket) {
    socket.listen((data) {
      if (data is! String) return;
      final request = jsonDecode(data);
      if (request is! Map<String, dynamic>) return;

      final id = request['id'];
      if (id == null) return;
      socket.add(
        jsonEncode({
          'jsonrpc': '2.0',
          'id': id,
          'result': {'type': 'Success'},
        }),
      );

      final params = request['params'];
      if (request['method'] != 'streamListen' ||
          params is! Map<String, dynamic>) {
        return;
      }

      final streamId = params['streamId'];
      Timer(const Duration(milliseconds: 20), () async {
        if (socket.readyState != WebSocket.open) return;
        if (streamId == 'Logging' && loggingLevel != null) {
          socket.add(
            jsonEncode({
              'jsonrpc': '2.0',
              'method': 'streamNotify',
              'params': {
                'streamId': 'Logging',
                'event': {
                  'type': 'Event',
                  'kind': 'Logging',
                  'timestamp': 1783997898247,
                  'logRecord': {
                    'type': 'LogRecord',
                    'message': {
                      'type': '@Instance',
                      'kind': 'String',
                      'valueAsString': 'Using WidgetsApp configuration',
                    },
                    'time': 1783997898247,
                    'level': loggingLevel,
                    'sequenceNumber': 1,
                    'loggerName': {
                      'type': '@Instance',
                      'kind': 'String',
                      'valueAsString': 'GoRouter',
                    },
                    'zone': {
                      'type': '@Instance',
                      'kind': 'Null',
                      'valueAsString': 'null',
                    },
                    'error': {
                      'type': '@Instance',
                      'kind': 'Null',
                      'valueAsString': 'null',
                    },
                    'stackTrace': {
                      'type': '@Instance',
                      'kind': 'Null',
                      'valueAsString': 'null',
                    },
                  },
                },
              },
            }),
          );
        } else if (streamId == 'Stdout') {
          for (var index = 0; index < stdoutChunks.length; index++) {
            final chunk = stdoutChunks[index];
            socket.add(
              jsonEncode({
                'jsonrpc': '2.0',
                'method': 'streamNotify',
                'params': {
                  'streamId': 'Stdout',
                  'event': {
                    'type': 'Event',
                    'kind': 'WriteEvent',
                    'bytes': base64Encode(chunk),
                  },
                },
              }),
            );
            if (index < stdoutChunks.length - 1 &&
                stdoutChunkInterval > Duration.zero) {
              await Future<void>.delayed(stdoutChunkInterval);
            }
          }
        }
      });
    }, onDone: socket.close);
  });
  return (
    server: server,
    wsUri: 'ws://127.0.0.1:${server.port}/ws',
  );
}

void main() {
  group('Given a FlutterProcess missing the executable', () {
    late FlutterProcess fp;

    setUp(() {
      fp = FlutterProcess(
        flutterPackageDir: Directory.systemTemp.path,
        device: 'web-server',
        flutterExecutable: '/definitely/not/a/real/binary',
      );
    });

    test(
      'when calling start '
      'then FlutterNotInstalledException is thrown so the caller can keep going',
      () async {
        await expectLater(
          fp.start,
          throwsA(isA<FlutterNotInstalledException>()),
        );
      },
    );
  });

  group('Given a FlutterProcess running', () {
    late FlutterProcess fp;

    setUp(() async {
      // Long-running shim so the first process is still alive when
      // the second start is attempted.
      fp = FlutterProcess(
        flutterPackageDir: Directory.current.path,
        device: 'web-server',
        flutterExecutable: _dartExecutable(),
        argsOverrideForTesting: [_shimPath('never_publishes_uri.dart')],
      );

      await fp.start();
    });

    tearDown(() async {
      await fp.stop();
    });

    test(
      'when calling start again while still running '
      'then it throws StateError instead of spawning a duplicate process',
      () async {
        expect(fp.start, throwsStateError);
      },
    );

    group(
      'Given a running FlutterProcess with a shim that never publishes app.debugPort or app.webLaunchUrl',
      () {
        late FlutterProcess fp;

        setUp(() async {
          fp = FlutterProcess(
            flutterPackageDir: Directory.current.path,
            device: 'web-server',
            flutterExecutable: _dartExecutable(),
            argsOverrideForTesting: [_shimPath('never_publishes_uri.dart')],
          );

          await fp.start();
        });

        tearDown(() async {
          await fp.stop();
        });

        test(
          'when awaiting launched and connectToVmService '
          'then both are only resolved after the process is stopped (matches "no reload available" semantics)',
          () async {
            var launchedResolved = false;
            var connectResolved = false;
            unawaited(
              fp.launched.then((_) => launchedResolved = true),
            );
            unawaited(
              fp.connectToVmService().then((_) => connectResolved = true),
            );

            await Future<void>.delayed(const Duration(milliseconds: 200));
            expect(launchedResolved, isFalse);
            expect(connectResolved, isFalse);

            // Stop resolves both completers; the futures unblock.
            await fp.stop(timeout: const Duration(seconds: 1));
            await fp.launched.timeout(const Duration(seconds: 2));

            expect(fp.vmServiceUri, isNull);
            expect(fp.isVmServiceConnected, isFalse);
          },
        );

        test(
          'when connectToVmService is called with a short timeout '
          'then it gives up without throwing so the caller can proceed',
          () async {
            // Mirrors the chrome-tab-closed-quickly bug:
            // https://github.com/serverpod/serverpod/issues/5173
            // app.debugPort "never" arrives
            await fp
                .connectToVmService(
                  timeout: const Duration(milliseconds: 200),
                )
                .timeout(const Duration(seconds: 2));
            expect(fp.isVmServiceConnected, isFalse);
            expect(fp.vmServiceUri, isNull);
          },
        );
      },
    );
  });

  group(
    'Given a running FlutterProcess parsing machine protocol from a shim',
    () {
      late FlutterProcess fp;
      late ({HttpServer server, String wsUri}) fake;
      late List<String> progressMessages;
      late Completer<void> started;

      setUp(() async {
        fake = await _startFakeVmService();
        progressMessages = <String>[];
        started = Completer<void>();

        fp = FlutterProcess(
          flutterPackageDir: Directory.current.path,
          device: 'web-server',
          flutterExecutable: _dartExecutable(),
          argsOverrideForTesting: [
            _shimPath('emits_machine_events.dart'),
            '--ws=${fake.wsUri}',
            '--web-url=http://localhost:54321',
          ],
          onProgress: progressMessages.add,
          onStarted: () {
            if (!started.isCompleted) started.complete();
          },
        );

        await fp.start();

        // We only need vmServiceUri set; the fake never replies.
        unawaited(fp.connectToVmService());
      });

      tearDown(() async {
        await fp.stop();
        await fake.server.close(force: true);
      });

      test(
        'when the shim emits app.progress, app.webLaunchUrl, app.debugPort, app.dtd, app.started '
        'then onProgress and onStarted fire, flutterAppUrl is captured, dtdUri is captured, and vmServiceUri is the http form of the daemon\'s wsUri',
        () async {
          await started.future.timeout(const Duration(seconds: 20));

          expect(
            fp.vmServiceUri,
            equals('http://127.0.0.1:${fake.server.port}'),
          );
          expect(fp.flutterAppUrl, equals('http://localhost:54321'));
          expect(fp.dtdUri, equals('ws://127.0.0.1:9100/ws'));
          expect(progressMessages, contains(flutterAppLaunching));
          expect(progressMessages, contains('Launching ...'));

          await fp.stop(timeout: const Duration(seconds: 1));
        },
        timeout: const Timeout(Duration(seconds: 30)),
      );
    },
  );

  group('Given a FlutterProcess that was never started', () {
    late FlutterProcess fp;

    setUp(() {
      fp = FlutterProcess(
        flutterPackageDir: Directory.systemTemp.path,
        device: 'web-server',
      );
    });

    test(
      'when reload is called then it returns false without throwing',
      () async {
        expect(await fp.reload(), isFalse);
      },
    );

    test(
      'when stop is called then it completes',
      () async {
        expect(await fp.stop(), 0);
      },
    );

    test(
      'when stop is called multiple times then it completes idempotently',
      () async {
        expect(await fp.stop(), 0);
        expect(await fp.stop(), 0);
      },
    );
  });

  group('Given a FlutterProcess wired to a VmServiceProxy', () {
    late FlutterProcess fp;
    late ({HttpServer server, String wsUri}) fake;
    late VmServiceProxy proxy;

    setUp(() async {
      fake = await _startFakeVmService();
      proxy = VmServiceProxy(
        upstreamWs: null,
        waitingClientTimeout: const Duration(seconds: 10),
      );
      await proxy.bind();
      fp = FlutterProcess(
        flutterPackageDir: Directory.current.path,
        device: 'web-server',
        flutterExecutable: _dartExecutable(),
        argsOverrideForTesting: [
          _shimPath('emits_machine_events.dart'),
          '--ws=${fake.wsUri}',
        ],
        flutterProxy: proxy,
      );

      await fp.start();
      unawaited(fp.connectToVmService());
    });

    tearDown(() async {
      await fp.stop();
      await proxy.close();
      await fake.server.close(force: true);
    });

    test(
      'when the shim publishes a URI '
      'then the proxy upstream becomes the WS form of that URI, '
      'and is cleared on stop',
      () async {
        // Poll until the proxy observes the upstream bind.
        final deadline = DateTime.now().add(const Duration(seconds: 5));
        while (proxy.upstreamWs == null && DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
        }

        expect(
          proxy.upstreamWs?.toString(),
          equals(fake.wsUri),
        );

        await fp.stop(timeout: const Duration(seconds: 1));

        // Cleanup runs async via the exit listener.
        final clearDeadline = DateTime.now().add(const Duration(seconds: 2));
        while (proxy.upstreamWs != null &&
            DateTime.now().isBefore(clearDeadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
        }
        expect(proxy.upstreamWs, isNull);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });

  test(
    'Given a ws URI ending in /ws'
    'when getting the http URI '
    'then the scheme swaps to http and the /ws suffix is stripped',
    () {
      expect(
        FlutterProcess.httpFromWs('ws://127.0.0.1:54321/ws'),
        'http://127.0.0.1:54321',
      );
    },
  );

  test('Given a wss URI'
      'when getting the http URI '
      'then the scheme swaps to https', () {
    // Uri.toString() strips the port when it matches the scheme default.
    expect(
      FlutterProcess.httpFromWs('wss://example.com:9443/ws'),
      'https://example.com:9443',
    );
  });

  test('Given a ws URI with a path other than /ws'
      'when getting the http URI '
      'then the path is left alone', () {
    expect(
      FlutterProcess.httpFromWs('ws://127.0.0.1:54321/different'),
      'http://127.0.0.1:54321/different',
    );
  });

  group('Given a FlutterProcess receiving machine protocol lines', () {
    late FlutterProcess fp;
    late List<String> progressMessages;
    late StringBuffer stdoutBuffer;
    late StringBuffer stderrBuffer;
    late StreamController<List<int>> stdoutController;
    late StreamController<List<int>> stderrController;
    late IOSink stdoutSink;
    late IOSink stderrSink;
    late List<FlutterLogEvent> logEvents;

    setUp(() async {
      progressMessages = <String>[];
      stdoutBuffer = StringBuffer();
      stderrBuffer = StringBuffer();
      stdoutController = StreamController<List<int>>();
      stderrController = StreamController<List<int>>();
      stdoutController.stream
          .transform(utf8.decoder)
          .listen(stdoutBuffer.write);
      stderrController.stream
          .transform(utf8.decoder)
          .listen(stderrBuffer.write);
      stdoutSink = IOSink(stdoutController.sink);
      stderrSink = IOSink(stderrController.sink);
      logEvents = [];

      /// FlutterProcess wired only enough to push synthetic lines through
      /// `handleMachineLine` and assert side effects.
      fp = FlutterProcess(
        flutterPackageDir: Directory.systemTemp.path,
        device: 'web-server',
        onProgress: progressMessages.add,
        stdoutSink: stdoutSink,
        stderrSink: stderrSink,
        onLog: logEvents.add,
      );
    });

    tearDown(() async {
      await stdoutSink.close();
      await stderrSink.close();
    });

    test(
      'when a Flutter application log event contains a framework exception, '
      'then the complete exception is forwarded to stdout.',
      () async {
        const exception = '''
══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞══
Multiple widgets used the same GlobalKey.
The key [GlobalKey#1d408] was used by multiple widgets.''';

        fp.handleMachineLine(
          jsonEncode([
            {
              'event': 'app.log',
              'params': {'log': exception, 'error': false},
            },
          ]),
        );
        await stdoutSink.flush();
        await Future<void>.delayed(Duration.zero);

        expect(stdoutBuffer.toString(), '$exception\n');
        expect(stderrBuffer.toString(), isEmpty);
        expect(logEvents, hasLength(1));
        expect(logEvents.single.level, LogLevel.info);
        expect(logEvents.single.source, FlutterLogSource.appLog);
        expect(logEvents.single.message, exception);
        expect(logEvents.single.levelIsInferred, isTrue);
      },
    );

    test(
      'when a Flutter application log event is marked as an error, '
      'then the complete log is forwarded to stderr.',
      () async {
        const warning =
            '** (serverpod_app:564071): WARNING **: '
            'Timed out waiting for OpenGL frame';

        fp.handleMachineLine(
          jsonEncode([
            {
              'event': 'app.log',
              'params': {'log': warning, 'error': true},
            },
          ]),
        );
        await stderrSink.flush();
        await Future<void>.delayed(Duration.zero);

        expect(stderrBuffer.toString(), '$warning\n');
        expect(stdoutBuffer.toString(), isEmpty);
        expect(logEvents.single.level, LogLevel.error);
        expect(logEvents.single.source, FlutterLogSource.appLog);
        expect(logEvents.single.levelIsInferred, isTrue);
      },
    );

    test(
      'when a Flutter tool warning contains a stack trace, '
      'then the message and stack trace are forwarded to stderr.',
      () async {
        fp.handleMachineLine(
          jsonEncode([
            {
              'event': 'daemon.logMessage',
              'params': {
                'level': 'warning',
                'message': 'Flutter tool warning',
                'stackTrace': 'first frame\nsecond frame\n',
              },
            },
          ]),
        );
        await stderrSink.flush();
        await Future<void>.delayed(Duration.zero);

        expect(
          stderrBuffer.toString(),
          'Flutter tool warning\nfirst frame\nsecond frame\n',
        );
        expect(stdoutBuffer.toString(), isEmpty);
        expect(logEvents.single.level, LogLevel.warning);
        expect(logEvents.single.source, FlutterLogSource.daemon);
        expect(logEvents.single.stackTrace, 'first frame\nsecond frame\n');
        expect(logEvents.single.levelIsInferred, isFalse);
      },
    );

    test(
      'when a Flutter tool status message is received, '
      'then the message is forwarded to stdout.',
      () async {
        fp.handleMachineLine(
          jsonEncode([
            {
              'event': 'daemon.logMessage',
              'params': {
                'level': 'status',
                'message': 'Building Linux application...',
              },
            },
          ]),
        );
        await stdoutSink.flush();
        await Future<void>.delayed(Duration.zero);

        expect(stdoutBuffer.toString(), 'Building Linux application...\n');
        expect(stderrBuffer.toString(), isEmpty);
        expect(logEvents.single.level, LogLevel.info);
        expect(logEvents.single.source, FlutterLogSource.daemon);
        expect(logEvents.single.levelIsInferred, isFalse);
      },
    );

    test(
      'when given a line that does not start with [ '
      'then the line is ignored',
      () {
        fp.handleMachineLine('just some text');
        fp.handleMachineLine('');
        expect(fp.vmServiceUri, isNull);
        expect(fp.flutterAppUrl, isNull);
      },
    );

    test(
      'when given a [-prefixed line containing malformed JSON '
      'then the line is ignored',
      () {
        fp.handleMachineLine('[not-json');
        expect(fp.vmServiceUri, isNull);
      },
    );

    test(
      'when given an envelope missing the event field '
      'then the envelope is ignored',
      () {
        fp.handleMachineLine(
          jsonEncode([
            {'noevent': true},
          ]),
        );
        expect(fp.vmServiceUri, isNull);
      },
    );

    test(
      'when given a line containing multiple events '
      'then each event is processed in order',
      () {
        fp.handleMachineLine(
          jsonEncode([
            {
              'event': 'app.webLaunchUrl',
              'params': {'url': 'http://localhost:8080'},
            },
            {
              'event': 'app.progress',
              'params': {'message': 'Compiling'},
            },
            {
              'event': 'app.started',
              'params': <String, Object?>{},
            },
          ]),
        );
        expect(fp.flutterAppUrl, 'http://localhost:8080');
        expect(progressMessages, contains('Compiling'));
      },
    );

    test(
      'when app.started arrives then onStarted fires',
      () {
        var startedCalls = 0;
        fp = FlutterProcess(
          flutterPackageDir: Directory.systemTemp.path,
          device: 'linux',
          onProgress: progressMessages.add,
          onStarted: () => startedCalls++,
        );

        fp.handleMachineLine(
          jsonEncode([
            {
              'event': 'app.started',
              'params': <String, Object?>{},
            },
          ]),
        );

        // Desktop devices never publish an app.webLaunchUrl, so this
        // callback is their only launch-complete signal. It replaces the
        // progress stream for this event - no stage string is emitted.
        expect(startedCalls, 1);
        expect(progressMessages, isEmpty);
        expect(fp.flutterAppUrl, isNull);
      },
    );

    test(
      'when given app.dtd then dtdUri is captured',
      () {
        fp.handleMachineLine(
          jsonEncode([
            {
              'event': 'app.dtd',
              'params': {'uri': 'ws://127.0.0.1:9100/ws'},
            },
          ]),
        );

        expect(fp.dtdUri, 'ws://127.0.0.1:9100/ws');
      },
    );

    test(
      'when app.webLaunchUrl arrives before app.debugPort '
      'then launched completes immediately (web-server gate semantics)',
      () async {
        fp.handleMachineLine(
          jsonEncode([
            {
              'event': 'app.webLaunchUrl',
              'params': {'url': 'http://localhost:54321'},
            },
          ]),
        );
        await fp.launched.timeout(const Duration(milliseconds: 100));
        expect(fp.flutterAppUrl, 'http://localhost:54321');
        expect(fp.vmServiceUri, isNull);
      },
    );

    test(
      'when device is "web-server-launch-browser" and app.webLaunchUrl arrives '
      'then the browser launcher is invoked with that URL',
      () async {
        Uri? openedUrl;
        fp = FlutterProcess(
          flutterPackageDir: Directory.systemTemp.path,
          device: flutterDeviceWebServerWithBrowser,
          openBrowserForTesting: (url) async {
            openedUrl = url;
            return true;
          },
        );
        fp.handleMachineLine(
          jsonEncode([
            {
              'event': 'app.webLaunchUrl',
              'params': {'url': 'http://localhost:54321'},
            },
          ]),
        );
        await Future<void>.delayed(Duration.zero);
        expect(openedUrl, Uri.parse('http://localhost:54321'));
      },
    );

    test(
      'when device is "web-server" and app.webLaunchUrl arrives '
      'then the browser launcher is not invoked',
      () async {
        var browserLaunchCount = 0;
        fp = FlutterProcess(
          flutterPackageDir: Directory.systemTemp.path,
          device: 'web-server',
          openBrowserForTesting: (_) async {
            browserLaunchCount++;
            return true;
          },
        );
        fp.handleMachineLine(
          jsonEncode([
            {
              'event': 'app.webLaunchUrl',
              'params': {'url': 'http://localhost:54321'},
            },
          ]),
        );
        await Future<void>.delayed(Duration.zero);
        expect(browserLaunchCount, 0);
      },
    );

    test(
      'when app.debugPort arrives without app.webLaunchUrl '
      'then launched completes immediately (mobile/desktop gate semantics)',
      () async {
        fp.handleMachineLine(
          jsonEncode([
            {
              'event': 'app.debugPort',
              'params': {'wsUri': 'ws://127.0.0.1:1111/ws'},
            },
          ]),
        );
        await fp.launched.timeout(const Duration(milliseconds: 100));
        expect(fp.flutterAppUrl, isNull);
        expect(fp.vmServiceUri, 'http://127.0.0.1:1111');
      },
    );
  });

  group(
    'Given a VM Logging record whose optional values are Null instances, '
    'when the record is received,',
    () {
      late FlutterProcess fp;
      late ({HttpServer server, String wsUri}) fake;
      late FlutterLogEvent receivedEvent;

      setUp(() async {
        fake = await _startFakeLoggingVmService();
        final eventCompleter = Completer<FlutterLogEvent>();
        fp = FlutterProcess(
          flutterPackageDir: Directory.current.path,
          device: 'web-server',
          flutterExecutable: _dartExecutable(),
          argsOverrideForTesting: [
            _shimPath('emits_machine_events.dart'),
            '--ws=${fake.wsUri}',
          ],
          onLog: (event) {
            if (event.source == FlutterLogSource.vmLogging &&
                !eventCompleter.isCompleted) {
              eventCompleter.complete(event);
            }
          },
        );

        await fp.start();
        await fp.launched;
        await fp.connectToVmService();
        receivedEvent = await eventCompleter.future.timeout(
          const Duration(seconds: 5),
        );
      });

      tearDown(() async {
        await fp.stop(timeout: const Duration(milliseconds: 100));
        await fake.server.close(force: true);
      });

      test(
        'then no error, stack trace, or null-valued metadata is emitted.',
        () {
          expect(receivedEvent.error, isNull);
          expect(receivedEvent.stackTrace, isNull);
          expect(receivedEvent.metadata, {
            'vmLevel': 800,
            'sequenceNumber': 1,
          });
        },
      );
    },
  );

  group(
    'Given VM logging with an unspecified level, '
    'when the record is forwarded,',
    () {
      late FlutterProcess fp;
      late ({HttpServer server, String wsUri}) fake;
      late FlutterLogEvent loggingEvent;

      setUp(() async {
        fake = await _startFakeLoggingVmService(loggingLevel: 0);
        final loggingCompleter = Completer<FlutterLogEvent>();
        fp = FlutterProcess(
          flutterPackageDir: Directory.current.path,
          device: 'web-server',
          flutterExecutable: _dartExecutable(),
          argsOverrideForTesting: [
            _shimPath('emits_machine_events.dart'),
            '--ws=${fake.wsUri}',
          ],
          onLog: (event) {
            if (event.source == FlutterLogSource.vmLogging &&
                !loggingCompleter.isCompleted) {
              loggingCompleter.complete(event);
            }
          },
        );

        await fp.start();
        await fp.launched;
        await fp.connectToVmService();
        loggingEvent = await loggingCompleter.future.timeout(
          const Duration(seconds: 5),
        );
      });

      tearDown(() async {
        await fp.stop(timeout: const Duration(milliseconds: 100));
        await fake.server.close(force: true);
      });

      test(
        'then it is represented as inferred info.',
        () {
          expect(loggingEvent.level, LogLevel.info);
          expect(loggingEvent.levelIsInferred, isTrue);
          expect(loggingEvent.metadata, {'sequenceNumber': 1});
        },
      );
    },
  );

  group(
    'Given VM stdout split across partial writes, '
    'when the stream is forwarded,',
    () {
      late FlutterProcess fp;
      late ({HttpServer server, String wsUri}) fake;
      late FlutterLogEvent stdoutEvent;

      setUp(() async {
        fake = await _startFakeLoggingVmService(
          loggingLevel: null,
          stdoutChunks: [utf8.encode('Progress: '), utf8.encode('50%\n')],
        );
        final stdoutCompleter = Completer<FlutterLogEvent>();
        fp = FlutterProcess(
          flutterPackageDir: Directory.current.path,
          device: 'web-server',
          flutterExecutable: _dartExecutable(),
          argsOverrideForTesting: [
            _shimPath('emits_machine_events.dart'),
            '--ws=${fake.wsUri}',
          ],
          onLog: (event) {
            if (event.source == FlutterLogSource.vmStdout &&
                !stdoutCompleter.isCompleted) {
              stdoutCompleter.complete(event);
            }
          },
        );

        await fp.start();
        await fp.launched;
        await fp.connectToVmService();
        stdoutEvent = await stdoutCompleter.future.timeout(
          const Duration(seconds: 5),
        );
      });

      tearDown(() async {
        await fp.stop(timeout: const Duration(milliseconds: 100));
        await fake.server.close(force: true);
      });

      test(
        'then one complete structured line is emitted.',
        () {
          expect(stdoutEvent.message, 'Progress: 50%');
          expect(stdoutEvent.metadata, {
            'coalesced': false,
            'lineCount': 1,
          });
        },
      );
    },
  );

  group(
    'Given the same app line from a VM stream and app.log, '
    'when both transports forward it,',
    () {
      late FlutterProcess fp;
      late ({HttpServer server, String wsUri}) fake;
      late List<FlutterLogEvent> receivedEvents;
      late StringBuffer stdoutBuffer;
      late StreamController<List<int>> stdoutController;
      late IOSink stdoutSink;

      setUp(() async {
        const message = 'A native application message';
        fake = await _startFakeLoggingVmService(
          loggingLevel: null,
          stdoutChunks: [utf8.encode('$message\n')],
        );
        receivedEvents = [];
        stdoutBuffer = StringBuffer();
        stdoutController = StreamController<List<int>>();
        stdoutController.stream
            .transform(utf8.decoder)
            .listen(stdoutBuffer.write);
        stdoutSink = IOSink(stdoutController.sink);
        final vmEvent = Completer<void>();
        fp = FlutterProcess(
          flutterPackageDir: Directory.current.path,
          device: 'linux',
          flutterExecutable: _dartExecutable(),
          argsOverrideForTesting: [
            _shimPath('emits_machine_events.dart'),
            '--ws=${fake.wsUri}',
          ],
          stdoutSink: stdoutSink,
          onLog: (event) {
            receivedEvents.add(event);
            if (event.source == FlutterLogSource.vmStdout &&
                !vmEvent.isCompleted) {
              vmEvent.complete();
            }
          },
        );

        await fp.start();
        await fp.launched;
        await fp.connectToVmService();
        await vmEvent.future.timeout(const Duration(seconds: 5));
        fp.handleMachineLine(
          jsonEncode([
            {
              'event': 'app.log',
              'params': {'log': message, 'error': false},
            },
          ]),
        );
        await stdoutSink.flush();
        await Future<void>.delayed(Duration.zero);
      });

      tearDown(() async {
        await fp.stop(timeout: const Duration(milliseconds: 100));
        await fake.server.close(force: true);
        await stdoutSink.close();
      });

      test(
        'then one structured entry and one raw line are retained.',
        () {
          expect(receivedEvents, hasLength(1));
          expect(receivedEvents.single.source, FlutterLogSource.vmStdout);
          expect(stdoutBuffer.toString(), 'A native application message\n');
        },
      );
    },
  );

  group(
    'Given a partially mirrored multi-line app log followed by a repeated line, '
    'when both transports forward the output,',
    () {
      late FlutterProcess fp;
      late ({HttpServer server, String wsUri}) fake;
      late List<FlutterLogEvent> receivedEvents;
      late StringBuffer stdoutBuffer;
      late StreamController<List<int>> stdoutController;
      late IOSink stdoutSink;

      setUp(() async {
        fake = await _startFakeLoggingVmService(
          loggingLevel: null,
          stdoutChunks: [utf8.encode('A\n'), utf8.encode('A\n')],
          stdoutChunkInterval: const Duration(milliseconds: 150),
        );
        receivedEvents = [];
        stdoutBuffer = StringBuffer();
        stdoutController = StreamController<List<int>>();
        stdoutController.stream
            .transform(utf8.decoder)
            .listen(stdoutBuffer.write);
        stdoutSink = IOSink(stdoutController.sink);
        final firstVmEvent = Completer<void>();
        fp = FlutterProcess(
          flutterPackageDir: Directory.current.path,
          device: 'linux',
          flutterExecutable: _dartExecutable(),
          argsOverrideForTesting: [
            _shimPath('emits_machine_events.dart'),
            '--ws=${fake.wsUri}',
          ],
          stdoutSink: stdoutSink,
          onLog: (event) {
            receivedEvents.add(event);
            if (event.source == FlutterLogSource.vmStdout &&
                !firstVmEvent.isCompleted) {
              firstVmEvent.complete();
            }
          },
        );

        await fp.start();
        await fp.launched;
        await fp.connectToVmService();
        await firstVmEvent.future.timeout(const Duration(seconds: 5));
        fp.handleMachineLine(
          jsonEncode([
            {
              'event': 'app.log',
              'params': {'log': 'A\nB', 'error': false},
            },
          ]),
        );
        await Future<void>.delayed(const Duration(milliseconds: 250));
        fp.handleMachineLine(
          jsonEncode([
            {
              'event': 'app.log',
              'params': {'log': 'A', 'error': false},
            },
          ]),
        );
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await stdoutSink.flush();
        await Future<void>.delayed(Duration.zero);
      });

      tearDown(() async {
        await fp.stop(timeout: const Duration(milliseconds: 100));
        await fake.server.close(force: true);
        await stdoutSink.close();
      });

      test(
        'then the repeated line is retained once.',
        () {
          expect(
            receivedEvents.map((event) => event.message),
            ['A', 'A\nB', 'A'],
          );
          expect(stdoutBuffer.toString(), 'A\nA\nB\nA\n');
        },
      );
    },
  );

  group(
    'Given a Flutter process whose UTF-8 stderr character spans byte chunks, '
    'when stderr is forwarded,',
    () {
      late FlutterProcess fp;
      late FlutterLogEvent receivedEvent;
      late StringBuffer stderrBuffer;
      late StreamController<List<int>> stderrController;
      late IOSink stderrSink;

      setUp(() async {
        final eventCompleter = Completer<FlutterLogEvent>();
        stderrBuffer = StringBuffer();
        stderrController = StreamController<List<int>>();
        stderrController.stream
            .transform(utf8.decoder)
            .listen(stderrBuffer.write);
        stderrSink = IOSink(stderrController.sink);
        fp = FlutterProcess(
          flutterPackageDir: Directory.current.path,
          device: 'web-server',
          flutterExecutable: _dartExecutable(),
          argsOverrideForTesting: [
            _shimPath('emits_split_utf8_stderr.dart'),
          ],
          stderrSink: stderrSink,
          onLog: (event) {
            if (event.source == FlutterLogSource.processStderr &&
                !eventCompleter.isCompleted) {
              eventCompleter.complete(event);
            }
          },
        );

        await fp.start();
        await fp.exitCode;
        receivedEvent = await eventCompleter.future.timeout(
          const Duration(seconds: 5),
        );
        await stderrSink.flush();
        await Future<void>.delayed(Duration.zero);
      });

      tearDown(() async {
        await fp.stop();
        await stderrSink.close();
      });

      test(
        'then the structured entry and raw line preserve the character.',
        () {
          expect(receivedEvent.message, 'Falha: conexão');
          expect(stderrBuffer.toString(), 'Falha: conexão\n');
        },
      );
    },
  );

  group(
    'Given a Flutter process emitting inferred stderr lines in two bursts, '
    'when its log events are forwarded,',
    () {
      late FlutterProcess fp;
      late List<FlutterLogEvent> receivedEvents;

      setUp(() async {
        receivedEvents = [];
        final twoEvents = Completer<void>();
        fp = FlutterProcess(
          flutterPackageDir: Directory.current.path,
          device: 'web-server',
          flutterExecutable: _dartExecutable(),
          argsOverrideForTesting: [
            _shimPath('emits_raw_log_bursts.dart'),
          ],
          onLog: (event) {
            receivedEvents.add(event);
            if (receivedEvents.length == 2 && !twoEvents.isCompleted) {
              twoEvents.complete();
            }
          },
        );

        await fp.start();
        await fp.exitCode;
        await twoEvents.future.timeout(const Duration(seconds: 5));
      });

      tearDown(() async {
        await fp.stop();
      });

      test(
        'then adjacent lines are grouped and the idle boundary starts a new entry.',
        () {
          expect(receivedEvents, hasLength(2));
          expect(
            receivedEvents.first.message,
            'First line of one diagnostic.\n'
            'Second line of one diagnostic.',
          );
          expect(receivedEvents.first.metadata, {
            'coalesced': true,
            'lineCount': 2,
          });
          expect(receivedEvents.first.levelIsInferred, isTrue);
          expect(receivedEvents.first.timestampIsInferred, isTrue);
          expect(receivedEvents.last.message, 'A later diagnostic.');
          expect(receivedEvents.last.metadata, {
            'coalesced': false,
            'lineCount': 1,
          });
        },
      );
    },
  );

  group(
    'Given a Flutter process continuously emitting inferred stderr lines, '
    'when its log events are forwarded,',
    () {
      late FlutterProcess fp;
      late List<FlutterLogEvent> receivedEvents;

      setUp(() async {
        receivedEvents = [];
        final allLinesForwarded = Completer<void>();
        fp = FlutterProcess(
          flutterPackageDir: Directory.current.path,
          device: 'web-server',
          flutterExecutable: _dartExecutable(),
          argsOverrideForTesting: [
            _shimPath('emits_raw_log_trickle.dart'),
          ],
          onLog: (event) {
            receivedEvents.add(event);
            final lineCount = receivedEvents.fold<int>(
              0,
              (count, event) => count + event.message.split('\n').length,
            );
            if (lineCount == 20 && !allLinesForwarded.isCompleted) {
              allLinesForwarded.complete();
            }
          },
        );

        await fp.start();
        await fp.exitCode;
        await allLinesForwarded.future.timeout(const Duration(seconds: 5));
      });

      tearDown(() async {
        await fp.stop();
      });

      test(
        'then the pending entry is flushed before the output becomes idle.',
        () {
          expect(receivedEvents, hasLength(greaterThan(1)));
          expect(
            receivedEvents.expand((event) => event.message.split('\n')),
            [for (var index = 1; index <= 20; index++) 'Line $index'],
          );
        },
      );
    },
  );
}
