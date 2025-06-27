import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

void main() {
  group('Given an `AuthenticationInfo` with a UUID `userIdentifier`', () {
    final authUserId = const Uuid().v4obj();

    final authenticationInfo = AuthenticationInfo(authUserId, {});

    test('when reading the `userUuid` field, then the UUID is returned.', () {
      expect(authenticationInfo.userUuid, authUserId);
    });
  });

  group('Given an `AuthenticationInfo` with a non-UUID `userIdentifier`', () {
    final authenticationInfo = AuthenticationInfo(123, {});

    test('when reading the `userUuid` field, then it throws.', () {
      expect(
        () => authenticationInfo.userUuid,
        throwsFormatException,
      );
    });
  });
}
