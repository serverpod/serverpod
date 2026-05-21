import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/start/flutter_process.dart';
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
      },
    );
  });

  group(
    'Given a running FlutterProcess parsing machine protocol from a shim',
    () {
      late FlutterProcess fp;
      late ({HttpServer server, String wsUri}) fake;
      late List<String> progressMessages;

      setUp(() async {
        fake = await _startFakeVmService();
        progressMessages = <String>[];

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
        );

        await fp.start();

        // We only need vmServiceUri set; the fake never replies.
        unawaited(fp.connectToVmService());
      });

      tearDown(() async {
        await fp.stop();
      });

      test(
        'when the shim emits app.progress, app.webLaunchUrl, app.debugPort, app.started '
        'then onProgress fires, flutterAppUrl is captured, and vmServiceUri is the http form of the daemon\'s wsUri',
        () async {
          // Wait until the URI shows up (the shim emits it ~immediately).
          final deadline = DateTime.now().add(const Duration(seconds: 5));
          while (fp.vmServiceUri == null && DateTime.now().isBefore(deadline)) {
            await Future<void>.delayed(const Duration(milliseconds: 20));
          }

          expect(
            fp.vmServiceUri,
            equals('http://127.0.0.1:${fake.server.port}'),
          );
          expect(fp.flutterAppUrl, equals('http://localhost:54321'));
          expect(progressMessages, contains(flutterAppLaunching));
          expect(progressMessages, contains('Launching ...'));
          expect(progressMessages, contains('ready'));

          await fp.stop(timeout: const Duration(seconds: 1));
          await fake.server.close(force: true);
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

  group('Given a FlutterProcess with a vmServiceInfoFile configured', () {
    late FlutterProcess fp;
    late ({HttpServer server, String wsUri}) fake;
    late Directory tmp;
    late String infoPath;

    setUp(() async {
      fake = await _startFakeVmService();
      tmp = Directory.systemTemp.createTempSync('flutter_proc_test_');
      infoPath = p.join(tmp.path, 'flutter-vm-service-info.json');

      fp = FlutterProcess(
        flutterPackageDir: Directory.current.path,
        device: 'web-server',
        flutterExecutable: _dartExecutable(),
        argsOverrideForTesting: [
          _shimPath('emits_machine_events.dart'),
          '--ws=${fake.wsUri}',
        ],
        vmServiceInfoFile: infoPath,
      );

      await fp.start();
      unawaited(fp.connectToVmService());
    });

    tearDown(() async {
      await fp.stop();
      await fake.server.close(force: true);
      try {
        tmp.deleteSync(recursive: true);
      } on FileSystemException {
        // Already gone.
      }
    });

    test(
      'when the shim publishes a URI '
      'then the file is written with the http URI, then cleaned up on stop',
      () async {
        // Poll on contents: writeAsString creates the inode before
        // flushing, so existsSync can catch an empty intermediate.
        final deadline = DateTime.now().add(const Duration(seconds: 5));
        var contents = '';
        while (contents.isEmpty && DateTime.now().isBefore(deadline)) {
          if (File(infoPath).existsSync()) {
            contents = File(infoPath).readAsStringSync();
          }
          if (contents.isEmpty) {
            await Future<void>.delayed(const Duration(milliseconds: 20));
          }
        }

        expect(
          contents,
          contains('http://127.0.0.1:${fake.server.port}'),
        );

        await fp.stop(timeout: const Duration(seconds: 1));

        // Cleanup runs async via the exit listener; poll briefly.
        final cleanupDeadline = DateTime.now().add(const Duration(seconds: 2));
        while (File(infoPath).existsSync() &&
            DateTime.now().isBefore(cleanupDeadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
        }
        expect(File(infoPath).existsSync(), isFalse);
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

    setUp(() async {
      progressMessages = <String>[];

      /// FlutterProcess wired only enough to push synthetic lines through
      /// `handleMachineLine` and assert side effects.
      fp = FlutterProcess(
        flutterPackageDir: Directory.systemTemp.path,
        device: 'web-server',
        onProgress: progressMessages.add,
      );
    });

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
        expect(progressMessages, containsAllInOrder(['Compiling', 'ready']));
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
      },
    );
  });
}
