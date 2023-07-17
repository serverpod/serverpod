import 'dart:io';

import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/logger/loggers/std_out_logger.dart';

/// Serverpods internal logger interface.
/// All logging output should go through this interface.
/// The purpose is to simplify implementing and switching out concrete logger
/// implementations.
abstract class Logger {
  final LogLevel logLevel;

  Logger(this.logLevel);

  /// Display debug [message] to the user.
  /// Commands should use this for information that is important for
  /// debugging purposes.
  void debug(
    String message, {
    LogStyle style,
  });

  /// Display a normal [message] to the user.
  /// Command should use this as the standard communication channel for
  /// success, progress or information messages.
  void info(
    String message, {
    LogStyle style,
  });

  /// Display a warning [message] to the user.
  /// Commands should use this if they have important but not critical
  /// information for the user.
  void warning(
    String message, {
    LogStyle style,
  });

  /// Display an error [message] to the user.
  /// Commands should use this if they want to inform a user that an error
  /// has occurred.
  void error(
    String message, {
    StackTrace? stackTrace,
    LogStyle style,
  });

  /// Display a [SourceSpanSeverityException] to the user.
  /// Commands should use this to log [SourceSpanSeverityException] with
  /// enhanced highlighting if possible.
  void sourceSpanSeverityException(
    SourceSpanSeverityException sourceSpan, {
    bool newParagraph,
  });

  /// Returns a [Future] that completes once all logging is complete.
  Future<void> flush();
}

enum LogLevel {
  debug,
  info,
  warning,
  error,
  nothing,
}

enum AbstractStyleType {
  normal,
  hint,
  success,
  bullet,
  command,
}

/// Minimum formatting for style.
class LogStyle {
  final bool newParagraph;

  const LogStyle({
    this.newParagraph = false,
  });
}

/// Box style console formatting.
/// If [title] is set the box will have a title row.
class BoxLogStyle extends LogStyle {
  final String? title;
  const BoxLogStyle({
    this.title,
    bool newParagraph = true,
  }) : super(newParagraph: newParagraph);
}

/// Abstract style console formatting.
/// Enables more precise settings for log message.
class TextLogStyle extends LogStyle {
  final bool wordWrap;
  final AbstractStyleType type;

  const TextLogStyle({
    this.type = AbstractStyleType.normal,
    this.wordWrap = true,
    bool newParagraph = false,
  }) : super(newParagraph: newParagraph);
}

/// Singleton instance of logger.
Logger? _logger;

/// Initializer for logger singleton.
/// Runs checks to pick the best suitable logger for the environment.
/// This should only be called once from runtime entry points.
void initializeLogger(LogLevel logLevel) {
  assert(
    _logger == null,
    'Only one logger initialization is allowed.',
  );

  _logger = Platform.isWindows
      ? WindowsStdOutLogger(logLevel)
      : StdOutLogger(logLevel);
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
  _logger ??= StdOutLogger(LogLevel.debug);
  return _logger!;
}
