import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';

final class AnonymousIdpTestFixture {
  late final AnonymousIdp anonymousIdp;
  late final TokenManager tokenManager;
  final UserProfiles userProfiles = const UserProfiles();
  final AuthUsers defaultAuthUsers = const AuthUsers();

  AnonymousIdpTestFixture({
    AnonymousIdpConfig? config,
    TokenManager? tokenManager,
    AuthUsersConfig? authUsersConfig,
  }) {
    config ??= const AnonymousIdpConfig();
    authUsersConfig ??= const AuthUsersConfig();
    final authUsers = AuthUsers(config: authUsersConfig);
    this.tokenManager =
        tokenManager ??
        AuthServices(
          authUsers: authUsers,
          userProfiles: userProfiles,
          primaryTokenManagerBuilder: ServerSideSessionsConfig(
            sessionKeyHashPepper: 'test-pepper',
          ),
          identityProviderBuilders: [],
        ).tokenManager;

    anonymousIdp = config.build(
      tokenManager: this.tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }

  Future<void> tearDown(Session session) async {
    await session.db.transaction((transaction) async {
      await Future.wait([
        AnonymousAccount.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
          transaction: transaction,
        ),
        RateLimitedRequestAttempt.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
          transaction: transaction,
        ),
        AuthUser.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
          transaction: transaction,
        ),
      ]);
    });
  }
}
