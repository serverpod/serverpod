import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:collection/collection.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/rebase_migration.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/migrations/generator.dart';
import 'package:serverpod_cli/src/migrations/migration_registry.dart';
import 'package:serverpod_cli/src/migrations/rebase_migration_runner.dart';
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
    this.check = false,
    this.force = false,
  });

  final String? onto;
  final bool check;
  final bool force;

  List<String> get args {
    return [
      '--no-interactive',
      RebaseMigrationCommand().name,
      if (onto != null) ...['--onto', onto!],
      if (check) '--check',
      if (force) '--force',
    ];
  }
}

/// Mock rebase migration implementation
class MockRebaseMigrationRunner extends RebaseMigrationRunner {
  int rebaseMigrationCallCount = 0;
  int checkMigrationCallCount = 0;

  MockRebaseMigrationRunner({
    super.onto,
    super.check,
    super.force,
    super.tag,
  });

  @override
  Future<bool> rebaseMigration({
    required MigrationGenerator generator,
    required String baseMigrationId,
    required GeneratorConfig config,
  }) async {
    rebaseMigrationCallCount++;
    return true;
  }

  @override
  String getBaseMigrationId(MigrationRegistry migrationRegistry) {
    return onto ?? '1234567890';
  }

  @override
  void ensureBaseMigration(
    MigrationRegistry migrationRegistry,
    String baseMigrationId,
  ) {}

  @override
  Future<bool> checkMigration(
    MigrationRegistry migrationRegistry,
    String baseMigrationId,
  ) async {
    checkMigrationCallCount++;
    return true;
  }
}

void main() {
  final version = Version(1, 1, 0);
  late MockLogger testLogger;
  late ServerpodCommandRunner runner;
  final originalDir = Directory.current;
  late MockRebaseMigrationRunner mockRebaseMigrationImpl;

  /// Creates a valid project for testing
  Future<void> createValidProject({bool withDatabase = true}) async {
    final currentDir = createMockServerpodProject(
      projectName: 'myapp',
      generatorYamlContent:
          '''
type: server
features:
  database: $withDatabase
''',
    );
    await currentDir.create();
    Directory.current = currentDir.io;
  }

  setUp(() async {
    testLogger = MockLogger();
    initializeLoggerWith(testLogger);
    runner = ServerpodCommandRunner.createCommandRunner(
      MockAnalytics(),
      false,
      version,
      onBeforeRunCommand: (_) => Future.value(),
    );
  });

  /// Runs the rebase migration command with the given arguments
  Future<void> runRebase(_RebaseMigrationArgs args) async {
    await runner.run(args.args);
    Directory.current = originalDir;
  }

  tearDown(() {
    resetLogger();
  });

  /// Sets up the rebase migration command with the given arguments
  void setupCommand(_RebaseMigrationArgs args) {
    mockRebaseMigrationImpl = MockRebaseMigrationRunner(
      onto: args.onto,
      check: args.check,
      force: args.force,
    );
    runner.addCommand(
      RebaseMigrationCommand(
        rebaseMigrationRunner: mockRebaseMigrationImpl,
      ),
    );
  }

  group('RebaseMigrationCommand', () {
    test('given --onto specified but empty then an error is thrown', () async {
      final rebaseArgs = _RebaseMigrationArgs(
        onto: '',
        force: true,
      );
      setupCommand(rebaseArgs);
      await expectLater(
        runRebase(rebaseArgs),
        throwsA(isA<ExitException>()),
      );

      expect(
        testLogger.output.errorMessages,
        contains('Cannot specify empty --onto'),
      );
    });

    test(
      'given command environment is not valid then an error is thrown',
      () async {
        final rebaseArgs = _RebaseMigrationArgs();
        setupCommand(rebaseArgs);
        await expectLater(
          runRebase(rebaseArgs),
          throwsA(isA<ExitException>()),
        );

        expect(testLogger.output.errorMessages, isNotEmpty);
        expect(
          testLogger.output.errorMessages.first,
          contains('Failed to load generator config'),
        );
      },
    );

    test(
      'given database feature is not enabled then an error is thrown',
      () async {
        await createValidProject(withDatabase: false);
        final rebaseArgs = _RebaseMigrationArgs();
        setupCommand(rebaseArgs);
        await expectLater(
          runRebase(rebaseArgs),
          throwsA(isA<ExitException>()),
        );

        expect(
          testLogger.output.errorMessages.firstWhereOrNull(
            (message) => message.contains(
              'The database feature is not enabled in this project',
            ),
          ),
          isNotNull,
        );
      },
    );

    group('given valid command environment', () {
      test(
        'when check is false then rebase migration is executed',
        () async {
          await createValidProject();
          final rebaseArgs = _RebaseMigrationArgs(check: false);
          setupCommand(rebaseArgs);
          await runRebase(rebaseArgs);
          expect(mockRebaseMigrationImpl.rebaseMigrationCallCount, 1);
          expect(mockRebaseMigrationImpl.checkMigrationCallCount, 0);
        },
      );

      test(
        'when check is true then check migration is executed',
        () async {
          await createValidProject();
          final rebaseArgs = _RebaseMigrationArgs(check: true);
          setupCommand(rebaseArgs);
          await runRebase(rebaseArgs);
          expect(mockRebaseMigrationImpl.rebaseMigrationCallCount, 0);
          expect(mockRebaseMigrationImpl.checkMigrationCallCount, 1);
        },
      );
    });
  });
}
