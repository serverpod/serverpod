import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';

/// Endpoint for email based accounts
abstract class EmailAccountEndpoint extends Endpoint {
  static const String _method = 'email';

  /// Logs in the user and returns a session key.
  ///
  /// In case an expected error occurs, this throws a `EmailAccountLoginException`.
  Future<String> login(
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

  /// Starts the registration for a new user account with an email-based login associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to complete the registration.
  Future<void> startRegistration(
    final Session session, {
    required final String email,
    required final String password,
  }) async {
    await EmailAccounts.startAccountCreation(
      session,
      email: email,
      password: password,
    );
  }

  /// Completes a new account registration, creating a new auth user with a profile and attaching the given email account to it.
  ///
  /// Returns the session key for the new session.
  Future<String> finishRegistration(
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

      return _createSession(session, authUserId);
    });
  }

  /// Requests a password reset for [email].
  Future<void> startPasswordReset(
    final Session session, {
    required final String email,
  }) async {
    await EmailAccounts.startPasswordReset(session, email: email);
  }

  /// Completes a password reset request by setting a new password.
  ///
  /// If the reset was successful, a new session key is returned.
  ///
  /// Destroys all active sessions of the user.
  Future<String> finishPasswordReset(
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

    return _createSession(session, authUserId);
  }

  Future<String> _createSession(
    final Session session,
    final UuidValue authUserId,
  ) async {
    final authUser = await AuthUsers.get(
      session,
      authUserId: authUserId,
    );

    if (authUser.blocked) {
      throw AuthUserBlockedException();
    }

    final sessionKey = await AuthSessions.createSession(
      session,
      authUserId: authUserId,
      method: _method,
      scopes: authUser.scopes,
    );

    return sessionKey;
  }
}
