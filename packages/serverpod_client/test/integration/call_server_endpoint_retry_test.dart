@OnPlatform({
  'browser': Skip('HTTP server tests are not supported in browser'),
})
library;

import 'package:serverpod_client/serverpod_client.dart';
import 'package:relic/relic.dart';
import 'package:test/test.dart';

import '../test_utils/test_auth_key_providers.dart';
import '../test_utils/test_http_server.dart';
import '../test_utils/test_serverpod_client.dart';

void main() {
  late Uri httpHost;
  late TestServerpodClient client;
  late Future<void> Function() closeServer;
  late int requestCount;

  group(
    'Given a Client with an authKeyProvider that does not support refresh',
    () {
      setUp(() async {
        requestCount = 0;

        closeServer = await TestHttpServer.startServer(
          httpRequestHandler: (request) async {
            requestCount++;
            return Response.unauthorized();
          },
          onConnected: (host) => httpHost = host,
        );

        client = TestServerpodClient(
          host: httpHost,
          authKeyProvider: TestNonRefresherAuthKeyProvider('token'),
        );
      });

      tearDown(() async => await closeServer());

      test(
        'when first call fails with 401 then no retry is attempted.',
        () async {
          await expectLater(
            client.callServerEndpoint<String>('test', 'method', {
              'arg': 'value',
            }),
            throwsA(isA<ServerpodClientUnauthorized>()),
          );

          expect(requestCount, 1);
        },
      );
    },
  );

  group('Given a Client with an authKeyProvider that supports refresh', () {
    late TestRefresherAuthKeyProvider authKeyProvider;
    late List<String> receivedAuthHeaders;
    late List<Response> serverResponses;

    setUp(() async {
      requestCount = 0;
      receivedAuthHeaders = [];

      closeServer = await TestHttpServer.startServer(
        httpRequestHandler: (request) async {
          requestCount++;

          final authHeader = request.headers.authorization?.headerValue;
          receivedAuthHeaders.add(authHeader ?? '');

          if (requestCount > serverResponses.length) {
            throw Exception('No more responses configured');
          }
          return serverResponses[requestCount - 1];
        },
        onConnected: (host) => httpHost = host,
      );

      authKeyProvider = TestRefresherAuthKeyProvider();
      authKeyProvider.setAuthKey('initial-token');

      client = TestServerpodClient(
        host: httpHost,
        authKeyProvider: authKeyProvider,
      );
    });

    tearDown(() async => await closeServer());

    test('when first call succeeds then no retry is attempted.', () async {
      serverResponses = [
        Response.ok(
          body: Body.fromString('"success"'),
        ),
      ];

      final result = await client.callServerEndpoint<String>(
        'test',
        'method',
        {'arg': 'value'},
      );

      expect(result, 'success');
      expect(requestCount, 1);
      expect(authKeyProvider.refreshCallCount, 0);
    });

    test('when first call fails with 401 but refresh succeeds '
        'then request is retried.', () async {
      serverResponses = [
        Response.unauthorized(),
        Response.ok(body: Body.fromString('"success"')),
      ];

      authKeyProvider.setRefresh(() {
        authKeyProvider.setAuthKey('refreshed-token');
        return RefreshAuthKeyResult.success;
      });

      final result = await client.callServerEndpoint<String>(
        'test',
        'method',
        {'arg': 'value'},
      );

      expect(result, 'success');
      expect(requestCount, 2);
      expect(authKeyProvider.refreshCallCount, 1);
      expect(receivedAuthHeaders[0], contains('initial-token'));
      expect(receivedAuthHeaders[1], contains('refreshed-token'));
    });

    test('when first call fails with 401 and refresh fails '
        'then original exception is rethrown.', () async {
      serverResponses = [
        Response.unauthorized(),
      ];

      authKeyProvider.setRefresh(() => RefreshAuthKeyResult.failedOther);

      await expectLater(
        client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
        throwsA(isA<ServerpodClientUnauthorized>()),
      );

      expect(requestCount, 1);
      expect(authKeyProvider.refreshCallCount, 1);
    });

    test(
      'when first call fails with 401, refresh succeeds and second call also fails with 401 '
      'then no second retry is attempted and original exception is rethrown.',
      () async {
        serverResponses = [
          Response.unauthorized(),
          Response.unauthorized(),
        ];

        authKeyProvider.setRefresh(() {
          authKeyProvider.setAuthKey('refreshed-token');
          return RefreshAuthKeyResult.success;
        });

        await expectLater(
          client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
          throwsA(isA<ServerpodClientUnauthorized>()),
        );

        expect(requestCount, 2);
        expect(authKeyProvider.refreshCallCount, 1);
        expect(receivedAuthHeaders[0], contains('initial-token'));
        expect(receivedAuthHeaders[1], contains('refreshed-token'));
      },
    );

    test('when first call fails with non-401 error '
        'then no retry is attempted.', () async {
      serverResponses = [
        Response.internalServerError(),
      ];

      await expectLater(
        client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
        throwsA(isA<ServerpodClientInternalServerError>()),
      );

      expect(requestCount, 1);
      expect(authKeyProvider.refreshCallCount, 0);
    });
  });
}
