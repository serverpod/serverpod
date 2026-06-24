@OnPlatform({
  'browser': Skip('HTTP server tests are not supported in browser'),
})
library;

import 'package:relic/relic.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

import '../test_utils/test_auth_key_providers.dart';
import '../test_utils/test_http_server.dart';
import '../test_utils/test_serverpod_client.dart';

void main() {
  late Uri httpHost;
  late TestServerpodClient client;
  late Future<void> Function() closeServer;
  late int requestCount;
  late List<String?> receivedAuthModeMarkers;
  late List<String?> receivedAuthHeaders;

  group('Given a cookie-auth client on a transport without a cookie jar', () {
    setUp(() async {
      requestCount = 0;
      receivedAuthModeMarkers = [];
      receivedAuthHeaders = [];

      closeServer = await TestHttpServer.startServer(
        httpRequestHandler: (request) async {
          requestCount++;
          receivedAuthModeMarkers.add(
            request.headers[webAuthModeHeaderName]?.firstOrNull,
          );
          receivedAuthHeaders.add(request.headers.authorization?.headerValue);
          return Response.ok(body: Body.fromString('"ok"'));
        },
        onConnected: (host) => httpHost = host,
      );

      client = TestServerpodClient(
        host: httpHost,
        authKeyProvider: TestCookieAuthKeyProvider(),
      );
    });

    tearDown(() async => await closeServer());

    test(
      'when an authenticated call is made '
      'then it fails loudly because the transport cannot carry the auth cookie.',
      () async {
        await expectLater(
          client.callServerEndpoint<String>('test', 'method', {}),
          throwsA(isA<StateError>()),
        );

        expect(requestCount, 0);
      },
    );

    test(
      'when an unauthenticated call is made '
      'then cookie mode is suppressed: no marker, no Authorization header, and the call succeeds.',
      () async {
        await client.callServerEndpoint<String>(
          'test',
          'method',
          {},
          authenticated: false,
        );

        expect(requestCount, 1);
        expect(receivedAuthModeMarkers, [null]);
        expect(receivedAuthHeaders, [null]);
      },
    );
  });
}
