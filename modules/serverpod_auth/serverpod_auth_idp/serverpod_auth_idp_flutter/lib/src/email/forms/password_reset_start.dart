import 'package:flutter/material.dart';

import '../../common/widgets/buttons/action_button.dart';
import '../../common/widgets/buttons/text_button.dart';
import '../../common/widgets/gaps.dart';
import '../email_auth_controller.dart';
import 'widgets/email_text_field.dart';
import 'widgets/back_to_sign_in_button.dart';
import 'widgets/form_standard_layout.dart';

/// Password reset request form widget.
///
/// Displays an email field for users to request a password reset.
class RequestPasswordResetForm extends StatelessWidget {
  /// The controller that manages authentication state and logic.
  final EmailAuthController controller;

  /// Creates a [RequestPasswordResetForm] widget.
  const RequestPasswordResetForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FormStandardLayout(
      title: 'Reset password',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enter the email address to reset password.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
          smallGap,
          EmailTextField(controller: controller),
          tinyGap,
          BackToSignInButton(controller: controller),
        ],
      ),
      actionButton: ActionButton(
        onPressed:
            controller.emailController.text.isNotEmpty &&
                controller.state == EmailAuthState.idle
            ? controller.startPasswordReset
            : null,
        label: 'Request password reset',
        isLoading: controller.isLoading,
      ),
      bottomText: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account?"),
          HyperlinkTextButton(
            onPressed: () =>
                controller.navigateTo(EmailFlowScreen.startRegistration),
            label: 'Sign up',
          ),
        ],
      ),
    );
  }
}
