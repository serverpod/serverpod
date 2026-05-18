import 'package:flutter/material.dart';

/// Coordinator that manages full-screen UI blocking and navigation locking
/// during authentication processes.
class SignInFlowCoordinator extends InheritedNotifier<ValueNotifier<bool>> {
  /// Creates a coordinator that exposes the current authentication lock state.
  const SignInFlowCoordinator({
    super.key,
    required ValueNotifier<bool> isAuthenticating,
    required super.child,
  }) : super(notifier: isAuthenticating);

  /// Returns the active coordinator state from [context], if present.
  static SignInFlowCoordinatorState? of(BuildContext context) {
    return context.findAncestorStateOfType<SignInFlowCoordinatorState>();
  }
}

/// Root widget that installs [SignInFlowCoordinator] for descendant sign-in UI.
class SignInFlowCoordinatorWidget extends StatefulWidget {
  /// The sign-in UI that should be blocked while authentication is in progress.
  final Widget child;

  /// Creates a coordinator scope for the provided [child].
  const SignInFlowCoordinatorWidget({super.key, required this.child});

  @override
  State<SignInFlowCoordinatorWidget> createState() =>
      SignInFlowCoordinatorState();
}

/// State object that owns the authentication lock overlay and navigation guard.
class SignInFlowCoordinatorState extends State<SignInFlowCoordinatorWidget> {
  final ValueNotifier<bool> _isAuthenticating = ValueNotifier<bool>(false);
  OverlayEntry? _activeOverlayEntry;

  /// Whether an authentication flow is currently blocking interaction.
  bool get isAuthenticating => _isAuthenticating.value;

  /// Blocks interaction and back navigation while authentication is in progress.
  void lockUI() {
    if (_isAuthenticating.value) return;
    _isAuthenticating.value = true;

    _activeOverlayEntry = OverlayEntry(
      builder: (context) {
        return const Positioned.fill(
          child: AbsorbPointer(
            absorbing: true,
            child: SizedBox.expand(),
          ),
        );
      },
    );

    Overlay.of(context).insert(_activeOverlayEntry!);
  }

  /// Restores interaction and back navigation after authentication completes.
  void unlockUI() {
    if (!_isAuthenticating.value) return;
    _isAuthenticating.value = false;

    _activeOverlayEntry?.remove();
    _activeOverlayEntry?.dispose();
    _activeOverlayEntry = null;
  }

  @override
  void dispose() {
    _activeOverlayEntry?.remove();
    _activeOverlayEntry?.dispose();
    _activeOverlayEntry = null;
    _isAuthenticating.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignInFlowCoordinator(
      isAuthenticating: _isAuthenticating,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isAuthenticating,
        builder: (context, isAuthenticating, child) {
          return PopScope(
            canPop: !isAuthenticating,
            child: child!,
          );
        },
        child: widget.child,
      ),
    );
  }
}
