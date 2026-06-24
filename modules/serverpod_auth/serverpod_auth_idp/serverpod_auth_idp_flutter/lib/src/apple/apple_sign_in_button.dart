import 'package:flutter/material.dart' hide IconAlignment;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../common/sign_in_button_style.dart';
import '../localization/sign_in_localization_provider.dart';
import 'apple_sign_in_style.dart';

/// A styled button for Apple Sign-In.
///
/// This widget wraps the official Sign in with Apple button from the
/// `sign_in_with_apple` package and adds loading and disabled states.
///
/// The [type], [size], [shape], [logoAlignment], and [minimumWidth] arguments
/// fall back to the shared [SignInButtonStyle] in scope when left null, then to
/// Apple's own defaults. The shared `textStyle` does not apply: the button is
/// rendered natively and always uses the system font.
class AppleSignInButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The button text variant.
  ///
  /// Falls back to the shared [SignInButtonStyle], then to
  /// [AppleButtonText.continueWith], when null.
  final AppleButtonText? type;

  /// The brand color preset (black, white, or white-outlined).
  ///
  /// When null, the button approximates the shared [SignInButtonStyle] colors
  /// (or the uniform default) with its nearest preset. Set it to pick an Apple
  /// preset explicitly.
  final AppleButtonStyle? style;

  /// The button size.
  ///
  /// For example, small or large. Falls back to the shared [SignInButtonStyle],
  /// then to [AppleButtonSize.large], when null.
  final AppleButtonSize? size;

  /// The button shape.
  ///
  /// For example, rectangular or pill. Falls back to the shared
  /// [SignInButtonStyle], then to [AppleButtonShape.pill], when null.
  final AppleButtonShape? shape;

  /// The Apple logo alignment: left or center.
  ///
  /// Falls back to the shared [SignInButtonStyle], then to
  /// [AppleButtonLogoAlignment.center], when null.
  final AppleButtonLogoAlignment? logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels. Falls back to the shared
  /// [SignInButtonStyle], then to 240, when null.
  final double? minimumWidth;

  /// Creates an Apple Sign-In button.
  const AppleSignInButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.type,
    this.style,
    this.size,
    this.shape,
    this.logoAlignment,
    this.minimumWidth,
    super.key,
  }) : assert(
         minimumWidth == null || (minimumWidth > 0 && minimumWidth <= 400),
         'Invalid minimumWidth. Must be between 0 and 400.',
       );

  @override
  Widget build(BuildContext context) {
    final texts = context.appleSignInTexts;
    final shared = context.signInButtonStyle;

    final type =
        this.type ?? _toAppleText(shared.text) ?? AppleButtonText.continueWith;
    final size =
        this.size ?? _toAppleSize(shared.size) ?? AppleButtonSize.large;
    final shape =
        this.shape ?? _toAppleShape(shared.shape) ?? AppleButtonShape.pill;
    final logoAlignment =
        this.logoAlignment ??
        _toAppleLogoAlignment(shared.logoAlignment) ??
        AppleButtonLogoAlignment.center;
    final minimumWidth = this.minimumWidth ?? shared.minimumWidth ?? 240;

    // Apple's native button can't take arbitrary colors, so an explicit preset
    // wins, otherwise map the resolved background to its nearest preset. The
    // borderless white/black presets are used (rather than whiteOutlined) since
    // Apple's outline is black and would not match the other buttons' border.
    final AppleButtonStyle effectiveStyle;
    if (style != null) {
      effectiveStyle = style!;
    } else {
      final colors = shared.resolveColors(context);
      effectiveStyle = colors.background.computeLuminance() > 0.5
          ? AppleButtonStyle.white
          : AppleButtonStyle.black;
    }

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
        text: texts.signInButton ?? _getButtonText(type),
        height: buttonStyle.size.height,
        style: effectiveStyle,
        borderRadius: buttonStyle.borderRadius,
        iconAlignment: logoAlignment,
      ),
    );
  }

  String _getButtonText(AppleButtonText type) {
    return switch (type) {
      AppleButtonText.signinWith => 'Sign in with Apple',
      AppleButtonText.continueWith => 'Continue with Apple',
      AppleButtonText.signupWith => 'Sign up with Apple',
      AppleButtonText.signin => 'Sign in',
    };
  }
}

AppleButtonSize? _toAppleSize(SignInButtonSize? size) => switch (size) {
  null => null,
  SignInButtonSize.large => AppleButtonSize.large,
  SignInButtonSize.medium => AppleButtonSize.medium,
  SignInButtonSize.small => AppleButtonSize.small,
};

AppleButtonShape? _toAppleShape(SignInButtonShape? shape) => switch (shape) {
  null => null,
  SignInButtonShape.rectangular => AppleButtonShape.rectangular,
  SignInButtonShape.rounded => AppleButtonShape.rounded,
  SignInButtonShape.pill => AppleButtonShape.pill,
};

AppleButtonLogoAlignment? _toAppleLogoAlignment(
  SignInButtonLogoAlignment? alignment,
) => switch (alignment) {
  null => null,
  SignInButtonLogoAlignment.left => AppleButtonLogoAlignment.left,
  SignInButtonLogoAlignment.center => AppleButtonLogoAlignment.center,
};

AppleButtonText? _toAppleText(SignInButtonTextVariant? text) => switch (text) {
  null => null,
  SignInButtonTextVariant.signInWith => AppleButtonText.signinWith,
  SignInButtonTextVariant.signUpWith => AppleButtonText.signupWith,
  SignInButtonTextVariant.continueWith => AppleButtonText.continueWith,
  SignInButtonTextVariant.signIn => AppleButtonText.signin,
};
