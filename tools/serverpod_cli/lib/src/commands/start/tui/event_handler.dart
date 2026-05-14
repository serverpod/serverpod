import 'package:serverpod_cli/src/commands/tui/app_state_holder.dart';
import 'package:serverpod_cli/src/commands/tui/state.dart';
import 'package:serverpod_shared/log.dart' hide log;
import 'package:vm_service/vm_service.dart' show Event;

import '../../../util/serverpod_cli_logger.dart';
import 'app.dart';

int _actionCounter = 0;

/// Dispatches a structured server log event to the TUI state.
void handleServerLogEvent(ServerpodAppStateHolder holder, Event event) {
  if (event.extensionKind != 'ext.serverpod.log') return;
  final data = event.extensionData?.data;
  if (data == null) return;

  final state = holder.state;
  final type = data['type'] as String?;
  switch (type) {
    case 'log':
      state.logHistory.add(
        LogEntry(
          level: parseLogLevel(data['level'] as String? ?? 'info'),
          time:
              DateTime.tryParse(data['timestamp'] as String? ?? '') ??
              DateTime.now(),
          message: data['message'] as String? ?? '',
          scope: LogScope.root('server'),
          error: data['error']?.toString(),
        ),
      );

    case 'scope_start':
      final id = data['id'] as String? ?? '';
      final label = data['label'] as String? ?? '';
      // Don't track internal scopes as operations.
      if (label == 'INTERNAL') break;
      state.activeOperations[id] = TrackedOperation(
        id: id,
        label: label,
      );

    case 'scope_end':
      final id = data['id'] as String? ?? '';
      final op = state.activeOperations.remove(id);
      if (op != null) {
        op.stopwatch.stop();
        final serverDuration = (data['duration'] as num?)?.toDouble();
        state.logHistory.add(
          CompletedOperation(
            label: op.label,
            success: data['success'] as bool? ?? true,
            duration: serverDuration != null
                ? Duration(microseconds: (serverDuration * 1000000).round())
                : op.stopwatch.elapsed,
          ),
        );
      }
  }
  holder.markDirty();
}

/// Runs an async action as a tracked operation with spinner in the TUI.
///
/// Guards against concurrent actions - if [state.actionBusy] is true or
/// [state.serverReady] is false, the action is silently ignored.
void runTrackedAction(
  StartAppStateHolder holder,
  String label,
  Future<void> Function() action,
) {
  final state = holder.state;
  if (state.actionBusy || !state.serverReady) return;

  state.actionBusy = true;
  final id =
      '${label.hashCode}_${DateTime.now().millisecondsSinceEpoch}_${++_actionCounter}';
  state.activeOperations[id] = TrackedOperation(id: id, label: label);
  holder.markDirty();

  action()
      .then((_) {
        _completeTrackedAction(holder, id, success: true);
      })
      .catchError((Object e) {
        _completeTrackedAction(holder, id, success: false);
        log.error('$label failed: $e');
      });
}

void _completeTrackedAction(
  StartAppStateHolder holder,
  String id, {
  required bool success,
}) {
  final state = holder.state;
  state.actionBusy = false;
  final op = state.activeOperations.remove(id);
  if (op != null) {
    op.stopwatch.stop();
    state.logHistory.add(
      CompletedOperation(
        label: op.label,
        success: success,
        duration: op.stopwatch.elapsed,
      ),
    );
  }
  holder.markDirty();
}

LogLevel parseLogLevel(String level) {
  return switch (level) {
    'debug' => LogLevel.debug,
    'info' => LogLevel.info,
    'warning' || 'warn' => LogLevel.warning,
    'error' => LogLevel.error,
    'fatal' => LogLevel.fatal,
    _ => LogLevel.info,
  };
}
