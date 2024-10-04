import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given calling `copyWith` on the session',
    (endpoints, session) {
      group('when setting a new shared session on the group level', () {
        TestSession modifiedSession = session.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            123,
            {},
          ),
        );

        test(
            'then the first test gets the modifiedSession according to the group assignment',
            () async {
          await expectLater(
            modifiedSession.authenticationInfo,
            completion((a) => a.userId == 123),
          );
        });
        test(
            'then the second test gets the modifiedSession according to the group assignment',
            () async {
          await expectLater(
            modifiedSession.authenticationInfo,
            completion((a) => a.userId == 123),
          );
        });
      });

      group(
          'when setting a new shared session on the group level '
          'and copying the session in the first test', () {
        TestSession modifiedSession = session.copyWith(
          authentication: AuthenticationOverride.unauthenticated(),
        );

        test('then the first test can change it', () async {
          modifiedSession = session.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              123,
              {},
            ),
          );

          await expectLater(
            modifiedSession.authenticationInfo,
            completion((a) => a.userId == 123),
          );
        });

        test(
            'then the second test gets the modifiedSession according to the first test',
            () async {
          await expectLater(
            modifiedSession.authenticationInfo,
            completion((a) => a.userId == 123),
          );
        });
      });
    },
    runMode: ServerpodRunMode.production,
  );
}
