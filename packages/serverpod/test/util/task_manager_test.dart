import 'package:serverpod/protocol.dart';
import 'package:serverpod/src/generated/endpoints.dart';
import 'package:serverpod/src/server/serverpod.dart';
import 'package:serverpod/src/server/task.dart';
import 'package:serverpod/src/server/task_manager.dart';
import 'package:test/test.dart';

void main() {
  group('TaskManager', () {
    test(
        'Given a registered task, When handleTasks is called, Then the task is executed',
        () async {
      // Given
      final manager = TaskManager();
      var called = false;

      manager.addTask(Task<void>(
        'test-task',
        () async {
          called = true;
        },
      ));

      // When
      await manager.handleTasks(
        onTaskError: (_, __, ___) {},
      );

      // Then
      expect(called, isTrue);
    });

    test(
        'Given a task that throws, When handleTasks is called, Then other tasks still run',
        () async {
      // Given
      final manager = TaskManager();
      var executedTaskIds = <Object>[];

      manager.addTask(Task<void>('throws', () async {
        throw Exception('fail');
      }));

      manager.addTask(Task<void>('runs', () async {
        executedTaskIds.add('runs');
      }));

      // When
      await manager.handleTasks(
        onTaskError: (_, __, id) {
          executedTaskIds.add(id);
        },
      );

      // Then
      expect(executedTaskIds, containsAll(['throws', 'runs']));
    });

    test(
        'Given a removed task, When handleTasks is called, Then the task is not executed',
        () async {
      // Given
      final manager = TaskManager();
      var called = false;

      manager.addTask(Task<void>('task1', () async {
        called = true;
      }));
      manager.removeTask('task1');

      // When
      await manager.handleTasks(
        onTaskError: (_, __, ___) {},
      );

      // Then
      expect(called, isFalse);
    });
  });

  /// Integration Test
  test(
      'Given a shutdown task, When server shuts down, Then the task is executed',
      () async {
    // Given
    final pod = Serverpod([], Protocol(), Endpoints()); // configure as needed
    bool shutdownCalled = false;
    bool removedCalled = false;
    bool removed = false;
    bool removedAlready = true;
    Object? exception;

    pod.shutdownTasks.addTask(Task(
      #pass,
      () async {
        shutdownCalled = true;
      },
    ));

    pod.shutdownTasks.addTask(Task(#remove, () async {
      removedCalled = true;
    }));

    removed = pod.shutdownTasks.removeTask(#remove);

    removedAlready = pod.shutdownTasks.removeTask(#remove);

    pod.shutdownTasks.addTask(Task(#error, () async {
      throw Exception('Testing error');
    }));

    await pod.start();

    // When
    try {
      await pod.shutdown(exitProcess: false);
    } catch (e) {
      exception = e;
    }

    // Then
    expect(shutdownCalled, isTrue);
    expect(removedCalled, isFalse);
    expect(removedAlready, isFalse);
    expect(removed, isTrue);
    expect(exception, isA<Exception>());
    expect(exception.toString(), contains('Testing error'));
  });
}
