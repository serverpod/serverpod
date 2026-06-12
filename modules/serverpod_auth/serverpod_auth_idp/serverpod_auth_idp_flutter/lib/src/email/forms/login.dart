import 'package:flutter/material.dart';

import '../../localization/sign_in_localization_provider.dart';
import '../../common/widgets/buttons/action_button.dart';
import '../../common/widgets/buttons/text_button.dart';
import '../../common/widgets/gaps.dart';
import '../../common/widgets/password_field.dart';
import '../email_auth_controller.dart';
import 'widgets/email_text_field.dart';
import 'widgets/form_standard_layout.dart';

/// Login form widget for email authentication.
///
/// Displays email and password fields with options to sign in, create a new
/// account, or reset password.
class LoginForm extends StatelessWidget {
  /// The controller that manages authentication state and logic.
  final EmailAuthController controller;

  /// Creates a [LoginForm] widget.
  const LoginForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final texts = context.emailSignInTexts;

    return FormStandardLayout(
      title: texts.title,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmailTextField(controller: controller),
          smallGap,
          PasswordField(
            controller: controller.passwordController,
            isLoading: controller.isLoading,
          ),
          tinyGap,
          Align(
            alignment: Alignment.centerRight,
            child: HyperlinkTextButton(
              onPressed: () =>
                  controller.navigateTo(EmailFlowScreen.requestPasswordReset),
              label: texts.forgotPassword,
            ),
          ),
        ],
      ),
      actionButton: ActionButton(
        onPressed:
            controller.emailController.text.isNotEmpty &&
                controller.passwordController.text.isNotEmpty &&
                controller.state == EmailAuthState.idle
            ? controller.login
            : null,
        label: texts.signIn,
        isLoading: controller.isLoading,
      ),
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
