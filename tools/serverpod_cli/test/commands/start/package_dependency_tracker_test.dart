import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/package_dependency_tracker.dart';
import 'package:test/test.dart';

/// Runs a real `dart pub get` in [dir]. Fixtures use only path and workspace
/// dependencies, so resolution works offline and the tests exercise the actual
/// `package_graph.json` / `package_config.json` files pub generates.
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
  return buffer.toString();
}

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('pkg_dep_tracker_');
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
  // Real-resolution fixture: a workspace shared by a server and a Flutter app,
  // mirroring a generated Serverpod project. The package_graph.json is shared
  // across all members, so the tracker rooted at the SERVER must ignore changes
  // that only touch the app's closure - the core workspace-scoping guarantee.
  //
  // Layout: app_server -> dep_server, app_flutter -> dep_app (app-only).
  // Third-party packages live outside the workspace as path deps.
  // ---------------------------------------------------------------------

  late String wsDir;

  void writeThirdParty(
    String name, {
    String version = '1.0.0',
    bool withBuildHook = false,
  }) {
    write(
      p.join(tempDir.path, 'third_party', name, 'pubspec.yaml'),
      _pubspec(name, version: version),
    );
    if (withBuildHook) {
      write(
        p.join(tempDir.path, 'third_party', name, 'hook', 'build.dart'),
        'void main() {}',
      );
    }
  }

  void writeAppServerPubspec({Map<String, String>? deps}) {
    write(
      p.join(wsDir, 'app_server', 'pubspec.yaml'),
      _pubspec(
        'app_server',
        workspaceMember: true,
        deps: deps ?? {'dep_server': '../../third_party/dep_server'},
        devDeps: {'dep_dev': '../../third_party/dep_dev'},
      ),
    );
  }

  Future<PackageDependencyTracker> createServerTracker({
    bool serverDepHasBuildHook = false,
  }) async {
    wsDir = p.join(tempDir.path, 'ws');
    writeThirdParty('dep_server', withBuildHook: serverDepHasBuildHook);
    writeThirdParty('dep_app');
    writeThirdParty('dep_dev');
    write(
      p.join(wsDir, 'pubspec.yaml'),
      _pubspec('fixture_root', workspace: ['app_server', 'app_flutter']),
    );
    writeAppServerPubspec();
    write(
      p.join(wsDir, 'app_flutter', 'pubspec.yaml'),
      _pubspec(
        'app_flutter',
        workspaceMember: true,
        deps: {'dep_app': '../../third_party/dep_app'},
      ),
    );
    await _pubGet(wsDir);
    return PackageDependencyTracker(
      dartToolDir: p.join(wsDir, '.dart_tool'),
      packageName: 'app_server',
    );
  }

  group('Given a real pub workspace shared by a server and a Flutter app,', () {
    late PackageDependencyTracker tracker;

    setUp(() async {
      tracker = await createServerTracker();
    });

    test(
      'when an app-only dependency changes version, '
      'then no change is reported for the server closure',
      () async {
        // The shared package_graph.json changes, but dep_app is not in the
        // server's closure - the workspace-scoping guarantee.
        writeThirdParty('dep_app', version: '1.0.1');
        await _pubGet(wsDir);

        expect(tracker.refreshClosure(), PackageDependencyChange.none);
      },
    );

    test(
      'when a server dependency changes version, '
      'then a pure-Dart change is reported',
      () async {
        writeThirdParty('dep_server', version: '1.0.1');
        await _pubGet(wsDir);

        expect(tracker.refreshClosure(), PackageDependencyChange.dartOnly);
      },
    );

    test(
      'when a pure-Dart dependency is added to the server, '
      'then a pure-Dart change is reported',
      () async {
        writeThirdParty('dep_added');
        writeAppServerPubspec(
          deps: {
            'dep_server': '../../third_party/dep_server',
            'dep_added': '../../third_party/dep_added',
          },
        );
        await _pubGet(wsDir);

        expect(tracker.refreshClosure(), PackageDependencyChange.dartOnly);
      },
    );

    test(
      'when a server dependency is removed, '
      'then a pure-Dart change is reported (a removal never needs a relaunch)',
      () async {
        // Removing a dep shrinks the closure; its compiled code may linger in
        // the running process but nothing references it anymore, so the lighter
        // response is correct - never the native escalation.
        writeAppServerPubspec(deps: {});
        await _pubGet(wsDir);

        expect(tracker.refreshClosure(), PackageDependencyChange.dartOnly);
      },
    );

    test(
      'when a dev dependency of the server changes, '
      'then no change is reported',
      () async {
        writeThirdParty('dep_dev', version: '1.0.1');
        await _pubGet(wsDir);

        expect(tracker.refreshClosure(), PackageDependencyChange.none);
      },
    );

    test(
      'when pub get runs again with no pubspec changes, '
      'then no change is reported',
      () async {
        await _pubGet(wsDir);

        expect(tracker.refreshClosure(), PackageDependencyChange.none);
      },
    );
  });

  test(
    'Given a server dependency with a native-assets build hook, '
    'when its version changes, '
    'then a native change is reported',
    () async {
      final tracker = await createServerTracker(serverDepHasBuildHook: true);

      writeThirdParty('dep_server', version: '1.0.1', withBuildHook: true);
      await _pubGet(wsDir);

      expect(tracker.refreshClosure(), PackageDependencyChange.native);
    },
  );

  test(
    'Given a server package directory in a workspace, '
    'when resolving its .dart_tool, '
    'then it resolves to the workspace root .dart_tool',
    () async {
      await createServerTracker();

      final resolved = PackageDependencyTracker.resolveDartToolDir(
        p.join(wsDir, 'app_server'),
        packageName: 'app_server',
      );

      expect(resolved, p.join(wsDir, '.dart_tool'));
    },
  );

  // ---------------------------------------------------------------------
  // Corruption and race states. Hand-written: pub never produces malformed or
  // partially-missing dependency files, so synthetic fixtures are the only way
  // to cover the tracker's tolerance of them.
  // ---------------------------------------------------------------------

  late String syntheticDartTool;

  Future<void> createSyntheticDartTool() async {
    syntheticDartTool = p.join(tempDir.path, '.dart_tool');
    await Directory(syntheticDartTool).create(recursive: true);
  }

  void writeGraph(Map<String, dynamic> graph) {
    write(p.join(syntheticDartTool, 'package_graph.json'), jsonEncode(graph));
  }

  Map<String, dynamic> minimalGraph({String depVersion = '1.0.0'}) => {
    'roots': ['app_server'],
    'packages': [
      {
        'name': 'app_server',
        'version': '1.0.0',
        'dependencies': ['dep'],
      },
      {'name': 'dep', 'version': depVersion, 'dependencies': <String>[]},
    ],
  };

  PackageDependencyTracker createSyntheticTracker({
    String packageName = 'app_server',
  }) => PackageDependencyTracker(
    dartToolDir: syntheticDartTool,
    packageName: packageName,
  );

  group('Given a resolution whose dependency graph file is absent,', () {
    setUp(createSyntheticDartTool);

    test(
      'when the closure is refreshed, '
      'then no change is reported',
      () {
        final tracker = createSyntheticTracker();
        expect(tracker.refreshClosure(), PackageDependencyChange.none);
      },
    );
  });

  group('Given a malformed dependency graph file,', () {
    setUp(() async {
      await createSyntheticDartTool();
      write(
        p.join(syntheticDartTool, 'package_graph.json'),
        '{ not valid json',
      );
    });

    test(
      'when the closure is refreshed, '
      'then no change is reported',
      () {
        final tracker = createSyntheticTracker();
        expect(tracker.refreshClosure(), PackageDependencyChange.none);
      },
    );
  });

  group('Given a graph that does not list the tracked package,', () {
    setUp(() async {
      await createSyntheticDartTool();
      writeGraph(minimalGraph());
    });

    test(
      'when the closure is refreshed, '
      'then no change is reported',
      () {
        final tracker = createSyntheticTracker(packageName: 'not_in_graph');
        expect(tracker.refreshClosure(), PackageDependencyChange.none);
      },
    );
  });

  group('Given a seeded synthetic graph,', () {
    test(
      'when a dependency version changes after construction, '
      'then a change is reported (the baseline was seeded at construction)',
      () async {
        await createSyntheticDartTool();
        writeGraph(minimalGraph());
        final tracker = createSyntheticTracker();

        // Bump the dep. With no package_config.json to locate it, the changed
        // package cannot be classified and is conservatively treated as native
        // - the point here is that a change is detected at all (proving the
        // constructor seeded the baseline), not the exact severity.
        writeGraph(minimalGraph(depVersion: '1.0.1'));

        expect(
          tracker.refreshClosure(),
          isNot(PackageDependencyChange.none),
        );
      },
    );

    test(
      'when the graph disappears then reappears unchanged, '
      'then no change is reported',
      () async {
        await createSyntheticDartTool();
        writeGraph(minimalGraph());
        final tracker = createSyntheticTracker();

        File(p.join(syntheticDartTool, 'package_graph.json')).deleteSync();
        expect(tracker.refreshClosure(), PackageDependencyChange.none);

        writeGraph(minimalGraph());
        expect(tracker.refreshClosure(), PackageDependencyChange.none);
      },
    );
  });
}
