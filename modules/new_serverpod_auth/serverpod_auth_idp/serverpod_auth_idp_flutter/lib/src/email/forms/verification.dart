import 'package:flutter/material.dart';

import '../../common/text_formatters.dart';
import '../../common/widgets/buttons/action_button.dart';
import '../../common/widgets/gaps.dart';
import '../../common/widgets/verification_code.dart';
import '../email_auth_controller.dart';
import 'widgets/back_to_sign_in_button.dart';
import 'widgets/form_standard_layout.dart';
import '../../common/widgets/buttons/resend_code_button.dart';

/// Pattern with the default server-side characters in the verification code.
///
/// The code uses a slightly reduced alphabet from [a-z0-9] to exclude easily
/// confused characters (e.g. 0, O, l).
final _defaultAllowedCharacters = RegExp(r'[abcdefghikmnpqrstuvwxyz123456789]');

/// Email verification form widget.
///
/// Displays a verification code input field for users to validate a request.
class VerificationForm extends StatefulWidget {
  /// The controller that manages authentication state and logic.
  final EmailAuthController controller;

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

  /// The duration of the countdown timer for resending the code.
  final Duration resendCountdownDuration;

  /// The keyboard type to use for the verification code input.
  final TextInputType keyboardType;

  /// The case of letters allowed in the verification code input.
  final LetterCase allowedLetterCase;

  /// A pattern of the allowed characters in the verification code input.
  ///
  /// This value must be synchronized with the server-side configuration. If
  /// not provided, will restrict to the default configuration of the server,
  /// which allows only lowercase alphanumeric characters and excludes visually
  /// similar characters like 0, O, 1, l.
  final Pattern? allowedCharactersPattern;

  /// Creates a [VerificationForm] widget.
  const VerificationForm({
    required this.title,
    required this.controller,
    required this.onCompleted,
    this.messageText,
    this.verifyButtonLabel,
    this.resendCountdownDuration = const Duration(minutes: 1),
    this.keyboardType = TextInputType.text,
    this.allowedLetterCase = LetterCase.lowercase,
    this.allowedCharactersPattern,
    super.key,
  });

  @override
  State<VerificationForm> createState() => _VerificationFormState();
}

class _VerificationFormState extends State<VerificationForm> {
  late final FocusNode focusNode;

  EmailAuthController get controller => widget.controller;

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
    return FormStandardLayout(
      title: widget.title,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.messageText ??
                'A verification email has been sent. Please check your email '
                    'and enter the verification code below.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
          smallGap,
          VerificationCodeInput(
            focusNode: focusNode,
            verificationCodeController: controller.verificationCodeController,
            onCompleted: widget.onCompleted,
            isLoading: controller.isLoading,
            length: controller.verificationCodeLength,
            keyboardType: widget.keyboardType,
            allowedLetterCase: widget.allowedLetterCase,
            allowedCharactersPattern:
                widget.allowedCharactersPattern ?? _defaultAllowedCharacters,
          ),
          ResendCodeButton(
            onResendPressed: controller.resendVerificationCode,
            countdownDuration: widget.resendCountdownDuration,
          ),
        ],
      ),
      actionButton: ActionButton(
        onPressed: widget.onCompleted,
        label: widget.verifyButtonLabel ?? 'Verify',
        isLoading: controller.isLoading,
      ),
      bottomText: BackToSignInButton(controller: controller),
    );
  }
}
