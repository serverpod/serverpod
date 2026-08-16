import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';

void main() {
  group('Given the watch-mode watch paths', () {
    final config = GeneratorConfigBuilder().build();

    test(
      'when there is no Flutter dependency tracker (server-only project), '
      'then the server resolution package_config.json is still watched',
      () {
        final serverDartTool = p.absolute('some_server', '.dart_tool');

        final paths = buildWatchPaths(
          config: config,
          serverDartToolDir: serverDartTool,
        );

        // Without this, package_config.json changes are never observed and the
        // server can't pick up a new dependency without a full restart.
        expect(paths, contains(p.join(serverDartTool, 'package_config.json')));
      },
    );

    test(
      'when a resolution .dart_tool is provided, '
      'then only its pub artifacts are watched, not the whole directory',
      () {
        final serverDartTool = p.absolute('some_server', '.dart_tool');

        final paths = buildWatchPaths(
          config: config,
          serverDartToolDir: serverDartTool,
        );

        // Watching the directory itself would also watch large, churning
        // build state (e.g. flutter_build intermediates, the server's dill),
        // causing heavy disk I/O whenever a build runs.
        expect(paths, isNot(contains(serverDartTool)));
      },
    );

    test(
      'when the server and Flutter resolutions differ (non-workspace layout), '
      "then both resolutions' pub artifacts are watched",
      () {
        final serverDartTool = p.absolute('server_pkg', '.dart_tool');
        final flutterDartTool = p.absolute('flutter_pkg', '.dart_tool');

        final paths = buildWatchPaths(
          config: config,
          serverDartToolDir: serverDartTool,
          flutterPackageGraphPaths: [
            p.join(flutterDartTool, 'package_graph.json'),
          ],
        );

        expect(
          paths,
          containsAll([
            p.join(serverDartTool, 'package_config.json'),
            p.join(flutterDartTool, 'package_graph.json'),
          ]),
        );
        expect(paths, isNot(contains(serverDartTool)));
        expect(paths, isNot(contains(flutterDartTool)));
      },
    );

    test(
      'when the server and Flutter share a resolution (workspace layout), '
      'then the shared .dart_tool contributes exactly its two pub artifacts',
      () {
        final sharedDartTool = p.absolute('workspace_root', '.dart_tool');

        final paths = buildWatchPaths(
          config: config,
          serverDartToolDir: sharedDartTool,
          flutterPackageGraphPaths: [
            p.join(sharedDartTool, 'package_graph.json'),
          ],
        );

        expect(
          paths.where((path) => p.isWithin(sharedDartTool, path)),
          unorderedEquals([
            p.join(sharedDartTool, 'package_config.json'),
            p.join(sharedDartTool, 'package_graph.json'),
          ]),
        );
      },
    );

    test(
      'when a Flutter app has no dependency tracker yet, '
      'then its expected local package_graph.json is watched.',
      () {
        final serverDir = p.absolute('project_server');
        final flutterDir = p.absolute('project_flutter');
        final app = FlutterAppConfig(
          id: 'project',
          name: 'project',
          relativePathParts: p.split(p.relative(flutterDir, from: serverDir)),
          serverPackageDirectoryPathParts: p.split(serverDir),
        );

        final paths = buildWatchPaths(
          config: config,
          flutterApps: [app],
          flutterPackageGraphPaths: [
            p.join(flutterDir, '.dart_tool', 'package_graph.json'),
          ],
        );

        expect(
          paths,
          contains(p.join(flutterDir, '.dart_tool', 'package_graph.json')),
        );
      },
    );
  });
}
