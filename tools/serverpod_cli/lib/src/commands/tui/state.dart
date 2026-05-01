import 'package:serverpod_cli/src/commands/tui/bounded_queue_list.dart';

/// A tracked operation (server session or CLI progress).
///
/// While active, rendered as a pinned entry with spinner at the bottom of the
/// log area. On completion, collapses into a divider-style summary line.
final class TrackedOperation {
  TrackedOperation({
    required this.id,
    required this.label,
  }) {
    stopwatch.start();
  }

  final String id;
  final String label;
  final Stopwatch stopwatch = Stopwatch();

  /// Null while active, set on completion.
  bool? success;

  /// Duration in seconds, set on completion.
  double? duration;
}

/// Completed tracked operation, stored in the log history.
final class CompletedOperation {
  CompletedOperation({
    required this.label,
    required this.success,
    required this.duration,
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();

  final String label;
  final bool success;
  final Duration duration;
  final DateTime completedAt;
}

/// Central state for the TUI, mutated by the backend and rendered by nocterm.
abstract class ServerpodState {
  /// Log history entries: [LogEntry] (from serverpod_shared) or
  /// [CompletedOperation].
  BoundedQueueList<Object> get logHistory;

  /// Raw stdout/stderr lines for the "Raw server output" tab.
  BoundedQueueList<String> get rawLines => BoundedQueueList(0);

  /// Currently active tracked operations (keyed by ID).
  Map<String, TrackedOperation> get activeOperations;

  /// Whether the help overlay is visible.
  bool showHelp = false;
}
