import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:source_span/source_span.dart';

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
    LogType type = const RawLog(),
  }) {}

  @override
  void info(
    String message, {
    bool newParagraph = false,
    LogType type = const RawLog(),
  }) {}

  @override
  void warning(
    String message, {
    bool newParagraph = false,
    LogType type = const RawLog(),
  }) {}

  @override
  void error(
    String message, {
    bool newParagraph = false,
    StackTrace? stackTrace,
    LogType type = const RawLog(),
  }) {}

  @override
  void sourceSpanException(SourceSpanException sourceSpan,
      {bool newParagraph = false}) {}

  @override
  Future<void> flush() {
    return Future(() => {});
  }

  @override
  Future<bool> progress(
    String message,
    Future<bool> Function() run, {
    bool newParagraph = true,
  }) async {
    return await run();
  }
}
