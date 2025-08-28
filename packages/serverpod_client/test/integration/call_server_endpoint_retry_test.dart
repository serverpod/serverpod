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

  group('Given a Client with an authKeyProvider that does not support refresh',
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

    test('when first call fails with 401 then no retry is attempted.',
        () async {
      await expectLater(
        client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
        throwsA(isA<ServerpodClientUnauthorized>()),
      );

      expect(requestCount, 1);
    });
  });

  group('Given a Client with an authKeyProvider that supports refresh', () {
    late TestRefresherAuthKeyProvider authKeyProvider;
    late bool shouldFailFirstCall;
    late bool shouldFailSecondCall;
    late bool shouldFailOtherException;
    late List<String> receivedAuthHeaders;

    setUp(() async {
      requestCount = 0;
      shouldFailFirstCall = false;
      shouldFailSecondCall = false;
      shouldFailOtherException = false;
      receivedAuthHeaders = [];

      closeServer = await TestHttpServer.startServer(
        httpRequestHandler: (request) async {
          requestCount++;

          final authHeader = request.headers.authorization?.headerValue;
          receivedAuthHeaders.add(authHeader ?? '');

          if (shouldFailOtherException) {
            return Response.internalServerError();
          } else if ((requestCount == 1 && shouldFailFirstCall) ||
              (requestCount == 2 && shouldFailSecondCall)) {
            return Response.unauthorized();
          } else {
            return Response.ok(
              body: Body.fromString('"success"'),
            );
          }
        },
        onConnected: (host) => httpHost = host,
      );

      authKeyProvider = TestRefresherAuthKeyProvider(
        initialAuthKey: 'initial-token',
      );

      client = TestServerpodClient(
        host: httpHost,
        authKeyProvider: authKeyProvider,
      );
    });

    tearDown(() async => await closeServer());

    test('when first call succeeds then no retry is attempted.', () async {
      final result = await client.callServerEndpoint<String>(
        'test',
        'method',
        {'arg': 'value'},
      );

      expect(result, 'success');
      expect(requestCount, 1);
      expect(authKeyProvider.refreshCallCount, 0);
    });

    test(
        'when first call fails with 401 and refresh succeeds '
        'then request is retried.', () async {
      shouldFailFirstCall = true;

      final result = await client.callServerEndpoint<String>(
        'test',
        'method',
        {'arg': 'value'},
      );

      expect(result, 'success');
      expect(requestCount, 2);
      expect(authKeyProvider.refreshCallCount, 1);
      expect(receivedAuthHeaders[0], contains('initial-token'));
      expect(receivedAuthHeaders[1], contains('refreshed-token-1'));
    });

    test(
        'when first call fails with 401 but refresh fails '
        'then original exception is rethrown.', () async {
      shouldFailFirstCall = true;
      authKeyProvider.setRefreshResult(false);

      await expectLater(
        client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
        throwsA(isA<ServerpodClientUnauthorized>()),
      );

      expect(requestCount, 1);
      expect(authKeyProvider.refreshCallCount, 1);
    });

    test(
        'when first and second calls fails with 401 '
        'then no second retry is attempted and original exception is rethrown.',
        () async {
      shouldFailFirstCall = true;
      shouldFailSecondCall = true;

      await expectLater(
        client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
        throwsA(isA<ServerpodClientUnauthorized>()),
      );

      expect(requestCount, 2);
      expect(authKeyProvider.refreshCallCount, 1);
      expect(receivedAuthHeaders[0], contains('initial-token'));
      expect(receivedAuthHeaders[1], contains('refreshed-token-1'));
    });

    test(
        'when first call fails with non-401 error '
        'then no retry is attempted.', () async {
      shouldFailOtherException = true;

      await expectLater(
        client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
        throwsA(isA<ServerpodClientInternalServerError>()),
      );

      expect(requestCount, 1);
      expect(authKeyProvider.refreshCallCount, 0);
    });

    test(
        'when exception is not ServerpodClientUnauthorized '
        'then no retry is attempted.', () async {
      closeServer = await TestHttpServer.startServer(
        httpRequestHandler: (request) async {
          requestCount++;
          throw Exception('Network error');
        },
        onConnected: (host) => httpHost = host,
      );

      client = TestServerpodClient(
        host: httpHost,
        authKeyProvider: authKeyProvider,
      );

      await expectLater(
        client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
        throwsA(isA<Exception>()),
      );

      expect(authKeyProvider.refreshCallCount, 0);
    });
  });
}
