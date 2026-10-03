import 'dart:async';

import 'package:serverpod_tui/serverpod_tui.dart';

import '../log_history.dart';
import 'app.dart';

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
  }
}

/// Runs [action] once the stack can take it, holding [state.actionBusy] until
/// it ends so keys do not queue commands.
///
/// The runner records the operation and any failure for every attached
/// client, so the UI keeps nothing but the busy flag. The action requires
/// [state.serverReady], unless [allowWhenStartable] is set and the session is
/// degraded but [state.serverStartable] (the "Start server" recovery action,
/// which runs precisely when no server is up yet).
void runTrackedAction(
  StartAppStateHolder holder,
  Future<void> Function() action, {
  bool allowWhenStartable = false,
}) {
  final state = holder.state;
  final ready =
      state.serverReady || (allowWhenStartable && state.serverStartable);
  if (state.actionBusy || !ready) return;

  state.actionBusy = true;
  holder.markDirty();

  unawaited(
    action().catchError((_) {}).whenComplete(() {
      state.actionBusy = false;
      holder.markDirty();
    }),
  );
}
