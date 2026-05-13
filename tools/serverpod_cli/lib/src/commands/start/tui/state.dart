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

  /// Currently active tracked operations (keyed by ID).
  @override
  final Map<String, TrackedOperation> activeOperations = {};

  /// Currently selected tab index (0 = Log Messages, 1 = Raw server output).
  int selectedTab = 0;

  /// Whether a tracked action (hot reload, migration) is in progress.
  bool actionBusy = false;

  /// Whether the server is running and ready for actions.
  bool serverReady = false;

  /// Whether to show the splash overlay. Starts true, set to false
  /// after 5 seconds or explicitly by the backend.
  bool showSplash = true;

  /// Maximum number of log entries to keep.
  static const maxLogEntries = 10000;

  /// Maximum number of raw lines to keep.
  static const maxRawLines = 10000;
}
