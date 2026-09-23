import 'package:serverpod/serverpod.dart';
import 'package:serverpod_push_core_server/serverpod_push_core_server.dart';
import 'package:serverpod_push_store_server/serverpod_push_store_server.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the push store', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late FakeStoreProvider provider;

    setUp(() async {
      session = sessionBuilder.build();
      provider = FakeStoreProvider();
      PushService.set(
        providers: [PreBuiltPushProviderBuilder(provider)],
      );
      PushStore.set(config: const PushStoreConfig());
    });

    tearDown(() {
      PushService.reset();
      PushStore.reset();
    });

    test(
      'when enqueueing with notBefore after expiresAt then it throws.',
      () async {
        expect(
          () => PushNotifications.sendToUsers(
            session,
            message: PushMessage(
              data: const {},
              priority: PushPriority.normal,
              timeToLive: const Duration(seconds: 1),
            ),
            userIdentifiers: const ['user-1'],
            notBefore: DateTime.now().toUtc().add(const Duration(hours: 1)),
          ),
          throwsA(isA<PushInvalidScheduleException>()),
        );
      },
    );

    test(
      'when registerDevice is called twice without auth then userIdentifier stays null '
      'and omitted fields are not cleared.',
      () async {
        await endpoints.pushDevice.registerDevice(
          sessionBuilder,
          provider: 'fake',
          credential: 'token-1',
          platform: PushPlatform.android,
          installationId: 'install-1',
          locale: 'en',
          appVersion: '1.0.0',
        );

        await endpoints.pushDevice.registerDevice(
          sessionBuilder,
          provider: 'fake',
          credential: 'token-2',
          platform: PushPlatform.android,
          installationId: 'install-1',
        );

        final devices = await PushDevice.db.find(session);
        expect(devices, hasLength(1));
        expect(devices.single.credential, 'token-2');
        expect(devices.single.locale, 'en');
        expect(devices.single.appVersion, '1.0.0');
        expect(devices.single.userIdentifier, isNull);
      },
    );

    test(
      'when an owned device is re-registered from an unauthenticated session '
      'then userIdentifier is preserved.',
      () async {
        final authed = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            'user-42',
            <Scope>{},
          ),
        );
        await endpoints.pushDevice.registerDevice(
          authed,
          provider: 'fake',
          credential: 'token-1',
          platform: PushPlatform.android,
          installationId: 'install-owned',
        );

        await endpoints.pushDevice.registerDevice(
          sessionBuilder,
          provider: 'fake',
          credential: 'token-1-refreshed',
          platform: PushPlatform.android,
          installationId: 'install-owned',
        );

        final device = (await PushDevice.db.find(session)).single;
        expect(device.userIdentifier, 'user-42');
        expect(device.credential, 'token-1-refreshed');
        expect(device.createdAt, isNotNull);
      },
    );

    test(
      'when a token moves to a new installationId then exactly one live row remains.',
      () async {
        await endpoints.pushDevice.registerDevice(
          sessionBuilder,
          provider: 'fake',
          credential: 'same-token',
          platform: PushPlatform.android,
          installationId: 'old-install',
        );
        await endpoints.pushDevice.registerDevice(
          sessionBuilder,
          provider: 'fake',
          credential: 'same-token',
          platform: PushPlatform.android,
          installationId: 'new-install',
        );

        final live = await PushDevice.db.find(
          session,
          where: (final t) => t.disabledAt.equals(null),
        );
        expect(live, hasLength(1));
        expect(live.single.installationId, 'new-install');

        final all = await PushDevice.db.find(session);
        expect(all, hasLength(2));
        expect(
          all.where((final d) => d.disabledReason == 'superseded'),
          hasLength(1),
        );
      },
    );

    test(
      'when sendToUsers is called with an empty audience then no notification is written.',
      () async {
        final result = await PushNotifications.sendToUsers(
          session,
          message: PushMessage(
            data: const {},
            priority: PushPriority.normal,
          ),
          userIdentifiers: const ['nobody'],
        );
        expect(result.notificationId, isNull);
        expect(result.deliveriesCreated, 0);
        expect(await PushNotification.db.find(session), isEmpty);
      },
    );

    test(
      'when sendToUsers is called for a registered user then deliveries are created.',
      () async {
        final authed = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            'user-7',
            <Scope>{},
          ),
        );
        await endpoints.pushDevice.registerDevice(
          authed,
          provider: 'fake',
          credential: 'tok',
          platform: PushPlatform.android,
        );

        final result = await PushNotifications.sendToUsers(
          session,
          message: PushMessage(
            title: 'Hi',
            data: const {},
            priority: PushPriority.high,
          ),
          userIdentifiers: const ['user-7'],
        );

        expect(result.deduped, isFalse);
        expect(result.deliveriesCreated, 1);
        expect(result.notificationId, isNotNull);
      },
    );

    test(
      'when the same dedupeKey is reused then enqueue reports deduped and creates '
      'no extra deliveries.',
      () async {
        final authed = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            'user-8',
            <Scope>{},
          ),
        );
        await endpoints.pushDevice.registerDevice(
          authed,
          provider: 'fake',
          credential: 'tok-8',
          platform: PushPlatform.android,
        );

        final first = await PushNotifications.sendToUsers(
          session,
          message: PushMessage(
            data: const {},
            priority: PushPriority.normal,
          ),
          userIdentifiers: const ['user-8'],
          dedupeKey: 'order-42-shipped',
        );
        final second = await PushNotifications.sendToUsers(
          session,
          message: PushMessage(
            body: 'different body',
            data: const {},
            priority: PushPriority.normal,
          ),
          userIdentifiers: const ['user-8'],
          dedupeKey: 'order-42-shipped',
        );

        expect(first.deduped, isFalse);
        expect(first.deliveriesCreated, 1);
        expect(second.deduped, isTrue);
        expect(second.notificationId, first.notificationId);
        expect(second.deliveriesCreated, 0);
      },
    );
    test(
      'when acknowledge is called for an anonymous device without login then '
      'receivedAt is recorded.',
      () async {
        await endpoints.pushDevice.registerDevice(
          sessionBuilder,
          provider: 'fake',
          credential: 'anon-ack',
          platform: PushPlatform.android,
        );
        final device = (await PushDevice.db.find(session)).single;
        await PushNotifications.sendToDevices(
          session,
          message: PushMessage(
            data: const {},
            priority: PushPriority.normal,
          ),
          deviceIds: [device.id!],
        );
        final delivery = (await PushDelivery.db.find(session)).single;

        await endpoints.pushDevice.acknowledge(
          sessionBuilder,
          deliveryId: delivery.id!,
          type: PushAckType.received,
        );

        final updated = await PushDelivery.db.findById(session, delivery.id!);
        expect(updated!.receivedAt, isNotNull);
      },
    );

    test(
      'when acknowledge is called for an owned device without login then it '
      'fails with anonymousDevice.',
      () async {
        final authed = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            'user-ack',
            <Scope>{},
          ),
        );
        await endpoints.pushDevice.registerDevice(
          authed,
          provider: 'fake',
          credential: 'owned-ack',
          platform: PushPlatform.android,
        );
        final device = (await PushDevice.db.find(session)).single;
        await PushNotifications.sendToDevices(
          session,
          message: PushMessage(
            data: const {},
            priority: PushPriority.normal,
          ),
          deviceIds: [device.id!],
        );
        final delivery = (await PushDelivery.db.find(session)).single;

        await expectLater(
          () => endpoints.pushDevice.acknowledge(
            sessionBuilder,
            deliveryId: delivery.id!,
            type: PushAckType.received,
          ),
          throwsA(
            isA<PushAcknowledgeException>().having(
              (final e) => e.reason,
              'reason',
              PushAcknowledgeFailureReason.anonymousDevice,
            ),
          ),
        );
      },
    );

    test(
      'when acknowledge is called by a different user then it fails with notOwned.',
      () async {
        final owner = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            'owner-ack',
            <Scope>{},
          ),
        );
        await endpoints.pushDevice.registerDevice(
          owner,
          provider: 'fake',
          credential: 'other-ack',
          platform: PushPlatform.android,
        );
        final device = (await PushDevice.db.find(session)).single;
        await PushNotifications.sendToDevices(
          session,
          message: PushMessage(
            data: const {},
            priority: PushPriority.normal,
          ),
          deviceIds: [device.id!],
        );
        final delivery = (await PushDelivery.db.find(session)).single;

        final other = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            'other-user',
            <Scope>{},
          ),
        );
        await expectLater(
          () => endpoints.pushDevice.acknowledge(
            other,
            deliveryId: delivery.id!,
            type: PushAckType.received,
          ),
          throwsA(
            isA<PushAcknowledgeException>().having(
              (final e) => e.reason,
              'reason',
              PushAcknowledgeFailureReason.notOwned,
            ),
          ),
        );
      },
    );

    test(
      'when a Web Push subscription is re-registered with rotated keys but the '
      'same endpoint then the row is updated in place.',
      () async {
        PushService.reset();
        PushService.set(
          providers: [
            PreBuiltPushProviderBuilder(
              FakeStoreProvider(
                providerId: 'webpush',
                identityTransform: (final credential) {
                  final start = credential.indexOf('"endpoint":"') + 12;
                  final end = credential.indexOf('"', start);
                  return credential.substring(start, end);
                },
              ),
            ),
          ],
        );

        const endpoint = 'https://push.example/abc';
        await endpoints.pushDevice.registerDevice(
          sessionBuilder,
          provider: 'webpush',
          credential:
              '{"endpoint":"$endpoint","keys":{"p256dh":"aaa","auth":"bbb"}}',
          platform: PushPlatform.web,
        );
        await endpoints.pushDevice.registerDevice(
          sessionBuilder,
          provider: 'webpush',
          credential:
              '{"endpoint":"$endpoint","keys":{"p256dh":"ccc","auth":"ddd"}}',
          platform: PushPlatform.web,
        );

        final devices = await PushDevice.db.find(
          session,
          where: (final t) => t.provider.equals('webpush'),
        );
        expect(devices, hasLength(1));
        expect(devices.single.credential, contains('"p256dh":"ccc"'));
      },
    );
  });
}

class FakeStoreProvider implements PushProvider {
  FakeStoreProvider({
    this.providerId = 'fake',
    this.identityTransform,
  });

  final String providerId;
  final String Function(String credential)? identityTransform;

  @override
  String get provider => providerId;

  @override
  Set<PushPlatform> get supportedPlatforms => PushPlatform.values.toSet();

  @override
  int get maxTargetsPerRequest => 10;

  @override
  int get maxConcurrentRequests => 5;

  @override
  Duration get sendTimeout => const Duration(seconds: 5);

  @override
  int get maxPayloadBytes => 4096;

  @override
  Duration get maxTimeToLive => const Duration(days: 28);

  @override
  String identityKeyFor(final String credential) =>
      identityTransform?.call(credential) ?? credential;

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
    return [
      for (final request in requests)
        PushSendResult(
          target: request.target,
          outcome: PushDeliveryOutcome.accepted,
        ),
    ];
  }

  @override
  Future<void> close() async {}
}
