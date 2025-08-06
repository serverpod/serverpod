import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a user created through `AuthEmail.admin.create`,',
    (final sessionBuilder, final endpoints) {
      const email = 'test@serverpod.dev';
      const password = 'Abcdef123!!!';

      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();

        authUserId = await AuthEmail.admin.createUser(
          session,
          email: email,
          password: password,
        );
      });

      test(
          "when getting the user's profile, then it is found and the email set.",
          () async {
        final profile = await UserProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );

        expect(
          profile.email,
          email,
        );
      });

      test(
        'when using the credentials, then they work.',
        () async {
          final authenticatedUserId = await EmailAccounts.authenticate(
            session,
            email: email,
            password: password,
          );

          expect(
            authenticatedUserId,
            authUserId,
          );
        },
      );
    },
  );
}
