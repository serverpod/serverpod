import 'dart:async';

import 'package:serverpod/src/server/task.dart';

/// Manages tasks that need to be executed in a specific order.
///
/// The `TaskManager` allows registering tasks that should be executed
/// in a specific sequence. Tasks can be added to run before, during,
/// or after the main task execution process.
class TaskManager {
  /// Creates a new task manager.
  ///
  /// The [_exceptionHandler] is used to handle any exceptions that occur during
  /// the execution of tasks.
  TaskManager(this._exceptionHandler);

  /// Function to handle exceptions that occur during task execution.
  ///
  /// This handler is called with the exception, stack trace, and an optional
  /// message describing where the error occurred.
  final Function(
    Object e,
    StackTrace stackTrace, {
    String? message,
  }) _exceptionHandler;

  /// List of tasks to be executed before the main task group.
  final List<Task> _tasksPrior = [];

  /// List of main tasks.
  final List<Task> _tasks = [];

  /// List of tasks to be executed after the main task group.
  final List<Task> _tasksLater = [];

  /// Stores any error that occurs during the task execution process.
  ///
  /// This is returned by [handleTasks] to indicate if any errors occurred.
  Object? _error;

  /// Adds a task to be executed in the main task group.
  ///
  /// The [id] is used for identification and logging purposes.
  /// The [callback] is the function that will be executed when the task is run.
  void addTask<T>(
    String id,
    Future<T>? Function()? callback,
  ) =>
      _tasks.add(Task(
        id: id,
        callback: callback,
      ));

  /// Adds a task to be executed before the main task group.
  ///
  /// Tasks added with this method will be executed before any tasks added with
  /// [addTask]. This is useful for tasks that need to be completed before the
  /// main task execution begins.
  ///
  /// The [id] is used for identification and logging purposes.
  /// The [callback] is the function that will be executed when the task is run.
  void addTaskBefore<T>(
    String id,
    Future<T> Function()? callback,
  ) =>
      _tasksPrior.add(Task(
        id: id,
        callback: callback,
      ));

  /// Adds a task to be executed after the main task group.
  ///
  /// Tasks added with this method will be executed after all tasks added with
  /// [addTask]. This is useful for final operations that should happen
  /// after the main task execution is complete.
  ///
  /// The [id] is used for identification and logging purposes.
  /// The [callback] is the function that will be executed when the task is run.
  void addTaskAfter<T>(
    String id,
    Future<T> Function()? callback,
  ) =>
      _tasksLater.add(Task(
        id: id,
        callback: callback,
      ));

  /// Removes a task with the specified ID from all task groups.
  ///
  /// This method searches for a task with the given [id] in all task groups
  /// (_tasksPrior, _tasks, _tasksLater) and removes it if found.
  /// Throws an [AssertionError] if no task with the specified ID exists.
  ///
  /// The [id] is the identifier of the task to remove.
  void removeTask(String id) {
    if (_tasksPrior.map((tasks) => tasks.id).contains(id)) {
      _tasksPrior.removeWhere((task) => task.id == id);
    }

    if (_tasks.map((tasks) => tasks.id).contains(id)) {
      _tasks.removeWhere((task) => task.id == id);
    }

    if (_tasksLater.map((tasks) => tasks.id).contains(id)) {
      _tasksLater.removeWhere((task) => task.id == id);
    }

    throw AssertionError('Task with id: $id, doesn\'t exist');
  }

  /// Executes a list of tasks in parallel.
  ///
  /// This method takes a [List] of [Task] objects and executes them in parallel.
  /// It collects any errors that occur during execution and reports them through
  /// the exception handler provided to the [TaskManager].
  ///
  /// The method creates a [Future] for each task and waits for all of them to
  /// complete using [Future.wait]. If any errors occur, they are captured and
  /// stored in the [_error] field as a [ParallelWaitError].
  ///
  /// [tasks] is the list of tasks to execute.
  Future<void> _tasksExecutor(List<Task> tasks) async {
    final futures = <Future<void>>[];
    final List<dynamic> errors = [];
    final List<dynamic> values = [];

    // Loop to insure futures get logged with ids
    for (final task in tasks) {
      if (task.callback == null) continue;

      futures.add(Future(() async {
        try {
          await task.callback!();
        } catch (e, stackTrace) {
          errors.add(e);
          values.add(task.id);
          _exceptionHandler(
            e,
            stackTrace,
            message: 'Error in task "${task.id}" execution',
          );
        }
      }));

      if (errors.isNotEmpty && values.isNotEmpty) {
        _error = ParallelWaitError(values, errors);
      }
    }

    await Future.wait(futures);
  }

  /// Executes all registered tasks in the proper order.
  ///
  /// This method is the main entry point for task execution. It executes
  /// all registered tasks in the following order:
  /// 1. Tasks added with [addTaskBefore]
  /// 2. Tasks added with [addTask]
  /// 3. Tasks added with [addTaskAfter]
  ///
  /// Tasks within each group are executed in parallel for better performance.
  ///
  /// Returns any error that occurred during the task execution process, or null if
  /// all tasks completed successfully.
  Future<Object?> handleTasks() async {
    await _tasksExecutor(_tasksPrior);

    await _tasksExecutor(_tasks);

    await _tasksExecutor(_tasksLater);

    return _error;
  }
}
