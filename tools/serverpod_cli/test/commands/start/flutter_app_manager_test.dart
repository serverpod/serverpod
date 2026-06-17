import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/flutter_app_manager.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:test/test.dart';

String _shimPath(String name) => p.join(
  Directory.current.path,
  'test',
  'commands',
  'start',
  'flutter_shims',
  name,
);

String _dartExecutable() => Platform.resolvedExecutable;

Future<({HttpServer server, String wsUri})> _startFakeVmService() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.transform(WebSocketTransformer()).listen((socket) async {
    socket.listen((_) {}, onDone: () => socket.close());
  });
  return (
    server: server,
    wsUri: 'ws://127.0.0.1:${server.port}/ws',
  );
}

FlutterAppConfig _testApp({
  required Directory serverDir,
  required Directory flutterDir,
  required String id,
  required String name,
}) {
  return FlutterAppConfig(
    id: id,
    name: name,
    relativePathParts: p.split(
      p.relative(flutterDir.path, from: serverDir.path),
    ),
    serverPackageDirectoryPathParts: p.split(serverDir.path),
    // `web-server` (no browser) so launches never spawn a real browser and the
    // VM-service connect waits without a timeout, as the manager tests expect.
    device: 'web-server',
  );
}

void main() {
  group('Given a FlutterAppManager with two configured apps', () {
    late Directory tempDir;
    late Directory serverDir;
    late Directory flutterDirA;
    late Directory flutterDirB;
    late FlutterAppManager manager;
    late FlutterAppConfig appA;
    late FlutterAppConfig appB;
    late String launchedAppId;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('flutter_mgr_test_');
      serverDir = Directory(p.join(tempDir.path, 'project_server'))
        ..createSync(recursive: true);
      flutterDirA = Directory(p.join(tempDir.path, 'app_a_flutter'))
        ..createSync(recursive: true);
      flutterDirB = Directory(p.join(tempDir.path, 'app_b_flutter'))
        ..createSync(recursive: true);

      for (final dir in [flutterDirA, flutterDirB]) {
        File(p.join(dir.path, 'pubspec.yaml')).writeAsStringSync('''
name: ${p.basename(dir.path)}
dependencies:
  flutter:
    sdk: flutter
''');
      }

      appA = _testApp(
        serverDir: serverDir,
        flutterDir: flutterDirA,
        id: 'app-a',
        name: 'App A',
      );
      appB = _testApp(
        serverDir: serverDir,
        flutterDir: flutterDirB,
        id: 'app-b',
        name: 'App B',
      );

      launchedAppId = '';
      manager = FlutterAppManager(
        apps: [appA, appB],
        serverpodToolDir: p.join(serverDir.path, '.dart_tool', 'serverpod'),
        runMode: 'development',
        onProgress: (_, _) {},
        onReady: (_, _) {},
        onStart: (_, _) async {},
        onEnsureAppTab: (app) => launchedAppId = app.id,
        stdoutSinkFor: (_) => stdout,
        stderrSinkFor: (_) => stderr,
        flutterExecutableForTesting: _dartExecutable(),
        argsOverrideForTesting: (_) => [_shimPath('never_publishes_uri.dart')],
      );
      await manager.initialize();
    });

    tearDown(() async {
      await manager.dispose();
      await tempDir.delete(recursive: true);
    });

    test(
      'when initialize is called then each app gets its own info file',
      () {
        expect(
          File(
            p.join(
              serverDir.path,
              '.dart_tool',
              'serverpod',
              'flutter-vm-service-info-app-a.json',
            ),
          ).existsSync(),
          isTrue,
        );
        expect(
          File(
            p.join(
              serverDir.path,
              '.dart_tool',
              'serverpod',
              'flutter-vm-service-info-app-b.json',
            ),
          ).existsSync(),
          isTrue,
        );
      },
    );

    test(
      'when stdoutSinkFor is called then each app gets its own sink target',
      () async {
        final sinkLines = <String, List<String>>{
          appA.id: [],
          appB.id: [],
        };

        IOSink sinkFor(List<String> lines) {
          final controller = StreamController<List<int>>();
          controller.stream.listen((data) => lines.add(utf8.decode(data)));
          return IOSink(controller.sink);
        }

        final routingManager = FlutterAppManager(
          apps: [appA, appB],
          serverpodToolDir: p.join(serverDir.path, '.dart_tool', 'serverpod'),
          runMode: 'development',
          onProgress: (_, _) {},
          onReady: (_, _) {},
          onStart: (_, _) async {},
          onEnsureAppTab: (_) {},
          stdoutSinkFor: (app) => sinkFor(sinkLines[app.id]!),
          stderrSinkFor: (app) => sinkFor(sinkLines[app.id]!),
        );

        routingManager.stdoutSinkFor(appA).write('line-a\n');
        routingManager.stdoutSinkFor(appB).write('line-b\n');
        await Future<void>.delayed(Duration.zero);

        expect(sinkLines[appA.id], ['line-a\n']);
        expect(sinkLines[appB.id], ['line-b\n']);
      },
    );

    test(
      'when two apps are launched then both run concurrently',
      () async {
        await manager.launch(appA.id);
        await manager.launch(appB.id);

        expect(manager.isRunning(appA.id), isTrue);
        expect(manager.isRunning(appB.id), isTrue);
        expect(manager.runningAppIds, containsAll([appA.id, appB.id]));
      },
    );

    test(
      'when launch is called then onEnsureAppTab is invoked',
      () async {
        await manager.launch(appA.id);

        expect(launchedAppId, appA.id);
      },
    );

    test(
      'when launch starts then isLaunching is true',
      () async {
        // `launch` flips the spawn-in-flight flag synchronously, before its
        // first await, so the app reads as launching the instant the call is
        // kicked off — no fixed wait needed. The shim never publishes a URL, so
        // it stays launching until torn down in tearDown.
        unawaited(manager.launch(appA.id));

        expect(manager.isLaunching(appA.id), isTrue);
        expect(manager.isLaunching(appB.id), isFalse);
      },
    );

    test(
      'when stopAll is called then running apps stop and info files are removed',
      () async {
        await manager.launch(appA.id);
        final infoFile = p.join(
          serverDir.path,
          '.dart_tool',
          'serverpod',
          'flutter-vm-service-info-app-a.json',
        );
        expect(File(infoFile).existsSync(), isTrue);

        await manager.stopAll();

        expect(manager.isRunning(appA.id), isFalse);
        expect(File(infoFile).existsSync(), isFalse);
      },
    );

    test(
      'when changed paths are under one app lib then only that app id matches',
      () async {
        await manager.launch(appA.id);
        await manager.launch(appB.id);

        final adminPath = p.join(flutterDirA.path, 'lib', 'main.dart');
        expect(
          manager.appIdsForChangedPaths([adminPath]),
          {appA.id},
        );
      },
    );
  });

  group('Given a FlutterAppManager with an emits_machine_events shim', () {
    late Directory tempDir;
    late Directory serverDir;
    late Directory flutterDir;
    late FlutterAppConfig app;
    late FlutterAppManager manager;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('flutter_mgr_shim_');
      serverDir = Directory(p.join(tempDir.path, 'project_server'))
        ..createSync(recursive: true);
      flutterDir = Directory(p.join(tempDir.path, 'project_flutter'))
        ..createSync(recursive: true);
      File(p.join(flutterDir.path, 'pubspec.yaml')).writeAsStringSync('''
name: project_flutter
dependencies:
  flutter:
    sdk: flutter
''');

      app = _testApp(
        serverDir: serverDir,
        flutterDir: flutterDir,
        id: 'project',
        name: 'Project',
      );
    });

    tearDown(() async {
      await manager.dispose();
      await tempDir.delete(recursive: true);
    });

    test(
      'when launch completes then onReady receives the app URL',
      () async {
        final fake = await _startFakeVmService();
        addTearDown(() => fake.server.close(force: true));

        // Completed by onReady once the shim publishes its web URL, so the test
        // waits for exactly that event rather than a fixed duration.
        final ready = Completer<String>();

        manager = FlutterAppManager(
          apps: [app],
          serverpodToolDir: p.join(serverDir.path, '.dart_tool', 'serverpod'),
          runMode: 'development',
          onProgress: (_, _) {},
          onReady: (_, url) => ready.complete(url),
          onStart: (_, _) async {},
          onEnsureAppTab: (_) {},
          stdoutSinkFor: (_) => stdout,
          stderrSinkFor: (_) => stderr,
          flutterExecutableForTesting: _dartExecutable(),
          argsOverrideForTesting: (_) => [
            _shimPath('emits_machine_events.dart'),
            '--ws=${fake.wsUri}',
            '--web-url=http://localhost:9999',
          ],
        );
        await manager.initialize();
        await manager.launch(app.id);

        final readyUrl = await ready.future.timeout(
          const Duration(seconds: 30),
        );

        expect(readyUrl, 'http://localhost:9999');
        expect(manager.isRunning(app.id), isTrue);
        expect(manager.isLaunching(app.id), isFalse);
      },
    );
  });
}
