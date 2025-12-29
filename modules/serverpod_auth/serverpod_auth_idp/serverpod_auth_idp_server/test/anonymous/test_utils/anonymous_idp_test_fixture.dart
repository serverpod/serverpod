import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';

final class AnonymousIdpTestFixture {
  late final AnonymousIdp anonymousIdp;
  late final TokenManager tokenManager;
  final UserProfiles userProfiles = const UserProfiles();
  final AuthUsers authUsers = const AuthUsers();

  AnonymousIdpTestFixture({
    final AnonymousIdpConfig config = const AnonymousIdpConfig(),
    final TokenManager? tokenManager,
  }) {
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

    anonymousIdp = AnonymousIdp(config, tokenManager: this.tokenManager);
  }

  Future<void> tearDown(final Session session) async {
    await session.db.transaction((final transaction) async {
      await Future.wait([
        AnonymousAccount.db.deleteWhere(
          session,
          where: (final _) => Constant.bool(true),
          transaction: transaction,
        ),
        RateLimitedRequestAttempt.db.deleteWhere(
          session,
          where: (final _) => Constant.bool(true),
          transaction: transaction,
        ),
        AuthUser.db.deleteWhere(
          session,
          where: (final _) => Constant.bool(true),
          transaction: transaction,
        ),
      ]);
    });
  }
}
