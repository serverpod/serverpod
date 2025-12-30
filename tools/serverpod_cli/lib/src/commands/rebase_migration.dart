import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/migrations/rebase_migration_runner.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// {@template rebase_migration_option}
/// Options for the rebase migration command.
/// {@endtemplate}
enum RebaseMigrationOption<V> implements OptionDefinition<V> {
  /// Onto
  onto(
    StringOption(
      argName: 'onto',
      argAbbrev: 'o',
      helpText: 'Specific migration ID to rebase onto',
    ),
  ),

  /// Check
  check(
    FlagOption(
      argName: 'check',
      argAbbrev: 'c',
      negatable: false,
      defaultsTo: false,
      helpText: 'Validate that only one migration exists since base',
    ),
  ),

  /// Force
  force(
    FlagOption(
      argName: 'force',
      argAbbrev: 'f',
      negatable: false,
      defaultsTo: false,
      helpText:
          'Creates the new migration even if there are warnings or information that '
          'may be destroyed.',
    ),
  );

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
  RebaseMigrationCommand({this.rebaseMigrationRunner})
    : super(options: RebaseMigrationOption.values);

  /// Rebase migration implementation
  final RebaseMigrationRunner? rebaseMigrationRunner;

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
    bool force = commandConfig.value(RebaseMigrationOption.force);

    // Ensure onto is not empty if specified
    if (onto != null && onto.trim().isEmpty) {
      log.error('Cannot specify empty --onto');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    bool checkMode = commandConfig.value(RebaseMigrationOption.check);
    if (checkMode) {
      log.info(
        'Check mode enabled. Validating that only one migration exists since base migration.',
      );
    }

    // Validate the command environment is correct for executing the command
    final config = await _validateCommandEnvironment();

    // Create rebase migration runner
    final runner =
        rebaseMigrationRunner ??
        RebaseMigrationRunner(
          onto: onto?.trim(),
          check: checkMode,
          force: force,
        );

    // Check migration
    final message = "${checkMode ? 'Checking' : 'Rebasing'} migration...";
    await log.progress(
      message,
      () => runner.run(config),
      newParagraph: true,
    );
  }

  /// Validates the command environment is correct for executing the command
  Future<GeneratorConfig> _validateCommandEnvironment() async {
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

    return config;
  }
}
