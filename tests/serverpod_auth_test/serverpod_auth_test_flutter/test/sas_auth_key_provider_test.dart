import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

void main() {
  late SasAuthKeyProvider provider;
  late AuthSuccess? getAuthInfoReturn;

  setUp(() {
    provider = SasAuthKeyProvider(
      getAuthInfo: () async => getAuthInfoReturn,
    );
  });

  test('Given a SasAuthKeyProvider with no auth info available'
      'when getting auth header value '
      'then it returns null.', () async {
    getAuthInfoReturn = null;

    final result = await provider.authHeaderValue;

    expect(result, isNull);
  });

  test('Given a SasAuthKeyProvider with valid auth info available '
      'when getting auth header value '
      'then it returns Bearer token format.', () async {
    getAuthInfoReturn = _authSuccess;

    final result = await provider.authHeaderValue;

    expect(result, 'Bearer session-key');
  });
}

final _authSuccess = AuthSuccess(
  authStrategy: AuthStrategy.session.name,
  token: 'session-key',
  authUserId: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
  scopeNames: {'test1', 'test2'},
);
