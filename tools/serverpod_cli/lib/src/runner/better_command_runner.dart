import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';

/// A function type for executing code before running a command.
typedef OnBeforeRunCommand = Future<void> Function(
  BetterCommandRunner runner,
);

/// A function type for passing log messages.
typedef PassMessage = void Function(String message);

/// A function type for setting the log level.
/// The [logLevel] is the log level to set.
/// The [commandName] is the name of the command if custom rules for log
/// levels are needed.
typedef SetLogLevel = void Function({
  required CommandRunnerLogLevel parsedLogLevel,
  String? commandName,
});

/// A function type for tracking events.
typedef OnAnalyticsEvent = void Function(String event);

/// A custom implementation of [CommandRunner] with additional features.
///
/// This class extends the [CommandRunner] class from the `args` package and adds
/// additional functionality such as logging, setting log levels, tracking events,
/// and handling analytics.
///
/// The [BetterCommandRunner] class provides a more enhanced command line interface
/// for running commands and handling command line arguments.
class BetterCommandRunner extends CommandRunner {
  final PassMessage? _logError;
  final PassMessage? _logInfo;
  final SetLogLevel? _setLogLevel;
  final OnBeforeRunCommand? _onBeforeRunCommand;
  OnAnalyticsEvent? _onAnalyticsEvent;

  final ArgParser _argParser;

  /// Creates a new instance of [BetterCommandRunner].
  ///
  /// The [executableName] is the name of the executable for the command line interface.
  /// The [description] is a description of the command line interface.
  /// The [logError] function is used to pass error log messages.
  /// The [logInfo] function is used to pass informational log messages.
  /// The [setLogLevel] function is used to set the log level.
  /// The [onBeforeRunCommand] function is executed before running a command.
  /// The [onAnalyticsEvent] function is used to track events.
  /// The [wrapTextColumn] is the column width for wrapping text in the command line interface.
  BetterCommandRunner(
    super.executableName,
    super.description, {
    PassMessage? logError,
    PassMessage? logInfo,
    SetLogLevel? setLogLevel,
    OnBeforeRunCommand? onBeforeRunCommand,
    OnAnalyticsEvent? onAnalyticsEvent,
    int? wrapTextColumn,
  })  : _logError = logError,
        _logInfo = logInfo,
        _onBeforeRunCommand = onBeforeRunCommand,
        _setLogLevel = setLogLevel,
        _onAnalyticsEvent = onAnalyticsEvent,
        _argParser = ArgParser(usageLineLength: wrapTextColumn) {
    argParser.addFlag(
      BetterCommandRunnerFlags.quiet,
      abbr: BetterCommandRunnerFlags.quietAbbr,
      defaultsTo: false,
      negatable: false,
      help: 'Suppress all cli output. Is overridden by '
          ' -${BetterCommandRunnerFlags.verboseAbbr}, --${BetterCommandRunnerFlags.verbose}.',
    );

    argParser.addFlag(
      BetterCommandRunnerFlags.verbose,
      abbr: BetterCommandRunnerFlags.verboseAbbr,
      defaultsTo: false,
      negatable: false,
      help: 'Prints additional information useful for development. '
          'Overrides --${BetterCommandRunnerFlags.quietAbbr}, --${BetterCommandRunnerFlags.quiet}.',
    );

    if (_onAnalyticsEvent != null) {
      argParser.addFlag(
        BetterCommandRunnerFlags.analytics,
        abbr: BetterCommandRunnerFlags.analyticsAbbr,
        defaultsTo: true,
        negatable: true,
        help: 'Toggles if analytics data is sent. ',
      );
    }
  }

  @override
  ArgParser get argParser => _argParser;

  /// Adds a list of commands to the command runner.
  void addCommands(List<Command> commands) {
    for (var command in commands) {
      addCommand(command);
    }
  }

  /// Checks if analytics is enabled.
  bool analyticsEnabled() => _onAnalyticsEvent != null;

  @override
  ArgResults parse(Iterable<String> args) {
    try {
      return super.parse(args);
    } on UsageException catch (e) {
      _onAnalyticsEvent?.call(BetterCommandRunnerAnalyticsEvents.invalid);
      _logError?.call(e.toString());
      throw ExitException(ExitCodeType.commandNotFound);
    }
  }

  @override
  void printUsage() {
    _logInfo?.call(usage);
  }

  @override
  Future<void> runCommand(ArgResults topLevelResults) async {
    _setLogLevel?.call(
      parsedLogLevel: _parseLogLevel(topLevelResults),
      commandName: topLevelResults.command?.name,
    );

    if (argParser.options.containsKey(BetterCommandRunnerFlags.analytics) &&
        !topLevelResults[BetterCommandRunnerFlags.analytics]) {
      _onAnalyticsEvent = null;
    }

    await _onBeforeRunCommand?.call(this);

    try {
      await super.runCommand(topLevelResults);
      if (topLevelResults.command == null) {
        _onAnalyticsEvent?.call(BetterCommandRunnerAnalyticsEvents.help);
      } else {
        _onAnalyticsEvent?.call(topLevelResults.command!.name!);
      }
    } on UsageException catch (e) {
      _logError?.call(e.toString());
      _onAnalyticsEvent?.call(BetterCommandRunnerAnalyticsEvents.invalid);
      throw ExitException(ExitCodeType.commandNotFound);
    }
  }

  CommandRunnerLogLevel _parseLogLevel(ArgResults topLevelResults) {
    if (topLevelResults[BetterCommandRunnerFlags.verbose]) {
      return CommandRunnerLogLevel.verbose;
    } else if (topLevelResults[BetterCommandRunnerFlags.quiet]) {
      return CommandRunnerLogLevel.quiet;
    }

    return CommandRunnerLogLevel.normal;
  }
}

/// Constants for the command runner flags.
abstract class BetterCommandRunnerFlags {
  static const quiet = 'quiet';
  static const quietAbbr = 'q';
  static const verbose = 'verbose';
  static const verboseAbbr = 'v';
  static const analytics = 'analytics';
  static const analyticsAbbr = 'a';
}

/// Constants for the command runner analytics events.
abstract class BetterCommandRunnerAnalyticsEvents {
  static const help = 'help';
  static const invalid = 'invalid';
}

/// An enum for the command runner log levels.
enum CommandRunnerLogLevel { quiet, verbose, normal }
