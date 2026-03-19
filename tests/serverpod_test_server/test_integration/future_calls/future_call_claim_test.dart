import 'dart:async';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/simple_data.dart';
import 'package:test/test.dart';
import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';
import 'package:serverpod/src/generated/future_call_claim_entry.dart';

class _CounterFutureCall extends FutureCall<SimpleData> {
  int counter = 0;

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    counter++;
  }
}

class _LongRunningCounterFutureCall extends FutureCall<SimpleData> {
  int counter = 0;

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    await Future.delayed(const Duration(seconds: 2));
    counter++;
  }
}

void main() {
  withServerpod(
    'Given FutureCallManager with scheduled FutureCall that is due',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late _LongRunningCounterFutureCall testCall;
      final testCallName = 'testCall';

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).build();

        testCall = _LongRunningCounterFutureCall();
        futureCallManager.registerFutureCall(testCall, testCallName);

        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 4),
          DateTime.now().subtract(const Duration(seconds: 1)),
          '1',
          '',
        );
      });

      tearDown(() async {
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );

        await session.close();
      });

      group('when start is called', () {
        setUp(() async {
          await futureCallManager.start();
        });

        tearDown(() async {
          await futureCallManager.stop();
        });

        test('then a claim is inserted for the FutureCall', () async {
          // Wait for future call execution to be scheduled
          await Future.delayed(const Duration(seconds: 1));

          final claims = await FutureCallClaimEntry.db.find(session);
          expect(claims, hasLength(1));
        });
      });
    },
  );

  withServerpod(
    'Given FutureCallManager with scheduled FutureCall that is due',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late _CounterFutureCall testCall;
      final testCallName = 'testCall';

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).build();

        testCall = _CounterFutureCall();
        futureCallManager.registerFutureCall(testCall, testCallName);

        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 4),
          DateTime.now().subtract(const Duration(seconds: 1)),
          '1',
          '',
        );
      });

      tearDown(() async {
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
        await session.close();
      });

      group('when running scheduled FutureCalls', () {
        setUp(() async {
          await futureCallManager.runScheduledFutureCalls();
        });

        test('then the FutureCall is executed', () async {
          expect(testCall.counter, equals(1));
        });

        test('then the claim is deleted', () async {
          final claims = await FutureCallClaimEntry.db.find(session);
          expect(claims, isEmpty);
        });
      });
    },
  );

  withServerpod(
    'Given FutureCallManager with scheduled FutureCall that is due'
    'and existing valid claim in the database for the FutureCall',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late _CounterFutureCall testCall;
      late FutureCallEntry existingEntry;
      final testCallName = 'testCall';

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).build();

        testCall = _CounterFutureCall();
        futureCallManager.registerFutureCall(testCall, testCallName);

        // Insert a future call entry that is due
        final entry = FutureCallEntry(
          id: 1,
          name: testCallName,
          serializedObject: SimpleData(num: 4).toString(),
          time: DateTime.now().subtract(const Duration(seconds: 1)),
          serverId: '1',
        );

        existingEntry = await FutureCallEntry.db.insertRow(session, entry);

        // Insert an existing claim for this future call
        final claim = FutureCallClaimEntry(
          id: existingEntry.id,
          heartbeat: DateTime.now().toUtc(),
        );
        await FutureCallClaimEntry.db.insert(session, [claim]);
      });

      tearDown(() async {
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
        await session.close();
      });

      group('when running scheduled FutureCalls', () {
        setUp(() async {
          await futureCallManager.runScheduledFutureCalls();
        });

        test('then the FutureCall is not executed', () async {
          expect(testCall.counter, equals(0));
        });

        test('then the claim is not deleted', () async {
          final claims = await FutureCallClaimEntry.db.find(session);
          expect(claims, hasLength(1));
        });
      });
    },
  );

  withServerpod('Given FutureCallManager with scheduled FutureCall that is due'
      'and existing stale claim in the database for the FutureCall', (
    sessionBuilder,
    _,
  ) {
    late FutureCallManager futureCallManager;
    late Session session;
    late _CounterFutureCall testCall;
    late FutureCallEntry existingEntry;
    final testCallName = 'testCall';

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
        sessionBuilder,
      ).build();

      testCall = _CounterFutureCall();
      futureCallManager.registerFutureCall(testCall, testCallName);

      // Insert a future call entry that is due
      final entry = FutureCallEntry(
        name: testCallName,
        serializedObject: SimpleData(num: 4).toString(),
        time: DateTime.now().subtract(const Duration(seconds: 1)),
        serverId: '1',
        identifier: '',
      );

      existingEntry = await FutureCallEntry.db.insertRow(session, entry);

      // Insert a stale claim for this future call
      final claim = FutureCallClaimEntry(
        id: existingEntry.id,
        heartbeat: DateTime.now().toUtc().subtract(
          const Duration(minutes: 5),
        ),
      );
      await FutureCallClaimEntry.db.insert(session, [claim]);
    });

    tearDown(() async {
      await FutureCallEntry.db.deleteWhere(
        session,
        where: (entry) => entry.name.equals(testCallName),
      );
      await session.close();
    });

    group('when running scheduled FutureCalls', () {
      setUp(() async {
        await futureCallManager.runScheduledFutureCalls();
      });

      test('then the FutureCall is executed', () async {
        expect(testCall.counter, equals(1));
      });

      test('then the claim is deleted', () async {
        final claims = await FutureCallClaimEntry.db.find(session);
        expect(claims, isEmpty);
      });
    });
  });

  withServerpod(
    'Given FutureCallManager with scheduled long running FutureCall that is due',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late _LongRunningCounterFutureCall testCall;
      final testCallName = 'testCall';

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).withHeartbeatInterval(Duration(milliseconds: 500)).build();

        testCall = _LongRunningCounterFutureCall();
        futureCallManager.registerFutureCall(testCall, testCallName);

        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 4),
          DateTime.now().subtract(const Duration(seconds: 1)),
          '1',
          '',
        );
      });

      tearDown(() async {
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
        await session.close();
      });

      group('when start is called', () {
        setUp(() async {
          await futureCallManager.start();
        });

        tearDown(() async {
          await futureCallManager.stop();
        });

        test('then heartbeat timestamp is updated periodically', () async {
          // Wait for future call execution to be scheduled
          await Future.delayed(const Duration(seconds: 1));

          final initialClaims = await FutureCallClaimEntry.db.find(session);
          expect(initialClaims, hasLength(1));

          await Future.delayed(Duration(milliseconds: 500));

          final updatedClaims = await FutureCallClaimEntry.db.find(session);
          expect(updatedClaims, hasLength(1));

          final updatedClaim = updatedClaims.first;
          final initialClaim = initialClaims.first;

          expect(updatedClaim.id, equals(initialClaim.id));
          expect(
            updatedClaim.heartbeat.isAfter(initialClaim.heartbeat),
            isTrue,
          );
        });
      });
    },
  );
}
