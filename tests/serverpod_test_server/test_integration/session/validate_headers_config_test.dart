import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/src/web/routes/session_test_route.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

const _testToken = 'test-token';
const _testUserId = 'test-user-123';
const _testAuthId = 'auth-id-456';
const _apiServerUrl = 'http://localhost:8080/';
const _webServerUrl = 'http://localhost:8082/session-test';

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
  group(
    'Given a server with default configuration (validateHeaders enabled)',
    () {
      late Serverpod server;

      setUpAll(() async {
        server = IntegrationTestServer.create(
          authenticationHandler: (final session, final token) async {
            if (token == _testToken) {
              return AuthenticationInfo(
                _testUserId,
                {Scope('test')},
                authId: _testAuthId,
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
        'then validateHeaders defaults to true',
        () {
          expect(server.config.validateHeaders, isTrue);
        },
      );

      group('when calling endpoint with Bearer-wrapped token', () {
        late Client client;

        setUp(() {
          client = Client(_apiServerUrl)
            ..authKeyProvider = _BearerTokenAuthProvider(_testToken);
        });

        tearDown(() {
          client.close();
        });

        test(
          'then request should succeed',
          () async {
            final result = await client.echoRequest.echoAuthenticationKey();
            expect(result, equals(_testToken));
          },
        );
      });

      group('when calling endpoint with unwrapped token', () {
        late Client client;

        setUp(() {
          client = Client(_apiServerUrl)
            ..authKeyProvider = _UnwrappedTokenAuthProvider(_testToken);
        });

        tearDown(() {
          client.close();
        });

        test(
          'then request should fail',
          () async {
            await expectLater(
              client.echoRequest.echoAuthenticationKey(),
              throwsA(isA<ServerpodClientException>()),
            );
          },
        );
      });

      group('when calling streaming endpoint with unwrapped token', () {
        late Client client;

        setUp(() {
          client = Client(_apiServerUrl)
            ..authKeyProvider = _UnwrappedTokenAuthProvider(_testToken);
        });

        tearDown(() {
          client.close();
        });

        test(
          'then stream should fail',
          () async {
            await expectLater(
              client.methodStreaming.simpleStream(),
              emitsError(isA<ServerpodClientException>()),
            );
          },
        );
      });

      group('when accessing web route with unwrapped token', () {
        test(
          'then request should fail with 400',
          () async {
            final response = await http.get(
              Uri.parse(_webServerUrl),
              headers: {
                'Authorization': _testToken,
              },
            );

            expect(response.statusCode, equals(400));
          },
        );
      });
    },
  );

  group('Given a server with validateHeaders explicitly disabled', () {
    late Serverpod server;

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
          if (token == _testToken) {
            return AuthenticationInfo(
              _testUserId,
              {Scope('test')},
              authId: _testAuthId,
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

    group('when calling endpoint with unwrapped token', () {
      late Client client;

      setUp(() {
        client = Client(_apiServerUrl)
          ..authKeyProvider = _UnwrappedTokenAuthProvider(_testToken);
      });

      tearDown(() {
        client.close();
      });

      test(
        'then request should succeed',
        () async {
          final result = await client.echoRequest.echoAuthenticationKey();
          expect(result, equals(_testToken));
        },
      );
    });

    group('when calling streaming endpoint with unwrapped token', () {
      late Client client;

      setUp(() {
        client = Client(_apiServerUrl)
          ..authKeyProvider = _UnwrappedTokenAuthProvider(_testToken);
      });

      tearDown(() {
        client.close();
      });

      test(
        'then stream should succeed',
        () async {
          final stream = await client.methodStreaming.simpleStream();
          await expectLater(
            stream.take(1),
            emits(isA<int>()),
          );
        },
      );
    });

    group('when calling endpoint with Bearer-wrapped token', () {
      late Client client;

      setUp(() {
        client = Client(_apiServerUrl)
          ..authKeyProvider = _BearerTokenAuthProvider(_testToken);
      });

      tearDown(() {
        client.close();
      });

      test(
        'then request should succeed and token should be unwrapped',
        () async {
          final result = await client.echoRequest.echoAuthenticationKey();
          expect(result, equals(_testToken));
        },
      );
    });

    group('when calling endpoint with Basic-wrapped token', () {
      late Client client;

      setUp(() {
        client = Client(_apiServerUrl)
          ..authKeyProvider = _BasicTokenAuthProvider(_testToken);
      });

      tearDown(() {
        client.close();
      });

      test(
        'then request should succeed and token should be unwrapped',
        () async {
          final result = await client.echoRequest.echoAuthenticationKey();
          expect(result, equals(_testToken));
        },
      );
    });

    group('when accessing web route with unwrapped token', () {
      test(
        'then session should be authenticated',
        () async {
          final response = await http.get(
            Uri.parse(_webServerUrl),
            headers: {
              'Authorization': _testToken,
            },
          );

          expect(response.statusCode, equals(200));
          final body = jsonDecode(response.body) as Map<String, dynamic>;
          expect(body['isAuthenticated'], isTrue);
          expect(body['userId'], equals(_testUserId));
        },
      );
    });

    group('when accessing web route with Bearer-wrapped token', () {
      test(
        'then session should be authenticated',
        () async {
          final response = await http.get(
            Uri.parse(_webServerUrl),
            headers: {
              'Authorization': 'Bearer $_testToken',
            },
          );

          expect(response.statusCode, equals(200));
          final body = jsonDecode(response.body) as Map<String, dynamic>;
          expect(body['isAuthenticated'], isTrue);
          expect(body['userId'], equals(_testUserId));
        },
      );
    });
  });
}
