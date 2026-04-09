import 'package:vm_service/vm_service.dart' show Event;

import '../../../util/serverpod_cli_logger.dart';
import 'app.dart';
import 'state.dart';

/// Dispatches a structured server log event to the TUI state.
void handleServerLogEvent(AppStateHolder holder, Event event) {
  if (event.extensionKind != 'ext.serverpod.log') return;
  final data = event.extensionData?.data;
  if (data == null) return;

  final state = holder.state;
  final type = data['type'] as String?;
  switch (type) {
    case 'log':
      state.logHistory.add(
        TuiLogEntry(
          level: parseTuiLogLevel(data['level'] as String? ?? 'info'),
          timestamp:
              DateTime.tryParse(data['timestamp'] as String? ?? '') ??
              DateTime.now(),
          message: data['message'] as String? ?? '',
        ),
      );

    case 'session_start':
      final id = data['id'] as String? ?? '';
      final label = data['label'] as String? ?? '';
      // Don't track internal sessions as operations.
      if (label == 'INTERNAL') break;
      state.activeOperations[id] = TrackedOperation(
        id: id,
        label: label,
      );

    case 'session_log':
      state.activeOperations[data['sessionId'] as String? ?? '']?.entries.add(
        OperationSubEntry(
          timestamp: DateTime.now(),
          message: data['message'] as String? ?? '',
          level: parseTuiLogLevel(data['level'] as String? ?? 'info'),
        ),
      );

    case 'session_query':
      state.activeOperations[data['sessionId'] as String? ?? '']?.entries.add(
        OperationSubEntry(
          timestamp: DateTime.now(),
          message: data['query'] as String? ?? '',
          duration: (data['duration'] as num?)?.toDouble(),
        ),
      );

    case 'session_end':
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
            entries: op.entries,
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
  AppStateHolder holder,
  String label,
  Future<void> Function() action,
) {
  final state = holder.state;
  if (state.actionBusy || !state.serverReady) return;

  state.actionBusy = true;
  final id = '${label.hashCode}_${DateTime.now().millisecondsSinceEpoch}';
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
  AppStateHolder holder,
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
        entries: op.entries,
      ),
    );
  }
  holder.markDirty();
}

TuiLogLevel parseTuiLogLevel(String level) {
  return switch (level) {
    'debug' => TuiLogLevel.debug,
    'info' => TuiLogLevel.info,
    'warning' || 'warn' => TuiLogLevel.warning,
    'error' => TuiLogLevel.error,
    'fatal' => TuiLogLevel.fatal,
    _ => TuiLogLevel.info,
  };
}
