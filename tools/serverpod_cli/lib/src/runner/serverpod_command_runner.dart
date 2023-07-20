import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analytics/analytics.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/update_prompt/prompt_to_update.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';

abstract class GlobalFlags {
  static const quiet = 'quiet';
  static const verbose = 'verbose';
}

typedef LoggerInit = void Function(LogLevel);
typedef PreCommandEnvironmentCheck = Future<void> Function();

Future<void> _preCommandEnvironmentChecks() async {
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

class ServerpodCommandRunner extends CommandRunner {
  final Analytics _analytics;
  final bool _productionMode;
  final Version _cliVersion;
  final LoggerInit _onLoggerInit;
  final PreCommandEnvironmentCheck _onPreCommandEnvironmentCheck;

  ServerpodCommandRunner({
    required Analytics analytics,
    required bool productionMode,
    required Version cliVersion,
    required LoggerInit onLoggerInit,
    required PreCommandEnvironmentCheck onPreCommandEnvironmentCheck,
    required String executableName,
    required String description,
  })  : _analytics = analytics,
        _productionMode = productionMode,
        _cliVersion = cliVersion,
        _onLoggerInit = onLoggerInit,
        _onPreCommandEnvironmentCheck = onPreCommandEnvironmentCheck,
        super(executableName, description) {
    argParser.addFlag(
      GlobalFlags.quiet,
      abbr: 'q',
      defaultsTo: false,
      negatable: false,
      help: 'Suppress all serverpod cli output. Is overridden by '
          ' -v, --verbose.',
    );

    argParser.addFlag(GlobalFlags.verbose,
        abbr: 'v',
        defaultsTo: false,
        negatable: false,
        help: 'Prints additional information useful for development. '
            'Overrides --q, --quiet.');
  }

  static ServerpodCommandRunner createCommandRunner(
    Analytics analytics,
    bool productionMode,
    Version cliVersion, {
    LoggerInit onLoggerInit = initializeLogger,
    PreCommandEnvironmentCheck onPreCommandEnvironmentCheck =
        _preCommandEnvironmentChecks,
  }) {
    return ServerpodCommandRunner(
      analytics: analytics,
      productionMode: productionMode,
      cliVersion: cliVersion,
      onLoggerInit: onLoggerInit,
      onPreCommandEnvironmentCheck: onPreCommandEnvironmentCheck,
      executableName: 'serverpod',
      description: 'Manage your serverpod app development',
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
    _initializeLogger(topLevelResults);

    await _onPreCommandEnvironmentCheck();
    await _preCommandPrints();

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

  void _initializeLogger(ArgResults topLevelResults) {
    var logLevel = LogLevel.info;

    if (topLevelResults[GlobalFlags.verbose]) {
      logLevel = LogLevel.debug;
    } else if (topLevelResults[GlobalFlags.quiet]) {
      logLevel = LogLevel.nothing;
    }

    _onLoggerInit(logLevel);
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
