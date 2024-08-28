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
      await authKeyManager.put(key);

      tokenInspectionCompleter = Completer();
      var reflectedKey = await client.reflection.reflectAuthenticationKey();
      expect(reflectedKey, key);

      var receivedToken = await tokenInspectionCompleter.future;
      expect(receivedToken, key);
    });

    test(
        'then endpoint method request should contain properly formatted "authorization" header with Basic scheme',
        () async {
      var key = 'username-4712:password-4712';
      await authKeyManager.put(key);

      tokenInspectionCompleter = Completer();
      var reflectedHeader =
          await client.reflection.reflectHttpHeader('authorization');
      expect(reflectedHeader, isNotNull);
      expect(reflectedHeader!, isNotEmpty);
      expect(isValidAuthHeaderValue(reflectedHeader.first), isTrue);
      expect(isWrappedAuthValue(reflectedHeader.first), isTrue);

      var scheme = reflectedHeader.first.split(' ')[0];
      expect(scheme, 'Basic');

      var unwrappedKey = unwrapAuthValue(reflectedHeader.first);
      expect(unwrappedKey, key);

      var receivedToken = await tokenInspectionCompleter.future;
      expect(receivedToken, key);
    });

    test(
        'then old clients passing keys in body should still work with new server code',
        () async {
      var key = 'username-4713:password-4713';

      // Intentionally clearing the authKeyManager so that auth is not passed in header.
      await authKeyManager.remove();

      // Verify that by calling it this way, the key is not passed in the header.
      // This validates this unit test's approach.
      tokenInspectionCompleter = Completer();
      var reflectedHeader =
          await client.reflection.caller.callServerEndpoint<List<String>?>(
        'reflection',
        'reflectHttpHeader',
        {
          'headerName': 'authorization',
          'auth': key,
        },
      );
      expect(reflectedHeader, isNull);

      // Verify that auth is required by this endpoint method.
      tokenInspectionCompleter = Completer();
      int? statusCode;
      try {
        reflectedHeader =
            await client.reflection.caller.callServerEndpoint<List<String>?>(
          'reflection',
          'reflectHttpHeader',
          {
            'headerName': 'authorization',
          },
        );
      } catch (e) {
        if (e is ServerpodClientException) {
          statusCode = e.statusCode;
        }
      }
      expect(statusCode, equals(401));

      // This emulates how the old formatArgs(), called by callServerEndpoint(),
      // would pass the key
      tokenInspectionCompleter = Completer();
      var reflectedKey =
          await client.reflection.caller.callServerEndpoint<String?>(
        'reflection',
        'reflectAuthenticationKey',
        {'auth': key},
      );
      expect(reflectedKey, key);

      var receivedToken = await tokenInspectionCompleter.future;
      expect(receivedToken, key);
    });
  });
}
