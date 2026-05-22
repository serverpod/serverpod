import 'package:serverpod_cli/src/commands/tui/bounded_queue_list.dart';
import 'package:serverpod_cli/src/commands/tui/state.dart';

/// Central state for the TUI, mutated by the backend and rendered by nocterm.
class ServerWatchState extends ServerpodState {
  ServerWatchState();

  /// Log history entries: [LogEntry] (from serverpod_shared) or
  /// [CompletedOperation].
  @override
  final logHistory = BoundedQueueList<Object>(maxLogEntries);

  /// Raw stdout/stderr lines for the "Raw server output" tab.
  @override
  final rawLines = BoundedQueueList<String>(maxRawLines);

  /// Raw lines for the "Flutter output" tab.
  final rawFlutterLines = BoundedQueueList<String>(maxRawLines);

  /// Currently active tracked operations (keyed by ID).
  @override
  final Map<String, TrackedOperation> activeOperations = {};

  /// Currently selected tab index.
  ///
  /// - 0 = structured server logs
  /// - 1 = Flutter logs (narrow layout only)
  /// - 2 = raw server logs
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

  /// Maximum number of log entries to keep.
  static const maxLogEntries = 10000;

  /// Maximum number of raw lines to keep.
  static const maxRawLines = 10000;
}
