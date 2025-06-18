import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';

void main() {
  group('Given an `AuthenticationOverride` with an `int` user ID', () {
    final authenticationOverride = AuthenticationOverride.authenticationInfo(
      123,
      {},
    ) as AuthenticationInfoOverride;

    test(
      "when inspecting the `AuthenticationInfo`'s legacy `userId` property, then it returns the specified value.",
      () {
        expect(authenticationOverride.authenticationInfo.userId, 123);
      },
    );

    test(
      "when inspecting the `AuthenticationInfo`'s `userIdentifier` property, then it returns the stringified value.",
      () {
        expect(authenticationOverride.authenticationInfo.userIdentifier, '123');
      },
    );
  });

  group('Given an `AuthenticationOverride` with a `UUID` user ID', () {
    const uuidString = '78da5669-e934-48a2-9f90-047cc0956b9e';
    final uuid = UuidValue.fromString(uuidString);
    final authenticationOverride = AuthenticationOverride.authenticationInfo(
      uuid,
      {},
    ) as AuthenticationInfoOverride;

    test(
      "when inspecting the `AuthenticationInfo`'s legacy `userId` property, then it throws.",
      () {
        expect(
          () => authenticationOverride.authenticationInfo.userId,
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      "when inspecting the `AuthenticationInfo`'s `userIdentifier` property, then it returns the stringified value.",
      () {
        expect(
          authenticationOverride.authenticationInfo.userIdentifier,
          uuidString,
        );
      },
    );
  });
}
