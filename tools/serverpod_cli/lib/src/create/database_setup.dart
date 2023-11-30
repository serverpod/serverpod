import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/create/port_checker.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';

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

    var migration = await generator.createMigration(
      force: false,
      config: config,
    );

    return migration != null;
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
