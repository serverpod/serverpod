import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/command_line_args.dart';
import 'package:serverpod/src/server/future_call_manager/future_call_manager.dart';
import 'package:test/test.dart';

import 'future_call_scanner_mock.dart';
import 'future_call_scheduler_mock.dart';

class MockServer extends Mock implements Server {}

class MockServerpod extends Mock implements Serverpod {}

class MockCommandLineArgs extends Mock implements CommandLineArgs {}

class MockSerializationManager extends Mock implements SerializationManager {}

class MockFutureCall extends Mock implements FutureCall<SerializableModel> {}

abstract class OnCompleted {
  void call();
}

class MockOnCompleted extends Mock implements OnCompleted {}

void main() {
  late MockServer server;
  late MockSerializationManager serializationManager;
  late MockFutureCallScheduler scheduler;
  late MockFutureCallScanner scanner;
  late FutureCallConfig config;
  late FutureCallManager manager;
  late MockCommandLineArgs commandLineArgs;
  late MockServerpod serverpod;
  late MockOnCompleted onCompleted;

  setUp(() {
    server = MockServer();
    serializationManager = MockSerializationManager();
    scheduler = MockFutureCallScheduler();
    scanner = MockFutureCallScanner();
    commandLineArgs = MockCommandLineArgs();
    serverpod = MockServerpod();
    config = const FutureCallConfig(
      concurrencyLimit: 1,
      scanInterval: Duration(milliseconds: 100),
    );
    onCompleted = MockOnCompleted();

    when(() => server.serverpod).thenReturn(serverpod);
    when(() => serverpod.commandLineArgs).thenReturn(commandLineArgs);

    manager = FutureCallManager.forTesting(
      server,
      config,
      serializationManager,
      onCompleted.call,
      scheduler: scheduler,
      scanner: scanner,
    );
  });

  group('FutureCallManager', () {
    test('registerFutureCall should register a future call with the scheduler',
        () {
      final futureCall = MockFutureCall();
      const name = 'testFutureCall';

      manager.registerFutureCall(futureCall, name);

      verify(() => scheduler.registerFutureCall(futureCall, name)).called(1);
    });

    test('start should handle monolith role', () async {
      when(() => commandLineArgs.role).thenReturn(ServerpodRole.monolith);

      manager.start();

      verify(() => scanner.start()).called(1);
      verifyNever(() => scheduler.stop());
      verifyNever(() => scanner.scanFutureCalls());
    });

    test('start should handle maintenance role', () async {
      when(() => commandLineArgs.role).thenReturn(ServerpodRole.maintenance);

      final completer = Completer<void>();

      when(() => scanner.start()).thenThrow(Exception('test'));
      when(() => scanner.scanFutureCalls()).thenAnswer((_) async {});
      when(() => scheduler.stop()).thenAnswer((_) async {});
      when(() => onCompleted.call()).thenAnswer((_) => completer.complete());

      manager.start();

      await completer.future;

      verify(() => scanner.scanFutureCalls()).called(1);
      verify(() => scheduler.stop()).called(1);
      verify(() => onCompleted.call()).called(1);
    });

    test('start should handle serverless role', () async {
      when(() => commandLineArgs.role).thenReturn(ServerpodRole.serverless);

      manager.start();

      verifyNever(() => scanner.start());
      verifyNever(() => scanner.scanFutureCalls());
      verifyNever(() => scheduler.stop());
    });

    test('stop should stop scanner and scheduler', () async {
      when(() => scanner.stop()).thenAnswer((_) async {});
      when(() => scheduler.stop()).thenAnswer((_) async {});

      await manager.stop();

      verify(() => scanner.stop()).called(1);
      verify(() => scheduler.stop()).called(1);
    });
  });
}
