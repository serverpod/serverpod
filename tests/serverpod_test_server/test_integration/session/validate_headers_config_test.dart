import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/web/routes/session_test_route.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a server with validateHeaders enabled', () {
    late Serverpod server;
    const validTestToken = 'valid-test-token';

    setUpAll(() async {
      server = IntegrationTestServer.create(
        authenticationHandler: (final session, final token) async {
          if (token == validTestToken) {
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
      'when calling endpoint with Bearer-wrapped token in Authorization header '
      'then request should succeed',
      () async {
        final response = await http.post(
          Uri.parse('http://localhost:8080/echoRequest'),
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer $validTestToken',
          },
          body: jsonEncode({
            'method': 'echoAuthenticationKey',
          }),
        );

        expect(response.statusCode, equals(200));
        expect(response.body, '"$validTestToken"');
      },
    );

    test(
      'when calling endpoint with unwrapped token in Authorization header '
      'then request should fail with 400',
      () async {
        final response = await http.post(
          Uri.parse('http://localhost:8080/echoRequest'),
          headers: {
            'content-type': 'application/json',
            'Authorization': validTestToken,
          },
          body: jsonEncode({
            'method': 'echoAuthenticationKey',
          }),
        );

        expect(response.statusCode, equals(400));
      },
    );

    test(
      'when accessing web route with unwrapped token in Authorization header '
      'then request should fail with 400',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:8082/session-test'),
          headers: {
            'Authorization': validTestToken,
          },
        );

        expect(response.statusCode, equals(400));
      },
    );
  });

  group('Given a server with validateHeaders disabled', () {
    late Serverpod server;
    const validTestToken = 'valid-test-token';

    setUpAll(() async {
      server = IntegrationTestServer.create(
        authenticationHandler: (final session, final token) async {
          if (token == validTestToken) {
            return AuthenticationInfo(
              'test-user-123',
              {Scope('test')},
              authId: 'auth-id-456',
            );
          }
          return null;
        },
        validateHeaders: false,
      );

      server.webServer.addRoute(SessionTestRoute(), '/session-test');

      await server.start();
    });

    tearDownAll(() async {
      await server.shutdown(exitProcess: false);
    });

    test(
      'when calling endpoint with unwrapped token in Authorization header '
      'then request should succeed',
      () async {
        final response = await http.post(
          Uri.parse('http://localhost:8080/echoRequest'),
          headers: {
            'content-type': 'application/json',
            'Authorization': validTestToken,
          },
          body: jsonEncode({
            'method': 'echoAuthenticationKey',
          }),
        );

        expect(response.statusCode, equals(200));
        expect(response.body, '"$validTestToken"');
      },
    );

    test(
      'when calling endpoint with Bearer-wrapped token in Authorization header '
      'then request should succeed and token should be unwrapped',
      () async {
        final response = await http.post(
          Uri.parse('http://localhost:8080/echoRequest'),
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer $validTestToken',
          },
          body: jsonEncode({
            'method': 'echoAuthenticationKey',
          }),
        );

        expect(response.statusCode, equals(200));
        expect(response.body, '"$validTestToken"');
      },
    );

    test(
      'when calling endpoint with Basic-wrapped token in Authorization header '
      'then request should succeed and token should be unwrapped',
      () async {
        final response = await http.post(
          Uri.parse('http://localhost:8080/echoRequest'),
          headers: {
            'content-type': 'application/json',
            'Authorization':
                'Basic ${base64.encode(utf8.encode(validTestToken))}',
          },
          body: jsonEncode({
            'method': 'echoAuthenticationKey',
          }),
        );

        expect(response.statusCode, equals(200));
        expect(response.body, '"$validTestToken"');
      },
    );

    test(
      'when accessing web route with unwrapped token in Authorization header '
      'then session should be authenticated',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:8082/session-test'),
          headers: {
            'Authorization': validTestToken,
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
            'Authorization': 'Bearer $validTestToken',
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
