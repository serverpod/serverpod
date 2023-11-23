import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
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

    var config = await GeneratorConfig.load();
    if (config == null) {
      throw ExitException(ExitCodeType.commandInvokedCannotExecute);
    }

    var projectName = await getProjectName();
    if (projectName == null) {
      throw ExitException(ExitCodeType.commandInvokedCannotExecute);
    }

    int priority;
    var packageType = config.type;
    switch (packageType) {
      case PackageType.internal:
        priority = 0;
        break;
      case PackageType.module:
        priority = 1;
        break;
      case PackageType.server:
        priority = 2;
        break;
    }

    var generator = MigrationGenerator(
      directory: Directory.current,
      projectName: projectName,
    );

    var success = await log.progress('Creating migration', () async {
      MigrationVersion? migration;
      try {
        migration = await generator.createMigration(
          tag: tag,
          force: force,
          priority: priority,
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

    if (!success) {
      throw ExitException();
    }

    log.info('Done.', type: TextLogType.success);
  }
}
