import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

sealed class EmailAccountPassword {
  static EmailAccountPasswordHash fromPasswordHash(
    final String passwordHash,
  ) {
    return EmailAccountPasswordHash(passwordHash);
  }

  static EmailAccountPasswordString fromString(final String password) {
    return EmailAccountPasswordString(password);
  }
}

final class EmailAccountPasswordHash extends EmailAccountPassword {
  final String passwordHash;

  EmailAccountPasswordHash(this.passwordHash);
}

final class EmailAccountPasswordString extends EmailAccountPassword {
  final String password;

  EmailAccountPasswordString(this.password);
}

final class EmailIdpTestFixture {
  late final EmailIdp emailIdp;
  late final TokenManager tokenManager;
  final UserProfiles userProfiles = const UserProfiles();
  final AuthUsers authUsers = const AuthUsers();

  EmailIdpTestFixture({
    final EmailIdpConfig config = const EmailIdpConfig(
      secretHashPepper: 'pepper',
    ),
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
    emailIdp = EmailIdp(config, tokenManager: tokenManager);
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
        await passwordHashUtil.createHashFromString(secret: password.password),
      null => '',
    };

    return await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        authUserId: authUserId,
        email: email.toLowerCase().trim(),
        passwordHash: passwordHash,
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

  Argon2HashUtil get passwordHashUtil => emailIdp.utils.hashUtil;
  EmailIdpAuthenticationUtil get authenticationUtil =>
      emailIdp.utils.authentication;
  EmailIdpPasswordResetUtil get passwordResetUtil =>
      emailIdp.utils.passwordReset;
  EmailIdpAccountCreationUtil get accountCreationUtil =>
      emailIdp.utils.accountCreation;
  EmailIdpConfig get config => emailIdp.config;
}
