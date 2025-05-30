import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';

/// Endpoint for email based accounts
@doNotGenerate
class EmailAccountEndpoint extends Endpoint {
  static const String _method = 'email';

  /// Returns the session key for the user with the given credentials.
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

  /// Starts the registration for an email based account.
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

  /// Completes the email account registration.
  ///
  /// In case the given [session] belongs to a logged-in user,
  /// the email account will be added as an authentication method for that user.
  ///
  /// If the [session] belongs to a guest, a new auth user account and profile will
  /// be created.
  ///
  /// Returns the session key for the new session.
  Future<String> finishRegistration(
    final Session session, {
    required final UuidValue accountRequestId,
    required final String verificationCode,
  }) async {
    return session.db.transaction((final transaction) async {
      // TODO: Once all base packages are merged together, do this in a single transaction
      final accountRequest = await EmailAccounts.verifyAccountCreation(
        session,
        accountRequestId: accountRequestId,
        verificationCode: verificationCode,
        transaction: transaction,
      );
      if (accountRequest == null) {
        throw EmailAccountRequestNotFoundException();
      }

      // consolidation via the profile has been removed for now, replace with look up across modules
      const UserProfileModel? existingUserWithEmail = null;
      //     await UserProfiles.maybeFindUserProfileByEmail(
      //   session,
      //   accountRequest.email,
      // );

      final authenticationInfo = await session.authenticated;

      final UuidValue authUserId;
      if (authenticationInfo != null) {
        authUserId = authenticationInfo.authSessionId;
      } else if (existingUserWithEmail != null) {
        authUserId = existingUserWithEmail.authUserId;
      } else {
        final newUser = await AuthUser.db.insertRow(
          session,
          AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
          transaction: transaction,
        );
        authUserId = newUser.id!;

        await UserProfiles.createUserProfile(
          session,
          authUserId,
          UserProfileData(
            email: accountRequest.email,
          ),
          transaction: transaction,
        );
      }

      await EmailAccounts.completeAccountCreation(
        session,
        accountRequestId: accountRequestId,
        verificationCode: verificationCode,
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
  /// Destroy all active sessions of the user.
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
    final authUser = (await AuthUser.db.findById(session, authUserId))!;

    if (authUser.blocked) {
      throw Exception('User is blocked');
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

// TODO: Move extensions to `serverpod_auth_user` package.
extension on AuthUser {
  Set<Scope> get scopes {
    return scopeNames.map(Scope.new).toSet();
  }
}
