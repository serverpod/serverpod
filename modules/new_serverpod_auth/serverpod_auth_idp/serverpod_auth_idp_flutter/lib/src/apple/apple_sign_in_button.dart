import 'package:flutter/material.dart' hide IconAlignment;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'apple_sign_in_style.dart';

/// A styled button for Apple Sign-In.
///
/// This widget wraps the official Sign in with Apple button from the
/// `sign_in_with_apple` package and adds loading and disabled states.
class AppleSignInButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The button type: icon, or standard button.
  final AppleButtonText type;

  /// The button style.
  ///
  /// For example, black or white.
  final AppleButtonStyle style;

  /// The button size.
  ///
  /// For example, small or large.
  final AppleButtonSize size;

  /// The button shape.
  ///
  /// For example, rectangular or pill.
  final AppleButtonShape shape;

  /// The Apple logo alignment: left or center.
  final AppleButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// Creates an Apple Sign-In button.
  const AppleSignInButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.type = AppleButtonText.continueWith,
    this.style = AppleButtonStyle.black,
    this.size = AppleButtonSize.large,
    this.shape = AppleButtonShape.pill,
    this.logoAlignment = AppleButtonLogoAlignment.center,
    this.minimumWidth = 240,
    super.key,
  }) : assert(
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be between 0 and 400.',
       );

  @override
  Widget build(BuildContext context) {
    final buttonStyle = AppleSignInStyle.fromConfiguration(
      shape: shape,
      size: size,
      width: minimumWidth,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minimumWidth,
        maxWidth: 400,
        minHeight: buttonStyle.size.height,
        maxHeight: buttonStyle.size.height,
      ),
      child: SignInWithAppleButton(
        onPressed: isLoading || isDisabled ? null : onPressed ?? () {},
        text: _getButtonText(),
        height: buttonStyle.size.height,
        style: style,
        borderRadius: buttonStyle.borderRadius,
        iconAlignment: logoAlignment,
      ),
    );
  }

  String _getButtonText() {
    return switch (type) {
      AppleButtonText.signinWith => 'Sign in with Apple',
      AppleButtonText.continueWith => 'Continue with Apple',
      AppleButtonText.signupWith => 'Sign up with Apple',
      AppleButtonText.signin => 'Sign in',
    };
  }
}
