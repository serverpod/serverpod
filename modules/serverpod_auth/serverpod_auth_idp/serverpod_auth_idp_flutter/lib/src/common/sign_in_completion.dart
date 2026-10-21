import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import 'account_linking_controller.dart';

/// Handles the [AuthSuccess] of a completed sign-in instead of signing the user
/// in with it.
///
/// Used for account linking, where the user stays signed in to their existing
/// account and the new sign-in only serves as proof that they control the
/// account being linked.
typedef OnAuthSuccessCallback = Future<void> Function(AuthSuccess authSuccess);

/// Finishes a sign-in by signing the user in, unless [accountLinking] or
/// [onAuthSuccess] takes over.
///
/// Identity provider controllers call this rather than
/// [ClientAuthSessionManager.updateSignedInUser] directly, so that a linking
/// flow can hold on to the result without changing who is signed in.
Future<bool> completeSignIn(
  final ServerpodClientShared client,
  final AuthSuccess authSuccess, {
  final AccountLinkingController? accountLinking,
  final OnAuthSuccessCallback? onAuthSuccess,
}) async {
  if (accountLinking != null) {
    await accountLinking.handleAuthSuccess(authSuccess);
    return false;
  }
  if (onAuthSuccess != null) {
    await onAuthSuccess(authSuccess);
    return false;
  }

  await client.auth.updateSignedInUser(authSuccess);
  return true;
}
