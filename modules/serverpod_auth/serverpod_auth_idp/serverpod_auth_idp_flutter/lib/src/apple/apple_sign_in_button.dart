import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/sign_in_button_base.dart';
import '../common/sign_in_button_style.dart';
import '../localization/sign_in_localization_provider.dart';
import 'apple_sign_in_style.dart';

/// A styled button for Apple Sign-In.
///
/// Renders a custom Apple-branded button on the shared [SignInButtonBase], with
/// loading and disabled states, so it matches every other provider button. The
/// [size], [text], [shape], [logoAlignment], [minimumWidth], and [textStyle]
/// arguments fall back to the shared [SignInButtonStyle] in scope when a
/// [SignInWidget] provides one.
class AppleSignInButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The brand color preset (black, white, or white-outlined).
  ///
  /// Applies when the button is used on its own. Inside a [SignInWidget] (or any
  /// [SignInButtonStyle] in scope) the shared common style applies instead.
  final AppleButtonStyle style;

  /// The button size.
  final SignInButtonSize size;

  /// The button label variant.
  final SignInButtonTextVariant text;

  /// The button shape.
  final SignInButtonShape shape;

  /// The Apple logo alignment: left or center.
  final SignInButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// The text style applied to the button label.
  final TextStyle? textStyle;

  /// Creates an Apple Sign-In button.
  const AppleSignInButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.style = AppleButtonStyle.black,
    this.size = SignInButtonSize.large,
    this.text = SignInButtonTextVariant.continueWith,
    this.shape = SignInButtonShape.pill,
    this.logoAlignment = SignInButtonLogoAlignment.center,
    this.minimumWidth = 240,
    this.textStyle,
    super.key,
  }) : assert(
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be greater than 0 and at most 400.',
       );

  @override
  Widget build(BuildContext context) {
    final localizations = context.appleSignInTexts;
    final (background, foreground, showBorder) = switch (style) {
      AppleButtonStyle.black => (const Color(0xFF000000), Colors.white, false),
      AppleButtonStyle.white => (
        Colors.white,
        const Color(0xFF000000),
        false,
      ),
      AppleButtonStyle.whiteOutlined => (
        Colors.white,
        const Color(0xFF000000),
        true,
      ),
    };

    return SignInButtonBase(
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      size: size,
      shape: shape,
      text: text,
      logoAlignment: logoAlignment,
      minimumWidth: minimumWidth,
      textStyle: textStyle,
      config: SignInButtonConfig(
        brandColors: SignInButtonColors(
          background: background,
          foreground: foreground,
          border: const Color(0xFF000000),
        ),
        brandShowBorder: showBorder,
        localizedLabel: localizations.signInButton,
        label: _label,
        logoBuilder: _buildLogo,
      ),
    );
  }

  // Apple supports the bare "Sign in" without its name, like Facebook and
  // Google.
  static String _label(SignInButtonTextVariant variant) => switch (variant) {
    SignInButtonTextVariant.signInWith => 'Sign in with Apple',
    SignInButtonTextVariant.signUpWith => 'Sign up with Apple',
    SignInButtonTextVariant.continueWith => 'Continue with Apple',
    SignInButtonTextVariant.signIn => 'Sign in',
  };

  // The Apple mark is monochrome, so it tints to the foreground and greys out
  // when disabled.
  static Widget _buildLogo({
    required double logoSize,
    required Color foregroundColor,
    required bool isDisabled,
  }) {
    return SizedBox.square(
      dimension: logoSize,
      child: SvgPicture.asset(
        'assets/images/apple.svg',
        package: 'serverpod_auth_idp_flutter',
        colorFilter: ColorFilter.mode(
          isDisabled ? const Color(0xff9c9c9c) : foregroundColor,
          BlendMode.srcIn,
        ),
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
