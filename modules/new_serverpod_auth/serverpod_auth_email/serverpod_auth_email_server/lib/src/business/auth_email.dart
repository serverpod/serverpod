import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';

/// The default implementation for the email account endpoint methods.
///
/// All public methods in here can be safely exposed to end-user clients.
///
/// Uses `serverpod_auth_session` for session management and
/// `serverpod_auth_profile` for user profiles.
abstract class AuthEmail {
  static const String _method = 'email';

  /// {@macro email_account_base_endpoint.login}
  static Future<AuthSuccess> login(
    final Session session, {
    required final String email,
    required final String password,
  }) async {
    final authUserId = await EmailAccounts.login(
      session,
      email: email,
      password: password,
    );

    return _createSession(session, authUserId);
  }

  /// {@macro email_account_base_endpoint.start_registration}
  static Future<void> startRegistration(
    final Session session, {
    required final String email,
    required final String password,
  }) async {
    final result = await EmailAccounts.startAccountCreation(
      session,
      email: email,
      password: password,
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
  }

  /// {@macro email_account_base_endpoint.finish_registration}
  static Future<AuthSuccess> finishRegistration(
    final Session session, {
    required final UuidValue accountRequestId,
    required final String verificationCode,
  }) async {
    return session.db.transaction((final transaction) async {
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

      return _createSession(session, authUserId, transaction: transaction);
    });
  }

  /// {@macro email_account_base_endpoint.start_password_reset}
  static Future<void> startPasswordReset(
    final Session session, {
    required final String email,
  }) async {
    final result = await EmailAccounts.startPasswordReset(
      session,
      email: email,
    );

    // The details of the operation are intentionally not given to the caller, in order to not leak the existence of accounts.
    // Clients should always show something like "check your email to proceed with the password reset".
    if (result != PasswordResetResult.passwordResetSent) {
      session.log(
        'Failed to start password reset for $email, reason: $result',
        level: LogLevel.debug,
      );
    }
  }

  /// {@macro email_account_base_endpoint.finish_password_reset}
  static Future<AuthSuccess> finishPasswordReset(
    final Session session, {
    required final UuidValue passwordResetRequestId,
    required final String verificationCode,
    required final String newPassword,
  }) async {
    final authUserId = await EmailAccounts.completePasswordReset(
      session,
      passwordResetRequestId: passwordResetRequestId,
      verificationCode: verificationCode,
      newPassword: newPassword,
    );

    await AuthSessions.destroyAllSessions(session, authUserId: authUserId);

    return _createSession(
      session,
      authUserId,
    );
  }

  static Future<AuthSuccess> _createSession(
    final Session session,
    final UuidValue authUserId, {
    final Transaction? transaction,
  }) async {
    final authUser = await AuthUsers.get(
      session,
      authUserId: authUserId,
      transaction: transaction,
    );

    if (authUser.blocked) {
      throw AuthUserBlockedException();
    }

    final sessionKey = await AuthSessions.createSession(
      session,
      authUserId: authUserId,
      method: _method,
      scopes: authUser.scopes,
      transaction: transaction,
    );

    return sessionKey;
  }
}
