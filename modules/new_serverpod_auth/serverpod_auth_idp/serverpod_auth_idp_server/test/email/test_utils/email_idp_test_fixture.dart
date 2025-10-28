import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/auth_user.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/src/providers/email/util/uint8list_extension.dart';

sealed class EmailAccountPassword {
  static EmailAccountPasswordHash fromPasswordHash(
      final PasswordHash passwordHash) {
    return EmailAccountPasswordHash(passwordHash);
  }

  static EmailAccountPasswordString fromString(final String password) {
    return EmailAccountPasswordString(password);
  }
}

final class EmailAccountPasswordHash extends EmailAccountPassword {
  final PasswordHash passwordHash;

  EmailAccountPasswordHash(this.passwordHash);
}

final class EmailAccountPasswordString extends EmailAccountPassword {
  final String password;

  EmailAccountPasswordString(this.password);
}

final class EmailIDPTestFixture {
  late final EmailIDPConfig config;
  late final EmailIDP emailIDP;

  final List<UuidValue> _authUserIds = [];

  EmailIDPTestFixture({
    this.config = const EmailIDPConfig(
      passwordHashPepper: 'pepper',
    ),
  }) : emailIDP = EmailIDP(config: config);

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
      null => PasswordHash.empty(),
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

  Future<AuthUserModel> createAuthUser(final Session session) async {
    final authUser = await AuthUsers.create(session);
    _authUserIds.add(authUser.id);
    return authUser;
  }

  Future<void> tearDown(final Session session) async {
    await EmailAccount.db
        .deleteWhere(session, where: (final _) => Constant.bool(true));
    await EmailAccountFailedLoginAttempt.db
        .deleteWhere(session, where: (final _) => Constant.bool(true));
    await EmailAccountPasswordResetRequest.db
        .deleteWhere(session, where: (final _) => Constant.bool(true));
    await EmailAccountPasswordResetCompleteAttempt.db
        .deleteWhere(session, where: (final _) => Constant.bool(true));
    await EmailAccountPasswordResetRequestAttempt.db
        .deleteWhere(session, where: (final _) => Constant.bool(true));
    await EmailAccountRequest.db
        .deleteWhere(session, where: (final _) => Constant.bool(true));
    await EmailAccountRequestCompletionAttempt.db
        .deleteWhere(session, where: (final _) => Constant.bool(true));

    await AuthUser.db
        .deleteWhere(session, where: (final _) => Constant.bool(true));
  }

  EmailIDPPasswordHashUtil get passwordHashUtil => emailIDP.utils.passwordHash;
  EmailIDPAuthenticationUtil get authenticationUtil =>
      emailIDP.utils.authentication;
  EmailIDPPasswordResetUtil get passwordResetUtil =>
      emailIDP.utils.passwordReset;
  EmailIDPAccountCreationUtil get accountCreationUtil =>
      emailIDP.utils.accountCreation;
}
