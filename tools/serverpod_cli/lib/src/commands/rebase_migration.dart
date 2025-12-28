import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/migrations/rebase_migration_impl.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// {@template rebase_migration_option}
/// Options for the rebase migration command.
/// {@endtemplate}
enum RebaseMigrationOption<V> implements OptionDefinition<V> {
  onto(RebaseMigrationCommand.ontoOption),
  ontoBranch(RebaseMigrationCommand.ontoBranchOption),
  check(RebaseMigrationCommand.checkOption),
  force(RebaseMigrationCommand.forceOption);

  /// {@macro rebase_migration_option}
  const RebaseMigrationOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// {@template rebase_migration_command}
/// Rebase migration command.
/// {@endtemplate}
class RebaseMigrationCommand extends ServerpodCommand<RebaseMigrationOption> {
  /// {@macro rebase_migration_command}
  RebaseMigrationCommand({
    this.rebaseMigrationImpl = const RebaseMigrationImpl(),
  }) : super(options: RebaseMigrationOption.values);

  /// Rebase migration implementation
  final RebaseMigrationImpl rebaseMigrationImpl;

  static const ontoOption = StringOption(
    argName: 'onto',
    argAbbrev: 'o',
    helpText: 'Specific migration ID to rebase onto',
  );

  static const ontoBranchOption = StringOption(
    argName: 'onto-branch',
    argAbbrev: 'b',
    helpText:
        'Base branch to rebase onto, defaults to ${RebaseMigrationImpl.defaultBranch}',
  );

  static const checkOption = FlagOption(
    argName: 'check',
    argAbbrev: 'c',
    negatable: false,
    defaultsTo: false,
    helpText: 'Validate that only one migration exists since base',
  );

  static const forceOption = FlagOption(
    argName: 'force',
    argAbbrev: 'f',
    negatable: false,
    defaultsTo: false,
    helpText:
        'Creates the new migration even if there are warnings or information that '
        'may be destroyed.',
  );

  @override
  final name = 'rebase-migration';

  @override
  final description =
      'Consolidate multiple migrations into a single migration by rebasing onto a base state';

  @override
  Future<void> runWithConfig(
    final Configuration<RebaseMigrationOption> commandConfig,
  ) async {
    // Parse command arguments
    String? onto = commandConfig.optionalValue(RebaseMigrationOption.onto);
    String? ontoBranch = commandConfig.optionalValue(
      RebaseMigrationOption.ontoBranch,
    );
    // bool force = commandConfig.value(RebaseMigrationOption.force);

    // Ensure both --onto and --onto-branch are not specified
    if (onto != null && ontoBranch != null) {
      log.error('Cannot specify both --onto and --onto-branch');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    bool checkMode = commandConfig.value(RebaseMigrationOption.check);
    if (checkMode) {
      log.info(
        'Check mode enabled. Only validating that only one migration exists since base migration.',
      );
    }

    // Validate the command environment is correct for executing the command
    await _validateCommandEnvironment();

    // Check migration
    final operation = checkMode
        ? rebaseMigrationImpl.checkMigration
        : rebaseMigrationImpl.rebaseMigration;
    final message = "${checkMode ? 'Checking' : 'Rebasing'} migration...";
    await log.progress(message, operation, newParagraph: true);
  }

  /// Validates the command environment is correct for executing the command
  Future<void> _validateCommandEnvironment() async {
    // Get interactive flag from global configuration
    final interactive = serverpodRunner.globalConfiguration.optionalValue(
      GlobalOption.interactive,
    );

    // Load generator config
    GeneratorConfig config;
    try {
      config = await GeneratorConfig.load(interactive: interactive);
    } catch (e) {
      log.error('Failed to load generator config: $e');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    // Check if database feature is enabled
    if (!config.isFeatureEnabled(ServerpodFeature.database)) {
      log.error(
        'The database feature is not enabled in this project. '
        'This command cannot be used.',
      );
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    // Get server directory
    var serverDirectory = Directory(
      path.joinAll(config.serverPackageDirectoryPathParts),
    );

    // Get project name
    var projectName = await getProjectName(serverDirectory);
    if (projectName == null) {
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }
  }
}
