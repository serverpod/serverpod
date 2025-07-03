import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart'
    as new_email_account;
import 'package:serverpod_auth_migration_server/src/business/migrate_user.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    as legacy_auth;

/// Helper functions to migrate email accounts from `serverpod_auth` to
/// `serverpod_auth_email_account`.
abstract final class AuthMigrationEmail {
  /// Attempts to migrate the user and their email authentication to the new
  /// auth module.
  ///
  /// In case the email is already registered in the new system or the
  /// credentials are not known in the old system, this method does not do
  /// anything.
  ///
  /// If the credentials are known to the old system but not yet in the new one,
  /// then the user's email authentication as well as their profile are
  /// migrated.
  /// If the credentials are valid in the old system and the user has already
  /// been migrated (for another authentication method), then only the email
  /// authentication will be added for that user.
  /// If the email is registered in the old system, but the password is not
  /// correct, then an email authentication without a set password will be
  /// created in the new system.
  ///
  /// The password policy for new registrations will not be applied to migrated
  /// accounts.
  ///
  /// This method is intended to be used before the login is attempted in the
  /// new module, so it should be added in the `login` endpoint as the first
  /// step.
  static Future<void> migrateWithPassword(
    final Session session, {
    required String email,
    required final String password,
    final Transaction? transaction,
  }) async {
    email = email.toLowerCase();

    final emailAccountInfo =
        await new_email_account.EmailAccounts.admin.findAccount(
      session,
      email: email,
      transaction: transaction,
    );
    if (emailAccountInfo != null && emailAccountInfo.hasPassword) {
      return;
    }

    final authenticationResult = await legacy_auth.Emails.authenticate(
      session,
      email,
      password,
    );

    if (!authenticationResult.success) {
      // Attempt migration without password, such that a caller will not conclude
      // that no account exists, in which case they might create a conflicting one.
      await migrateWithoutPassword(session, email: email);

      // A login will of course fail in the new auth provider, but we don't want
      // to preempt any throttling or logging, and thus let it continue.
      return;
    }

    // Remove the authentication that was implicitly created upon successful
    // login in the legacy module.
    await legacy_auth.AuthKey.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(authenticationResult.keyId!),
      transaction: transaction,
    );

    if (emailAccountInfo != null && !emailAccountInfo.hasPassword) {
      // The account was already migrated without a password, and now we need to
      // set the password to the correct one from the old system.
      await new_email_account.EmailAccounts.admin.setPassword(
        session,
        email: email,
        password: password,
        transaction: transaction,
      );

      return;
    }

    final userInfo = authenticationResult.userInfo!;

    await DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        await migrateUserIfNeeded(
          session,
          userInfo,
          transaction: transaction,
        );

        await new_email_account.EmailAccounts.admin.setPassword(
          session,
          email: email,
          password: password,
          transaction: transaction,
        );
      },
    );
  }

  /// Attempts to migrate the account belonging to the given email address
  /// without transferring their password.
  ///
  /// The password will be unset, and needs to be set later either through a
  /// password reset, or a login attempt, where the password can be retrieved
  /// from the old system.
  ///
  /// This method is intended to be called in the background to migrate all
  /// users eventually and before any code which would attempt a look-up by
  /// email, e.g. an account creation or password reset.
  static Future<void> migrateWithoutPassword(
    final Session session, {
    required String email,
    final Transaction? transaction,
  }) async {
    email = email.toLowerCase();

    final emailAccountInfo =
        await new_email_account.EmailAccounts.admin.findAccount(
      session,
      email: email,
      transaction: transaction,
    );
    if (emailAccountInfo != null) {
      return;
    }

    final emailAuth = await legacy_auth.EmailAuth.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );

    if (emailAuth == null) {
      return;
    }

    final userInfo = await legacy_auth.Users.findUserByUserId(
      session,
      emailAuth.userId,
      useCache: false,
    );

    if (userInfo == null) {
      return;
    }

    await DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        await migrateUserIfNeeded(
          session,
          userInfo,
          transaction: transaction,
        );
      },
    );
  }
}
