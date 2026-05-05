import 'package:serverpod_cli/src/commands/tui/app_state_holder.dart';
import 'package:serverpod_cli/src/commands/tui/state.dart';
import 'package:serverpod_shared/log.dart';

/// A [LogWriter] that routes log entries and scopes to the TUI state.
///
/// Before the TUI is ready, log entries are buffered and flushed once
/// [attach] is called with the [ServerpodAppStateHolder].
///
/// Scopes map to tracked operations with spinners. Log entries appear
/// in the "Log Messages" tab.
class TuiLogWriter extends LogWriter {
  ServerpodAppStateHolder? _holder;
  final List<LogEntry> _buffer = [];

  /// Attach to the TUI state holder. Flushes any buffered messages.
  void attach(ServerpodAppStateHolder holder) {
    _holder = holder;
    if (_buffer.isNotEmpty) {
      holder.state.logHistory.addAll(_buffer);
      _buffer.clear();
      holder.markDirty();
    }
  }

  @override
  Future<void> log(LogEntry entry) async {
    final holder = _holder;
    if (holder != null) {
      holder.state.logHistory.add(entry);
      holder.markDirty();
    } else {
      _buffer.add(entry);
    }
  }

  @override
  Future<void> openScope(LogScope scope) async {
    final holder = _holder;
    if (holder != null) {
      holder.state.activeOperations[scope.id] = TrackedOperation(
        id: scope.id,
        label: scope.label,
      );
      holder.markDirty();
    } else {
      _buffer.add(
        LogEntry(
          level: LogLevel.info,
          time: scope.startTime,
          message: scope.label,
          scope: scope,
        ),
      );
    }
  }

  @override
  Future<void> closeScope(
    LogScope scope, {
    required bool success,
    required Duration duration,
    Object? error,
    StackTrace? stackTrace,
  }) async {
    final holder = _holder;
    if (holder == null) return;

    final op = holder.state.activeOperations.remove(scope.id);
    if (op != null) {
      op.stopwatch.stop();
      holder.state.logHistory.add(
        CompletedOperation(
          label: op.label,
          success: success,
          duration: duration,
        ),
      );
    }
    holder.markDirty();
  }
}
