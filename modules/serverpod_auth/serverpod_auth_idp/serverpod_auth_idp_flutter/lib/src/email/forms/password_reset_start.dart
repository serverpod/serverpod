import 'package:flutter/material.dart';

import '../../common/widgets/buttons/text_button.dart';
import '../../localization/sign_in_localization_provider.dart';
import '../email_auth_controller.dart';
import 'shared/shared_password_reset_forms.dart';

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
    final texts = context.emailSignInTexts;

    return SharedRequestPasswordResetForm(
      controller: controller,
      onBackToSignIn: () => controller.navigateTo(EmailFlowScreen.login),
      bottomText: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(texts.dontHaveAnAccount),
          HyperlinkTextButton(
            onPressed: () =>
                controller.navigateTo(EmailFlowScreen.startRegistration),
            label: texts.signUp,
          ),
        ],
      ),
    );
  }
}
