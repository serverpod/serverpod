import 'dart:async';
import 'dart:collection';

/// A callback function that performs an asynchronous task.
///
/// This is the type of function that can be scheduled and executed by
/// [ServerpodTaskScheduler].
typedef TaskCallback = Future<void> Function();

/// A task scheduler that manages the execution of asynchronous tasks with
/// optional concurrency limits.
///
/// The [ServerpodTaskScheduler] allows you to queue multiple asynchronous
/// tasks (defined as [TaskCallback]) and ensures they are executed in the
/// order they are added. If a concurrency limit is specified, it ensures
/// that no more than the specified number of tasks run concurrently.
class ServerpodTaskScheduler {
  /// The maximum number of tasks that can run concurrently.
  ///
  /// If `null`, there is no concurrency limit, and tasks will run as soon
  /// as they are added to the queue.
  final int? _concurrencyLimit;

  /// A queue that holds the tasks to be executed.
  ///
  /// Tasks are added to this queue and processed in the order they are added.
  final _queue = Queue<TaskCallback>();

  /// The number of tasks currently running.
  ///
  /// This is used to track the number of tasks being executed concurrently
  /// and enforce the concurrency limit.
  var _runningTaskCallbacks = 0;

  /// A completer that is used to signal when the scheduler has stopped
  /// processing tasks.
  ///
  /// This is set when the [stop] method is called and completed when all
  /// tasks in the queue have finished processing.
  Completer<void>? _stoppingCompleter;

  /// Creates a new instance of [ServerpodTaskScheduler].
  ///
  /// The [concurrencyLimit] parameter specifies the maximum number of tasks
  /// that can run concurrently. If `null`, there is no concurrency limit.
  ServerpodTaskScheduler({
    required int? concurrencyLimit,
  }) : _concurrencyLimit = concurrencyLimit;

  /// Stops the scheduler and ensures all queued and running tasks are
  /// completed before returning.
  ///
  /// The method returns a [Future] that completes when all tasks in the queue
  /// have finished processing.
  ///
  /// Once this method is called, no new tasks can be added to the scheduler
  /// until the returned [Future] completes.
  Future<void> stop() async {
    final stoppingCompleter = Completer<void>();

    _stoppingCompleter = stoppingCompleter;

    _handleQueue();

    return stoppingCompleter.future;
  }

  /// This method checks whether the number of currently running tasks has
  /// reached the specified concurrency limit.
  bool isConcurrentLimitReached() {
    final concurrencyLimit = _concurrencyLimit;

    if (concurrencyLimit == null) {
      return false;
    }

    final isLimitReached = _runningTaskCallbacks >= concurrencyLimit;

    return isLimitReached;
  }

  /// Adds a list of [TaskCallback] to the queue.
  ///
  /// The tasks will be executed in the order they are added, subject to the
  /// concurrency limit.
  ///
  /// If this method is called when the [stop] method has been called, this
  /// method will throw a [StateError].
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

    // If the stopping completer is not null, and there are no running tasks
    // and the queue is empty, complete the stopping completer.
    final stoppingCompleter = _stoppingCompleter;
    if (stoppingCompleter != null &&
        _queue.isEmpty &&
        _runningTaskCallbacks <= 0) {
      stoppingCompleter.complete();
    }
  }
}
