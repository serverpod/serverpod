import 'package:flutter/material.dart';

import 'style.dart';

/// Base class for Google Sign-In buttons with shared wrapping logic.
abstract class GoogleSignInBaseButton extends StatelessWidget {
  /// The button type: icon, or standard button.
  final GSIButtonType type;

  /// The button theme.
  ///
  /// For example, filledBlue or filledBlack.
  final GSIButtonTheme theme;

  /// The button size.
  ///
  /// For example, small or large.
  final GSIButtonSize size;

  /// The button text.
  ///
  /// For example "Sign in with Google" or "Sign up with Google".
  final GSIButtonText text;

  /// The button shape.
  ///
  /// For example, rectangular or circular.
  final GSIButtonShape shape;

  /// The Google logo alignment: left or center.
  final GSIButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// A wrapper function to the rendered button to ensure style consistency.
  ///
  /// This wrapper ensures the consistency of the rendered button with the rest
  /// of the application. Since the render configuration is done through enum
  /// values, the wrapper will be called with a [GoogleSignInStyle] object that
  /// translates the enum values to actual style properties. The [Widget] is the
  /// rendered Google button that should be wrapped.
  ///
  /// Be mindful that creating the button with no wrapper will also result in a
  /// dangling "Getting ready..." text that is returned while the iFrame is
  /// being built.
  final Widget Function({
    required GoogleSignInStyle style,
    required Widget child,
    required VoidCallback? onPressed,
  })?
  buttonWrapper;

  /// Creates a base Google Sign-In button.
  const GoogleSignInBaseButton({
    this.type = GSIButtonType.standard,
    this.theme = GSIButtonTheme.outline,
    this.size = GSIButtonSize.large,
    this.text = GSIButtonText.continueWith,
    this.shape = GSIButtonShape.pill,
    this.logoAlignment = GSIButtonLogoAlignment.center,
    this.minimumWidth = 240,
    this.buttonWrapper = wrapAsOutline,
    super.key,
  }) : assert(
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be between 0 and 400.',
       ),
       assert(
         size != GSIButtonSize.small,
         'Small size is disabled due to Android Material and iOS Human '
         'Interface design guidelines regarding minimum target size. Use '
         'medium or large instead.',
       );

  /// Wraps the button to match Material's outlined button style.
  static Widget wrapAsOutline({
    required GoogleSignInStyle style,
    required Widget child,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: style.backgroundColor,
        foregroundColor: style.foregroundColor,
        side: style.borderSide,
        shape: RoundedRectangleBorder(borderRadius: style.borderRadius),
        padding: EdgeInsets.zero,
      ),
      child: child,
    );
  }

  /// Wraps the button to match Material's filled button style.
  static Widget wrapAsFilled({
    required GoogleSignInStyle style,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: style.backgroundColor,
        foregroundColor: style.foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: style.borderRadius,
          side: style.borderSide,
        ),
        padding: EdgeInsets.zero,
      ),
      child: child,
    );
  }

  /// Wraps the button to match Material's elevated button style.
  static Widget wrapAsElevated({
    required GoogleSignInStyle style,
    required Widget child,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: style.backgroundColor,
        foregroundColor: style.foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: style.borderRadius,
          side: style.borderSide,
        ),
        padding: EdgeInsets.zero,
      ),
      child: child,
    );
  }
}
