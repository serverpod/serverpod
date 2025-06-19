import 'dart:async';

import 'package:meta/meta.dart';

/// Manages tasks that need to be executed.
///
/// The `TaskManager` allows registering tasks that can be executed
/// concurrently. Each task is identified by a unique ID and contains
/// a callback function that will be executed when the task is run.
abstract interface class TaskManager {
  /// Adds a task to be executed.
  ///
  /// The task is stored in the task map with its ID as the key and a callback
  /// function that will be executed when the task is run.
  ///
  /// Throws [StateError] if a task with the same ID already exists.
  void addTask(
    Object id,
    Future<void> Function() callback,
  );

  /// Removes a task with the specified ID from the task map.
  ///
  /// This method removes the task with the given [id] from the task map.
  /// Return [bool] if success in removing task.
  ///
  /// The [id] is the identifier of the task to remove.
  bool removeTask(Object id);
}

@internal
class TaskManagerImpl extends TaskManager {
  final Map<Object, _Task> _tasks = {};

  @override
  void addTask(
    Object id,
    Future<void> Function() callback,
  ) {
    if (_tasks.containsKey(id)) {
      throw StateError('Task with id $id already exists.');
    }
    _tasks[id] = _Task(id, callback);
  }

  @override
  bool removeTask(Object id) {
    return _tasks.remove(id) != null;
  }

  /// Executes all registered tasks concurrently.
  ///
  /// This method creates a Future for each task and executes them all
  /// concurrently using Future.wait. If a task throws an exception, the
  /// [onTaskError] callback is called with the error, stack trace, and task ID.
  ///
  /// The [onTaskError] callback is required and is called when a task throws
  /// an exception.
  Future<void> executeTasks({
    required void Function(Object error, StackTrace stack, Object id)
        onTaskError,
  }) async {
    final futures = <Future<void>>[];

    for (final entry in _tasks.entries.toList()) {
      final Object id = entry.key;
      final _Task task = entry.value;

      futures.add(task.callback().onError((Object e, s) {
        onTaskError(e, s, id);
      }));
    }

    await futures.wait;
  }
}

/// A task that can be executed by the [TaskManager].
///
/// Tasks are managed by the [TaskManager] and can be executed at various points,
/// such as during server shutdown.
class _Task {
  /// Creates a new task.
  ///
  /// The [id] is used for identification and logging purposes.
  /// The [callback] is the function that will be executed when the task is run.
  _Task(this.id, this.callback);

  /// The identifier for this task.
  ///
  /// Used for identification and logging purposes, especially when errors
  /// occur.
  final Object id;

  /// The function to execute when the task is run.
  ///
  /// This function should return a [Future] that completes when the task is done.
  final Future<void> Function() callback;
}
