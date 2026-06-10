import 'dart:io';

import 'package:cli_tools/cli_tools.dart' as cli;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_shared/log_io.dart';

// ---------------------------------------------------------------------------
// Singleton logger
// ---------------------------------------------------------------------------

/// Singleton instance of logger.
cli.Logger? _logger;

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

  _logger = ServerpodCliLogger(
    IsolatedLogWriter(
      () => StdOutLogWriter(
        replacements: Platform.isWindows ? _windowsLoggerReplacements : null,
      ),
    ),
  );
}

/// Replaces the logger singleton with the given [logger].
///
/// Preserves the current log level if a logger was already set.
void initializeLoggerWith(cli.Logger logger) {
  final previous = _logger;
  if (previous != null) {
    logger.logLevel = previous.logLevel;
  }
  _logger = logger;
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
  final logger = _logger;
  _logger = null;
  if (logger == null) return;
  await logger.flush();
  if (logger is ServerpodCliLogger) {
    await logger.close();
  }
}
