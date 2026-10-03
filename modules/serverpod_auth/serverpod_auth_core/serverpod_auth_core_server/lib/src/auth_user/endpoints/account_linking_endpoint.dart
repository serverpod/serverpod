import 'package:serverpod/serverpod.dart';

import '../../common/business/auth_services.dart';
import '../../generated/protocol.dart';
import '../business/account_link_requests.dart';

/// Endpoint for linking an additional sign-in method to the current account.
///
/// The flow has three steps:
///
/// 1. Call [createLinkRequest] while signed in.
/// 2. Sign in with the additional provider as usual. The response carries a
///    token for that account, which the client keeps rather than signing in
///    with, since the user stays signed in to their original account.
/// 3. Call [executeLinkRequest] with that token.
///
/// See also:
///   - [AccountLinkRequests], which implements the flow.
class AccountLinkingEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Gets the [AccountLinkRequests] from the [AuthServices] instance.
  ///
  /// If [AccountLinkRequests] should be fetched from a different source,
  /// override this method.
  AccountLinkRequests get accountLinkRequests =>
      AuthServices.instance.accountLinkRequests;

  /// Starts an account link flow for the calling user and session.
  ///
  /// Any previous request for this user is replaced, so the flow can be
  /// restarted at any point.
  ///
  /// See [AccountLinkRequests.createLinkRequest].
  Future<void> createLinkRequest(final Session session) async {
    return accountLinkRequests.createLinkRequest(session);
  }

  /// Cancels the calling user's account link flow, if one is in progress.
  ///
  /// Call this as soon as the user declines a merge or dismisses the linking
  /// UI, so that signing in as another user from this session is rejected
  /// again without waiting for the request to expire.
  ///
  /// See [AccountLinkRequests.cancelLinkRequest].
  Future<void> cancelLinkRequest(final Session session) async {
    return accountLinkRequests.cancelLinkRequest(session);
  }

  /// Completes the calling user's account link flow.
  ///
  /// [proofToken] is the token returned by the sign-in with the additional
  /// provider, and proves that the caller controls the account being linked.
  ///
  /// Returns [AccountLinkStatus.mergeRequired] without changing anything when
  /// the sign-in method already belongs to another account and [approveMerge]
  /// is not set. Present the returned conflict to the user, then call this
  /// again with [approveMerge] set to merge that account in and remove it.
  ///
  /// See [AccountLinkRequests.executeLinkRequest].
  Future<AccountLinkResult> executeLinkRequest(
    final Session session, {
    required final String proofToken,
    final bool approveMerge = false,
  }) async {
    return accountLinkRequests.executeLinkRequest(
      session,
      proofToken: proofToken,
      approveMerge: approveMerge,
    );
  }
}
