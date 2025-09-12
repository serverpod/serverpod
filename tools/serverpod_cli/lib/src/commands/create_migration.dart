import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:serverpod_shared/serverpod_shared.dart' hide ExitException;

enum CreateMigrationOption<V> implements OptionDefinition<V> {
  force(CreateMigrationCommand.forceOption),
  tag(CreateMigrationCommand.tagOption),
  empty(CreateMigrationCommand.emptyOption),
  check(CreateMigrationCommand.checkOption);

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

  static const emptyOption = FlagOption(
    argName: 'empty',
    argAbbrev: 'e',
    negatable: false,
    defaultsTo: false,
    helpText:
        'Creates an empty migration without evaluating the state of the project. '
        'Advanced use case for manual migration creation.',
  );

  static const checkOption = FlagOption(
    argName: 'check',
    argAbbrev: 'c',
    negatable: false,
    defaultsTo: false,
    helpText:
        'Returns with exit code 0 if no changes have been detected. '
        'Useful for CI/CD pipelines to check if migrations are needed.',
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
    bool empty = commandConfig.value(CreateMigrationOption.empty);
    bool check = commandConfig.value(CreateMigrationOption.check);

    // Validate flag combinations
    if (empty && check) {
      log.error(
        'The --empty and --check flags cannot be used together. '
        'Use --empty to create an empty migration, or --check to verify if changes are needed.',
      );
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    if (empty && force) {
      log.error(
        'The --empty and --force flags cannot be used together. '
        'The --empty flag already creates a migration without evaluation.',
      );
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    GeneratorConfig config;
    try {
      config = await GeneratorConfig.load();
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

    var projectName = await getProjectName();
    if (projectName == null) {
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    var generator = MigrationGenerator(
      directory: Directory.current,
      projectName: projectName,
    );

    MigrationVersion? migration;
    bool hasError = false;
    
    // Handle --empty flag: create empty migration without evaluation
    if (empty) {
      await log.progress('Creating empty migration', () async {
        try {
          migration = await generator.createEmptyMigration(
            tag: tag,
            config: config,
          );
        } on MigrationVersionAlreadyExistsException catch (e) {
          hasError = true;
          log.error(
            'Unable to create migration. A directory with the same name already '
            'exists: "${e.directoryPath}".',
          );
        }
        return migration != null;
      });
    } else {
      // Handle normal migration creation or --check flag
      String progressMessage = check ? 'Checking for changes' : 'Creating migration';
      await log.progress(progressMessage, () async {
        try {
          migration = await generator.createMigration(
            tag: tag,
            force: force,
            config: config,
          );
        } on MigrationVersionLoadException catch (e) {
          hasError = true;
          log.error(
            'Unable to determine latest database definition due to a corrupted '
            'migration. Please re-create or remove the migration version and try '
            'again. Migration version: "${e.versionName}".',
          );
          log.error(e.exception);
        } on GenerateMigrationDatabaseDefinitionException {
          hasError = true;
          log.error('Unable to generate database definition for project.');
        } on MigrationVersionAlreadyExistsException catch (e) {
          hasError = true;
          log.error(
            'Unable to create migration. A directory with the same name already '
            'exists: "${e.directoryPath}".',
          );
        }

        return migration != null;
      });
    }

    // Handle the case where we had actual errors
    if (hasError) {
      throw ExitException.error();
    }

    // Handle successful migration creation
    if (migration != null) {
      var projectDirectory = migration!.projectDirectory;
      var migrationName = migration!.versionName;
      
      if (check) {
        log.info('Changes detected. Migration would be created.', type: TextLogType.bullet);
      } else {
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
      }
    } else if (check) {
      // For --check flag, no changes detected is the desired outcome
      log.info('No changes detected.', type: TextLogType.bullet);
    }

    // Both "migration created" and "no changes detected" are successful outcomes
    log.info('Done.', type: TextLogType.success);
  }
}
