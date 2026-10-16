import 'dart:async';

import 'package:flutter/material.dart';

import '../../common/widgets/buttons/action_button.dart';
import '../../common/widgets/buttons/text_button.dart';
import '../../common/widgets/gaps.dart';
import '../../common/widgets/password_field.dart';
import '../../localization/sign_in_localization_provider.dart';
import '../email_flow_controller.dart';
import '../email_otp_auth_controller.dart';
import 'shared/shared_email_text_field.dart';
import 'widgets/expandable_section.dart';
import 'widgets/form_inline_action_layout.dart';

/// Start form of the passwordless email authentication flow.
///
/// Displays an email field with the action to request a one-time password
/// right below it. If [EmailOtpAuthController.allowPasswordSignIn] is `true`,
/// users can expand a password field to sign in with their password instead,
/// which pushes the action down and turns it into a sign-in action.
class OtpStartForm extends StatelessWidget {
  /// The controller that manages authentication state and logic.
  final EmailOtpAuthController controller;

  /// Creates an [OtpStartForm] widget.
  const OtpStartForm({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final texts = context.emailSignInTexts;
    final otpTexts = context.emailWithOtpSignInTexts;
    final usePassword = controller.isPasswordSignInExpanded;
    final hasEmail = controller.emailController.text.isNotEmpty;
    final isIdle = controller.state == EmailAuthState.idle;

    final VoidCallback? onActionPressed;
    if (usePassword) {
      onActionPressed =
          hasEmail && controller.passwordController.text.isNotEmpty && isIdle
          ? controller.login
          : null;
    } else {
      onActionPressed = hasEmail && isIdle
          ? () => unawaited(controller.startOtpLogin())
          : null;
    }

    return FormInlineActionLayout(
      title: otpTexts.startTitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SharedEmailTextField(controller: controller),
          ExpandableSection(
            expanded: usePassword,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                smallGap,
                PasswordField(
                  labelText: texts.passwordLabel,
                  controller: controller.passwordController,
                  isLoading: controller.isLoading,
                ),
                tinyGap,
                Align(
                  alignment: Alignment.centerRight,
                  child: HyperlinkTextButton(
                    onPressed: () => controller.navigateTo(
                      EmailOtpFlowScreen.requestPasswordReset,
                    ),
                    label: texts.forgotPassword,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actionButton: ActionButton(
        onPressed: onActionPressed,
        label: usePassword ? texts.signIn : otpTexts.sendCode,
        isLoading: controller.isLoading,
      ),
      bottomText: controller.allowPasswordSignIn
          ? Center(
              child: HyperlinkTextButton(
                onPressed: controller.togglePasswordSignIn,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                label: usePassword
                    ? otpTexts.signInWithCode
                    : otpTexts.signInWithPassword,
              ),
            )
          : null,
    );
  }
}
