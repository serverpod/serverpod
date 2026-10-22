import 'package:flutter/material.dart';

import '../../../common/widgets/buttons/action_button.dart';
import '../../../common/widgets/gaps.dart';
import '../../../localization/sign_in_localization_provider.dart';
import '../../email_flow_controller.dart';
import 'shared_back_to_sign_in_button.dart';
import 'shared_email_text_field.dart';
import 'shared_form_layout.dart';
import 'shared_set_password_form.dart';

/// Password reset request form, shared by the email authentication flows.
///
/// Displays an email field for users to request a password reset.
class SharedRequestPasswordResetForm extends StatelessWidget {
  /// The controller of the email authentication flow.
  final EmailFlowController<Enum> controller;

  /// Navigates to the sign-in screen of the flow.
  final VoidCallback onBackToSignIn;

  /// Optional widget to display below the action button.
  final Widget? bottomText;

  /// Whether the content scrolls when it does not fit the form.
  final bool scrollableContent;

  /// Creates a [SharedRequestPasswordResetForm] widget.
  const SharedRequestPasswordResetForm({
    required this.controller,
    required this.onBackToSignIn,
    this.bottomText,
    this.scrollableContent = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.emailSignInTexts;

    return SharedFormLayout(
      scrollableContent: scrollableContent,
      title: texts.resetPasswordTitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            texts.resetPasswordDescription,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
          smallGap,
          SharedEmailTextField(controller: controller),
          tinyGap,
          SharedBackToSignInButton(onPressed: onBackToSignIn),
        ],
      ),
      actionButton: ActionButton(
        onPressed:
            controller.emailController.text.isNotEmpty &&
                controller.state == EmailAuthState.idle
            ? controller.startPasswordReset
            : null,
        label: texts.requestPasswordReset,
        isLoading: controller.isLoading,
      ),
      bottomText: bottomText,
    );
  }
}

/// Form for completing a password reset by setting a new password, shared by
/// the email authentication flows.
class SharedCompletePasswordResetForm extends StatelessWidget {
  /// The controller of the email authentication flow.
  final EmailFlowController<Enum> controller;

  /// Navigates to the sign-in screen of the flow.
  final VoidCallback onBackToSignIn;

  /// Whether the content scrolls when it does not fit the form.
  final bool scrollableContent;

  /// Creates a [SharedCompletePasswordResetForm] widget.
  const SharedCompletePasswordResetForm({
    required this.controller,
    required this.onBackToSignIn,
    this.scrollableContent = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.emailSignInTexts;

    return SharedSetPasswordForm(
      controller: controller,
      title: texts.setNewPasswordTitle,
      passwordLabelText: texts.newPasswordLabel,
      actionButtonLabel: texts.resetPassword,
      onActionPressed: controller.finishPasswordReset,
      bottomText: SharedBackToSignInButton(onPressed: onBackToSignIn),
      scrollableContent: scrollableContent,
    );
  }
}
