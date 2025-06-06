import 'package:serverpod/src/server/command_line_args.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Augments command line arguments with values from environment variables.
///
/// This class takes environment variables and uses them to supplement or
/// override default command line argument values when those arguments
/// haven't been explicitly provided via the command line.
final class EnvironmentCliArgsAugmenter {
  final Map<String, dynamic> _environment;

  /// Creates an augmenter with the provided environment variables.
  ///
  /// The [_environment] map should contain environment variable key-value pairs
  /// that will be used to augment command line arguments.
  EnvironmentCliArgsAugmenter(this._environment);

  /// Augments the provided command line arguments with environment variable values.
  ///
  /// For each argument that is set to its default value (not explicitly provided
  /// via command line), this method will check if a corresponding environment
  /// variable exists and use that value instead.
  ///
  /// The following arguments can be augmented from environment variables:
  /// - runMode: From SERVERPOD_MODE
  /// - serverId: From SERVERPOD_SERVER_ID
  /// - loggingMode: From SERVERPOD_LOGGING
  /// - role: From SERVERPOD_ROLE
  /// - applyMigrations: From SERVERPOD_APPLY_MIGRATIONS (expects 'true' for true)
  /// - applyRepairMigration: From SERVERPOD_APPLY_REPAIR_MIGRATION (expects 'true' for true)
  ///
  /// Returns a new [CommandLineArgs] instance with the augmented values.
  CommandLineArgs createAugmentedFrom(CommandLineArgs commandLineArgs) {
    final runMode = commandLineArgs.isRunModeDefault
        ? switch (_environment[ServerpodEnv.runMode.envVariable]) {
            String value => value,
            _ => null,
          }
        : null;

    final serverId = commandLineArgs.isServerIdDefault
        ? switch (_environment[ServerpodEnv.serverId.envVariable]) {
            String value => value,
            _ => null,
          }
        : null;

    final loggingMode = commandLineArgs.isLoggingModeDefault
        ? switch (_environment[ServerpodEnv.loggingMode.envVariable]) {
            String value => _parseLoggingMode(value),
            _ => null,
          }
        : null;

    final role = commandLineArgs.isRoleDefault
        ? switch (_environment[ServerpodEnv.role.envVariable]) {
            String value => _parseRole(value),
            _ => null,
          }
        : null;

    final applyMigrations = commandLineArgs.isApplyMigrationsDefault
        ? switch (_environment[ServerpodEnv.applyMigrations.envVariable]) {
            'true' => true,
            _ => false,
          }
        : null;

    final applyRepairMigration = commandLineArgs.isApplyRepairMigrationDefault
        ? switch (_environment[ServerpodEnv.applyRepairMigration.envVariable]) {
            'true' => true,
            _ => false,
          }
        : null;

    return commandLineArgs.copyWith(
      runMode: runMode,
      serverId: serverId,
      loggingMode: loggingMode,
      role: role,
      applyMigrations: applyMigrations,
      applyRepairMigration: applyRepairMigration,
    );
  }

  /// Parses a string value into a [ServerpodLoggingMode] enum.
  /// Returns null if the value is null or invalid.
  ServerpodLoggingMode? _parseLoggingMode(String? value) {
    return switch (value) {
      'normal' => ServerpodLoggingMode.normal,
      'verbose' => ServerpodLoggingMode.verbose,
      _ => null,
    };
  }

  /// Parses a string value into a [ServerpodRole] enum.
  /// Returns null if the value is null or invalid.
  ServerpodRole? _parseRole(String? value) {
    return switch (value) {
      'monolith' => ServerpodRole.monolith,
      'serverless' => ServerpodRole.serverless,
      'maintenance' => ServerpodRole.maintenance,
      _ => null,
    };
  }
}
