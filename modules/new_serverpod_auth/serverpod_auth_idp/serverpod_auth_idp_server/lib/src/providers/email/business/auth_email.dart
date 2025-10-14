import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/profile.dart';
import 'package:serverpod_auth_core_server/session.dart';

import '../../../generated/protocol.dart';
import 'email_account_server_exceptions.dart';
import 'email_accounts.dart';

part 'auth_email_admin.dart';

/// The default implementation for the email account endpoint methods.
///
/// All public methods in here can be safely exposed to end-user clients.
///
/// Uses `serverpod_auth_session` for session management and
/// `serverpod_auth_profile` for user profiles.
abstract class AuthEmail {
  /// Collection of admin-related functions.
  static final AuthEmailAdmin admin = AuthEmailAdmin._();

  /// {@macro email_account_base_endpoint.login}
  static Future<AuthSuccess> login(
    final Session session, {
    required final String email,
    required final String password,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => _withReplacedServerEmailException(() async {
        final authUserId = await EmailAccounts.authenticate(
          session,
          email: email,
          password: password,
          transaction: transaction,
        );

        return admin.createSession(
          session,
          authUserId,
          transaction: transaction,
        );
      }),
    );
  }

  /// {@macro email_account_base_endpoint.start_registration}
  static Future<UuidValue> startRegistration(
    final Session session, {
    required final String email,
    required final String password,
    final Transaction? transaction,
  }) async {
    return await _withReplacedServerEmailException(() async {
      final result = await EmailAccounts.startAccountCreation(
        session,
        email: email,
        password: password,
        transaction: transaction,
      );

      // The details of the operation are intentionally not given to the caller, in order to not leak the existence of accounts.
      // Clients should always show something like "check your email to proceed with the account creation".
      // One might want to send a "password reset" in case of a "email already exists" status, to help the user log in.
      if (result.result != EmailAccountRequestResult.accountRequestCreated) {
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
    });
  }

  /// {@macro email_account_base_endpoint.finish_registration}
  static Future<AuthSuccess> finishRegistration(
    final Session session, {
    required final UuidValue accountRequestId,
    required final String verificationCode,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => _withReplacedServerEmailException(() async {
        final accountRequest = await EmailAccounts.verifyAccountCreation(
          session,
          accountRequestId: accountRequestId,
          verificationCode: verificationCode,
          transaction: transaction,
        );

        final newUser = await AuthUsers.create(
          session,
          transaction: transaction,
        );
        final authUserId = newUser.id;

        await UserProfiles.createUserProfile(
          session,
          authUserId,
          UserProfileData(
            email: accountRequest.email,
          ),
          transaction: transaction,
        );

        await EmailAccounts.completeAccountCreation(
          session,
          accountRequestId: accountRequestId,
          authUserId: authUserId,
          transaction: transaction,
        );

        return admin.createSession(
          session,
          authUserId,
          transaction: transaction,
        );
      }),
    );
  }

  /// {@macro email_account_base_endpoint.start_password_reset}
  static Future<UuidValue> startPasswordReset(
    final Session session, {
    required final String email,
    final Transaction? transaction,
  }) async {
    return await _withReplacedServerEmailException(() async {
      final result = await EmailAccounts.startPasswordReset(
        session,
        email: email,
        transaction: transaction,
      );

      // The details of the operation are intentionally not given to the caller, in order to not leak the existence of accounts.
      // Clients should always show something like "check your email to proceed with the password reset".
      if (result.result != PasswordResetResult.passwordResetSent) {
        session.log(
          'Failed to start password reset for $email, reason: ${result.result}',
          level: LogLevel.debug,
        );
      }

      // NOTE: It is necessary to keep the version of the uuid in sync with the
      // one used by the [EmailAccountPasswordResetRequestAttempt] model to
      // prevent attackers from using the difference on the version bit of the
      // uuid to determine whether an email is registered or not.
      return result.passwordResetRequestId ?? const Uuid().v4obj();
    });
  }

  /// {@macro email_account_base_endpoint.finish_password_reset}
  static Future<AuthSuccess> finishPasswordReset(
    final Session session, {
    required final UuidValue passwordResetRequestId,
    required final String verificationCode,
    required final String newPassword,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async => _withReplacedServerEmailException(() async {
        return await _withReplacedServerEmailException(() async {
          final authUserId = await EmailAccounts.completePasswordReset(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
            newPassword: newPassword,
            transaction: transaction,
          );

          await AuthSessions.destroyAllSessions(
            session,
            authUserId: authUserId,
            transaction: transaction,
          );

          return admin.createSession(
            session,
            authUserId,
            transaction: transaction,
          );
        });
      }),
    );
  }
}

/// Replaces server-side exceptions by client-side exceptions, hiding details
/// that could leak account information.
Future<T> _withReplacedServerEmailException<T>(
    final Future<T> Function() fn) async {
  try {
    return await fn();
  } on EmailServerException catch (e) {
    switch (e) {
      // Login
      case EmailAccountNotFoundException():
      case EmailAuthenticationInvalidCredentialsException():
        throw EmailAccountLoginException(
            reason: EmailAccountLoginExceptionReason.invalidCredentials);
      case EmailAuthenticationTooManyAttemptsException():
        throw EmailAccountLoginException(
            reason: EmailAccountLoginExceptionReason.tooManyAttempts);
      // Account creation
      case EmailAccountRequestInvalidVerificationCodeException():
      case EmailAccountRequestNotFoundException():
      case EmailAccountRequestNotVerifiedException():
      case EmailAccountRequestVerificationTooManyAttemptsException():
        throw EmailAccountRequestException(
            reason: EmailAccountRequestExceptionReason.invalid);
      case EmailPasswordPolicyViolationException():
        throw EmailAccountRequestException(
            reason: EmailAccountRequestExceptionReason.policyViolation);
      case EmailAccountRequestVerificationExpiredException():
        throw EmailAccountRequestException(
            reason: EmailAccountRequestExceptionReason.expired);
      // Password reset
      case EmailPasswordResetAccountNotFoundException():
      case EmailPasswordResetInvalidVerificationCodeException():
      case EmailPasswordResetRequestNotFoundException():
      case EmailPasswordResetTooManyAttemptsException():
      case EmailPasswordResetTooManyVerificationAttemptsException():
        throw EmailAccountPasswordResetException(
            reason: EmailAccountPasswordResetExceptionReason.invalid);
      case EmailPasswordResetPasswordPolicyViolationException():
        throw EmailAccountPasswordResetException(
            reason: EmailAccountPasswordResetExceptionReason.policyViolation);
      case EmailPasswordResetRequestExpiredException():
        throw EmailAccountPasswordResetException(
            reason: EmailAccountPasswordResetExceptionReason.expired);
    }
  }
}
