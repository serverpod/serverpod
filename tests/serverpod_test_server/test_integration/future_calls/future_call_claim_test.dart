import 'dart:async';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/future_call_claim_entry.dart';
import 'package:serverpod_test_server/src/generated/simple_data.dart';
import 'package:test/test.dart';
import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';

class _CounterFutureCall extends FutureCall<SimpleData>
    implements InvokableFutureCall<SimpleData> {
  int counter = 0;

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    counter++;
  }
}

class _CompleterFutureCall extends FutureCall<SimpleData>
    implements InvokableFutureCall<SimpleData> {
  final Completer<SimpleData?> completer = Completer<SimpleData?>();
  final Completer<void> invocationStarted = Completer<void>();
  int counter = 0;

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    if (!invocationStarted.isCompleted) {
      invocationStarted.complete();
    }
    await completer.future;
    counter++;
  }
}

/// Polls [condition] until it is fulfilled.
///
/// Fails the test if [condition] is not fulfilled within [timeout].
///
/// Used instead of waiting a fixed amount of time for background work, which
/// makes the tests fail on machines that are slower than the delay assumes.
Future<void> waitUntil(
  FutureOr<bool> Function() condition, {
  required String description,
  Duration timeout = const Duration(seconds: 10),
  Duration pollInterval = const Duration(milliseconds: 10),
}) async {
  final deadline = DateTime.now().add(timeout);

  while (!await condition()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Timed out after $timeout waiting for $description.');
    }

    await Future.delayed(pollInterval);
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
          await testCall.invocationStarted.future;
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

            // The claim is cleaned up after the invocation returns.
            await waitUntil(
              () async => (await FutureCallClaimEntry.db.find(session)).isEmpty,
              description: 'the claim to be deleted',
            );
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

          // Wait for the call to be claimed and its execution to start.
          await testCall.invocationStarted.future;
        });

        tearDown(() async {
          if (!testCall.completer.isCompleted) {
            testCall.completer.complete();
          }
          await futureCallManager.stop();
        });

        test('then the stale claim is replaced', () async {
          final claims = await FutureCallClaimEntry.db.find(session);
          expect(claims, hasLength(1));
          expect(claims.first.id, isNot(staleClaim.id));

          testCall.completer.complete();
          await testCall.completer.future;
        });
      });
    },
  );

  withServerpod(
    'Given FutureCallManager with scheduled long running FutureCall that is due',
    rollbackDatabase: RollbackDatabase.disabled,
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

          // Wait for the call to be claimed and its execution to start.
          await testCall.invocationStarted.future;
        });

        tearDown(() async {
          if (!testCall.completer.isCompleted) {
            testCall.completer.complete();
          }
          await futureCallManager.stop();
        });

        test('then heartbeat timestamp is updated periodically', () async {
          final initialClaims = await FutureCallClaimEntry.db.find(session);
          expect(initialClaims, hasLength(1));
          final initialClaim = initialClaims.first;

          late FutureCallClaimEntry updatedClaim;
          await waitUntil(
            () async {
              final claims = await FutureCallClaimEntry.db.find(session);
              if (claims.length != 1) return false;

              updatedClaim = claims.first;
              return updatedClaim.lastHeartbeatTime.isAfter(
                initialClaim.lastHeartbeatTime,
              );
            },
            description: 'the heartbeat timestamp of the claim to be updated',
          );

          expect(updatedClaim.id, equals(initialClaim.id));

          // The heartbeat is not updated more often than configured. Both
          // timestamps are written by the manager, so this holds regardless
          // of how slow the machine running the test is.
          expect(
            updatedClaim.lastHeartbeatTime.difference(
              initialClaim.lastHeartbeatTime,
            ),
            greaterThanOrEqualTo(heartbeatInterval),
          );

          testCall.completer.complete();
        });

        test(
          'then heartbeat timer is cancelled after future call is executed',
          () async {
            // ignore: invalid_use_of_visible_for_testing_member
            expect(futureCallManager.heartbeatTimers, hasLength(1));

            testCall.completer.complete();
            await testCall.completer.future;

            // The heartbeat timer is cancelled after the invocation returns.
            await waitUntil(
              // ignore: invalid_use_of_visible_for_testing_member
              () => futureCallManager.heartbeatTimers.isEmpty,
              description: 'the heartbeat timer to be cancelled',
            );
          },
        );
      });
    },
  );

  withServerpod(
    'Given a degraded and an active FutureCallManager '
    'running concurrently and a FutureCall that is due',
    rollbackDatabase: RollbackDatabase.disabled,
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
            // Wait for degradedFutureCallManager's claim to become stale
            // and for activeFutureCallManager to acquire the claim.
            await waitUntil(
              // ignore: invalid_use_of_visible_for_testing_member
              () => activeFutureCallManager.heartbeatTimers.length == 1,
              description: 'the active instance to reclaim the future call',
            );

            testCall.completer.complete();
          },
        );

        test(
          'then the heartbeat update is aborted on the degraded instance due to losing the claim',
          () async {
            // The degraded instance claims the future call first, since it is
            // started first and scans more frequently.
            await waitUntil(
              // ignore: invalid_use_of_visible_for_testing_member
              () => degradedFutureCallManager.heartbeatTimers.isNotEmpty,
              description: 'the degraded instance to claim the future call',
            );

            // Wait for degradedFutureCallManager's heartbeat update
            // to detect claim loss.
            await waitUntil(
              // ignore: invalid_use_of_visible_for_testing_member
              () => degradedFutureCallManager.heartbeatTimers.isEmpty,
              description:
                  'the degraded instance to abort its heartbeat update',
            );

            testCall.completer.complete();
          },
        );
      });
    },
  );
}
