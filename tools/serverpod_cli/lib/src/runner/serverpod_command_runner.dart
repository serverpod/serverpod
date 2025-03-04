import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/language_server.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/update_prompt/prompt_to_update.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

Future<void> _preCommandEnvironmentChecks() async {
  // Check that required tools are installed
  if (!await CommandLineTools.existsCommand('dart', ['--version'])) {
    log.error(
        'Failed to run serverpod. You need to have dart installed and in your \$PATH');
    throw ExitException.error();
  }
  if (!await CommandLineTools.existsCommand('flutter', ['--version'])) {
    log.error(
        'Failed to run serverpod. You need to have flutter installed and in your \$PATH');
    throw ExitException.error();
  }

  if (!loadEnvironmentVars()) {
    throw ExitException.error();
  }

  // Make sure all necessary downloads are installed
  if (!resourceManager.isTemplatesInstalled) {
    try {
      await resourceManager.installTemplates();
    } catch (e) {
      log.error('Failed to download templates.');
      throw ExitException.error();
    }

    if (!resourceManager.isTemplatesInstalled) {
      log.error(
          'Could not download the required resources for Serverpod. Make sure that you are connected to the internet and that you are using the latest version of Serverpod.');
      throw ExitException.error();
    }
  }
}

Future<void> _preCommandPrints(ServerpodCommandRunner runner) async {
  if (runner._productionMode) {
    await promptToUpdateIfNeeded(runner._cliVersion);
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

Future<void> _serverpodOnBeforeRunCommand(BetterCommandRunner runner) async {
  await _preCommandEnvironmentChecks();
  await _preCommandPrints(runner as ServerpodCommandRunner);
}

class ServerpodCommandRunner extends BetterCommandRunner {
  final bool _productionMode;
  final Version _cliVersion;

  ServerpodCommandRunner(
    super.executableName,
    super.description, {
    required bool productionMode,
    required Version cliVersion,
    super.messageOutput,
    super.onBeforeRunCommand,
    super.setLogLevel,
    super.onAnalyticsEvent,
  })  : _productionMode = productionMode,
        _cliVersion = cliVersion {
    argParser.addMultiOption(
      'experimental-features',
      help:
          'Enable experimental features. Experimental features might be removed at any time.',
      allowed: ExperimentalFeature.values.map((e) => e.name),
      defaultsTo: [],
    );
  }

  @override
  Future<void> runCommand(ArgResults topLevelResults) async {
    var enabledExperimentalFeatures = topLevelResults['experimental-features'];

    var experimentalFeatures = <ExperimentalFeature>[];
    for (var feature in enabledExperimentalFeatures) {
      log.info(
        'Enabling experimental feature: $feature.',
      );
      experimentalFeatures.add(ExperimentalFeature.fromString(feature));
    }
    CommandLineExperimentalFeatures.initialize(experimentalFeatures);
    await super.runCommand(topLevelResults);
  }

  static ServerpodCommandRunner createCommandRunner(
    Analytics analytics,
    bool productionMode,
    Version cliVersion, {
    OnBeforeRunCommand onBeforeRunCommand = _serverpodOnBeforeRunCommand,
  }) {
    return ServerpodCommandRunner(
      'serverpod',
      'Manage your serverpod app development',
      messageOutput: MessageOutput(
        logUsage: log.info,
        logUsageException: (UsageException e) => log.error(e.toString()),
      ),
      setLogLevel: _configureLogLevel,
      onBeforeRunCommand: onBeforeRunCommand,
      onAnalyticsEvent: (String event) => analytics.track(event: event),
      productionMode: productionMode,
      cliVersion: cliVersion,
    );
  }

  static void _configureLogLevel({
    required CommandRunnerLogLevel parsedLogLevel,
    String? commandName,
  }) {
    var logLevel = LogLevel.info;

    if (parsedLogLevel == CommandRunnerLogLevel.verbose) {
      logLevel = LogLevel.debug;
    } else if (parsedLogLevel == CommandRunnerLogLevel.quiet) {
      logLevel = LogLevel.nothing;
    } else if (commandName == LanguageServerCommand.commandName) {
      logLevel = LogLevel.nothing;
    }

    log.logLevel = logLevel;
  }
}
