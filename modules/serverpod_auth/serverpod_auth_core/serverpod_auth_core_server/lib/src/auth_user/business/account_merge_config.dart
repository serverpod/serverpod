/// @docImport 'package:serverpod_auth_core_server/src/auth_user/business/auth_users.dart';
library;

import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/src/profile/extensions/user_profile_extensions.dart';

/// Configuration for merging two [AuthUser]s.
class AccountMergeConfig {
  /// Creates a new [AccountMergeConfig] instance.
  const AccountMergeConfig({
    this.applicationMergeHandler = defaultMergeHandler,
    this.coreDataMergeHandler = defaultCoreDataMergeHandler,
    this.mergeCleanupHandler = defaultMergeCleanupHandler,
    this.mergeHooks = const [],
  });

  /// Called when two auth users are merged. Application developers should write
  /// their application-specific merge logic here.
  final AccountMergeHandler applicationMergeHandler;

  /// Callbacks to merge data from additional modules or custom tables. These
  /// functions are invoked before any other special merge handlers, like the
  /// [coreDataMergeHandler] or the application-specific
  /// [applicationMergeHandler].
  ///
  /// Serverpod's first party auth module registers hooks with this list to
  /// migrate Idp account data to preserve user sign-in after a merge.
  ///
  /// Third-party Serverpod module authors should consider writing an
  /// [AccountMergeHandler] for their module which developers can include
  /// in this list.
  final List<AccountMergeHandler> mergeHooks;

  /// Handler for cleaning up the user to remove after the merge.
  ///
  /// The default expectation is that previous merge handlers have removed any
  /// relevant data for the [userToRemove], and so this handler should only
  /// need to finally delete that user and allow cascading constraints to
  /// remove any otherwise orphaned data.
  final AccountMergeHandler mergeCleanupHandler;

  /// Handler for merging core Serverpod data (refresh tokens, user profile,
  /// and scopes).
  final AccountMergeHandler coreDataMergeHandler;

  /// Default merge handler that throws an exception. This is only useful for
  /// applications which will never merge accounts.
  static FutureOr<void> defaultMergeHandler(
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    required final Transaction transaction,
  }) => throw Exception(
    'Cannot safely merge users without a handler for application-specific '
    'logic. If your application supports account-merging, you must configure '
    'an [AccountMergeConfig] with a custom function for '
    '[applicationMergeHandler].',
  );

  /// Default merge handler that throws an exception. This is only useful for
  /// applications which will never merge accounts.
  static FutureOr<void> defaultMergeCleanupHandler(
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    required final Transaction transaction,
  }) async {
    await AuthUser.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(userToRemoveId),
      transaction: transaction,
    );
  }

  /// Merges core Serverpod data from [userToRemove] to [userToKeep].
  ///
  /// This includes:
  /// - Merging scopes
  /// - Moving access tokens and refresh tokens
  /// - Moving user profile (if userToKeep does not have one)
  static Future<void> defaultCoreDataMergeHandler(
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    required final Transaction transaction,
  }) async {
    final users = await Future.wait([
      AuthUser.db.findById(
        session,
        userToKeepId,
        transaction: transaction,
      ),
      AuthUser.db.findById(
        session,
        userToRemoveId,
        transaction: transaction,
      ),
    ]);
    AuthUser? userToKeep = users[0];
    final userToRemove = users[1];

    if (userToKeep == null || userToRemove == null) {
      throw AuthUserNotFoundException();
    }

    // Merge Scopes
    final combinedScopes = {
      ...userToKeep.scopeNames,
      ...userToRemove.scopeNames,
    };
    if (combinedScopes.length > userToKeep.scopeNames.length) {
      userToKeep = userToKeep.copyWith(scopeNames: combinedScopes);
      userToKeep = await AuthUser.db.updateRow(
        session,
        userToKeep,
        transaction: transaction,
      );
    }

    // Move Refresh Tokens
    await RefreshToken.db.updateWhere(
      session,
      where: (final t) => t.authUserId.equals(userToRemove.id),
      columnValues: (final t) => [t.authUserId(userToKeep!.id!)],
      transaction: transaction,
    );

    // Load existing profiles
    final profiles = await Future.wait([
      UserProfile.db.findFirstRow(
        session,
        where: (final t) => t.authUserId.equals(userToKeep!.id!),
        transaction: transaction,
      ),

      UserProfile.db.findFirstRow(
        session,
        where: (final t) => t.authUserId.equals(userToRemove.id),
        transaction: transaction,
      ),
    ]);
    final keepProfile = profiles[0];
    final removeProfile = profiles[1];

    // Merge User Profile
    if (removeProfile != null) {
      if (keepProfile != null) {
        // Both profiles exist, merge fields
        final mergedProfile = keepProfile.merge(removeProfile);
        await UserProfile.db.updateRow(
          session,
          mergedProfile,
          transaction: transaction,
        );
        // Don't need to remove the userToRemove profile since that database
        // relationship is set to onDelete=cascade.
      } else {
        session.log(
          'No profile found for user to keep ${userToKeep.id}, moving profile '
          'from to-be-deleted user ${userToRemove.id}. This likely constitutes '
          'an error -- please file an issue with the Serverpod team.',
          level: LogLevel.warning,
        );
        // Target has no profile, move the origin profile over
        await UserProfile.db.updateRow(
          session,
          removeProfile.copyWith(authUserId: userToKeep.id),
          columns: (final t) => [t.authUserId],
          transaction: transaction,
        );
      }
    }
  }
}

/// Callback to be invoked the accounts of two [AuthUser]s are merged.
typedef AccountMergeHandler =
    FutureOr<void> Function(
      Session session, {
      required UuidValue userToKeepId,
      required UuidValue userToRemoveId,
      required Transaction transaction,
    });
