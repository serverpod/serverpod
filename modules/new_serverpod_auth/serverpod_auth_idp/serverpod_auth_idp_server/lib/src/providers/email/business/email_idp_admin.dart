import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/src/providers/email/util/email_string_extension.dart';

import '../../../generated/protocol.dart';
import 'email_idp_server_exceptions.dart';
import 'email_idp_utils.dart';

/// Collection of email-account admin methods.
final class EmailIDPAdmin {
  final EmailIDPUtils _utils;

  /// Creates a new instance of [EmailIDPAdmin].
  EmailIDPAdmin({
    required final EmailIDPUtils utils,
  }) : _utils = utils;

  /// {@macro email_idp_account_creation_util.create_email_authentication}
  Future<UuidValue> createEmailAuthentication(
    final Session session, {
    required final UuidValue authUserId,
    required final String email,
    required final String? password,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => _utils.accountCreation.createEmailAuthentication(
        session,
        authUserId: authUserId,
        email: email,
        password: password,
        transaction: transaction,
      ),
    );
  }

  /// {@macro email_idp_account_creation_util.delete_email_account_request_by_id}
  Future<void> deleteEmailAccountRequestById(
    final Session session,
    final UuidValue accountRequestId, {
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          _utils.accountCreation.deleteEmailAccountRequestById(
        session,
        accountRequestId,
        transaction: transaction,
      ),
    );
  }

  /// {@macro email_idp_account_creation_util.delete_expired_account_requests}
  Future<void> deleteExpiredAccountRequests(
    final Session session, {
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          _utils.accountCreation.deleteExpiredAccountRequests(
        session,
        transaction: transaction,
      ),
    );
  }

  /// Deletes all password reset request attempts for an email.
  ///
  /// This is useful when you want to allow a user to request a new password
  /// even though they have hit the rate limit.
  Future<void> deletePasswordResetRequestsAttemptsForEmail(
    final Session session, {
    required final String email,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          _utils.passwordReset.deletePasswordResetRequestAttempts(
        session,
        olderThan: Duration.zero,
        email: email,
        transaction: transaction,
      ),
    );
  }

  /// Deletes all expired password reset requests.
  Future<void> deleteExpiredPasswordResetRequests(
    final Session session, {
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => _utils.passwordReset.deletePasswordResetRequests(
        session,
        olderThan: null,
        emailAccountId: null,
        transaction: transaction,
      ),
    );
  }

  /// {@macro email_idp_authentication_utils.delete_failed_login_attempts}
  Future<void> deleteFailedLoginAttempts(
    final Session session, {
    final Duration? olderThan,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => _utils.authentication.deleteFailedLoginAttempts(
        session,
        olderThan: olderThan,
        transaction: transaction,
      ),
    );
  }

  /// Checks whether an email authentication exists for the given email address.
  Future<
      ({
        UuidValue authUserId,
        UuidValue emailAccountId,
        bool hasPassword,
      })?> findAccount(
    final Session session, {
    required String email,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction,
        (final transaction) async {
      email = email.normalizedEmail;

      final account = await EmailAccount.db.findFirstRow(
        session,
        where: (final t) => t.email.equals(email),
        transaction: transaction,
      );

      if (account == null) {
        return null;
      }

      return (
        authUserId: account.authUserId,
        emailAccountId: account.id!,
        hasPassword: account.passwordHash.lengthInBytes > 0,
      );
    });
  }

  /// {@macro email_idp_account_creation_util.find_active_email_account_request}
  Future<EmailAccountRequest?> findActiveEmailAccountRequest(
    final Session session, {
    required final UuidValue accountRequestId,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          _utils.accountCreation.findActiveEmailAccountRequest(
        session,
        accountRequestId: accountRequestId,
        transaction: transaction,
      ),
    );
  }

  /// Sets the password for the authentication belonging to the given email.
  ///
  /// The [password] argument is not checked against the configured password
  /// policy.
  ///
  /// Throws an [EmailAccountNotFoundException] in case no account exists for
  /// the given email address.
  Future<void> setPassword(
    final Session session, {
    required String email,
    required final String password,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        email = email.normalizedEmail;

        final account = (await EmailAccount.db.find(
          session,
          where: (final t) => t.email.equals(email),
          transaction: transaction,
        ))
            .singleOrNull;

        if (account == null) {
          throw EmailAccountNotFoundException();
        }

        return _utils.passwordReset.setPassword(
          session,
          emailAccount: account,
          password: password,
          transaction: transaction,
        );
      },
    );
  }
}
