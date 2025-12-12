import 'package:flutter/material.dart';

import '../../common/widgets/buttons/text_button.dart';
import '../email_auth_controller.dart';
import 'widgets/set_password_form.dart';

/// Widget for completing registration by setting a password.
///
/// Displays a password field for users to set their password during
/// registration.
class CompleteRegistrationForm extends StatelessWidget {
  /// The controller that manages authentication state and logic.
  final EmailAuthController controller;

  /// Creates a [CompleteRegistrationForm] widget.
  const CompleteRegistrationForm({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SetPasswordForm(
      controller: controller,
      title: 'Set account password',
      passwordLabelText: 'Password',
      actionButtonLabel: 'Sign up',
      onActionPressed: controller.finishRegistration,
      bottomText: Center(
        child: HyperlinkTextButton(
          onPressed: () =>
              controller.navigateTo(EmailFlowScreen.startRegistration),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          label: 'Back to sign up',
        ),
      ),
    );
  }
}
