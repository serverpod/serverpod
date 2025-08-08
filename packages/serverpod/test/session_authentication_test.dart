import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

// Mock server and authentication handler for testing
class MockServer extends Server {
  final AuthenticationHandler authHandler;

  MockServer(this.authHandler)
      : super(
          serverpod: MockServerpod(),
          serverId: 'test-server',
          port: 8080,
          serializationManager: SerializationManager(),
          databasePoolManager: null,
          passwords: {},
          runMode: 'test',
          authenticationHandler: authHandler,
          caches: Caches(),
          httpResponseHeaders: {},
          httpOptionsResponseHeaders: {},
        );
}

class MockServerpod extends Serverpod {
  MockServerpod()
      : super(
          config: ServerpodConfig(runMode: 'test'),
          serializationManager: SerializationManager(),
        );
}

void main() {
  group('Session Authentication Resolution', () {
    test('should resolve authentication immediately for valid auth key', () async {
      // Create a mock authentication handler that returns authentication info
      AuthenticationHandler authHandler = (session, token) async {
        if (token == 'valid-token') {
          return AuthenticationInfo('user-123', <Scope>{});
        }
        return null;
      };

      var server = MockServer(authHandler);

      // Create a session with an authentication key
      var session = Session(
        server: server,
        authenticationKey: 'valid-token',
        enableLogging: false,
        endpoint: 'test',
      );

      // Wait a bit for async initialization to complete
      await Future.delayed(Duration(milliseconds: 100));

      // The authentication should be resolved
      var authInfo = await session.authenticated;
      expect(authInfo, isNotNull);
      expect(authInfo!.userIdentifier, equals('user-123'));

      // Clean up
      await session.close();
    });

    test('should handle null authentication key', () async {
      AuthenticationHandler authHandler = (session, token) async {
        return AuthenticationInfo('user-123', <Scope>{});
      };

      var server = MockServer(authHandler);

      // Create a session without an authentication key
      var session = Session(
        server: server,
        authenticationKey: null,
        enableLogging: false,
        endpoint: 'test',
      );

      // The authentication should remain null
      var authInfo = await session.authenticated;
      expect(authInfo, isNull);

      // Clean up
      await session.close();
    });

    test('should handle invalid authentication key', () async {
      AuthenticationHandler authHandler = (session, token) async {
        if (token == 'valid-token') {
          return AuthenticationInfo('user-123', <Scope>{});
        }
        return null;
      };

      var server = MockServer(authHandler);

      // Create a session with an invalid authentication key
      var session = Session(
        server: server,
        authenticationKey: 'invalid-token',
        enableLogging: false,
        endpoint: 'test',
      );

      // Wait a bit for async initialization to complete
      await Future.delayed(Duration(milliseconds: 100));

      // The authentication should be null
      var authInfo = await session.authenticated;
      expect(authInfo, isNull);

      // Clean up
      await session.close();
    });
  });
}