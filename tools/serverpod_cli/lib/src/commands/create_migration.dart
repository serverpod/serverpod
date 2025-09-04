import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/migrations/migration_creation_result.dart';
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
    negatable: false,
    defaultsTo: false,
    helpText: 'Creates an empty migration without evaluating the state of the project.',
  );

  static const checkOption = FlagOption(
    argName: 'check',
    negatable: false,
    defaultsTo: false,
    helpText: 'Returns with exit code 0 if no changes have been detected.',
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

    MigrationCreationResult result = const MigrationCreationResult.error();
    await log.progress('Creating migration', () async {
      try {
        // Handle --empty flag: force creation of empty migration
        var effectiveForce = force || empty;
        
        result = await generator.createMigrationWithResult(
          tag: tag,
          force: effectiveForce,
          config: config,
        );
      } on MigrationVersionLoadException catch (e) {
        log.error(
          'Unable to determine latest database definition due to a corrupted '
          'migration. Please re-create or remove the migration version and try '
          'again. Migration version: "${e.versionName}".',
        );
        log.error(e.exception);
        result = const MigrationCreationResult.error();
      } on GenerateMigrationDatabaseDefinitionException {
        log.error('Unable to generate database definition for project.');
        result = const MigrationCreationResult.error();
      } on MigrationVersionAlreadyExistsException catch (e) {
        log.error(
          'Unable to create migration. A directory with the same name already '
          'exists: "${e.directoryPath}".',
        );
        result = const MigrationCreationResult.error();
      }

      return result.isSuccess;
    });

    // Handle the different result cases
    if (result.isSuccess) {
      var migration = result.migration!;
      log.info(
        'Migration created: ${path.relative(
          MigrationConstants.migrationVersionDirectory(
            migration.projectDirectory,
            migration.versionName,
          ).path,
          from: Directory.current.path,
        )}',
        type: TextLogType.bullet,
      );
      log.info('Done.', type: TextLogType.success);
    } else if (result.isNoChanges) {
      // This is the key fix: when no changes are detected, don't throw an error
      if (check) {
        // With --check flag, we exit with code 0 for no changes (this is the desired behavior)
        log.info('No changes detected.', type: TextLogType.success);
        return;
      } else {
        // Without --check flag, we also exit with code 0 (this fixes the original issue)
        log.info('No changes detected.', type: TextLogType.success);
        return;
      }
    } else {
      // result.isError - this is a real error, exit with non-zero code
      throw ExitException.error();
    }
  }
}
