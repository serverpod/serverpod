import 'dart:io';

import 'package:args/args.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'run_mode.dart';

/// Parses the command line arguments passed to Serverpod.
class CommandLineArgs {
  late final String? _runMode;

  /// The run mode of the server. This can be set to either [development],
  /// [staging], or [production]. Depending on where the server is deployed.
  String get runMode => _runMode ?? ServerpodRunMode.development;

  /// Whether the run mode is using the default value.
  bool get isRunModeDefault => _runMode == null;

  late final ServerpodRole? _role;

  /// The main role of the server. By default, Serverpod is running as a
  /// monolith, but it can also be configured to run as a serverless server, or
  /// in maintenance mode where it runs scheduled tasks, such as executing
  /// future calls.
  ServerpodRole get role => _role ?? ServerpodRole.monolith;

  /// Whether the role is using the default value.
  bool get isRoleDefault => _role == null;

  late final ServerpodLoggingMode? _loggingMode;

  /// The overarching logging mode of the server. This can be set to either
  /// [normal] or [verbose].
  ServerpodLoggingMode get loggingMode =>
      _loggingMode ?? ServerpodLoggingMode.normal;

  /// Whether the logging mode is using the default value.
  bool get isLoggingModeDefault => _loggingMode == null;

  late final String? _serverId;

  /// The id of the server. This is used to identify the server, if you run
  /// multiple servers in a cluster.
  String get serverId => _serverId ?? 'default';

  /// Whether the server id is using the default value.
  bool get isServerIdDefault => _serverId == null;

  late final bool? _applyMigrations;

  /// Whether to apply database migrations on startup.
  bool get applyMigrations => _applyMigrations ?? false;

  /// Whether the apply migrations flag is using the default value.
  bool get isApplyMigrationsDefault => _applyMigrations == null;

  late final bool? _applyRepairMigration;

  /// Whether to apply database repair migration on startup.
  bool get applyRepairMigration => _applyRepairMigration ?? false;

  /// Whether the apply repair migration flag is using the default value.
  bool get isApplyRepairMigrationDefault => _applyRepairMigration == null;

  /// Parses the command line arguments passed to Serverpod and creates a
  /// [CommandLineArgs] object.
  CommandLineArgs(List<String> args) {
    try {
      var argParser = ArgParser()
        ..addOption(
          'mode',
          abbr: 'm',
          allowed: [
            ServerpodRunMode.development,
            ServerpodRunMode.test,
            ServerpodRunMode.staging,
            ServerpodRunMode.production,
          ],
        )
        ..addOption(
          'server-id',
          abbr: 'i',
        )
        ..addOption(
          'logging',
          abbr: 'l',
          allowed: ['normal', 'verbose'],
        )
        ..addOption(
          'role',
          abbr: 'r',
          allowed: ['monolith', 'serverless', 'maintenance'],
        )
        ..addFlag(
          'apply-migrations',
          abbr: 'a',
        )
        ..addFlag(
          'apply-repair-migration',
          abbr: 'A',
        );
      var results = argParser.parse(args);

      _runMode = results['mode'];
      _serverId = results['server-id'];

      _loggingMode = switch (results['logging']) {
        'normal' => ServerpodLoggingMode.normal,
        'verbose' => ServerpodLoggingMode.verbose,
        _ => null,
      };

      _role = switch (results['role']) {
        'monolith' => ServerpodRole.monolith,
        'serverless' => ServerpodRole.serverless,
        'maintenance' => ServerpodRole.maintenance,
        _ => null,
      };

      _applyMigrations = results.wasParsed('apply-migrations')
          ? results['apply-migrations']
          : null;
      _applyRepairMigration = results.wasParsed('apply-repair-migration')
          ? results['apply-repair-migration']
          : null;
    } catch (e) {
      stdout.writeln(
        'Failed to parse command line arguments. Using default values. $e',
      );
      _runMode = null;
      _serverId = null;
      _loggingMode = null;
      _role = null;
      _applyMigrations = null;
      _applyRepairMigration = null;
    }
  }

  CommandLineArgs._internal({
    required String? runMode,
    required String? serverId,
    required ServerpodLoggingMode? loggingMode,
    required ServerpodRole? role,
    required bool? applyMigrations,
    required bool? applyRepairMigration,
  })  : _runMode = runMode,
        _serverId = serverId,
        _loggingMode = loggingMode,
        _role = role,
        _applyMigrations = applyMigrations,
        _applyRepairMigration = applyRepairMigration;

  /// Creates a copy of this [CommandLineArgs] with the given fields replaced.
  CommandLineArgs copyWith({
    String? runMode,
    String? serverId,
    ServerpodLoggingMode? loggingMode,
    ServerpodRole? role,
    bool? applyMigrations,
    bool? applyRepairMigration,
  }) {
    return CommandLineArgs._internal(
      runMode: runMode ?? _runMode,
      serverId: serverId ?? _serverId,
      loggingMode: loggingMode ?? _loggingMode,
      role: role ?? _role,
      applyMigrations: applyMigrations ?? _applyMigrations,
      applyRepairMigration: applyRepairMigration ?? _applyRepairMigration,
    );
  }

  /// Returns a map of the command line arguments.
  Map<String, dynamic> toMap() {
    return {
      CliArgsConstants.runMode: isRunModeDefault ? null : runMode,
      CliArgsConstants.serverId: isServerIdDefault ? null : serverId,
      CliArgsConstants.loggingMode: isLoggingModeDefault ? null : loggingMode,
      CliArgsConstants.role: isRoleDefault ? null : role,
      CliArgsConstants.applyMigrations:
          isApplyMigrationsDefault ? null : applyMigrations,
      CliArgsConstants.applyRepairMigration:
          isApplyRepairMigrationDefault ? null : applyRepairMigration,
    };
  }

  /// Returns a string representation of the command line arguments.
  @override
  String toString() {
    String formattedRole;
    switch (role) {
      case ServerpodRole.monolith:
        formattedRole = 'monolith';
        break;
      case ServerpodRole.serverless:
        formattedRole = 'serverless';
        break;
      case ServerpodRole.maintenance:
        formattedRole = 'maintenance';
        break;
    }

    String formattedLoggingMode;
    switch (loggingMode) {
      case ServerpodLoggingMode.normal:
        formattedLoggingMode = 'normal';
        break;
      case ServerpodLoggingMode.verbose:
        formattedLoggingMode = 'verbose';
        break;
    }

    return 'mode: $runMode, role: $formattedRole, logging: $formattedLoggingMode, serverId: $serverId, '
        'applyMigrations: $applyMigrations, applyRepairMigration: $applyRepairMigration';
  }
}
