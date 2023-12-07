import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/create/port_checker.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
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

  static Future<bool> applyDefaultMigration(Directory dir) async {
    log.debug('Applying default migration.');

    log.debug('Starting docker container.');
    var success = await CommandLineTools.startDockerContainer(dir);
    if (!success) {
      return false;
    }

    log.debug('Waiting for database to become available.');
    await waitForServiceOnPort(8090);

    log.debug('Applying migrations.');
    success = await CommandLineTools.applyMigrations(dir, log.logLevel);
    if (!success) {
      return false;
    }

    log.debug('Stopping docker container.');
    return await CommandLineTools.stopDockerContainer(dir);
  }
}
