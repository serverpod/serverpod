import 'dart:async';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';

class CompleterTestCall extends FutureCall<SimpleData> {
  final Completer<SimpleData?> completer = Completer<SimpleData?>();

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    completer.complete(object);
  }
}

void main() async {
  withServerpod('Given FutureCallManager', (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late Session session;
    var testCallName = 'test-db-entry-call';

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      futureCallManager.registerFutureCall(
        CompleterTestCall(),
        testCallName,
      );
    });

    group('when scheduling a FutureCall', () {
      setUp(() async {
        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 4),
          DateTime.now(),
          '1',
          'unique-identifier-42',
        );
      });

      test('then a FutureCallEntry is added to the database', () async {
        final futureCallEntries = await FutureCallEntry.db.find(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );

        expect(futureCallEntries, hasLength(1));
      });
    });
  });

  withServerpod('Given FutureCallManager with a scheduled FutureCall',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late Session session;
    var testCallName = 'test-cancel-future-call';
    var identifier = 'unique-identifier-1337';

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      await futureCallManager.scheduleFutureCall(
        testCallName,
        SimpleData(num: 4),
        DateTime.now().add(Duration(days: 42)),
        '1',
        identifier,
      );
    });

    group('when cancelling the scheduled FutureCall', () {
      setUp(() async {
        await futureCallManager.cancelFutureCall(identifier);
      });

      test('then the FutureCallEntry is removed from the database', () async {
        final futureCallEntries = await FutureCallEntry.db.find(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );

        expect(futureCallEntries, isEmpty);
      });
    });
  });

  withServerpod('Given FutureCallManager with a scheduled FutureCall',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late Session session;
    var testCallName = 'test-cancel-future-call-existing';
    var identifier = 'unique-identifier-1337';

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      await futureCallManager.scheduleFutureCall(
        testCallName,
        SimpleData(num: 4),
        DateTime.now().add(Duration(days: 42)),
        '1',
        identifier,
      );
    });

    test(
        'when cancelling a non-scheduled FutureCall'
        'then scheduled FutureCall is not removed', () async {
      await futureCallManager.cancelFutureCall('non-existing-identifier');

      final futureCallEntries = await FutureCallEntry.db.find(
        session,
        where: (entry) => entry.name.equals(testCallName),
      );

      expect(futureCallEntries, hasLength(1));
    });
  });

  withServerpod(
      'Given FutureCallManager with a scheduled not-registered FutureCall',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late Session session;
    var testCallName = 'non-registered-future-call';
    var identifier = 'very-unique-identifier';

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      await futureCallManager.scheduleFutureCall(
        testCallName,
        SimpleData(num: 4),
        DateTime.now().subtract(Duration(days: 42)),
        '1',
        identifier,
      );
    });

    test(
        'when executing all scheduled FutureCalls '
        'then FutureCall entry is removed from the database', () async {
      await futureCallManager.runScheduledFutureCalls();

      final futureCallEntries = await FutureCallEntry.db.find(
        session,
        where: (entry) => entry.name.equals(testCallName),
      );

      expect(futureCallEntries, isEmpty);
    });
  });

  withServerpod('Given FutureCallManager with scheduled FutureCall that is due',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late CompleterTestCall testCall;
    late Session session;
    var testCallName = 'testCall';
    var identifier = 'alex';

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      testCall = CompleterTestCall();

      futureCallManager.registerFutureCall(testCall, testCallName);

      await futureCallManager.scheduleFutureCall(
        testCallName,
        SimpleData(num: 4),
        DateTime.now().subtract(const Duration(seconds: 1)),
        '1',
        identifier,
      );
    });

    group('when running scheduled FutureCalls', () {
      setUp(() async {
        await futureCallManager.runScheduledFutureCalls();
      });

      test('then the FutureCall is executed', () async {
        await expectLater(testCall.completer.future, completes);
      });

      test('then the FutureCallEntry gets deleted from database', () async {
        final futureCallEntries = await FutureCallEntry.db.find(
          session,
        );

        expect(futureCallEntries, isEmpty);
      });
    });
  });

  withServerpod(
      'Given FutureCallManager with registered future call that is not due',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late CompleterTestCall testCall;
    var testCallName = 'no-due-call';
    var identifier = 'not-due-id';

    setUp(() async {
      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .withConfig(FutureCallConfig(
                // Set a short scan interval for testing
                scanInterval: Duration(milliseconds: 1),
              ))
              .build();

      testCall = CompleterTestCall();
      futureCallManager.registerFutureCall(testCall, testCallName);

      await futureCallManager.scheduleFutureCall(
        testCallName,
        SimpleData(num: 1),
        DateTime.now().add(Duration(days: 1)),
        '1',
        identifier,
      );
    });

    group('when start is called', () {
      setUp(() async {
        futureCallManager.start();
        // Wait briefly to allow processing to occur (or not occur)
        await Future.delayed(Duration(milliseconds: 10));
      });

      tearDown(() async {
        await futureCallManager.stop();
      });

      test('then FutureCall is not processed', () async {
        expect(testCall.completer.isCompleted, isFalse);
      });
    });
  });

  withServerpod('Given FutureCallManager in continuous mode',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late CompleterTestCall testCall;
    var testCallName = 'continuous-mode-call';
    var identifier = 'due-now-id';

    setUp(() async {
      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .withConfig(FutureCallConfig(
                // Set a short scan interval for testing
                scanInterval: Duration(milliseconds: 1),
              ))
              .build();

      testCall = CompleterTestCall();
      futureCallManager.registerFutureCall(testCall, testCallName);

      futureCallManager.start();
    });

    tearDown(() async {
      await futureCallManager.stop();
    });

    group('when a new future call becomes due', () {
      setUp(() async {
        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 2),
          DateTime.now().subtract(Duration(seconds: 1)), // Already due
          '1',
          identifier,
        );
      });

      test('then the call is processed automatically', () async {
        await expectLater(testCall.completer.future, completes);
      });
    });
  });

  withServerpod(
      'Given FutureCallManager that has been stopped from continuous mode',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late CompleterTestCall testCall;
    var testCallName = 'after-stop-call';
    var canaryCallName = 'canary-call';
    var identifier = 'stop-test-id';

    setUp(() async {
      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .withConfig(FutureCallConfig(
                // Set a short scan interval for testing
                scanInterval: Duration(milliseconds: 1),
              ))
              .build();

      var canaryCall = CompleterTestCall();
      futureCallManager.registerFutureCall(
        canaryCall,
        canaryCallName,
      );

      testCall = CompleterTestCall();
      futureCallManager.registerFutureCall(
        testCall,
        testCallName,
      );

      await futureCallManager.scheduleFutureCall(
        canaryCallName,
        SimpleData(num: 1),
        DateTime.now(),
        '1',
        identifier,
      );

      futureCallManager.start();

      // Wait for the canary call to be processed
      await canaryCall.completer.future;

      await futureCallManager.stop();
    });

    test('when scheduling a new future call then future call is not processed',
        () async {
      await futureCallManager.scheduleFutureCall(
        testCallName,
        SimpleData(num: 3),
        DateTime.now(),
        '1',
        identifier,
      );

      // Since scan interval is set to 1, we need to wait a bit to ensure
      // that the scheduler has had a chance to process any new calls if it
      // were to do so.
      await Future.delayed(Duration(milliseconds: 100));

      expect(testCall.completer.isCompleted, isFalse);
    });
  });
}
