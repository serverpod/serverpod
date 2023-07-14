import 'package:serverpod_cli/src/logger/loggers/std_out_logger.dart';

/// Serverpods internal logger interface.
/// All logging output should go through this interface.
/// The purpose is to simplify implementing and switching out concrete logger
/// implementations.
abstract class Logger {
  /// Sets the log level for the logger
  void setLogLevel(LogLevel level);

  /// Display debug [message] to the user.
  /// Commands should use this for information that is important for
  /// debugging purposes.
  void debug(
    String message, {
    RawPrint style,
  });

  /// Display a normal [message] to the user.
  /// Command should use this as the standard communication channel for
  /// success, progress or information messages.
  void info(
    String message, {
    RawPrint style,
  });

  /// Display a warning [message] to the user.
  /// Commands should use this if they have important but not critical
  /// information for the user.
  void warning(
    String message, {
    RawPrint style,
  });

  /// Display an error [message] to the user.
  /// Commands should use this if they want to inform a user that an error
  /// has occurred.
  void error(
    String message, {
    StackTrace? stackTrace,
    RawPrint style,
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

enum PrettyPrintType {
  normal,
  hint,
  success,
  list,
  command,
}

class RawPrint {
  final bool newParagraph;

  const RawPrint({
    this.newParagraph = false,
  });
}

class BoxPrint extends RawPrint {
  final String? title;
  const BoxPrint({
    this.title,
    bool newParagraph = true,
  }) : super(newParagraph: newParagraph);
}

class PrettyPrint extends RawPrint {
  final bool wordWrap;
  final PrettyPrintType type;

  const PrettyPrint({
    this.type = PrettyPrintType.normal,
    this.wordWrap = true,
    bool newParagraph = false,
  }) : super(newParagraph: newParagraph);
}

/// Singleton instance of logger.
Logger? _logger;

/// Initializer for logger singleton.
/// This should only be called once from runtime entry points.
void initializeLogger(Logger logger) {
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
  _logger ??= StdOutLogger();
  return _logger!;
}
