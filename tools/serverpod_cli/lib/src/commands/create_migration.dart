import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';

class CreateMigrationCommand extends ServerpodCommand {
  static const runModes = <String>['development', 'staging', 'production'];

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
    argParser.addFlag(
      'repair',
      abbr: 'r',
      negatable: false,
      defaultsTo: false,
      help:
          'Repairs the database by comparing the target state to what is in the '
          'live database instead of comparing to the latest migration.',
    );
    argParser.addOption(
      'mode',
      abbr: 'm',
      defaultsTo: 'development',
      allowed: runModes,
      help: 'Use together with --repair to specify which database to repair.',
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
    bool repair = argResults!['repair'];
    String mode = argResults!['mode'];
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

    var projectName = await getProjectName();

    var config = await GeneratorConfig.load();
    if (config == null) {
      throw ExitException();
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

    var success = false;
    if (repair) {
      success = await log.progress('Creating repair migration', () async {
        var migration = await generator.repairMigration(
          tag: tag,
          force: force,
          runMode: mode,
        );

        return migration != null;
      });
    } else {
      success = await log.progress('Creating migration', () async {
        var migration = await generator.createMigration(
          tag: tag,
          force: force,
          priority: priority,
        );

        return migration != null;
      });
    }

    if (!success) {
      throw ExitException();
    }

    log.info('Done.', type: TextLogType.success);
  }
}
