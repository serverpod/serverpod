/// A task that is executed during server shutdown.
///
/// Shutdown tasks are managed by the [ShutdownTaskManager] and are executed
/// when the server is shutting down. Tasks can be executed in parallel or
/// sequentially, depending on the [sequentialTask] flag.
class ShutdownTask<T> {
  /// Creates a new shutdown task.
  ///
  /// The [id] is used for identification and logging purposes.
  /// The [callback] is the function that will be executed during shutdown.
  /// If [sequentialTask] is true, the task will be executed sequentially,
  /// otherwise it will be executed in parallel with other non-sequential tasks.
  ShutdownTask({
    required this.id,
    required this.callback,
    this.sequentialTask = false,
  });

  /// The identifier for this shutdown task.
  ///
  /// Used for identification and logging purposes, especially when errors
  /// occur.
  String id;

  /// The function to execute when the server is shutting down.
  ///
  /// This callback can return a Future that completes when the task is done,
  /// or it can be null if no action is needed.
  Future<T>? Function()? callback;

  /// Whether this task should be executed sequentially.
  ///
  /// If true, the task will be executed one after another with other sequential
  /// tasks. If false (default), the task will be executed in parallel with
  /// other non-sequential tasks for better performance during shutdown.
  bool sequentialTask;
}
