import 'dart:async';
import 'dart:io';

import 'package:ci/ci.dart' as ci;
import 'package:cli_tools/cli_tools.dart';
import 'package:config/command.dart';
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

import 'doctor.dart' show DoctorCommand;
import 'serverpod_command.dart';
import 'upgrade.dart' show UpgradeCommand;
import 'version.dart' show VersionCommand, printServerpodCliVersion;

typedef GlobalConfiguration = Configuration<GlobalOption>;

/// Whether this CLI build is a release build.
///
/// Development builds skip the update prompt.
class ProductionMode {
  const ProductionMode(this.enabled);

  final bool enabled;
}

Future<void> _preCommandEnvironmentChecks() async {
  try {
    try {
      await sdkResolver.dartSdk;
    } on SdkResolutionException {
      log.error(
        'Failed to run serverpod. You need to have dart installed and in your \$PATH',
      );
      throw ExitException.error();
    }
    if (!ci.isCI && !await sdkResolver.isFlutterInstalled) {
      log.error(
        'Failed to run serverpod. You need to have flutter installed and in your \$PATH',
      );
      if (await CommandLineTools.existsCommand('fvm', ['--version'])) {
        // Raw, so text wrapping never breaks a command across lines.
        log.error('\n${_fvmShimInstructions()}\n', type: const RawLogType());
      }
      throw ExitException.error();
    }

    if (log.logLevel == LogLevel.debug) {
      log.debug(await sdkResolver.describeResolution());
    }
  } on SdkResolutionTimeoutException catch (e) {
    log.error('Failed to run serverpod. ${e.message}');
    throw ExitException.error();
  }
}

/// Returns the page to open on the [runCount]th run: the welcome page on the
/// first run, the check-in page on the 20th, and null otherwise.
///
/// The Serverpod CLI ID is only added when [analyticsEnabled] is true.
Uri? welcomePageUrl({
  required int runCount,
  required String serverpodCliId,
  required bool analyticsEnabled,
}) {
  final query = analyticsEnabled ? '?serverpod_cli_id=$serverpodCliId' : '';
  return switch (runCount) {
    1 => Uri.parse('https://serverpod.dev/welcome$query'),
    20 => Uri.parse('https://serverpod.dev/checkin$query'),
    _ => null,
  };
}

/// Pops the web browser on the first and 20th run.
///
/// If the user ID is not available, the welcome and check-in pages are
/// skipped, to avoid invoking the webpage every time the CLI is run if any
/// configuration prevents the CLI from writing to the user home directory.
Future<void> _preCommandWelcome(CommandContext context) async {
  final runCount = resourceManager.runCount;
  final uuid = resourceManager.uniqueUserId;
  if (uuid == null) return;

  final analyticsEnabled =
      context.provider.maybeFetch<AnalyticsEnabled>()?.enabled ?? false;

  final url = welcomePageUrl(
    runCount: runCount,
    serverpodCliId: uuid,
    analyticsEnabled: analyticsEnabled,
  );
  if (url != null) await BrowserLauncher.openUrl(url);
}

/// How fvm users put `fvm flutter` behind a `flutter` on their PATH.
String _fvmShimInstructions() {
  // Without a project pin or a global version, `fvm flutter` runs the
  // `flutter` on PATH, which is the shim itself.
  const globalVersion =
      'Also set a version with `fvm global <version>`, or the shim ends up\n'
      'calling itself outside projects pinned with fvm.';
  if (Platform.isWindows) {
    return 'If you use fvm, create `%USERPROFILE%\\.fvm_shim` and save a '
        '`flutter.bat`\n'
        'file in it containing this line:\n'
        '\n'
        '  @fvm flutter %*\n'
        '\n'
        'Add that folder to the front of your PATH environment variable\n'
        'and reopen your terminal.\n'
        '\n'
        '$globalVersion\n'
        '\n'
        'Then verify:\n'
        '\n'
        '  where.exe flutter\n'
        '\n'
        'The first result from `where.exe flutter` should be your '
        '`flutter.bat` shim.';
  }
  return 'If you use fvm, add a `flutter` that runs `fvm flutter`:\n'
      '\n'
      '  mkdir -p ~/.fvm_shim\n'
      '  printf \'#!/bin/sh\\nexec fvm flutter "\$@"\\n\' > ~/.fvm_shim/flutter\n'
      '  chmod +x ~/.fvm_shim/flutter\n'
      '\n'
      'Put the shim directory at the front of your \$PATH:\n'
      '\n'
      '  export PATH="\$HOME/.fvm_shim:\$PATH"\n'
      '\n'
      'Reopen your terminal.\n'
      '\n'
      '$globalVersion\n'
      '\n'
      'Then verify:\n'
      '\n'
      '  which flutter\n'
      '\n'
      '`which flutter` should report your `~/.fvm_shim/flutter` shim.';
}

Future<void> _preCommandPrints(
  CommandContext<GlobalOption, void> context,
  ServerpodCommandRunner runner,
) async {
  if (!context.provider.fetch<ProductionMode>().enabled) {
    log.debug('Development mode.');
    return;
  }

  if (context.next?.command is UpgradeCommand) {
    return;
  }

  await promptToUpdateIfNeeded(runner.cliVersion);
}

/// Runs before [setLogLevel].
///
/// Skips completion requests. Skips the experimental-feature announcement for
/// the global `--version` action, which used to return before that code.
void _prepareRun(CommandContext<GlobalOption, void> context) {
  if (context.runMode == CommandRunMode.completion) return;

  initializeSdkResolver();
  context.provider.store<GlobalConfiguration>(context.globalConfiguration);

  if (_isRunningVersion(context)) return;

  final experimentalFeatures = context.config.value(
    GlobalOption.experimentalFeatures,
  );
  for (final feature in experimentalFeatures) {
    log.info('Enabling experimental feature: ${feature.name}.');
  }
  CommandLineExperimentalFeatures.initialize(experimentalFeatures);
}

