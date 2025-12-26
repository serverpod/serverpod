import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
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

/// Rebase migration command.
class RebaseMigrationCommand extends ServerpodCommand<RebaseMigrationOption> {
  static const ontoOption = StringOption(
    argName: 'onto',
    argAbbrev: 'o',
    helpText: 'Specific migration ID to rebase onto',
  );

  static const _defaultBranch = 'main';

  static const ontoBranchOption = StringOption(
    argName: 'onto-branch',
    argAbbrev: 'b',
    helpText: 'Base branch to rebase onto',
    defaultsTo: _defaultBranch,
  );

  static const checkOption = FlagOption(
    argName: 'check',
    argAbbrev: 'c',
    helpText: 'Validate that only one migration exists since base (CI/CD mode)',
    negatable: false,
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

  RebaseMigrationCommand() : super(options: RebaseMigrationOption.values);

  @override
  Future<void> runWithConfig(
    final Configuration<RebaseMigrationOption> commandConfig,
  ) async {
    // Validate the command environment is correct for executing the command
    await _validateCommandEnvironment();

    // Parse command arguments
    String? onto = commandConfig.optionalValue(RebaseMigrationOption.onto);
    String ontoBranch = commandConfig.value(RebaseMigrationOption.ontoBranch);
    // bool force = commandConfig.value(RebaseMigrationOption.force);

    // Ensure both --onto and --onto-branch are not specified
    if (onto != null && ontoBranch != _defaultBranch) {
      log.error('Cannot specify both --onto and --onto-branch');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    bool? checkMode = commandConfig.optionalValue(RebaseMigrationOption.check);
    if (checkMode != null) {
      log.info(
        'Check mode enabled. Only validating that only one migration exists since base migration.',
      );
    }
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
    } catch (_) {
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
