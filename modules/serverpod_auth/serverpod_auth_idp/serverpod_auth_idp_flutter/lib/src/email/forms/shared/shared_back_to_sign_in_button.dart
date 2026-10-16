import 'package:flutter/material.dart';

import '../../../common/widgets/buttons/text_button.dart';
import '../../../localization/sign_in_localization_provider.dart';

/// A "Back to sign in" button, shared by the email authentication flows.
class SharedBackToSignInButton extends StatelessWidget {
  /// Navigates to the sign-in screen of the flow.
  final VoidCallback onPressed;

  /// Creates a [SharedBackToSignInButton] widget.
  const SharedBackToSignInButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    final texts = context.emailSignInTexts;

    return Center(
      child: HyperlinkTextButton(
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        label: texts.backToSignIn,
      ),
    );
  }
}
