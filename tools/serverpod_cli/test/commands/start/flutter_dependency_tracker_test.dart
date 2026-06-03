import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/flutter_dependency_tracker.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late String dartToolDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('flutter_dep_tracker_');
    dartToolDir = p.join(tempDir.path, '.dart_tool');
    await Directory(dartToolDir).create();
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  void writeGraph(Map<String, dynamic> graph) {
    File(
      p.join(dartToolDir, 'package_graph.json'),
    ).writeAsStringSync(jsonEncode(graph));
  }

  Map<String, dynamic> packageNamed(Map<String, dynamic> graph, String name) {
    return (graph['packages'] as List).cast<Map<String, dynamic>>().firstWhere(
      (pkg) => pkg['name'] == name,
    );
  }

  /// Creates a fake package source directory holding [pubspec], returning its
  /// rootUri relative to the `.dart_tool` directory.
  String writePackage(String name, String pubspec) {
    final dir = Directory(p.join(tempDir.path, 'pkgs', name))
      ..createSync(recursive: true);
    File(p.join(dir.path, 'pubspec.yaml')).writeAsStringSync(pubspec);
    return '../pkgs/$name';
  }

  void writePackageConfig(Map<String, String> rootUris) {
    File(p.join(dartToolDir, 'package_config.json')).writeAsStringSync(
      jsonEncode({
        'configVersion': 2,
        'packages': [
          for (final entry in rootUris.entries)
            {'name': entry.key, 'rootUri': entry.value, 'packageUri': 'lib/'},
        ],
      }),
    );
  }

  // A Flutter app that transitively depends on the client (and http) but not
  // the server. flutter_test is a dev dependency only.
  Map<String, dynamic> baseGraph() => {
    'roots': ['app_flutter', 'app_server', 'app_client'],
    'packages': [
      {
        'name': 'app_flutter',
        'version': '1.0.0',
        'dependencies': ['app_client', 'http'],
        'devDependencies': ['flutter_test'],
      },
      {
        'name': 'app_client',
        'version': '1.0.0',
        'dependencies': ['http'],
      },
      {
        'name': 'app_server',
        'version': '1.0.0',
        'dependencies': ['postgres'],
      },
      {'name': 'http', 'version': '1.2.0', 'dependencies': <String>[]},
      {'name': 'postgres', 'version': '3.0.0', 'dependencies': <String>[]},
      {'name': 'flutter_test', 'version': '0.0.0', 'dependencies': <String>[]},
    ],
  };

  /// Pure-Dart source dirs + package_config for the app's closure packages.
  Map<String, String> closureRootUris() => {
    'app_flutter': writePackage('app_flutter', 'name: app_flutter\n'),
    'app_client': writePackage('app_client', 'name: app_client\n'),
    'http': writePackage('http', 'name: http\n'),
  };

  group(
    'Given a Flutter app dependency graph of pure-Dart packages '
    'in a workspace,',
    () {
      late FlutterDependencyTracker tracker;

      setUp(() {
        writeGraph(baseGraph());
        writePackageConfig(closureRootUris());
        tracker = FlutterDependencyTracker(
          dartToolDir: dartToolDir,
          flutterPackageName: 'app_flutter',
        );
      });

      test(
        'when a server-only dependency version changes, '
        'then no change is reported',
        () {
          final graph = baseGraph();
          packageNamed(graph, 'postgres')['version'] = '3.1.0';
          writeGraph(graph);

          expect(tracker.refresh(), FlutterDependencyChange.none);
        },
      );

      test(
        'when a dependency inside the app closure changes version, '
        'then a pure-Dart change is reported',
        () {
          final graph = baseGraph();
          packageNamed(graph, 'http')['version'] = '1.3.0';
          writeGraph(graph);

          expect(tracker.refresh(), FlutterDependencyChange.dartOnly);
        },
      );

      test(
        'when a pure-Dart dependency is added to the app, '
        'then a pure-Dart change is reported',
        () {
          final graph = baseGraph();
          (packageNamed(graph, 'app_flutter')['dependencies'] as List).add(
            'redis',
          );
          (graph['packages'] as List).add({
            'name': 'redis',
            'version': '1.0.0',
            'dependencies': <String>[],
          });
          writeGraph(graph);
          writePackageConfig({
            ...closureRootUris(),
            'redis': writePackage('redis', 'name: redis\n'),
          });

          expect(tracker.refresh(), FlutterDependencyChange.dartOnly);
        },
      );

      test(
        'when a dependency is removed from the app, '
        'then a pure-Dart change is reported',
        () {
          // Stale native code in the running binary is harmless, so removals
          // never require more than a hot restart.
          final graph = baseGraph();
          packageNamed(graph, 'app_flutter')['dependencies'] = ['http'];
          writeGraph(graph);

          expect(tracker.refresh(), FlutterDependencyChange.dartOnly);
        },
      );

      test(
        'when a dev dependency of the app changes, '
        'then no change is reported',
        () {
          final graph = baseGraph();
          packageNamed(graph, 'flutter_test')['version'] = '0.1.0';
          writeGraph(graph);

          expect(tracker.refresh(), FlutterDependencyChange.none);
        },
      );

      test(
        'when the graph is rewritten with identical contents, '
        'then no change is reported',
        () {
          writeGraph(baseGraph());

          expect(tracker.refresh(), FlutterDependencyChange.none);
        },
      );
    },
  );

  /// Sets up an app depending on a single package `dep@1.0.0` (described by
  /// [depPubspec]), then bumps it to 1.0.1 in the graph so the next
  /// `refresh()` classifies the bump.
  FlutterDependencyTracker prepareBumpedDependency({
    required String depPubspec,
    bool listedInPackageConfig = true,
    bool withBuildHook = false,
  }) {
    Map<String, dynamic> graph(String version) => {
      'roots': ['app_flutter'],
      'packages': [
        {
          'name': 'app_flutter',
          'version': '1.0.0',
          'dependencies': ['dep'],
        },
        {'name': 'dep', 'version': version, 'dependencies': <String>[]},
      ],
    };

    final depRoot = writePackage('dep', depPubspec);
    if (withBuildHook) {
      final hookDir = Directory(p.join(tempDir.path, 'pkgs', 'dep', 'hook'))
        ..createSync(recursive: true);
      File(
        p.join(hookDir.path, 'build.dart'),
      ).writeAsStringSync('void main() {}');
    }
    writePackageConfig({
      'app_flutter': writePackage('app_flutter', 'name: app_flutter\n'),
      if (listedInPackageConfig) 'dep': depRoot,
    });

    writeGraph(graph('1.0.0'));
    final tracker = FlutterDependencyTracker(
      dartToolDir: dartToolDir,
      flutterPackageName: 'app_flutter',
    );
    writeGraph(graph('1.0.1'));
    return tracker;
  }

  group('Given a changed app dependency declaring a native plugin class,', () {
    test(
      'when the closure is refreshed, '
      'then a native change is reported',
      () {
        final tracker = prepareBumpedDependency(
          depPubspec:
              'name: dep\n'
              'flutter:\n'
              '  plugin:\n'
              '    platforms:\n'
              '      android:\n'
              '        package: com.example.dep\n'
              '        pluginClass: DepPlugin\n',
        );

        expect(tracker.refresh(), FlutterDependencyChange.native);
      },
    );
  });

  group('Given a changed app dependency declaring an FFI plugin,', () {
    test(
      'when the closure is refreshed, '
      'then a native change is reported',
      () {
        final tracker = prepareBumpedDependency(
          depPubspec:
              'name: dep\n'
              'flutter:\n'
              '  plugin:\n'
              '    platforms:\n'
              '      windows:\n'
              '        ffiPlugin: true\n',
        );

        expect(tracker.refresh(), FlutterDependencyChange.native);
      },
    );
  });

  group(
    'Given a changed app dependency declaring only a Dart plugin class,',
    () {
      test(
        'when the closure is refreshed, '
        'then a pure-Dart change is reported',
        () {
          final tracker = prepareBumpedDependency(
            depPubspec:
                'name: dep\n'
                'flutter:\n'
                '  plugin:\n'
                '    platforms:\n'
                '      linux:\n'
                '        dartPluginClass: DepPluginLinux\n',
          );

          expect(tracker.refresh(), FlutterDependencyChange.dartOnly);
        },
      );
    },
  );

  group('Given a changed app dependency with "pluginClass: none",', () {
    test(
      'when the closure is refreshed, '
      'then a pure-Dart change is reported',
      () {
        final tracker = prepareBumpedDependency(
          depPubspec:
              'name: dep\n'
              'flutter:\n'
              '  plugin:\n'
              '    platforms:\n'
              '      web:\n'
              '        pluginClass: none\n',
        );

        expect(tracker.refresh(), FlutterDependencyChange.dartOnly);
      },
    );
  });

  group('Given a changed app dependency with a native-assets build hook,', () {
    test(
      'when the closure is refreshed, '
      'then a native change is reported',
      () {
        final tracker = prepareBumpedDependency(
          depPubspec: 'name: dep\n',
          withBuildHook: true,
        );

        expect(tracker.refresh(), FlutterDependencyChange.native);
      },
    );
  });

  group('Given a changed app dependency missing from package_config.json,', () {
    test(
      'when the closure is refreshed, '
      'then a native change is conservatively reported',
      () {
        final tracker = prepareBumpedDependency(
          depPubspec: 'name: dep\n',
          listedInPackageConfig: false,
        );

        expect(tracker.refresh(), FlutterDependencyChange.native);
      },
    );
  });

  group('Given a changed app dependency with an unreadable pubspec,', () {
    test(
      'when the closure is refreshed, '
      'then a native change is conservatively reported',
      () {
        final tracker = prepareBumpedDependency(
          depPubspec: 'name: [unclosed\n  flutter: {',
        );

        expect(tracker.refresh(), FlutterDependencyChange.native);
      },
    );
  });

  group('Given a missing or malformed dependency graph,', () {
    test(
      'when the graph file is absent, '
      'then no change is reported',
      () {
        // No graph written.
        final tracker = FlutterDependencyTracker(
          dartToolDir: dartToolDir,
          flutterPackageName: 'app_flutter',
        );

        expect(tracker.refresh(), FlutterDependencyChange.none);
      },
    );

    test(
      'when the graph file is malformed, '
      'then no change is reported',
      () {
        File(
          p.join(dartToolDir, 'package_graph.json'),
        ).writeAsStringSync('{ not valid json');

        final tracker = FlutterDependencyTracker(
          dartToolDir: dartToolDir,
          flutterPackageName: 'app_flutter',
        );

        expect(tracker.refresh(), FlutterDependencyChange.none);
      },
    );

    test(
      'when the Flutter package is absent from the graph, '
      'then no change is reported',
      () {
        writeGraph(baseGraph());

        final tracker = FlutterDependencyTracker(
          dartToolDir: dartToolDir,
          flutterPackageName: 'not_in_graph',
        );

        expect(tracker.refresh(), FlutterDependencyChange.none);
      },
    );

    test(
      'when the graph disappears then reappears unchanged, '
      'then no change is reported',
      () {
        writeGraph(baseGraph());
        final tracker = FlutterDependencyTracker(
          dartToolDir: dartToolDir,
          flutterPackageName: 'app_flutter',
        );

        // Simulate a transient state (e.g. mid-pub-get / flutter clean): the
        // file vanishes and is then recreated with identical contents.
        File(p.join(dartToolDir, 'package_graph.json')).deleteSync();
        expect(tracker.refresh(), FlutterDependencyChange.none);

        writeGraph(baseGraph());
        expect(tracker.refresh(), FlutterDependencyChange.none);
      },
    );
  });

  group('Given a Flutter package directory in a workspace,', () {
    test(
      'when resolving its .dart_tool, '
      'then it resolves to the workspace root .dart_tool',
      () async {
        final root = await Directory(
          p.join(tempDir.path, 'workspace'),
        ).create();
        await Directory(p.join(root.path, '.dart_tool')).create();
        await File(
          p.join(root.path, '.dart_tool', 'package_config.json'),
        ).writeAsString('{}');
        // Member package with no resolution of its own.
        final member = await Directory(
          p.join(root.path, 'app_flutter'),
        ).create();

        final resolved = FlutterDependencyTracker.resolveDartToolDir(
          member.path,
        );

        expect(resolved, p.join(root.path, '.dart_tool'));
      },
    );
  });

  group('Given a standalone (non-workspace) Flutter package directory,', () {
    test(
      'when resolving its .dart_tool, '
      'then it resolves to the package\'s own .dart_tool',
      () async {
        final pkg = await Directory(
          p.join(tempDir.path, 'standalone'),
        ).create();
        await Directory(p.join(pkg.path, '.dart_tool')).create();
        await File(
          p.join(pkg.path, '.dart_tool', 'package_config.json'),
        ).writeAsString('{}');

        final resolved = FlutterDependencyTracker.resolveDartToolDir(pkg.path);

        expect(resolved, p.join(pkg.path, '.dart_tool'));
      },
    );

    test(
      'when no resolution exists in any ancestor, '
      'then it resolves to null',
      () async {
        final pkg = await Directory(
          p.join(tempDir.path, 'unresolved'),
        ).create();

        final resolved = FlutterDependencyTracker.resolveDartToolDir(pkg.path);

        expect(resolved, isNull);
      },
    );
  });
}
