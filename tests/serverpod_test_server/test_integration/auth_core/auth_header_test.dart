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

  TestAuthKeyManager authKeyManager = TestAuthKeyManager();
  var client = Client(
    'http://localhost:8080/',
    authenticationKeyManager: authKeyManager,
  );
  late Serverpod server;

  group('When passing auth key in HTTP header format', () {
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
        'then endpoint method reflectAuthenticationKey should receive plain auth key (i.e. in original format)',
        () async {
      var key = 'username-4711:password-4711';
      await authKeyManager.put(key);

      var reflectedKey =
          await client.requestReflection.reflectAuthenticationKey();
      expect(reflectedKey, key);

      var receivedToken = await tokenInspectionCompleter.future;
      expect(receivedToken, key);
    });

    test(
        'then endpoint method reflectHttpHeader should receive plain auth key (i.e. in original format)',
        () async {
      var key = 'username-4711:password-4711';
      await authKeyManager.put(key);

      await client.requestReflection.reflectHttpHeader('authorization');

      var receivedToken = await tokenInspectionCompleter.future;
      expect(receivedToken, key);
    });

    test(
        'then endpoint method request should contain properly formatted "authorization" header with Basic scheme',
        () async {
      var key = 'username-4712:password-4712';
      await authKeyManager.put(key);

      var reflectedHeader =
          await client.requestReflection.reflectHttpHeader('authorization');

      expect(reflectedHeader, isNotNull);
      expect(reflectedHeader!, isNotEmpty);
      expect(isValidAuthHeaderValue(reflectedHeader.first), isTrue);
      expect(isWrappedAuthValue(reflectedHeader.first), isTrue);
      var scheme = reflectedHeader.first.split(' ')[0];
      expect(scheme, 'Basic');
    });

    test(
        'then endpoint method request\'s "authorization" should when unwrapped contain the original key',
        () async {
      var key = 'username-4713:password-4713';
      await authKeyManager.put(key);

      var reflectedHeader =
          await client.requestReflection.reflectHttpHeader('authorization');

      var unwrappedKey = unwrapAuthValue(reflectedHeader!.first);
      expect(unwrappedKey, key);
    });
  });
}
