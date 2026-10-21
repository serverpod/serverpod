import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../localization/sign_in_localization_provider.dart';
import 'email_otp_auth_controller.dart';
import 'forms/otp_registration_complete.dart';
import 'forms/otp_start.dart';
import 'forms/shared/shared_password_reset_forms.dart';
import 'forms/shared/shared_verification_form.dart';
import 'forms/verification.dart';

/// Displays the current screen of the passwordless email authentication flow
/// driven by [controller], animating the transitions between screens.
class EmailOtpFlowView extends StatefulWidget {
  /// The controller that manages authentication state and logic.
  final EmailOtpAuthController controller;

  /// Configuration for the password reset verification code input.
  final VerificationCodeConfig verificationCodeConfig;

  /// Configuration for the one-time password input.
  final VerificationCodeConfig otpVerificationCodeConfig;

  /// Optional callback to call when the terms and conditions button is pressed.
  final VoidCallback? onTermsAndConditionsPressed;

  /// Optional callback to call when the privacy policy button is pressed.
  final VoidCallback? onPrivacyPolicyPressed;

  /// Creates an [EmailOtpFlowView].
  const EmailOtpFlowView({
    required this.controller,
    required this.verificationCodeConfig,
    this.otpVerificationCodeConfig = defaultOtpVerificationCodeConfig,
    this.onTermsAndConditionsPressed,
    this.onPrivacyPolicyPressed,
    super.key,
  });

  /// The default [otpVerificationCodeConfig], matching the default one-time
  /// passwords of the server.
  static const defaultOtpVerificationCodeConfig = VerificationCodeConfig(
    length: 6,
  );

  @override
  State<EmailOtpFlowView> createState() => _EmailOtpFlowViewState();
}

class _EmailOtpFlowViewState extends State<EmailOtpFlowView> {
  EmailOtpAuthController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerStateChanged);
  }

  @override
  void didUpdateWidget(EmailOtpFlowView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerStateChanged);
      widget.controller.addListener(_onControllerStateChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerStateChanged);
    super.dispose();
  }

  void _onControllerStateChanged() => setState(() {});

  void _backToSignIn() => _controller.navigateTo(EmailOtpFlowScreen.start);

  @override
  Widget build(BuildContext context) {
    final texts = context.emailSignInTexts;

    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 600),
      reverse: _controller.currentScreen != _controller.startScreen,
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          fillColor: Colors.transparent,
          child: child,
        );
      },
      child: _buildScreen(texts, context.emailWithOtpSignInTexts),
    );
  }

  Widget _buildScreen(
    EmailSignInTexts texts,
    EmailWithOtpSignInTexts otpTexts,
  ) {
    return switch (_controller.currentScreen) {
      EmailOtpFlowScreen.start => OtpStartForm(controller: _controller),
      EmailOtpFlowScreen.verify => SharedVerificationForm(
        title: otpTexts.verifyTitle,
        messageText: otpTexts.verificationMessage,
        controller: _controller,
        onCompleted: _controller.verifyOtpCode,
        onBackToSignIn: _backToSignIn,
        verifyButtonLabel: otpTexts.verifyAction,
        resendCodeLabel: otpTexts.resendCode,
        inlineAction: true,
        verificationCodeConfig: widget.otpVerificationCodeConfig,
      ),
      EmailOtpFlowScreen.completeRegistration => OtpCompleteRegistrationForm(
        controller: _controller,
        onTermsAndConditionsPressed: widget.onTermsAndConditionsPressed,
        onPrivacyPolicyPressed: widget.onPrivacyPolicyPressed,
      ),
      EmailOtpFlowScreen.requestPasswordReset => SharedRequestPasswordResetForm(
        controller: _controller,
        onBackToSignIn: _backToSignIn,
        inlineAction: true,
      ),
      EmailOtpFlowScreen.verifyPasswordReset => SharedVerificationForm(
        title: texts.verifyResetCodeTitle,
        messageText: texts.verificationMessage,
        controller: _controller,
        onCompleted: _controller.verifyPasswordResetCode,
        onBackToSignIn: _backToSignIn,
        verifyButtonLabel: texts.verify,
        resendCodeLabel: otpTexts.resendCode,
        inlineAction: true,
        verificationCodeConfig: widget.verificationCodeConfig,
      ),
      EmailOtpFlowScreen.completePasswordReset =>
        SharedCompletePasswordResetForm(
          controller: _controller,
          onBackToSignIn: _backToSignIn,
          inlineAction: true,
        ),
    };
  }
}
