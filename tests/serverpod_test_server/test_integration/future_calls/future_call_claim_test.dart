import 'dart:async';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/future_call_claim_entry.dart';
import 'package:serverpod_test_server/src/generated/simple_data.dart';
import 'package:test/test.dart';
import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';

class _CounterFutureCall extends FutureCall<SimpleData> {
  int counter = 0;

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    counter++;
  }
}

class _CompleterFutureCall extends FutureCall<SimpleData> {
  final Completer<SimpleData?> completer = Completer<SimpleData?>();
  int counter = 0;

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    await completer.future;
    counter++;
  }
}

void main() {
  withServerpod(
    'Given FutureCallManager with scheduled FutureCall that is due',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late _CompleterFutureCall testCall;
      final testCallName = 'claim-insertion-call';

      setUp(() async {
        session = sessionBuilder.build();
        final config = FutureCallConfig(
          scanInterval: Duration(milliseconds: 1),
        );

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).withConfig(config).build();

        testCall = _CompleterFutureCall();
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
          // Wait for future call execution to be scheduled
          await Future.delayed(const Duration(milliseconds: 100));
        });

        tearDown(() async {
          if (!testCall.completer.isCompleted) {
            testCall.completer.complete();
          }
          await futureCallManager.stop();
        });

        test('then a claim is inserted for the FutureCall', () async {
          final claims = await FutureCallClaimEntry.db.find(session);
          expect(claims, hasLength(1));
          testCall.completer.complete();
        });

        test('then the FutureCall is executed', () async {
          testCall.completer.complete();
          await testCall.completer.future;
          expect(testCall.counter, equals(1));
        });

        test(
          'then the claim is deleted after the FutureCall is executed',
          () async {
            testCall.completer.complete();
            await testCall.completer.future;

            // Wait for cleanup to run
            await Future.delayed(const Duration(milliseconds: 100));
            final claims = await FutureCallClaimEntry.db.find(session);
            expect(claims, isEmpty);
          },
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );

  withServerpod(
    'Given FutureCallManager with scheduled FutureCall that is due '
    'and existing valid claim in the database for the FutureCall',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late _CounterFutureCall testCall;
      final testCallName = 'existing-claimtest-call';

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).build();

        testCall = _CounterFutureCall();
        futureCallManager.registerFutureCall(testCall, testCallName);

        // Insert a future call entry that is due
        var entry = FutureCallEntry(
          name: testCallName,
          serializedObject: SimpleData(num: 4).toString(),
          time: DateTime.now().subtract(const Duration(seconds: 1)),
          serverId: '1',
        );

        entry = await FutureCallEntry.db.insertRow(session, entry);

        // Insert an existing claim for this future call
        final claim = FutureCallClaimEntry(
          futureCallId: entry.id,
          lastHeartbeatTime: DateTime.now().toUtc(),
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

  withServerpod(
    'Given FutureCallManager with scheduled FutureCall that is due '
    'and existing stale claim in the database for the FutureCall',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late _CompleterFutureCall testCall;
      final testCallName = 'stale-claim-test-call';
      late FutureCallClaimEntry staleClaim;

      setUp(() async {
        session = sessionBuilder.build();
        final config = FutureCallConfig(
          scanInterval: Duration(milliseconds: 1),
        );

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).withConfig(config).build();

        testCall = _CompleterFutureCall();
        futureCallManager.registerFutureCall(testCall, testCallName);

        // Insert a future call entry that is due
        var entry = FutureCallEntry(
          name: testCallName,
          serializedObject: SimpleData(num: 4).toString(),
          time: DateTime.now().subtract(const Duration(seconds: 1)),
          serverId: '1',
          identifier: '',
        );

        entry = await FutureCallEntry.db.insertRow(session, entry);

        // Insert a stale claim for this future call
        staleClaim = FutureCallClaimEntry(
          futureCallId: entry.id,
          lastHeartbeatTime: DateTime.now().toUtc().subtract(
            const Duration(minutes: 5),
          ),
        );

        staleClaim = await FutureCallClaimEntry.db.insertRow(
          session,
          staleClaim,
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
          testCall.completer.complete();
          await futureCallManager.runScheduledFutureCalls();
        });

        test('then the FutureCall is executed', () async {
          await testCall.completer.future;
          expect(testCall.counter, equals(1));
        });

        test('then the claim is deleted', () async {
          final claims = await FutureCallClaimEntry.db.find(session);
          expect(claims, isEmpty);
        });
      });

      group('when start is called', () {
        setUp(() async {
          await futureCallManager.start();
        });

        tearDown(() async {
          if (!testCall.completer.isCompleted) {
            testCall.completer.complete();
          }
          await futureCallManager.stop();
        });

        test('then the stale claim is replaced', () async {
          // Wait for the call to be scheduled
          await Future.delayed(const Duration(milliseconds: 100));

          final claims = await FutureCallClaimEntry.db.find(session);
          expect(claims, hasLength(1));
          expect(staleClaim, isNot(claims.first));

          testCall.completer.complete();
          await testCall.completer.future;
        });
      });
    },
  );

  withServerpod(
    'Given FutureCallManager with scheduled long running FutureCall that is due',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late _CompleterFutureCall testCall;
      final testCallName = 'long-running-test-call';
      const heartbeatInterval = Duration(milliseconds: 100);

      setUp(() async {
        session = sessionBuilder.build();
        final config = FutureCallConfig(
          scanInterval: Duration(milliseconds: 1),
        );

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).withConfig(config).withHeartbeatInterval(heartbeatInterval).build();

        testCall = _CompleterFutureCall();
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
          if (!testCall.completer.isCompleted) {
            testCall.completer.complete();
          }
          await futureCallManager.stop();
        });

        test('then heartbeat timestamp is updated periodically', () async {
          // Wait for future call execution to be scheduled
          await Future.delayed(const Duration(milliseconds: 100));

          final initialClaims = await FutureCallClaimEntry.db.find(session);
          expect(initialClaims, hasLength(1));

          await Future.delayed(heartbeatInterval * 2);

          final updatedClaims = await FutureCallClaimEntry.db.find(session);
          expect(updatedClaims, hasLength(1));

          final updatedClaim = updatedClaims.first;
          final initialClaim = initialClaims.first;

          expect(updatedClaim.id, equals(initialClaim.id));
          expect(
            updatedClaim.lastHeartbeatTime.isAfter(
              initialClaim.lastHeartbeatTime,
            ),
            isTrue,
          );

          testCall.completer.complete();
        });

        test(
          'then heartbeat timer is cancelled after future call is executed',
          () async {
            // Wait for future call execution to be scheduled
            await Future.delayed(const Duration(milliseconds: 100));

            testCall.completer.complete();
            // ignore: invalid_use_of_visible_for_testing_member
            expect(futureCallManager.heartbeatTimers, hasLength(1));
            await testCall.completer.future;

            // Wait for cleanup to run
            await Future.delayed(const Duration(milliseconds: 100));
            // ignore: invalid_use_of_visible_for_testing_member
            expect(futureCallManager.heartbeatTimers, isEmpty);
          },
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );

  withServerpod(
    'Given a degraded and an active FutureCallManager '
    'running concurrently and a FutureCall that is due',
    (sessionBuilder, _) {
      late FutureCallManager degradedFutureCallManager;
      late FutureCallManager activeFutureCallManager;
      late Session session;
      late _CompleterFutureCall testCall;
      final testCallName = 'long-running-test-call';
      const degradedHeartbeatInterval = Duration(milliseconds: 800);
      const activeHeartbeatInterval = Duration(milliseconds: 100);

      setUp(() async {
        session = sessionBuilder.build();
        final configA = FutureCallConfig(
          scanInterval: Duration(milliseconds: 1),
        );
        final configB = FutureCallConfig(
          scanInterval: Duration(milliseconds: 100),
        );

        // We simulate a degraded instance with a long heartbeat interval.
        degradedFutureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(
                  sessionBuilder,
                )
                .withConfig(configA)
                .withHeartbeatInterval(degradedHeartbeatInterval)
                .build();

        // We simulate an active instance with a shorter heartbeat interval.
        activeFutureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(
                  sessionBuilder,
                )
                .withConfig(configB)
                .withHeartbeatInterval(activeHeartbeatInterval)
                .build();

        testCall = _CompleterFutureCall();

        degradedFutureCallManager.registerFutureCall(testCall, testCallName);
        activeFutureCallManager.registerFutureCall(testCall, testCallName);

        final entry = FutureCallEntry(
          name: testCallName,
          serializedObject: SimpleData(num: 4).toString(),
          time: DateTime.now().subtract(const Duration(seconds: 1)),
          serverId: '1',
          identifier: '',
        );

        await FutureCallEntry.db.insertRow(session, entry);

        await degradedFutureCallManager.start();
      });

      tearDown(() async {
        if (!testCall.completer.isCompleted) {
          testCall.completer.complete();
        }
        await degradedFutureCallManager.stop(unregisterAll: true);
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
        await session.close();
      });

      group('when scanning due future calls on the active instance', () {
        setUp(() async {
          await activeFutureCallManager.start();
        });

        tearDown(() async {
          if (!testCall.completer.isCompleted) {
            testCall.completer.complete();
          }
          await activeFutureCallManager.stop(unregisterAll: true);
        });

        test(
          'then the active instance detects the stale heartbeat and reclaims the execution',
          () async {
            // Wait for future call execution to be scheduled
            await Future.delayed(const Duration(milliseconds: 100));

            // Wait for degradedFutureCallManager's claim to be stale
            // and for activeFutureCallManager to acquire the claim
            await Future.delayed(activeHeartbeatInterval * 4);

            // ignore: invalid_use_of_visible_for_testing_member
            expect(activeFutureCallManager.heartbeatTimers, hasLength(1));

            testCall.completer.complete();
          },
        );

        test(
          'then the heartbeat update is aborted on the degraded instance due to losing the claim',
          () async {
            // Wait for degradedFutureCallManager's heartbeat update
            // to detect claim loss.
            await Future.delayed(degradedHeartbeatInterval * 2);

            // ignore: invalid_use_of_visible_for_testing_member
            expect(degradedFutureCallManager.heartbeatTimers, isEmpty);
            testCall.completer.complete();
          },
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
