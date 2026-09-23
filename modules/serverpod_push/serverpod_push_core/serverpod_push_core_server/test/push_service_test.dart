import 'package:serverpod_push_core_server/serverpod_push_core_server.dart';
import 'package:test/test.dart';

import 'fakes/fake_push_provider.dart';

void main() {
  tearDown(PushService.reset);

  test(
    'when set with two builders then providers are registered by id.',
    () {
      final fcm = FakePushProvider(provider: 'fcm');
      final apns = FakePushProvider(provider: 'apns');
      PushService.set(
        providers: [
          PreBuiltPushProviderBuilder(fcm),
          PreBuiltPushProviderBuilder(apns),
        ],
      );

      expect(PushService.instance.providerByIdOrThrow('fcm'), same(fcm));
      expect(PushService.instance.providerByIdOrThrow('apns'), same(apns));
      expect(
        () => PushService.instance.providerByIdOrThrow('webpush'),
        throwsA(isA<PushUnknownProviderException>()),
      );
    },
  );

  test(
    'when two builders share a provider id then set throws.',
    () {
      expect(
        () => PushService.set(
          providers: [
            PreBuiltPushProviderBuilder(FakePushProvider()),
            PreBuiltPushProviderBuilder(FakePushProvider()),
          ],
        ),
        throwsA(isA<StateError>()),
      );
    },
  );

  test(
    'when a fake Web Push provider extracts the endpoint then identity is stable '
    'across key rotation.',
    () {
      final provider = FakePushProvider(
        provider: 'webpush',
        identityTransform: (final credential) {
          // credential is JSON: {"endpoint":"...","keys":{...}}
          final start = credential.indexOf('"endpoint":"') + 12;
          final end = credential.indexOf('"', start);
          return credential.substring(start, end);
        },
      );

      const endpoint = 'https://push.example/abc';
      const first = '{"endpoint":"$endpoint","keys":{"p256dh":"aaa","auth":"bbb"}}';
      const rotated =
          '{"endpoint":"$endpoint","keys":{"p256dh":"ccc","auth":"ddd"}}';

      expect(provider.identityKeyFor(first), endpoint);
      expect(provider.identityKeyFor(rotated), endpoint);
    },
  );

  test(
    'when send is called then results are returned in request order.',
    () async {
      final provider = FakePushProvider();
      final message = PushMessage(
        data: const {'k': 'v'},
        priority: PushPriority.normal,
      );
      final requests = [
        PushSendRequest(
          target: PushDeviceTarget(
            provider: 'fake',
            credential: 'a',
            platform: PushPlatform.android,
          ),
          dataOverlay: const {pushDeliveryIdDataKey: '1'},
          expiresAt: DateTime.utc(2099),
        ),
        PushSendRequest(
          target: PushDeviceTarget(
            provider: 'fake',
            credential: 'b',
            platform: PushPlatform.ios,
          ),
          dataOverlay: const {pushDeliveryIdDataKey: '2'},
          expiresAt: DateTime.utc(2099),
        ),
      ];

      final results = await provider.send(
        message: message,
        requests: requests,
      );

      expect(results, hasLength(2));
      expect(results[0].target.credential, 'a');
      expect(results[1].target.credential, 'b');
      expect(results[0].outcome, PushDeliveryOutcome.accepted);
    },
  );
}
