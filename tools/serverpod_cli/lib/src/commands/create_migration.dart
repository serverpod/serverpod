import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/migrations/create_migration_action.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';

enum CreateMigrationOption<V> implements OptionDefinition<V> {
  force(CreateMigrationCommand.forceOption),
  tag(CreateMigrationCommand.tagOption),
  ;

  const CreateMigrationOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

class CreateMigrationCommand extends ServerpodCommand<CreateMigrationOption> {
  static const forceOption = FlagOption(
    argName: 'force',
    argAbbrev: 'f',
    negatable: false,
    defaultsTo: false,
    helpText:
        'Creates the migration even if there are warnings or information that '
        'may be destroyed.',
  );

  static const tagOption = StringOption(
    argName: 'tag',
    argAbbrev: 't',
    helpText: 'Add a tag to the revision to easier identify it.',
    customValidator: _validateTag,
  );

  static void _validateTag(String tag) {
    if (!StringValidators.isValidTagName(tag)) {
      throw const FormatException(
        'Tag names can only contain lowercase letters, numbers, and dashes.',
      );
    }
  }

  @override
  final name = 'create-migration';

  @override
  final description =
      'Creates a migration from the last migration to the current state of the database.';

  CreateMigrationCommand() : super(options: CreateMigrationOption.values);

  @override
  Future<void> runWithConfig(
    final Configuration<CreateMigrationOption> commandConfig,
  ) async {
    final force = commandConfig.value(CreateMigrationOption.force);
    final tag = commandConfig.optionalValue(CreateMigrationOption.tag);

    // Get interactive flag from global configuration
    final interactive = serverpodRunner.globalConfiguration.optionalValue(
      GlobalOption.interactive,
    );

    GeneratorConfig config;
    try {
      config = await GeneratorConfig.load(interactive: interactive);
    } catch (e) {
      log.error('$e');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    late final CreateMigrationOutcome outcome;
    await log.progress('Creating migration', () async {
      outcome = await createMigrationAction(
        config: config,
        tag: tag,
        force: force,
      );
      return outcome.success;
    });

    _logMigrationOutcome(outcome);
    if (outcome.success) {
      log.info('Done.', type: TextLogType.success);
    } else {
      throw ExitException.error();
    }
  }
}

void _logMigrationOutcome(
  CreateMigrationOutcome outcome, {
  bool isServer = true,
}) {
  final label = '${isServer ? 'Server' : 'Client'} migration';
  switch (outcome) {
    case CreateMigrationFailed(:final message):
      log.error(message);
    case CreateMigrationAborted():
      log.error(
        '$label aborted. Use --force to ignore warnings.',
        type: TextLogType.bullet,
      );
    case CreateMigrationNoChanges():
      log.info(
        '$label skipped. No changes detected.',
        type: TextLogType.bullet,
      );
    case CreateMigrationCreated(:final migrationDirectory):
      log.info(
        '$label created: ${path.relative(
          migrationDirectory,
          from: Directory.current.path,
        )}',
        type: TextLogType.bullet,
      );
    case CreateMigrationServerClientCreated(
      :final serverResult,
      :final clientResult,
    ):
      _logMigrationOutcome(serverResult, isServer: true);
      _logMigrationOutcome(clientResult, isServer: false);
  }
}
