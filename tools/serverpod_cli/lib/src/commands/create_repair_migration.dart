import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/migrations/create_repair_migration_action.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_shared/serverpod_shared.dart' hide ExitException;

import 'create_migration.dart' show CreateMigrationCommand;

enum CreateRepairMigrationOption<V> implements OptionDefinition<V> {
  force(CreateMigrationCommand.forceOption),
  tag(CreateMigrationCommand.tagOption),
  version(
    StringOption(
      argName: 'version',
      argAbbrev: 'v',
      helpText:
          'The target version for the repair. If not specified, the latest '
          'migration version will be repaired.',
    ),
  ),
  mode(
    StringOption(
      argName: 'mode',
      argAbbrev: 'm',
      defaultsTo: 'development',
      helpText:
          'Used to specify which database configuration to use when '
          'fetching the live database definition.',
      allowedValues: runModes,
    ),
  ),
  ;

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

    // Get interactive flag from global configuration
    final interactive = serverpodRunner.globalConfiguration.optionalValue(
      GlobalOption.interactive,
    );

    String mode = commandConfig.value(CreateRepairMigrationOption.mode);
    String? targetVersion = commandConfig.optionalValue(
      CreateRepairMigrationOption.version,
    );

    GeneratorConfig config;
    try {
      config = await GeneratorConfig.load(interactive: interactive);
    } catch (e) {
      log.error('$e');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    File? repairMigration;
    try {
      await log.progress('Creating repair migration', () async {
        repairMigration = await createRepairMigrationAction(
          config: config,
          tag: tag,
          force: force,
          runMode: mode,
          targetMigrationVersion: targetVersion,
        );
        return repairMigration != null;
      });
    } on MigrationAbortedException {
      log.info('Migration aborted. Use --force to ignore warnings.');
      throw ExitException.error();
    } on Exception catch (e) {
      log.error('$e');
      throw ExitException.error();
    }

    if (repairMigration == null) {
      log.info(
        'No changes detected. Use --force to create an empty repair migration.',
      );
      throw ExitException.error();
    }

    log.info(
      'Repair migration created: ${path.relative(
        repairMigration!.path,
        from: Directory.current.path,
      )}',
      type: TextLogType.bullet,
    );
    log.info('Done.', type: TextLogType.success);
  }
}
