import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analytics/analytics.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/update_prompt/prompt_to_update.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';

abstract class GlobalFlags {
  static const developmentPrint = 'development-print';
}

class ServerpodCommandRunner extends CommandRunner {
  final Analytics _analytics;
  final bool _productionMode;
  final Version _cliVersion;

  ServerpodCommandRunner(
    this._analytics,
    this._productionMode,
    this._cliVersion,
    super.executableName,
    super.description,
  ) {
    argParser.addFlag(
      GlobalFlags.developmentPrint,
      defaultsTo: true,
      negatable: true,
      help: 'Prints additional information useful for development.',
    );
  }

  static ServerpodCommandRunner createCommandRunner(
    Analytics analytics,
    bool productionMode,
    Version cliVersion,
  ) {
    return ServerpodCommandRunner(
      analytics,
      productionMode,
      cliVersion,
      'serverpod',
      'Manage your serverpod app development',
    );
  }

  @override
  ArgResults parse(Iterable<String> args) {
    try {
      return super.parse(args);
    } on UsageException catch (e) {
      _analytics.track(event: 'invalid');
      log.error(e.toString(), style: const LogStyle());
      throw ExitException(ExitCodeType.commandNotFound);
    }
  }

  @override
  Future<void> runCommand(ArgResults topLevelResults) async {
    // TODO: Add flaggs for setting log level.
    // For now, use old behavior and log everything.
    initializeLogger(LogLevel.debug);

    await _preCommandChecks();

    // TODO: [GlobalFlags.developmentPrint] should silence all logging with a
    // suitable name. Make this once we have a centralized logging and printing.
    if (topLevelResults[GlobalFlags.developmentPrint]) {
      await _preCommandPrints();
    }

    try {
      await super.runCommand(topLevelResults);
      if (topLevelResults.command == null) {
        _analytics.track(event: 'help');
      } else {
        _analytics.track(event: topLevelResults.command!.name!);
      }
    } on UsageException catch (e) {
      log.error(e.toString(), style: const LogStyle());
      _analytics.track(event: 'invalid');
      throw ExitException(ExitCodeType.commandNotFound);
    }
  }

  @override
  void printUsage() {
    log.info(usage, style: const LogStyle());
  }

  @override
  ArgParser get argParser => _argParser;
  final ArgParser _argParser = ArgParser(usageLineLength: log.wrapTextColumn);

  Future<void> _preCommandChecks() async {
    if (Platform.isWindows) {
      log.warning(
          'Windows is not officially supported yet. Things may or may not work '
          'as expected.');
    }

    // Check that required tools are installed
    if (!await CommandLineTools.existsCommand('dart')) {
      log.error(
          'Failed to run serverpod. You need to have dart installed and in your \$PATH');
      throw ExitException();
    }
    if (!await CommandLineTools.existsCommand('flutter')) {
      log.error(
          'Failed to run serverpod. You need to have flutter installed and in your \$PATH');
      throw ExitException();
    }

    if (!loadEnvironmentVars()) {
      throw ExitException();
    }

    // Make sure all necessary downloads are installed
    if (!resourceManager.isTemplatesInstalled) {
      try {
        await resourceManager.installTemplates();
      } catch (e) {
        log.error('Failed to download templates.');
        throw ExitException();
      }

      if (!resourceManager.isTemplatesInstalled) {
        log.error(
            'Could not download the required resources for Serverpod. Make sure that you are connected to the internet and that you are using the latest version of Serverpod.');
        throw ExitException();
      }
    }
  }

  Future<void> _preCommandPrints() async {
    if (_productionMode) {
      await promptToUpdateIfNeeded(_cliVersion);
    } else {
      log.debug(
        'Development mode. Using templates from: ${resourceManager.templateDirectory.path}',
      );
      log.debug('SERVERPOD_HOME is set to $serverpodHome');

      if (!resourceManager.isTemplatesInstalled) {
        log.warning('Could not find templates.');
      }
    }
  }
}
