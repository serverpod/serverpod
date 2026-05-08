import 'package:flutter/material.dart';

/// The type of the Google Sign-In button.
///
/// See: https://developers.google.com/identity/gsi/web/reference/js-reference#type
enum GSIButtonType {
  /// A standard button with text and logo.
  standard,

  /// An icon-only button.
  icon,
}

/// The theme (color scheme) of the Google Sign-In button.
///
/// See: https://developers.google.com/identity/gsi/web/reference/js-reference#theme
enum GSIButtonTheme {
  /// White background with colored Google logo.
  outline,

  /// Blue background.
  filledBlue,

  /// Black background.
  filledBlack,
}

/// The size of the Google Sign-In button.
///
/// See: https://developers.google.com/identity/gsi/web/reference/js-reference#size
enum GSIButtonSize {
  /// Large button (40px height).
  large,

  /// Medium button (32px height).
  medium,

  /// Small button (20px height).
  small,
}

/// The text label of the Google Sign-In button.
///
/// See: https://developers.google.com/identity/gsi/web/reference/js-reference#text
enum GSIButtonText {
  /// "Sign in with Google".
  signinWith,

  /// "Sign up with Google".
  signupWith,

  /// "Continue with Google".
  continueWith,

  /// "Sign in".
  signin,
}

/// The shape of the Google Sign-In button.
///
/// See: https://developers.google.com/identity/gsi/web/reference/js-reference#shape
enum GSIButtonShape {
  /// Rectangular button with slightly rounded corners.
  rectangular,

  /// Pill-shaped button.
  pill,
}

/// The alignment of the Google logo within the button.
///
/// See: https://developers.google.com/identity/gsi/web/reference/js-reference#logo_alignment
enum GSIButtonLogoAlignment {
  /// Logo aligned to the left.
  left,

  /// Logo centered in the button.
  center,
}

/// The style of the rendered Google button.
class GoogleSignInStyle {
  /// The size of the button.
  final Size size;

  /// The foreground color of the button.
  final Color foregroundColor;

  /// The background color of the button.
  final Color backgroundColor;

  /// The border radius of the button.
  final BorderRadius borderRadius;

  /// Creates a [GoogleSignInStyle] with the given properties.
  const GoogleSignInStyle({
    required this.size,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderRadius,
  });

  /// Gets the border side for native buttons.
  BorderSide get borderSide {
    return BorderSide(
      color: backgroundColor == Colors.white
          ? const Color(0xFFE0E0E0)
          : backgroundColor,
      width: 1,
    );
  }

  /// Creates a [GoogleSignInStyle] from the button configuration.
  ///
  /// Values are translated from the enum values to actual style properties
  /// using the Google Sign-In documentation as reference.
  factory GoogleSignInStyle.fromConfiguration({
    required GSIButtonTheme theme,
    required GSIButtonShape shape,
    required GSIButtonSize size,
    required double width,
  }) {
    final height = switch (size) {
      GSIButtonSize.large => 40.0,
      GSIButtonSize.medium => 32.0,
      GSIButtonSize.small => 20.0,
    };

    return GoogleSignInStyle(
      size: Size(width, height),
      foregroundColor: switch (theme) {
        GSIButtonTheme.outline => Colors.black,
        GSIButtonTheme.filledBlue => Colors.white,
        GSIButtonTheme.filledBlack => Colors.white,
      },
      backgroundColor: switch (theme) {
        GSIButtonTheme.outline => Colors.white,
        GSIButtonTheme.filledBlue => const Color(0xFF1A73E8),
        GSIButtonTheme.filledBlack => Colors.black,
      },
      borderRadius: switch (shape) {
        GSIButtonShape.rectangular => BorderRadius.circular(4),
        GSIButtonShape.pill => BorderRadius.circular(height / 2),
      },
    );
  }
}
