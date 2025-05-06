import 'dart:async';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';

class CompleterTestCall extends FutureCall<SimpleData> {
  final Completer<void> completer = Completer<void>();

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    if (object != null) {
      var data = object;
      session.log('${data.num}');
    } else {
      session.log('null');
    }

    completer.complete();
  }
}

void main() async {
  withServerpod('Given FutureCallManager', (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      futureCallManager.registerFutureCall(
          CompleterTestCall(), 'test-db-entry-call');
    });

    tearDown(() async {
      await futureCallManager.stop();
    });

    group('when scheduling a FutureCall', () {
      setUp(() async {
        await futureCallManager.scheduleFutureCall(
          'test-db-entry-call',
          SimpleData(num: 4),
          DateTime.now(),
          '1',
          'unique-identifier-42',
        );
      });

      test('then a FutureCallEntry is added to the database', () async {
        final futureCallEntries = await FutureCallEntry.db.find(
          session,
          where: (entry) => entry.name.equals('test-db-entry-call'),
        );

        expect(futureCallEntries, hasLength(1));
      });
    });
  });

  withServerpod('Given FutureCallManager with a scheduled FutureCall',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      await futureCallManager.scheduleFutureCall(
        'test-cancel-future-call',
        SimpleData(num: 4),
        DateTime.now().add(Duration(days: 42)),
        '1',
        'unique-identifier-1337',
      );
    });

    tearDown(() async {
      await futureCallManager.stop();
    });

    group('when cancelling the scheduled FutureCall', () {
      setUp(() async {
        await futureCallManager.cancelFutureCall('unique-identifier-1337');
      });

      test('then the FutureCallEntry is removed from the database', () async {
        final futureCallEntries = await FutureCallEntry.db.find(
          session,
          where: (entry) => entry.name.equals('test-cancel-future-call'),
        );

        expect(futureCallEntries, hasLength(0));
      });
    });
  });

  withServerpod('Given FutureCallManager with a scheduled FutureCall',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      await futureCallManager.scheduleFutureCall(
        'test-cancel-future-call-existing',
        SimpleData(num: 4),
        DateTime.now().add(Duration(days: 42)),
        '1',
        'unique-identifier-1337',
      );
    });

    tearDown(() async {
      await futureCallManager.stop();
    });

    group('when cancelling a non-scheduled FutureCall', () {
      setUp(() async {
        await futureCallManager.cancelFutureCall('non-existing-identifier');
      });

      test('then no error is thrown and the database is not affected',
          () async {
        await futureCallManager.cancelFutureCall('non-existing-identifier');

        final futureCallEntries = await FutureCallEntry.db.find(
          session,
          where: (entry) =>
              entry.name.equals('test-cancel-future-call-existing'),
        );

        expect(futureCallEntries, hasLength(1));
      });
    });
  });

  withServerpod(
      'Given FutureCallManager with a scheduled not-registered FutureCall',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      await futureCallManager.scheduleFutureCall(
        'non-registered-future-call',
        SimpleData(num: 4),
        DateTime.now().subtract(Duration(days: 42)),
        '1',
        'very-unique-identifier',
      );
    });

    tearDown(() async {
      await futureCallManager.stop();
    });

    group('when executing a scheduled but unregistered FutureCall', () {
      test('then no error is thrown and the FutureCallEntry is removed',
          () async {
        await futureCallManager.runScheduledFutureCalls();

        final futureCallEntries = await FutureCallEntry.db.find(
          session,
          where: (entry) => entry.name.equals('non-registered-future-call'),
        );

        expect(futureCallEntries, hasLength(0));
      });
    });
  });

  withServerpod('Given FutureCallManager with scheduled FutureCall that is due',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late CompleterTestCall testCall;
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      testCall = CompleterTestCall();

      futureCallManager.registerFutureCall(testCall, 'testCall');

      await futureCallManager.scheduleFutureCall(
        'testCall',
        SimpleData(num: 4),
        DateTime.now().subtract(const Duration(seconds: 1)),
        '1',
        'alex',
      );
    });

    tearDown(() async {
      await futureCallManager.stop();
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

        expect(futureCallEntries, hasLength(0));
      });
    });
  });

  withServerpod('Given FutureCallManager with no due future calls',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late CompleterTestCall testCall;
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      testCall = CompleterTestCall();
      futureCallManager.registerFutureCall(testCall, 'no-due-call');

      await futureCallManager.scheduleFutureCall(
        'no-due-call',
        SimpleData(num: 1),
        DateTime.now().add(Duration(days: 1)),
        '1',
        'not-due-id',
      );
    });

    tearDown(() async {
      await futureCallManager.stop();
    });

    group('when start is called', () {
      setUp(() async {
        futureCallManager.start();
        // Wait briefly to allow processing to occur (or not occur)
        await Future.delayed(Duration(milliseconds: 100));
      });

      test('then no calls are processed', () async {
        expect(testCall.completer.isCompleted, isFalse);
      });
    });
  });

  withServerpod('Given FutureCallManager in continuous mode',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late CompleterTestCall testCall;

    setUp(() async {
      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      testCall = CompleterTestCall();
      futureCallManager.registerFutureCall(testCall, 'continuous-mode-call');

      futureCallManager.start();
    });

    tearDown(() async {
      await futureCallManager.stop();
    });

    group('when a new future call becomes due', () {
      setUp(() async {
        await futureCallManager.scheduleFutureCall(
          'continuous-mode-call',
          SimpleData(num: 2),
          DateTime.now().subtract(Duration(seconds: 1)), // Already due
          '1',
          'due-now-id',
        );
      });

      test('then the call is processed automatically', () async {
        await expectLater(testCall.completer.future, completes);
      });
    });
  });

  withServerpod('Given FutureCallManager running in continuous mode',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late CompleterTestCall testCall;

    setUp(() async {
      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      testCall = CompleterTestCall();
      futureCallManager.registerFutureCall(
          testCall, 'continuous-mode-stop-call');

      futureCallManager.start();

      await futureCallManager.stop();

      await futureCallManager.scheduleFutureCall(
        'continuous-mode-stop-call',
        SimpleData(num: 3),
        DateTime.now(),
        '1',
        'stop-test-id',
      );
    });

    group('when stop is called', () {
      test('then future calls are no longer processed', () async {
        await Future.delayed(Duration(milliseconds: 100));

        expect(testCall.completer.isCompleted, isFalse);
      });
    });
  });

  withServerpod('Given FutureCallManager running in continuous mode',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late CompleterTestCall testCall;

    setUp(() async {
      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      testCall = CompleterTestCall();
      futureCallManager.registerFutureCall(
          testCall, 'continuous-mode-new-call-after-stop');

      futureCallManager.start();
      await futureCallManager.stop();
    });

    group('when a new future call is scheduled after stop', () {
      setUp(() async {
        await futureCallManager.scheduleFutureCall(
          'continuous-mode-new-call-after-stop',
          SimpleData(num: 5),
          DateTime.now().subtract(Duration(seconds: 1)),
          '1',
          'new-call-after-stop-id',
        );
      });

      test('then the call is not processed', () async {
        await Future.delayed(Duration(milliseconds: 100));

        expect(testCall.completer.isCompleted, isFalse);
      });
    });
  });
}
