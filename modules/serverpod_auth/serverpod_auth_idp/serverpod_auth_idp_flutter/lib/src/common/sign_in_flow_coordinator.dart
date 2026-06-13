import 'dart:async';

import 'package:flutter/material.dart';

/// Root widget that installs sign-in flow coordination for descendant UI.
class SignInFlowCoordinatorWidget extends StatefulWidget {
  /// The sign-in UI that should be blocked while authentication is in progress.
  final Widget child;

  /// Creates a coordinator scope for the provided [child].
  const SignInFlowCoordinatorWidget({super.key, required this.child});

  /// Maximum time the UI stays locked before automatically unlocking.
  static const lockTimeout = Duration(seconds: 30);

  /// Returns the active coordinator state from [context], if present.
  static SignInFlowCoordinatorState? of(BuildContext context) {
    return context.findAncestorStateOfType<SignInFlowCoordinatorState>();
  }

  @override
  State<SignInFlowCoordinatorWidget> createState() =>
      SignInFlowCoordinatorState();
}

/// State object that owns the authentication lock overlay and navigation guard.
class SignInFlowCoordinatorState extends State<SignInFlowCoordinatorWidget> {
  final ValueNotifier<bool> _isAuthenticating = ValueNotifier<bool>(false);
  OverlayEntry? _activeOverlayEntry;
  Timer? _lockTimeout;

  /// Whether an authentication flow is currently blocking interaction.
  bool get isAuthenticating => _isAuthenticating.value;

  /// Blocks interaction and back navigation while authentication is in progress.
  ///
  /// The lock is released automatically after [SignInFlowCoordinatorWidget.lockTimeout]
  /// if authentication has not completed yet.
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

    _lockTimeout?.cancel();
    _lockTimeout = Timer(SignInFlowCoordinatorWidget.lockTimeout, () {
      if (mounted) {
        unlockUI();
      }
    });
  }

  /// Restores interaction and back navigation after authentication completes.
  void unlockUI() {
    if (!_isAuthenticating.value) return;
    _isAuthenticating.value = false;

    _lockTimeout?.cancel();
    _lockTimeout = null;

    _activeOverlayEntry?.remove();
    _activeOverlayEntry?.dispose();
    _activeOverlayEntry = null;
  }

  @override
  void dispose() {
    _lockTimeout?.cancel();
    _lockTimeout = null;
    _activeOverlayEntry?.remove();
    _activeOverlayEntry?.dispose();
    _activeOverlayEntry = null;
    _isAuthenticating.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isAuthenticating,
      builder: (context, isAuthenticating, child) {
        return PopScope(
          canPop: !isAuthenticating,
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}
