import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given calling `copyWith` on the session builder',
    (sessionBuilder, endpoints) {
      group('when setting a new shared session builder on the group level', () {
        TestSessionBuilder modifiedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            123,
            {},
          ),
        );

        test(
            'then the first test gets the modifiedSessionBuilder according to the group assignment',
            () async {
          await expectLater(
            modifiedSessionBuilder.build().authenticated,
            completion((a) => a.userId == 123),
          );
        });
        test(
            'then the second test gets the modifiedSessionBuilder according to the group assignment',
            () async {
          await expectLater(
            modifiedSessionBuilder.build().authenticated,
            completion((a) => a.userId == 123),
          );
        });
      });

      group(
          'when setting a new shared session builder on the group level '
          'and copying the session builder in the first test', () {
        TestSessionBuilder modifiedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.unauthenticated(),
        );

        test('then the first test can change it', () async {
          modifiedSessionBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              123,
              {},
            ),
          );

          await expectLater(
            modifiedSessionBuilder.build().authenticated,
            completion((a) => a.userId == 123),
          );
        });

        test(
            'then the second test gets the modifiedSessionBuilder according to the first test',
            () async {
          await expectLater(
            modifiedSessionBuilder.build().authenticated,
            completion((a) => a.userId == 123),
          );
        });
      });
    },
    runMode: ServerpodRunMode.production,
  );
}
