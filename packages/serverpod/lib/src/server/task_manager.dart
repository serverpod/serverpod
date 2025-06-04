import 'dart:async';

import 'package:serverpod/src/server/task.dart';

/// Manages tasks that need to be executed.
///
/// The `TaskManager` allows registering tasks that can be executed
/// concurrently. Each task is identified by a unique ID and contains
/// a callback function that will be executed when the task is run.
class TaskManager {
  final Map<String, Task> _tasks = {};

  /// Adds a task to be executed.
  ///
  /// The task is stored in the task map with its ID as the key.
  /// The [task] contains an ID for identification and a callback function
  /// that will be executed when the task is run.
  void addTask<T>(
    Task task,
  ) =>
      _tasks[task.id] = task;

  /// Removes a task with the specified ID from the task map.
  ///
  /// This method removes the task with the given [id] from the task map.
  /// Throws an [AssertionError] if no task with the specified ID exists.
  ///
  /// The [id] is the identifier of the task to remove.
  void removeTask(String id) {
    _tasks.remove(id);
    throw AssertionError('Task with id: $id, doesn\'t exist');
  }

  /// Executes all registered tasks concurrently.
  ///
  /// This method creates a Future for each task and executes them all
  /// concurrently using Future.wait. If a task throws an exception, the
  /// [onTaskError] callback is called with the error, stack trace, and task ID.
  ///
  /// The [onTaskError] callback is required and is called when a task throws
  /// an exception.
  Future<void> handleTasks({
    required void Function(Object error, StackTrace stack, String id)
        onTaskError,
  }) async {
    final futures = <Future<void>>[];

    for (final entry in _tasks.entries) {
      final String id = entry.key;
      final Task task = entry.value;

      if (task.callback != null) {
        futures.add(
          Future(() async {
            try {
              await task.callback!();
            } catch (e, stack) {
              onTaskError(e, stack, id);
            }
          }),
        );
      }
    }

    await Future.wait(futures);
  }
}
