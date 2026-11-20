import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

/// Asks the user whether the account described by [conflict] should be merged
/// into the account they are signed in to.
///
/// Return `true` to merge the accounts, which removes the described account, or
/// `false` to abandon the link.
typedef ConfirmAccountMergeCallback =
    Future<bool> Function(AccountLinkConflict conflict);

/// The stage an account link flow has reached.
enum AccountLinkingState {
  /// No link flow is in progress.
  idle,

  /// A link request is being created, or a completed sign-in is being linked.
  busy,

  /// Waiting for the user to sign in with the provider they are linking.
  awaitingSignIn,

  /// The sign-in method was linked to the user's account.
  linked,
}

/// Drives the client side of linking an additional sign-in method to the
/// account the user is already signed in to.
///
/// Pass an instance to [SignInWidget] to put it in linking mode: the widget
/// starts the flow, and every provider it shows reports back here instead of
/// signing the user in.
///
/// Example usage:
/// ```dart
/// SignInWidget(
///   client: client,
///   accountLinking: AccountLinkingController(
///     client: client,
///     confirmMerge: (final conflict) => showMergeDialog(context, conflict),
///     onLinked: () => Navigator.of(context).pop(),
///   ),
/// );
/// ```
class AccountLinkingController extends ChangeNotifier {
  /// The Serverpod client instance.
  final ServerpodClientShared client;

  /// Asks the user to approve merging a pre-existing account into theirs.
  ///
  /// Called only when the sign-in method already belongs to another account.
  /// If this is not set, such a link is abandoned rather than merged.
  final ConfirmAccountMergeCallback? confirmMerge;

  /// Called once the sign-in method has been linked to the user's account.
  final VoidCallback? onLinked;

  /// Called when an account link attempt was cancelled or declined.
  final VoidCallback? onCancelled;

  /// Called when the link could not be completed.
  ///
  /// The [error] parameter is an exception that should be shown to the user.
  final void Function(Object error)? onError;

  /// Creates an account linking controller.
  AccountLinkingController({
    required this.client,
    this.confirmMerge,
    this.onLinked,
    this.onCancelled,
    this.onError,
  });

  AccountLinkingState _state = AccountLinkingState.idle;
  bool _disposed = false;

  /// The stage the flow has reached.
  AccountLinkingState get state => _state;

  /// Whether the controller is waiting on the server.
  bool get isBusy => _state == AccountLinkingState.busy;

  EndpointAccountLinking get _endpoint => client.auth.caller.accountLinking;

  /// Tells the server that the next sign-in from this session is a link
  /// attempt rather than a switch to another account.
  Future<void> start() async {
    if (_disposed || _state != AccountLinkingState.idle) return;

    _setState(AccountLinkingState.busy);
    try {
      await _endpoint.createLinkRequest();
      if (_disposed) {
        _endpoint.cancelLinkRequest().ignore();
        return;
      }
      _setState(AccountLinkingState.awaitingSignIn);
    } catch (e) {
      _setState(AccountLinkingState.idle);
      _reportError(e);
    }
  }

  /// Links the account that was just signed in to.
  ///
  /// Pass this as the sign-in completion callback of the provider widgets, so
  /// that [authSuccess] is used as proof of ownership instead of signing the
  /// user in with it.
  Future<void> handleAuthSuccess(final AuthSuccess authSuccess) async {
    _setState(AccountLinkingState.busy);
    try {
      // A first pass without approval, which reports back rather than merging
      // if the sign-in method turns out to belong to another account.
      var result = await _endpoint.executeLinkRequest(
        proofToken: authSuccess.token,
        approveMerge: false,
      );

      if (result.status == AccountLinkStatus.mergeRequired) {
        final conflict = result.conflict;
        final confirmMerge = this.confirmMerge;
        if (conflict == null || confirmMerge == null) {
          // The application does not offer merging, so report the error and
          // leave both accounts as they are.
          _reportError(AccountMergeNotConfiguredException());
          await cancel();
          onCancelled?.call();
          return;
        }

        if (!await confirmMerge(conflict)) {
          await cancel();
          onCancelled?.call();
          return;
        }

        result = await _endpoint.executeLinkRequest(
          proofToken: authSuccess.token,
          approveMerge: true,
        );
      }

      _setState(AccountLinkingState.linked);
      onLinked?.call();
    } catch (e) {
      _setState(AccountLinkingState.idle);
      _reportError(e);
    }
  }

  /// Abandons the link flow.
  ///
  /// Call this when the user backs out, so that signing in as another user from
  /// this session is rejected again straight away rather than staying possible
  /// until the request expires.
  Future<void> cancel() async {
    if (_state == AccountLinkingState.idle ||
        _state == AccountLinkingState.linked) {
      return;
    }

    _setState(AccountLinkingState.idle);
    try {
      await _endpoint.cancelLinkRequest();
    } catch (e) {
      debugPrint('Failed to cancel the account link request: $e');
    }
  }

  @override
  void dispose() {
    _disposed = true;
    if (_state == AccountLinkingState.awaitingSignIn) {
      // Best effort: the widget is going away, so nothing can await this.
      _endpoint.cancelLinkRequest().ignore();
    }
    super.dispose();
  }

  void _setState(final AccountLinkingState state) {
    if (_disposed || _state == state) return;
    _state = state;
    notifyListeners();
  }

  void _reportError(final Object error) {
    if (onError case final onError?) {
      onError(error);
      return;
    }
    debugPrint('Account linking failed: $error');
  }
}
