/// A task that can be executed by the [TaskManager].
///
/// Tasks are managed by the [TaskManager] and can be executed at various points,
/// such as during server shutdown. Tasks can be executed in parallel or
/// sequentially based on their configuration.
class Task<T> {
  /// Creates a new task.
  ///
  /// The [id] is used for identification and logging purposes.
  /// The [callback] is the function that will be executed when the task is run.
  Task(this.id, this.callback);

  /// The identifier for this task.
  ///
  /// Used for identification and logging purposes, especially when errors
  /// occur.
  final Object id;

  /// The function to execute when the task is run.
  ///
  /// This callback can return a Future that completes when the task is done,
  /// or it can be null if no action is needed.
  final Future<T>? Function()? callback;
}
