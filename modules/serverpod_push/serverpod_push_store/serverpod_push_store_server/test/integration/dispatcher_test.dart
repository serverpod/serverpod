import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_push_core_server/serverpod_push_core_server.dart';
import 'package:serverpod_push_store_server/serverpod_push_store_server.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given the push dispatcher',
    (
      final sessionBuilder,
      final endpoints,
    ) {
      late Session session;
      late _ScriptedProvider provider;
      late PushStoreConfig config;
      late PushDispatcher dispatcher;
      late Completer<void> hang;
      final extraDispatchers = <PushDispatcher>[];

      setUp(() async {
        session = sessionBuilder.build();
        hang = Completer<void>();
        provider = _ScriptedProvider();
        config = const PushStoreConfig(
          scanInterval: Duration(milliseconds: 50),
          batchesInFlight: 1,
          maxAttempts: 5,
          maxClaims: 15,
          maxDeliveryAge: Duration(days: 2),
          baseBackoff: Duration(milliseconds: 10),
          maxBackoff: Duration(seconds: 1),
          backoffJitter: 0,
          claimTimeout: Duration(seconds: 1),
          retentionPeriod: Duration(minutes: 1),
          defaultDedupeWindow: Duration(minutes: 1),
        );
        PushService.reset();
        PushService.set(
          providers: [PreBuiltPushProviderBuilder(provider)],
        );
        PushStore.set(config: config);
        dispatcher = PushDispatcher(
          serverpod: session.serverpod,
          config: config,
        );
      });

      tearDown(() async {
        if (!hang.isCompleted) hang.complete();
        await dispatcher.stopAndReleaseClaims();
        for (final extra in extraDispatchers) {
          await extra.stopAndReleaseClaims();
        }
        extraDispatchers.clear();
        await _wipe(session);
        PushService.reset();
        PushStore.reset();
      });

      Future<PushDevice> registerUser({
        required final String user,
        required final String credential,
      }) async {
        final authed = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            user,
            <Scope>{},
          ),
        );
        await endpoints.pushDevice.registerDevice(
          authed,
          provider: 'fake',
          credential: credential,
          platform: PushPlatform.android,
        );
        return (await PushDevice.db.find(
          session,
          where: (final t) => t.credential.equals(credential),
        )).single;
      }

      Future<PushEnqueueResult> enqueue({
        required final String user,
        final Duration? timeToLive,
        final String? dedupeKey,
      }) {
        return PushNotifications.sendToUsers(
          session,
          message: PushMessage(
            title: 'Hi',
            data: const {},
            priority: PushPriority.normal,
            timeToLive: timeToLive,
          ),
          userIdentifiers: [user],
          dedupeKey: dedupeKey,
        );
      }

      test(
        'when two dispatchers claim concurrently then they take disjoint rows.',
        () async {
          await registerUser(user: 'u-a', credential: 'tok-a');
          await registerUser(user: 'u-b', credential: 'tok-b');
          await enqueue(user: 'u-a');
          await enqueue(user: 'u-b');

          provider.hang = hang;
          final other = PushDispatcher(
            serverpod: session.serverpod,
            config: config,
          );
          extraDispatchers.add(other);

          unawaited(dispatcher.runCycleForTest());
          unawaited(other.runCycleForTest());

          final sending = await _waitUntil(
            () => PushDelivery.db.find(
              session,
              where: (final t) => t.status.equals(PushDeliveryStatus.sending),
            ),
            (final rows) => rows.length >= 2,
          );

          expect(sending.map((final d) => d.claimedBy).toSet(), hasLength(2));
          hang.complete();
        },
      );

      test(
        'when a send times out then attempts is unchanged and claimCount grows, '
        'and the reaper abandons after maxClaims.',
        () async {
          await registerUser(user: 'u-crash', credential: 'tok-crash');
          await enqueue(user: 'u-crash');
          final crashConfig = PushStoreConfig(
            scanInterval: config.scanInterval,
            batchesInFlight: config.batchesInFlight,
            maxAttempts: config.maxAttempts,
            maxClaims: 2,
            maxDeliveryAge: config.maxDeliveryAge,
            baseBackoff: config.baseBackoff,
            maxBackoff: config.maxBackoff,
            backoffJitter: config.backoffJitter,
            claimTimeout: config.claimTimeout,
            retentionPeriod: config.retentionPeriod,
            defaultDedupeWindow: config.defaultDedupeWindow,
          );
          await dispatcher.stopAndReleaseClaims();
          dispatcher = PushDispatcher(
            serverpod: session.serverpod,
            config: crashConfig,
          );
          provider.hang = hang;
          provider.sendTimeout = const Duration(milliseconds: 80);

          await dispatcher.runCycleForTest();
          var row = (await PushDelivery.db.find(session)).single;
          expect(row.status, PushDeliveryStatus.sending);
          expect(row.attempts, 0);
          expect(row.claimCount, 1);

          await PushDelivery.db.updateWhere(
            session,
            columnValues: (final t) => [
              t.claimedAt(
                DateTime.now().toUtc().subtract(
                  const Duration(seconds: 5),
                ),
              ),
            ],
            where: (final t) => t.id.equals(row.id),
          );
          // Reap then immediately re-claim in the same cycle.
          await dispatcher.runCycleForTest(forceMaintenance: true);
          row = (await PushDelivery.db.find(session)).single;
          expect(row.attempts, 0);
          expect(row.claimCount, 2);
          expect(row.status, PushDeliveryStatus.sending);

          await PushDelivery.db.updateWhere(
            session,
            columnValues: (final t) => [
              t.claimedAt(
                DateTime.now().toUtc().subtract(
                  const Duration(seconds: 5),
                ),
              ),
            ],
            where: (final t) => t.id.equals(row.id),
          );
          await dispatcher.runCycleForTest(forceMaintenance: true);
          row = (await PushDelivery.db.find(session)).single;
          expect(row.status, PushDeliveryStatus.abandoned);
          expect(row.attempts, 0);
          expect(row.claimCount, 2);
        },
      );

      test(
        'when the provider returns rateLimited then backoffExponent grows and '
        'attempts does not.',
        () async {
          await registerUser(user: 'u-rl', credential: 'tok-rl');
          await enqueue(user: 'u-rl');
          provider.outcome = PushDeliveryOutcome.rateLimited;

          await dispatcher.runCycleForTest();
          var row = (await PushDelivery.db.find(session)).single;
          expect(row.status, PushDeliveryStatus.failed);
          expect(row.attempts, 0);
          expect(row.backoffExponent, 1);
          final firstDelay = row.nextAttemptAt.difference(row.lastAttemptAt!);

          await PushDelivery.db.updateWhere(
            session,
            columnValues: (final t) => [
              t.nextAttemptAt(DateTime.utc(2020)),
            ],
            where: (final t) => t.id.equals(row.id),
          );
          await dispatcher.runCycleForTest();
          row = (await PushDelivery.db.find(session)).single;
          expect(row.attempts, 0);
          expect(row.backoffExponent, 2);
          expect(row.status, PushDeliveryStatus.failed);
          final secondDelay = row.nextAttemptAt.difference(row.lastAttemptAt!);
          expect(secondDelay, greaterThan(firstDelay));
        },
      );

      test(
        'when expiresAt passes while pending then the sweep marks expired and '
        'retention deletes the row.',
        () async {
          await registerUser(user: 'u-exp', credential: 'tok-exp');
          await enqueue(
            user: 'u-exp',
            timeToLive: const Duration(hours: 1),
            dedupeKey: 'order-expired',
          );
          var row = (await PushDelivery.db.find(session)).single;
          expect(row.status, PushDeliveryStatus.pending);

          final past = DateTime.now().toUtc().subtract(
            const Duration(minutes: 5),
          );
          await PushDelivery.db.updateWhere(
            session,
            columnValues: (final t) => [
              t.expiresAt(past),
            ],
            where: (final t) => t.id.equals(row.id),
          );

          await dispatcher.runCycleForTest(forceMaintenance: true);
          row = (await PushDelivery.db.find(session)).single;
          expect(row.status, PushDeliveryStatus.expired);

          await PushDelivery.db.updateWhere(
            session,
            columnValues: (final t) => [
              t.createdAt(past),
            ],
            where: (final t) => t.id.equals(row.id),
          );
          await PushNotification.db.updateWhere(
            session,
            columnValues: (final t) => [
              t.createdAt(past),
              t.dedupeExpiresAt(past),
            ],
            where: (final t) => t.id.equals(row.notificationId),
          );

          await dispatcher.runCycleForTest(forceMaintenance: true);
          expect(await PushDelivery.db.find(session), isEmpty);
          expect(await PushNotification.db.find(session), isEmpty);

          final again = await enqueue(
            user: 'u-exp',
            dedupeKey: 'order-expired',
          );
          expect(again.deduped, isFalse);
          expect(again.deliveriesCreated, 1);
        },
      );

      test(
        'when invalidToken is returned then the device is disabled and sibling '
        'deliveries are discarded.',
        () async {
          await registerUser(user: 'u-inv', credential: 'tok-inv');
          await enqueue(user: 'u-inv', dedupeKey: 'n-1');
          await enqueue(user: 'u-inv', dedupeKey: 'n-2');
          expect(await PushDelivery.db.find(session), hasLength(2));

          provider.outcome = PushDeliveryOutcome.invalidToken;
          provider.maxTargetsPerRequest = 1;
          await dispatcher.runCycleForTest();

          final deliveries = await PushDelivery.db.find(session);
          expect(
            deliveries.every(
              (final d) => d.status == PushDeliveryStatus.discarded,
            ),
            isTrue,
          );
          final device = (await PushDevice.db.find(session)).single;
          expect(device.disabledAt, isNotNull);
          expect(device.disabledReason, 'invalidToken');
        },
      );

      test(
        'when acknowledge lands during send then completion does not clear it.',
        () async {
          final device = await registerUser(
            user: 'u-ack',
            credential: 'tok-ack',
          );
          await enqueue(user: 'u-ack');
          provider.hang = hang;

          unawaited(dispatcher.runCycleForTest());
          final sending = await _waitUntil(
            () => PushDelivery.db.find(
              session,
              where: (final t) => t.status.equals(PushDeliveryStatus.sending),
            ),
            (final rows) => rows.length == 1,
          );
          final deliveryId = sending.single.id!;

          await endpoints.pushDevice.acknowledge(
            sessionBuilder.copyWith(
              authentication: AuthenticationOverride.authenticationInfo(
                'u-ack',
                <Scope>{},
              ),
            ),
            deliveryId: deliveryId,
            type: PushAckType.received,
          );

          hang.complete();
          await _waitUntil(
            () => PushDelivery.db.findById(session, deliveryId),
            (final row) => row?.status == PushDeliveryStatus.accepted,
          );

          final row = await PushDelivery.db.findById(session, deliveryId);
          expect(row!.receivedAt, isNotNull);
          expect(row.status, PushDeliveryStatus.accepted);
          expect(device.id, isNotNull);
        },
      );

      test(
        'when shutdown runs after a send timeout then claims are released and '
        'a new dispatcher picks them up immediately.',
        () async {
          await registerUser(user: 'u-stop', credential: 'tok-stop');
          await enqueue(user: 'u-stop');
          provider.hang = hang;
          provider.sendTimeout = const Duration(milliseconds: 80);

          await dispatcher.runCycleForTest();
          expect(
            (await PushDelivery.db.find(session)).single.status,
            PushDeliveryStatus.sending,
          );

          await dispatcher.stopAndReleaseClaims();
          expect(
            (await PushDelivery.db.find(session)).single.status,
            PushDeliveryStatus.pending,
          );

          hang = Completer<void>();
          provider.hang = null;
          provider.outcome = PushDeliveryOutcome.accepted;
          final restarted = PushDispatcher(
            serverpod: session.serverpod,
            config: config,
          );
          extraDispatchers.add(restarted);
          await restarted.runCycleForTest();
          expect(
            (await PushDelivery.db.find(session)).single.status,
            PushDeliveryStatus.accepted,
          );
        },
      );

      test(
        'when a cycle outlives scanInterval then a second cycle does not overlap.',
        () async {
          await registerUser(user: 'u-ol', credential: 'tok-ol');
          await enqueue(user: 'u-ol');
          provider.hang = hang;
          provider.sendTimeout = const Duration(seconds: 5);

          await dispatcher.start();
          await _waitUntil(
            () => Future.value(provider.sendCalls),
            (final calls) => calls >= 1,
          );
          await Future<void>.delayed(const Duration(milliseconds: 200));
          expect(provider.sendCalls, 1);
          hang.complete();
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}

Future<void> _wipe(final Session session) async {
  final cutoff = DateTime.utc(2100);
  await PushDelivery.db.deleteWhere(
    session,
    where: (final t) => t.createdAt < cutoff,
    noReturn: true,
  );
  await PushNotification.db.deleteWhere(
    session,
    where: (final t) => t.createdAt < cutoff,
    noReturn: true,
  );
  await PushDevice.db.deleteWhere(
    session,
    where: (final t) => t.createdAt < cutoff,
    noReturn: true,
  );
}

Future<T> _waitUntil<T>(
  final Future<T> Function() read,
  final bool Function(T value) ok, {
  final Duration timeout = const Duration(seconds: 5),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (true) {
    final value = await read();
    if (ok(value)) return value;
    if (DateTime.now().isAfter(deadline)) {
      fail('Timed out waiting for dispatcher condition.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

class _ScriptedProvider implements PushProvider {
  @override
  Duration sendTimeout = const Duration(seconds: 5);

  @override
  int maxTargetsPerRequest = 10;
  PushDeliveryOutcome outcome = PushDeliveryOutcome.accepted;
  Completer<void>? hang;
  var sendCalls = 0;

  @override
  String get provider => 'fake';

  @override
  Set<PushPlatform> get supportedPlatforms => PushPlatform.values.toSet();

  @override
  int get maxConcurrentRequests => 1;

  @override
  int get maxPayloadBytes => 4096;

  @override
  Duration get maxTimeToLive => const Duration(days: 28);

  @override
  String identityKeyFor(final String credential) => credential;

  @override
  int payloadBytesFor(
    final PushMessage message,
    final Map<String, String> additionalData,
  ) => 1;

  @override
  Future<List<PushSendResult>> send({
    required final PushMessage message,
    required final List<PushSendRequest> requests,
  }) async {
    sendCalls += 1;
    final gate = hang;
    if (gate != null) {
      await gate.future;
    }
    return [
      for (final request in requests)
        PushSendResult(target: request.target, outcome: outcome),
    ];
  }

  @override
  Future<void> close() async {}
}
