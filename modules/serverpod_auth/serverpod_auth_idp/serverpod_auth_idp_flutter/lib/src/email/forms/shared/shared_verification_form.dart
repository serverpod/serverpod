import 'package:flutter/material.dart';

import '../../../common/widgets/buttons/action_button.dart';
import '../../../common/widgets/buttons/resend_code_button.dart';
import '../../../common/widgets/gaps.dart';
import '../../../common/widgets/verification_code.dart';
import '../../../localization/sign_in_localization_provider.dart';
import '../../email_flow_controller.dart';
import '../verification.dart' show VerificationCodeConfig;
import 'shared_back_to_sign_in_button.dart';
import 'shared_form_layout.dart';

/// Pattern with the default server-side characters in the verification code.
///
/// The default is to generate codes with digits from [1-9].
final _defaultAllowedCharacters = RegExp(r'[1-9]');

/// Email verification form widget, shared by the email authentication flows.
///
/// Displays a verification code input field for users to validate a request.
class SharedVerificationForm extends StatefulWidget {
  /// The controller of the email authentication flow.
  final EmailFlowController<Enum> controller;

  /// Navigates to the sign-in screen of the flow.
  final VoidCallback onBackToSignIn;

  /// Callback to call when verification is completed.
  ///
  /// Should navigate to the next screen.
  final VoidCallback onCompleted;

  /// The title of the form.
  final String title;

  /// Optional message text to display.
  ///
  /// If not provided, defaults to the registration verification message.
  final String? messageText;

  /// Optional label for the verify button.
  ///
  /// If not provided, defaults to 'Verify'.
  final String? verifyButtonLabel;

  /// Configuration for the verification code input.
  final VerificationCodeConfig verificationCodeConfig;

  /// Optional text for the action requesting a new code.
  ///
  /// If not provided, defaults to [ResendCodeButton.defaultLabel].
  final String? resendCodeLabel;

  /// Whether the content scrolls when it does not fit the form.
  final bool scrollableContent;

  /// Creates a [SharedVerificationForm] widget.
  const SharedVerificationForm({
    required this.onBackToSignIn,
    required this.title,
    required this.controller,
    required this.onCompleted,
    required this.verificationCodeConfig,
    this.messageText,
    this.verifyButtonLabel,
    this.resendCodeLabel,
    this.scrollableContent = false,
    super.key,
  });

  @override
  State<SharedVerificationForm> createState() => _SharedVerificationFormState();
}

class _SharedVerificationFormState extends State<SharedVerificationForm> {
  late final FocusNode focusNode;

  EmailFlowController<Enum> get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();

    controller.addListener(_onControllerStateChanged);
  }

  /// Automatically focus the verification code input when an error occurs for
  /// the user to correct it.
  void _onControllerStateChanged() {
    if (!mounted) return;
    if (controller.state == EmailAuthState.error) {
      focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerStateChanged);
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.emailSignInTexts;
    final config = widget.verificationCodeConfig;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.messageText ?? texts.verificationMessage,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.left,
        ),
        smallGap,
        VerificationCodeInput(
          focusNode: focusNode,
          verificationCodeController: controller.verificationCodeController,
          onCompleted: widget.onCompleted,
          isLoading: controller.isLoading,
          length: config.length,
          keyboardType: config.keyboardType,
          allowedLetterCase: config.allowedLetterCase,
          allowedCharactersPattern:
              config.allowedCharactersPattern ?? _defaultAllowedCharacters,
        ),
        ResendCodeButton(
          onResendPressed: controller.resendVerificationCode,
          countdownDuration: config.resendCountdownDuration,
          label: widget.resendCodeLabel ?? ResendCodeButton.defaultLabel,
        ),
      ],
    );
    final actionButton = ActionButton(
      onPressed: widget.onCompleted,
      label: widget.verifyButtonLabel ?? texts.verify,
      isLoading: controller.isLoading,
    );
    final bottomText = SharedBackToSignInButton(
      onPressed: widget.onBackToSignIn,
    );

    return SharedFormLayout(
      scrollableContent: widget.scrollableContent,
      title: widget.title,
      content: content,
      actionButton: actionButton,
      bottomText: bottomText,
    );
  }
}
