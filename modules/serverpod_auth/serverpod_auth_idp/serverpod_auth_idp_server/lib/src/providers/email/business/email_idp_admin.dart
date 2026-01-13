import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../util/email_string_extension.dart';
import 'email_idp_server_exceptions.dart';
import 'email_idp_utils.dart';

/// Collection of email-account admin methods.
class EmailIdpAdmin {
  final EmailIdpUtils _utils;

  /// Creates a new instance of [EmailIdpAdmin].
  EmailIdpAdmin({
    required final EmailIdpUtils utils,
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

  /// Updates the email address for an existing email authentication account.
  ///
  /// This method performs an atomic update of both the [EmailAccount] and the
  /// associated [UserProfile] to ensure data consistency across the authentication
  /// system. All operations are executed within a database transaction.
  ///
  /// **Email Normalization:**
  /// Both [oldEmail] and [newEmail] are automatically normalized using the
  /// [normalizedEmail] extension (typically converts to lowercase and trims
  /// whitespace) to ensure consistent email matching and storage.
  ///
  /// **Data Updates:**
  /// 1. Updates the email field in the [EmailAccount] table
  /// 2. Updates the email field in the [UserProfile] table (if profile exists)
  ///
  /// **Validation:**
  /// - Verifies that an account exists for [oldEmail]
  /// - Ensures [newEmail] is not already associated with another account
  ///
  /// **Parameters:**
  /// - [session]: The current database session
  /// - [oldEmail]: The existing email address to be updated
  /// - [newEmail]: The new email address to set
  /// - [transaction]: Optional transaction context for atomic operations
  ///
  /// **Throws:**
  /// - [EmailAccountNotFoundException] if no account exists for [oldEmail]
  /// - [EmailAlreadyInUseException] if [newEmail] is already registered
  ///
  /// This method should only be called after proper authentication and
  /// authorization checks. Ensure the requesting user has permission to
  /// change the email address (typically the account owner or an administrator).
  Future<void> updateEmail(
    final Session session, {
    required String oldEmail,
    required String newEmail,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        // Normalize email addresses to ensure consistent matching
        oldEmail = oldEmail.normalizedEmail;
        newEmail = newEmail.normalizedEmail;

        // Locate the existing email account
        final account = (await _utils.account.listAccounts(
          session,
          email: oldEmail,
          transaction: transaction,
        )).singleOrNull;

        // Validate that the old email account exists
        if (account == null) {
          throw EmailAccountNotFoundException();
        }

        // Verify the new email is not already registered
        final existingAccount = await findAccount(
          session,
          email: newEmail,
          transaction: transaction,
        );

        if (existingAccount != null) {
          throw EmailAlreadyInUseException();
        }

        // Update the email account record
        await EmailAccount.db.updateRow(
          session,
          account.copyWith(email: newEmail),
          transaction: transaction,
        );

        // Update the associated user profile if it exists
        final profile = await UserProfile.db.findFirstRow(
          session,
          where: (final t) => t.authUserId.equals(account.authUserId),
          transaction: transaction,
        );

        if (profile != null) {
          await UserProfile.db.updateRow(
            session,
            profile.copyWith(email: newEmail),
            transaction: transaction,
          );
        }
      },
    );
  }
}

/// Extension methods for [EmailAccount].
extension EmailAccountExtension on EmailAccount {
  /// Checks whether the email account has a password set.
  bool get hasPassword => passwordHash.isNotEmpty;
}
