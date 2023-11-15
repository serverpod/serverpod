import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

class CreateRepairMigrationCommand extends ServerpodCommand {
  static const runModes = <String>['development', 'staging', 'production'];

  @override
  final name = 'create-repair-migration';

  @override
  final description =
      'Repairs the database by comparing the target state to what is in the '
      'live database instead of comparing to the latest migration.';

  CreateRepairMigrationCommand() {
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
      'version',
      abbr: 'v',
      help: 'The target version for the repair. If not specified, the latest '
          'migration version will be repaired.',
    );
    argParser.addOption(
      'mode',
      abbr: 'm',
      defaultsTo: 'development',
      allowed: runModes,
      help: 'Used to specify which database to fetch the live database '
          'definition from.',
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
    String mode = argResults!['mode'];
    String? tag = argResults!['tag'];
    String? targetVersion = argResults!['version'];

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

    var generator = MigrationGenerator(
      directory: Directory.current,
      projectName: projectName,
    );

    RepairTargetMigration? targetMigration;
    if (targetVersion != null) {
      targetMigration = RepairTargetMigration(
        version: targetVersion,
        moduleName: projectName,
      );
    }

    var success = await log.progress('Creating repair migration', () async {
      try {
        return await generator.repairMigration(
          tag: tag,
          force: force,
          runMode: mode,
          targetMigration: targetMigration,
        );
      } on MigrationRepairTargetNotFoundException catch (e) {
        if (e.versionsFound.isEmpty) {
          log.error('Unable to find any migration versions.');
        } else {
          log.error(
              'Unable to find the specified target migration "${e.targetName}".'
              'Please select on of the available versions: ${e.versionsFound}.');
        }
      } on MigrationVersionLoadException catch (e) {
        log.error(
          'Unable to determine latest database definition due to a corrupted '
          'migration. Please re-create or remove the migration version and try '
          'again. Migration version: "${e.versionName}" for module '
          '"${e.moduleName}".',
        );
        log.error(e.exception);
      } on MigrationRegistryLoadException catch (e) {
        log.error(
            'Unable to load migration registry from ${e.directoryPath}: ${e.exception}');
      } on MigrationLiveDatabaseDefinitionException catch (e) {
        log.error('Unable to fetch live database schema from server. '
            'Make sure the server is running and is connected to the '
            'database.');
        log.error(e.exception);
      } on MigrationRepairWriteException catch (e) {
        log.error('Unable to write repair migration.');
        log.error(e.exception);
      }

      return false;
    });

    if (!success) {
      throw ExitException();
    }

    log.info('Done.', type: TextLogType.success);
  }
}
