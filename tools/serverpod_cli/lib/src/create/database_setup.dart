import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

class DatabaseSetup {
  static Future<bool> createDefaultMigration(
    Directory dir,
    String name,
  ) async {
    log.debug('Creating initial migration.');

    var config = await GeneratorConfig.load(dir.path);
    if (config == null) {
      log.error('Could not load config file.');
      return false;
    }

    var generator = MigrationGenerator(
      directory: dir,
      projectName: name,
    );

    MigrationVersion? migration;
    try {
      migration = await generator.createMigration(
        force: false,
        config: config,
      );
    } on MigrationVersionLoadException {
      // Ignore known error since the user can create the migration manually
      // and get better error messages then.
    } on GenerateMigrationDatabaseDefinitionException {
      // Ignore known error since the user can create the migration manually
      // and get better error messages then.
    } on MigrationVersionAlreadyExistsException {
      // Ignore known error since the user can create the migration manually
      // and get better error messages then.
    }

    if (migration == null) {
      log.error(
        'An error occurred while creating the initial migration. You might '
        'not be set up correctly for the created project. Please see the '
        'documentation for how to create and apply a migration manually: '
        '${ServerpodUrlConstants.serverpodDocumentation}',
      );
      return false;
    }

    return true;
  }
}
