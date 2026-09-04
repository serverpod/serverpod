import 'package:serverpod_tui/serverpod_tui.dart';

import '../../../util/serverpod_cli_logger.dart';
import '../log_history.dart';
import 'app.dart';

int _actionCounter = 0;

/// Renders a session's [StartLogHistory] in the TUI.
///
/// Declared here rather than on [StartLogHistory] itself so the history stays
/// unaware of the TUI: the watch loop fills it whether or not one is running.
extension TuiLogHistory on StartLogHistory {
  /// Subscribes [holder] to this history, so the TUI repaints whenever the
  /// watch loop records something and surfaces the entries that need more than
  /// a repaint.
  void attachHolder(StartAppStateHolder holder) {
    onChanged = holder.markDirty;
    onServerEntry = (entry) {
      // An alert carries `metadata: {'alert': true}`. AlertMessage.parse
      // strips any `<...>` copy markup for display; the recorded log line
      // keeps the markup.
      if (entry.metadata?['alert'] == true) {
        holder.showAlert(AlertMessage.parse(entry.message), time: entry.time);
      }
    };
    // The entry's raw text is already in this history; only the structured
    // copy the app's tab renders is left to add.
    onFlutterEntry = holder.state.addFlutterLogEntry;
    onServerLine = holder.state.rawLines.add;
  }
}

/// Runs an async action as a tracked operation with spinner in the TUI.
///
/// Guards against concurrent actions - if [state.actionBusy] is true the action
/// is silently ignored. The action also requires [state.serverReady], unless
/// [allowWhenStartable] is set and the session is degraded but
/// [state.serverStartable] (used by the "Start server" recovery action, which
/// runs precisely when no server is up yet).
void runTrackedAction(
  StartAppStateHolder holder,
  String label,
  Future<void> Function() action, {
  bool allowWhenStartable = false,
}) {
  final state = holder.state;
  final ready =
      state.serverReady || (allowWhenStartable && state.serverStartable);
  if (state.actionBusy || !ready) return;

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
