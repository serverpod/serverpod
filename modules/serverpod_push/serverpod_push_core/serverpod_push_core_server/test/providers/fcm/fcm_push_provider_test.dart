import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod_push_core_server/serverpod_push_core_server.dart';
import 'package:test/test.dart';

void main() {
  const credentials = FirebaseServiceAccountCredentials(
    projectId: 'test-project',
    clientEmail: 'sa@test-project.iam.gserviceaccount.com',
    privateKey: _testPrivateKey,
  );

  PushMessage message() => PushMessage(
    title: 'Hello',
    body: 'World',
    data: const {'k': 'v'},
    priority: PushPriority.normal,
  );

  PushSendRequest request({
    final DateTime? expiresAt,
    final String token = 'device-token',
  }) => PushSendRequest(
    target: PushDeviceTarget(
      provider: 'fcm',
      credential: token,
      platform: PushPlatform.android,
    ),
    dataOverlay: const {pushDeliveryIdDataKey: 'delivery-1'},
    expiresAt: expiresAt ?? DateTime.utc(2099, 1, 1),
  );

  test('identityKeyFor returns the credential unchanged.', () {
    final provider = FcmPushProvider(
      credentials: credentials,
      httpClient: MockClient((final _) async => http.Response('', 500)),
    );
    expect(provider.identityKeyFor('abc'), 'abc');
  });

  test(
    'when expiresAt is in the past then send returns expired without HTTP.',
    () async {
      var httpCalls = 0;
      final provider = FcmPushProvider(
        credentials: credentials,
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

  test('when FCM returns 200 then the outcome is accepted.', () async {
    final provider = FcmPushProvider(
      credentials: credentials,
      httpClient: _fcmClient(
        sendBody: jsonEncode({'name': 'projects/test-project/messages/1'}),
        sendStatus: 200,
      ),
    );

    final results = await provider.send(
      message: message(),
      requests: [request()],
    );

    expect(results.single.outcome, PushDeliveryOutcome.accepted);
    expect(
      results.single.providerMessageId,
      'projects/test-project/messages/1',
    );
  });

  test(
    'when FCM returns UNREGISTERED then the outcome is invalidToken.',
    () async {
      final provider = FcmPushProvider(
        credentials: credentials,
        httpClient: _fcmClient(
          sendBody: jsonEncode({
            'error': {
              'code': 404,
              'status': 'NOT_FOUND',
              'details': [
                {'errorCode': 'UNREGISTERED'},
              ],
            },
          }),
          sendStatus: 404,
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
    'when FCM returns 429 then the outcome is rateLimited and retryAfter is parsed.',
    () async {
      final provider = FcmPushProvider(
        credentials: credentials,
        httpClient: _fcmClient(
          sendBody: jsonEncode({
            'error': {
              'code': 429,
              'status': 'RESOURCE_EXHAUSTED',
              'details': [
                {'errorCode': 'QUOTA_EXCEEDED'},
              ],
            },
          }),
          sendStatus: 429,
          sendHeaders: {'retry-after': '30'},
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

  test(
    'when FCM returns 401 then the outcome is retryable with UNAUTHENTICATED.',
    () async {
      final provider = FcmPushProvider(
        credentials: credentials,
        httpClient: _fcmClient(
          sendBody: jsonEncode({
            'error': {
              'code': 401,
              'status': 'UNAUTHENTICATED',
              'message': 'no',
            },
          }),
          sendStatus: 401,
        ),
      );

      final results = await provider.send(
        message: message(),
        requests: [request()],
      );

      expect(results.single.outcome, PushDeliveryOutcome.retryable);
      expect(results.single.errorCode, 'UNAUTHENTICATED');
    },
  );

  test(
    'when FCM returns INVALID_ARGUMENT then the outcome is permanentFailure.',
    () async {
      final provider = FcmPushProvider(
        credentials: credentials,
        httpClient: _fcmClient(
          sendBody: jsonEncode({
            'error': {
              'code': 400,
              'status': 'INVALID_ARGUMENT',
              'details': [
                {'errorCode': 'INVALID_ARGUMENT'},
              ],
            },
          }),
          sendStatus: 400,
        ),
      );

      final results = await provider.send(
        message: message(),
        requests: [request()],
      );

      expect(results.single.outcome, PushDeliveryOutcome.permanentFailure);
    },
  );

  test('payloadBytesFor measures the FCM data envelope.', () {
    final provider = FcmPushProvider(
      credentials: credentials,
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

MockClient _fcmClient({
  required final String sendBody,
  required final int sendStatus,
  final Map<String, String> sendHeaders = const {},
}) {
  return MockClient((final request) async {
    if (request.url.host == 'oauth2.googleapis.com') {
      return http.Response(
        jsonEncode({
          'access_token': 'ya29.test',
          'expires_in': 3600,
        }),
        200,
      );
    }
    expect(request.url.path, contains('messages:send'));
    expect(request.headers['authorization'], 'Bearer ya29.test');
    return http.Response(sendBody, sendStatus, headers: sendHeaders);
  });
}

// PKCS#8 RSA key used only in tests. Listed under false_secrets in pubspec.
const _testPrivateKey = '''
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC7VJTUt9Us8cKj
MzEfYyjiWA4R4/M2bS1GB4t7NXp98C3SC6dVMvDuictGeurT8jNbvJZHtCSuYEvu
NMoSfm76oqFvAp8Gy0iz5sxjZmSnXyCdPEovGhLa0VzMaQ8s+CLOyS56YyCFGeJZ
qgtzJ6GR3eqoYSW9b9UMvkBpZODSctWSNGj3P7jRFDO5VoTwCQAWbFnOjDfH5Ulg
p2PKSQnSJP3AJLQNFNe7br1XbrhV//eO+t51mIpGSDCUv3E0DDFcWDTH9cXDTTlR
ZVEiR2BwpZOOkE/Z0/BVnhZYL71oZV34bKfWjQIt6V/isSMahdsAASACp4ZTGtwi
VuNd9tybAgMBAAECggEBAKTmjaS6tkK8BlPXClTQ2vpz/N6uxDeS35mXpqasqskV
laAidgg/sWqpjXDbXr93otIMLlWsM+X0CqMDgSXKejLS2jx4GDjI1ZTXg++0AMJ8
sJ74pWzVDOfmCEQ/7wXs3+cbnXhKriO8Z036q92Qc1+N87SI38nkGa0ABH9CN83H
mQqt4fB7UdHzuIRe/me2PGhIq5ZBzj6h3BpoPGzEP+x3l9YmK8t/1cN0pqI+dQwY
dgfGjackLu/2qH80MCF7IyQaseZUOJyKrCLtSD/Iixv/hzDEUPfOCjFDgTpzf3cw
ta8+oE4wHCo1iI1/4TlPkwmXx4qSXtmw4aQPz7IDQvECgYEA8KNThCO2gsC2I9PQ
DM/8Cw0O983WCDY+oi+7JPiNAJwv5DYBqEZB1QYdj06YD16XlC/HAZMsMku1na2T
N0driwenQQWzoev3g2S7gRDoS/FCJSI3jJ+kjgtaA7Qmzlgk1TxODN+G1H91HW7t
0l7VnL27IWyYo2qRRK3jzxqUiPUCgYEAx0oQs2reBQGMVZnApD1jeq7n4MvNLcPv
t8b/eU9iUv6Y4Mj0Suo/AU8lYZXm8ubbqAlwz2VSVunD2tOplHyMUrtCtObAfVDU
AhCndKaA9gApgfb3xw1IKbuQ1u4IF1FJl3VtumfQn//LiH1B3rXhcdyo3/vIttEk
48RakUKClU8CgYEAzV7W3COOlDDcQd935DdtKBFRAPRPAlspQUnzMi5eSHMD/ISL
DY5IiQHbIH83D4bvXq0X7qQoSBSNP7Dvv3HYuqMhf0DaegrlBuJllFVVq9qPVRnK
xt1Il2HgxOBvbhOT+9in1BzA+YJ99UzC85O0Qz06A+CmtHEy4aZ2kj5hHjECgYEA
mNS4+A8Fkss8Js1RieK2LniBxMgmYml3pfVLKGnzmng7H2+cwPLhPIzIuwytXywh
2bzbsYEfYx3EoEVgMEpPhoarQnYPukrJO4gwE2o5Te6T5mJSZGlQJQj9q4ZB2Dfz
et6INsK0oG8XVGXSpQvQh3RUYekCZQkBBFcpqWpbIEsCgYAnM3DQf3FJoSnXaMhr
VBIovic5l0xFkEHskAjFTevO86Fsz1C2aSeRKSqGFoOQ0tmJzBEs1R6KqnHInicD
TQrKhArgLXX4v3CddjfTRJkFWDbE/CkvKZNOrcf1nhaGCPspRJj2KUkj1Fhl9Cnc
dn/RsYEONbwQSjIfMPkvxF+8HQ==
-----END PRIVATE KEY-----
''';
