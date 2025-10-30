import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/profile.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:serverpod_auth_idp_server/src/providers/email/business/email_idp_server_exceptions.dart';

import 'email_idp_admin.dart';
import 'email_idp_config.dart';
import 'email_idp_utils.dart';
import 'utils/email_idp_account_creation_util.dart';

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
  static const String _method = 'email';

  /// Admin operations to work with email-backed accounts.
  late final EmailIDPAdmin admin;

  /// Utility functions for the email identity provider.
  late final EmailIDPUtils utils;

  /// The configuration for the email identity provider.
  final EmailIDPConfig config;

  final TokenManager _tokenManager;

  /// Creates a new instance of [EmailIDP].
  EmailIDP({required this.config, required final TokenManager tokenManager})
      : _tokenManager = tokenManager {
    utils = EmailIDPUtils(config: config);
    admin = EmailIDPAdmin(utils: utils);
  }

  /// {@macro email_account_base_endpoint.finish_password_reset}
  Future<AuthSuccess> finishPasswordReset(
    final Session session, {
    required final UuidValue passwordResetRequestId,
    required final String verificationCode,
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
          passwordResetRequestId: passwordResetRequestId,
          verificationCode: verificationCode,
          newPassword: newPassword,
          transaction: transaction,
        );

        await _destroyAllSessions(
          session,
          authUserId,
          transaction: transaction,
        );

        return _createSession(
          session,
          authUserId,
          transaction: transaction,
          method: _method,
        );
      }),
    );
  }

  /// {@macro email_account_base_endpoint.finish_registration}
  Future<AuthSuccess> finishRegistration(
    final Session session, {
    required final UuidValue accountRequestId,
    required final String verificationCode,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          EmailIDPUtils.withReplacedServerEmailException(() async {
        final result = await utils.accountCreation.completeAccountCreation(
          session,
          accountRequestId: accountRequestId,
          verificationCode: verificationCode,
          transaction: transaction,
        );

        await UserProfiles.createUserProfile(
          session,
          result.authUserId,
          UserProfileData(
            email: result.email,
          ),
          transaction: transaction,
        );

        return _createSession(
          session,
          result.authUserId,
          transaction: transaction,
          method: _method,
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

        return _createSession(
          session,
          authUserId,
          transaction: transaction,
          method: _method,
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
            return const Uuid().v4obj();
          }
        },
      ),
    );
  }

  /// {@macro email_account_base_endpoint.start_registration}
  Future<UuidValue> startRegistration(
    final Session session, {
    required final String email,
    required final String password,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => EmailIDPUtils.withReplacedServerEmailException(
        () async {
          final result = await utils.accountCreation.startAccountCreation(
            session,
            email: email,
            password: password,
            transaction: transaction,
          );

          // The details of the operation are intentionally not given to the caller, in order to not leak the existence of accounts.
          // Clients should always show something like "check your email to proceed with the account creation".
          // One might want to send a "password reset" in case of a "email already exists" status, to help the user log in.
          if (result.result !=
              EmailAccountRequestResult.accountRequestCreated) {
            session.log(
              'Failed to start account registration for $email, reason: ${result.result}',
              level: LogLevel.debug,
            );
          }

          // NOTE: It is necessary to keep the version of the uuid in sync with the
          // one used by the [EmailAccountRequest] model to prevent attackers from
          // using the difference on the version bit of the uuid to determine whether
          // an email is registered or not.
          return result.accountRequestId ?? const Uuid().v4obj();
        },
      ),
    );
  }

  Future<AuthSuccess> _createSession(
    final Session session,
    final UuidValue authUserId, {
    required final Transaction? transaction,
    required final String method,
  }) async {
    final authUser = await AuthUsers.get(
      session,
      authUserId: authUserId,
      transaction: transaction,
    );

    if (authUser.blocked) {
      throw AuthUserBlockedException();
    }

    final sessionKey = await _tokenManager.issueToken(
      session,
      authUserId: authUserId,
      method: method,
      scopes: authUser.scopes,
      transaction: transaction,
    );

    return sessionKey;
  }

  Future<void> _destroyAllSessions(
    final Session session,
    final UuidValue authUserId, {
    required final Transaction? transaction,
  }) async {
    await _tokenManager.revokeAllTokens(
      session,
      authUserId: authUserId,
      transaction: transaction,
      method: _method,
    );
  }
}
