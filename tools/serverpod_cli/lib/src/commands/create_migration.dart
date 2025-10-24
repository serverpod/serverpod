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
  check(CreateMigrationCommand.checkOption),
  empty(CreateMigrationCommand.emptyOption);

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

  static const checkOption = FlagOption(
    argName: 'check',
    argAbbrev: 'c',
    negatable: false,
    defaultsTo: false,
    helpText: 'Check if there are changes without creating a migration. '
        'Returns exit code 0 if no changes detected, 1 if changes exist. '
        'Cannot be used with --empty flag.',
  );

  static const emptyOption = FlagOption(
    argName: 'empty',
    argAbbrev: 'e',
    negatable: false,
    defaultsTo: false,
    helpText:
        'Creates an empty migration without evaluating the state of the project. '
        'Advanced use case for manual migration creation. '
        'Cannot be used with --check flag.',
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
    bool check = commandConfig.value(CreateMigrationOption.check);
    bool empty = commandConfig.value(CreateMigrationOption.empty);

    if (check && empty) {
      log.error(
        'Cannot use both --check and --empty flags together.',
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

    String progressMessage;
    if (check) {
      progressMessage = 'Checking for changes';
    } else if (empty) {
      progressMessage = 'Creating empty migration';
    } else {
      progressMessage = 'Creating migration';
    }

    await log.progress(progressMessage, () async {
      try {
        migration = await generator.createMigration(
          tag: tag,
          force: force,
          config: config,
          write: !check,
          empty: empty,
        );
      } on MigrationVersionLoadException catch (e) {
        log.error(
          'Unable to determine latest database definition due to a corrupted '
          'migration. Please re-create or remove the migration version and try '
          'again. Migration version: "${e.versionName}".',
        );
        log.error(e.exception);
      } on GenerateMigrationDatabaseDefinitionException {
        log.error('Unable to generate database definition for project.');
      } on MigrationVersionAlreadyExistsException catch (e) {
        log.error(
          'Unable to create migration. A directory with the same name already '
          'exists: "${e.directoryPath}".',
        );
      }

      return migration == null;
    });

    if (check) {
      if (migration == null) {
        log.info('No changes detected.', type: TextLogType.success);
        return;
      } else {
        log.info('Changes detected.', type: TextLogType.bullet);
        throw ExitException.error();
      }
    }

    if (migration == null) {
      log.info('No changes detected.', type: TextLogType.success);
      return;
    }

    var projectDirectory = migration!.projectDirectory;
    var migrationName = migration!.versionName;

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
    return;
  }
}
