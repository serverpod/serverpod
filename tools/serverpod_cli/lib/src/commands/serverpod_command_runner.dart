import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:ci/ci.dart' as ci;
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/commands/language_server.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/update_prompt/prompt_to_update.dart';
import 'package:serverpod_cli/src/util/browser_launcher.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/sdk_resolver.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

import '../generated/completion_script_carapace.dart';
import 'doctor.dart' show DoctorCommand;
import 'upgrade.dart' show UpgradeCommand;
import 'version.dart' show VersionCommand;

Future<void> _preCommandEnvironmentChecks() async {
  try {
    await sdkResolver.dartSdk;
  } on SdkResolutionException {
    log.error(
      'Failed to run serverpod. You need to have dart installed and in your \$PATH',
    );
    throw ExitException.error();
  }
  if (!ci.isCI && await sdkResolver.flutterSdk == null) {
    log.error(
      'Failed to run serverpod. You need to have flutter installed and in your \$PATH',
    );
    throw ExitException.error();
  }

  if (log.logLevel == LogLevel.debug) {
    log.debug(await sdkResolver.describeResolution());
  }
}

/// Pops the web browser on the first and 20th run.
///
/// If the user ID is not available, the welcome and check-in pages are
/// skipped, to avoid invoking the webpage every time the CLI is run if any
/// configuration prevents the CLI from writing to the user home directory.
Future<void> _preCommandWelcome() async {
  final runCount = resourceManager.runCount;
  final uuid = resourceManager.uniqueUserId;
  if (uuid == null) return;

  if (runCount == 1) {
    await BrowserLauncher.openUrl(
      Uri.parse('https://serverpod.dev/welcome?distinct_id=$uuid'),
    );
  } else if (runCount == 20) {
    await BrowserLauncher.openUrl(
      Uri.parse('https://serverpod.dev/checkin?distinct_id=$uuid'),
    );
  }
}

Future<void> _preCommandPrints(ServerpodCommandRunner runner) async {
  if (!runner._productionMode) {
    log.debug('Development mode.');
    return;
  }

  if (runner._invokedCommandName == UpgradeCommand.commandName) return;

  await promptToUpdateIfNeeded(runner._cliVersion);
}

Future<void> _serverpodOnBeforeRunCommand(BetterCommandRunner runner) async {
  runner as ServerpodCommandRunner;

  // Doctor reports on missing SDKs instead of refusing to run without them,
  // and scripts need its stdout and the user's profile left untouched.
  if (runner._invokedCommandName == DoctorCommand.commandName) return;

  await _preCommandEnvironmentChecks();
  await _preCommandWelcome();
  await _preCommandPrints(runner);
}

class ServerpodCommandRunner extends BetterCommandRunner<GlobalOption, void> {
  final bool _productionMode;
  final Version _cliVersion;
  String? _invokedCommandName;

  ServerpodCommandRunner(
    super.executableName,
    super.description, {
    required bool productionMode,
    required Version cliVersion,
    super.messageOutput,
    super.onBeforeRunCommand,
    super.setLogLevel,
    super.onAnalyticsEvent,
    super.enableCompletionCommand,
    super.embeddedCompletions,
  }) : _productionMode = productionMode,
       _cliVersion = cliVersion,
       super(globalOptions: GlobalOption.values);

  @override
  Future<void> runCommand(ArgResults topLevelResults) async {
    // `--no-analytics` is resolved by [BetterCommandRunner.run] before this
    // point, so this is the one place the opt-out state is final. Every `cli.*`
    // call site reads it from the singleton instead of taking a flag. Set
    // before the `--version` early return so the state is never stale.
    cliAnalytics.enabled = analyticsEnabled();

    // Installed before any command runs so every call site reads one answer.
    // Resolution itself is lazy, so a command that never touches an SDK never
    // pays for looking one up.
    initializeSdkResolver();

    if (globalConfiguration.value(GlobalOption.version)) {
      await commands['version']?.run();
      return; // Exit early to prevent showing help text
    }

    var experimentalFeatures = globalConfiguration.value(
      GlobalOption.experimentalFeatures,
    );

    for (var feature in experimentalFeatures) {
      log.info('Enabling experimental feature: ${feature.name}.');
    }
    CommandLineExperimentalFeatures.initialize(experimentalFeatures);

    // Counted straight off the registered command list, so a renamed or newly
    // added command is picked up without touching the analytics code.
    final commandName = _invokedCommandName = topLevelResults.command?.name;
    if (commandName != null &&
        commands.containsKey(commandName) &&
        cliAnalytics.enabled) {
      final serverDir = findServerDirectory(Directory.current);
      if (serverDir != null) {
        unawaited(
          cliAnalytics.recordCommandInvocation(
            serverDir: serverDir.path,
            commandName: commandName,
          ),
        );
      }
    }

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
      enableCompletionCommand: true,
      embeddedCompletions: [completionScriptCarapace],
      messageOutput: MessageOutput(
        usageLogger: log.info,
      ),
      setLogLevel: _configureLogLevel,
      onBeforeRunCommand: onBeforeRunCommand,
      onAnalyticsEvent: (event, properties) => analytics.track(
        event: event,
        properties: properties,
      ),
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

/// The options every command accepts.
enum GlobalOption<V> implements OptionDefinition<V> {
  quiet(BetterCommandRunnerFlags.quietOption),
  verbose(BetterCommandRunnerFlags.verboseOption),
  analytics(BetterCommandRunnerFlags.analyticsOption),
  interactive(
    FlagOption(
      argName: 'interactive',
      negatable: true,
      helpText:
          'Enable interactive prompts. Automatically disabled in CI environments.',
    ),
  ),
  version(
    FlagOption(
      argName: 'version',
      helpText: VersionCommand.usageDescription,
      negatable: false,
      defaultsTo: false,
    ),
  ),
  experimentalFeatures(
    MultiOption<ExperimentalFeature>(
      multiParser: MultiParser(EnumParser(ExperimentalFeature.values)),
      argName: 'experimental-features',
      defaultsTo: [],
      helpText:
          'Enable experimental features. Experimental features might be removed at any time.',
    ),
  ),
  ;

  const GlobalOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}
