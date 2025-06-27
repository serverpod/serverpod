import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:test/test.dart';

void main() {
  final authUserId = const Uuid().v4obj();

  group('Given an `AuthenticationInfo` with a UUID `authId`', () {
    final authId = const Uuid().v4obj();

    final authenticationInfo = AuthenticationInfo(
      authUserId,
      {},
      authId: authId.uuid,
    );

    test('when reading the `authSessionId` field, then the UUID is returned.',
        () {
      expect(authenticationInfo.authSessionId, authId);
    });
  });

  group('Given an `AuthenticationInfo` with a `null` `authId`', () {
    final authenticationInfo = AuthenticationInfo(
      authUserId,
      {},
      authId: null,
    );

    test('when reading the `authSessionId` field, then it throws.', () {
      expect(
        () => authenticationInfo.authSessionId,
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('Given an `AuthenticationInfo` with a non-UUID `authId`', () {
    final authenticationInfo = AuthenticationInfo(
      123,
      {},
      authId: 'foo-bar',
    );

    test('when reading the `authSessionId` field, then it throws.', () {
      expect(
        () => authenticationInfo.authSessionId,
        throwsFormatException,
      );
    });
  });
}
