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

  late final ServerpodRole? _role;

  /// The main role of the server. By default, Serverpod is running as a
  /// monolith, but it can also be configured to run as a serverless server, or
  /// in maintenance mode where it runs scheduled tasks, such as executing
  /// future calls.
  ServerpodRole get role => _role ?? ServerpodRole.monolith;

  late final ServerpodLoggingMode? _loggingMode;

  /// The overarching logging mode of the server. This can be set to either
  /// [normal] or [verbose].
  ServerpodLoggingMode get loggingMode =>
      _loggingMode ?? ServerpodLoggingMode.normal;

  late final String? _serverId;

  /// The id of the server. This is used to identify the server, if you run
  /// multiple servers in a cluster.
  String get serverId => _serverId ?? 'default';

  late final bool? _applyMigrations;

  /// Whether to apply database migrations on startup.
  bool get applyMigrations => _applyMigrations ?? false;

  late final bool? _applyRepairMigration;

  /// Whether to apply database repair migration on startup.
  bool get applyRepairMigration => _applyRepairMigration ?? false;

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

  /// Returns the raw value for a given command line argument key.
  /// Returns null if the argument was not provided when parsing the command
  /// line arguments.
  ///
  /// The value is cast to type [T]. Throws [ArgumentError] if the key is
  /// invalid.
  T? getRaw<T>(String key) {
    return switch (key) {
      CliArgsConstants.runMode => _runMode as T?,
      CliArgsConstants.serverId => _serverId as T?,
      CliArgsConstants.loggingMode => _loggingMode as T?,
      CliArgsConstants.role => _role as T?,
      CliArgsConstants.applyMigrations => _applyMigrations as T?,
      CliArgsConstants.applyRepairMigration => _applyRepairMigration as T?,
      _ => throw ArgumentError('Invalid key: $key'),
    };
  }

  /// Returns a map of the command line arguments.
  Map<String, dynamic> toMap() {
    return {
      CliArgsConstants.runMode: _runMode,
      CliArgsConstants.serverId: _serverId,
      CliArgsConstants.loggingMode: _loggingMode,
      CliArgsConstants.role: _role,
      CliArgsConstants.applyMigrations: _applyMigrations,
      CliArgsConstants.applyRepairMigration: _applyRepairMigration,
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
