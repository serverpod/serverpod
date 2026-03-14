import 'package:flutter/material.dart';

import '../../common/widgets/buttons/text_button.dart';
import '../../localization/sign_in_localization_provider.dart';
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
    final texts = context.emailSignInTexts;

    return SetPasswordForm(
      controller: controller,
      title: texts.setAccountPasswordTitle,
      passwordLabelText: texts.passwordLabel,
      actionButtonLabel: texts.signUp,
      onActionPressed: controller.finishRegistration,
      bottomText: Center(
        child: HyperlinkTextButton(
          onPressed: () =>
              controller.navigateTo(EmailFlowScreen.startRegistration),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          label: texts.backToSignUp,
        ),
      ),
    );
  }
}
