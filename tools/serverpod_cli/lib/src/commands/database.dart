import 'dart:io';

import 'package:ci/ci.dart' as ci;
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/commands/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_database/embedded.dart';
import 'package:serverpod_shared/serverpod_shared.dart'
    show PasswordManager, PostgresDatabaseConfig, ServerpodConfig;

/// Database-related development commands.
class DatabaseCommand extends ServerpodCommand<OptionDefinition> {
  DatabaseCommand() : super(options: const []) {
    addSubcommand(DatabaseStartCommand());
  }

  @override
  final name = 'database';

  @override
  final description =
      'Manage the embedded PostgreSQL database used by a Serverpod project.';

  @override
  void runWithConfig(Configuration<OptionDefinition> commandConfig) {}
}

/// Options for `serverpod database start`.
enum DatabaseStartOption<V> implements OptionDefinition<V> {
  serverDir(
    StringOption(
      argName: 'server-dir',
      argAbbrev: 's',
      helpText: 'Server project directory. Defaults to auto-detection.',
      valueHelp: 'path',
    ),
  ),
  mode(
    StringOption(
      argName: 'mode',
      argAbbrev: 'm',
      defaultsTo: 'development',
      helpText: 'Serverpod run mode whose database config should be used.',
    ),
  ),
  port(
    IntOption(
      argName: 'port',
      argAbbrev: 'p',
      min: 1,
      max: 65535,
      helpText:
          'TCP port override. Defaults to the configured database port. '
          'Requires a database password for the run mode.',
    ),
  ),
  ;

  const DatabaseStartOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// Starts the configured embedded PostgreSQL database, or joins the one the
/// server already runs, and prints how to reach it.
class DatabaseStartCommand extends ServerpodCommand<DatabaseStartOption> {
  DatabaseStartCommand() : super(options: DatabaseStartOption.values);

  @override
  final name = 'start';

  @override
  final description =
      'Start the configured embedded PostgreSQL database and print how to '
      'connect to it.';

  @override
  Future<void> runWithConfig(
    Configuration<DatabaseStartOption> commandConfig,
  ) async {
    var interactive =
        serverpodRunner.globalConfiguration.optionalValue(
          GlobalOption.interactive,
        ) ??
        !ci.isCI;

    final Directory serverDirectory;
    try {
      var serverDir = commandConfig.optionalValue(
        DatabaseStartOption.serverDir,
      );
      serverDirectory = await ServerDirectoryFinder.findOrPrompt(
        startDir: serverDir == null ? null : Directory(serverDir),
        interactive: interactive,
      );
    } catch (e) {
      log.error('$e');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    try {
      var resolved = await _startFromServerpodConfig(
        serverDirectory: serverDirectory,
        runMode: commandConfig.value(DatabaseStartOption.mode),
        port: commandConfig.optionalValue(DatabaseStartOption.port),
      );
      var postgres = resolved.handle;

      log.info(
        resolved.launched
            ? 'Embedded PostgreSQL is ready.'
            : 'Embedded PostgreSQL is ready (joined the database another '
                  'process started).',
      );
      log.info('Unix socket URI: ${postgres.connectionString}');
      var tcpUri = postgres.tcpConnectionUri;
      if (tcpUri != null) {
        log.info('TCP URI: $tcpUri');
      } else if (resolved.connectivity.password.isEmpty) {
        log.info(
          'TCP is off because no database password is configured. Set '
          '`database` for this run mode in config/passwords.yaml to also '
          'listen on the configured port.',
        );
      } else {
        log.info(
          'TCP is off because the process that started the database did not '
          'enable it. Restart that process to also listen on the configured '
          'port.',
        );
      }
      log.info(
        resolved.launched
            ? (Platform.isMacOS ? 'Press ⌃C to stop.' : 'Press Ctrl+C to stop.')
            : 'Stopping the owning process stops the database.',
      );

      while (postgres.isRunning) {
        await Future<void>.delayed(const Duration(seconds: 1));
      }
      await resolved.stop?.call();
    } on _DatabaseStartConfigurationException catch (e) {
      log.error(e.message);
      throw ExitException.error();
    } catch (e, stackTrace) {
      log.error(
        formatEmbeddedPostgresFailure(e),
        stackTrace: shouldReportEmbeddedPostgresFailure(e) ? stackTrace : null,
      );
      throw ExitException.error();
    }
  }
}

Future<ResolvedEmbeddedPostgres> _startFromServerpodConfig({
  required Directory serverDirectory,
  required String runMode,
  int? port,
}) async {
  var serverDir = p.normalize(serverDirectory.absolute.path);
  var passwords = PasswordManager(runMode: runMode).loadPasswords(
    serverDir: serverDir,
  );
  var serverConfig = ServerpodConfig.load(
    runMode,
    null,
    passwords,
    serverDir: serverDir,
  );
  var databaseConfig = serverConfig.database;
  if (databaseConfig is! PostgresDatabaseConfig) {
    throw _DatabaseStartConfigurationException(
      'Run mode "$runMode" does not use PostgreSQL. Select a run mode '
      'configured for PostgreSQL and try again.',
    );
  }
  if (port != null && databaseConfig.password.isEmpty) {
    throw _DatabaseStartConfigurationException(
      'A TCP port was given, but run mode "$runMode" has no database '
      'password, so the embedded database only serves its Unix socket. Set '
      '`database` for this run mode in config/passwords.yaml to listen on '
      'TCP.',
    );
  }
  if (port != null) databaseConfig = databaseConfig.withPort(port);

  var resolved = await startOrAttachEmbeddedPostgres(
    databaseConfig.withResolvedLocalPath(serverDir),
  );
  if (resolved == null) {
    throw _DatabaseStartConfigurationException(
      'The command `serverpod database start` can only be used with an '
      'embedded database, but run mode "$runMode" uses an external database.',
    );
  }
  var runningPort = resolved.handle.tcpEndpoint?.port;
  if (!resolved.launched && port != null && runningPort != port) {
    var listening = runningPort == null
        ? 'without TCP'
        : 'on port $runningPort';
    throw _DatabaseStartConfigurationException(
      'The embedded database is already running $listening, started by '
      'another process, so it cannot also listen on port $port. Stop that '
      'process or drop --port.',
    );
  }
  return resolved;
}

final class _DatabaseStartConfigurationException implements Exception {
  final String message;

  const _DatabaseStartConfigurationException(this.message);
}
