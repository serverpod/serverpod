import 'dart:async';
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
        flutterDevice: 'web-server',
        flutterExtraArgs: const [],
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
  });

  group('Given a FlutterAppManager with an emits_machine_events shim', () {
    late Directory tempDir;
    late Directory serverDir;
    late Directory flutterDir;
    late FlutterAppConfig app;
    late FlutterAppManager manager;
    late String? readyUrl;

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

      readyUrl = null;
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

        manager = FlutterAppManager(
          apps: [app],
          serverpodToolDir: p.join(serverDir.path, '.dart_tool', 'serverpod'),
          runMode: 'development',
          flutterDevice: 'web-server',
          flutterExtraArgs: const [],
          onProgress: (_, _) {},
          onReady: (_, url) => readyUrl = url,
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

        await Future<void>.delayed(const Duration(seconds: 2));

        expect(readyUrl, 'http://localhost:9999');
        expect(manager.isRunning(app.id), isTrue);
      },
    );
  });
}
