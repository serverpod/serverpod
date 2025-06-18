import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given an `AuthenticationInfo` created through the `TestSessionBuilder` for an `int` user ID, ',
    (sessionBuilder, final endpoints) {
      late AuthenticationInfo? authenticationInfo;

      setUp(() async {
        final session = sessionBuilder
            .copyWith(
              authentication: AuthenticationOverride.authenticationInfo(
                123,
                {},
              ),
            )
            .build();

        authenticationInfo = await session.authenticated;
      });

      test(
        "when inspecting the legacy `userId` property, then it returns the specified value.",
        () {
          expect(authenticationInfo?.userId, 123);
        },
      );

      test(
        "when inspecting the `userIdentifier` property, then it returns the stringified value.",
        () {
          expect(authenticationInfo?.userIdentifier, '123');
        },
      );
    },
  );

  withServerpod(
    'Given an `AuthenticationInfo` created through the `TestSessionBuilder` for a `UUID` user ID, ',
    (sessionBuilder, final endpoints) {
      const uuidString = '78da5669-e934-48a2-9f90-047cc0956b9e';
      late AuthenticationInfo? authenticationInfo;

      setUp(() async {
        final uuid = UuidValue.fromString(uuidString);

        final session = sessionBuilder
            .copyWith(
              authentication: AuthenticationOverride.authenticationInfo(
                uuid,
                {},
              ),
            )
            .build();

        authenticationInfo = await session.authenticated;
      });

      test(
        "when inspecting the legacy `userId` property, then it throws.",
        () {
          expect(
            () => authenticationInfo?.userId,
            throwsA(isA<FormatException>()),
          );
        },
      );

      test(
        "when inspecting the `userIdentifier` property, then it returns the stringified value.",
        () {
          expect(authenticationInfo?.userIdentifier, uuidString);
        },
      );
    },
  );
}
