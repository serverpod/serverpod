import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/flutter_app_manager.dart';
import 'package:serverpod_cli/src/commands/start/package_dependency_tracker.dart';
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

/// One fabricated Flutter app in a [_ManagerFixture].
class _AppSpec {
  const _AppSpec(
    this.id, {
    // `web-server` (no browser) so launches never spawn a real browser and
    // the VM-service connect waits without a timeout, as most manager tests
    // expect. Pass a desktop device (e.g. `linux`) for non-web scenarios.
    this.device = 'web-server',
  });

  final String id;
  final String device;

  /// Directory (and package) name of the fabricated Flutter app.
  String get dirName => '${id.replaceAll('-', '_')}_flutter';
}

/// Shared scaffolding for [FlutterAppManager] tests.
///
/// Builds a temp tree with a server package and one fabricated Flutter
/// package per [_AppSpec] - a directory whose pubspec.yaml carries the
/// `flutter: sdk: flutter` marker is all the manager needs; no real Flutter
/// project is involved. The server pubspec.yaml wires the apps up under
/// `serverpod: flutter_apps:`, and when a [shim] is given the manager's
/// `flutter` executable is replaced by that Dart script from
/// `flutter_shims/`, so launches speak the `--machine` protocol without
/// Flutter tooling. Callbacks default to no-ops; pass overrides to capture
/// events. Call [dispose] from tearDown.
class _ManagerFixture {
  _ManagerFixture._({
    required this.tempDir,
    required this.serverDir,
    required this.serverPubspecFile,
    required this.manager,
    required Map<String, Directory> flutterDirs,
    required HttpServer? fakeVmServer,
  }) : _flutterDirs = flutterDirs,
       _fakeVmServer = fakeVmServer;

  final Directory tempDir;
  final Directory serverDir;
  final File serverPubspecFile;
  final FlutterAppManager manager;
  final Map<String, Directory> _flutterDirs;
  final HttpServer? _fakeVmServer;

  static Future<_ManagerFixture> create({
    List<_AppSpec> apps = const [_AppSpec('project')],
    String? shim,
    List<String> shimArgs = const [],
    bool fakeVmService = false,
    bool initialize = true,
    void Function(FlutterAppConfig app, String stage)? onProgress,
    void Function(FlutterAppConfig app, String? url)? onReady,
    void Function(FlutterAppConfig app)? onStop,
    void Function(FlutterAppConfig app)? onLaunchFailed,
    void Function(FlutterAppConfig app)? onEnsureAppTab,
    IOSink Function(FlutterAppConfig app)? stdoutSinkFor,
    IOSink Function(FlutterAppConfig app)? stderrSinkFor,
  }) async {
    final tempDir = await Directory.systemTemp.createTemp('flutter_mgr_test_');
    final serverDir = Directory(p.join(tempDir.path, 'project_server'))
      ..createSync(recursive: true);

    final flutterDirs = <String, Directory>{
      for (final spec in apps)
        spec.id: _createFlutterPackage(tempDir, spec.dirName),
    };

    final appEntries = StringBuffer();
    for (final spec in apps) {
      appEntries.writeln('    ${spec.id}:');
      appEntries.writeln('      path: ../${spec.dirName}');
      appEntries.writeln('      device: ${spec.device}');
    }
    final serverPubspecFile = File(p.join(serverDir.path, 'pubspec.yaml'));
    serverPubspecFile.writeAsStringSync('''
name: project_server
serverpod:
  flutter_apps:
$appEntries''');

    HttpServer? fakeVmServer;
    final resolvedShimArgs = <String>[...shimArgs];
    if (fakeVmService) {
      final fake = await _startFakeVmService();
      fakeVmServer = fake.server;
      resolvedShimArgs.add('--ws=${fake.wsUri}');
    }

    final manager = FlutterAppManager(
      projectName: 'project',
      launchFlutterApp: false,
      serverPubspecFile: serverPubspecFile,
      serverPackageDirectoryPathParts: p.split(serverDir.path),
      serverpodToolDir: p.join(serverDir.path, '.dart_tool', 'serverpod'),
      runMode: 'development',
      onProgress: onProgress ?? (_, _) {},
      onReady: onReady ?? (_, _) {},
      onStart: (_, _) async {},
      onStop: onStop ?? (_) {},
      onLaunchFailed: onLaunchFailed ?? (_) {},
      onEnsureAppTab: onEnsureAppTab ?? (_) {},
      stdoutSinkFor: stdoutSinkFor ?? (_) => stdout,
      stderrSinkFor: stderrSinkFor ?? (_) => stderr,
      flutterExecutableForTesting: shim == null ? null : _dartExecutable(),
      argsOverrideForTesting: shim == null
          ? null
          : (_) => [_shimPath(shim), ...resolvedShimArgs],
    );

    if (initialize) await manager.initialize();

    return _ManagerFixture._(
      tempDir: tempDir,
      serverDir: serverDir,
      serverPubspecFile: serverPubspecFile,
      manager: manager,
      flutterDirs: flutterDirs,
      fakeVmServer: fakeVmServer,
    );
  }

