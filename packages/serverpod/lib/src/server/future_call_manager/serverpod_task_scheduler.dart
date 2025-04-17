import 'dart:async';
import 'dart:collection';

/// A callback that returns a [Future],
/// used for scheduled tasks in [ServerpodTaskScheduler].
typedef TaskCallback = Future<void> Function();

/// A class responsible for scheduling and executing task callbacks.
class ServerpodTaskScheduler {
  final int? _concurrencyLimit;

  final _queue = Queue<TaskCallback>();

  var _runningTaskCallbacks = 0;

  Completer<void>? _stoppingCompleter;

  /// Creates a new [ServerpodTaskScheduler].
  ServerpodTaskScheduler({
    required int? concurrencyLimit,
  }) : _concurrencyLimit = concurrencyLimit;

  /// Makes sure any running task callbacks and queued task callbacks are processed.
  /// Once called, [isConcurrentLimitReached] will always return `true`.
  Future<void> stop() async {
    final stoppingCompleter = Completer<void>();

    _stoppingCompleter = stoppingCompleter;

    _handleQueue();

    return stoppingCompleter.future;
  }

  /// Returns `true` if the concurrent limit for task callbacks is reached.
  /// Returns `false` otherwise.
  bool isConcurrentLimitReached() {
    final concurrencyLimit = _concurrencyLimit;

    if (concurrencyLimit == null) {
      return false;
    }

    final isLimitReached = _runningTaskCallbacks >= concurrencyLimit;

    return isLimitReached;
  }

  /// Adds a list of [TaskCallback] to the queue.
  Future<void> addTaskCallbacks(
    List<TaskCallback> taskCallbacks,
  ) async {
    // If stop has been called, we cannot add any more task callbacks.
    if (_stoppingCompleter != null) {
      throw StateError('Cannot add task callbacks after stop has been called.');
    }

    _queue.addAll(taskCallbacks);

    _handleQueue();
  }

  /// Handles the queue of task callbacks.
  /// While the concurrency limit is not reached, the queue is processed.
  /// If the concurrency limit is reached, the queue is not processed further.
  void _handleQueue() {
    // Run as many task callbacks as possible.
    while (_queue.isNotEmpty && !isConcurrentLimitReached()) {
      final taskCallback = _queue.removeFirst();

      _runningTaskCallbacks++;

      unawaited(
        taskCallback().whenComplete(
          () {
            _runningTaskCallbacks--;

            _handleQueue();
          },
        ),
      );
    }

    // If the queue is empty and there are no running task callbacks,
    // complete the stopping completer.
    final stoppingCompleter = _stoppingCompleter;

    if (stoppingCompleter != null &&
        _queue.isEmpty &&
        _runningTaskCallbacks <= 0) {
      stoppingCompleter.complete();
    }
  }
}
