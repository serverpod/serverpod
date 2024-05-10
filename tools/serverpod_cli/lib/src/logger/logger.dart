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

  /// Directly write a [message] to the output.
  /// Generally the other methods should be used instead of this. But this
  /// method can be used for more direct control of the output.
  ///
  /// If [newParagraph] is set to true, output is written as a new paragraph.
  /// [LogLevel] can be set to control the log level of the message.
  void write(
    String message,
    LogLevel logLevel, {
    bool newParagraph = false,
    bool newLine = true,
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
