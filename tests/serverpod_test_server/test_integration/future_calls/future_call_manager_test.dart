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

    setUp(() async {
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
          sessionBuilder.build(),
          where: (entry) => entry.name.equals('test-db-entry-call'),
        );

        expect(futureCallEntries, hasLength(1));
      });
    });
  });

  withServerpod('Given FutureCallManager with a scheduled FutureCall',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;

    setUp(() async {
      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      futureCallManager.registerFutureCall(
          CompleterTestCall(), 'test-cancel-future-call');

      futureCallManager.scheduleFutureCall(
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
          sessionBuilder.build(),
          where: (entry) => entry.name.equals('test-cancel-future-call'),
        );

        expect(futureCallEntries, hasLength(0));
      });
    });

    group('when cancelling a non-scheduled FutureCall', () {
      setUp(() async {
        await futureCallManager.cancelFutureCall('non-existing-identifier');
      });

      test('then no error is thrown and the database is not affected',
          () async {
        await expectLater(
          () => futureCallManager.cancelFutureCall('non-existing-identifier'),
          returnsNormally,
        );

        final futureCallEntries = await FutureCallEntry.db.find(
          sessionBuilder.build(),
          where: (entry) => entry.name.equals('test-cancel-future-call'),
        );

        expect(futureCallEntries, hasLength(1));
      });
    });
  });

  withServerpod(
      'Given FutureCallManager with a scheduled not-registered FutureCall',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;

    setUp(() async {
      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      futureCallManager.scheduleFutureCall(
        'non-registered-future-call',
        SimpleData(num: 4),
        DateTime.now().add(Duration(days: 42)),
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
          sessionBuilder.build(),
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

    setUp(() async {
      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      testCall = CompleterTestCall();

      futureCallManager.registerFutureCall(testCall, 'testCall');

      futureCallManager.scheduleFutureCall(
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
          sessionBuilder.build(),
        );

        expect(futureCallEntries, hasLength(0));
      });
    });
  });
}
