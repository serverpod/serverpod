import 'package:flutter/material.dart';

import '../common/sign_in_button_base.dart';
import '../common/sign_in_button_style.dart';
import '../localization/sign_in_localization_provider.dart';

/// A text-only button for anonymous sign-in ("Continue without account").
///
/// It has no provider logo, but shares the same [SignInButtonBase] as the
/// provider buttons, so [size], [shape], [minimumWidth], and [textStyle] fall
/// back to the shared [SignInButtonStyle] in scope when a [SignInWidget]
/// provides one.
class AnonymousSignInButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The button size.
  final SignInButtonSize size;

  /// The button shape.
  final SignInButtonShape shape;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// The text style applied to the button label.
  final TextStyle? textStyle;

  /// Creates an anonymous sign-in button.
  const AnonymousSignInButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.size = SignInButtonSize.large,
    this.shape = SignInButtonShape.pill,
    this.minimumWidth = 240,
    this.textStyle,
    super.key,
  }) : assert(
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be greater than 0 and at most 400.',
       );

  @override
  Widget build(BuildContext context) {
    final texts = context.anonymousSignInTexts;
    // The anonymous button has no brand of its own, so on its own it uses the
    // same neutral, theme-aware colors it would inside a SignInWidget.
    final neutral = SignInButtonStyle.defaults.resolveColors(context);

    return SignInButtonBase(
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      size: size,
      shape: shape,
      minimumWidth: minimumWidth,
      textStyle: textStyle,
      config: SignInButtonConfig(
        brandColors: neutral,
        brandShowBorder: true,
        localizedLabel: texts.signInButton,
        label: (_) => 'Continue without account',
      ),
    );
  }
}
