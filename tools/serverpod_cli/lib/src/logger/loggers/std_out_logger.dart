import 'dart:io';
import 'dart:math' as math;

import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/util/ansi_style.dart';
import 'package:serverpod_cli/src/logger/helpers/progress.dart';
import 'package:super_string/super_string.dart';

/// Logger that logs using the [Stdout] library.
/// Errors and Warnings are printed on [stderr] and other messages are logged
/// on [stdout].
class StdOutLogger extends Logger {
  static const int _defaultColumnWrap = 80;

  Progress? trackedAnimationInProgress;

  final Map<String, String>? _replacements;

  StdOutLogger(super.logLevel, {Map<String, String>? replacements})
      : _replacements = replacements;

  @override
  int? get wrapTextColumn => stdout.hasTerminal ? stdout.terminalColumns : null;

  @override
  void debug(
    String message, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) {
    if (ansiSupported) {
      _log(
        AnsiStyle.darkGray.wrap(message),
        LogLevel.debug,
        newParagraph,
        type,
      );
    } else {
      _log(
        message,
        LogLevel.debug,
        newParagraph,
        type,
        prefix: 'DEBUG: ',
      );
    }
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
    if (ansiSupported) {
      _log(
        AnsiStyle.yellow.wrap(message),
        LogLevel.warning,
        newParagraph,
        type,
      );
    } else {
      _log(
        message,
        LogLevel.warning,
        newParagraph,
        type,
        prefix: 'WARNING: ',
      );
    }
  }

  @override
  void error(
    String message, {
    bool newParagraph = false,
    StackTrace? stackTrace,
    LogType type = TextLogType.normal,
  }) {
    if (ansiSupported) {
      _log(
        AnsiStyle.red.wrap(message),
        LogLevel.error,
        newParagraph,
        type,
      );
    } else {
      _log(
        message,
        LogLevel.error,
        newParagraph,
        type,
        prefix: 'ERROR: ',
      );
    }

    if (stackTrace != null) {
      _log(
        AnsiStyle.red.wrap(stackTrace.toString()),
        LogLevel.error,
        newParagraph,
        type,
      );
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

    _stopAnimationInProgress();

    // Write an empty line before the progress message if a new paragraph is
    // requested.
    if (newParagraph) {
      write(
        '',
        LogLevel.info,
        newParagraph: false,
        newLine: true,
      );
    }

    var progress = Progress(message, stdout);
    trackedAnimationInProgress = progress;
    bool success = await runner();
    trackedAnimationInProgress = null;
    success ? progress.complete() : progress.fail();
    return success;
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

    write(
      message,
      logLevel,
      newParagraph: newParagraph,
      newLine: type is! RawLogType,
    );
  }

  @override
  void write(
    String message,
    LogLevel logLevel, {
    newParagraph = false,
    newLine = true,
  }) {
    message = switch (_replacements) {
      null => message,
      Map<String, String> replacements => replacements.entries.fold(
          message,
          (String acc, entry) => acc.replaceAll(entry.key, entry.value),
        ),
    };

    _stopAnimationInProgress();
    if (logLevel.index >= LogLevel.warning.index) {
      stderr.write('${newParagraph ? '\n' : ''}$message${newLine ? '\n' : ''}');
    } else {
      stdout.write('${newParagraph ? '\n' : ''}$message${newLine ? '\n' : ''}');
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

/// wrap text based on column width
String _wrapText(String text, int columnWidth) {
  var textLines = text.split('\n');
  List<String> outLines = [];
  for (var line in textLines) {
    var leadingTrimChar = _tryGetLeadingTrimmableChar(line);
    // wordWrap(...) uses trim as part of its implementation which removes all
    // leading trimmable characters.
    // In order to preserve them we temporarily replace the first char with a
    // non trimmable character.
    if (leadingTrimChar != null) {
      line = '@${line.substring(1)}';
    }

    var wrappedLine = line.wordWrap(width: columnWidth);

    if (leadingTrimChar != null) {
      wrappedLine = '$leadingTrimChar${wrappedLine.substring(1)}';
    }
    outLines.add(wrappedLine);
  }

  return outLines.join('\n');
}

String? _tryGetLeadingTrimmableChar(String text) {
  if (text.isNotEmpty && text.first.trim().isEmpty) {
    return text.first;
  }

  return null;
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
