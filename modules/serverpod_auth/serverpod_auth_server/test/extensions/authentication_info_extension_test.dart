import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';

void main() {
  group('Given an `AuthenticationInfo` with an integer `userIdentifier`', () {
    final authInfo = AuthenticationInfo('123', {});

    test('when calling the `userId` helper, then `int` value is returned.', () {
      expect(authInfo.userId, 123);
    });
  });

  group(
    'Given an `AuthenticationInfo` with a non-integer `userIdentifier`',
    () {
      final authInfo = AuthenticationInfo('abc-123', {});

      test('when calling the `userId` helper, then it throws.', () {
        expect(
          () => authInfo.userId,
          throwsFormatException,
        );
      });
    },
  );
}
