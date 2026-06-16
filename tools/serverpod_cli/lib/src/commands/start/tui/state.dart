import 'package:serverpod_tui/serverpod_tui.dart';

import 'tab_model.dart';

/// Central state for the TUI, mutated by the backend and rendered by nocterm.
class ServerWatchState extends TuiState {
  /// Creates [ServerWatchState].
  ///
  /// When [hasConfiguredApps] is false the layout is a single full-width server
  /// pane with no apps area.
  ServerWatchState({this.hasConfiguredApps = true})
    : tabs = TabModel([
        TabArea(id: kMainArea, flex: 1),
        if (hasConfiguredApps) TabArea(id: kAppsArea, flex: 1),
      ]) {
    tabs.addTab(ServerLogTab());
  }

  /// Log history entries: [LogEntry] (from serverpod_shared) or
  /// [CompletedOperation].
  @override
  final logHistory = BoundedQueueList<Object>(maxLogEntries);

  /// Raw stdout/stderr lines shown in the raw server logs overlay
  /// (toggled with the backtick or `.` shortcut).
  @override
  final rawLines = BoundedQueueList<String>(maxRawLines);

  /// Currently active tracked operations (keyed by ID).
  @override
  final Map<String, TrackedOperation> activeOperations = {};

  /// Areas-based tab model for the multi-pane layout.
  final TabModel tabs;

  /// Whether this project declares at least one companion Flutter app.
  final bool hasConfiguredApps;

  /// Whether a Flutter app can be launched or restarted from here (the project
  /// has configured apps and we're in development mode).
  bool canLaunchApps = false;

  /// Latest measured content width from the main log area.
  double? contentWidth;

  /// Below this width the areas stack vertically instead of side by side.
  static const stackAreasMinWidth = 120.0;

  /// Whether the main log area should stack areas vertically.
  bool get stackAreasVertically =>
      hasConfiguredApps && (contentWidth ?? 0) < stackAreasMinWidth;

  /// The structured server log tab in the main area.
  ServerLogTab get serverLogTab =>
      tabs.areaOf(kMainArea).tabs.whereType<ServerLogTab>().first;

  /// Whether a tracked action (hot reload, migration) is in progress.
  bool actionBusy = false;

  /// Whether the server runs in watch mode (incremental compilation with
  /// automatic hot reload on file changes). Swaps the manual
  /// `Hot reload / restart` button for a plain `Hot restart`, since reloads
  /// are already handled by the incremental compiler.
  bool watchModeEnabled = false;

  /// Whether the server is running and ready for actions.
  bool serverReady = false;

  /// Whether to show the splash overlay. Starts true, set to false
  /// after 5 seconds or explicitly by the backend.
  bool showSplash = true;

  /// Whether the help overlay is visible.
  bool showHelp = false;

  /// Whether stack traces attached to log entries are shown inline.
  ///
  /// When false, an error entry that carries a trace shows a compact
  /// affordance instead; toggled with `e` on the structured log tab.
  bool expandStackTraces = false;

  /// Whether the raw server logs overlay (the "dev console") is visible.
  ///
  /// Raw server stdout/stderr is hidden from the default tabs and reached
  /// on demand via the backtick or `.` shortcut.
  bool showRawServerLogs = false;

  /// Maximum number of log entries to keep.
  static const maxLogEntries = 10000;

  /// Maximum number of raw lines to keep.
  static const maxRawLines = 10000;

  /// Returns the [AppLogTab] for [appId], or null if it is not open.
  AppLogTab? appLogTabFor(String appId) {
    if (!hasConfiguredApps) return null;
    for (final tab in tabs.areaOf(kAppsArea).tabs) {
      if (tab is AppLogTab && tab.appId == appId) return tab;
    }
    return null;
  }

  /// Returns an existing [AppLogTab] for [appId] or creates and adds one.
  AppLogTab getOrCreateAppLogTab({
    required String appId,
    required String label,
  }) {
    final existing = appLogTabFor(appId);
    if (existing != null) return existing;

    final tab = AppLogTab(appId: appId, label: label);
    tabs.addTab(tab);
    return tab;
  }

  /// Drops all server, raw server, and app log entries.
  ///
  /// In-progress [activeOperations] are kept so a running hot reload or
  /// migration still renders its pinned spinner after the buffers are cleared.
  void clearLogs() {
    logHistory.clear();
    rawLines.clear();
    if (!hasConfiguredApps) return;
    for (final tab in tabs.areaOf(kAppsArea).tabs) {
      if (tab is AppLogTab) {
        tab.lines.clear();
      }
    }
  }
}
