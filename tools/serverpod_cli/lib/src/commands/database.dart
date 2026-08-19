import 'dart:io';

import 'package:ci/ci.dart' as ci;
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_database/embedded.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
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
      helpText: 'TCP port override. Defaults to the configured database port.',
    ),
  ),
  ;

  const DatabaseStartOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// Starts the configured embedded PostgreSQL database over loopback TCP.
class DatabaseStartCommand extends ServerpodCommand<DatabaseStartOption> {
  DatabaseStartCommand() : super(options: DatabaseStartOption.values);

  @override
  final name = 'start';

  @override
  final description =
      'Start the configured embedded PostgreSQL database over TCP.';

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
      var postgres = await _startFromServerpodConfig(
        serverDirectory: serverDirectory,
        runMode: commandConfig.value(DatabaseStartOption.mode),
        port: commandConfig.optionalValue(DatabaseStartOption.port),
      );

      log
        ..info('Embedded PostgreSQL is ready.')
        ..info('Connection URI: ${postgres.connectionString}')
        ..info(
          Platform.isMacOS ? 'Press ⌃C to stop.' : 'Press Ctrl+C to stop.',
        );

      while (postgres.isRunning) {
        await Future<void>.delayed(const Duration(seconds: 1));
      }
      await postgres.stop();
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

Future<EmbeddedPostgres> _startFromServerpodConfig({
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

  var dataPath = databaseConfig.dataPath;
  if (dataPath == null) {
    throw _DatabaseStartConfigurationException(
      'The command `serverpod database start` can only be used with an '
      'embedded database, but run mode "$runMode" uses an external database.',
    );
  }

  return EmbeddedPostgres.start(
    EmbeddedPostgresOptions(
      dataDir: Directory(
        p.isAbsolute(dataPath)
            ? dataPath
            : p.normalize(p.join(serverDir, dataPath)),
      ),
      databaseName: databaseConfig.name,
      username: databaseConfig.user,
      transport: TcpTransport(
        port: port ?? databaseConfig.port,
        password: databaseConfig.password,
      ),
      repairStaleLocks: true,
    ),
  );
}

final class _DatabaseStartConfigurationException implements Exception {
  final String message;

  const _DatabaseStartConfigurationException(this.message);
}
