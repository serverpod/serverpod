import 'dart:async';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/simple_data.dart';
import 'package:serverpod_test_server/test_util/logging_utils.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
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
    await Future.delayed(const Duration(seconds: 5));
    counter++;
  }
}

class _CompleterFutureCall extends FutureCall<SimpleData> {
  final Completer<SimpleData?> completer = Completer<SimpleData?>();

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    completer.complete(object);
  }
}

void main() {
  group('1. Given FutureCallManager with scheduled FutureCall that is due', () {
    withServerpod('when running scheduled FutureCalls', (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late _LongRunningCounterFutureCall testCall;
      var testCallName = 'testCall';
      var identifier = 'test-id';

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
          identifier,
        );

        await FutureCallClaimEntry.db.deleteWhere(
          session,
          where: (t) => t.id.notEquals(null),
        );
      });

      tearDown(() async {
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
        await FutureCallClaimEntry.db.deleteWhere(
          session,
          where: (t) => t.id.notEquals(null),
        );
        await session.close();
      });

      test('then a claim is inserted for the FutureCall', () async {
        await futureCallManager.runScheduledFutureCalls();

        final claims = await FutureCallClaimEntry.db.find(session);
        expect(claims, hasLength(1));
      });

      test('then the FutureCall is executed', () async {
        await futureCallManager.runScheduledFutureCalls();
        expect(testCall.counter, equals(1));
      });

      test('then the claim is deleted', () async {
        await futureCallManager.runScheduledFutureCalls();
        await Future.delayed(const Duration(seconds: 1));

        final claims = await FutureCallClaimEntry.db.find(session);
        expect(claims, isEmpty);
      });
    });
  });

  group(
    '2. Given FutureCallManager with scheduled FutureCall that is due with existing claim in the database for the FutureCall',
    () {
      withServerpod('when running scheduled FutureCalls', (sessionBuilder, _) {
        late FutureCallManager futureCallManager;
        late Session session;
        late _CounterFutureCall testCall;
        var testCallName = 'testCall';
        var identifier = 'test-id';
        late FutureCallEntry existingEntry;

        setUp(() async {
          session = sessionBuilder.build();

          futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
            sessionBuilder,
          ).build();

          testCall = _CounterFutureCall();
          futureCallManager.registerFutureCall(testCall, testCallName);

          // Insert a future call entry that is due
          existingEntry = FutureCallEntry(
            id: 1,
            name: testCallName,
            serializedObject: SimpleData(num: 4).toString(),
            time: DateTime.now().subtract(const Duration(seconds: 1)),
            serverId: '1',
            identifier: identifier,
          );
          await FutureCallEntry.db.insertRow(session, existingEntry);

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
          await FutureCallClaimEntry.db.deleteWhere(
            session,
            where: (t) => t.id.notEquals(null),
          );
          await session.close();
        });

        test('then the FutureCall is not executed', () async {
          await futureCallManager.runScheduledFutureCalls();
          expect(testCall.counter, equals(0));
        });

        test('then the claim is not deleted', () async {
          await futureCallManager.runScheduledFutureCalls();

          final claims = await FutureCallClaimEntry.db.find(session);
          expect(claims, hasLength(1));
        });
      });
    },
  );

  group(
    '3. Given FutureCallManager with scheduled FutureCall that is due with existing stale claim in the database for the FutureCall',
    () {
      withServerpod('when running scheduled FutureCalls', (sessionBuilder, _) {
        late FutureCallManager futureCallManager;
        late Session session;
        late _CounterFutureCall testCall;
        var testCallName = 'testCall';
        var identifier = 'test-id';
        late FutureCallEntry existingEntry;

        setUp(() async {
          session = sessionBuilder.build();

          futureCallManager =
              FutureCallManagerBuilder.fromTestSessionBuilder(
                    sessionBuilder,
                  )
                  .withConfig(
                    FutureCallConfig(
                      // Set a short heartbeat interval for testing to make claims stale quickly
                      // Note: heartbeatInterval is not a direct parameter, we'll use scanInterval instead for testing
                      scanInterval: Duration(seconds: 1),
                    ),
                  )
                  .build();

          testCall = _CounterFutureCall();
          futureCallManager.registerFutureCall(testCall, testCallName);

          // Insert a future call entry that is due
          existingEntry = FutureCallEntry(
            name: testCallName,
            serializedObject: SimpleData(num: 4).toString(),
            time: DateTime.now().subtract(const Duration(seconds: 1)),
            serverId: '1',
            identifier: identifier,
          );
          await FutureCallEntry.db.insertRow(session, existingEntry);

          // Insert an existing stale claim for this future call (older than 2x heartbeat interval)
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
          await FutureCallClaimEntry.db.deleteWhere(
            session,
            where: (t) => t.id.notEquals(null),
          );
          await session.close();
        });

        test('then the FutureCall is executed', () async {
          await futureCallManager.runScheduledFutureCalls();
          expect(testCall.counter, equals(1));
        });

        test('then the claim is deleted', () async {
          await futureCallManager.runScheduledFutureCalls();

          final claims = await FutureCallClaimEntry.db.find(session);
          expect(claims, isEmpty);
        });
      });
    },
  );

  group(
    '4. Given FutureCallManager with scheduled long running FutureCall that is due',
    () {
      withServerpod('when running scheduled FutureCalls', (sessionBuilder, _) {
        late FutureCallManager futureCallManager;
        late Session session;
        late _CounterFutureCall testCall;
        var testCallName = 'testCall';
        var identifier = 'test-id';

        setUp(() async {
          session = sessionBuilder.build();

          futureCallManager =
              FutureCallManagerBuilder.fromTestSessionBuilder(
                    sessionBuilder,
                  )
                  .withConfig(
                    FutureCallConfig(
                      // Set a short scan interval for testing
                      scanInterval: Duration(seconds: 1),
                    ),
                  )
                  .build();

          testCall = _CounterFutureCall();
          futureCallManager.registerFutureCall(testCall, testCallName);

          await futureCallManager.scheduleFutureCall(
            testCallName,
            SimpleData(num: 4),
            DateTime.now().subtract(const Duration(seconds: 1)),
            '1',
            identifier,
          );
        });

        tearDown(() async {
          await FutureCallEntry.db.deleteWhere(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );
          await FutureCallClaimEntry.db.deleteWhere(
            session,
            where: (t) => t.id.notEquals(null),
          );
          await session.close();
        });

        test('then heartbeat timestamp is updated periodically', () async {
          // We'll test this by checking that the claim exists during execution
          // and has a recent heartbeat
          await futureCallManager.scheduleFutureCall(
            testCallName,
            SimpleData(num: 4),
            DateTime.now().subtract(const Duration(seconds: 10)), // Way overdue
            '1',
            identifier,
          );

          // Execute the future call but delay completion to simulate long running call
          await futureCallManager.scheduleFutureCall(
            testCallName,
            SimpleData(num: 4),
            DateTime.now().subtract(const Duration(seconds: 10)),
            '1',
            identifier + '-2',
          );

          // Register a call that takes time to complete
          var delayCall = _CompleterFutureCall();
          futureCallManager.registerFutureCall(delayCall, 'delayCall');
          await futureCallManager.scheduleFutureCall(
            'delayCall',
            SimpleData(num: 4),
            DateTime.now().subtract(const Duration(seconds: 10)),
            '1',
            identifier + '-delay',
          );

          // Start executing the long running call
          await futureCallManager.runScheduledFutureCalls();

          // Give it a moment to start
          await Future.delayed(const Duration(milliseconds: 100));

          // Check that a claim exists
          final claimsBefore = await FutureCallClaimEntry.db.find(session);
          expect(claimsBefore, isNotEmpty);

          // Complete the call
          delayCall.completer.complete(SimpleData(num: 5));
          await Future.delayed(
            const Duration(seconds: 2),
          ); // Wait for heartbeat updates

          // Check that claim still exists and has updated heartbeat
          final claimsAfter = await FutureCallClaimEntry.db.find(session);
          expect(claimsAfter, hasLength(1));

          // Verify the heartbeat was updated (should be newer than original)
          final claim = claimsAfter.first;
          final originalHeartbeat = claimsBefore.first.heartbeat;
          expect(claim.heartbeat.isAfter(originalHeartbeat), isTrue);
        });
      });
    },
  );

  group('5. Given Serverpod instance is started', () {
    test(
      'when a new future call becomes due and the server shuts down before execution completes',
      () async {
        late Serverpod server;
        late Session session;
        late Session logSession;
        late FutureCallManager futureCallManager;
        var testCallName = 'testCall';
        var identifier = 'test-id';

        server = IntegrationTestServer.create();
        session = await server.createSession(enableLogging: false);
        logSession = await server.createSession();
        await LoggingUtil.clearAllLogs(session);

        futureCallManager = FutureCallManagerBuilder(
          sessionProvider: (String futureCallName) => session,
          internalSession: session,
          logSession: logSession,
        ).build();

        var testCall = _CounterFutureCall();
        futureCallManager.registerFutureCall(testCall, testCallName);

        // Schedule a future call that is due now
        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 4),
          DateTime.now().subtract(const Duration(seconds: 1)),
          '1',
          identifier,
        );

        // Start the server
        await server.start();

        // Give it a moment to process but then shut down quickly
        await Future.delayed(const Duration(milliseconds: 100));
        await server.shutdown(exitProcess: false);

        // Check that claim exists but future call was not executed
        final claims = await FutureCallClaimEntry.db.find(session);
        expect(claims, hasLength(1)); // Claim should exist
        expect(testCall.counter, equals(0)); // But call wasn't executed

        await session.close();
        await logSession.close();
      },
    );
  });

  group(
    '6. Given Serverpod instance is started with scheduled FutureCall that is due',
    () {
      test(
        'when the server shuts down before execution completes and is then restarted',
        () async {
          late Serverpod server;
          late Session session;
          late Session logSession;
          late FutureCallManager futureCallManager;
          var testCallName = 'testCall';
          var identifier = 'test-id';

          server = IntegrationTestServer.create();
          session = await server.createSession(enableLogging: false);
          logSession = await server.createSession();
          await LoggingUtil.clearAllLogs(session);

          futureCallManager = FutureCallManagerBuilder(
            sessionProvider: (String futureCallName) => session,
            internalSession: session,
            logSession: logSession,
          ).build();

          var testCall = _CounterFutureCall();
          futureCallManager.registerFutureCall(testCall, testCallName);

          // Schedule a future call that is due now
          await futureCallManager.scheduleFutureCall(
            testCallName,
            SimpleData(num: 4),
            DateTime.now().subtract(const Duration(seconds: 1)),
            '1',
            identifier,
          );

          // Start the server
          await server.start();

          // Give it a moment to process but then shut down quickly
          await Future.delayed(const Duration(milliseconds: 100));
          await server.shutdown(exitProcess: false);

          // Verify claim exists but call not executed
          final claimsAfterShutdown = await FutureCallClaimEntry.db.find(
            session,
          );
          expect(claimsAfterShutdown, hasLength(1));
          expect(testCall.counter, equals(0));

          // Now restart the server
          await server.start();

          // Give it time to process the call
          await Future.delayed(const Duration(seconds: 2));

          // Check that claim was deleted and call was executed
          final claimsAfterRestart = await FutureCallClaimEntry.db.find(
            session,
          );
          expect(claimsAfterRestart, isEmpty); // Claim should be cleaned up
          expect(testCall.counter, equals(1)); // Call should have been executed

          await session.close();
          await logSession.close();
          await server.shutdown(exitProcess: false);
        },
      );
    },
  );
}
