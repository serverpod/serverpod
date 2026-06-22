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

/// Polls [condition] until it returns true or [timeout] elapses.
Future<void> _eventually(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('Condition not met within $timeout');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

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

      final serverPubspecFile = File(p.join(serverDir.path, 'pubspec.yaml'));
      serverPubspecFile.writeAsStringSync('name: server');

      launchedAppId = '';
      manager = FlutterAppManager(
        apps: [appA, appB],
        serverpodToolDir: p.join(serverDir.path, '.dart_tool', 'serverpod'),
        serverPubspecFile: serverPubspecFile,
        runMode: 'development',
        onProgress: (_, _) {},
        onReady: (_, _) {},
        onStart: (_, _) async {},
        onLaunchFailed: (_) {},
        onEnsureAppTab: (app) => launchedAppId = app.id,
        stdoutSinkFor: (_) => stdout,
        stderrSinkFor: (_) => stderr,
        flutterExecutableForTesting: _dartExecutable(),
        argsOverrideForTesting: (_) => [_shimPath('never_publishes_uri.dart')],
      );
    });

    tearDown(() async {
      await manager.dispose();
      await tempDir.delete(recursive: true);
    });

    test(
      'when initialize is called then each app gets its own info file',
      () async {
        await manager.initialize();

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

    group('that is initialized', () {
      setUp(() async {
        await manager.initialize();
      });

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
          // kicked off — no fixed wait needed. The shim never publishes a URL,
          // so it stays launching until torn down in tearDown.
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
        'when stop is called then only that app stops and its info file remains',
        () async {
          await manager.launch(appA.id);
          await manager.launch(appB.id);
          final infoFile = p.join(
            serverDir.path,
            '.dart_tool',
            'serverpod',
            'flutter-vm-service-info-app-a.json',
          );

          await manager.stop(appA.id);

          expect(manager.isRunning(appA.id), isFalse);
          expect(manager.isRunning(appB.id), isTrue);
          // Unlike stopAll, a single stop keeps the info file for relaunch.
          expect(File(infoFile).existsSync(), isTrue);
        },
      );

      test(
        'when stop is called for an unknown or stopped app then it is a no-op',
        () async {
          await manager.stop('does-not-exist');
          await manager.stop(appA.id);

          expect(manager.isRunning(appA.id), isFalse);
        },
      );

      test(
        'when an app is stopped then its entry is dropped from dtdUris while '
        'others remain',
        () async {
          await manager.launch(appA.id);
          await manager.launch(appB.id);

          // The never_publishes_uri shim starts the process but never emits
          // app.dtd, so each running app maps to a null DTD URI. dtdUris backs
          // the get_flutter_app_dtd MCP tool.
          expect(manager.dtdUris, {appA.id: null, appB.id: null});

          await manager.stop(appA.id);

          // The stopped app is gone entirely, not merely mapped to null; the
          // still-running app is untouched.
          expect(manager.dtdUris, {appB.id: null});
          expect(manager.dtdUris.containsKey(appA.id), isFalse);
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
  });

  group('Given a FlutterAppManager wired with per-app log sinks', () {
    late Directory tempDir;
    late FlutterAppConfig appA;
    late FlutterAppConfig appB;
    late Map<String, List<String>> sinkLines;
    late FlutterAppManager manager;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('flutter_mgr_test_');
      final serverDir = Directory(p.join(tempDir.path, 'project_server'))
        ..createSync(recursive: true);
      appA = const FlutterAppConfig(
        id: 'app-a',
        name: 'App A',
        relativePathParts: ['..', 'app_a_flutter'],
        serverPackageDirectoryPathParts: [],
      );
      appB = const FlutterAppConfig(
        id: 'app-b',
        name: 'App B',
        relativePathParts: ['..', 'app_b_flutter'],
        serverPackageDirectoryPathParts: [],
      );
      sinkLines = {appA.id: [], appB.id: []};

      IOSink sinkFor(List<String> lines) {
        final controller = StreamController<List<int>>();
        controller.stream.listen((data) => lines.add(utf8.decode(data)));
        return IOSink(controller.sink);
      }

      final serverPubspecFile = File(p.join(serverDir.path, 'pubspec.yaml'));
      serverPubspecFile.writeAsStringSync('name: server');

      manager = FlutterAppManager(
        apps: [appA, appB],
        serverpodToolDir: 'unused',
        serverPubspecFile: serverPubspecFile,
        runMode: 'development',
        onProgress: (_, _) {},
        onReady: (_, _) {},
        onStart: (_, _) async {},
        onLaunchFailed: (_) {},
        onEnsureAppTab: (_) {},
        stdoutSinkFor: (app) => sinkFor(sinkLines[app.id]!),
        stderrSinkFor: (app) => sinkFor(sinkLines[app.id]!),
      );
    });

    tearDown(() async {
      await manager.dispose();
      await tempDir.delete(recursive: true);
    });

    test(
      'when stdoutSinkFor is called then each app gets its own sink target',
      () async {
        manager.stdoutSinkFor(appA).write('line-a\n');
        manager.stdoutSinkFor(appB).write('line-b\n');
        await Future<void>.delayed(Duration.zero);

        expect(sinkLines[appA.id], ['line-a\n']);
        expect(sinkLines[appB.id], ['line-b\n']);
      },
    );
  });

  group(
    'Given an initialized FlutterAppManager running the emits_machine_events shim',
    () {
      late Directory tempDir;
      late Directory serverDir;
      late Directory flutterDir;
      late FlutterAppConfig app;
      late FlutterAppManager manager;
      // Completed by onReady once the shim publishes its web URL, so the test
      // waits for exactly that event rather than a fixed duration.
      late Completer<String> ready;

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

        final fake = await _startFakeVmService();
        addTearDown(() => fake.server.close(force: true));
        final serverPubspecFile = File(p.join(serverDir.path, 'pubspec.yaml'));
        serverPubspecFile.writeAsStringSync('name: server');

        ready = Completer<String>();
        manager = FlutterAppManager(
          apps: [app],
          serverpodToolDir: p.join(serverDir.path, '.dart_tool', 'serverpod'),
          serverPubspecFile: serverPubspecFile,
          runMode: 'development',
          onProgress: (_, _) {},
          onReady: (_, url) => ready.complete(url),
          onStart: (_, _) async {},
          onLaunchFailed: (_) {},
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
      });

      tearDown(() async {
        await manager.dispose();
        await tempDir.delete(recursive: true);
      });

      test(
        'when launch completes then onReady receives the app URL',
        () async {
          await manager.launch(app.id);

          final readyUrl = await ready.future.timeout(
            const Duration(seconds: 30),
          );

          expect(readyUrl, 'http://localhost:9999');
          expect(manager.isRunning(app.id), isTrue);
          expect(manager.isLaunching(app.id), isFalse);
        },
      );

      test(
        'when the app is stopped then its published DTD URI is no longer '
        'reported by dtdUris',
        () async {
          await manager.launch(app.id);
          await ready.future.timeout(const Duration(seconds: 30));
          // onReady fires on the web URL, which the shim emits before app.dtd,
          // so wait until the DTD URI has been parsed too.
          await _eventually(() => manager.dtdUris['project'] != null);

          // The shim emits app.dtd, so the running app reports its DTD URI.
          expect(manager.dtdUris, {'project': 'ws://127.0.0.1:9100/ws'});

          await manager.stop(app.id);

          // Stopping the app drops it from the map that backs the
          // get_flutter_app_dtd MCP tool, so its DTD URI is no longer returned.
          expect(manager.dtdUris, isEmpty);
        },
      );
    },
  );

  group(
    'Given an initialized FlutterAppManager whose app exits during the build',
    () {
      late Directory tempDir;
      late Directory serverDir;
      late Directory flutterDir;
      late FlutterAppConfig app;
      late FlutterAppManager manager;
      late Completer<FlutterAppConfig> launchFailed;
      var readyCalls = 0;

      setUp(() async {
        tempDir = await Directory.systemTemp.createTemp('flutter_mgr_fail_');
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

        final serverPubspecFile = File(p.join(serverDir.path, 'pubspec.yaml'));
        serverPubspecFile.writeAsStringSync('name: server');

        readyCalls = 0;
        launchFailed = Completer<FlutterAppConfig>();
        manager = FlutterAppManager(
          apps: [app],
          serverpodToolDir: p.join(serverDir.path, '.dart_tool', 'serverpod'),
          serverPubspecFile: serverPubspecFile,
          runMode: 'development',
          onProgress: (_, _) {},
          onReady: (_, _) => readyCalls++,
          onStart: (_, _) async {},
          onLaunchFailed: (app) => launchFailed.complete(app),
          onEnsureAppTab: (_) {},
          stdoutSinkFor: (_) => stdout,
          stderrSinkFor: (_) => stderr,
          flutterExecutableForTesting: _dartExecutable(),
          argsOverrideForTesting: (_) => [_shimPath('exits_during_build.dart')],
        );
        await manager.initialize();
      });

      tearDown(() async {
        await manager.dispose();
        await tempDir.delete(recursive: true);
      });

      test(
        'when launch is attempted then onLaunchFailed fires and onReady does not',
        () async {
          await manager.launch(app.id);

          // This future only completes when the app exits during the build and
          // the `onLaunchFailed` callback is invoked.
          final failedApp = await launchFailed.future.timeout(
            const Duration(seconds: 30),
          );

          expect(failedApp.id, app.id);
          expect(readyCalls, 0);
          expect(manager.isRunning(app.id), isFalse);
          expect(manager.isLaunching(app.id), isFalse);
        },
      );
    },
  );

  group('Given an initialized FlutterAppManager', () {
    late Directory tempDir;
    late Directory serverDir;
    late FlutterAppManager manager;
    late FlutterAppConfig appA;
    late FlutterAppConfig appB;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('flutter_mgr_reload_');
      serverDir = Directory(p.join(tempDir.path, 'project_server'))
        ..createSync(recursive: true);
      final flutterDirA = Directory(p.join(tempDir.path, 'app_a_flutter'))
        ..createSync(recursive: true);
      final flutterDirB = Directory(p.join(tempDir.path, 'app_b_flutter'))
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

      final serverPubspecFile = File(p.join(serverDir.path, 'pubspec.yaml'));
      serverPubspecFile.writeAsStringSync('name: server');

      manager = FlutterAppManager(
        apps: [appA, appB],
        serverpodToolDir: p.join(tempDir.path, '.serverpod'),
        serverPubspecFile: serverPubspecFile,
        runMode: 'development',
        onProgress: (_, _) {},
        onReady: (_, _) {},
        onStart: (_, _) async {},
        onLaunchFailed: (_) {},
        onEnsureAppTab: (_) {},
        stdoutSinkFor: (_) => stdout,
        stderrSinkFor: (_) => stderr,
      );
      await manager.initialize();
    });

    tearDown(() async {
      await manager.dispose();
      await tempDir.delete(recursive: true);
    });

    test(
      'when reloadApps is called with a subset of apps, '
      'then removed apps are stopped and new list is reflected',
      () async {
        expect(manager.apps.length, 2);

        await manager.reloadApps([appA]);

        expect(manager.isRunning(appB.id), isFalse);
        expect(manager.apps.length, 1);
        expect(manager.apps.first.id, 'app-a');
      },
    );

    test(
      'when reloadApps is called with additional apps, '
      'then new apps are added and old ones remain',
      () async {
        final flutterDirC = Directory(p.join(tempDir.path, 'app_c_flutter'))
          ..createSync(recursive: true);
        File(p.join(flutterDirC.path, 'pubspec.yaml')).writeAsStringSync('''
name: app_c
dependencies:
  flutter:
    sdk: flutter
''');
        final appC = _testApp(
          serverDir: serverDir,
          flutterDir: flutterDirC,
          id: 'app-c',
          name: 'App C',
        );

        expect(manager.apps.length, 2);

        await manager.reloadApps([appA, appB, appC]);

        expect(manager.apps.length, 3);
        expect(
          manager.apps.map((a) => a.id),
          containsAll(['app-a', 'app-b', 'app-c']),
        );
      },
    );

    test(
      'when reloadApps is called with the same apps, '
      'then the app list remains unchanged',
      () async {
        expect(manager.apps.length, 2);

        await manager.reloadApps([appA, appB]);

        expect(manager.apps.length, 2);
        expect(manager.apps.map((a) => a.id), containsAll(['app-a', 'app-b']));
      },
    );
  });
}
