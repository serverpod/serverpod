import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_backwards_compatibility_server/serverpod_auth_backwards_compatibility_server.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart';
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    as legacy_auth;

class EmailAccountBackwardsCompatibilityTestEndpoint extends Endpoint {
  Future<int> createLegacyUser(
    final Session session, {
    required final String email,
    required final String password,
  }) async {
    final user = await legacy_auth.Emails.createUser(
      session,
      email,
      email,
      password,
    );

    return user!.id!;
  }

  Future<legacy_auth.AuthKey> createLegacySession(
    final Session session, {
    required final int userId,
    required final Set<String> scopes,
  }) async {
    return legacy_auth.UserAuthentication.signInUser(
      session,
      userId,
      'test',
      scopes: scopes.map(Scope.new).toSet(),
      updateSession: false,
    );
  }

  Future<void> migrateUser(
    final Session session, {
    required final int legacyUserId,
    final String? password,
  }) async {
    await AuthMigrations.migrateUsers(
      session,
      userMigration: null,
      // ignore: invalid_use_of_visible_for_testing_member
      legacyUserId: legacyUserId,
    );
  }

  /// Returns the new auth user ID.
  Future<UuidValue?> getNewAuthUserId(
    final Session session, {
    required final int userId,
  }) async {
    return await AuthMigrations.getNewAuthUserId(session, userId);
  }

  /// Delete `UserInfo`, `AuthKey` and `EmailAuth` entities for the user
  Future<void> deleteLegacyAuthData(
    final Session session, {
    required final int userId,
  }) async {
    await legacy_auth.AuthKey.db.deleteWhere(
      session,
      where: (final t) => t.userId.equals(userId),
    );

    await legacy_auth.EmailAuth.db.deleteWhere(
      session,
      where: (final t) => t.userId.equals(userId),
    );

    await legacy_auth.UserInfo.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(userId),
    );
  }

  /// Returns the user identifier associated with the session.
  ///
  /// Since the server runs with the backwards compatible auth handler, both
  /// old session keys will work post migration.
  Future<String?> sessionUserIdentifer(final Session session) async {
    return (await session.authenticated)?.userIdentifier;
  }

  /// Returns the user ID of associated with the session derived from the session key
  Future<bool> checkLegacyPassword(
    final Session session, {
    required final String email,
    required final String password,
  }) async {
    final account = await EmailAccounts.admin.findAccount(
      session,
      email: email,
    );

    if (account == null) {
      throw Exception('No account found for "$email"');
    }

    return await AuthBackwardsCompatibility.isLegacyPasswordValid(
      session,
      emailAccountId: account.emailAccountId,
      email: email,
      password: password,
    );
  }
}
