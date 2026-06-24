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
  late List<String?> receivedAuthModeMarkers;
  late List<String?> receivedAuthHeaders;

  group('Given a cookie-auth client', () {
    setUp(() async {
      receivedAuthModeMarkers = [];
      receivedAuthHeaders = [];

      closeServer = await TestHttpServer.startServer(
        httpRequestHandler: (request) async {
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
      'then the cookie-mode marker is sent and no Authorization header is set.',
      () async {
        await client.callServerEndpoint<String>('test', 'method', {});

        expect(receivedAuthModeMarkers, [webAuthModeCookie]);
        expect(receivedAuthHeaders, [null]);
      },
    );

    test(
      'when an unauthenticated call is made '
      'then the cookie-mode marker is omitted so the server treats the call as anonymous.',
      () async {
        await client.callServerEndpoint<String>(
          'test',
          'method',
          {},
          authenticated: false,
        );

        expect(receivedAuthModeMarkers, [null]);
        expect(receivedAuthHeaders, [null]);
      },
    );
  });
}
