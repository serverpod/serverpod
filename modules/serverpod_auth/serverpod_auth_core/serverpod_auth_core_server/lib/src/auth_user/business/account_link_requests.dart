import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';

import '../../common/business/auth_services.dart';
import '../../generated/protocol.dart';
import '../../profile/util/user_profile_extension.dart';
import '../util/authentication_info_extension.dart';
import 'account_merge_config.dart';

/// Management functions for linking an additional sign-in method to an existing
/// account.
///
/// Linking runs in three steps, so that an ordinary sign-in can never be turned
/// into an account merge by accident:
///
/// 1. The signed-in user calls [createLinkRequest], which records the intent
///    together with the current session's `authId`.
/// 2. The user signs in with the additional provider, as they normally would.
///    Each identity provider calls [attachToActiveLinkRequest] before issuing a
///    token, which records the signed-in account on the request. Only the
///    session that created the request can attach to it, so a concurrent login
///    on a second device is never absorbed.
/// 3. The client calls [executeLinkRequest] with the token from step 2 as proof
///    that the user controls the account being linked.
///
/// See also:
///   - [AccountMerger], which performs the merge itself.
class AccountLinkRequests {
  final AccountMergeConfig _config;

  /// Creates a new [AccountLinkRequests] instance.
  const AccountLinkRequests({
    final AccountMergeConfig config = const AccountMergeConfig(),
  }) : _config = config;

