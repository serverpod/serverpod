import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  late Completer<String> tokenInspectionCompleter;
  Future<AuthenticationInfo?> authenticationHandler(
    Session session,
    String token,
  ) {
    tokenInspectionCompleter.complete(token);
    return Future.value(AuthenticationInfo(1, {}));
  }

  group('Given auth key in valid HTTP header format', () {
    var authKeyManager = TestAuthKeyManager();
    var client = Client(
      'http://localhost:8080/',
      authenticationKeyManager: authKeyManager,
    );
    late Serverpod server;

    setUp(() async {
      tokenInspectionCompleter = Completer();

      server = IntegrationTestServer.create(
        authenticationHandler: authenticationHandler,
      );
      await server.start();
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
      // clear the authKeyManager so that auth is not retained between tests
      await authKeyManager.remove();
    });

    test(
        'when calling an endpoint method without parameters '
        'then it should receive plain auth key (i.e. in original format)',
        () async {
      var key = 'username-4711:password-4711';
      await authKeyManager.put(key);

      var reflectedKey = await client.echoRequest.echoAuthenticationKey();
      expect(reflectedKey, key);

      var receivedToken = await tokenInspectionCompleter.future;
      expect(receivedToken, key);
    });

    test(
        'when calling an endpoint method with a parameter '
        'then it should receive plain auth key (i.e. in original format)',
        () async {
      var key = 'username-4711:password-4711';
      await authKeyManager.put(key);

      await client.echoRequest.echoHttpHeader('authorization');

      var receivedToken = await tokenInspectionCompleter.future;
      expect(receivedToken, key);
    });

    test(
        'when calling an endpoint method '
        'then endpoint method request should contain properly formatted "authorization" header with Basic scheme',
        () async {
      var key = 'username-4712:password-4712';
      await authKeyManager.put(key);

      var reflectedHeader =
          await client.echoRequest.echoHttpHeader('authorization');

      expect(reflectedHeader, isNotNull);
      expect(reflectedHeader!, isNotEmpty);
      expect(isValidAuthHeaderValue(reflectedHeader.first), isTrue);
      expect(isWrappedBasicAuthHeaderValue(reflectedHeader.first), isTrue);
      var scheme = reflectedHeader.first.split(' ')[0];
      expect(scheme, 'Basic');
    });

    test(
        'when calling an endpoint method '
        'then endpoint method request\'s "authorization" should when unwrapped contain the original key',
        () async {
      var key = 'username-4713:password-4713';
      await authKeyManager.put(key);

      var reflectedHeader =
          await client.echoRequest.echoHttpHeader('authorization');

      var unwrappedKey = unwrapAuthHeaderValue(reflectedHeader!.first);
      expect(unwrappedKey, key);
    });
  });

  group('Given auth key in invalid Basic HTTP header format', () {
    var incorrectAuthKeyManager = TestIncorrectAuthKeyManager();
    var client = Client(
      'http://localhost:8080/',
      authenticationKeyManager: incorrectAuthKeyManager,
    );
    late Serverpod server;

    setUp(() async {
      tokenInspectionCompleter = Completer();

      server = IntegrationTestServer.create(
        authenticationHandler: authenticationHandler,
      );
      await server.start();
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
      // clear the authKeyManager so that auth is not retained between tests
      await incorrectAuthKeyManager.remove();
    });

    test(
        'when calling an endpoint method '
        'then endpoint method should return error corresponding to HTTP invalid request error (400)',
        () async {
      var key = 'username-4711:password-4711';
      await incorrectAuthKeyManager.put(key);

      ServerpodClientException? clientException;
      try {
        await client.echoRequest.echoAuthenticationKey();
      } catch (e) {
        clientException = e as ServerpodClientException?;
      }
      expect(clientException, isNotNull);
      expect(clientException!.statusCode, equals(400));
    });
  });
}

/// A test implementation that skips encoding of the key, i.e. yields invalid header values.
class TestIncorrectAuthKeyManager extends AuthenticationKeyManager {
  String? _key;

  @override
  Future<String?> get() async => _key;

  @override
  Future<void> put(String key) async {
    _key = key;
  }

  @override
  Future<void> remove() async {
    _key = null;
  }

  @override
  Future<String?> toHeaderValue(String? key) async {
    return 'basic $key';
  }
}
