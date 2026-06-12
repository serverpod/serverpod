import 'package:flutter/material.dart';

import '../../../localization/sign_in_localization_provider.dart';
import '../../email_auth_controller.dart';
import '../../../common/widgets/buttons/text_button.dart';

/// A widget for displaying a "Back to sign in" button.
class BackToSignInButton extends StatelessWidget {
  /// The controller that manages navigation state.
  final EmailAuthController controller;

  /// Creates a [BackToSignInButton] widget.
  const BackToSignInButton({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.emailSignInTexts;

    return Center(
      child: HyperlinkTextButton(
        onPressed: () => controller.navigateTo(EmailFlowScreen.login),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        label: texts.backToSignIn,
      ),
    );
  }
}
