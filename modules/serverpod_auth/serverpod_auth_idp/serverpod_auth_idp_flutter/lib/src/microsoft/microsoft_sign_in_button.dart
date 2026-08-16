import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/sign_in_button_base.dart';
import '../common/sign_in_button_style.dart';
import '../localization/sign_in_localization_provider.dart';
import 'microsoft_sign_in_style.dart';

/// A styled button for Microsoft Sign-In.
///
/// Renders a Microsoft-branded button on the shared [SignInButtonBase], with
/// loading and disabled states. The [size], [text], [shape], [logoAlignment],
/// [minimumWidth], and [textStyle] arguments fall back to the shared
/// [SignInButtonStyle] in scope when a [SignInWidget] provides one.
class MicrosoftSignInButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The brand color preset (light or dark).
  ///
  /// Applies when the button is used on its own. Inside a [SignInWidget] (or any
  /// [SignInButtonStyle] in scope) the shared common style applies instead.
  final MicrosoftButtonStyle style;

  /// The button size.
  final SignInButtonSize size;

  /// The button label variant.
  final SignInButtonTextVariant text;

  /// The button shape.
  final SignInButtonShape shape;

  /// The Microsoft logo alignment: left or center.
  final SignInButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// The text style applied to the button label.
  final TextStyle? textStyle;

  /// Creates a Microsoft Sign-In button.
  const MicrosoftSignInButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.style = MicrosoftButtonStyle.light,
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
    final localizations = context.microsoftSignInTexts;
    final (background, foreground) = switch (style) {
      MicrosoftButtonStyle.light => (
        const Color(0xFFFFFFFF),
        const Color(0xFF5E5E5E),
      ),
      MicrosoftButtonStyle.dark => (const Color(0xFF2F2F2F), Colors.white),
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
          border: background == const Color(0xFFFFFFFF)
              ? const Color(0xFFE0E0E0)
              : background,
        ),
        brandShowBorder: style == MicrosoftButtonStyle.light,
        localizedLabel: localizations.signInButton,
        label: _label,
        logoBuilder: _buildLogo,
      ),
    );
  }

  // Microsoft always appends its name, so the bare "sign in" reads "with
  // Microsoft".
  static String _label(SignInButtonTextVariant variant) => switch (variant) {
    SignInButtonTextVariant.signInWith => 'Sign in with Microsoft',
    SignInButtonTextVariant.signUpWith => 'Sign up with Microsoft',
    SignInButtonTextVariant.continueWith => 'Continue with Microsoft',
    SignInButtonTextVariant.signIn => 'Sign in with Microsoft',
  };

  // The Microsoft mark is multicolor, so it is never tinted to the foreground —
  // only greyed out when disabled.
  static Widget _buildLogo({
    required double logoSize,
    required Color foregroundColor,
    required bool isDisabled,
  }) {
    return SizedBox.square(
      dimension: logoSize,
      child: SvgPicture.asset(
        'assets/images/microsoft.svg',
        package: 'serverpod_auth_idp_flutter',
        colorFilter: isDisabled
            ? const ColorFilter.mode(Color(0xff9c9c9c), BlendMode.srcIn)
            : null,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
