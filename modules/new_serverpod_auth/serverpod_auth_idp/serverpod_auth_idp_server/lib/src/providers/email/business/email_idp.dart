import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/profile.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:serverpod_auth_idp_server/src/providers/email/business/email_idp_server_exceptions.dart';

import 'email_idp_admin.dart';
import 'email_idp_config.dart';
import 'email_idp_utils.dart';

/// Main class for the email identity provider.
/// The methods defined here are intended to be called from an endpoint.
///
/// The `admin` property provides access to [EmailIDPAdmin], which contains
/// admin-related methods for managing email-backed accounts.
///
/// The `utils` property provides access to [EmailIDPUtils], which contains
/// utility methods for working with email-backed accounts. These can be used
/// to implement custom authentication flows if needed.
///
/// If you would like to modify the authentication flow, consider creating
/// custom implementations of the relevant methods.
final class EmailIDP {
  /// The method used when authenticating with the Email identity provider.
  static const String method = 'email';

  /// Admin operations to work with email-backed accounts.
  final EmailIDPAdmin admin;

  /// Utility functions for the email identity provider.
  final EmailIDPUtils utils;

  /// The configuration for the email identity provider.
  final EmailIDPConfig config;

  final TokenManager _tokenManager;
  final AuthUsers _authUsers;
  final UserProfiles _userProfiles;

  EmailIDP._(
    this.config,
    this._authUsers,
    this._userProfiles,
    this._tokenManager,
    this.utils,
    this.admin,
  );

  /// Creates a new instance of [EmailIDP].
  factory EmailIDP(
    final EmailIDPConfig config, {
    required final TokenManager tokenManager,
    final AuthUsers authUsers = const AuthUsers(),
    final UserProfiles userProfiles = const UserProfiles(),
  }) {
    final utils = EmailIDPUtils(config: config, authUsers: authUsers);
    final admin = EmailIDPAdmin(utils: utils);
    return EmailIDP._(
      config,
      authUsers,
      userProfiles,
      tokenManager,
      utils,
      admin,
    );
  }

  /// {@macro email_account_base_endpoint.finish_password_reset}
  Future<void> finishPasswordReset(
    final Session session, {
    required final String finishPasswordResetToken,
    required final String newPassword,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          EmailIDPUtils.withReplacedServerEmailException(() async {
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
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          EmailIDPUtils.withReplacedServerEmailException(() async {
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
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          EmailIDPUtils.withReplacedServerEmailException(() async {
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
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => EmailIDPUtils.withReplacedServerEmailException(
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
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => EmailIDPUtils.withReplacedServerEmailException(
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
              case EmailAccountRequestAlreadyExistsException():
                session.log(
                  'Failed to start account registration for $email, reason: email account request already exists',
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
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => EmailIDPUtils.withReplacedServerEmailException(
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
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => EmailIDPUtils.withReplacedServerEmailException(
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
}
