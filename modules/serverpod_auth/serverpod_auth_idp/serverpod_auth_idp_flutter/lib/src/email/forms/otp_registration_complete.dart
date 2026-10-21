import 'dart:async';

import 'package:flutter/material.dart';

import '../../common/widgets/buttons/action_button.dart';
import '../../common/widgets/buttons/text_button.dart';
import '../../common/widgets/gaps.dart';
import '../../common/widgets/password_field.dart';
import '../../common/widgets/password_requirements/widget.dart';
import '../../localization/sign_in_localization_provider.dart';
import '../email_flow_controller.dart';
import '../email_otp_auth_controller.dart';
import 'shared/shared_back_to_sign_in_button.dart';
import 'shared/shared_form_layout.dart';
import 'widgets/expandable_section.dart';
import 'widgets/terms_and_privacy.dart';

/// Form completing an account created through the passwordless flow.
///
/// Shown after the one-time password was verified for an email without an
/// account. Displays the terms checkbox, if any terms callback is provided.
/// If the server allows setting a password
/// ([EmailOtpAuthController.otpAllowPassword]), users can expand an optional
/// password field.
class OtpCompleteRegistrationForm extends StatefulWidget {
  /// The controller that manages authentication state and logic.
  final EmailOtpAuthController controller;

  /// Optional callback to call when the terms and conditions button is pressed.
  final VoidCallback? onTermsAndConditionsPressed;

  /// Optional callback to call when the privacy policy button is pressed.
  final VoidCallback? onPrivacyPolicyPressed;

  /// Creates an [OtpCompleteRegistrationForm] widget.
  const OtpCompleteRegistrationForm({
    required this.controller,
    this.onTermsAndConditionsPressed,
    this.onPrivacyPolicyPressed,
    super.key,
  });

  @override
  State<OtpCompleteRegistrationForm> createState() =>
      _OtpCompleteRegistrationFormState();
}

class _OtpCompleteRegistrationFormState
    extends State<OtpCompleteRegistrationForm> {
  EmailOtpAuthController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    controller.passwordController.removeListener(_onPasswordChanged);
    super.dispose();
  }

  void _onPasswordChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final otpTexts = context.emailWithOtpSignInTexts;
    final onTermsAndConditionsPressed = widget.onTermsAndConditionsPressed;
    final onPrivacyPolicyPressed = widget.onPrivacyPolicyPressed;

    final hasTermsAndConditions =
        onTermsAndConditionsPressed != null || onPrivacyPolicyPressed != null;
    final termsAccepted =
        !hasTermsAndConditions || controller.legalNoticeAcceptedNotifier.value;

    final allowPassword = controller.otpAllowPassword;
    final passwordRequirements = controller.passwordRequirements;
    final password = controller.passwordController.text;
    final isValidPassword =
        !allowPassword ||
        password.isEmpty ||
        passwordRequirements.isValid(password);

    return SharedFormLayout(
      scrollableContent: true,
      title: otpTexts.createAccountTitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The terms come first so they stay visible while the password
          // requirements expand below the optional password.
          if (hasTermsAndConditions)
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
          if (allowPassword) ...[
            if (hasTermsAndConditions) smallGap,
            Align(
              alignment: Alignment.centerLeft,
              child: HyperlinkTextButton(
                onPressed: controller.toggleRegistrationPassword,
                label: controller.isRegistrationPasswordExpanded
                    ? otpTexts.removePassword
                    : otpTexts.addPassword,
              ),
            ),
            ExpandableSection(
              expanded: controller.isRegistrationPasswordExpanded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  tinyGap,
                  PasswordField(
                    labelText: otpTexts.passwordLabel,
                    controller: controller.passwordController,
                    isLoading: controller.isLoading,
                  ),
                  ExpandableSection(
                    expanded:
                        password.isNotEmpty && passwordRequirements.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        tinyGap,
                        PasswordRequirements(
                          password: password,
                          requirements: passwordRequirements,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actionButton: ActionButton(
        onPressed:
            termsAccepted &&
                isValidPassword &&
                controller.state == EmailAuthState.idle
            ? () => unawaited(controller.finishOtpRegistration())
            : null,
        label: otpTexts.createAccount,
        isLoading: controller.isLoading,
      ),
      bottomText: SharedBackToSignInButton(
        onPressed: () => controller.navigateTo(EmailOtpFlowScreen.start),
      ),
    );
  }
}
