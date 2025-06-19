import 'dart:async';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a registered shutdown task '
      'when the server is shutdown '
      'then the task is executed.', () async {
    var called = false;

    var serverpod = IntegrationTestServer.create();
    serverpod.experimental.shutdownTasks.addTask(
      Task(
        #testTask,
        () async {
          called = true;
        },
      ),
    );

    await serverpod.shutdown(exitProcess: false);

    expect(called, isTrue);
  });

  test(
      'Given added and then removed shutdown task '
      'when the server is shutdown '
      'then the task is not executed.', () async {
    var called = false;

    var task = Task(
      #testTask,
      () async {
        called = true;
      },
    );

    var serverpod = IntegrationTestServer.create();
    serverpod.experimental.shutdownTasks.addTask(task);
    serverpod.experimental.shutdownTasks.removeTask(task.id);

    await serverpod.shutdown(exitProcess: false);

    expect(called, isFalse);
  });

  test(
      'Given shutdown task that records number of calls '
      'when the server is shutdown multiple times '
      'then the task once for each shutdown.', () async {
    var callCount = 0;

    var serverpod = IntegrationTestServer.create();
    serverpod.experimental.shutdownTasks.addTask(
      Task(
        #testTask,
        () async {
          callCount++;
        },
      ),
    );

    await serverpod.shutdown(exitProcess: false);
    await serverpod.shutdown(exitProcess: false);

    expect(callCount, equals(2));
  });

  test(
      'Given a shutdown task that throws an error '
      'when the server is shutdown '
      'then the error is thrown from shutdown.', () async {
    var task = Task(
      #testTask,
      () async {
        throw Exception('Test exception');
      },
    );

    var serverpod = IntegrationTestServer.create();
    serverpod.experimental.shutdownTasks.addTask(task);

    expect(
      () async => await serverpod.shutdown(exitProcess: false),
      throwsException,
    );
  });

  test(
      'Given multiple shutdown tasks that throw errors '
      'when the server is shutdown '
      'then last thrown exception is thrown from shutdown method.', () async {
    var exception1 = #firstException;
    var exception2 = #secondException;
    var task1 = Task(
      #testTask1,
      () async {
        throw exception1;
      },
    );
    var task2 = Task(
      #testTask2,
      () async {
        await Future.delayed(Duration(milliseconds: 100));
        throw exception2;
      },
    );

    var serverpod = IntegrationTestServer.create();
    serverpod.experimental.shutdownTasks.addTask(task1);
    serverpod.experimental.shutdownTasks.addTask(task2);

    await expectLater(
      () async => await serverpod.shutdown(exitProcess: false),
      throwsA(exception2),
    );
  });

  test(
      'Given multiple shutdown tasks '
      'when the server is shutdown '
      'then tasks are executed concurrently.', () async {
    final completer1 = Completer<void>();
    final completer2 = Completer<void>();

    var task1 = Task(
      #task1,
      () async {
        completer1.complete();
        await completer2.future;
      },
    );
    var task2 = Task(
      #task2,
      () async {
        await completer1.future;
        completer2.complete();
      },
    );

    var serverpod = IntegrationTestServer.create();
    serverpod.experimental.shutdownTasks.addTask(task1);
    serverpod.experimental.shutdownTasks.addTask(task2);

    await serverpod.shutdown(exitProcess: false);

    expect(completer1.isCompleted, isTrue);
    expect(completer2.isCompleted, isTrue);
  });

  test(
      'Given a registered shutdown task '
      'when the server is shutdown '
      'then the task is executed after all request receiving services are shutdown',
      () async {
    var serverStopped = false;
    var webServerStopped = false;
    var serviceServerStopped = false;

    var serverpod = IntegrationTestServer.create();
    serverpod.experimental.shutdownTasks.addTask(
      Task(
        #testTask,
        () async {
          serverStopped = serverpod.server.running;
          webServerStopped = serverpod.webServer.running;
          serviceServerStopped = serverpod.serviceServer.running;
        },
      ),
    );

    await serverpod.shutdown(exitProcess: false);

    expect(serverStopped, isFalse,
        reason: 'Server was not shutdown when task executed');
    expect(webServerStopped, isFalse,
        reason: 'Web server was not shutdown when task executed');
    expect(serviceServerStopped, isFalse,
        reason: 'Service server was not shutdown when task executed');
  });
}
