/// @docImport 'package:serverpod_auth_core_server/src/auth_user/business/auth_users.dart';
library;

import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/src/profile/extensions/user_profile_extensions.dart';

/// Configuration for merging two [AuthUser]s.
///
/// When users need to be merged, your application must decide how to handle
/// the data associated with each user. For example, if two accounts tied to the
/// same person have conflicting data for certain fields, you must decide what
/// data to merge, what data to discard, and what data to keep.
///
/// This class stores a list of callbacks which collectively solve that problem.
///
/// See also:
///   - [AccountMerger.merge]
///   - [AccountMergeHandler]
class AccountMergeConfig {
  /// Creates a new [AccountMergeConfig] instance with a custom list of merge
  /// hooks.
  ///
  /// Use this constructor if you need fine-grained control over the ordering
  /// of merge hooks or if you want to override some of the default handlers
  /// while keeping others.
  ///
  /// See [AccountMergeConfig] for more information about merge hooks and
  /// how they are ordered.
  const AccountMergeConfig.custom({
    required final List<AccountMergeHandler> mergeHooks,
  }) : _mergeHooks = mergeHooks,
       applicationMergeHandler = null;

  /// Creates a new [AccountMergeConfig] instance with the default merge hooks.
  ///
  /// Applications which have their own data to migrate should consider passing
  /// a callback for [applicationMergeHandler] which moves all relevant data
  /// from the user to remove to the user to keep. This function is then placed
  /// in the list of merge hooks just before the cleanup handler.
  ///
  /// Applications which desire finer-grain control over the ordering of merge
  /// hooks should use the [AccountMergeConfig.custom] constructor. Re-use of
  /// some or all of the existing default merge handlers is still appropriate in
  /// this scenario, should you be using the custom constructor for reordering
  /// purposes or to override only some of the default handlers.
  const AccountMergeConfig({
    this.applicationMergeHandler = defaultMergeHandler,
  }) : _mergeHooks = null;

  /// Called when two auth users are merged. Application developers should write
  /// their application-specific merge logic here.
  final AccountMergeHandler? applicationMergeHandler;

  final List<AccountMergeHandler>? _mergeHooks;

  /// Callbacks to merge data from additional modules or custom tables. These
  /// functions are invoked before any other special merge handlers.
  ///
  /// Serverpod's first party auth module automatically migrates Idp account data
  /// for initialized identity providers that implement
  /// `AccountMergeHandlerProvider`.
  ///
  /// Third-party Serverpod module authors should consider implementing
  /// [AccountMergeHandlerProvider] on their IdentityProvider classes or writing
  /// an [AccountMergeHandler] for their module which developers can include
  /// in this list.
  List<AccountMergeHandler> get mergeHooks {
    if (_mergeHooks != null) {
      return _mergeHooks;
    }
    return [
      defaultIdpMergeHandler,
      defaultCoreDataMergeHandler,
      ?applicationMergeHandler,
      defaultMergeCleanupHandler,
    ];
  }

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

  /// Default merge handler that deletes the old account.
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

  /// Default merge handler that loops over Idps which support merging accounts
  /// and calls their individual merging functions.
  static FutureOr<void> defaultIdpMergeHandler(
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    required final Transaction transaction,
  }) async {
    for (final provider in AuthServices.instance.providers) {
      if (provider is AccountMergeHandlerProvider) {
        await provider.accountMergeHook(
          session,
          userToKeepId: userToKeepId,
          userToRemoveId: userToRemoveId,
          transaction: transaction,
        );
      } else {
        session.log(
          'Auth IDP $provider does not implement AccountMergeHandlerProvider. '
          'Account data associated with this provider will not be migrated.',
          level: LogLevel.warning,
        );
      }
    }
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
          'No profile found for user to keep ${userToKeep.id}. As a '
          'fallback, the profile from to-be-deleted user ${userToRemove.id} '
          'is being migrated to User ${userToKeep.id}. This likely '
          'constitutes an error -- please file an issue with the Serverpod '
          'team.',
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
