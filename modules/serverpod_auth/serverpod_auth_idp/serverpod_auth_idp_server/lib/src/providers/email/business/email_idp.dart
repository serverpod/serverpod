import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'email_idp_admin.dart';
import 'email_idp_config.dart';
import 'email_idp_server_exceptions.dart';
import 'email_idp_utils.dart';

/// Main class for the email identity provider.
/// The methods defined here are intended to be called from an endpoint.
///
/// Users log in either with a password ([login], with the registration and
/// password reset flows), or without one, with a verification code sent to
/// their email address ([startPasswordlessLogin] and
/// [finishPasswordlessLogin]). Each way can be enabled on its own through
/// [EmailIdpConfig.password] and [EmailIdpConfig.passwordless]. The methods of
/// a disabled way fail with the `unknown` reason of their exception. Both ways
/// use the same email accounts, and sessions of both are issued with the
/// [method] `email`, so a password reset revokes them all.
///
/// The `admin` property provides access to [EmailIdpAdmin], which contains
/// admin-related methods for managing email-backed accounts.
///
/// The `utils` property provides access to [EmailIdpUtils], which contains
/// utility methods for working with email-backed accounts. These can be used
/// to implement custom authentication flows if needed.
///
/// If you would like to modify the authentication flow, consider creating
/// custom implementations of the relevant methods.
class EmailIdp implements IdentityProvider {
  /// The method used when authenticating with the Email identity provider.
  @override
  String get method => 'email';

  /// Admin operations to work with email-backed accounts.
  final EmailIdpAdmin admin;

  /// Utility functions for the email identity provider.
  final EmailIdpUtils utils;

  /// The configuration for the email identity provider.
  final EmailIdpConfig config;

  final TokenManager _tokenManager;
  final AuthUsers _authUsers;
  final UserProfiles _userProfiles;

  EmailIdp._(
    this.config,
    this._authUsers,
    this._userProfiles,
    this._tokenManager,
    this.utils,
    this.admin,
  );

  /// Creates a new instance of [EmailIdp].
  factory EmailIdp(
    final EmailIdpConfig config, {
    required final TokenManager tokenManager,
    final AuthUsers authUsers = const AuthUsers(),
    final UserProfiles userProfiles = const UserProfiles(),
  }) {
    config.validate();
    final utils = EmailIdpUtils(config: config, authUsers: authUsers);
    final admin = EmailIdpAdmin(utils: utils);
    return EmailIdp._(
      config,
      authUsers,
      userProfiles,
      tokenManager,
      utils,
      admin,
    );
  }

