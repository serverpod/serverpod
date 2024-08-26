import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  TestAuthKeyManager authKeyManager = TestAuthKeyManager();
  var client = Client(
    'http://localhost:8080/',
    authenticationKeyManager: authKeyManager,
  );
  late Serverpod server;

  group('Passing auth key in HTTP header format', () {
    late Completer<String> tokenInspectionCompleter;

    setUp(() async {
      tokenInspectionCompleter = Completer();

      Future<AuthenticationInfo?> authenticationHandler(
        Session session,
        String token,
      ) {
        tokenInspectionCompleter.complete(token);
        return Future.value(AuthenticationInfo(1, {}));
      }

      server = IntegrationTestServer.create(
        authenticationHandler: authenticationHandler,
      );
      await server.start();
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
    });

    test(
        'then endpoint method should receive plain auth key (i.e. in original format)',
        () async {
      var key = 'username-4711:password-4711';
      authKeyManager.put(key);

      var reflectedKey = await client.reflection.reflectAuthenticationKey();
      expect(reflectedKey, key);

      var receivedToken = await tokenInspectionCompleter.future;
      expect(receivedToken, key);
    });

    test(
        'then endpoint method request should contain properly formatted "authorization" header with Basic scheme',
        () async {
      var key = 'username-4711:password-4711';
      authKeyManager.put(key);

      var reflectedHeader =
          await client.reflection.reflectHttpHeader('authorization');
      expect(reflectedHeader, isNotNull);
      expect(reflectedHeader!.length, 1);
      expect(isValidAuthHeaderValue(reflectedHeader.first), true);
      expect(isWrappedAuthValue(reflectedHeader.first), true);

      var scheme = reflectedHeader.first.split(' ')[0];
      expect(scheme, 'Basic');

      var unwrappedKey = unwrapAuthValue(reflectedHeader.first);
      expect(unwrappedKey, key);

      var receivedToken = await tokenInspectionCompleter.future;
      expect(receivedToken, key);
    });
  });
}
