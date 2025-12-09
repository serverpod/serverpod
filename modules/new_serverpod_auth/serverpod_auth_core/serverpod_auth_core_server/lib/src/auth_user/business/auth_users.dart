import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'auth_users_config.dart';

/// Management functions for auth users.
class AuthUsers {
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

  /// Merges two auth users.
  ///
  /// The [sourceUserId] will be merged into [targetUserId].
  /// The [sourceUserId] will be deleted after the merge.
  ///
  /// This method will:
  /// 1. Invoke [AuthUsersConfig.onUserMerged] to allow the application to migrate data.
  /// 2. Merge scopes from source to target.
  /// 3. Move all sessions from source to target.
  /// 4. Move user profile from source to target (if target has no profile).
  /// 5. Delete source user.
  ///
  /// Throws an [AuthUserNotFoundException] in case no auth user is found for either ID.
  ///
  /// [sourceUserId] is the ID of the user to be merged and deleted.
  /// [targetUserId] is the ID of the user to merge into.
  /// [transaction] is the transaction to use for the database operations.
  Future<AuthUserModel> merge(
    final Session session, {
    required final UuidValue sourceUserId,
    required final UuidValue targetUserId,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      final transaction,
    ) async {
      final sourceUser = await AuthUser.db.findById(
        session,
        sourceUserId,
        transaction: transaction,
      );
      final targetUser = await AuthUser.db.findById(
        session,
        targetUserId,
        transaction: transaction,
      );

      if (sourceUser == null || targetUser == null) {
        throw AuthUserNotFoundException();
      }

      // 1. Invoke callback
      await _config.onUserMerged?.call(
        session,
        sourceUserId,
        targetUserId,
        transaction: transaction,
      );

      // 2. Merge scopes
      await _mergeScopes(session, sourceUser, targetUser, transaction);

      // 3. Move sessions
      await _moveSessions(session, sourceUserId, targetUserId, transaction);

      // 4. Merge profile
      await _mergeProfiles(session, sourceUserId, targetUserId, transaction);

      // 5. Delete source user
      // Note: This will cascade delete any remaining linked entities (like source profile if not moved)
      await delete(
        session,
        authUserId: sourceUserId,
        transaction: transaction,
      );

      return await get(
        session,
        authUserId: targetUserId,
        transaction: transaction,
      );
    });
  }

  Future<void> _mergeScopes(
    final Session session,
    final AuthUser sourceUser,
    final AuthUser targetUser,
    final Transaction transaction,
  ) async {
    final newScopes = {...targetUser.scopeNames, ...sourceUser.scopeNames};
    if (newScopes.length > targetUser.scopeNames.length) {
      await AuthUser.db.updateRow(
        session,
        targetUser.copyWith(scopeNames: newScopes),
        transaction: transaction,
      );
    }
  }

  Future<void> _moveSessions(
    final Session session,
    final UuidValue sourceUserId,
    final UuidValue targetUserId,
    final Transaction transaction,
  ) async {
    await ServerSideSession.db.updateWhere(
      session,
      where: (final t) => t.authUserId.equals(sourceUserId),
      columnValues: (final t) => [
        t.authUserId(targetUserId),
      ],
      transaction: transaction,
    );
  }

  Future<void> _mergeProfiles(
    final Session session,
    final UuidValue sourceUserId,
    final UuidValue targetUserId,
    final Transaction transaction,
  ) async {
    final sourceProfile = await UserProfile.db.findFirstRow(
      session,
      where: (final t) => t.authUserId.equals(sourceUserId),
      transaction: transaction,
    );
    final targetProfile = await UserProfile.db.findFirstRow(
      session,
      where: (final t) => t.authUserId.equals(targetUserId),
      transaction: transaction,
    );

    if (sourceProfile != null) {
      if (targetProfile == null) {
        // Target has no profile, move source profile to target
        await UserProfile.db.updateWhere(
          session,
          where: (final t) => t.authUserId.equals(sourceUserId),
          columnValues: (final t) => [
            t.authUserId(targetUserId),
          ],
          transaction: transaction,
        );
      } else {
        // Both have profiles, merge source into target column-by-column
        var updatedTargetProfile = targetProfile.copyWith();
        bool changed = false;

        if ((updatedTargetProfile.userName == null ||
                updatedTargetProfile.userName!.isEmpty) &&
            sourceProfile.userName != null &&
            sourceProfile.userName!.isNotEmpty) {
          updatedTargetProfile = updatedTargetProfile.copyWith(
            userName: sourceProfile.userName,
          );
          changed = true;
        }

        if ((updatedTargetProfile.fullName == null ||
                updatedTargetProfile.fullName!.isEmpty) &&
            sourceProfile.fullName != null &&
            sourceProfile.fullName!.isNotEmpty) {
          updatedTargetProfile = updatedTargetProfile.copyWith(
            fullName: sourceProfile.fullName,
          );
          changed = true;
        }

        if ((updatedTargetProfile.email == null ||
                updatedTargetProfile.email!.isEmpty) &&
            sourceProfile.email != null &&
            sourceProfile.email!.isNotEmpty) {
          updatedTargetProfile = updatedTargetProfile.copyWith(
            email: sourceProfile.email,
          );
          changed = true;
        }

        if (updatedTargetProfile.imageId == null &&
            sourceProfile.imageId != null) {
          updatedTargetProfile = updatedTargetProfile.copyWith(
            imageId: sourceProfile.imageId,
          );
          changed = true;
        }

        if (changed) {
          await UserProfile.db.updateRow(
            session,
            updatedTargetProfile,
            transaction: transaction,
          );
        }

        // Delete source profile as it has been merged
        await UserProfile.db.deleteRow(
          session,
          sourceProfile,
          transaction: transaction,
        );
      }
    }
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
