import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/passwordless.dart';

final class PasswordlessIdpTestFixture {
  late final PasswordlessIdp passwordlessIdp;
  late final TokenManager tokenManager;
  final AuthUsers authUsers = const AuthUsers();
  final UserProfiles userProfiles = const UserProfiles();

  PasswordlessIdpTestFixture({
    required final PasswordlessIdpConfig config,
    TokenManager? tokenManager,
  }) {
    tokenManager ??= AuthServices(
      authUsers: authUsers,
      userProfiles: userProfiles,
      primaryTokenManagerBuilder: ServerSideSessionsConfig(
        sessionKeyHashPepper: 'test-pepper',
      ),
      identityProviderBuilders: [],
    ).tokenManager;

    // Analyzer incorrectly suggests this should be initialized in the
    // constructor.
    // ignore: prefer_initializing_formals
    this.tokenManager = tokenManager;
    passwordlessIdp = PasswordlessIdp(
      config,
      tokenManager: tokenManager,
      authUsers: authUsers,
    );
  }

  Future<void> tearDown(final Session session) async {
    await session.db.transaction((final transaction) async {
      await Future.wait([
        PasswordlessLoginRequest.db.deleteWhere(
          session,
          where: (final _) => Constant.bool(true),
          transaction: transaction,
        ),
        RateLimitedRequestAttempt.db.deleteWhere(
          session,
          where: (final t) => t.domain.equals('passwordless'),
          transaction: transaction,
        ),
        SecretChallenge.db.deleteWhere(
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
