import 'package:flutter/material.dart';

import '../email_auth_controller.dart';
import 'shared/shared_password_reset_forms.dart';

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
  Widget build(BuildContext context) => SharedCompletePasswordResetForm(
    controller: controller,
    onBackToSignIn: () => controller.navigateTo(EmailFlowScreen.login),
  );
}
