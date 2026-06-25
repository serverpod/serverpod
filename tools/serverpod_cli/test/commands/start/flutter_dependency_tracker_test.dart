import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/flutter_dependency_tracker.dart';
import 'package:serverpod_cli/src/commands/start/package_dependency_tracker.dart';
import 'package:test/test.dart';

/// Runs a real `dart pub get` in [dir]. Fixtures use only path and workspace
/// dependencies, so resolution works offline and the tests exercise the actual
/// `package_graph.json` and `package_config.json` files pub generates.
Future<void> _pubGet(String dir) async {
  final result = await Process.run(Platform.resolvedExecutable, [
    'pub',
    'get',
    '--offline',
  ], workingDirectory: dir);
  if (result.exitCode != 0) {
    fail('pub get failed in $dir:\n${result.stdout}\n${result.stderr}');
  }
}

String _pubspec(
  String name, {
  String version = '1.0.0',
  List<String>? workspace,
  bool workspaceMember = false,
  Map<String, String> deps = const {},
  Map<String, String> devDeps = const {},
  String? flutterBlock,
}) {
  final buffer = StringBuffer()
    ..writeln('name: $name')
    ..writeln('version: $version')
    ..writeln('environment:')
    ..writeln('  sdk: ^3.6.0');
  if (workspace != null) {
    buffer.writeln('workspace:');
    for (final member in workspace) {
      buffer.writeln('  - $member');
    }
  }
  if (workspaceMember) buffer.writeln('resolution: workspace');
  if (deps.isNotEmpty) {
    buffer.writeln('dependencies:');
    deps.forEach((dep, path) {
      buffer
        ..writeln('  $dep:')
        ..writeln('    path: $path');
    });
  }
  if (devDeps.isNotEmpty) {
    buffer.writeln('dev_dependencies:');
    devDeps.forEach((dep, path) {
      buffer
        ..writeln('  $dep:')
        ..writeln('    path: $path');
    });
  }
  if (flutterBlock != null) buffer.writeln(flutterBlock);
  return buffer.toString();
}

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('flutter_dep_tracker_');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  void write(String path, String contents) {
    File(path)
      ..createSync(recursive: true)
      ..writeAsStringSync(contents);
  }

  // ---------------------------------------------------------------------
  // Real-resolution fixtures: a workspace whose dependency files are
  // produced by an actual `pub get`, mirroring generated Serverpod projects.
  // Layout: app_flutter -> app_client -> dep_pure (transitive), app_server ->
  // dep_server_only, and dep_dev as a dev dependency of the app. Third-party
  // packages live outside the workspace and are wired up as path deps.
  // ---------------------------------------------------------------------

  late String wsDir;

  void writeThirdParty(
    String name, {
    String version = '1.0.0',
    String? flutterBlock,
  }) {
    write(
      p.join(tempDir.path, 'third_party', name, 'pubspec.yaml'),
      _pubspec(name, version: version, flutterBlock: flutterBlock),
    );
  }

  void writeAppFlutterPubspec({
    Map<String, String>? deps,
    String? flutterBlock,
  }) {
    write(
      p.join(wsDir, 'app_flutter', 'pubspec.yaml'),
      _pubspec(
        'app_flutter',
        workspaceMember: true,
        deps: deps ?? {'app_client': '../app_client'},
        devDeps: {'dep_dev': '../../third_party/dep_dev'},
        flutterBlock: flutterBlock,
      ),
    );
  }

  Future<FlutterDependencyTracker> createWorkspaceTracker({
    String? appPubspecFlutterBlock,
  }) async {
    wsDir = p.join(tempDir.path, 'ws');
    writeThirdParty('dep_pure');
    writeThirdParty('dep_dev');
    writeThirdParty('dep_server_only');
    write(
      p.join(wsDir, 'pubspec.yaml'),
      _pubspec(
        'fixture_root',
        workspace: ['app_flutter', 'app_client', 'app_server'],
      ),
    );
    writeAppFlutterPubspec(flutterBlock: appPubspecFlutterBlock);
    write(
      p.join(wsDir, 'app_client', 'pubspec.yaml'),
      _pubspec(
        'app_client',
        workspaceMember: true,
        deps: {'dep_pure': '../../third_party/dep_pure'},
      ),
    );
    write(
      p.join(wsDir, 'app_server', 'pubspec.yaml'),
      _pubspec(
        'app_server',
        workspaceMember: true,
        deps: {'dep_server_only': '../../third_party/dep_server_only'},
      ),
    );
    await _pubGet(wsDir);
    return FlutterDependencyTracker(
      dartToolDir: p.join(wsDir, '.dart_tool'),
      flutterPackageName: 'app_flutter',
      flutterPackageDir: p.join(wsDir, 'app_flutter'),
    );
  }

  group('Given a real pub workspace with a Flutter app,', () {
    late FlutterDependencyTracker tracker;

    setUp(() async {
      tracker = await createWorkspaceTracker();
    });

    test(
      'when a server-only dependency version changes, '
      'then no change is reported',
      () async {
        writeThirdParty('dep_server_only', version: '1.0.1');
        await _pubGet(wsDir);

        expect(tracker.refresh(), PackageDependencyChange.none);
      },
    );

    test(
      'when a transitive dependency of the app changes version, '
      'then a pure-Dart change is reported',
      () async {
        // dep_pure is reached only through app_client.
        writeThirdParty('dep_pure', version: '1.0.1');
        await _pubGet(wsDir);

        expect(tracker.refresh(), PackageDependencyChange.dartOnly);
      },
    );

    test(
      'when a pure-Dart dependency is added to the app, '
      'then a pure-Dart change is reported',
      () async {
        writeThirdParty('dep_added');
        writeAppFlutterPubspec(
          deps: {
            'app_client': '../app_client',
            'dep_added': '../../third_party/dep_added',
          },
        );
        await _pubGet(wsDir);

        expect(tracker.refresh(), PackageDependencyChange.dartOnly);
      },
    );

    test(
      'when a dependency is removed from the app, '
      'then a pure-Dart change is reported',
      () async {
        // Stale native code in the running binary is harmless, so removals
        // never require more than a hot restart.
        writeAppFlutterPubspec(deps: {});
        await _pubGet(wsDir);

        expect(tracker.refresh(), PackageDependencyChange.dartOnly);
      },
    );

    test(
      'when a dev dependency of the app changes, '
      'then no change is reported',
      () async {
        writeThirdParty('dep_dev', version: '1.0.1');
        await _pubGet(wsDir);

        expect(tracker.refresh(), PackageDependencyChange.none);
      },
    );

    test(
      'when pub get runs again with no pubspec changes, '
      'then no change is reported',
      () async {
        await _pubGet(wsDir);

        expect(tracker.refresh(), PackageDependencyChange.none);
      },
    );
  });

  group('Given a Flutter app pubspec with assets,', () {
    late FlutterDependencyTracker tracker;

    setUp(() async {
      tracker = await createWorkspaceTracker(
        appPubspecFlutterBlock:
            'flutter:\n'
            '  assets:\n'
            '    - assets/image.png\n',
      );
    });

    test(
      'when assets are unchanged, '
      'then no change is reported',
      () {
        expect(tracker.refresh(), PackageDependencyChange.none);
      },
    );

    test(
      'when an asset is added, '
      'then an asset change is reported',
      () {
        writeAppFlutterPubspec(
          flutterBlock:
              'flutter:\n'
              '  assets:\n'
              '    - assets/image.png\n'
              '    - assets/new_asset.png\n',
        );
        expect(tracker.refresh(), PackageDependencyChange.assets);
      },
    );

    test(
      'when an asset is removed, '
      'then an asset change is reported',
      () {
        writeAppFlutterPubspec(
          flutterBlock:
              'flutter:\n'
              '  assets:\n'
              '    - assets/other.png\n',
        );
        expect(tracker.refresh(), PackageDependencyChange.assets);
      },
    );

    test(
      'when the asset list is cleared, '
      'then an asset change is reported',
      () {
        writeAppFlutterPubspec(
          flutterBlock:
              'flutter:\n'
              '  assets: []\n',
        );
        expect(tracker.refresh(), PackageDependencyChange.assets);
      },
    );
  });

  group('Given a Flutter app pubspec with fonts,', () {
    late FlutterDependencyTracker tracker;

    setUp(() async {
      tracker = await createWorkspaceTracker(
        appPubspecFlutterBlock:
            'flutter:\n'
            '  fonts:\n'
            '    - family: MyFont\n'
            '      fonts:\n'
            '        - asset: fonts/MyFont-Regular.ttf\n',
      );
    });

    test(
      'when fonts are unchanged, '
      'then no change is reported',
      () {
        expect(tracker.refresh(), PackageDependencyChange.none);
      },
    );

    test(
      'when a font family is added, '
      'then an asset change is reported',
      () {
        writeAppFlutterPubspec(
          flutterBlock:
              'flutter:\n'
              '  fonts:\n'
              '    - family: MyFont\n'
              '      fonts:\n'
              '        - asset: fonts/MyFont-Regular.ttf\n'
              '    - family: NewFont\n'
              '      fonts:\n'
              '        - asset: fonts/NewFont-Regular.ttf\n',
        );
        expect(tracker.refresh(), PackageDependencyChange.assets);
      },
    );

    test(
      'when a font asset is changed, '
      'then an asset change is reported',
      () {
        writeAppFlutterPubspec(
          flutterBlock:
              'flutter:\n'
              '  fonts:\n'
              '    - family: MyFont\n'
              '      fonts:\n'
              '        - asset: fonts/MyFont-Bold.ttf\n',
        );
        expect(tracker.refresh(), PackageDependencyChange.assets);
      },
    );

    test(
      'when fonts are removed, '
      'then an asset change is reported',
      () {
        writeAppFlutterPubspec(
          flutterBlock:
              'flutter:\n'
              '  fonts: []\n',
        );
        expect(tracker.refresh(), PackageDependencyChange.assets);
      },
    );
  });

  /// Resolves a standalone app depending on `dep@1.0.0` (described by
  /// [depFlutterBlock]) with a real `pub get`, bumps it to 1.0.1, re-resolves,
  /// and returns the tracker's classification of the bump.
  Future<PackageDependencyChange> classifyRealDependencyBump({
    String? depFlutterBlock,
    bool withBuildHook = false,
    bool corruptDepPubspecAfterResolve = false,
  }) async {
    final appDir = p.join(tempDir.path, 'app');
    writeThirdParty('dep', flutterBlock: depFlutterBlock);
    if (withBuildHook) {
      write(
        p.join(tempDir.path, 'third_party', 'dep', 'hook', 'build.dart'),
        'void main() {}',
      );
    }
    write(
      p.join(appDir, 'pubspec.yaml'),
      _pubspec('app_flutter', deps: {'dep': '../third_party/dep'}),
    );
    await _pubGet(appDir);
    final tracker = FlutterDependencyTracker(
      dartToolDir: p.join(appDir, '.dart_tool'),
      flutterPackageName: 'app_flutter',
      flutterPackageDir: appDir,
    );

    writeThirdParty('dep', version: '1.0.1', flutterBlock: depFlutterBlock);
    await _pubGet(appDir);
    if (corruptDepPubspecAfterResolve) {
      write(
        p.join(tempDir.path, 'third_party', 'dep', 'pubspec.yaml'),
        'name: [unclosed',
      );
    }
    return tracker.refresh();
  }

  test(
    'Given a changed app dependency declaring a native plugin class, '
    'when the closure is refreshed, '
    'then a native change is reported',
    () async {
      final change = await classifyRealDependencyBump(
        depFlutterBlock:
            'flutter:\n'
            '  plugin:\n'
            '    platforms:\n'
            '      android:\n'
            '        package: com.example.dep\n'
            '        pluginClass: DepPlugin\n',
      );

      expect(change, PackageDependencyChange.native);
    },
  );

  test(
    'Given a changed app dependency declaring an FFI plugin, '
    'when the closure is refreshed, '
    'then a native change is reported',
    () async {
      final change = await classifyRealDependencyBump(
        depFlutterBlock:
            'flutter:\n'
            '  plugin:\n'
            '    platforms:\n'
            '      windows:\n'
            '        ffiPlugin: true\n',
      );

      expect(change, PackageDependencyChange.native);
    },
  );

  test(
    'Given a changed app dependency declaring only a Dart plugin class, '
    'when the closure is refreshed, '
    'then a pure-Dart change is reported',
    () async {
      final change = await classifyRealDependencyBump(
        depFlutterBlock:
            'flutter:\n'
            '  plugin:\n'
            '    platforms:\n'
            '      linux:\n'
            '        dartPluginClass: DepPluginLinux\n',
      );

      expect(change, PackageDependencyChange.dartOnly);
    },
  );

  test(
    'Given a changed app dependency with "pluginClass: none", '
    'when the closure is refreshed, '
    'then a pure-Dart change is reported',
    () async {
      final change = await classifyRealDependencyBump(
        depFlutterBlock:
            'flutter:\n'
            '  plugin:\n'
            '    platforms:\n'
            '      web:\n'
            '        pluginClass: none\n',
      );

      expect(change, PackageDependencyChange.dartOnly);
    },
  );

  test(
    'Given a changed app dependency with a native-assets build hook, '
    'when the closure is refreshed, '
    'then a native change is reported',
    () async {
      final change = await classifyRealDependencyBump(withBuildHook: true);

      expect(change, PackageDependencyChange.native);
    },
  );

  test(
    'Given a changed app dependency with an unreadable pubspec, '
    'when the closure is refreshed, '
    'then a native change is conservatively reported',
    () async {
      final change = await classifyRealDependencyBump(
        corruptDepPubspecAfterResolve: true,
      );

      expect(change, PackageDependencyChange.native);
    },
  );

  test(
    'Given a Flutter package directory in a workspace, '
    'when resolving its .dart_tool, '
    'then it resolves to the workspace root .dart_tool',
    () async {
      await createWorkspaceTracker();

      final resolved = PackageDependencyTracker.resolveDartToolDir(
        p.join(wsDir, 'app_flutter'),
        packageName: 'app_flutter',
      );

      expect(resolved, p.join(wsDir, '.dart_tool'));
    },
  );

  test(
    'Given a standalone (non-workspace) Flutter package directory, '
    'when resolving its .dart_tool, '
    'then it resolves to the package\'s own .dart_tool',
    () async {
      final appDir = p.join(tempDir.path, 'standalone');
      write(p.join(appDir, 'pubspec.yaml'), _pubspec('app_flutter'));
      await _pubGet(appDir);

      final resolved = PackageDependencyTracker.resolveDartToolDir(
        appDir,
        packageName: 'app_flutter',
      );

      expect(resolved, p.join(appDir, '.dart_tool'));
    },
  );

  test(
    'Given a Flutter package directory with no resolution in any ancestor, '
    'when resolving its .dart_tool, '
    'then it resolves to null',
    () async {
      final pkg = await Directory(p.join(tempDir.path, 'unresolved')).create();

      final resolved = PackageDependencyTracker.resolveDartToolDir(
        pkg.path,
        packageName: 'app_flutter',
      );

      expect(resolved, isNull);
    },
  );

  group(
    'Given a Flutter package whose own resolution was deleted and an unrelated ancestor resolution,',
    () {
      // E.g. a standalone app under some other Dart project's tree: the
      // ancestor's resolution is real but doesn't list the app.
      late Directory pkg;

      setUp(() async {
        final ancestorDir = p.join(tempDir.path, 'other_project');
        write(
          p.join(ancestorDir, 'pubspec.yaml'),
          _pubspec('something_unrelated'),
        );
        await _pubGet(ancestorDir);
        pkg = await Directory(
          p.join(ancestorDir, 'nested', 'app_flutter'),
        ).create(recursive: true);
      });

      test(
        'when resolving its .dart_tool, '
        'then it does not latch onto the unrelated resolution',
        () {
          final resolved = PackageDependencyTracker.resolveDartToolDir(
            pkg.path,
            packageName: 'app_flutter',
          );

          expect(resolved, isNull);
        },
      );
    },
  );

  group(
    'Given a Flutter package under an unrelated resolution with a same-named package resolved further up,',
    () {
      // Resolution stops at the nearest root: a same-named package in a
      // resolution further up must not be mistaken for this app.
      late Directory pkg;

      setUp(() async {
        final outerDir = p.join(tempDir.path, 'outer');
        write(p.join(outerDir, 'pubspec.yaml'), _pubspec('app_flutter'));
        await _pubGet(outerDir);
        final midDir = p.join(outerDir, 'mid');
        write(
          p.join(midDir, 'pubspec.yaml'),
          _pubspec('something_unrelated'),
        );
        await _pubGet(midDir);
        pkg = await Directory(
          p.join(midDir, 'app_flutter'),
        ).create(recursive: true);
      });

      test(
        'when resolving its .dart_tool, '
        'then it resolves to null',
        () {
          final resolved = PackageDependencyTracker.resolveDartToolDir(
            pkg.path,
            packageName: 'app_flutter',
          );

          expect(resolved, isNull);
        },
      );
    },
  );

  // ---------------------------------------------------------------------
  // Corruption and race states. These stay hand-written deliberately: pub
  // never produces malformed or partially-missing dependency files, so the
  // only way to cover the tracker's tolerance of them is synthetically.
  // ---------------------------------------------------------------------

  late String syntheticDartTool;

  late String syntheticFlutterPkgDir;

  Future<void> createSyntheticDartTool() async {
    syntheticDartTool = p.join(tempDir.path, '.dart_tool');
    await Directory(syntheticDartTool).create();
    syntheticFlutterPkgDir = p.join(tempDir.path, 'flutter_app');
    await Directory(syntheticFlutterPkgDir).create(recursive: true);
  }

  void writeGraph(Map<String, dynamic> graph) {
    write(p.join(syntheticDartTool, 'package_graph.json'), jsonEncode(graph));
  }

  Map<String, dynamic> minimalGraph({String depVersion = '1.0.0'}) => {
    'roots': ['app_flutter'],
    'packages': [
      {
        'name': 'app_flutter',
        'version': '1.0.0',
        'dependencies': ['dep'],
      },
      {'name': 'dep', 'version': depVersion, 'dependencies': <String>[]},
    ],
  };

  FlutterDependencyTracker createSyntheticTracker({
    String flutterPackageName = 'app_flutter',
  }) => FlutterDependencyTracker(
    dartToolDir: syntheticDartTool,
    flutterPackageName: flutterPackageName,
    flutterPackageDir: syntheticFlutterPkgDir,
  );

  group('Given a resolution whose dependency graph file is absent,', () {
    late FlutterDependencyTracker tracker;

    setUp(() async {
      await createSyntheticDartTool();
      tracker = createSyntheticTracker();
    });

    test(
      'when the closure is refreshed, '
      'then no change is reported',
      () {
        expect(tracker.refresh(), PackageDependencyChange.none);
      },
    );
  });

  group('Given a malformed dependency graph file,', () {
    late FlutterDependencyTracker tracker;

    setUp(() async {
      await createSyntheticDartTool();
      write(
        p.join(syntheticDartTool, 'package_graph.json'),
        '{ not valid json',
      );
      tracker = createSyntheticTracker();
    });

    test(
      'when the closure is refreshed, '
      'then no change is reported',
      () {
        expect(tracker.refresh(), PackageDependencyChange.none);
      },
    );
  });

  group(
    'Given a dependency graph that does not list the Flutter package,',
    () {
      late FlutterDependencyTracker tracker;

      setUp(() async {
        await createSyntheticDartTool();
        writeGraph(minimalGraph());
        tracker = createSyntheticTracker(flutterPackageName: 'not_in_graph');
      });

      test(
        'when the closure is refreshed, '
        'then no change is reported',
        () {
          expect(tracker.refresh(), PackageDependencyChange.none);
        },
      );
    },
  );

  group('Given a tracked dependency graph,', () {
    late FlutterDependencyTracker tracker;

    setUp(() async {
      await createSyntheticDartTool();
      writeGraph(minimalGraph());
      tracker = createSyntheticTracker();
    });

    test(
      'when the graph disappears then reappears unchanged, '
      'then no change is reported',
      () {
        // Simulate a transient state (e.g. mid-pub-get / flutter clean): the
        // file vanishes and is then recreated with identical contents.
        File(p.join(syntheticDartTool, 'package_graph.json')).deleteSync();
        expect(tracker.refresh(), PackageDependencyChange.none);

        writeGraph(minimalGraph());
        expect(tracker.refresh(), PackageDependencyChange.none);
      },
    );
  });

  group(
    'Given a changed dependency that is missing from package_config.json,',
    () {
      // A graph/config mismatch can only arise from a racing or partial
      // write; the unlocatable package must not be assumed pure-Dart.
      late FlutterDependencyTracker tracker;

      setUp(() async {
        await createSyntheticDartTool();
        writeGraph(minimalGraph());
        write(
          p.join(syntheticDartTool, 'package_config.json'),
          jsonEncode({
            'configVersion': 2,
            'packages': [
              {
                'name': 'app_flutter',
                'rootUri': '../',
                'packageUri': 'lib/',
              },
            ],
          }),
        );
        tracker = createSyntheticTracker();

        writeGraph(minimalGraph(depVersion: '1.0.1'));
      });

      test(
        'when the closure is refreshed, '
        'then a native change is conservatively reported',
        () {
          expect(tracker.refresh(), PackageDependencyChange.native);
        },
      );
    },
  );
}
