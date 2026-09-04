import 'dart:io';

import 'package:cli_tools/cli_tools.dart' as cli;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_shared/log.dart' as shared;
import 'package:serverpod_shared/log_io.dart';

// ---------------------------------------------------------------------------
// Singleton logger
// ---------------------------------------------------------------------------

/// Singleton instance of logger.
cli.Logger? _logger;

/// Whether [_logger] is the default one [initializeLogger] installs.
bool _loggerIsDefault = false;

/// Replacements for emojis that are not supported on Windows.
final Map<String, String> _windowsLoggerReplacements = {
  '🥳': '=D',
  '✅': cli.AnsiStyle.bold.wrap(cli.AnsiStyle.lightGreen.wrap('✓')),
  '🚀': '',
  '📦': '',
};

/// Initializer for logger singleton.
/// Runs checks to pick the best suitable logger for the environment.
/// This should only be called once from runtime entry points.
void initializeLogger() {
  assert(
    _logger == null,
    'Only one logger initialization is allowed.',
  );

  _logger = ServerpodCliLogger(stdOutLogWriter());
  _loggerIsDefault = true;
  _attachGlobalLogBridge();
}

/// Whether the logger singleton is the default one [initializeLogger] installs,
/// rather than one something else put there.
///
/// A command that wants its output somewhere else too asks this before
/// replacing the singleton. Composing over the CLI's own logger redirects only
/// what this entry point set up. Composing over an installed one, a test's or
/// an embedder's, takes away what that installer is there to see.
bool get loggerIsDefault => _logger == null || _loggerIsDefault;

/// The writer [initializeLogger] installs, putting the CLI's own output on
/// stdout.
///
/// Exposed for a command that writes elsewhere too. The runner records its
/// output in the history it serves attached clients, and composes this in for
/// the terminal half.
shared.LogWriter stdOutLogWriter() => IsolatedLogWriter(
  () => StdOutLogWriter(
    replacements: Platform.isWindows ? _windowsLoggerReplacements : null,
  ),
);

/// Replaces the logger singleton with the given [logger].
///
/// Preserves the current log level if a logger was already set.
void initializeLoggerWith(cli.Logger logger) {
  final previous = _logger;
  if (previous != null) {
    logger.logLevel = previous.logLevel;
  }
  _logger = logger;
  _loggerIsDefault = false;
  _attachGlobalLogBridge();
}

/// Singleton accessor for logger.
/// Default initializes a [ServerpodCliLogger] if initialization is not run
/// before this call.
cli.Logger get log {
  if (_logger == null) {
    initializeLogger();
  }

  return _logger!;
}

extension SourceSpanExceptionLogger on cli.Logger {
  /// Display a [SourceSpanException] to the user.
  /// Commands should use this to log [SourceSpanException] with
  /// enhanced highlighting if possible.
  void sourceSpanException(
    SourceSpanException sourceSpan, {
    bool newParagraph = false,
  }) {
    var logLevel = cli.LogLevel.error;
    bool isHint = false;

    if (sourceSpan is SourceSpanSeverityException) {
      var severity = sourceSpan.severity;
      isHint = severity == SourceSpanSeverity.hint;
      logLevel = _SeveritySpanHelpers.severityToLogLevel(severity);
    }

    if (!(logLevel.index >= log.logLevel.index)) return;

    var highlightAnsiCode = _SeveritySpanHelpers.highlightAnsiCode(
      logLevel,
      isHint,
    );
    var message = sourceSpan.toString(color: highlightAnsiCode);

    write(message, logLevel, newParagraph: newParagraph);
  }
}

abstract class _SeveritySpanHelpers {
  static cli.LogLevel severityToLogLevel(SourceSpanSeverity severity) {
    switch (severity) {
      case SourceSpanSeverity.error:
        return cli.LogLevel.error;
      case SourceSpanSeverity.warning:
        return cli.LogLevel.warning;
      case SourceSpanSeverity.info:
      case SourceSpanSeverity.hint:
        return cli.LogLevel.info;
    }
  }

