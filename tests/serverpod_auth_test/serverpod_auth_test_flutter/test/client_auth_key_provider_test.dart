import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_test_client/serverpod_auth_test_client.dart';

import 'utils/test_storage.dart';

void main() {
  test(
    'Given a client without authSessionManager set, '
    'when accessing authKeyProvider, '
    'then it should be null.',
    () {
      final client = Client('http://localhost:8080/');

      expect(client.authKeyProvider, isNull);
    },
  );

  test(
    'Given a client with authSessionManager set, '
    'when updateSignedInUser is called, '
    'then the client authKeyProvider provides the correct auth header.',
    () async {
      final client = Client(
        'http://localhost:8080/',
      )..authSessionManager = FlutterAuthSessionManager(storage: TestStorage());

      await client.auth.updateSignedInUser(_authSuccess);

      expect(await client.auth.authHeaderValue, _authHeaderValue);
      expect(await client.authKeyProvider?.authHeaderValue, _authHeaderValue);
      expect(identical(client.authKeyProvider, client.auth), isTrue);
    },
  );

  test(
    'Given a client with authSessionManager set, '
    'when signing out, '
    'then authKeyProvider should return null.',
    () async {
      final client = Client(
        'http://localhost:8080/',
      )..authSessionManager = FlutterAuthSessionManager(storage: TestStorage());

      await client.auth.updateSignedInUser(_authSuccess);
      expect(await client.authKeyProvider?.authHeaderValue, _authHeaderValue);

      await client.auth.updateSignedInUser(null);
      expect(await client.authKeyProvider?.authHeaderValue, isNull);
    },
  );
}

final _authSuccess = AuthSuccess(
  authStrategy: AuthStrategy.session.name,
  token: 'session-key',
  authUserId: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
  scopeNames: {'test1', 'test2'},
);

const _authHeaderValue = 'Bearer session-key';
