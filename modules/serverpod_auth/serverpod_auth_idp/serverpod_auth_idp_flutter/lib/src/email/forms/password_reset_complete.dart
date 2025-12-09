import 'package:flutter/material.dart';

import '../email_auth_controller.dart';
import 'widgets/back_to_sign_in_button.dart';
import 'widgets/set_password_form.dart';

/// Widget for completing password reset by setting a new password.
///
/// Displays a password field for users to set a new password after password
/// reset verification.
class CompletePasswordResetForm extends StatelessWidget {
  /// The controller that manages authentication state and logic.
  final EmailAuthController controller;

  /// Creates a [CompletePasswordResetForm] widget.
  const CompletePasswordResetForm({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SetPasswordForm(
      controller: controller,
      title: 'Set new password',
      passwordLabelText: 'New Password',
      actionButtonLabel: 'Reset password',
      onActionPressed: controller.finishPasswordReset,
      bottomText: BackToSignInButton(controller: controller),
    );
  }
}
