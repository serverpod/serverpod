import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'create_migration.dart' show CreateMigrationCommand;

enum CreateRepairMigrationOption<V> implements OptionDefinition<V> {
  force(CreateMigrationCommand.forceOption),
  tag(CreateMigrationCommand.tagOption),
  version(StringOption(
    argName: 'version',
    argAbbrev: 'v',
    helpText: 'The target version for the repair. If not specified, the latest '
        'migration version will be repaired.',
  )),
  mode(StringOption(
    argName: 'mode',
    argAbbrev: 'm',
    defaultsTo: 'development',
    helpText: 'Used to specify which database configuration to use when '
        'fetching the live database definition.',
    allowedValues: runModes,
  ));

  static const runModes = <String>['development', 'staging', 'production'];

  const CreateRepairMigrationOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

class CreateRepairMigrationCommand
    extends ServerpodCommand<CreateRepairMigrationOption> {
  @override
  final name = 'create-repair-migration';

  @override
  final description =
      'Repairs the database by comparing the target state to what is in the '
      'live database instead of comparing to the latest migration.';

  CreateRepairMigrationCommand()
      : super(options: CreateRepairMigrationOption.values);

  @override
  Future<void> runWithConfig(
    final Configuration<CreateRepairMigrationOption> commandConfig,
  ) async {
    bool force = commandConfig.value(CreateRepairMigrationOption.force);
    String? tag = commandConfig.optionalValue(CreateRepairMigrationOption.tag);
    String mode = commandConfig.value(CreateRepairMigrationOption.mode);
    String? targetVersion =
        commandConfig.optionalValue(CreateRepairMigrationOption.version);

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

    File? repairMigration;
    await log.progress('Creating repair migration', () async {
      try {
        repairMigration = await generator.repairMigration(
          tag: tag,
          force: force,
          runMode: mode,
          targetMigrationVersion: targetVersion,
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
      } on MigrationLiveDatabaseDefinitionException catch (e) {
        log.error('Unable to fetch live database schema from server. '
            'Make sure the server is running and is connected to the '
            'database.');
        log.error(e.exception);
      } on MigrationRepairWriteException catch (e) {
        log.error('Unable to write repair migration.');
        log.error(e.exception);
      }

      return repairMigration != null;
    });

    var repairMigrationPath = repairMigration?.path;
    if (repairMigration == null || repairMigrationPath == null) {
      throw ExitException.error();
    }

    log.info(
      'Repair migration created: ${path.relative(
        repairMigrationPath,
        from: Directory.current.path,
      )}',
      type: TextLogType.bullet,
    );
    log.info('Done.', type: TextLogType.success);
  }
}
