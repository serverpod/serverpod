import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';

class MigrateCommand extends Command {
  static const _runModes = <String>['development', 'staging', 'production'];

  @override
  final name = 'migrate';

  @override
  final description =
      'Creates a migration from the last migration to the current state of the database.';

  MigrateCommand() {
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      defaultsTo: false,
      help: 'Output more detailed information.',
    );
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
      allowed: _runModes,
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
    bool verbose = argResults!['verbose'];
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

    if (repair) {
      await generator.repairMigration(
        tag: tag,
        force: force,
        runMode: mode,
        verbose: verbose,
      );
    } else {
      await generator.createMigration(
        tag: tag,
        verbose: verbose,
        force: force,
        priority: priority,
      );
      log.info('Done.',
          style: const TextLogStyle(type: AbstractStyleType.success));
    }
  }
}
