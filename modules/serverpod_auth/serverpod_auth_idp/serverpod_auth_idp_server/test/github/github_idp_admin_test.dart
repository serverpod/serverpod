import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/github.dart';
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

  final githubIdp = GitHubIdp(
    GitHubIdpConfig(
      clientId: 'test-client-id',
      clientSecret: 'test-client-secret',
    ),
    tokenIssuer: tokenManager,
    authUsers: authUsers,
  );

  withServerpod(
    'Given an existing GitHub account,',
    (final sessionBuilder, final _) {
      late Session session;
      late UuidValue authUserId;
      const userIdentifier = '12345';
      const email = 'test@example.com';

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await authUsers.create(session);
        authUserId = authUser.id;

        await GitHubAccount.db.insertRow(
          session,
          GitHubAccount(
            userIdentifier: userIdentifier,
            email: email,
            authUserId: authUserId,
          ),
        );
      });

      test(
        'when calling `GitHubIdpAdmin.findUserByGitHubUserId` with existing userIdentifier, then the auth user ID is returned.',
        () async {
          final foundUserId = await GitHubIdpAdmin.findUserByGitHubUserId(
            session,
            userIdentifier: userIdentifier,
          );

          expect(foundUserId, equals(authUserId));
        },
      );

      test(
        'when calling `GitHubIdpAdmin.findUserByGitHubUserId` with non-existing userIdentifier, then null is returned.',
        () async {
          final foundUserId = await GitHubIdpAdmin.findUserByGitHubUserId(
            session,
            userIdentifier: '99999',
          );

          expect(foundUserId, isNull);
        },
      );
    },
  );

  withServerpod(
    'Given an auth user without GitHub authentication,',
    (final sessionBuilder, final _) {
      late Session session;
      late UuidValue authUserId;
      late GitHubIdpAdmin admin;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await authUsers.create(session);
        authUserId = authUser.id;

        admin = GitHubIdpAdmin(
          utils: githubIdp.utils,
        );
      });

      test(
        'when calling `linkGitHubAuthentication`, then a GitHub account is created.',
        () async {
          final githubAccount = await admin.linkGitHubAuthentication(
            session,
            authUserId: authUserId,
            accountDetails: (
              userIdentifier: '54321',
              email: 'newuser@example.com',
              name: 'New User',
              image: null,
            ),
          );

          expect(githubAccount.authUserId, equals(authUserId));
          expect(githubAccount.userIdentifier, equals('54321'));
          expect(githubAccount.email, equals('newuser@example.com'));

          final foundAccount = await GitHubAccount.db.findFirstRow(
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
