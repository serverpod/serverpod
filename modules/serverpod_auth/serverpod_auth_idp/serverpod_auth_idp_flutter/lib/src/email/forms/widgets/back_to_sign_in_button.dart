import 'package:flutter/material.dart';

import '../../email_auth_controller.dart';
import '../shared/shared_back_to_sign_in_button.dart';

/// A widget for displaying a "Back to sign in" button.
class BackToSignInButton extends StatelessWidget {
  /// The controller that manages navigation state.
  final EmailAuthController controller;

  /// Creates a [BackToSignInButton] widget.
  const BackToSignInButton({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SharedBackToSignInButton(
    onPressed: () => controller.navigateTo(EmailFlowScreen.login),
  );
}