  /// Starts an account link flow for the calling user and session.
  ///
  /// Any previous request for this user is replaced, so a user can restart the
  /// flow at any point. If the replaced request had an account attached that
  /// was created by the linking sign-in itself, that account is removed here,
  /// reclaiming it after an abandoned flow.
  ///
  /// Throws a [StateError] if the caller is not authenticated.
  Future<void> createLinkRequest(
    final Session session, {
    final Transaction? transaction,
  }) async {
    final authentication = _requireAuthentication(session);

    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      final transaction,
    ) async {
      await _discardExistingRequest(
        session,
        authUserId: authentication.authUserId,
        transaction: transaction,
      );

      await AccountLinkRequest.db.insertRow(
        session,
        AccountLinkRequest(
          authUserId: authentication.authUserId,
          authId: authentication.authId,
          expiresAt: clock.now().add(_config.linkRequestLifetime),
        ),
        transaction: transaction,
      );
    });
  }

  /// Cancels the calling user's account link flow, if one is in progress.
  ///
  /// Call this as soon as the user declines a merge or dismisses the linking
  /// UI. While a request is active, signing in as another user from this
  /// session is permitted instead of being rejected, and cancelling closes that
  /// window ahead of the request's expiry.
  ///
  /// Throws a [StateError] if the caller is not authenticated.
  Future<void> cancelLinkRequest(
    final Session session, {
    final Transaction? transaction,
  }) async {
    final authentication = _requireAuthentication(session);

    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      final transaction,
    ) async {
      await _discardExistingRequest(
        session,
        authUserId: authentication.authUserId,
        transaction: transaction,
      );
    });
  }

  /// Completes the calling user's account link flow.
  ///
  /// [proofToken] is the token returned by the sign-in performed in step 2, and
  /// proves that the caller controls the account being linked.
  ///
  /// If that sign-in created a new account, it is linked right away and
  /// [AccountLinkStatus.linked] is returned. If it signed in to an account that
  /// already existed, completing the link means merging that account into the
  /// caller's and removing it, which needs the user's consent: unless
  /// [approveMerge] is set, nothing is changed and
  /// [AccountLinkStatus.mergeRequired] is returned along with a description of
  /// the account, so it can be presented to the user.
  ///
  /// Throws an [AccountLinkRequestNotFoundException] if there is no usable
  /// request for this caller and token, in which case the flow has to be
  /// started again.
  /// Throws an [AccountMergeNotConfiguredException] if a merge is required but
  /// the application has not configured how to merge its own data.
  /// Throws an [AccountMergeFailedException] if the merge itself fails, in
  /// which case both accounts are left untouched.
  Future<AccountLinkResult> executeLinkRequest(
    final Session session, {
    required final String proofToken,
    final bool approveMerge = false,
  }) async {
    final authentication = _requireAuthentication(session);
    final authServices = AuthServices.instance;

    final proofAuthentication = await authServices.tokenManager.validateToken(
      session,
      proofToken,
    );
    if (proofAuthentication == null) {
      throw AccountLinkRequestNotFoundException(
        message: 'The proof token is not valid.',
      );
    }

    final result = await DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      null,
      (final transaction) async {
        final request = await _findActiveRequest(
          session,
          authUserId: authentication.authUserId,
          authId: authentication.authId,
          transaction: transaction,
        );
        if (request == null) {
          throw AccountLinkRequestNotFoundException(
            message: 'No account link request is in progress.',
          );
        }

        final linkedAuthUserId = request.linkedAuthUserId;
        if (linkedAuthUserId == null) {
          throw AccountLinkRequestNotFoundException(
            message:
                'No sign-in has been attached to the account link request yet.',
          );
        }
        if (proofAuthentication.userIdentifier != linkedAuthUserId.toString()) {
          throw AccountLinkRequestNotFoundException(
            message:
                'The proof token does not belong to the account that was '
                'attached to the account link request.',
          );
        }

        // An account that already existed carries data of its own, so removing
        // it needs both the user's consent and application logic to merge it.
        final wasNewlyCreated = request.linkedAccountWasCreated ?? false;
        AccountLinkConflict? conflict;
        if (!wasNewlyCreated) {
          if (!authServices.accountMerger.hasApplicationMergeHandler) {
            throw AccountMergeNotConfiguredException();
          }

          conflict = await _describeAccount(
            session,
            authUserId: linkedAuthUserId,
            method: request.linkedMethod,
            transaction: transaction,
          );

          if (!approveMerge) {
            // A dry run: leave the request and the proof token usable, so the
            // client can come back once the user has approved the merge.
            return (
              result: AccountLinkResult(
                status: AccountLinkStatus.mergeRequired,
                conflict: conflict,
              ),
              merged: false,
            );
          }
        }

        await _merge(
          session,
          userToKeepId: authentication.authUserId,
          userToRemoveId: linkedAuthUserId,
          isNewlyCreated: wasNewlyCreated,
          transaction: transaction,
        );
        await AccountLinkRequest.db.deleteRow(
          session,
          request,
          transaction: transaction,
        );

        return (
          result: AccountLinkResult(
            status: wasNewlyCreated
                ? AccountLinkStatus.linked
                : AccountLinkStatus.merged,
            conflict: conflict,
          ),
          merged: true,
        );
      },
    );

    if (result.merged) {
      // The merge moved the linked account's tokens over to the caller, so the
      // proof token would otherwise keep working as the caller. Revoked after
      // the commit, so that a rollback cannot strand the client.
      await authServices.tokenManager.revokeToken(
        session,
        tokenId: proofAuthentication.authId,
      );
    }

    return result.result;
  }

  /// Records a successful sign-in on the caller's active account link request.
  ///
  /// Identity providers call this just before issuing a token. It does nothing
  /// unless the caller is signed in and has a link request created by this same
  /// session, so ordinary sign-ins are unaffected.
  ///
  /// Throws an [AccountAlreadyLinkedException] if the sign-in resolved to the
  /// account the caller is already signed in to.
  static Future<void> attachToActiveLinkRequest(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,
    required final bool newAccount,
    required final Transaction transaction,
  }) async {
    final authentication = session.authenticated;
    if (authentication == null) {
      // An ordinary sign-in. Deliberately does not touch the database.
      return;
    }

    final request = await _findActiveRequest(
      session,
      authUserId: authentication.authUserId,
      authId: authentication.authId,
      transaction: transaction,
    );
    if (request == null) {
      // Either a re-authentication of the current user, or a sign-in from a
      // session that did not start a link flow. Left to the token issuer to
      // accept or reject.
      return;
    }

    if (authUserId == authentication.authUserId) {
      throw AccountAlreadyLinkedException();
    }

    final previousLinkedAuthUserId = request.linkedAuthUserId;
    if (previousLinkedAuthUserId != null &&
        previousLinkedAuthUserId != authUserId &&
        (request.linkedAccountWasCreated ?? false)) {
      await AuthUser.db.deleteWhere(
        session,
        where: (final t) => t.id.equals(previousLinkedAuthUserId),
        transaction: transaction,
      );
    }

    await AccountLinkRequest.db.updateRow(
      session,
      request.copyWith(
        linkedAuthUserId: authUserId,
        linkedMethod: method,
        linkedAccountWasCreated: newAccount,
      ),
      transaction: transaction,
    );
  }

  /// Whether [authUserId] has an account link request, created by the session
  /// identified by [authId], that [linkedAuthUserId] has been attached to.
  ///
  /// Used by [TokenIssuer.issueToken] to decide whether a signed-in caller is
  /// allowed to be issued a token for a different user.
  static Future<bool> hasActiveAttachedRequest(
    final Session session, {
    required final UuidValue authUserId,
    required final String authId,
    required final UuidValue linkedAuthUserId,
    final Transaction? transaction,
  }) async {
    final request = await AccountLinkRequest.db.findFirstRow(
      session,
      where: (final t) =>
          t.authUserId.equals(authUserId) &
          t.authId.equals(authId) &
          t.linkedAuthUserId.equals(linkedAuthUserId) &
          (t.expiresAt > clock.now()),
      transaction: transaction,
    );

    return request != null;
  }

  static AuthenticationInfo _requireAuthentication(final Session session) {
    final authentication = session.authenticated;
    if (authentication == null) {
      throw StateError(
        'Account linking requires an authenticated caller.',
      );
    }

    return authentication;
  }

  static Future<AccountLinkRequest?> _findActiveRequest(
    final Session session, {
    required final UuidValue authUserId,
    required final String authId,
    required final Transaction? transaction,
  }) async {
    return AccountLinkRequest.db.findFirstRow(
      session,
      where: (final t) =>
          t.authUserId.equals(authUserId) &
          t.authId.equals(authId) &
          (t.expiresAt > clock.now()),
      transaction: transaction,
    );
  }

  /// Removes the caller's request, along with an attached account that only
  /// exists because of this flow.
  Future<void> _discardExistingRequest(
    final Session session, {
    required final UuidValue authUserId,
    required final Transaction transaction,
  }) async {
    final request = await AccountLinkRequest.db.findFirstRow(
      session,
      where: (final t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );
    if (request == null) {
      return;
    }

    final linkedAuthUserId = request.linkedAuthUserId;
    if (linkedAuthUserId != null &&
        (request.linkedAccountWasCreated ?? false)) {
      // Created by the linking sign-in and never claimed, so it holds nothing
      // the user could want. Leaving it behind would make the sign-in method
      // look like it belongs to a separate account on the next attempt.
      await AuthUser.db.deleteWhere(
        session,
        where: (final t) => t.id.equals(linkedAuthUserId),
        transaction: transaction,
      );
    }

    await AccountLinkRequest.db.deleteRow(
      session,
      request,
      transaction: transaction,
    );
  }

  Future<AccountLinkConflict> _describeAccount(
    final Session session, {
    required final UuidValue authUserId,
    required final String? method,
    required final Transaction transaction,
  }) async {
    final authUser = await AuthUser.db.findById(
      session,
      authUserId,
      transaction: transaction,
    );
    if (authUser == null) {
      throw AuthUserNotFoundException();
    }

    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (final t) => t.authUserId.equals(authUserId),
      include: UserProfile.include(image: UserProfileImage.include()),
      transaction: transaction,
    );

    return AccountLinkConflict(
      authUserId: authUserId,
      profile: profile?.toModel(),
      createdAt: authUser.createdAt,
      method: method ?? '',
    );
  }

  Future<void> _merge(
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    required final bool isNewlyCreated,
    required final Transaction transaction,
  }) async {
    try {
      await AuthServices.instance.accountMerger.merge(
        session,
        userToKeepId: userToKeepId,
        userToRemoveId: userToRemoveId,
        userToRemoveIsNewlyCreated: isNewlyCreated,
        transaction: transaction,
      );
    } catch (e, stackTrace) {
      session.log(
        'Failed to merge auth user $userToRemoveId into $userToKeepId while '
        'completing an account link request.',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );

      throw AccountMergeFailedException(
        userToKeepId: userToKeepId,
        userToRemoveId: userToRemoveId,
      );
    }
  }
}
