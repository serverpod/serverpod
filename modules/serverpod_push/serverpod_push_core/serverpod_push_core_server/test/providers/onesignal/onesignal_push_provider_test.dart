import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod_push_core_server/serverpod_push_core_server.dart';
import 'package:test/test.dart';

void main() {
  PushMessage message() => PushMessage(
    title: 'Hello',
    body: 'World',
    data: const {'k': 'v'},
    priority: PushPriority.normal,
  );

  PushSendRequest request({
    final DateTime? expiresAt,
    final String subscriptionId = 'sub-123',
  }) => PushSendRequest(
    target: PushDeviceTarget(
      provider: 'onesignal',
      credential: subscriptionId,
      platform: PushPlatform.android,
    ),
    dataOverlay: const {pushDeliveryIdDataKey: 'delivery-1'},
    expiresAt: expiresAt ?? DateTime.utc(2099, 1, 1),
  );

  test('identityKeyFor returns the credential unchanged.', () {
    final provider = OneSignalPushProvider(
      appId: 'app-id',
      restApiKey: 'rest-key',
      httpClient: MockClient((final _) async => http.Response('', 500)),
    );
    expect(provider.identityKeyFor('abc'), 'abc');
  });

  test('when credentials are empty then construction throws.', () {
    expect(
      () => OneSignalPushProvider(appId: '', restApiKey: 'key'),
      throwsA(isA<PushMissingCredentialsException>()),
    );
  });

  test(
    'when expiresAt is in the past then send returns expired without HTTP.',
    () async {
      var httpCalls = 0;
      final provider = OneSignalPushProvider(
        appId: 'app-id',
        restApiKey: 'rest-key',
        httpClient: MockClient((final _) async {
          httpCalls += 1;
          return http.Response('', 500);
        }),
      );

      final results = await provider.send(
        message: message(),
        requests: [request(expiresAt: DateTime.utc(2000))],
      );

      expect(results.single.outcome, PushDeliveryOutcome.expired);
      expect(httpCalls, 0);
    },
  );

  test(
    'when OneSignal returns 200 with id then the outcome is accepted.',
    () async {
      final provider = OneSignalPushProvider(
        appId: 'app-id',
        restApiKey: 'rest-key',
        httpClient: _oneSignalClient(
          body: jsonEncode({'id': 'notif-1'}),
          status: 200,
        ),
      );

      final results = await provider.send(
        message: message(),
        requests: [request()],
      );

      expect(results.single.outcome, PushDeliveryOutcome.accepted);
      expect(results.single.providerMessageId, 'notif-1');
    },
  );

  test(
    'when OneSignal returns invalid_player_ids then the outcome is invalidToken.',
    () async {
      final provider = OneSignalPushProvider(
        appId: 'app-id',
        restApiKey: 'rest-key',
        httpClient: _oneSignalClient(
          body: jsonEncode({
            'id': 'notif-1',
            'errors': {
              'invalid_player_ids': ['sub-123'],
            },
          }),
          status: 200,
        ),
      );

      final results = await provider.send(
        message: message(),
        requests: [request()],
      );

      expect(results.single.outcome, PushDeliveryOutcome.invalidToken);
    },
  );

  test(
    'when OneSignal returns empty id then the outcome is invalidToken.',
    () async {
      final provider = OneSignalPushProvider(
        appId: 'app-id',
        restApiKey: 'rest-key',
        httpClient: _oneSignalClient(
          body: jsonEncode({
            'id': '',
            'errors': ['All included players are not subscribed'],
          }),
          status: 200,
        ),
      );

      final results = await provider.send(
        message: message(),
        requests: [request()],
      );

      expect(results.single.outcome, PushDeliveryOutcome.invalidToken);
    },
  );

  test(
    'when OneSignal returns 429 then the outcome is rateLimited and retryAfter is parsed.',
    () async {
      final provider = OneSignalPushProvider(
        appId: 'app-id',
        restApiKey: 'rest-key',
        httpClient: _oneSignalClient(
          body: jsonEncode({
            'errors': ['API rate limit exceeded'],
          }),
          status: 429,
          headers: {'retry-after': '30'},
        ),
      );

      final results = await provider.send(
        message: message(),
        requests: [request()],
      );

      expect(results.single.outcome, PushDeliveryOutcome.rateLimited);
      expect(results.single.retryAfter, const Duration(seconds: 30));
    },
  );

  test('when OneSignal returns 401 then the outcome is retryable.', () async {
    final provider = OneSignalPushProvider(
      appId: 'app-id',
      restApiKey: 'rest-key',
      httpClient: _oneSignalClient(
        body: jsonEncode({
          'errors': ['Invalid credentials'],
        }),
        status: 401,
      ),
    );

    final results = await provider.send(
      message: message(),
      requests: [request()],
    );

    expect(results.single.outcome, PushDeliveryOutcome.retryable);
    expect(results.single.errorCode, 'UNAUTHENTICATED');
  });

  test(
    'when OneSignal returns 400 then the outcome is permanentFailure.',
    () async {
      final provider = OneSignalPushProvider(
        appId: 'app-id',
        restApiKey: 'rest-key',
        httpClient: _oneSignalClient(
          body: jsonEncode({
            'errors': ['Missing contents'],
          }),
          status: 400,
        ),
      );

      final results = await provider.send(
        message: message(),
        requests: [request()],
      );

      expect(results.single.outcome, PushDeliveryOutcome.permanentFailure);
    },
  );

  test('send posts the expected OneSignal payload.', () async {
    http.Request? captured;
    final provider = OneSignalPushProvider(
      appId: 'app-id',
      restApiKey: 'rest-key',
      httpClient: MockClient((final request) async {
        captured = request;
        return http.Response(jsonEncode({'id': 'notif-1'}), 200);
      }),
    );

    await provider.send(message: message(), requests: [request()]);

    expect(captured, isNotNull);
    expect(captured!.url.host, 'api.onesignal.com');
    expect(captured!.headers['authorization'], 'Key rest-key');
    final body = jsonDecode(captured!.body) as Map<String, dynamic>;
    expect(body['app_id'], 'app-id');
    expect(body['include_subscription_ids'], ['sub-123']);
    expect(body['headings'], {'en': 'Hello'});
    expect(body['contents'], {'en': 'World'});
    expect(body['data'], {
      'k': 'v',
      pushDeliveryIdDataKey: 'delivery-1',
    });
    expect(body['ttl'], isA<int>());
    expect(body['priority'], 5);
  });

  test('payloadBytesFor measures the data envelope.', () {
    final provider = OneSignalPushProvider(
      appId: 'app-id',
      restApiKey: 'rest-key',
      httpClient: MockClient((final _) async => http.Response('', 500)),
    );
    final bytes = provider.payloadBytesFor(
      PushMessage(
        data: const {'hello': 'world'},
        priority: PushPriority.normal,
      ),
      const {pushDeliveryIdDataKey: '00000000-0000-0000-0000-000000000000'},
    );
    expect(bytes, greaterThan(0));
    expect(bytes, lessThan(provider.maxPayloadBytes));
  });
}

MockClient _oneSignalClient({
  required final String body,
  required final int status,
  final Map<String, String> headers = const {},
}) {
  return MockClient((final request) async {
    expect(request.url.path, '/notifications');
    expect(request.headers['authorization'], startsWith('Key '));
    return http.Response(body, status, headers: headers);
  });
}
