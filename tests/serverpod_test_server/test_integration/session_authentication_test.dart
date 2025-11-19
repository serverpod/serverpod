// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/src/web/routes/session_test_route.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a server with an authenticationHandler', () {
    late Serverpod server;
    const validTestToken = 'valid-test-token';
    const invalidTestToken = 'invalid-test-token';
    const testUserId = 'test-user-123';
    const testAuthId = 'auth-id-456';
    final testScopes = {Scope('test'), Scope('admin')};

    setUpAll(() async {
      server = IntegrationTestServer.create(
        authenticationHandler: (final session, final token) async {
          if (token == validTestToken) {
            return AuthenticationInfo(
              testUserId,
              testScopes,
              authId: testAuthId,
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

    group(
      'when calling standard endpoint methods with an authenticated client and a valid token',
      () {
        late Client client;

        setUp(() {
          final authKeyManager = TestAuthKeyManager();
          client = Client(
            'http://localhost:8080/',
            authenticationKeyManager: authKeyManager,
          );
          authKeyManager.put(validTestToken);
        });

        tearDown(() {
          client.close();
        });

        test(
          'then getAuthenticationInfo returns session.authenticated initialized',
          () async {
            final result = await client.sessionAuthentication
                .getAuthenticationInfo();

            expect(result.isAuthenticated, isTrue);
          },
        );

        test(
          'then getAuthenticatedUserId returns authenticated user identifier',
          () async {
            final userId = await client.sessionAuthentication
                .getAuthenticatedUserId();

            expect(userId, equals(testUserId));
          },
        );

        test(
          'then getAuthenticatedScopes returns authenticated scopes',
          () async {
            final scopes = await client.sessionAuthentication
                .getAuthenticatedScopes();

            expect(scopes, containsAll(testScopes.map((s) => s.name)));
          },
        );
      },
    );

    group(
      'when calling standard endpoint methods with an authenticated client and an invalid token',
      () {
        late Client client;

        setUp(() {
          final authKeyManager = TestAuthKeyManager();
          client = Client(
            'http://localhost:8080/',
            authenticationKeyManager: authKeyManager,
          );
          authKeyManager.put(invalidTestToken);
        });

        tearDown(() {
          client.close();
        });

        test(
          'then getAuthenticationInfo returns session.authenticated as false',
          () async {
            final result = await client.sessionAuthentication
                .getAuthenticationInfo();

            expect(result.isAuthenticated, isFalse);
          },
        );

        test('then getAuthenticatedUserId returns null', () async {
          final userId = await client.sessionAuthentication
              .getAuthenticatedUserId();

          expect(userId, isNull);
        });

        test('then getAuthenticatedScopes returns empty list', () async {
          final scopes = await client.sessionAuthentication
              .getAuthenticatedScopes();

          expect(scopes, isEmpty);
        });
      },
    );

    group(
      'when calling streaming endpoint methods with an authenticated client and a valid token',
      () {
        late Client client;

        setUp(() {
          final authKeyManager = TestAuthKeyManager();
          client = Client(
            'http://localhost:8080/',
            authenticationKeyManager: authKeyManager,
          );
          authKeyManager.put(validTestToken);
        });

        tearDown(() {
          client.close();
        });

        test(
          'then streamIsAuthenticated returns session.authenticated initialized',
          () async {
            final stream = client.sessionAuthentication.streamIsAuthenticated();

            final isAuthenticated = await stream.first;
            expect(isAuthenticated, isTrue);
          },
        );

        test(
          'then streamAuthenticatedUserId returns authenticated user identifier',
          () async {
            final stream = client.sessionAuthentication
                .streamAuthenticatedUserId();

            final userId = await stream.first;
            expect(userId, equals(testUserId));
          },
        );
      },
    );

    group(
      'when calling streaming endpoint methods with an authenticated client and an invalid token',
      () {
        late Client client;

        setUp(() {
          final authKeyManager = TestAuthKeyManager();
          client = Client(
            'http://localhost:8080/',
            authenticationKeyManager: authKeyManager,
          );
          authKeyManager.put(invalidTestToken);
        });

        tearDown(() {
          client.close();
        });

        test('then streamIsAuthenticated yields false', () async {
          final stream = client.sessionAuthentication.streamIsAuthenticated();

          final isAuthenticated = await stream.first;
          expect(isAuthenticated, isFalse);
        });

        test('then streamAuthenticatedUserId yields null', () async {
          final stream = client.sessionAuthentication
              .streamAuthenticatedUserId();

          final userId = await stream.first;
          expect(userId, isNull);
        });
      },
    );

    group('when accessing web route with a valid Authorization header', () {
      late http.Response response;
      late Map<String, dynamic> body;

      setUp(() async {
        response = await http.get(
          Uri.parse('http://localhost:8082/session-test'),
          headers: {
            'Authorization': 'Bearer $validTestToken',
          },
        );
        body = jsonDecode(response.body) as Map<String, dynamic>;
      });

      test('then session.authenticated is initialized', () async {
        expect(response.statusCode, equals(200));
        expect(body['isAuthenticated'], isTrue);
      });

      test('then authenticated user details are returned', () async {
        expect(body['userId'], equals(testUserId));
        expect(body['scopes'], containsAll(testScopes.map((s) => s.name)));
        expect(body['authId'], equals(testAuthId));
      });
    });

    group('when accessing web route with an invalid Authorization header', () {
      late http.Response response;
      late Map<String, dynamic> body;

      setUp(() async {
        response = await http.get(
          Uri.parse('http://localhost:8082/session-test'),
          headers: {
            'Authorization': 'Bearer $invalidTestToken',
          },
        );
        body = jsonDecode(response.body) as Map<String, dynamic>;
      });

      test('then session.authenticated is null', () async {
        expect(response.statusCode, equals(200));
        expect(body['isAuthenticated'], isFalse);
      });

      test('then authenticated user details are null/empty', () async {
        expect(body['userId'], isNull);
        expect(body['scopes'], isEmpty);
        expect(body['authId'], isNull);
      });
    });

    test(
      'when opening a streaming connection with a valid token then session.authenticated is initialized',
      () async {
        final authKeyManager = TestAuthKeyManager();
        final client = Client(
          'http://localhost:8080/',
          authenticationKeyManager: authKeyManager,
        );
        authKeyManager.put(validTestToken);

        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        try {
          final message =
              await client.sessionAuthenticationStreaming.stream.first
                  as SimpleData;

          expect(message.num, equals(1));
        } finally {
          await client.closeStreamingConnection();
          client.close();
        }
      },
    );

    test(
      'when opening a streaming connection with an invalid token then session.authenticated is null',
      () async {
        final authKeyManager = TestAuthKeyManager();
        final client = Client(
          'http://localhost:8080/',
          authenticationKeyManager: authKeyManager,
        );
        authKeyManager.put(invalidTestToken);

        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        try {
          final message =
              await client.sessionAuthenticationStreaming.stream.first
                  as SimpleData;

          expect(message.num, equals(0));
        } finally {
          await client.closeStreamingConnection();
          client.close();
        }
      },
    );

    test(
      'when sending message over a streaming connection with a valid token '
      'then session.authenticated remains initialized',
      () async {
        final authKeyManager = TestAuthKeyManager();
        final client = Client(
          'http://localhost:8080/',
          authenticationKeyManager: authKeyManager,
        );
        authKeyManager.put(validTestToken);

        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        try {
          client.sessionAuthenticationStreaming.sendStreamMessage(
            SimpleData(num: 999),
          );

          // Skip the first message from streamOpened
          final message =
              await client.sessionAuthenticationStreaming.stream.skip(1).first
                  as SimpleData;

          expect(message.num, equals(1));
        } finally {
          await client.closeStreamingConnection();
          client.close();
        }
      },
    );

    test(
      'when sending message over a streaming connection with an invalid token '
      'then session.authenticated remains null',
      () async {
        final authKeyManager = TestAuthKeyManager();
        final client = Client(
          'http://localhost:8080/',
          authenticationKeyManager: authKeyManager,
        );
        authKeyManager.put(invalidTestToken);

        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        try {
          client.sessionAuthenticationStreaming.sendStreamMessage(
            SimpleData(num: 999),
          );

          // Skip the first message from streamOpened
          final message =
              await client.sessionAuthenticationStreaming.stream.skip(1).first
                  as SimpleData;

          expect(message.num, equals(0));
        } finally {
          await client.closeStreamingConnection();
          client.close();
        }
      },
    );
  });

  group('Given a server without an authenticationHandler', () {
    late Serverpod server;

    setUpAll(() async {
      server = IntegrationTestServer.create(
        authenticationHandler: (session, token) async {
          return null;
        },
      );

      server.webServer.addRoute(SessionTestRoute(), '/session-test');

      await server.start();
    });

    tearDownAll(() async {
      await server.shutdown(exitProcess: false);
    });

    group(
      'when calling standard endpoint methods with an unauthenticated client',
      () {
        late Client client;

        setUp(() {
          client = Client('http://localhost:8080/');
        });

        tearDown(() {
          client.close();
        });

        test('then getAuthenticatedUserId returns null', () async {
          final userId = await client.sessionAuthentication
              .getAuthenticatedUserId();

          expect(userId, isNull);
        });

        test('then isAuthenticated returns false', () async {
          final isAuthenticated = await client.sessionAuthentication
              .isAuthenticated();

          expect(isAuthenticated, isFalse);
        });
      },
    );

    group(
      'when calling streaming endpoint methods with an unauthenticated client',
      () {
        late Client client;

        setUp(() {
          client = Client('http://localhost:8080/');
        });

        tearDown(() {
          client.close();
        });

        test('then streamAuthenticatedUserId yields null', () async {
          final stream = client.sessionAuthentication
              .streamAuthenticatedUserId();

          final userId = await stream.first;
          expect(userId, isNull);
        });

        test('then streamIsAuthenticated yields false', () async {
          final stream = client.sessionAuthentication.streamIsAuthenticated();

          final isAuthenticated = await stream.first;
          expect(isAuthenticated, isFalse);
        });
      },
    );

    test(
      'when accessing web route then session.authenticated is null',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:8082/session-test'),
        );

        expect(response.statusCode, equals(200));
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        expect(body['isAuthenticated'], isFalse);
        expect(body['userId'], isNull);
        expect(body['scopes'], isEmpty);
        expect(body['authId'], isNull);
      },
    );

    test(
      'when opening WebSocket connection then session.authenticated is null',
      () async {
        final client = Client('http://localhost:8080/');

        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        try {
          final message =
              await client.sessionAuthenticationStreaming.stream.first
                  as SimpleData;

          expect(message.num, equals(0));
        } finally {
          await client.closeStreamingConnection();
          client.close();
        }
      },
    );
  });
}
