import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/src/utils/uint8list_extension.dart';

sealed class EmailAccountPassword {
  static EmailAccountPasswordHash fromPasswordHash(
    final HashResult passwordHash,
  ) {
    return EmailAccountPasswordHash(passwordHash);
  }

  static EmailAccountPasswordString fromString(final String password) {
    return EmailAccountPasswordString(password);
  }
}

final class EmailAccountPasswordHash extends EmailAccountPassword {
  final HashResult passwordHash;

  EmailAccountPasswordHash(this.passwordHash);
}

final class EmailAccountPasswordString extends EmailAccountPassword {
  final String password;

  EmailAccountPasswordString(this.password);
}

final class EmailIDPTestFixture {
  late final EmailIDP emailIDP;
  late final TokenManager tokenManager;
  final UserProfiles userProfiles = const UserProfiles();
  final AuthUsers authUsers = const AuthUsers();

  EmailIDPTestFixture({
    final EmailIDPConfig config = const EmailIDPConfig(
      secretHashPepper: 'pepper',
    ),
    TokenManager? tokenManager,
  }) {
    tokenManager ??= AuthServices(
      authUsers: authUsers,
      userProfiles: userProfiles,
      primaryTokenManager: AuthSessionsTokenManagerFactory(
        AuthSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
      ),
      identityProviders: [],
    ).tokenManager;

    // Analyzer incorrectly suggests this should be initialized in the
    // constructor.
    // ignore: prefer_initializing_formals
    this.tokenManager = tokenManager;
    emailIDP = EmailIDP(config, tokenManager: tokenManager);
  }

  Future<EmailAccount> createEmailAccount(
    final Session session, {
    required final UuidValue authUserId,
    required final String email,
    final EmailAccountPassword? password,
  }) async {
    final passwordHash = switch (password) {
      final EmailAccountPasswordHash password => password.passwordHash,
      final EmailAccountPasswordString password =>
        await passwordHashUtil.createHash(value: password.password),
      null => HashResult.empty(),
    };

    return await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        authUserId: authUserId,
        email: email.toLowerCase().trim(),
        passwordHash: passwordHash.hash.asByteData,
        passwordSalt: passwordHash.salt.asByteData,
      ),
    );
  }

  Future<void> tearDown(final Session session) async {
    await EmailAccount.db.deleteWhere(
      session,
      where: (final _) => Constant.bool(true),
    );
    await EmailAccountFailedLoginAttempt.db.deleteWhere(
      session,
      where: (final _) => Constant.bool(true),
    );
    await EmailAccountPasswordResetRequest.db.deleteWhere(
      session,
      where: (final _) => Constant.bool(true),
    );
    await EmailAccountPasswordResetCompleteAttempt.db.deleteWhere(
      session,
      where: (final _) => Constant.bool(true),
    );
    await EmailAccountPasswordResetRequestAttempt.db.deleteWhere(
      session,
      where: (final _) => Constant.bool(true),
    );
    await EmailAccountRequest.db.deleteWhere(
      session,
      where: (final _) => Constant.bool(true),
    );
    await EmailAccountRequestCompletionAttempt.db.deleteWhere(
      session,
      where: (final _) => Constant.bool(true),
    );

    await AuthUser.db.deleteWhere(
      session,
      where: (final _) => Constant.bool(true),
    );
  }

  SecretHashUtil get passwordHashUtil => emailIDP.utils.hashUtil;
  EmailIDPAuthenticationUtil get authenticationUtil =>
      emailIDP.utils.authentication;
  EmailIDPPasswordResetUtil get passwordResetUtil =>
      emailIDP.utils.passwordReset;
  EmailIDPAccountCreationUtil get accountCreationUtil =>
      emailIDP.utils.accountCreation;
  EmailIDPConfig get config => emailIDP.config;
}
