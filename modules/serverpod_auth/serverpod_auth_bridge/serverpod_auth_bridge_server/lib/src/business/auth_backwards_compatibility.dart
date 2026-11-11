import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';
import 'package:serverpod_auth_bridge_server/src/business/legacy_email_password_validator.dart';
import 'package:serverpod_auth_bridge_server/src/generated/protocol.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';

/// Collections of helper functions to work with legacy authentication data.
abstract class AuthBackwardsCompatibility {
  /// The configuration used for the backwards compatibility.
  ///
  /// Should match the previous `AuthServices`.
  static AuthBackwardsCompatibilityConfig get config =>
      AuthBackwardsCompatibilityConfig(
        emailIdp: AuthServices.instance.emailIdp,
      );

  /// Set a legacy `serverpod_auth` `EmailAuth` "hash" as a fallback password
  /// for a `EmailAccount`.
  ///
  /// In case the latter doesn't have a password set, it can look up the
  /// previous one as a fallback here using [isLegacyPasswordValid].
  static Future<void> storeLegacyPassword(
    Session session, {
    required UuidValue emailAccountId,

    /// The legacy password hash
    required String passwordHash,
    Transaction? transaction,
  }) async {
    await LegacyEmailPassword.db.insertRow(
      session,
      LegacyEmailPassword(emailAccountId: emailAccountId, hash: passwordHash),
      transaction: transaction,
    );
  }

  /// Checks whether the password was valid for the email account in the legacy
  /// `serverpod_auth` module.
  static Future<bool> isLegacyPasswordValid(
    Session session, {
    required UuidValue emailAccountId,
    required String email,
    required String password,
    Transaction? transaction,
  }) async {
    final legacyPassword = await LegacyEmailPassword.db.findFirstRow(
      session,
      where: (t) => t.emailAccountId.equals(emailAccountId),
      transaction: transaction,
    );
    if (legacyPassword == null) {
      return false;
    }

    return legacyEmailPasswordValidator(
      session,
      email: email,
      password: password,
      passwordHash: legacyPassword.hash,
    );
  }

  /// Checks whether an account for the given [email] exists without a password,
  /// and if not it attempts to import the legacy password if its valid.
  static Future<void> importLegacyPasswordIfNeeded(
    Session session, {
    required String email,
    required String password,
    Transaction? transaction,
  }) async {
    await DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      transaction,
    ) async {
      final emailAccount = await config.emailIdp.admin.findAccount(
        session,
        email: email,
        transaction: transaction,
      );

      if (emailAccount == null || emailAccount.hasPassword) {
        return;
      }

      final passwordIsValid = await isLegacyPasswordValid(
        session,
        email: email,
        emailAccountId: emailAccount.id!,
        password: password,
        transaction: transaction,
      );

      if (!passwordIsValid) {
        // A login will of course fail in the new auth provider, but we don't want
        // to preempt any throttling or logging, and thus let it continue.
        return;
      }

      await clearLegacyPassword(
        session,
        emailAccountId: emailAccount.id!,
        transaction: transaction,
      );

      // The account was already migrated without a password, and now we need to
      // set the password to the correct one from the old system.
      await config.emailIdp.admin.setPassword(
        session,
        email: email,
        password: password,
        transaction: transaction,
      );
    });
  }

  /// Removes the legacy password from the database.
  static Future<void> clearLegacyPassword(
    Session session, {
    required UuidValue emailAccountId,
    Transaction? transaction,
  }) async {
    await LegacyEmailPassword.db.deleteWhere(
      session,
      where: (t) => t.emailAccountId.equals(emailAccountId),
      transaction: transaction,
    );
  }

  /// Imports a legacy session from `serverpod_auth` mapped to the new
  ///  `AuthUser`.
  ///
  /// This can later be checked using [authenticationHandler].
  static Future<void> storeLegacySession(
    Session session, {
    required int legacySessionId,
    required UuidValue authUserId,

    /// The legacy session key hash
    required String sessionKeyHash,
    required String method,
    required Iterable<String> scopeNames,
    Transaction? transaction,
  }) async {
    await LegacySession.db.insertRow(
      session,
      LegacySession(
        id: legacySessionId,
        authUserId: authUserId,
        hash: sessionKeyHash,
        method: method,
        scopeNames: scopeNames.toSet(),
      ),
      transaction: transaction,
    );
  }

  /// Imports a legacy (external) "user identifier".
  static Future<void> storeLegacyExternalUserIdentifier(
    Session session, {
    required UuidValue authUserId,
    required String userIdentifier,
    Transaction? transaction,
  }) async {
    await LegacyExternalUserIdentifier.db.insertRow(
      session,
      LegacyExternalUserIdentifier(
        authUserId: authUserId,
        userIdentifier: userIdentifier,
      ),
      transaction: transaction,
    );
  }

  /// Looks up an imported "user identifier", returning the `AuthUser` id.
  ///
  /// The identifier could be from previous social logins via Apple, Firebase,
  /// or Google, which were stored without a provider association.
  static Future<UuidValue?> lookUpLegacyExternalUserIdentifier(
    Session session, {
    required String userIdentifier,
    Transaction? transaction,
  }) async {
    final row = await LegacyExternalUserIdentifier.db.findFirstRow(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
      transaction: transaction,
    );

    return row?.authUserId;
  }

  /// Removes the legacy user identifier mapping.
  static Future<void> clearLegacyExternalUserIdentifier(
    Session session, {
    required String userIdentifier,
    Transaction? transaction,
  }) async {
    await LegacyExternalUserIdentifier.db.deleteWhere(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
      transaction: transaction,
    );
  }

  /// Imports an existing Google account if the user's external ID was already
  /// linked in the legacy system.
  ///
  /// Else it does nothing.
  static Future<void> importGoogleAccount(
    Session session, {
    required String idToken,
    required String? accessToken,
    Transaction? transaction,
  }) async {
    final accountDetails = await AuthServices.instance.googleIdp.admin
        .fetchAccountDetails(
          session,
          idToken: idToken,
          accessToken: accessToken,
        );

    final legacyUserIdentifier = await LegacyExternalUserIdentifier.db
        .findFirstRow(
          session,
          where: (t) => t.userIdentifier.equals(accountDetails.userIdentifier),
          transaction: transaction,
        );

    if (legacyUserIdentifier != null) {
      await DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
        transaction,
      ) async {
        await AuthServices.instance.googleIdp.admin.linkGoogleAuthentication(
          session,
          authUserId: legacyUserIdentifier.authUserId,
          accountDetails: accountDetails,
          transaction: transaction,
        );

        await LegacyExternalUserIdentifier.db.deleteRow(
          session,
          legacyUserIdentifier,
          transaction: transaction,
        );
      });
    }
  }
}