  /// {@macro email_account_base_endpoint.finish_password_reset}
  Future<UuidValue> finishPasswordReset(
    final Session session, {
    required final String finishPasswordResetToken,
    required final String newPassword,
    final Transaction? transaction,
  }) async {
    _requirePasswordLogin(
      session,
      () => EmailAccountPasswordResetException(
        reason: EmailAccountPasswordResetExceptionReason.unknown,
      ),
    );

    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          EmailIdpUtils.withReplacedServerEmailException(() async {
            final authUserId = await utils.passwordReset.completePasswordReset(
              session,
              completePasswordResetToken: finishPasswordResetToken,
              newPassword: newPassword,
              transaction: transaction,
            );

            await _tokenManager.revokeAllTokens(
              session,
              authUserId: authUserId,
              method: method,
              transaction: transaction,
            );

            return authUserId;
          }),
    );
  }

  /// {@macro email_account_base_endpoint.finish_registration}
  Future<AuthSuccess> finishRegistration(
    final Session session, {
    required final String registrationToken,
    required final String password,
    final Transaction? transaction,
  }) async {
    _requirePasswordLogin(
      session,
      () => EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.unknown,
      ),
    );

    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          EmailIdpUtils.withReplacedServerEmailException(() async {
            final result = await utils.accountCreation.completeAccountCreation(
              session,
              completeAccountCreationToken: registrationToken,
              password: password,
              transaction: transaction,
            );

            await _userProfiles.createUserProfile(
              session,
              result.authUserId,
              UserProfileData(
                email: result.email,
              ),
              transaction: transaction,
            );

            return _tokenManager.issueToken(
              session,
              authUserId: result.authUserId,
              method: method,
              scopes: result.scopes,
              transaction: transaction,
            );
          }),
    );
  }

  /// {@macro email_account_base_endpoint.login}
  Future<AuthSuccess> login(
    final Session session, {
    required final String email,
    required final String password,
    final Transaction? transaction,
  }) async {
    _requirePasswordLogin(
      session,
      () => EmailAccountLoginException(
        reason: EmailAccountLoginExceptionReason.unknown,
      ),
    );

    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          EmailIdpUtils.withReplacedServerEmailException(() async {
            final authUserId = await utils.authentication.authenticate(
              session,
              email: email,
              password: password,
              transaction: transaction,
            );

            final authUser = await _authUsers.get(
              session,
              authUserId: authUserId,
              transaction: transaction,
            );

            return _tokenManager.issueToken(
              session,
              authUserId: authUserId,
              method: method,
              scopes: authUser.scopes,
              transaction: transaction,
            );
          }),
    );
  }

  /// {@macro email_account_base_endpoint.start_password_reset}
  Future<UuidValue> startPasswordReset(
    final Session session, {
    required final String email,
    final Transaction? transaction,
  }) async {
    _requirePasswordLogin(
      session,
      () => EmailAccountPasswordResetException(
        reason: EmailAccountPasswordResetExceptionReason.unknown,
      ),
    );

    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => EmailIdpUtils.withReplacedServerEmailException(
        () async {
          try {
            return await utils.passwordReset.startPasswordReset(
              session,
              email: email,
              transaction: transaction,
            );
          } on EmailPasswordResetEmailNotFoundException catch (_) {
            // The details of the operation are intentionally not given to the caller, in order to not leak the existence of accounts.
            // Clients should always show something like "check your email to proceed with the password reset".
            session.log(
              'Failed to start password reset for $email, reason: email does not exist',
              level: LogLevel.debug,
            );

            // NOTE: It is necessary to keep the version of the uuid in sync with the
            // one used by the [EmailAccountPasswordResetRequestAttempt] model to
            // prevent attackers from using the difference on the version bit of the
            // uuid to determine whether an email is registered or not.
            return const Uuid().v7obj();
          }
        },
      ),
    );
  }

  /// {@macro email_account_base_endpoint.start_registration}
  Future<UuidValue> startRegistration(
    final Session session, {
    required final String email,
    final Transaction? transaction,
  }) async {
    _requirePasswordLogin(
      session,
      () => EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.unknown,
      ),
    );

    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => EmailIdpUtils.withReplacedServerEmailException(
        () async {
          try {
            return await utils.accountCreation.startRegistration(
              session,
              email: email,
              transaction: transaction,
            );
          } on EmailAccountRequestServerException catch (e) {
            // The details of these operation are intentionally not given to the caller, in order to not leak the existence of accounts.
            // Clients should always show something like "check your email to proceed with the account creation".
            // One might want to send a "password reset" in case of a "email already exists" exception, to help the user log in.
            switch (e) {
              case EmailAccountAlreadyRegisteredException():
                session.log(
                  'Failed to start account registration for $email, reason: email already registered',
                  level: LogLevel.debug,
                );
                break;
              default:
                rethrow;
            }

            // NOTE: It is necessary to keep the version of the uuid in sync with the
            // one used by the [EmailAccountRequest] model to prevent attackers from
            // using the difference on the version bit of the uuid to determine whether
            // an email is registered or not.
            return const Uuid().v7obj();
          }
        },
      ),
    );
  }

  /// {@macro email_account_base_endpoint.verify_registration_code}
  Future<String> verifyRegistrationCode(
    final Session session, {
    required final UuidValue accountRequestId,
    required final String verificationCode,
    final Transaction? transaction,
  }) async {
    _requirePasswordLogin(
      session,
      () => EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.unknown,
      ),
    );

    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => EmailIdpUtils.withReplacedServerEmailException(
        () async {
          return await utils.accountCreation.verifyRegistrationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          );
        },
      ),
    );
  }

  /// {@macro email_account_base_endpoint.verify_password_reset_code}
  Future<String> verifyPasswordResetCode(
    final Session session, {
    required final UuidValue passwordResetRequestId,
    required final String verificationCode,
    final Transaction? transaction,
  }) async {
    _requirePasswordLogin(
      session,
      () => EmailAccountPasswordResetException(
        reason: EmailAccountPasswordResetExceptionReason.unknown,
      ),
    );

    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => EmailIdpUtils.withReplacedServerEmailException(
        () async {
          return await utils.passwordReset.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          );
        },
      ),
    );
  }

  /// {@macro email_idp_base_endpoint.start_passwordless_login}
  ///
  /// This manages its own transactions and must not be called from within one,
  /// so that rate limiting does not hold two connections of the pool at once.
  /// The code is sent after the login request has been committed.
  Future<UuidValue> startPasswordlessLogin(
    final Session session, {
    required final String email,
  }) async {
    _requirePasswordlessLogin(session);

    return EmailIdpUtils.withReplacedServerEmailException(
      () => utils.passwordlessLogin.startLogin(session, email: email),
    );
  }

  /// {@macro email_idp_base_endpoint.finish_passwordless_login}
  ///
  /// The verification code is consumed in a transaction of its own that is
  /// committed before the account is resolved, so that a code can only be used
  /// once, and failed attempts are counted whatever happens later. The optional
  /// [transaction] is only used for the account resolution and the issuing of
  /// the token. If one of those fails, including the hooks of the
  /// configuration, the code stays consumed and the user has to request a new
  /// one.
  ///
  /// If the account is created concurrently by something else, the account
  /// resolution is retried once, which then logs in to the existing account.
  /// If that fails as well, the login fails as with an invalid code.
  Future<AuthSuccess> finishPasswordlessLogin(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
    final Transaction? transaction,
  }) async {
    _requirePasswordlessLogin(session);

    return EmailIdpUtils.withReplacedServerEmailException(() async {
      final email = await utils.passwordlessLogin.verifyLoginCode(
        session,
        loginRequestId: loginRequestId,
        verificationCode: verificationCode,
      );

      Future<AuthSuccess> resolveAccount() =>
          DatabaseUtil.runInTransactionOrSavepoint(
            session.db,
            transaction,
            (final transaction) => _passwordlessLoginOrSignUp(
              session,
              email: email,
              transaction: transaction,
            ),
          );

      try {
        return await resolveAccount();
      } on DatabaseUniqueViolationException {
        try {
          return await resolveAccount();
        } on DatabaseUniqueViolationException {
          throw EmailPasswordlessLoginRequestNotFoundException();
        }
      }
    });
  }

  Future<AuthSuccess> _passwordlessLoginOrSignUp(
    final Session session, {
    required final String email,
    required final Transaction transaction,
  }) async {
    final passwordlessConfig = config.passwordless!;

    var emailAccount = await EmailAccount.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );

    final accountCreated = emailAccount == null;
    final Set<Scope> scopes;

    if (emailAccount == null) {
      if (!passwordlessConfig.allowSignUp) {
        throw EmailPasswordlessSignUpNotAllowedException();
      }

      await passwordlessConfig.onBeforeAccountCreated?.call(
        session,
        email: email,
        transaction: transaction,
      );

      final newUser = await _authUsers.create(
        session,
        transaction: transaction,
      );

      emailAccount = await utils.account.createAccount(
        session,
        authUserId: newUser.id,
        email: email,
        transaction: transaction,
      );

      await _userProfiles.createUserProfile(
        session,
        newUser.id,
        UserProfileData(email: email),
        transaction: transaction,
      );

      await config.onAfterAccountCreated?.call(
        session,
        email: emailAccount.email,
        authUserId: emailAccount.authUserId,
        emailAccountId: emailAccount.id!,
        transaction: transaction,
      );

      scopes = newUser.scopes;
    } else {
      final authUser = await _authUsers.get(
        session,
        authUserId: emailAccount.authUserId,
        transaction: transaction,
      );

      if (authUser.blocked) {
        throw AuthUserBlockedException();
      }

      scopes = authUser.scopes;
    }

    await passwordlessConfig.onAfterLogin?.call(
      session,
      email: emailAccount.email,
      authUserId: emailAccount.authUserId,
      emailAccountId: emailAccount.id!,
      accountCreated: accountCreated,
      transaction: transaction,
    );

    return _tokenManager.issueToken(
      session,
      authUserId: emailAccount.authUserId,
      method: method,
      scopes: scopes,
      transaction: transaction,
    );
  }

  /// Throws the exception created by [disabledException] if the password
  /// login is disabled.
  void _requirePasswordLogin(
    final Session session,
    final Exception Function() disabledException,
  ) {
    if (utils.passwordLoginEnabled) return;

    session.log(
      'The password login of the email IdP was called, but it is disabled.',
      level: LogLevel.warning,
    );
    throw disabledException();
  }

  /// Throws an [EmailPasswordlessLoginException] if the passwordless login is
  /// disabled.
  void _requirePasswordlessLogin(final Session session) {
    if (utils.passwordlessLoginEnabled) return;

    session.log(
      'The passwordless login of the email IdP was called, but it is disabled.',
      level: LogLevel.warning,
    );
    throw EmailPasswordlessLoginException(
      reason: EmailPasswordlessLoginExceptionReason.unknown,
    );
  }

  /// Determines whether the current session has an associated email account.
  Future<bool> hasAccount(final Session session) async =>
      await utils.getAccount(session) != null;

  /// Migrates all [EmailAccount]s from [userToRemoveId] to [userToKeepId].
  @override
  Future<void> mergeAuthUsers(
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    required final Transaction transaction,
  }) async {
    await EmailAccount.db.updateWhere(
      session,
      where: (final t) => t.authUserId.equals(userToRemoveId),
      columnValues: (final t) => [
        t.authUserId(userToKeepId),
      ],
      transaction: transaction,
    );
  }
}

/// Extension to get the EmailIdp instance from the AuthServices.
extension EmailIdpGetter on AuthServices {
  /// Returns the EmailIdp instance from the AuthServices.
  EmailIdp get emailIdp => AuthServices.getIdentityProvider<EmailIdp>();
}
