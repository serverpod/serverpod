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

  /// Deletes an email account by email address.
  ///
  /// This will delete the email authentication account for the given email
  /// address. Related data such as password reset requests will be
  /// automatically deleted due to cascade delete constraints.
  ///
  /// Throws an [EmailAccountNotFoundException] if no account exists for the
  /// given email address.
  Future<void> deleteEmailAccount(
    final Session session, {
    required final String email,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final deleted = await _utils.account.deleteAccount(
          session,
          email: email,
          authUserId: null,
          transaction: transaction,
        );

        if (deleted.isEmpty) {
          throw EmailAccountNotFoundException();
        }
      },
    );
  }

  /// Deletes all email accounts by authentication user ID.
  ///
  /// This will delete all email authentication accounts for the given auth user
  /// ID. Related data such as password reset requests will be automatically
  /// deleted due to cascade delete constraints.
  ///
  /// Throws an [EmailAccountNotFoundException] if no accounts exist for the
  /// given auth user ID.
  Future<void> deleteEmailAccountByAuthUserId(
    final Session session, {
    required final UuidValue authUserId,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final deleted = await _utils.account.deleteAccount(
          session,
          email: null,
          authUserId: authUserId,
          transaction: transaction,
        );

        if (deleted.isEmpty) {
          throw EmailAccountNotFoundException();
        }
      },
    );
  }

  /// Gets an email authentication exists for the given email address.
  Future<EmailAccount?> findAccount(
    final Session session, {
    required final String email,
    final Transaction? transaction,
  }) async {
    return (await DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => _utils.account.listAccounts(
        session,
        email: email,
        transaction: transaction,
      ),
    )).firstOrNull;
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

        final account = (await _utils.account.listAccounts(
          session,
          email: email,
          transaction: transaction,
        )).singleOrNull;

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

/// Extension methods for [EmailAccount].
extension EmailAccountExtension on EmailAccount {
  /// Checks whether the email account has a password set.
  bool get hasPassword => passwordHash.lengthInBytes > 0;
}
