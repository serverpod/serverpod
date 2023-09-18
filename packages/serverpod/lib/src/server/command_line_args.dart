import 'dart:io';

import 'package:args/args.dart';

import 'run_mode.dart';

/// The main role of the server. By default, Serverpod is running as a monolith,
/// but it can also be configured to run as a serverless server, or in
/// maintenance mode where it runs scheduled tasks, such as executing future
/// calls.
enum ServerpodRole {
  /// The server is running as a monolith. This is the default.
  monolith,

  /// The server is running as a serverless server. Use this option if you want
  /// to run the server in a serverless environment, such as AWS Lambda or
  /// Google Cloud Run.
  serverless,

  /// Run the server in maintenance mode. This is used to run scheduled tasks,
  /// such as executing future calls. The server will not accept any requests.
  maintenance,
}

/// The overaching logging mode of the server. This can be set to either
/// [normal] or [verbose]. In [normal] mode, only important messages are logged,
/// which is the default.
enum ServerpodLoggingMode {
  /// Only log important messages.
  normal,

  /// Log all messages, including debugging information.
  verbose,
}

/// Parses the command line arguments passed to Serverpod.
class CommandLineArgs {
  /// The run mode of the server. This can be set to either [development],
  /// [staging], or [production]. Depending on where the server is deployed.
  late final String runMode;

  /// The main role of the server. By default, Serverpod is running as a
  /// monolith, but it can also be configured to run as a serverless server, or
  /// in maintenance mode where it runs scheduled tasks, such as executing
  /// future calls.
  late final ServerpodRole role;

  /// The overarching logging mode of the server. This can be set to either
  /// [normal] or [verbose].
  late final ServerpodLoggingMode loggingMode;

  /// The id of the server. This is used to identify the server, if you run
  /// multiple servers in a cluster.
  late final String serverId;

  /// If true, the server will apply database migrations on startup.
  late final bool applyMigrations;

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
            ServerpodRunMode.staging,
            ServerpodRunMode.production,
          ],
          defaultsTo: ServerpodRunMode.development,
        )
        ..addOption(
          'server-id',
          abbr: 'i',
          defaultsTo: 'default',
        )
        ..addOption(
          'logging',
          abbr: 'l',
          allowed: ['normal', 'verbose'],
          defaultsTo: 'normal',
        )
        ..addOption(
          'role',
          abbr: 'r',
          allowed: ['monolith', 'serverless', 'maintenance'],
          defaultsTo: 'monolith',
        )
        ..addFlag(
          'apply-migrations',
          abbr: 'a',
          defaultsTo: false,
        );
      var results = argParser.parse(args);

      runMode = results['mode'];
      serverId = results['server-id'];

      switch (results['logging']) {
        case 'normal':
          loggingMode = ServerpodLoggingMode.normal;
          break;
        case 'verbose':
          loggingMode = ServerpodLoggingMode.verbose;
          break;
      }

      switch (results['role']) {
        case 'monolith':
          role = ServerpodRole.monolith;
          break;
        case 'serverless':
          role = ServerpodRole.serverless;
          break;
        case 'maintenance':
          role = ServerpodRole.maintenance;
          break;
      }

      applyMigrations = results['apply-migrations'] ?? false;
    } catch (e) {
      stdout.writeln(
        'Failed to parse command line arguments. Using default values. $e',
      );
      runMode = ServerpodRunMode.development;
      serverId = 'default';
      loggingMode = ServerpodLoggingMode.normal;
      role = ServerpodRole.monolith;
      applyMigrations = false;
    }
  }

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

    return 'mode: $runMode, role: $formattedRole, logging: $formattedLoggingMode, serverId: $serverId';
  }
}
