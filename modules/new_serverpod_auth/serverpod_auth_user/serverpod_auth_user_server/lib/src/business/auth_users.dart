import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';

/// Management functions for auth users.
abstract final class AuthUsers {
  /// Retrieves an auth user.
  ///
  /// Throws an [AuthUserNotFoundException] in case no auth user is found for the ID.
  static Future<AuthUserModel> get(
    final Session session, {
    required final UuidValue authUserId,
    final Transaction? transaction,
  }) async {
    final authUser = await AuthUser.db.findById(
      session,
      authUserId,
      transaction: transaction,
    );

    if (authUser == null) {
      throw AuthUserNotFoundException();
    }

    return authUser.toModel();
  }

  /// Creates a new auth user.
  static Future<AuthUserModel> create(
    final Session session, {
    final Set<Scope> scopes = const {},
    final bool blocked = false,
    final Transaction? transaction,
  }) async {
    final authUser = await AuthUser.db.insertRow(
      session,
      AuthUser(
        created: clock.now(),
        blocked: blocked,
        scopeNames: scopes.map((final s) => s.name).nonNulls.toSet(),
      ),
      transaction: transaction,
    );

    return authUser.toModel();
  }

  /// Updates an auth user.
  ///
  /// Throws an [AuthUserNotFoundException] in case no auth user is found for the ID.
  static Future<AuthUserModel> update(
    final Session session, {
    required final UuidValue authUserId,
    final Set<Scope>? scopes,
    final bool? blocked,
    final Transaction? transaction,
  }) async {
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
  }

  /// Returns all auth users.
  static Future<List<AuthUserModel>> list(
    final Session session, {
    final Transaction? transaction,
  }) async {
    final authUsers = await AuthUser.db.find(
      session,
      transaction: transaction,
    );

    return authUsers.map((final a) => a.toModel()).toList();
  }

  /// Removes the specified auth user.
  ///
  /// Throws an [AuthUserNotFoundException] in case no auth user is found for the ID.
  static Future<void> delete(
    final Session session, {
    required final UuidValue authUserId,
    final Transaction? transaction,
  }) async {
    final deletedUsers = await AuthUser.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(authUserId),
      transaction: transaction,
    );

    if (deletedUsers.isEmpty) {
      throw AuthUserNotFoundException();
    }
  }
}

extension on AuthUser {
  AuthUserModel toModel() {
    return AuthUserModel(
      id: id!,
      created: created,
      blocked: blocked,
      scopeNames: scopeNames,
    );
  }
}