/// Runs after the built-in analytics middleware and [setLogLevel].
///
/// The global `--version` action used to return before the invocation record
/// and before [setLogLevel], so the version line is printed at the default
/// log level.
Future<void> _beforeCommand(CommandContext<GlobalOption, void> context) async {
  if (context.runMode == CommandRunMode.completion) return;

  final analyticsEnabled =
      context.provider.maybeFetch<AnalyticsEnabled>()?.enabled ?? false;
  cliAnalytics.enabled = analyticsEnabled;

  if (_isRunningVersion(context)) {
    log.logLevel = LogLevel.info;
    return;
  }

  final command = context.next?.command;
  if (command is ServerpodCommand && cliAnalytics.enabled) {
    final serverDir = findServerDirectory(Directory.current);
    if (serverDir != null) {
      unawaited(
        cliAnalytics.recordCommandInvocation(
          serverDir: serverDir.path,
          commandName: command.name,
        ),
      );
    }
  }
}

/// Environment checks, the welcome page, and the update prompt.
///
/// Runs after [setLogLevel], so `--quiet` and the language server suppress
/// the checks. Skipped for completion and the global `--version` action, which
/// return before this work, and for `doctor`, which reports missing SDKs
/// itself and must leave stdout and the user profile untouched.
Future<void> _runPreCommandHooks(
  CommandContext<GlobalOption, void> context,
  ServerpodCommandRunner runner,
) async {
  if (context.runMode == CommandRunMode.completion) return;
  if (_isRunningVersion(context)) return;

  if (context.next?.command is DoctorCommand) return;

  await _preCommandEnvironmentChecks();
  await _preCommandWelcome(context);
  await _preCommandPrints(context, runner);
}

class ServerpodCommandRunner extends BetterCommandRunner<GlobalOption, void> {
  /// The version of this CLI build. Fixed when the command tree is built.
  final Version cliVersion;

  ServerpodCommandRunner._(
    super.executableName,
    super.description, {
    required bool productionMode,
    required bool preCommandHooks,
    required this.cliVersion,
    required super.globalOptions,
    required Analytics analytics,
  }) : super(
         parserSettings: const ParserSettings(
           doubleDashHandling: DoubleDashHandling.passThroughRest,
         ),
         usageOutput: UsageOutputHandler(
           sinks: OutputSinks(
             out: _LogSink(
               (message) => log.info(message, type: const RawLogType()),
             ),
             err: _LogSink(
               (message) => log.error(message, type: const RawLogType()),
             ),
           ),
           usageSettings: UsageSettings(usageLineLength: log.wrapTextColumn),
         ),
         setLogLevel: _configureLogLevel,
         onAnalyticsEvent: (context, event, properties) => analytics.track(
           event: event,
           properties: properties,
         ),
         prependMiddlewares: [
           Middlewares.onBeforeRun((context) {
             context.provider.store(ProductionMode(productionMode));
           }),
           Middlewares.onBeforeRun(_prepareRun),
         ],
       ) {
    addMiddleware(
      Middlewares.onBeforeRun(_beforeCommand),
    );
    if (preCommandHooks) {
      addMiddleware(
        Middlewares.onBeforeRun(
          (context) => _runPreCommandHooks(context, this),
        ),
      );
    }
  }

  static ServerpodCommandRunner createCommandRunner(
    Analytics analytics,
    bool productionMode,
    Version cliVersion, {
    bool preCommandHooks = true,
  }) {
    return ServerpodCommandRunner._(
      'serverpod',
      'Manage your serverpod app development',
      productionMode: productionMode,
      preCommandHooks: preCommandHooks,
      cliVersion: cliVersion,
      globalOptions: GlobalOption.values,
      analytics: analytics,
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

bool _isRunningVersion(CommandContext<GlobalOption, void> rootContext) {
  if (rootContext.runMode != CommandRunMode.execution) return false;
  // if (rootContext.leaf().command is VersionCommand) return true;
  if (rootContext.specifiedActionOptions().firstOrNull is VersionOption) {
    return true;
  }
  return false;
}

class _LogSink implements StringSink {
  _LogSink(this._log);

  final void Function(String message) _log;

  @override
  void write(Object? object) {
    final text = object?.toString() ?? '';
    if (text.isEmpty) return;
    _log(text);
  }

  @override
  void writeAll(Iterable<dynamic> objects, [String separator = '']) {
    write(objects.join(separator));
  }

  @override
  void writeCharCode(int charCode) {
    write(String.fromCharCode(charCode));
  }

  @override
  void writeln([Object? object = '']) {
    write('$object\n');
  }
}

extension ServerpodContext<O extends OptionDefinition, T>
    on CommandContext<O, T> {
  GlobalConfiguration get globalConfiguration =>
      root().config as GlobalConfiguration;
}

/// Prints the CLI version wherever `--version` is used as the global action.
class VersionOption extends FlagOption with ActionOptionMixin<bool> {
  const VersionOption()
    : super(
        argName: 'version',
        helpText: VersionCommand.usageDescription,
        negatable: false,
        defaultsTo: false,
      );

  @override
  FutureOr<R?> run<O extends OptionDefinition, R>(
    CommandContext<O, R> context,
  ) {
    final command = context.command;
    if (command is! ServerpodCommandRunner) {
      throw StateError('Version option is only defined on the runner.');
    }
    printServerpodCliVersion((command as ServerpodCommandRunner).cliVersion);
    return null;
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
  version(VersionOption()),
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
