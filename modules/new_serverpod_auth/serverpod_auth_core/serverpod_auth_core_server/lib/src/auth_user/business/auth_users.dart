import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'auth_users_config.dart';

/// Management functions for auth users.
final class AuthUsers {
  final AuthUsersConfig _config;

  /// Creates a new [AuthUsers] instance.
  const AuthUsers({
    final AuthUsersConfig config = const AuthUsersConfig(),
  }) : _config = config;

  /// Retrieves an auth user.
  ///
  /// Throws an [AuthUserNotFoundException] in case no auth user is found for the ID.
  Future<AuthUserModel> get(
    final Session session, {
    required final UuidValue authUserId,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      final transaction,
    ) async {
      final authUser = await AuthUser.db.findById(
        session,
        authUserId,
        transaction: transaction,
      );

      if (authUser == null) {
        throw AuthUserNotFoundException();
      }

      return authUser.toModel();
    });
  }

  /// Creates a new auth user.
  Future<AuthUserModel> create(
    final Session session, {
    final Set<Scope> scopes = const {},
    final bool blocked = false,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      final transaction,
    ) async {
      final authUserToCreate =
          await _config.onBeforeAuthUserCreated?.call(
            session,
            scopes,
            blocked,
            transaction: transaction,
          ) ??
          (scopes: scopes, blocked: blocked);

      final authUser = await AuthUser.db.insertRow(
        session,
        AuthUser(
          blocked: authUserToCreate.blocked,
          scopeNames: authUserToCreate.scopes
              .map((final s) => s.name)
              .nonNulls
              .toSet(),
        ),
        transaction: transaction,
      );

      final createdAuthUser = authUser.toModel();

      await _config.onAfterAuthUserCreated?.call(
        session,
        createdAuthUser,
        transaction: transaction,
      );

      return createdAuthUser;
    });
  }

  /// Updates an auth user.
  ///
  /// When updating scopes or the blocked status of an auth user, you may need
  /// to communicate these changes to the rest of the server using
  /// [session.messages.authenticationRevoked] with an appropriate message type
  /// (e.g., [RevokedAuthenticationUser] or [RevokedAuthenticationScope]).
  ///
  /// Throws an [AuthUserNotFoundException] in case no auth user is found for the ID.
  Future<AuthUserModel> update(
    final Session session, {
    required final UuidValue authUserId,
    final Set<Scope>? scopes,
    final bool? blocked,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      final transaction,
    ) async {
      var authUser = await AuthUser.db.findById(
        session,
        authUserId,
        transaction: transaction,
      );
      if (authUser == null) {
        throw AuthUserNotFoundException();
      }

      if (scopes != null) {
        authUser = authUser.copyWith(
          scopeNames: scopes.map((final s) => s.name).nonNulls.toSet(),
        );
      }

      if (blocked != null) {
        authUser = authUser.copyWith(
          blocked: blocked,
        );
      }

      authUser = await AuthUser.db.updateRow(
        session,
        authUser,
        transaction: transaction,
      );

      return authUser.toModel();
    });
  }

  /// Returns all auth users.
  Future<List<AuthUserModel>> list(
    final Session session, {
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      final transaction,
    ) async {
      final authUsers = await AuthUser.db.find(
        session,
        transaction: transaction,
      );

      return authUsers.map((final a) => a.toModel()).toList();
    });
  }

  /// Removes the specified auth user.
  ///
  /// This also removes all authentication-related entities from all
  /// `serverpod_auth_*` packages which are linked to this user, like the
  /// various authentication methods and sessions.
  /// (This is based on the `onDelete=Cascade` relationship between the models.
  /// Other packages linking to the `AuthUser` may or may not opt into this.)
  ///
  /// When deleting an auth user, you may need to communicate this revocation
  /// to the rest of the server using [session.messages.authenticationRevoked]
  /// with [RevokedAuthenticationUser].
  ///
  /// Throws an [AuthUserNotFoundException] in case no auth user is found for
  /// the ID.
  Future<void> delete(
    final Session session, {
    required final UuidValue authUserId,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      final transaction,
    ) async {
      final deletedUsers = await AuthUser.db.deleteWhere(
        session,
        where: (final t) => t.id.equals(authUserId),
        transaction: transaction,
      );

      if (deletedUsers.isEmpty) {
        throw AuthUserNotFoundException();
      }
    });
  }
}

extension on AuthUser {
  AuthUserModel toModel() {
    return AuthUserModel(
      id: id!,
      createdAt: createdAt,
      blocked: blocked,
      scopeNames: scopeNames,
    );
  }
}
