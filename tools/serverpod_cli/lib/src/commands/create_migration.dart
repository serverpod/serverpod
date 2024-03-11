import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

class CreateMigrationCommand extends ServerpodCommand {
  @override
  final name = 'create-migration';

  @override
  final description =
      'Creates a migration from the last migration to the current state of the database.';

  CreateMigrationCommand() {
    argParser.addFlag(
      'force',
      abbr: 'f',
      negatable: false,
      defaultsTo: false,
      help:
          'Creates the migration even if there are warnings or information that '
          'may be destroyed.',
    );
    argParser.addOption(
      'tag',
      abbr: 't',
      help: 'Add a tag to the revision to easier identify it.',
    );
  }

  @override
  void run() async {
    bool force = argResults!['force'];
    String? tag = argResults!['tag'];

    if (tag != null) {
      if (!StringValidators.isValidTagName(tag)) {
        log.error(
          'Invalid tag name. Tag names can only contain lowercase letters, '
          'number, and dashes.',
        );
        throw ExitException(ExitCodeType.commandInvokedCannotExecute);
      }
    }

    GeneratorConfig config;
    try {
      config = await GeneratorConfig.load();
    } catch (_) {
      throw ExitException(ExitCodeType.commandInvokedCannotExecute);
    }

    if (!config.isFeatureEnabled(ServerpodFeature.database)) {
      log.error(
        'The database feature is not enabled in this project. '
        'This command cannot be used.',
      );
      throw ExitException(ExitCodeType.commandInvokedCannotExecute);
    }

    var projectName = await getProjectName();
    if (projectName == null) {
      throw ExitException(ExitCodeType.commandInvokedCannotExecute);
    }

    var generator = MigrationGenerator(
      directory: Directory.current,
      projectName: projectName,
    );

    MigrationVersion? migration;
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
      } on GenerateMigrationDatabaseDefinitionException {
        log.error('Unable to generate database definition for project.');
      } on MigrationVersionAlreadyExistsException catch (e) {
        log.error(
          'Unable to create migration. A directory with the same name already '
          'exists: "${e.directoryPath}".',
        );
      }

      return migration != null;
    });

    var projectDirectory = migration?.projectDirectory;
    var migrationName = migration?.versionName;
    if (migration == null ||
        projectDirectory == null ||
        migrationName == null) {
      throw ExitException();
    }

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
  }
}
