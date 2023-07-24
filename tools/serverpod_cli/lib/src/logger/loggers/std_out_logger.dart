import 'dart:io';
import 'dart:math' as math;

import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/util/ansi_style.dart';
import 'package:serverpod_cli/src/logger/helpers/progress.dart';
import 'package:source_span/source_span.dart';
import 'package:super_string/super_string.dart';

/// Logger that logs using the [Stdout] library.
/// Errors and Warnings are printed on [stderr] and other messages are logged
/// on [stdout].
class StdOutLogger extends Logger {
  Progress? trackedAnimationInProgress;

  StdOutLogger(LogLevel logLevel) : super(logLevel);

  @override
  int? get wrapTextColumn => stdout.hasTerminal ? stdout.terminalColumns : null;

  @override
  void debug(
    String message, {
    bool newParagraph = false,
    LogStyle style = const TextLog(),
  }) {
    _log(
      message,
      LogLevel.debug,
      newParagraph,
      style,
      prefix: 'DEBUG: ',
    );
  }

  @override
  void info(
    String message, {
    bool newParagraph = false,
    LogStyle style = const TextLog(),
  }) {
    _log(message, LogLevel.info, newParagraph, style);
  }

  @override
  void warning(
    String message, {
    bool newParagraph = false,
    LogStyle style = const TextLog(),
  }) {
    _log(message, LogLevel.warning, newParagraph, style, prefix: 'WARNING: ');
  }

  @override
  void error(
    String message, {
    bool newParagraph = false,
    StackTrace? stackTrace,
    LogStyle style = const TextLog(),
  }) {
    _log(message, LogLevel.error, newParagraph, style, prefix: 'ERROR: ');

    if (stackTrace != null) {
      _log(stackTrace.toString(), LogLevel.error, newParagraph, style);
    }
  }

  @override
  Future<bool> progress(
    String message,
    Future<bool> Function() run, {
    bool newParagraph = false,
  }) async {
    if (logLevel.index > LogLevel.info.index) {
      return await run();
    }

    if (newParagraph) _write('\n', LogLevel.info);

    var progress = Progress(message, stdout);
    _stopAnimationInProgress();
    trackedAnimationInProgress = progress;
    bool success = await run();
    trackedAnimationInProgress = null;
    success ? progress.complete() : progress.fail();
    return success;
  }

  @override
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

    if (!shouldLog(logLevel)) return;

    var highlightAnsiCode =
        _SeveritySpanHelpers.highlightAnsiCode(logLevel, isHint);
    var message = sourceSpan.toString(color: highlightAnsiCode);

    if (newParagraph) {
      message = '\n$message';
    }

    _write(message, logLevel);
  }

  @override
  Future<void> flush() async {
    await stderr.flush();
    await stdout.flush();
  }

  bool shouldLog(LogLevel logLevel) {
    return logLevel.index >= this.logLevel.index;
  }

  void _log(
    String message,
    LogLevel logLevel,
    bool newParagraph,
    LogStyle style, {
    String prefix = '',
  }) {
    if (message == '') return;
    if (!shouldLog(logLevel)) return;

    if (style is BoxLog) {
      message = _formatAsBox(
        wrapColumn: wrapTextColumn ?? 100,
        message: message,
        title: style.title,
      );
    } else if (style is TextLog) {
      if (wrapTextColumn != null && style.wordWrap) {
        message = _wrapText(message, wrapTextColumn!);
      }

      switch (style.type) {
        case TextLogType.command:
          message = '   ${AnsiStyle.cyan.wrap('\$')} $message';
          break;
        case TextLogType.bullet:
          message = ' • $message';
          break;
        case TextLogType.normal:
          message = '$prefix$message';
          break;
        case TextLogType.init:
          message = AnsiStyle.cyan.wrap(AnsiStyle.bold.wrap(message));
          break;
        case TextLogType.header:
          message = AnsiStyle.bold.wrap(message);
          break;
        case TextLogType.success:
          message =
              '✅ ${AnsiStyle.lightGreen.wrap(AnsiStyle.bold.wrap(message))}\n';
          break;
        case TextLogType.hint:
          message = AnsiStyle.darkGray.wrap(AnsiStyle.italic.wrap(message));
          break;
      }
    }

    if (newParagraph) {
      message = '\n$message';
    }

    if (style is! RawLog) {
      // If it is not a raw log we append a new line after the message.
      message = '$message\n';
    }

    _write(message, logLevel);
  }

  void _write(String message, LogLevel logLevel) {
    _stopAnimationInProgress();
    if (logLevel.index >= LogLevel.warning.index) {
      stderr.write(message);
    } else {
      stdout.write(message);
    }
  }

  void _stopAnimationInProgress() {
    trackedAnimationInProgress?.stopAnimation();
    trackedAnimationInProgress = null;
  }
}

/// Windows version of the [StdOutLogger].
/// The operates in the same way but filters out emojis not compatible with
/// Windows.
class WindowsStdOutLogger extends StdOutLogger {
  WindowsStdOutLogger(LogLevel logLevel) : super(logLevel);

  @override
  void _write(
    String message,
    LogLevel logLevel,
  ) {
    message
        .replaceAll('🥳', '=D')
        .replaceAll('✅', '√')
        .replaceAll('🚀', '')
        .replaceAll('📦', '');
    super._write(message, logLevel);
  }
}

/// wrap text based on column width
String _wrapText(String text, int columnWidth) {
  var textLines = text.split('\n');
  List<String> outLines = [];
  for (var line in textLines) {
    outLines.add(line.wordWrap(width: columnWidth));
  }

  return outLines.join('\n');
}

/// Wraps the message in a box.
///
///  Example output:
///
///   ┌─ [title] ─┐
///   │ [message] │
///   └───────────┘
///
/// When [title] is provided, the box will have a title above it.
String _formatAsBox({
  required String message,
  String? title,
  required int wrapColumn,
}) {
  const int kPaddingLeftRight = 1;
  const int kEdges = 2;

  var maxTextWidthPerLine = wrapColumn - kEdges - kPaddingLeftRight * 2;
  var lines = _wrapText(message, maxTextWidthPerLine).split('\n');
  var lineWidth = lines.map((String line) => line.length).toList();
  var maxColumnSize =
      lineWidth.reduce((int currLen, int maxLen) => math.max(currLen, maxLen));
  var textWidth = math.min(maxColumnSize, maxTextWidthPerLine);
  var textWithPaddingWidth = textWidth + kPaddingLeftRight * 2;

  var buffer = StringBuffer();

  // Write `┌─ [title] ─┐`.
  buffer.write('┌');
  buffer.write('─');
  if (title == null) {
    buffer.write('─' * (textWithPaddingWidth - 1));
  } else {
    buffer.write(' $title ');
    buffer.write('─' * (textWithPaddingWidth - title.length - 3));
  }
  buffer.write('┐');
  buffer.write('\n');

  // Write `│ [message] │`.
  for (int lineIdx = 0; lineIdx < lines.length; lineIdx++) {
    buffer.write('│');
    buffer.write(' ' * kPaddingLeftRight);
    buffer.write(lines[lineIdx]);
    var remainingSpacesToEnd = textWidth - lineWidth[lineIdx];
    buffer.write(' ' * (remainingSpacesToEnd + kPaddingLeftRight));
    buffer.write('│');
    buffer.write('\n');
  }

  // Write `└───────────┘`.
  buffer.write('└');
  buffer.write('─' * textWithPaddingWidth);
  buffer.write('┘');

  return buffer.toString();
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
        assert(severity != LogLevel.nothing,
            'Log level nothing should never be used for a log message');
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
