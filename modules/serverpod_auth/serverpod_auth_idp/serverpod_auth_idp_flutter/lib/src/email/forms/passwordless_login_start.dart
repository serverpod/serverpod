import 'dart:async';

import 'package:flutter/material.dart';

import '../../common/widgets/buttons/action_button.dart';
import '../../common/widgets/buttons/text_button.dart';
import '../../common/widgets/gaps.dart';
import '../../localization/sign_in_localization_provider.dart';
import '../email_auth_controller.dart';
import 'widgets/email_text_field.dart';
import 'widgets/form_standard_layout.dart';
import 'widgets/terms_and_privacy.dart';

/// Passwordless login form widget for email authentication.
///
/// Displays an email field for the user to request a verification code to sign
/// in with. After submission, the user proceeds to the verification screen.
class PasswordlessLoginStartForm extends StatelessWidget {
  /// The controller that manages authentication state and logic.
  final EmailAuthController controller;

  /// A widget shown below the email field to inform the user about terms and
  /// conditions, a privacy policy, or any other consent that applies to
  /// creating an account.
  ///
  /// This is a notice and does not block the continue button. If provided,
  /// [onTermsAndConditionsPressed] and [onPrivacyPolicyPressed] are ignored.
  final Widget? consentNotice;

  /// Optional callback to call when the terms and conditions button is pressed.
  ///
  /// If this or [onPrivacyPolicyPressed] is provided, and no [consentNotice]
  /// is, a checkbox that has to be checked before a code is requested is shown.
  final VoidCallback? onTermsAndConditionsPressed;

  /// Optional callback to call when the privacy policy button is pressed.
  ///
  /// See [onTermsAndConditionsPressed].
  final VoidCallback? onPrivacyPolicyPressed;

  /// Whether to show a link to sign in with a password instead.
  final bool showUsePasswordLink;

  /// Creates a [PasswordlessLoginStartForm] widget.
  const PasswordlessLoginStartForm({
    required this.controller,
    this.consentNotice,
    this.onTermsAndConditionsPressed,
    this.onPrivacyPolicyPressed,
    this.showUsePasswordLink = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.emailSignInTexts;
    final consentNotice = this.consentNotice;
    final requiresAcceptance =
        consentNotice == null &&
        (onTermsAndConditionsPressed != null || onPrivacyPolicyPressed != null);

    return FormStandardLayout(
      title: texts.passwordlessTitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The notice and the texts are of unknown length, so this part
          // scrolls instead of overflowing the fixed height of the layout.
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    texts.passwordlessDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  smallGap,
                  EmailTextField(controller: controller),
                  if (controller.resendCooldownActive) ...[
                    smallGap,
                    Text(
                      texts.passwordlessResendCooldownMessage,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (consentNotice != null) ...[
                    smallGap,
                    DefaultTextStyle.merge(
                      style: Theme.of(context).textTheme.bodySmall,
                      child: consentNotice,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (requiresAcceptance) ...[
            SizedBox(
              height: 40,
              child: TermsAndPrivacyText(
                onTermsAndConditionsPressed: onTermsAndConditionsPressed,
                onPrivacyPolicyPressed: onPrivacyPolicyPressed,
                isChecked: controller.legalNoticeAcceptedNotifier.value,
                onCheckboxChanged: (value) =>
                    controller.legalNoticeAcceptedNotifier.value =
                        value ?? false,
              ),
            ),
            smallGap,
          ],
        ],
      ),
      actionButton: ActionButton(
        onPressed:
            controller.emailController.text.isNotEmpty &&
                controller.state == EmailAuthState.idle &&
                (!requiresAcceptance ||
                    controller.legalNoticeAcceptedNotifier.value)
            ? () => unawaited(controller.startPasswordlessLogin())
            : null,
        label: texts.passwordlessContinueAction,
        isLoading: controller.isLoading,
      ),
      bottomText: showUsePasswordLink
          ? Center(
              child: HyperlinkTextButton(
                onPressed: () => controller.navigateTo(EmailFlowScreen.login),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                label: texts.usePasswordInstead,
              ),
            )
          : null,
    );
  }
}
