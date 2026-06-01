import 'package:serverpod_tui/serverpod_tui.dart';

/// Central state for the TUI, mutated by the backend and rendered by nocterm.
class ServerWatchState extends TuiState {
  ServerWatchState();

  /// Log history entries: [LogEntry] (from serverpod_shared) or
  /// [CompletedOperation].
  @override
  final logHistory = BoundedQueueList<Object>(maxLogEntries);

  /// Raw stdout/stderr lines shown in the raw server logs overlay
  /// (toggled with the backtick shortcut).
  @override
  final rawLines = BoundedQueueList<String>(maxRawLines);

  /// Raw lines for the "Flutter logs" tab.
  final rawFlutterLines = BoundedQueueList<String>(maxRawLines);

  /// Currently active tracked operations (keyed by ID).
  @override
  final Map<String, TrackedOperation> activeOperations = {};

  /// Currently selected tab index.
  ///
  /// - 0 = structured server logs
  /// - 1 = Flutter logs (only when [showFlutterOutput])
  int selectedTab = 0;

  /// Latest measured content width from the main log area.
  double? contentWidth;

  /// Minimum width for showing server and Flutter logs side by side.
  final sideBySideMinWidth = 160.0;

  /// Whether the main log area should use a side-by-side layout.
  bool get useSideBySideLayout =>
      showFlutterOutput && (contentWidth ?? 0) >= sideBySideMinWidth;

  /// Whether a tracked action (hot reload, migration) is in progress.
  bool actionBusy = false;

  /// Whether the server is running and ready for actions.
  bool serverReady = false;

  /// Flutter is running and a URL has been published.
  bool flutterReady = false;

  /// Whether the "Flutter output" tab is shown.
  bool showFlutterOutput = false;

  /// HTTP URL the Flutter app is served at.
  String? flutterUrl;

  /// Latest `app.progress` message from the Flutter daemon.
  String? flutterStartupStage;

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
  /// on demand via the backtick (`` ` ``) shortcut.
  bool showRawServerLogs = false;

  /// Maximum number of log entries to keep.
  static const maxLogEntries = 10000;

  /// Maximum number of raw lines to keep.
  static const maxRawLines = 10000;

  /// Drops all server, raw server, and Flutter log entries.
  ///
  /// In-progress [activeOperations] are kept so a running hot reload or
  /// migration still renders its pinned spinner after the buffers are cleared.
  void clearLogs() {
    logHistory.clear();
    rawLines.clear();
    rawFlutterLines.clear();
  }
}
