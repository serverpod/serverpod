import 'dart:io';
import 'dart:math' as math;

import 'package:colorize/colorize.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:super_string/super_string.dart';

/// Logger that logs using the [Stdout] library.
/// Errors and Warnings are printed on [stderr] and other messages are logged
/// on [stdout].
class StdOutLogger extends Logger {
  StdOutLogger(LogLevel logLevel) : super(logLevel);

  @override
  void debug(
    String message, {
    LogStyle style = const TextLogStyle(),
  }) {
    _log(
      message,
      LogLevel.debug,
      style,
      prefix: 'DEBUG: ',
    );
  }

  @override
  void info(
    String message, {
    LogStyle style = const TextLogStyle(),
  }) {
    _log(message, LogLevel.info, style);
  }

  @override
  void warning(
    String message, {
    LogStyle style = const TextLogStyle(),
  }) {
    _log(message, LogLevel.warning, style, prefix: 'WARNING: ');
  }

  @override
  void error(
    String message, {
    StackTrace? stackTrace,
    LogStyle style = const TextLogStyle(),
  }) {
    _log(message, LogLevel.error, style, prefix: 'ERROR: ');

    if (stackTrace != null) {
      _log(stackTrace.toString(), LogLevel.error, style);
    }
  }

  @override
  void sourceSpanSeverityException(
    SourceSpanSeverityException sourceSpan,
    LogLevel logLevel,
  ) {
    if (!shouldLog(logLevel)) return;

    _write(sourceSpan.toString(), logLevel);
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
    LogStyle style, {
    String prefix = '',
  }) {
    if (message == '') return;
    if (!shouldLog(logLevel)) return;

    if (style is BoxLogStyle) {
      message = _formatAsBox(
        message: message,
        title: style.title,
      );
    } else if (style is TextLogStyle) {
      if (style.wordWrap) {
        var wrapColumn = stdout.hasTerminal ? stdout.terminalColumns : 100;
        message = _wrapText(message, wrapColumn);
      }

      switch (style.type) {
        case AbstractStyleType.command:
          message = '  \$ $message';
          break;
        case AbstractStyleType.bullet:
          message = ' • $message';
          break;
        case AbstractStyleType.normal:
          message = '$prefix$message';
          break;
        case AbstractStyleType.success:
          break;
        case AbstractStyleType.hint:
          message = '${Colorize(message)..italic()}';
          break;
      }
    }

    if (style.newParagraph) {
      message = '\n$message';
    }

    _write(message, logLevel);
  }

  void _write(String message, LogLevel logLevel) {
    if (logLevel.index >= LogLevel.warning.index) {
      stderr.writeln(message);
    } else {
      stdout.writeln(message);
    }
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
    message.replaceAll('🥳', '=D');
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
}) {
  const int kPaddingLeftRight = 1;
  const int kEdges = 2;

  var wrapColumn = stdout.hasTerminal ? stdout.terminalColumns : 100;
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
