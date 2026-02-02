import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/facebook.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  const authUsers = AuthUsers();
  final tokenManager = ServerSideSessionsTokenManager(
    config: ServerSideSessionsConfig(
      sessionKeyHashPepper: 'test-pepper',
    ),
    authUsers: authUsers,
  );

  final facebookIdp = FacebookIdp(
    const FacebookIdpConfig(
      appId: 'test-app-id',
      appSecret: 'test-app-secret',
    ),
    tokenManager: tokenManager,
    authUsers: authUsers,
  );

  withServerpod(
    'Given an existing Facebook account,',
    (final sessionBuilder, final _) {
      late Session session;
      late UuidValue authUserId;
      const userIdentifier = '12345';
      const email = 'test@example.com';

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await authUsers.create(session);
        authUserId = authUser.id;

        await FacebookAccount.db.insertRow(
          session,
          FacebookAccount(
            userIdentifier: userIdentifier,
            email: email,
            authUserId: authUserId,
          ),
        );
      });

      test(
        'when calling `FacebookIdpAdmin.findUserByFacebookUserId` with existing userIdentifier, then the auth user ID is returned.',
        () async {
          final foundUserId = await FacebookIdpAdmin.findUserByFacebookUserId(
            session,
            userIdentifier: userIdentifier,
          );

          expect(foundUserId, equals(authUserId));
        },
      );

      test(
        'when calling `FacebookIdpAdmin.findUserByFacebookUserId` with non-existing userIdentifier, then null is returned.',
        () async {
          final foundUserId = await FacebookIdpAdmin.findUserByFacebookUserId(
            session,
            userIdentifier: '99999',
          );

          expect(foundUserId, isNull);
        },
      );
    },
  );

  withServerpod(
    'Given an auth user without Facebook authentication,',
    (final sessionBuilder, final _) {
      late Session session;
      late UuidValue authUserId;
      late FacebookIdpAdmin admin;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await authUsers.create(session);
        authUserId = authUser.id;

        admin = FacebookIdpAdmin(
          utils: facebookIdp.utils,
        );
      });

      test(
        'when calling `linkFacebookAuthentication`, then a Facebook account is created.',
        () async {
          final facebookAccount = await admin.linkFacebookAuthentication(
            session,
            authUserId: authUserId,
            accountDetails: (
              userIdentifier: '54321',
              email: 'newuser@example.com',
              fullName: 'New User',
              firstName: 'New',
              lastName: 'User',
              image: Uri.tryParse('https://example.com/image.jpg'),
            ),
          );

          expect(facebookAccount.authUserId, equals(authUserId));
          expect(facebookAccount.userIdentifier, equals('54321'));
          expect(facebookAccount.email, equals('newuser@example.com'));
          expect(facebookAccount.fullName, equals('New User'));
          expect(facebookAccount.firstName, equals('New'));
          expect(facebookAccount.lastName, equals('User'));

          final foundAccount = await FacebookAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('54321'),
          );

          expect(foundAccount, isNotNull);
          expect(foundAccount!.authUserId, equals(authUserId));
        },
      );
    },
  );
}
