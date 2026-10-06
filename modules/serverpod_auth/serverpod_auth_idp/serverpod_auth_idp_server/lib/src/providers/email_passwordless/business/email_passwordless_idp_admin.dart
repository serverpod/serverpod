import 'package:serverpod/serverpod.dart';

import 'email_passwordless_idp_utils.dart';

/// Collection of admin methods for the passwordless email identity provider.
class EmailPasswordlessIdpAdmin {
  final EmailPasswordlessIdpUtils _utils;

  /// Creates a new instance of [EmailPasswordlessIdpAdmin].
  EmailPasswordlessIdpAdmin({
    required final EmailPasswordlessIdpUtils utils,
  }) : _utils = utils;

  /// Creates an account without a password for the auth user with the given
  /// email address, so that the user can log in with a code sent to it.
  ///
  /// The [email] will be treated as verified right away, so the caller must
  /// ensure that it comes from a trusted source.
  ///
  /// Returns the ID of the created email account.
  Future<UuidValue> createAccount(
    final Session session, {
    required final UuidValue authUserId,
    required final String email,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final account = await _utils.createAccount(
          session,
          authUserId: authUserId,
          email: email,
          transaction: transaction,
        );

        return account.id!;
      },
    );
  }

  /// {@macro email_passwordless_idp_login_util.delete_login_request_by_id}
  Future<void> deleteLoginRequestById(
    final Session session,
    final UuidValue loginRequestId, {
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => _utils.login.deleteLoginRequestById(
        session,
        loginRequestId,
        transaction: transaction,
      ),
    );
  }

  /// {@macro email_passwordless_idp_login_util.delete_expired_login_requests}
  ///
  /// Requests are not deleted when they expire, but only when someone tries to
  /// use them or another request is created for the same email address, so this
  /// should be called regularly, for example from a future call.
  Future<void> deleteExpiredLoginRequests(
    final Session session, {
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => _utils.login.deleteExpiredLoginRequests(
        session,
        transaction: transaction,
      ),
    );
  }

  /// Deletes all recorded login attempts for an email.
  ///
  /// This is useful when you want to allow a user to log in even though they
  /// have hit a rate limit.
  Future<void> deleteLoginAttemptsForEmail(
    final Session session, {
    required final String email,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => _utils.login.deleteLoginAttempts(
        session,
        olderThan: Duration.zero,
        email: email,
        transaction: transaction,
      ),
    );
  }

  /// {@macro email_passwordless_idp_login_util.delete_login_attempts}
  ///
  /// Should be called regularly, for example from a future call, to keep the
  /// table of attempts small.
  Future<void> deleteExpiredLoginAttempts(
    final Session session, {
    final Duration? olderThan,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => _utils.login.deleteLoginAttempts(
        session,
        olderThan: olderThan,
        transaction: transaction,
      ),
    );
  }
}
