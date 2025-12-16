import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/src/web/routes/session_test_route.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

// Custom auth provider that returns a raw unwrapped token
class _UnwrappedTokenAuthProvider implements ClientAuthKeyProvider {
  final String token;

  _UnwrappedTokenAuthProvider(this.token);

  @override
  Future<String?> get authHeaderValue async => token;
}

// Custom auth provider that returns a Bearer-wrapped token
class _BearerTokenAuthProvider implements ClientAuthKeyProvider {
  final String token;

  _BearerTokenAuthProvider(this.token);

  @override
  Future<String?> get authHeaderValue async => 'Bearer $token';
}

// Custom auth provider that returns a Basic-wrapped token
class _BasicTokenAuthProvider implements ClientAuthKeyProvider {
  final String token;

  _BasicTokenAuthProvider(this.token);

  @override
  Future<String?> get authHeaderValue async =>
      'Basic ${base64.encode(utf8.encode(token))}';
}

void main() {
  group('Given a server with validateHeaders enabled', () {
    late Serverpod server;
    const testToken = 'test-token';

    setUpAll(() async {
      server = IntegrationTestServer.create(
        authenticationHandler: (final session, final token) async {
          if (token == testToken) {
            return AuthenticationInfo(
              'test-user-123',
              {Scope('test')},
              authId: 'auth-id-456',
            );
          }
          return null;
        },
      );

      server.webServer.addRoute(SessionTestRoute(), '/session-test');

      await server.start();
    });

    tearDownAll(() async {
      await server.shutdown(exitProcess: false);
    });

    test(
      'when calling endpoint with Bearer-wrapped token '
      'then request should succeed',
      () async {
        final client = Client(
          'http://localhost:8080/',
          authKeyProvider: _BearerTokenAuthProvider(testToken),
        );

        try {
          final result = await client.echoRequest.echoAuthenticationKey();
          expect(result, equals(testToken));
        } finally {
          client.close();
        }
      },
    );

    test(
      'when calling endpoint with unwrapped token '
      'then request should fail',
      () async {
        final client = Client(
          'http://localhost:8080/',
          authKeyProvider: _UnwrappedTokenAuthProvider(testToken),
        );

        try {
          await expectLater(
            client.echoRequest.echoAuthenticationKey(),
            throwsA(isA<ServerpodClientException>()),
          );
        } finally {
          client.close();
        }
      },
    );

    test(
      'when accessing web route with unwrapped token in Authorization header '
      'then request should fail with 400',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:8082/session-test'),
          headers: {
            'Authorization': testToken,
          },
        );

        expect(response.statusCode, equals(400));
      },
    );
  });

  group('Given a server with validateHeaders disabled', () {
    late Serverpod server;
    const testToken = 'test-token';

    setUpAll(() async {
      server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: ServerConfig(
            port: 8080,
            publicHost: 'serverpod_test_server',
            publicPort: 8080,
            publicScheme: 'http',
          ),
          webServer: ServerConfig(
            port: 8082,
            publicHost: 'serverpod_test_server',
            publicPort: 8082,
            publicScheme: 'http',
          ),
          validateHeaders: false,
        ),
        authenticationHandler: (final session, final token) async {
          if (token == testToken) {
            return AuthenticationInfo(
              'test-user-123',
              {Scope('test')},
              authId: 'auth-id-456',
            );
          }
          return null;
        },
      );

      server.webServer.addRoute(SessionTestRoute(), '/session-test');

      await server.start();
    });

    tearDownAll(() async {
      await server.shutdown(exitProcess: false);
    });

    test(
      'when calling endpoint with unwrapped token '
      'then request should succeed',
      () async {
        final client = Client(
          'http://localhost:8080/',
          authKeyProvider: _UnwrappedTokenAuthProvider(testToken),
        );

        try {
          final result = await client.echoRequest.echoAuthenticationKey();
          expect(result, equals(testToken));
        } finally {
          client.close();
        }
      },
    );

    test(
      'when calling endpoint with Bearer-wrapped token '
      'then request should succeed and token should be unwrapped',
      () async {
        final client = Client(
          'http://localhost:8080/',
          authKeyProvider: _BearerTokenAuthProvider(testToken),
        );

        try {
          final result = await client.echoRequest.echoAuthenticationKey();
          expect(result, equals(testToken));
        } finally {
          client.close();
        }
      },
    );

    test(
      'when calling endpoint with Basic-wrapped token '
      'then request should succeed and token should be unwrapped',
      () async {
        final client = Client(
          'http://localhost:8080/',
          authKeyProvider: _BasicTokenAuthProvider(testToken),
        );

        try {
          final result = await client.echoRequest.echoAuthenticationKey();
          expect(result, equals(testToken));
        } finally {
          client.close();
        }
      },
    );

    test(
      'when accessing web route with unwrapped token in Authorization header '
      'then session should be authenticated',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:8082/session-test'),
          headers: {
            'Authorization': testToken,
          },
        );

        expect(response.statusCode, equals(200));
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        expect(body['isAuthenticated'], isTrue);
        expect(body['userId'], equals('test-user-123'));
      },
    );

    test(
      'when accessing web route with Bearer-wrapped token in Authorization header '
      'then session should be authenticated',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:8082/session-test'),
          headers: {
            'Authorization': 'Bearer $testToken',
          },
        );

        expect(response.statusCode, equals(200));
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        expect(body['isAuthenticated'], isTrue);
        expect(body['userId'], equals('test-user-123'));
      },
    );
  });
}
