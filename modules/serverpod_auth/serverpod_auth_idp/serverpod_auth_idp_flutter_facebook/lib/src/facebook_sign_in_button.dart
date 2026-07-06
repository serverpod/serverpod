import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'facebook_sign_in_style.dart';

/// A styled button for Facebook Sign-In.
///
/// Renders a Facebook-branded button on the shared [SignInButtonBase], with
/// loading and disabled states. The [size], [text], [shape], [logoAlignment],
/// [minimumWidth], and [textStyle] arguments fall back to the shared
/// [SignInButtonStyle] in scope when a [SignInWidget] provides one.
class FacebookSignInButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The brand color preset (blue or white).
  ///
  /// Applies when the button is used on its own. Inside a [SignInWidget] (or any
  /// [SignInButtonStyle] in scope) the shared common style applies instead.
  final FacebookButtonStyle style;

  /// The button size.
  final SignInButtonSize size;

  /// The button label variant.
  final SignInButtonTextVariant text;

  /// The button shape.
  final SignInButtonShape shape;

  /// The Facebook logo alignment: left or center.
  final SignInButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// The text style applied to the button label.
  final TextStyle? textStyle;

  /// Creates a Facebook Sign-In button.
  const FacebookSignInButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.style = FacebookButtonStyle.blue,
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
    final localizations = context.facebookSignInTexts;
    final (background, foreground) = switch (style) {
      FacebookButtonStyle.blue => (const Color(0xFF1877F2), Colors.white),
      FacebookButtonStyle.white => (Colors.white, const Color(0xFF1877F2)),
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
          border: const Color(0xFFE0E0E0),
        ),
        brandShowBorder: style == FacebookButtonStyle.white,
        localizedLabel: localizations.signInButton,
        label: _label,
        logoBuilder: _buildLogo,
      ),
    );
  }

  // Facebook supports the bare "Sign in" without its name, unlike GitHub and
  // Microsoft which always append the provider.
  static String _label(SignInButtonTextVariant variant) => switch (variant) {
    SignInButtonTextVariant.signInWith => 'Sign in with Facebook',
    SignInButtonTextVariant.signUpWith => 'Sign up with Facebook',
    SignInButtonTextVariant.continueWith => 'Continue with Facebook',
    SignInButtonTextVariant.signIn => 'Sign in',
  };

  static Widget _buildLogo({
    required double logoSize,
    required Color foregroundColor,
    required bool isDisabled,
  }) {
    return SizedBox.square(
      dimension: logoSize,
      child: Icon(
        Icons.facebook,
        size: logoSize,
        color: foregroundColor,
      ),
    );
  }
}
