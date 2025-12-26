import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/rebase_migration.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

import '../integration/generator_config/database_feature_config_test.dart'
    hide MockLogger;
import '../test_util/mock_log.dart';

// Internal class used to run the rebase migration command with specific arguments.
class _RebaseMigrationArgs {
  _RebaseMigrationArgs({
    this.onto,
    this.ontoBranch,
    // ignore: unused_element_parameter
    this.check = false,
    // ignore: unused_element_parameter
    this.force = false,
  });

  final String? onto;
  final String? ontoBranch;
  final bool check;
  final bool force;

  List<String> get args {
    return [
      '--no-interactive',
      RebaseMigrationCommand().name,
      if (onto != null) ...['--onto', onto!],
      if (ontoBranch != null) ...['--onto-branch', ontoBranch!],
      if (check) '--check',
      if (force) '--force',
    ];
  }
}

void main() {
  var version = Version(1, 1, 0);
  late MockLogger testLogger;
  late ServerpodCommandRunner runner;
  late Directory originalDir;

  setUp(() async {
    testLogger = MockLogger();
    initializeLoggerWith(testLogger);
    runner = ServerpodCommandRunner.createCommandRunner(
      MockAnalytics(),
      false,
      version,
      onBeforeRunCommand: (_) => Future.value(),
    );
    runner.addCommand(
      RebaseMigrationCommand(),
    );

    originalDir = Directory.current;
    final currentDir = createMockServerpodProject(
      projectName: 'myapp',
      generatorYamlContent: '''
type: server
features:
  database: true
''',
    );
    await currentDir.create();
    Directory.current = currentDir.io;
  });

  tearDown(() {
    resetLogger();
    Directory.current = originalDir;
  });

  group('RebaseMigrationCommand', () {
    test(
      'throws error when both --onto and --onto-branch are specified',
      () async {
        final rebaseArgs = _RebaseMigrationArgs(
          onto: 'm1',
          ontoBranch: 'other',
        );
        // Note: --onto-branch has a default value 'main'.
        // So we need to specify a different onto-branch to trigger the error.
        await expectLater(
          runner.run(rebaseArgs.args),
          throwsA(isA<ExitException>()),
        );

        expect(
          testLogger.output.messages,
          contains('Cannot specify both --onto and --onto-branch'),
        );
      },
    );
  });
}
