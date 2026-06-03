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

  group('Given a Flutter app dependency graph in a workspace,', () {
    late FlutterDependencyTracker tracker;

    setUp(() {
      writeGraph(baseGraph());
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

        expect(tracker.refreshIfChanged(), isFalse);
      },
    );

    test(
      'when a dependency inside the app closure changes version, '
      'then a change is reported',
      () {
        final graph = baseGraph();
        packageNamed(graph, 'http')['version'] = '1.3.0';
        writeGraph(graph);

        expect(tracker.refreshIfChanged(), isTrue);
      },
    );

    test(
      'when a dependency is added to the app, '
      'then a change is reported',
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

        expect(tracker.refreshIfChanged(), isTrue);
      },
    );

    test(
      'when a dependency is removed from the app, '
      'then a change is reported',
      () {
        final graph = baseGraph();
        packageNamed(graph, 'app_flutter')['dependencies'] = ['http'];
        writeGraph(graph);

        expect(tracker.refreshIfChanged(), isTrue);
      },
    );

    test(
      'when a dev dependency of the app changes, '
      'then no change is reported',
      () {
        final graph = baseGraph();
        packageNamed(graph, 'flutter_test')['version'] = '0.1.0';
        writeGraph(graph);

        expect(tracker.refreshIfChanged(), isFalse);
      },
    );

    test(
      'when the graph is rewritten with identical contents, '
      'then no change is reported',
      () {
        writeGraph(baseGraph());

        expect(tracker.refreshIfChanged(), isFalse);
      },
    );
  });

  group('Given a missing or malformed dependency graph,', () {
    test(
      'when the graph file is absent, '
      'then the fingerprint is null and no change is reported',
      () {
        // No graph written.
        final tracker = FlutterDependencyTracker(
          dartToolDir: dartToolDir,
          flutterPackageName: 'app_flutter',
        );

        expect(tracker.computeFingerprint(), isNull);
        expect(tracker.refreshIfChanged(), isFalse);
      },
    );

    test(
      'when the graph file is malformed, '
      'then the fingerprint is null',
      () {
        File(
          p.join(dartToolDir, 'package_graph.json'),
        ).writeAsStringSync('{ not valid json');

        final tracker = FlutterDependencyTracker(
          dartToolDir: dartToolDir,
          flutterPackageName: 'app_flutter',
        );

        expect(tracker.computeFingerprint(), isNull);
      },
    );

    test(
      'when the Flutter package is absent from the graph, '
      'then the fingerprint is null',
      () {
        writeGraph(baseGraph());

        final tracker = FlutterDependencyTracker(
          dartToolDir: dartToolDir,
          flutterPackageName: 'not_in_graph',
        );

        expect(tracker.computeFingerprint(), isNull);
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
        expect(tracker.refreshIfChanged(), isFalse);

        writeGraph(baseGraph());
        expect(tracker.refreshIfChanged(), isFalse);
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
