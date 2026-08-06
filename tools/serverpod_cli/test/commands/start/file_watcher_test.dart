import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('file_watcher_test_');
    // Create the lib directory.
    await Directory(p.join(tempDir.path, 'lib')).create();
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('Given a FileWatcher watching a directory', () {
    late FileWatcher watcher;

    setUp(() {
      watcher = FileWatcher(
        watchPaths: [p.join(tempDir.path, 'lib')],
        debounceDelay: const Duration(milliseconds: 200),
      );
    });

    test(
      'when a .dart file is created, '
      'then it emits a FileChangeEvent with the file in dartFiles',
      () async {
        final firstEvent = watcher.onFilesChanged.first;
        await watcher.ready;

        await File(
          p.join(tempDir.path, 'lib', 'test_file.dart'),
        ).writeAsString('// test');

        final event = await firstEvent;

        expect(event.dartFiles, isNotEmpty);
        expect(event.dartFiles.first, contains('test_file.dart'));
        expect(event.modelFiles, isEmpty);
        expect(event.packageConfigChanged, isFalse);
      },
    );

    test(
      'when a .spy.yaml file is created, '
      'then it emits a FileChangeEvent with the file in modelFiles',
      () async {
        final firstEvent = watcher.onFilesChanged.first;
        await watcher.ready;

        await File(
          p.join(tempDir.path, 'lib', 'model.spy.yaml'),
        ).writeAsString('class: MyModel');

        final event = await firstEvent;

        expect(event.modelFiles, isNotEmpty);
        expect(event.modelFiles.first, contains('model.spy.yaml'));
        expect(event.dartFiles, isEmpty);
      },
    );
  });

  group(
    'Given a FileWatcher watching a directory with generated subdirectory',
    () {
      late FileWatcher watcher;
      late String generatedDir;

      setUp(() async {
        generatedDir = p.join(tempDir.path, 'lib', 'src', 'generated');
        await Directory(generatedDir).create(recursive: true);

        watcher = FileWatcher(
          watchPaths: [p.join(tempDir.path, 'lib')],
          debounceDelay: const Duration(milliseconds: 200),
        );
      });

      test(
        'when a file in a generated directory is created, '
        'then it is emitted as a dart file change',
        () async {
          final firstEvent = watcher.onFilesChanged.first;
          await watcher.ready;

          await File(
            p.join(generatedDir, 'generated.dart'),
          ).writeAsString('// generated');

          final event = await firstEvent;

          expect(event.dartFiles, isNotEmpty);
          expect(event.dartFiles.first, contains('generated.dart'));
        },
      );
    },
  );

  group('Given a FileWatcher tracking a missing pub artifact,', () {
    late File packageGraph;
    late FileWatcher watcher;

    setUp(() async {
      final dartToolDir = p.join(tempDir.path, '.dart_tool');
      await Directory(dartToolDir).create();
      packageGraph = File(p.join(dartToolDir, 'package_graph.json'));
      watcher = FileWatcher(
        watchPaths: [packageGraph.path],
        packageGraphPaths: [packageGraph.path],
        debounceDelay: const Duration(milliseconds: 50),
        missingFilePollingDelay: const Duration(milliseconds: 20),
      );
    });

    test(
      'when the artifact is created, '
      'then it emits a Flutter dependency change.',
      () async {
        final firstEvent = watcher.onFilesChanged.first;
        await watcher.ready;

        await packageGraph.writeAsString('{"roots":[],"packages":[]}');

        final event = await firstEvent.timeout(const Duration(seconds: 3));
        expect(event.flutterDependenciesChanged, isTrue);
      },
    );
  });

  group('Given a FileWatcher tracking an existing pub artifact,', () {
    late File packageGraph;
    late FileWatcher watcher;

    setUp(() async {
      final dartToolDir = p.join(tempDir.path, '.dart_tool');
      await Directory(dartToolDir).create();
      packageGraph = File(p.join(dartToolDir, 'package_graph.json'));
      await packageGraph.writeAsString('{"roots":[],"packages":[]}');
      watcher = FileWatcher(
        watchPaths: [packageGraph.path],
        packageGraphPaths: [packageGraph.path],
        debounceDelay: const Duration(milliseconds: 50),
        missingFilePollingDelay: const Duration(milliseconds: 20),
      );
    });

    test(
      'when the artifact is deleted and recreated, '
      'then subsequent changes continue to emit Flutter dependency changes.',
      () async {
        final events = StreamIterator(watcher.onFilesChanged);
        addTearDown(events.cancel);
        var nextEvent = events.moveNext();
        await watcher.ready;

        await packageGraph.delete();
        expect(
          await nextEvent.timeout(const Duration(seconds: 3)),
          isTrue,
        );
        expect(events.current.flutterDependenciesChanged, isTrue);

        nextEvent = events.moveNext();
        await packageGraph.writeAsString('{"roots":[],"packages":[]}');
        expect(
          await nextEvent.timeout(const Duration(seconds: 3)),
          isTrue,
        );
        expect(events.current.flutterDependenciesChanged, isTrue);

        nextEvent = events.moveNext();
        await packageGraph.writeAsString(
          '{"roots":[],"packages":[{"name":"new_dependency"}]}',
        );
        expect(
          await nextEvent.timeout(const Duration(seconds: 3)),
          isTrue,
        );
        expect(events.current.flutterDependenciesChanged, isTrue);
      },
    );
  });

  group('Given a FileWatcher watching a .dart_tool directory', () {
    late FileWatcher watcher;
    late String dartToolDir;

    setUp(() async {
      dartToolDir = p.join(tempDir.path, '.dart_tool');
      await Directory(dartToolDir).create();

      watcher = FileWatcher(
        watchPaths: [dartToolDir],
        packageConfigPath: p.join(dartToolDir, 'package_config.json'),
        packageGraphPaths: [p.join(dartToolDir, 'package_graph.json')],
        debounceDelay: const Duration(milliseconds: 200),
      );
    });

    test(
      'when package_graph.json changes, '
      'then it emits a FileChangeEvent with only flutterDependenciesChanged set',
      () async {
        final firstEvent = watcher.onFilesChanged.first;
        await watcher.ready;

        await File(
          p.join(dartToolDir, 'package_graph.json'),
        ).writeAsString('{"roots":[],"packages":[]}');

        final event = await firstEvent;

        expect(event.flutterDependenciesChanged, isTrue);
        // The Flutter-only scope: package_graph changes must not drive the
        // server FES restart, and .dart_tool churn is not a static change.
        expect(event.packageConfigChanged, isFalse);
        expect(event.staticFilesChanged, isFalse);
        expect(event.dartFiles, isEmpty);
      },
    );

    test(
      'when package_config.json changes, '
      'then it emits a FileChangeEvent with only packageConfigChanged set',
      () async {
        final firstEvent = watcher.onFilesChanged.first;
        await watcher.ready;

        await File(
          p.join(dartToolDir, 'package_config.json'),
        ).writeAsString('{"configVersion":2,"packages":[]}');

        final event = await firstEvent;

        expect(event.packageConfigChanged, isTrue);
        expect(event.flutterDependenciesChanged, isFalse);
        expect(event.staticFilesChanged, isFalse);
        expect(event.dartFiles, isEmpty);
      },
    );

    test(
      'when package_config and package_graph change alongside other .dart_tool files, '
      'then only packageConfigChanged and flutterDependenciesChanged are set',
      () async {
        final firstEvent = watcher.onFilesChanged.first;
        await watcher.ready;

        // A `pub get` rewrites both pub artifacts within one debounce window
        await File(
          p.join(dartToolDir, 'package_config.json'),
        ).writeAsString('{"configVersion":2,"packages":[]}');
        await File(
          p.join(dartToolDir, 'package_graph.json'),
        ).writeAsString('{"roots":[],"packages":[]}');

        final event = await firstEvent;

        expect(event.packageConfigChanged, isTrue);
        expect(event.flutterDependenciesChanged, isTrue);
        expect(event.staticFilesChanged, isFalse);
      },
    );
  });

  group('Given separate server and Flutter .dart_tool directories', () {
    late FileWatcher watcher;
    late String serverDartTool;
    late String flutterDartTool;

    setUp(() async {
      serverDartTool = p.join(tempDir.path, 'server', '.dart_tool');
      flutterDartTool = p.join(tempDir.path, 'flutter', '.dart_tool');
      await Directory(serverDartTool).create(recursive: true);
      await Directory(flutterDartTool).create(recursive: true);

      watcher = FileWatcher(
        watchPaths: [serverDartTool, flutterDartTool],
        packageConfigPath: p.join(serverDartTool, 'package_config.json'),
        packageGraphPaths: [p.join(flutterDartTool, 'package_graph.json')],
        debounceDelay: const Duration(milliseconds: 200),
      );
    });

    test(
      "when the Flutter app's package_config.json changes, "
      'then it does not trigger a server reload',
      () async {
        final firstEvent = watcher.onFilesChanged.first;
        await watcher.ready;

        // A `pub get` in the Flutter app rewrites its own pub artifacts.
        await File(
          p.join(flutterDartTool, 'package_config.json'),
        ).writeAsString('{"configVersion":2,"packages":[]}');
        await File(
          p.join(flutterDartTool, 'package_graph.json'),
        ).writeAsString('{"roots":[],"packages":[]}');

        final event = await firstEvent;

        expect(event.flutterDependenciesChanged, isTrue);
        expect(
          event.packageConfigChanged,
          isFalse,
          reason: "the Flutter app's package_config must not reload the server",
        );
      },
    );

    test(
      "when the server's package_graph.json changes, "
      'then it does not trigger the Flutter dependency check',
      () async {
        final firstEvent = watcher.onFilesChanged.first;
        await watcher.ready;

        await File(
          p.join(serverDartTool, 'package_config.json'),
        ).writeAsString('{"configVersion":2,"packages":[]}');
        await File(
          p.join(serverDartTool, 'package_graph.json'),
        ).writeAsString('{"roots":[],"packages":[]}');

        final event = await firstEvent;

        expect(event.packageConfigChanged, isTrue);
        expect(
          event.flutterDependenciesChanged,
          isFalse,
          reason: "the server's package_graph must not refresh the Flutter app",
        );
      },
    );
  });

  group('Given multiple Flutter app resolutions (non-workspace layout)', () {
    late FileWatcher watcher;
    late String serverDartTool;
    late String appADartTool;
    late String appBDartTool;

    setUp(() async {
      serverDartTool = p.join(tempDir.path, 'server', '.dart_tool');
      appADartTool = p.join(tempDir.path, 'app_a', '.dart_tool');
      appBDartTool = p.join(tempDir.path, 'app_b', '.dart_tool');
      for (final dir in [serverDartTool, appADartTool, appBDartTool]) {
        await Directory(dir).create(recursive: true);
      }

      watcher = FileWatcher(
        watchPaths: [serverDartTool, appADartTool, appBDartTool],
        packageConfigPath: p.join(serverDartTool, 'package_config.json'),
        packageGraphPaths: [
          p.join(appADartTool, 'package_graph.json'),
          p.join(appBDartTool, 'package_graph.json'),
        ],
        debounceDelay: const Duration(milliseconds: 200),
      );
    });

    test(
      "when any tracked Flutter app's package_graph.json changes, "
      'then it sets flutterDependenciesChanged',
      () async {
        final firstEvent = watcher.onFilesChanged.first;
        await watcher.ready;

        await File(
          p.join(appBDartTool, 'package_graph.json'),
        ).writeAsString('{"roots":[],"packages":[]}');

        final event = await firstEvent;

        expect(event.flutterDependenciesChanged, isTrue);
        expect(event.packageConfigChanged, isFalse);
      },
    );
  });

  group('Given a list of FileChangeEvents', () {
    test(
      'when merge is called on a single event, '
      'then it returns it unchanged',
      () {
        final event = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
          modelFiles: {'/models/m.spy.yaml'},
          packageConfigChanged: true,
        );
        final result = [event].merge();
        expect(identical(result, event), isTrue);
      },
    );

    test(
      'when merge is called on multiple events, '
      'then it merges all fields',
      () {
        final e1 = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
          modelFiles: {'/models/m1.spy.yaml'},
        );
        final e2 = FileChangeEvent(
          dartFiles: {'/lib/b.dart', '/lib/c.dart'},
          staticFilesChanged: true,
        );
        final result = [e1, e2].merge();
        expect(result.dartFiles, {'/lib/a.dart', '/lib/b.dart', '/lib/c.dart'});
        expect(result.modelFiles, {'/models/m1.spy.yaml'});
        expect(result.staticFilesChanged, isTrue);
      },
    );

    test(
      'when merge is called on events with the same file, '
      'then it appears only once',
      () {
        final e1 = FileChangeEvent(dartFiles: {'/lib/a.dart'});
        final e2 = FileChangeEvent(dartFiles: {'/lib/a.dart'});
        final result = [e1, e2].merge();
        expect(result.dartFiles, {'/lib/a.dart'});
      },
    );

    test(
      'when merge is called on events where one has packageConfigChanged, '
      'then result has packageConfigChanged true',
      () {
        final e1 = FileChangeEvent(dartFiles: {});
        final e2 = FileChangeEvent(dartFiles: {}, packageConfigChanged: true);
        final result = [e1, e2].merge();
        expect(result.packageConfigChanged, isTrue);
      },
    );

    test(
      'when merge is called on events where one has flutterDependenciesChanged, '
      'then result has flutterDependenciesChanged true',
      () {
        final e1 = FileChangeEvent(dartFiles: {});
        final e2 = FileChangeEvent(
          dartFiles: {},
          flutterDependenciesChanged: true,
        );
        final result = [e1, e2].merge();
        expect(result.flutterDependenciesChanged, isTrue);
      },
    );
  });

  group(
    'Given a FileWatcher watching a pubspec.yaml file',
    () {
      late FileWatcher watcher;
      late File pubspec;

      setUp(() async {
        final path = p.join(tempDir.path, 'pubspec.yaml');
        pubspec = File(path);
        await pubspec.create();

        watcher = FileWatcher(
          watchPaths: [path],
          debounceDelay: const Duration(milliseconds: 200),
        );
      });

      test(
        'when the file changes, '
        'then it emits a FileChangeEvent with only pubspecChanged set',
        () async {
          final firstEvent = watcher.onFilesChanged.first;
          await watcher.ready;

          await pubspec.writeAsString('name: example');

          final event = await firstEvent;

          expect(event.pubspecChanged, isTrue);
          expect(event.flutterDependenciesChanged, isFalse);
          expect(event.packageConfigChanged, isFalse);
          expect(event.staticFilesChanged, isFalse);
          expect(event.dartFiles, isEmpty);
        },
      );
    },
  );
}
