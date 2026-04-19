import 'package:cli_tools/cli_tools.dart';

import 'app.dart';
import 'state.dart';

/// A [Logger] implementation that routes messages to the TUI state.
///
/// Before the TUI is ready, messages are buffered and flushed once
/// [attach] is called with the state holder.
class TuiLogger extends Logger {
  TuiLogger() : super(LogLevel.debug);

  AppStateHolder? _holder;
  final List<TuiLogEntry> _buffer = [];
  int _progressCounter = 0;

  @override
  int? get wrapTextColumn => null;

  /// Attach to the TUI state holder. Flushes any buffered messages.
  void attach(AppStateHolder holder) {
    _holder = holder;
    if (_buffer.isNotEmpty) {
      holder.state.logHistory.addAll(_buffer);
      _buffer.clear();
      holder.markDirty();
    }
  }

  void _addLog(TuiLogLevel level, String message) {
    final entry = TuiLogEntry(
      level: level,
      timestamp: DateTime.now(),
      message: message,
    );

    final holder = _holder;
    if (holder != null) {
      final state = holder.state;
      state.logHistory.add(entry);
      holder.markDirty();
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
    final holder = _holder;

    if (holder != null) {
      holder.state.activeOperations[id] = TrackedOperation(
        id: id,
        label: message,
      );
      holder.markDirty();
    } else {
      _addLog(TuiLogLevel.info, message);
    }

    try {
      final success = await runner();
      _completeProgress(holder, id, success: success);
      return success;
    } catch (_) {
      _completeProgress(holder, id, success: false);
      rethrow;
    }
  }

  void _completeProgress(
    AppStateHolder? holder,
    String id, {
    required bool success,
  }) {
    if (holder == null) return;
    final op = holder.state.activeOperations.remove(id);
    if (op != null) {
      op.stopwatch.stop();
      holder.state.logHistory.add(
        CompletedOperation(
          label: op.label,
          success: success,
          duration: op.stopwatch.elapsed,
          entries: op.entries,
        ),
      );
    }
    holder.markDirty();
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
  Future<void> flush() async {}
}
