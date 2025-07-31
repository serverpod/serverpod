part of 'auth_email.dart';

/// Admin operations complementing the end-user [AuthEmail] functionality.
///
/// An instance of this class is available at [AuthEmail.admin].
abstract class AuthEmailAdmin<SessionType extends SerializableModel> {
  AuthEmailAdmin._();

  ///
  @protected
  final String method = 'email';

  /// Creates a user with an email-based authentication and the associated
  /// profile.
  ///
  /// The end result is identical to the combination of
  /// [AuthEmail.startRegistration] and [AuthEmail.finishRegistration].
  /// The [email] is considered verified by default.
  ///
  /// Returns the newly created [AuthUser]'s id.
  Future<UuidValue> createUser(
    final Session session, {
    required final String email,
    required final String password,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final newUser = await AuthUsers.create(
          session,
          transaction: transaction,
        );
        final authUserId = newUser.id;

        await UserProfiles.createUserProfile(
          session,
          authUserId,
          UserProfileData(
            email: email,
          ),
          transaction: transaction,
        );

        await EmailAccounts.admin.createEmailAuthentication(
          session,
          authUserId: authUserId,
          email: email,
          password: password,
          transaction: transaction,
        );

        return authUserId;
      },
    );
  }

  /// Create a session for the given auth user.
  ///
  /// The session is marked as originating from the `email` provider.
  Future<SessionType> createSession(
    final Session session,
    final UuidValue authUserId, {
    required final Transaction? transaction,
  });
}

///
class AuthEmailAdminDatabaseSession extends AuthEmailAdmin<AuthSuccess> {
  AuthEmailAdminDatabaseSession._() : super._();

  /// Create a session for the given auth user.
  ///
  /// The session is marked as originating from the `email` provider.
  @override
  Future<AuthSuccess> createSession(
    final Session session,
    final UuidValue authUserId, {
    required final Transaction? transaction,
  }) async {
    return AuthSessions.createSession(
      session,
      authUserId: authUserId,
      method: method,
      transaction: transaction,
    );
  }
}
