import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group(
    'Given a simulated legacy client sending the auth key via the removed '
    'URL/query convention, ',
    () {
      late Client client;
      late String authKey;

      setUpAll(() async {
        // prepare a proper authentication key
        client = Client(
          serverUrl,
          // ignore: deprecated_member_use
          authenticationKeyManager: TestAuthKeyManager(),
        );
        var response = await client.authentication.authenticate(
          'test@foo.bar',
          'password',
        );
        assert(response.success, 'Authentication setup failed');
        authKey = '${response.keyId}:${response.key}';
      });

      tearDownAll(() async {
        // ignore: deprecated_member_use
        await client.authenticationKeyManager?.remove();
        await client.authentication.removeAllUsers();
        await client.authentication.signOut();
        assert(
          await client.modules.auth.status.isSignedIn() == false,
          'Still signed in after teardown',
        );
        client.close();
      });

      test('when calling an authorized endpoint method with the old style '
          'auth key then it is no longer authenticated', () async {
        // The `auth` request parameter (formerly read from the URL / query
        // string) is no longer accepted, so even a valid key supplied this way
        // does not authenticate the request: the login-required endpoint
        // rejects it like any unauthenticated call.
        var response = await http.post(
          Uri.parse('${serverUrl}echoRequest'),
          body: jsonEncode({
            'method': 'echoAuthenticationKey',
            'auth': authKey,
          }),
        );

        expect(response.statusCode, 401);
        expect(response.body, '');
      });

      test('when calling an authorized endpoint method without auth key '
          'then it should fail', () async {
        var response = await http.post(
          Uri.parse('${serverUrl}echoRequest'),
          body: jsonEncode({
            'method': 'echoAuthenticationKey',
          }),
        );

        expect(response.statusCode, 401);
        expect(response.body, '');
      });
    },
  );
}
