import 'package:flutter/material.dart';

/// The style of Facebook Sign-In button.
enum FacebookButtonStyle {
  /// Facebook blue button (default).
  blue,

  /// White button with Facebook blue text.
  white,
}

/// The size of the Facebook Sign-In button.
enum FacebookButtonSize {
  /// A large button (about 40px tall).
  large,

  /// A medium-sized button (about 32px tall).
  medium,

  /// A small button (about 20px tall).
  small,
}

/// The type of Facebook Sign-In button.
enum FacebookButtonText {
  /// The button text is "Sign in with Facebook".
  signinWith,

  /// The button text is "Continue with Facebook".
  continueWith,

  /// The button text is "Sign up with Facebook".
  signupWith,

  /// The button text is "Sign in".
  signin,
}

/// The shape of the Facebook Sign-In button.
enum FacebookButtonShape {
  /// The rectangular-shaped button.
  rectangular,

  /// The pill-shaped button (StadiumBorder).
  pill,
}

/// The alignment of the Facebook logo. The default value is left.
///
/// This attribute only applies to the standard button type.
enum FacebookButtonLogoAlignment {
  /// Align the logo to the left.
  left,

  /// Align the logo to the center.
  center,
}

/// The style of the rendered Facebook button.
class FacebookSignInStyle {
  /// The size of the button.
  final Size size;

  /// The border radius of the button.
  final BorderRadius borderRadius;

  /// The background color of the button.
  final Color backgroundColor;

  /// The text color of the button.
  final Color textColor;

  /// Creates a [FacebookSignInStyle] with the given properties.
  const FacebookSignInStyle({
    required this.size,
    required this.borderRadius,
    required this.backgroundColor,
    required this.textColor,
  });

  /// Creates a [FacebookSignInStyle] from the button configuration.
  ///
  /// Values are translated from the enum values to actual style properties
  /// matching Facebook brand guidelines.
  factory FacebookSignInStyle.fromConfiguration({
    required FacebookButtonShape shape,
    required FacebookButtonSize size,
    required FacebookButtonStyle style,
    required double width,
  }) {
    final height = switch (size) {
      FacebookButtonSize.large => 40.0,
      FacebookButtonSize.medium => 32.0,
      FacebookButtonSize.small => 20.0,
    };

    final (backgroundColor, textColor) = switch (style) {
      FacebookButtonStyle.blue => (
        const Color(0xFF1877F2),
        Colors.white,
      ),
      FacebookButtonStyle.white => (
        Colors.white,
        const Color(0xFF1877F2),
      ),
    };

    return FacebookSignInStyle(
      size: Size(width, height),
      borderRadius: switch (shape) {
        FacebookButtonShape.rectangular => BorderRadius.circular(4),
        FacebookButtonShape.pill => BorderRadius.circular(height / 2),
      },
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }
}
