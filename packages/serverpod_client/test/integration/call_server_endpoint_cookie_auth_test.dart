@OnPlatform({
  'browser': Skip('HTTP server tests are not supported in browser'),
})
library;

import 'package:http/http.dart' as http;
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
  late List<String?> receivedBasePaths;

  group('Given a cookie-auth client on a transport without a cookie jar', () {
    test(
      'when cookie auth is enabled '
      'then it fails loudly at configuration time.',
      () {
        client = TestServerpodClient(
          host: Uri.parse('http://localhost:8080'),
        );

        expect(
          () => client.cookieAuth = true,
          throwsA(isA<UnsupportedError>()),
        );
        expect(client.cookieAuth, isFalse);
      },
    );
  });

  group('Given a cookie-auth client on a cookie-capable transport', () {
    setUp(() async {
      requestCount = 0;
      receivedAuthModeMarkers = [];
      receivedAuthHeaders = [];
      receivedBasePaths = [];

      closeServer = await TestHttpServer.startServer(
        httpRequestHandler: (request) async {
          requestCount++;
          receivedAuthModeMarkers.add(
            request.headers[webAuthModeHeaderName]?.firstOrNull,
          );
          receivedAuthHeaders.add(request.headers.authorization?.headerValue);
          receivedBasePaths.add(
            request.headers[webBasePathHeaderName]?.firstOrNull,
          );
          return Response.ok(body: Body.fromString('"ok"'));
        },
        onConnected: (host) => httpHost = host,
      );
    });

    tearDown(() async => await closeServer());

    test(
      'when an authenticated SAS-style call is made '
      'then the marker is sent without an Authorization header.',
      () async {
        client = TestServerpodClient(
          host: httpHost,
          authKeyProvider: TestNonRefresherAuthKeyProvider(null),
          requestDelegate: _CookieCapableRequestDelegate(),
        )..cookieAuth = true;

        await client.callServerEndpoint<String>('test', 'method', {});

        expect(requestCount, 1);
        expect(receivedAuthModeMarkers, [webAuthModeCookie]);
        expect(receivedAuthHeaders, [null]);
      },
    );

    test(
      'when an unauthenticated call is made '
      'then the transport-only marker is sent without an Authorization header.',
      () async {
        client = TestServerpodClient(
          host: httpHost,
          authKeyProvider: TestNonRefresherAuthKeyProvider(null),
          requestDelegate: _CookieCapableRequestDelegate(),
        )..cookieAuth = true;

        await client.callServerEndpoint<String>(
          'test',
          'method',
          {},
          authenticated: false,
        );

        expect(requestCount, 1);
        expect(receivedAuthModeMarkers, [webAuthModeCookieTransport]);
        expect(receivedAuthHeaders, [null]);
      },
    );

    test(
      'when an authenticated JWT-style call is made '
      'then the marker and Authorization header are both sent.',
      () async {
        client = TestServerpodClient(
          host: httpHost,
          authKeyProvider: TestNonRefresherAuthKeyProvider(
            wrapAsBearerAuthHeaderValue('access-token'),
          ),
          requestDelegate: _CookieCapableRequestDelegate(),
        )..cookieAuth = true;

        await client.callServerEndpoint<String>('test', 'method', {});

        expect(requestCount, 1);
        expect(receivedAuthModeMarkers, [webAuthModeCookie]);
        expect(receivedAuthHeaders, [
          wrapAsBearerAuthHeaderValue('access-token'),
        ]);
      },
    );

    test(
      'when the client host is at the domain root '
      'then the declared base path is "/".',
      () async {
        client = TestServerpodClient(
          host: httpHost,
          authKeyProvider: TestNonRefresherAuthKeyProvider(null),
          requestDelegate: _CookieCapableRequestDelegate(),
        )..cookieAuth = true;

        await client.callServerEndpoint<String>('test', 'method', {});

        expect(receivedBasePaths, ['/']);
      },
    );

    test(
      'when the client host has a URL prefix (reverse proxy) '
      'then the prefix is declared as the base path.',
      () async {
        client = TestServerpodClient(
          host: httpHost.replace(path: '/api/'),
          authKeyProvider: TestNonRefresherAuthKeyProvider(null),
          requestDelegate: _CookieCapableRequestDelegate(),
        )..cookieAuth = true;

        // The test server serves every path, so the prefixed call succeeds.
        await client.callServerEndpoint<String>('test', 'method', {});

        expect(receivedBasePaths, ['/api']);
      },
    );
  });
}

class _CookieCapableRequestDelegate extends ServerpodClientRequestDelegate {
  final _httpClient = http.Client();

  @override
  bool get supportsCookieAuth => true;

  @override
  Future<String> serverRequest<T>(
    Uri url, {
    required String body,
    String? authenticationValue,
    bool authenticated = true,
  }) async {
    final response = await _httpClient.post(
      url,
      body: body,
      headers: {
        'authorization': ?authenticationValue,
        ...webAuthHeaders(authenticated: authenticated),
      },
    );

    if (response.statusCode != 200) {
      throw ServerpodClientException(response.body, response.statusCode);
    }

    return response.body;
  }

  @override
  void close() {
    _httpClient.close();
  }
}
