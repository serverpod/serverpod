import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/sign_in_button_base.dart';
import '../../common/sign_in_button_style.dart';
import '../../localization/sign_in_localization_provider.dart';
import '../common/style.dart';

/// A styled button for Google Sign-In.
///
/// Renders a Google-branded button on the shared [SignInButtonBase] — matching
/// Google's branding guidelines
/// (https://developers.google.com/identity/branding-guidelines) while staying
/// consistent with the other provider buttons. The [size], [text], [shape],
/// [logoAlignment], [minimumWidth], and [textStyle] arguments fall back to the
/// shared [SignInButtonStyle] in scope when a [SignInWidget] provides one.
class GoogleSignInNativeButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The brand color preset (outline, filledBlue, or filledBlack).
  ///
  /// Applies when the button is used on its own. Inside a [SignInWidget] (or any
  /// [SignInButtonStyle] in scope) the shared common style applies instead.
  final GoogleButtonStyle style;

  /// The button size.
  final SignInButtonSize size;

  /// The button label variant.
  final SignInButtonTextVariant text;

  /// The button shape.
  final SignInButtonShape shape;

  /// The Google logo alignment: left or center.
  final SignInButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// The text style applied to the button label.
  final TextStyle? textStyle;

  /// Creates a Google Sign-In button.
  const GoogleSignInNativeButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.style = GoogleButtonStyle.outline,
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
    final localizations = context.googleSignInTexts;
    final (background, foreground, border) = switch (style) {
      GoogleButtonStyle.outline => (
        Colors.white,
        Colors.black,
        const Color(0xFFE0E0E0),
      ),
      GoogleButtonStyle.filledBlue => (
        const Color(0xFF1A73E8),
        Colors.white,
        const Color(0xFF1A73E8),
      ),
      GoogleButtonStyle.filledBlack => (
        Colors.black,
        Colors.white,
        Colors.black,
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
          border: border,
        ),
        brandShowBorder: style == GoogleButtonStyle.outline,
        localizedLabel: localizations.signInButton,
        label: _label,
        logoBuilder: _buildLogo,
      ),
    );
  }

  static String _label(SignInButtonTextVariant variant) => switch (variant) {
    SignInButtonTextVariant.signInWith => 'Sign in with Google',
    SignInButtonTextVariant.signUpWith => 'Sign up with Google',
    SignInButtonTextVariant.continueWith => 'Continue with Google',
    SignInButtonTextVariant.signIn => 'Sign in',
  };

  // Google's multicolor "G" is never tinted; it only greys out when disabled.
  // On the filled themes it sits on a white chip so it stays legible against the
  // colored background (Google branding guideline).
  Widget _buildLogo({
    required double logoSize,
    required Color foregroundColor,
    required bool isDisabled,
  }) {
    final g = SizedBox.square(
      dimension: logoSize,
      child: SvgPicture.asset(
        'assets/images/google.svg',
        package: 'serverpod_auth_idp_flutter',
        colorFilter: isDisabled
            ? const ColorFilter.mode(Color(0xff9c9c9c), BlendMode.srcIn)
            : null,
        fit: BoxFit.scaleDown,
      ),
    );

    if (style == GoogleButtonStyle.outline) return g;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: g,
    );
  }
}
