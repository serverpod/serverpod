import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analytics/analytics_helper.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:serverpod_shared/serverpod_shared.dart' hide ExitException;

enum CreateMigrationOption<V> implements OptionDefinition<V> {
  force(CreateMigrationCommand.forceOption),
  tag(CreateMigrationCommand.tagOption);

  const CreateMigrationOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

class CreateMigrationCommand extends ServerpodCommand<CreateMigrationOption> {
  static const forceOption = FlagOption(
    argName: 'force',
    argAbbrev: 'f',
    negatable: false,
    defaultsTo: false,
    helpText:
        'Creates the migration even if there are warnings or information that '
        'may be destroyed.',
  );

  static const tagOption = StringOption(
    argName: 'tag',
    argAbbrev: 't',
    helpText: 'Add a tag to the revision to easier identify it.',
    customValidator: _validateTag,
  );

  static void _validateTag(String tag) {
    if (!StringValidators.isValidTagName(tag)) {
      throw const FormatException(
        'Tag names can only contain lowercase letters, numbers, and dashes.',
      );
    }
  }

  @override
  final name = 'create-migration';

  @override
  final description =
      'Creates a migration from the last migration to the current state of the database.';

  CreateMigrationCommand() : super(options: CreateMigrationOption.values);

  @override
  Future<void> runWithConfig(
    final Configuration<CreateMigrationOption> commandConfig,
  ) async {
    bool force = commandConfig.value(CreateMigrationOption.force);
    String? tag = commandConfig.optionalValue(CreateMigrationOption.tag);

    // Build full command string for tracking
    final fullCommandParts = ['serverpod', 'create-migration'];
    if (force) {
      fullCommandParts.add('--force');
    }
    if (tag != null) {
      fullCommandParts.add('--tag');
      fullCommandParts.add(tag);
    }
    final fullCommand = fullCommandParts.join(' ');

    // Get interactive flag from global configuration
    final interactive = serverpodRunner.globalConfiguration.optionalValue(
      GlobalOption.interactive,
    );

    var success = false;
    var migrationCreated = false;
    try {
      GeneratorConfig config;
      try {
        config = await GeneratorConfig.load(interactive: interactive);
      } catch (_) {
        throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
      }

      if (!config.isFeatureEnabled(ServerpodFeature.database)) {
        log.error(
          'The database feature is not enabled in this project. '
          'This command cannot be used.',
        );
        throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
      }

      var serverDirectory = Directory(
        path.joinAll(config.serverPackageDirectoryPathParts),
      );

      var projectName = await getProjectName(serverDirectory);
      if (projectName == null) {
        throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
      }

      var generator = MigrationGenerator(
        directory: serverDirectory,
        projectName: projectName,
      );

      MigrationVersion? migration;
      bool migrationAborted = false;
      bool migrationFailed = false;
      await log.progress('Creating migration', () async {
        try {
          migration = await generator.createMigration(
            tag: tag,
            force: force,
            config: config,
          );
        } on MigrationVersionLoadException catch (e) {
          log.error(
            'Unable to determine latest database definition due to a corrupted '
            'migration. Please re-create or remove the migration version and try '
            'again. Migration version: "${e.versionName}".',
          );
          log.error(e.exception);
          migrationFailed = true;
        } on GenerateMigrationDatabaseDefinitionException {
          log.error('Unable to generate database definition for project.');
          migrationFailed = true;
        } on MigrationVersionAlreadyExistsException catch (e) {
          log.error(
            'Unable to create migration. A directory with the same name already '
            'exists: "${e.directoryPath}".',
          );
          migrationFailed = true;
        } on MigrationAbortedException {
          migrationAborted = true;
        }

        return migration != null;
      });

      if (migrationFailed) {
        throw ExitException.error();
      }

      // Migration was aborted due to warnings.
      if (migrationAborted) {
        throw ExitException.error();
      }

      // No changes detected.
      if (migration == null) {
        return;
      }

      // Dart does not infer the type of `migration` to be non-nullable here,
      // so we use the null-check operator to assert that it is not null.
      var createdMigration = migration!;
      var projectDirectory = createdMigration.projectDirectory;
      var migrationName = createdMigration.versionName;
      migrationCreated = true;

      log.info(
        'Migration created: ${path.relative(
          MigrationConstants.migrationVersionDirectory(
            projectDirectory,
            migrationName,
          ).path,
          from: Directory.current.path,
        )}',
        type: TextLogType.bullet,
      );
      log.info('Done.', type: TextLogType.success);
      success = true;
    } finally {
      // Track the event
      serverpodRunner.analytics.trackWithProperties(
        event: 'cli:migration_created',
        properties: {
          'full_command': fullCommand,
          'command': 'create-migration',
          'force': force,
          'tag': tag ?? '',
          'interactive': interactive ?? false,
          'migration_created': migrationCreated,
          'success': success,
        },
      );
    }
  }
}
