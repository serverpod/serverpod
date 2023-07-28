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
  static const int _defaultColumnWrap = 80;

  Progress? trackedAnimationInProgress;

  StdOutLogger(LogLevel logLevel) : super(logLevel);

  @override
  int? get wrapTextColumn => stdout.hasTerminal ? stdout.terminalColumns : null;

  @override
  void debug(
    String message, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) {
    _log(
      message,
      LogLevel.debug,
      newParagraph,
      type,
      prefix: AnsiStyle.darkGray.wrap('DEBUG: '),
    );
  }

  @override
  void info(
    String message, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) {
    _log(message, LogLevel.info, newParagraph, type);
  }

  @override
  void warning(
    String message, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) {
    _log(
      message,
      LogLevel.warning,
      newParagraph,
      type,
      prefix: AnsiStyle.yellow.wrap('WARNING: '),
    );
  }

  @override
  void error(
    String message, {
    bool newParagraph = false,
    StackTrace? stackTrace,
    LogType type = TextLogType.normal,
  }) {
    _log(
      message,
      LogLevel.error,
      newParagraph,
      type,
      prefix: AnsiStyle.red.wrap('ERROR: '),
    );

    if (stackTrace != null) {
      _log(stackTrace.toString(), LogLevel.error, newParagraph, type);
    }
  }

  @override
  Future<bool> progress(
    String message,
    Future<bool> Function() runner, {
    bool newParagraph = false,
  }) async {
    if (logLevel.index > LogLevel.info.index) {
      return await runner();
    }

    if (newParagraph) _write('\n', LogLevel.info);

    var progress = Progress(message, stdout);
    _stopAnimationInProgress();
    trackedAnimationInProgress = progress;
    bool success = await runner();
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
    LogType type, {
    String prefix = '',
  }) {
    if (message == '') return;
    if (!shouldLog(logLevel)) return;

    if (type is BoxLogType) {
      message = _formatAsBox(
        wrapColumn: wrapTextColumn ?? _defaultColumnWrap,
        message: message,
        title: type.title,
      );
    } else if (type is TextLogType) {
      switch (type.style) {
        case TextLogStyle.command:
          message = '   ${AnsiStyle.cyan.wrap('\$')} $message';
          break;
        case TextLogStyle.bullet:
          message = ' • $message';
          break;
        case TextLogStyle.normal:
          message = '$prefix$message';
          break;
        case TextLogStyle.init:
          message = AnsiStyle.cyan.wrap(AnsiStyle.bold.wrap(message));
          break;
        case TextLogStyle.header:
          message = AnsiStyle.bold.wrap(message);
          break;
        case TextLogStyle.success:
          message =
              '✅ ${AnsiStyle.lightGreen.wrap(AnsiStyle.bold.wrap(message))}\n';
          break;
        case TextLogStyle.hint:
          message = AnsiStyle.darkGray.wrap(AnsiStyle.italic.wrap(message));
          break;
      }

      message = _wrapText(message, wrapTextColumn ?? _defaultColumnWrap);
    }

    if (newParagraph) {
      message = '\n$message';
    }

    if (type is! RawLogType) {
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
    if (trackedAnimationInProgress != null) {
      trackedAnimationInProgress?.stopAnimation();
      // Since animation modifies the current line we add a new line so that
      // the next print doesn't end up on the same line.
      stdout.write('\n');
    }

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
    super._write(
        message
            .replaceAll('🥳', '=D')
            .replaceAll(
              '✅',
              AnsiStyle.bold.wrap(AnsiStyle.lightGreen.wrap('✓')),
            )
            .replaceAll('🚀', '')
            .replaceAll('📦', ''),
        logLevel);
  }
}

/// wrap text based on column width
String _wrapText(String text, int columnWidth) {
  var textLines = text.split('\n');
  List<String> outLines = [];
  for (var line in textLines) {
    var replaceFirstChar = _hasLeadingTrimCharacter(line);
    // wordWrap(...) uses trim as part of its implementation which removes all
    // leading trimmable characters.
    // In order to preserve them we temporarily replace the first char with a
    // non trimmable character.
    if (replaceFirstChar) {
      line = '@${line.substring(1)}';
    }

    var wrappedLine = line.wordWrap(width: columnWidth);

    if (replaceFirstChar) {
      wrappedLine = ' ${wrappedLine.substring(1)}';
    }
    outLines.add(wrappedLine);
  }

  return outLines.join('\n');
}

bool _hasLeadingTrimCharacter(String text) {
  if (text.isNotEmpty && text.first.trim().isEmpty) {
    return true;
  }

  return false;
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