  static String highlightAnsiCode(cli.LogLevel severity, bool isHint) {
    if (severity == cli.LogLevel.info && isHint) {
      return cli.AnsiStyle.cyan.ansiCode;
    }

    switch (severity) {
      case cli.LogLevel.nothing:
        assert(
          severity != cli.LogLevel.nothing,
          'Log level nothing should never be used for a log message',
        );
        return cli.AnsiStyle.terminalDefault.ansiCode;
      case cli.LogLevel.error:
        return cli.AnsiStyle.red.ansiCode;
      case cli.LogLevel.warning:
        return cli.AnsiStyle.yellow.ansiCode;
      case cli.LogLevel.info:
        return cli.AnsiStyle.blue.ansiCode;
      case cli.LogLevel.debug:
        return cli.AnsiStyle.cyan.ansiCode;
    }
  }
}

/// Shuts down and closes the logger, releasing any isolate resources.
Future<void> closeLogger() async {
  await _detachGlobalLogBridge();
  final logger = _logger;
  _logger = null;
  _loggerIsDefault = false;
  if (logger == null) return;
  await logger.flush();
  if (logger is ServerpodCliLogger) {
    await logger.close();
  }
}

// ---------------------------------------------------------------------------
// Global log bridge
// ---------------------------------------------------------------------------

/// Forwards records written to the global [shared.log] - the logger that
/// packages shared with the server, such as `serverpod_database`, write to - to
/// the CLI logger singleton.
///
/// The global [shared.logWriter] chain starts out empty and entry points are
/// expected to populate it. The server does so through `ServerpodLogSetup`;
/// the CLI never did, so every record a shared package emitted was silently
/// dropped for the whole CLI process.
///
/// Forwarding to the singleton rather than registering the singleton's own
/// writer on the chain keeps a single output path: whichever logger is
/// installed - stdout, the TUI, an isolate port forwarder, a test logger -
/// receives the record, and its log level and `--quiet` handling apply to it
/// unchanged.
class _GlobalLogBridge extends LogWriter {
  @override
  Future<void> log(LogEntry entry) async {
    // Read the singleton directly rather than through `log`, which would
    // resurrect a logger that `closeLogger` has just torn down.
    final logger = _logger;
    if (logger == null) return;

    // cli.Logger has no error argument, and the record is dropped rather than
    // rendered if it is not folded into the message.
    final message = entry.error == null
        ? entry.message
        : '${entry.message}\n${entry.error}';
    final metadataType = entry.metadata?[logTypeKey];
    final type = metadataType is cli.LogType
        ? metadataType
        : cli.TextLogType.normal;

    switch (entry.level) {
      case LogLevel.debug:
        logger.debug(message, type: type);
      case LogLevel.info:
        logger.info(message, type: type);
      case LogLevel.warning:
        logger.warning(message, type: type);
      case LogLevel.error:
      case LogLevel.fatal:
        logger.error(message, stackTrace: entry.stackTrace, type: type);
    }
  }

  /// Scopes are progress reporting, which the CLI drives through
  /// [cli.Logger.progress] on its own logger. Entries logged inside a scope
  /// still reach [log], only the scope's own start and end are not rendered.
  @override
  Future<void> openScope(LogScope scope) async {}

  @override
  Future<void> closeScope(
    LogScope scope, {
    required bool success,
    required Duration duration,
    Object? error,
    StackTrace? stackTrace,
  }) async {}
}

final _globalLogBridge = _GlobalLogBridge();
bool _globalLogBridgeAttached = false;
LogLevel? _globalLogLevelBeforeBridge;

/// Registers [_globalLogBridge] on the global writer chain. Idempotent, so
/// swapping the logger singleton does not stack up bridges.
void _attachGlobalLogBridge() {
  if (_globalLogBridgeAttached) return;
  _globalLogBridgeAttached = true;

  // Severity filtering belongs to the CLI logger, which owns the verbosity
  // flags. Opening the global filter all the way lets `-v` reach the shared
  // packages instead of their debug records being dropped before the bridge.
  _globalLogLevelBeforeBridge = shared.log.logLevel;
  shared.log.logLevel = LogLevel.debug;

  shared.logWriter.add(_globalLogBridge);
}

/// Undoes [_attachGlobalLogBridge], leaving the globals as they were found.
Future<void> _detachGlobalLogBridge() async {
  if (!_globalLogBridgeAttached) return;
  _globalLogBridgeAttached = false;

  // Records already dispatched are only handed to the writers in the chain at
  // the time they are written, so drain them before dropping out of it.
  await shared.log.flush();

  shared.logWriter.remove(_globalLogBridge);
  shared.log.logLevel = _globalLogLevelBeforeBridge ?? LogLevel.info;
  _globalLogLevelBeforeBridge = null;
}
