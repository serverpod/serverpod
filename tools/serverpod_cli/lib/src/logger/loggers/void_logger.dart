import 'package:serverpod_cli/src/logger/logger.dart';

/// Logger that logs no output.
///
/// Intended to be used for testing to silence any printed output.
class VoidLogger extends Logger {
  VoidLogger() : super(LogLevel.debug);

  @override
  int? get wrapTextColumn => null;

  @override
  void debug(
    String message, {
    bool newParagraph = false,
    LogType type = const RawLogType(),
  }) {}

  @override
  void info(
    String message, {
    bool newParagraph = false,
    LogType type = const RawLogType(),
  }) {}

  @override
  void warning(
    String message, {
    bool newParagraph = false,
    LogType type = const RawLogType(),
  }) {}

  @override
  void error(
    String message, {
    bool newParagraph = false,
    StackTrace? stackTrace,
    LogType type = const RawLogType(),
  }) {}

  @override
  Future<void> flush() {
    return Future(() => {});
  }

  @override
  Future<bool> progress(
    String message,
    Future<bool> Function() runner, {
    bool newParagraph = true,
  }) async {
    return await runner();
  }

  @override
  void write(
    String message,
    LogLevel logLevel, {
    bool newParagraph = false,
    bool newLine = true,
  }) {}
}
