import 'dart:async';

import 'package:cli_tools/cli_tools.dart';

import 'app.dart';
import 'state.dart';

/// A [Logger] implementation that routes messages to the TUI state.
///
/// Before the TUI is ready, messages are buffered and flushed once
/// [attach] is called with the app state handle.
class TuiLogger extends Logger {
  TuiLogger() : super(LogLevel.debug);

  ServerpodWatchAppState? _appState;
  final List<_BufferedEntry> _buffer = [];
  int _progressCounter = 0;

  @override
  int? get wrapTextColumn => null;

  /// Attach to the TUI state. Flushes any buffered messages.
  void attach(ServerpodWatchAppState appState) {
    _appState = appState;
    for (final entry in _buffer) {
      appState.addStructuredLog(
        level: entry.level,
        timestamp: entry.timestamp,
        message: entry.message,
      );
    }
    _buffer.clear();
  }

  void _addLog(TuiLogLevel level, String message) {
    final entry = _BufferedEntry(
      level: level,
      timestamp: DateTime.now(),
      message: message,
    );

    final appState = _appState;
    if (appState != null) {
      appState.addStructuredLog(
        level: entry.level,
        timestamp: entry.timestamp,
        message: entry.message,
      );
    } else {
      _buffer.add(entry);
    }
  }

  @override
  void debug(
    String message, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) {
    _addLog(TuiLogLevel.debug, message);
  }

  @override
  void info(
    String message, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) {
    _addLog(TuiLogLevel.info, message);
  }

  @override
  void warning(
    String message, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) {
    _addLog(TuiLogLevel.warning, message);
  }

  @override
  void error(
    String message, {
    bool newParagraph = false,
    StackTrace? stackTrace,
    LogType type = TextLogType.normal,
  }) {
    final msg = stackTrace != null
        ? '$message\n${stackTrace.toString()}'
        : message;
    _addLog(TuiLogLevel.error, msg);
  }

  @override
  void log(
    String message,
    LogLevel level, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) {
    final tuiLevel = switch (level) {
      LogLevel.debug => TuiLogLevel.debug,
      LogLevel.info => TuiLogLevel.info,
      LogLevel.warning => TuiLogLevel.warning,
      LogLevel.error => TuiLogLevel.error,
      LogLevel.nothing => TuiLogLevel.debug,
    };
    _addLog(tuiLevel, message);
  }

  @override
  Future<bool> progress(
    String message,
    Future<bool> Function() runner, {
    bool newParagraph = false,
  }) async {
    final id = 'cli_progress_${_progressCounter++}';
    final appState = _appState;

    if (appState != null) {
      appState.startTrackedOperation(id: id, label: message);
    } else {
      _addLog(TuiLogLevel.info, message);
    }

    final success = await runner();

    if (appState != null) {
      appState.endTrackedOperation(id: id, success: success);
    }

    return success;
  }

  @override
  void write(
    String message,
    LogLevel logLevel, {
    bool newParagraph = false,
    bool newLine = true,
  }) {
    log(message, logLevel, newParagraph: newParagraph);
  }

  @override
  Future<void> flush() async {
    // No-op - TUI renders synchronously on setState.
  }
}

class _BufferedEntry {
  _BufferedEntry({
    required this.level,
    required this.timestamp,
    required this.message,
  });

  final TuiLogLevel level;
  final DateTime timestamp;
  final String message;
}
