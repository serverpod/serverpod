import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/commands/start/flutter_dependency_tracker.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';

void main() {
  group('Given the watch-mode watch paths', () {
    final config = GeneratorConfigBuilder().build();

    test(
      'when there is no Flutter dependency tracker (server-only project), '
      'then the server resolution .dart_tool is still watched',
      () {
        final serverDartTool = p.absolute('some_server', '.dart_tool');

        final paths = buildWatchPaths(
          config: config,
          serverDartToolDir: serverDartTool,
        );

        // Without this, package_config.json changes are never observed and the
        // server can't pick up a new dependency without a full restart.
        expect(paths, contains(serverDartTool));
      },
    );

    test(
      'when the server and Flutter resolutions differ (non-workspace layout), '
      'then both .dart_tool directories are watched',
      () {
        final serverDartTool = p.absolute('server_pkg', '.dart_tool');
        final flutterDartTool = p.absolute('flutter_pkg', '.dart_tool');
        final tracker = FlutterDependencyTracker(
          dartToolDir: flutterDartTool,
          flutterPackageName: 'my_flutter',
          flutterPackageDir: p.absolute('flutter_pkg'),
        );

        final paths = buildWatchPaths(
          config: config,
          serverDartToolDir: serverDartTool,
          flutterDependencyTrackers: [tracker],
        );

        expect(paths, containsAll([serverDartTool, flutterDartTool]));
      },
    );

    test(
      'when the server and Flutter share a resolution (workspace layout), '
      'then the shared .dart_tool is watched exactly once',
      () {
        final sharedDartTool = p.absolute('workspace_root', '.dart_tool');
        final tracker = FlutterDependencyTracker(
          dartToolDir: sharedDartTool,
          flutterPackageName: 'my_flutter',
          flutterPackageDir: p.absolute('workspace_root', 'my_flutter'),
        );

        final paths = buildWatchPaths(
          config: config,
          serverDartToolDir: sharedDartTool,
          flutterDependencyTrackers: [tracker],
        );

        expect(paths.where((path) => path == sharedDartTool), hasLength(1));
      },
    );
  });
}
