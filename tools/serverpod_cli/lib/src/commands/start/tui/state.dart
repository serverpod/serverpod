import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

import 'tab_model.dart';

/// Central state for the TUI, mutated by the backend and rendered by nocterm.
class ServerWatchState extends TuiState {
  /// Creates [ServerWatchState].
  ServerWatchState() : tabs = TabModel([TabArea(id: kMainArea, flex: 1)]) {
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
  bool get hasConfiguredApps => launchableApps.isNotEmpty;

  /// Whether a Flutter app can be launched or restarted from here (the project
  /// has configured apps and we're in development mode).
  bool canLaunchApps = false;

  /// All configured companion apps, used by the launch panel.
  List<FlutterAppConfig> launchableApps = const [];

  /// Whether the right-docked launch panel is visible.
  bool showLaunchPanel = false;

  /// Index of the focused row in the launch panel, driven by the cursor keys.
  int launchPanelIndex = 0;

  /// Returns whether [appId] is currently running (for the launch panel).
  bool Function(String appId)? isAppRunning;

  /// Returns whether [appId] is starting up (for the launch panel).
  bool Function(String appId)? isAppLaunching;

  /// Latest measured content width from the main log area.
  double? contentWidth;

  /// Minimum content width for showing the server and apps areas side by side.
  ///
  /// Below this the layout collapses to a single column with one merged tab
  /// strip (server + apps), rather than splitting a too-narrow terminal into
  /// unreadable panes.
  static const sideBySideMinWidth = 160.0;

  /// Whether the server and apps areas are shown side by side, each with its
  /// own tab strip.
  ///
  /// False when the project has no configured apps or the terminal is narrower
  /// than [sideBySideMinWidth], in which case a single column with one merged
  /// tab strip is rendered instead.
  bool get useSideBySideLayout =>
      hasConfiguredApps && (contentWidth ?? 0) >= sideBySideMinWidth;

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

  /// Whether the session is degraded: no server is running because the project
  /// failed to generate or compile, but it can be (re)built and started on
  /// demand. Enables the "Start server" action while [serverReady] is false.
  bool serverStartable = false;

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

  /// The [launchableApps] index of the currently selected app tab, or 0 when
  /// none is open. Used to start the launch panel cursor on the active app.
  int get activeLaunchableIndex {
    final tabArea = _appsTabArea;
    if (tabArea == null) return 0;
    final selected = tabArea.selected;
    if (selected is! AppLogTab) return 0;
    final index = launchableApps.indexWhere((a) => a.id == selected.appId);
    return index >= 0 ? index : 0;
  }

  /// Returns tab area for apps if it exists.
  TabArea? get _appsTabArea {
    try {
      return tabs.areaOf(kAppsArea);
    } catch (_) {}
    return null;
  }

  /// Returns the [AppLogTab] for [appId], or null if it is not open.
  AppLogTab? appLogTabFor(String appId) {
    for (final tab in _appsTabArea?.tabs ?? []) {
      if (tab is AppLogTab && tab.appId == appId) return tab;
    }
    return null;
  }

  void createAppsTabAreaIfNeeded() {
    if (_appsTabArea == null) {
      tabs.addArea(TabArea(id: kAppsArea, flex: 1));
    }
  }

  /// Returns an existing [AppLogTab] for [appId] or creates and adds one.
  AppLogTab getOrCreateAppLogTab({
    required String appId,
    required String label,
  }) {
    final existing = appLogTabFor(appId);
    if (existing != null) return existing;

    createAppsTabAreaIfNeeded();
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
    for (final tab in _appsTabArea?.tabs ?? []) {
      if (tab is AppLogTab) {
        tab.lines.clear();
      }
    }
  }
}
