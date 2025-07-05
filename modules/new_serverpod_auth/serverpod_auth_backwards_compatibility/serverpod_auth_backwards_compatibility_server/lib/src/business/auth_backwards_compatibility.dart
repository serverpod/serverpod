import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_backwards_compatibility_server/serverpod_auth_backwards_compatibility_server.dart';
import 'package:serverpod_auth_backwards_compatibility_server/src/business/legacy_authentication_handler.dart';
import 'package:serverpod_auth_backwards_compatibility_server/src/business/legacy_email_password_validator.dart';
import 'package:serverpod_auth_backwards_compatibility_server/src/generated/protocol.dart';

/// Collections of helper functions to work with legacy authentication data.
abstract final class AuthBackwardsCompatibility {
  /// The configuration used for the backwards compatibility.
  ///
  /// Should match the previous `AuthConfig`.
  static var config = AuthBackwardsCompatibilityConfig();

  /// Set a legacy `serverpod_auth` `EmailAuth` "hash" as a fallback password
  /// for a `serverpod_auth_email_account` `EmailAccount`.
  ///
  /// In case the latter doesn't have a password set, it can look up the
  /// previous one as a fallback here using [isLegacyPasswordValid].
  static Future<void> storeLegacyPassword(
    final Session session, {
    required final UuidValue emailAccountId,

    /// The legacy password hash
    required final String passwordHash,
    final Transaction? transaction,
  }) async {
    await LegacyEmailPassword.db.insertRow(
      session,
      LegacyEmailPassword(
        emailAccountId: emailAccountId,
        hash: passwordHash,
      ),
      transaction: transaction,
    );
  }

  /// Checks whether the password was valid for the email account in the legacy
  /// `serverpod_auth` module.
  static Future<bool> isLegacyPasswordValid(
    final Session session, {
    required final UuidValue emailAccountId,
    required final String email,
    required final String password,
    final Transaction? transaction,
  }) async {
    final legacyPassword = await LegacyEmailPassword.db.findFirstRow(
      session,
      where: (final t) => t.emailAccountId.equals(emailAccountId),
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

  /// Removes the legacy password from the database.
  static Future<void> clearLegacyPassword(
    final Session session, {
    required final UuidValue emailAccountId,
    final Transaction? transaction,
  }) async {
    await LegacyEmailPassword.db.deleteWhere(
      session,
      where: (final t) => t.emailAccountId.equals(emailAccountId),
      transaction: transaction,
    );
  }

  /// Imports a legacy session from `serverpod_auth` mapped to the new
  ///  `AuthUser`.
  ///
  /// This can later be checked using [authenticationHandler].
  static Future<void> storeLegacySession(
    final Session session, {
    required final UuidValue authUserId,

    /// The legacy session key hash
    required final String sessionKeyHash,
    required final String method,
    required final Iterable<String> scopeNames,
    final Transaction? transaction,
  }) async {
    await LegacySession.db.insertRow(
      session,
      LegacySession(
        authUserId: authUserId,
        hash: sessionKeyHash,
        method: method,
        scopeNames: scopeNames.toSet(),
      ),
      transaction: transaction,
    );
  }

  /// Check whether the `sessionKey` matches an imported legacy session.
  static Future<AuthenticationInfo?> authenticationHandler(
    final Session session,
    final String sessionKey,
  ) async {
    return legacyAuthenticationHandler(session, sessionKey);
  }

  /// Imports a legacy (external) "user identifier".
  static Future<void> storeLegacyExternalUserIdentifier(
    final Session session, {
    required final UuidValue authUserId,
    required final String userIdentifier,
    final Transaction? transaction,
  }) async {
    await LegacyExternalUserIdentifier.db.insertRow(
      session,
      LegacyExternalUserIdentifier(
          authUserId: authUserId, userIdentifier: userIdentifier),
      transaction: transaction,
    );
  }

  /// Looks up a legacy (external) "user identifier".
  static Future<UuidValue?> lookUpLegacyExternalUserIdentifier(
    final Session session, {
    required final String userIdentifier,
    final Transaction? transaction,
  }) async {
    final row = await LegacyExternalUserIdentifier.db.findFirstRow(
      session,
      where: (final t) => t.userIdentifier.equals(userIdentifier),
      transaction: transaction,
    );

    return row?.authUserId;
  }
}
