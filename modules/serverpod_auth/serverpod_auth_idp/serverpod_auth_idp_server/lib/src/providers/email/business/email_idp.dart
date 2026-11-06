import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'email_idp_admin.dart';
import 'email_idp_config.dart';
import 'email_idp_server_exceptions.dart';
import 'email_idp_utils.dart';

/// Main class for the email identity provider.
/// The methods defined here are intended to be called from an endpoint.
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
    EmailIdpConfig config, {
    required TokenManager tokenManager,
    AuthUsers authUsers = const AuthUsers(),
    UserProfiles userProfiles = const UserProfiles(),
  }) {
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
    Session session, {
    required String finishPasswordResetToken,
    required String newPassword,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => EmailIdpUtils.withReplacedServerEmailException(() async {
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
    Session session, {
    required String registrationToken,
    required String password,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => EmailIdpUtils.withReplacedServerEmailException(() async {
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
    Session session, {
    required String email,
    required String password,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => EmailIdpUtils.withReplacedServerEmailException(() async {
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
    Session session, {
    required String email,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => EmailIdpUtils.withReplacedServerEmailException(
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
    Session session, {
    required String email,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => EmailIdpUtils.withReplacedServerEmailException(
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
    Session session, {
    required UuidValue accountRequestId,
    required String verificationCode,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => EmailIdpUtils.withReplacedServerEmailException(
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
    Session session, {
    required UuidValue passwordResetRequestId,
    required String verificationCode,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => EmailIdpUtils.withReplacedServerEmailException(
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

  /// {@macro email_account_base_endpoint.start_otp_login}
  Future<UuidValue> startOtpLogin(
    Session session, {
    required String email,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => EmailIdpUtils.withReplacedServerEmailException(
        () => utils.otpLogin.startOtpLogin(
          session,
          email: email,
          transaction: transaction,
        ),
      ),
    );
  }

  /// {@macro email_account_base_endpoint.verify_otp_login_code}
  Future<EmailAccountOtpVerificationResult> verifyOtpLoginCode(
    Session session, {
    required UuidValue otpLoginRequestId,
    required String verificationCode,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => EmailIdpUtils.withReplacedServerEmailException(
        () => utils.otpLogin.verifyOtpLoginCode(
          session,
          otpLoginRequestId: otpLoginRequestId,
          verificationCode: verificationCode,
          transaction: transaction,
        ),
      ),
    );
  }

  /// {@macro email_account_base_endpoint.finish_otp_login}
  Future<AuthSuccess> finishOtpLogin(
    Session session, {
    required String otpLoginToken,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => EmailIdpUtils.withReplacedServerEmailException(() async {
        final authUserId = await utils.otpLogin.completeOtpLogin(
          session,
          otpLoginToken: otpLoginToken,
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

  /// {@macro email_account_base_endpoint.finish_otp_registration}
  Future<AuthSuccess> finishOtpRegistration(
    Session session, {
    required String otpLoginToken,
    String? password,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => EmailIdpUtils.withReplacedServerEmailException(() async {
        final result = await utils.otpLogin.completeOtpRegistration(
          session,
          otpLoginToken: otpLoginToken,
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

  /// Determines whether the current session has an associated email account.
  Future<bool> hasAccount(Session session) async =>
      await utils.getAccount(session) != null;

  /// Migrates all [EmailAccount]s from [userToRemoveId] to [userToKeepId].
  @override
  Future<void> mergeAuthUsers(
    Session session, {
    required UuidValue userToKeepId,
    required UuidValue userToRemoveId,
    required Transaction transaction,
  }) async {
    await EmailAccount.db.updateWhere(
      session,
      where: (t) => t.authUserId.equals(userToRemoveId),
      columnValues: (t) => [
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
