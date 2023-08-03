import 'dart:io';

import 'package:serverpod_cli/src/logger/loggers/std_out_logger.dart';
import 'package:source_span/source_span.dart';

/// Serverpods internal logger interface.
/// All logging output should go through this interface.
/// The purpose is to simplify implementing and switching out concrete logger
/// implementations.
abstract class Logger {
  LogLevel logLevel;

  /// If defined, defines what column width text should be wrapped.
  int? get wrapTextColumn;

  Logger(this.logLevel);

  /// Display debug [message] to the user.
  /// Commands should use this for information that is important for
  /// debugging purposes.
  void debug(
    String message, {
    bool newParagraph,
    LogType type,
  });

  /// Display a normal [message] to the user.
  /// Command should use this as the standard communication channel for
  /// success, progress or information messages.
  void info(
    String message, {
    bool newParagraph,
    LogType type,
  });

  /// Display a warning [message] to the user.
  /// Commands should use this if they have important but not critical
  /// information for the user.
  void warning(
    String message, {
    bool newParagraph,
    LogType type,
  });

  /// Display an error [message] to the user.
  /// Commands should use this if they want to inform a user that an error
  /// has occurred.
  void error(
    String message, {
    bool newParagraph,
    StackTrace? stackTrace,
    LogType type,
  });

  /// Display a [SourceSpanException] to the user.
  /// Commands should use this to log [SourceSpanException] with
  /// enhanced highlighting if possible.
  void sourceSpanException(
    SourceSpanException sourceSpan, {
    bool newParagraph,
  });

  /// Display a progress message on [LogLevel.info] while running [runner]
  /// function.
  ///
  /// Uses return value from [runner] to print set progress success status.
  /// Returns return value from [runner].
  Future<bool> progress(
    String message,
    Future<bool> Function() runner, {
    bool newParagraph,
  });

  /// Returns a [Future] that completes once all logging is complete.
  Future<void> flush();
}

enum LogLevel {
  debug('debug'),
  info('info'),
  warning('warning'),
  error('error'),
  nothing('nothing');

  const LogLevel(this.name);
  final String name;
}

enum TextLogStyle {
  init,
  normal,
  hint,
  header,
  bullet,
  command,
  success,
}

abstract class LogType {
  const LogType();
}

/// Does not apply any formatting to the log before logging.
/// Assumes log is formatted with end line symbol.
class RawLogType extends LogType {
  const RawLogType();
}

/// Box style console formatting.
/// If [title] is set the box will have a title row.
class BoxLogType extends LogType {
  final String? title;
  const BoxLogType({
    this.title,
    bool newParagraph = true,
  });
}

/// Abstract style console formatting.
/// Enables more precise settings for log message.
class TextLogType extends LogType {
  static const init = TextLogType(style: TextLogStyle.init);
  static const normal = TextLogType(style: TextLogStyle.normal);
  static const hint = TextLogType(style: TextLogStyle.hint);
  static const header = TextLogType(style: TextLogStyle.header);
  static const bullet = TextLogType(style: TextLogStyle.bullet);
  static const command = TextLogType(style: TextLogStyle.command);
  static const success = TextLogType(style: TextLogStyle.success);

  final TextLogStyle style;

  const TextLogType({required this.style});
}

/// Singleton instance of logger.
Logger? _logger;

/// Initializer for logger singleton.
/// Runs checks to pick the best suitable logger for the environment.
/// This should only be called once from runtime entry points.
void initializeLogger() {
  assert(
    _logger == null,
    'Only one logger initialization is allowed.',
  );

  _logger = Platform.isWindows
      ? WindowsStdOutLogger(LogLevel.info)
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
