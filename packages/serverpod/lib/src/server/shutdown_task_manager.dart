import 'dart:async';

import 'package:collection/collection.dart';
import 'package:serverpod/src/server/shutdown_task.dart';

/// Manages tasks that need to be executed during server shutdown.
///
/// The `ShutdownTaskManager` allows registering tasks that should be executed
/// when the server is shutting down. Tasks can be added to run before, during,
/// or after the default shutdown process. Tasks can be executed in parallel or
/// sequentially based on their configuration.
class ShutdownTaskManager {
  /// Creates a new shutdown task manager.
  ///
  /// The [_exceptionHandler] is used to handle any exceptions that occur during
  /// the execution of shutdown tasks.
  ShutdownTaskManager(this._exceptionHandler);

  /// Function to handle exceptions that occur during shutdown task execution.
  ///
  /// This handler is called with the exception, stack trace, and an optional
  /// message describing where the error occurred.
  final Function(
    Object e,
    StackTrace stackTrace, {
    String? message,
  }) _exceptionHandler;

  /// List of tasks to be executed before the default shutdown tasks.
  final List<ShutdownTask> _tasksPrior = [];

  /// List of default shutdown tasks.
  final List<ShutdownTask> _tasks = [];

  /// List of tasks to be executed after the default shutdown tasks.
  final List<ShutdownTask> _tasksLater = [];

  /// Stores any error that occurs during the shutdown process.
  ///
  /// This is returned by [handleShutdown] to indicate if any errors occurred.
  Object? _shutdownError;

  /// Adds a task to be executed during the default shutdown phase.
  ///
  /// The [id] is used for identification and logging purposes.
  /// The [callback] is the function that will be executed during shutdown.
  /// If [sequential] is true, the task will be executed sequentially,
  /// otherwise it will be executed in parallel with other non-sequential tasks.
  void addTask<T>(
    String id,
    Future<T>? Function()? callback, {
    bool sequential = false,
  }) =>
      _tasks.add(ShutdownTask(
        id: id,
        callback: callback,
        sequentialTask: sequential,
      ));

  /// Adds a task to be executed before the default shutdown phase.
  ///
  /// Tasks added with this method will be executed before any tasks added with
  /// [addTask]. This is useful for tasks that need to be completed before the
  /// default shutdown process begins.
  ///
  /// The [id] is used for identification and logging purposes.
  /// The [callback] is the function that will be executed during shutdown.
  /// If [sequential] is true, the task will be executed sequentially,
  /// otherwise it will be executed in parallel with other non-sequential tasks.
  void addTaskBefore<T>(
    String id,
    Future<T> Function()? callback, {
    bool sequential = false,
  }) =>
      _tasksPrior.add(ShutdownTask(
        id: id,
        callback: callback,
        sequentialTask: sequential,
      ));

  /// Adds a task to be executed after the default shutdown phase.
  ///
  /// Tasks added with this method will be executed after all tasks added with
  /// [addTask]. This is useful for final cleanup operations that should happen
  /// after the default shutdown process is complete.
  ///
  /// The [id] is used for identification and logging purposes.
  /// The [callback] is the function that will be executed during shutdown.
  /// If [sequential] is true, the task will be executed sequentially,
  /// otherwise it will be executed in parallel with other non-sequential tasks.
  void addTaskAfter<T>(
    String id,
    Future<T> Function()? callback, {
    bool sequential = false,
  }) =>
      _tasksLater.add(ShutdownTask(
        id: id,
        callback: callback,
        sequentialTask: sequential,
      ));

  /// Executes a list of shutdown tasks.
  ///
  /// This method separates tasks into sequential and asynchronous groups based on
  /// their [ShutdownTask.sequentialTask] flag. Asynchronous tasks are executed in
  /// parallel for better performance, while sequential tasks are executed one
  /// after another.
  ///
  /// Any errors that occur during task execution are caught and passed to the
  /// [_exceptionHandler], and the error is stored in [_shutdownError].
  Future<void> _tasksExecutor(List<ShutdownTask> tasks) async {
    final sequentialTasks = tasks.where((task) => task.sequentialTask);
    final asyncTasks = tasks.whereNot((tasks) => tasks.sequentialTask);

    // Execute non-sequential tasks in parallel
    await asyncTasks
        .map((task) => task.callback != null ? task.callback!() : null)
        .nonNulls
        .wait
        .onError((ParallelWaitError e, stackTrace) {
      _shutdownError = e;
      var errors = e.errors;
      if (errors is Iterable<AsyncError?>) {
        for (var error in errors.nonNulls) {
          _exceptionHandler(
            error.error,
            error.stackTrace,
            message: 'Error in server shutdown',
          );
        }
      } else {
        _exceptionHandler(
          errors,
          stackTrace,
          message: 'Error in serverpod shutdown',
        );
      }
      return e.values;
    });

    // Execute sequential tasks one after another
    for (ShutdownTask task in sequentialTasks) {
      try {
        if (task.callback != null) {
          await task.callback!();
        }
      } catch (e, stackTrace) {
        _shutdownError = e;
        _exceptionHandler(
          e,
          stackTrace,
          message: 'Error in ${task.id} shutdown',
        );
      }
    }
  }

  /// Executes all registered shutdown tasks in the proper order.
  ///
  /// This method is the main entry point for the shutdown process. It executes
  /// all registered tasks in the following order:
  /// 1. Tasks added with [addTaskBefore]
  /// 2. Tasks added with [addTask]
  /// 3. Tasks added with [addTaskAfter]
  ///
  /// Within each group, tasks are executed according to their
  /// [ShutdownTask.sequentialTask] flag, with non-sequential tasks running in
  /// parallel and sequential tasks running one after another.
  ///
  /// Returns any error that occurred during the shutdown process, or null if
  /// the shutdown completed successfully.
  Future<Object?> handleShutdown() async {
    await _tasksExecutor(_tasksPrior);

    await _tasksExecutor(_tasks);

    await _tasksExecutor(_tasksLater);

    return _shutdownError;
  }
}
