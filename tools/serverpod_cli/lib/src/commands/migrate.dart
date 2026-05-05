import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/migrations/cli_migration_runner.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Options for the `migrate` command.
enum MigrateOption<V> implements OptionDefinition<V> {
  mode(
    StringOption(
      argName: 'mode',
      defaultsTo: 'development',
      helpText:
          'The run mode whose config + passwords are used to connect '
          'to the database.',
    ),
  ),
  ;

  const MigrateOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// `serverpod migrate` - applies pending migrations to the database
/// using the same config the pod would use, without restarting the pod.
class MigrateCommand extends ServerpodCommand<MigrateOption> {
  @override
  final name = 'migrate';

  @override
  final bool hidden = true;

  @override
  final description =
      'Applies pending database migrations using the project config and '
      'passwords. Does not require a running pod; safe to run while a '
      'pod is up since migrations apply over a separate connection.';

  MigrateCommand() : super(options: MigrateOption.values);

  @override
  Future<void> runWithConfig(Configuration<MigrateOption> commandConfig) async {
    final runMode = commandConfig.value(MigrateOption.mode);
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

    final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
    final moduleName = config.name;

    log.info('Applying migrations for "$moduleName" (mode: $runMode)...');

    try {
      await applyPendingMigrations(
        serverDir: serverDir,
        runMode: runMode,
        moduleName: moduleName,
      );
    } catch (e, s) {
      log.error('Migration failed: $e', stackTrace: s);
      throw ExitException.error();
    }
  }
}