  /// The fabricated Flutter package directory for [id].
  Directory flutterDir(String id) => _flutterDirs[id]!;

  /// A standalone config for [id], for calling manager members that take a
  /// [FlutterAppConfig] directly (only the id is significant).
  FlutterAppConfig appConfig(String id) => FlutterAppConfig(
    id: id,
    name: id,
    relativePathParts: ['..', '${id.replaceAll('-', '_')}_flutter'],
    serverPackageDirectoryPathParts: p.split(serverDir.path),
  );

  /// Fabricates an additional Flutter package (e.g. before rewriting the
  /// server pubspec to grow the `flutter_apps` config).
  Directory addFlutterPackage(String dirName) =>
      _createFlutterPackage(tempDir, dirName);

  static Directory _createFlutterPackage(Directory tempDir, String dirName) {
    final dir = Directory(p.join(tempDir.path, dirName))
      ..createSync(recursive: true);
    File(p.join(dir.path, 'pubspec.yaml')).writeAsStringSync('''
name: $dirName
dependencies:
  flutter:
    sdk: flutter
''');
    return dir;
  }

  Future<void> dispose() async {
    await manager.dispose();
    await _fakeVmServer?.close(force: true);
    await tempDir.delete(recursive: true);
  }
}

void main() {
  group('Given a FlutterAppManager with two configured apps', () {
    late _ManagerFixture f;
    late String launchedAppId;

    setUp(() async {
      launchedAppId = '';
      f = await _ManagerFixture.create(
        apps: const [_AppSpec('app-a'), _AppSpec('app-b')],
        shim: 'never_publishes_uri.dart',
        initialize: false,
        onEnsureAppTab: (app) => launchedAppId = app.id,
      );
    });

    tearDown(() => f.dispose());

    test(
      'when initialize is called then each app gets its own info file',
      () async {
        await f.manager.initialize();

        expect(
          File(
            p.join(
              f.serverDir.path,
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
              f.serverDir.path,
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
        await f.manager.initialize();
      });

      test(
        'when two apps are launched then both run concurrently',
        () async {
          await f.manager.launch('app-a');
          await f.manager.launch('app-b');

          expect(f.manager.isRunning('app-a'), isTrue);
          expect(f.manager.isRunning('app-b'), isTrue);
          expect(f.manager.runningAppIds, containsAll(['app-a', 'app-b']));
        },
      );

      test(
        'when launch is called then onEnsureAppTab is invoked',
        () async {
          await f.manager.launch('app-a');

          expect(launchedAppId, 'app-a');
        },
      );

      test(
        'when launch starts then isLaunching is true',
        () async {
          // `launch` flips the spawn-in-flight flag synchronously, before its
          // first await, so the app reads as launching the instant the call is
          // kicked off — no fixed wait needed. The shim never publishes a URL,
          // so it stays launching until torn down in tearDown.
          unawaited(f.manager.launch('app-a'));

          expect(f.manager.isLaunching('app-a'), isTrue);
          expect(f.manager.isLaunching('app-b'), isFalse);
        },
      );

      test(
        'when stopAll is called then running apps stop and info files are removed',
        () async {
          await f.manager.launch('app-a');
          final infoFile = p.join(
            f.serverDir.path,
            '.dart_tool',
            'serverpod',
            'flutter-vm-service-info-app-a.json',
          );
          expect(File(infoFile).existsSync(), isTrue);

          await f.manager.stopAll();

          expect(f.manager.isRunning('app-a'), isFalse);
          expect(File(infoFile).existsSync(), isFalse);
        },
      );

      test(
        'when stop is called then only that app stops and its info file remains',
        () async {
          await f.manager.launch('app-a');
          await f.manager.launch('app-b');
          final infoFile = p.join(
            f.serverDir.path,
            '.dart_tool',
            'serverpod',
            'flutter-vm-service-info-app-a.json',
          );

          await f.manager.stop('app-a');

          expect(f.manager.isRunning('app-a'), isFalse);
          expect(f.manager.isRunning('app-b'), isTrue);
          // Unlike stopAll, a single stop keeps the info file for relaunch.
          expect(File(infoFile).existsSync(), isTrue);
        },
      );

      test(
        'when stop is called for an unknown or stopped app then it is a no-op',
        () async {
          await f.manager.stop('does-not-exist');
          await f.manager.stop('app-a');

          expect(f.manager.isRunning('app-a'), isFalse);
        },
      );

      test(
        'when an app is stopped then its entry is dropped from dtdUris while '
        'others remain',
        () async {
          await f.manager.launch('app-a');
          await f.manager.launch('app-b');

          // The never_publishes_uri shim starts the process but never emits
          // app.dtd, so each running app maps to a null DTD URI. dtdUris backs
          // the get_flutter_app_dtd MCP tool.
          expect(f.manager.dtdUris, {'app-a': null, 'app-b': null});

          await f.manager.stop('app-a');

          // The stopped app is gone entirely, not merely mapped to null; the
          // still-running app is untouched.
          expect(f.manager.dtdUris, {'app-b': null});
          expect(f.manager.dtdUris.containsKey('app-a'), isFalse);
        },
      );

      test(
        'when changed paths are under one app lib then only that app id matches',
        () async {
          await f.manager.launch('app-a');
          await f.manager.launch('app-b');

          final adminPath = p.join(
            f.flutterDir('app-a').path,
            'lib',
            'main.dart',
          );
          expect(
            f.manager.appIdsForChangedPaths([adminPath]),
            {'app-a'},
          );
        },
      );
    });
  });

  group('Given a FlutterAppManager wired with per-app log sinks', () {
    late _ManagerFixture f;
    late Map<String, List<String>> sinkLines;

    setUp(() async {
      sinkLines = {'app-a': [], 'app-b': []};

      IOSink sinkFor(List<String> lines) {
        final controller = StreamController<List<int>>();
        controller.stream.listen((data) => lines.add(utf8.decode(data)));
        return IOSink(controller.sink);
      }

      f = await _ManagerFixture.create(
        apps: const [_AppSpec('app-a'), _AppSpec('app-b')],
        initialize: false,
        stdoutSinkFor: (app) => sinkFor(sinkLines[app.id]!),
        stderrSinkFor: (app) => sinkFor(sinkLines[app.id]!),
      );
    });

    tearDown(() => f.dispose());

    test(
      'when stdoutSinkFor is called then each app gets its own sink target',
      () async {
        f.manager.stdoutSinkFor(f.appConfig('app-a')).write('line-a\n');
        f.manager.stdoutSinkFor(f.appConfig('app-b')).write('line-b\n');
        await Future<void>.delayed(Duration.zero);

        expect(sinkLines['app-a'], ['line-a\n']);
        expect(sinkLines['app-b'], ['line-b\n']);
      },
    );
  });

  group(
    'Given an initialized FlutterAppManager running an app on a web device',
    () {
      late _ManagerFixture f;
      // Completed by onReady once the shim publishes its web URL, so the test
      // waits for exactly that event rather than a fixed duration.
      late Completer<String?> ready;
      // Completed by onStop.
      late Completer<void> stop;

      setUp(() async {
        ready = Completer<String?>();
        stop = Completer<void>();
        // The emits_machine_events shim plays the web-device daemon: it
        // publishes app.webLaunchUrl before app.debugPort and app.started.
        f = await _ManagerFixture.create(
          shim: 'emits_machine_events.dart',
          shimArgs: const ['--web-url=http://localhost:9999'],
          fakeVmService: true,
          onReady: (_, url) => ready.complete(url),
          onStop: (_) => stop.complete(),
        );
      });

      tearDown(() => f.dispose());

      test(
        'when launch completes then onReady receives the app URL',
        () async {
          await f.manager.launch('project');

          final readyUrl = await ready.future.timeout(
            const Duration(seconds: 30),
          );

          expect(readyUrl, 'http://localhost:9999');
          expect(f.manager.isRunning('project'), isTrue);
          expect(f.manager.isLaunching('project'), isFalse);
        },
      );

      group(
        'when the app is stopped',
        () {
          setUp(() async {
            await f.manager.launch('project');
            await ready.future.timeout(const Duration(seconds: 30));
            // onReady fires on the web URL, which the shim emits before app.dtd,
            // so wait until the DTD URI has been parsed too.
            await _eventually(() => f.manager.dtdUris['project'] != null);

            // The shim emits app.dtd, so the running app reports its DTD URI.
            expect(f.manager.dtdUris, {'project': 'ws://127.0.0.1:9100/ws'});

            await f.manager.stop('project');
          });

          test(
            'then its published DTD URI is no longer reported by dtdUris',
            () {
              // Stopping the app drops it from the map that backs the
              // get_flutter_app_dtd MCP tool, so its DTD URI is no longer returned.
              expect(f.manager.dtdUris, isEmpty);
            },
          );

          test('then onStop fires', () {
            expect(stop.future, completes);
          });
        },
      );
    },
  );

  group(
    'Given an initialized FlutterAppManager running an app on a desktop device',
    () {
      late _ManagerFixture f;
      // Completed by onReady; desktop devices never publish a web URL, so
      // the shim's app.started event is what must complete this.
      late Completer<String?> ready;
      late int readyCalls;

      setUp(() async {
        ready = Completer<String?>();
        readyCalls = 0;
        // The emits_desktop_machine_events shim plays the desktop-device
        // daemon: it publishes app.debugPort and app.started, but no
        // app.webLaunchUrl (that event is web-only).
        f = await _ManagerFixture.create(
          apps: const [_AppSpec('project', device: 'linux')],
          shim: 'emits_desktop_machine_events.dart',
          fakeVmService: true,
          onReady: (_, url) {
            readyCalls++;
            ready.complete(url);
          },
        );
      });

      tearDown(() => f.dispose());

      test(
        'when the app finishes launching then onReady fires once without a '
        'URL and the app is running, not launching',
        () async {
          await f.manager.launch('project');

          final readyUrl = await ready.future.timeout(
            const Duration(seconds: 30),
          );

          expect(readyUrl, isNull);
          expect(readyCalls, 1);
          expect(f.manager.isRunning('project'), isTrue);
          expect(f.manager.isLaunching('project'), isFalse);
        },
      );
    },
  );

  group(
    'Given an initialized FlutterAppManager whose app exits during the build',
    () {
      late _ManagerFixture f;
      late Completer<FlutterAppConfig> launchFailed;
      late int readyCalls;

      setUp(() async {
        readyCalls = 0;
        launchFailed = Completer<FlutterAppConfig>();
        f = await _ManagerFixture.create(
          shim: 'exits_during_build.dart',
          onReady: (_, _) => readyCalls++,
          onLaunchFailed: (app) => launchFailed.complete(app),
        );
      });

      tearDown(() => f.dispose());

      test(
        'when launch is attempted then onLaunchFailed fires and onReady does not',
        () async {
          await f.manager.launch('project');

          // This future only completes when the app exits during the build and
          // the `onLaunchFailed` callback is invoked.
          final failedApp = await launchFailed.future.timeout(
            const Duration(seconds: 30),
          );

          expect(failedApp.id, 'project');
          expect(readyCalls, 0);
          expect(f.manager.isRunning('project'), isFalse);
          expect(f.manager.isLaunching('project'), isFalse);
        },
      );
    },
  );

  group('Given an initialized FlutterAppManager', () {
    late _ManagerFixture f;

    setUp(() async {
      f = await _ManagerFixture.create(
        apps: const [_AppSpec('app-a'), _AppSpec('app-b')],
      );
    });

    tearDown(() => f.dispose());

    group('with an app removed from the flutter_apps config', () {
      setUp(() {
        f.serverPubspecFile.writeAsStringSync('''
name: project_server
serverpod:
  flutter_apps:
    app-a:
      path: ../app_a_flutter
''');
      });

      test(
        'when loadApps is called '
        'then the removed app is stopped and dropped from the app list',
        () async {
          expect(f.manager.apps.length, 2);

          await f.manager.loadApps();

          expect(f.manager.isRunning('app-b'), isFalse);
          expect(f.manager.apps.length, 1);
          expect(f.manager.apps.first.id, 'app-a');
        },
      );
    });

    group('with an additional app in the flutter_apps config', () {
      setUp(() {
        f.serverPubspecFile.writeAsStringSync('''
name: project_server
serverpod:
  flutter_apps:
    app-a:
      path: ../app_a_flutter
    app-b:
      path: ../app_b_flutter
    app-c:
      path: ../app_c_flutter
''');
        f.addFlutterPackage('app_c_flutter');
      });

      test(
        'when loadApps is called '
        'then the new app is added and existing ones remain',
        () async {
          expect(f.manager.apps.length, 2);

          await f.manager.loadApps();

          expect(f.manager.apps.length, 3);
          expect(
            f.manager.apps.map((a) => a.id),
            containsAll(['app-a', 'app-b', 'app-c']),
          );
        },
      );
    });

    test(
      'when loadApps is called without config changes '
      'then the app list is unchanged',
      () async {
        expect(f.manager.apps.length, 2);

        await f.manager.loadApps();

        expect(
          f.manager.apps.map((a) => a.id),
          containsAll(['app-a', 'app-b']),
        );
      },
    );
  });

  group(
    'Given an initialized FlutterAppManager before the Flutter resolution exists,',
    () {
      late _ManagerFixture f;

      setUp(() async {
        f = await _ManagerFixture.create();
      });

      tearDown(() => f.dispose());

      test(
        'when dependency changes are checked after the resolution is created, '
        'then dependency tracking is initialized.',
        () {
          expect(f.manager.dependencyTrackerFor('project'), isNull);

          final flutterDir = f.flutterDir('project');
          final dartToolDir = Directory(
            p.join(flutterDir.path, '.dart_tool'),
          )..createSync();
          File(
            p.join(dartToolDir.path, 'package_config.json'),
          ).writeAsStringSync('''
{"configVersion":2,"packages":[{"name":"project_flutter","rootUri":"../","packageUri":"lib/"}]}
''');
          File(
            p.join(dartToolDir.path, 'package_graph.json'),
          ).writeAsStringSync(
            '''
{"roots":["project_flutter"],"packages":[{"name":"project_flutter","version":"1.0.0","dependencies":[]}]}
''',
          );

          expect(
            f.manager.checkDependencyChange('project'),
            PackageDependencyChange.none,
          );
          expect(f.manager.dependencyTrackerFor('project'), isNotNull);
        },
      );
    },
  );
}
