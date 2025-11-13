import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';

/// Singleton instance of logger.
Logger? _logger;

/// Replacements for emojis that are not supported on Windows.
final Map<String, String> _windowsLoggerReplacements = {
  '🥳': '=D',
  '✅': AnsiStyle.bold.wrap(AnsiStyle.lightGreen.wrap('✓')),
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

  _logger = Platform.isWindows
      ? StdOutLogger(LogLevel.info, replacements: _windowsLoggerReplacements)
      : StdOutLogger(LogLevel.info);
}

/// Initializer for logger singleton.
/// Uses passed in [logger] to initialize the singleton.
/// This should only be called once from runtime entry points.
void initializeLoggerWith(Logger logger) {
  assert(
    _logger == null,
    'Only one logger initialization is allowed.',
  );

  _logger = logger;
}

/// Singleton accessor for logger.
/// Default initializes a [StdOutLogger] if initialization is not run before
/// this call.
Logger get log {
  if (_logger == null) {
    initializeLogger();
  }

  return _logger!;
}

extension SourceSpanExceptionLogger on Logger {
  /// Display a [SourceSpanException] to the user.
  /// Commands should use this to log [SourceSpanException] with
  /// enhanced highlighting if possible.
  void sourceSpanException(
    SourceSpanException sourceSpan, {
    bool newParagraph = false,
  }) {
    var logLevel = LogLevel.error;
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
  static LogLevel severityToLogLevel(SourceSpanSeverity severity) {
    switch (severity) {
      case SourceSpanSeverity.error:
        return LogLevel.error;
      case SourceSpanSeverity.warning:
        return LogLevel.warning;
      case SourceSpanSeverity.info:
      case SourceSpanSeverity.hint:
        return LogLevel.info;
    }
  }

  static String highlightAnsiCode(LogLevel severity, bool isHint) {
    if (severity == LogLevel.info && isHint) {
      return AnsiStyle.cyan.ansiCode;
    }

    switch (severity) {
      case LogLevel.nothing:
        assert(
          severity != LogLevel.nothing,
          'Log level nothing should never be used for a log message',
        );
        return AnsiStyle.terminalDefault.ansiCode;
      case LogLevel.error:
        return AnsiStyle.red.ansiCode;
      case LogLevel.warning:
        return AnsiStyle.yellow.ansiCode;
      case LogLevel.info:
        return AnsiStyle.blue.ansiCode;
      case LogLevel.debug:
        return AnsiStyle.cyan.ansiCode;
    }
  }
}
