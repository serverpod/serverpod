import 'dart:async';

import 'package:meta/meta.dart';

import 'task.dart';

/// Manages tasks that need to be executed.
///
/// The `TaskManager` allows registering tasks that can be executed
/// concurrently. Each task is identified by a unique ID and contains
/// a callback function that will be executed when the task is run.
abstract interface class TaskManager {
  /// Adds a task to be executed.
  ///
  /// The task is stored in the task map with its ID as the key.
  /// The [task] contains an ID for identification and a callback function
  /// that will be executed when the task is run.
  void addTask(Task task);

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
  final Map<Object, Task> _tasks = {};

  @override
  void addTask(Task task) => _tasks[task.id] = task;

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

    for (final entry in _tasks.entries) {
      final Object id = entry.key;
      final Task task = entry.value;

      futures.add(
        Future(() async {
          try {
            await task.callback();
          } catch (e, stack) {
            onTaskError(e, stack, id);
          }
        }),
      );
    }

    await Future.wait(futures);
  }
}
