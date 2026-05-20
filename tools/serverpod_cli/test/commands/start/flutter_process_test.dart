import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
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
  group('Given a FlutterProcess', () {
    test(
      'when the executable is missing '
      'then FlutterNotInstalledException is thrown so the caller can keep going',
      () async {
        final fp = FlutterProcess(
          flutterPackageDir: Directory.systemTemp.path,
          device: 'web-server',
          flutterExecutable: '/definitely/not/a/real/binary',
        );

        await expectLater(
          fp.start,
          throwsA(isA<FlutterNotInstalledException>()),
        );
      },
    );

    test(
      'when start is called twice while still running '
      'then the second call throws StateError instead of spawning a duplicate process',
      () async {
        // Long-running shim so the first process is still alive when
        // the second start is attempted.
        final fp = FlutterProcess(
          flutterPackageDir: Directory.current.path,
          device: 'web-server',
          flutterExecutable: _dartExecutable(),
          argsOverrideForTesting: [_shimPath('never_publishes_uri.dart')],
        );
        await fp.start();
        expect(fp.start, throwsStateError);
        await fp.stop(timeout: const Duration(seconds: 1));
      },
    );

    test(
      'when the shim never publishes app.debugPort or app.webLaunchUrl '
      'then launched and connectToVmService both pend until the process is stopped, '
      'after which they resolve (matches "no reload available" semantics)',
      () async {
        final fp = FlutterProcess(
          flutterPackageDir: Directory.current.path,
          device: 'web-server',
          flutterExecutable: _dartExecutable(),
          argsOverrideForTesting: [_shimPath('never_publishes_uri.dart')],
        );
        await fp.start();

        // While the shim is alive and silent, neither future resolves.
        var launchedResolved = false;
        var connectResolved = false;
        unawaited(fp.launched.then((_) => launchedResolved = true));
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
  });

  group('Given a FlutterProcess parsing machine protocol from a shim', () {
    test(
      'when the shim emits app.progress, app.webLaunchUrl, app.debugPort, app.started '
      'then onProgress fires, flutterAppUrl is captured, '
      'and vmServiceUri is the http form of the daemon\'s wsUri',
      () async {
        final fake = await _startFakeVmService();
        final progressMessages = <String>[];

        final fp = FlutterProcess(
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
        expect(progressMessages, contains('launching'));
        expect(progressMessages, contains('Launching ...'));
        expect(progressMessages, contains('ready'));

        await fp.stop(timeout: const Duration(seconds: 1));
        await fake.server.close(force: true);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });

  group('Given a FlutterProcess that was never started', () {
    test(
      'when reload is called then it returns false without throwing',
      () async {
        final fp = FlutterProcess(
          flutterPackageDir: Directory.systemTemp.path,
          device: 'web-server',
        );
        expect(await fp.reload(), isFalse);
      },
    );

    test(
      'when stop is called '
      'then it completes with 0 and is idempotent',
      () async {
        final fp = FlutterProcess(
          flutterPackageDir: Directory.systemTemp.path,
          device: 'web-server',
        );
        expect(await fp.stop(), 0);
        expect(await fp.stop(), 0);
      },
    );
  });

  group('Given a FlutterProcess with a vmServiceInfoFile configured', () {
    test(
      'when the shim publishes a URI '
      'then the file is written with the http URI, then cleaned up on stop',
      () async {
        final fake = await _startFakeVmService();
        final tmp = Directory.systemTemp.createTempSync('flutter_proc_test_');
        final infoPath = p.join(tmp.path, 'flutter-vm-service-info.json');

        final fp = FlutterProcess(
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

        await fake.server.close(force: true);
        tmp.deleteSync(recursive: true);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });

  group('Given a ws URI passed to httpFromWs', () {
    test(
      'when the URI ends in /ws '
      'then the scheme swaps to http and the /ws suffix is stripped',
      () {
        expect(
          FlutterProcess.httpFromWs('ws://127.0.0.1:54321/ws'),
          'http://127.0.0.1:54321',
        );
      },
    );

    test('when the scheme is wss then it swaps to https', () {
      // Uri.toString() strips the port when it matches the scheme default.
      expect(
        FlutterProcess.httpFromWs('wss://example.com:9443/ws'),
        'https://example.com:9443',
      );
    });

    test('when the path is not /ws then the path is left alone', () {
      expect(
        FlutterProcess.httpFromWs('ws://127.0.0.1:54321/different'),
        'http://127.0.0.1:54321/different',
      );
    });
  });

  group('Given handleMachineLine', () {
    /// FlutterProcess wired only enough to push synthetic lines through
    /// `handleMachineLine` and assert side effects.
    FlutterProcess bareFp({void Function(String)? onProgress}) =>
        FlutterProcess(
          flutterPackageDir: Directory.systemTemp.path,
          device: 'web-server',
          onProgress: onProgress,
        );

    test(
      'when given a line that does not start with [ '
      'then the line is ignored',
      () {
        final fp = bareFp();
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
        final fp = bareFp();
        fp.handleMachineLine('[not-json');
        expect(fp.vmServiceUri, isNull);
      },
    );

    test(
      'when given an envelope missing the event field '
      'then the envelope is ignored',
      () {
        final fp = bareFp();
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
        final progress = <String>[];
        final fp = bareFp(onProgress: progress.add);
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
        expect(progress, containsAllInOrder(['Compiling', 'ready']));
      },
    );

    test(
      'when app.webLaunchUrl arrives before app.debugPort '
      'then launched completes immediately (web-server gate semantics)',
      () async {
        final fp = bareFp();
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
        final fp = bareFp();
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
