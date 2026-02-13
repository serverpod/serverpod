import 'package:flutter/material.dart';

/// The type of Microsoft Sign-In button to render.
enum MicrosoftButtonType {
  /// A standard button with text and logo.
  standard,

  /// An icon-only button with just the Microsoft logo.
  icon,
}

/// The style/theme of the Microsoft Sign-In button.
enum MicrosoftButtonStyle {
  /// Light background with dark text.
  light,

  /// Dark background with white text.
  dark,
}

/// The size of the Microsoft Sign-In button.
enum MicrosoftButtonSize {
  /// Large button (recommended).
  large,

  /// Medium button.
  medium,
}

/// The text to display on the Microsoft Sign-In button.
enum MicrosoftButtonText {
  /// "Sign in with Microsoft"
  signIn,

  /// "Sign up with Microsoft"
  signUp,

  /// "Continue with Microsoft"
  continueWith,
}

/// The shape of the Microsoft Sign-In button.
enum MicrosoftButtonShape {
  /// Rectangular button with sharp corners.
  rectangular,

  /// Pill-shaped button with rounded ends.
  pill,

  /// Rounded button with moderate corner radius.
  rounded,
}

/// The alignment of the Microsoft logo on the button.
enum MicrosoftButtonLogoAlignment {
  /// Logo aligned to the left of the text.
  left,

  /// Logo centered on the button.
  center,
}

/// The style configuration for the Microsoft Sign-In button.
class MicrosoftSignInStyle {
  /// The size of the button.
  final Size size;

  /// The foreground color (text and icon).
  final Color foregroundColor;

  /// The background color of the button.
  final Color backgroundColor;

  /// The border radius of the button.
  final BorderRadius borderRadius;

  /// Creates a [MicrosoftSignInStyle] with the given properties.
  const MicrosoftSignInStyle({
    required this.size,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderRadius,
  });

  /// Gets the border side for the button.
  BorderSide get borderSide {
    return BorderSide(
      color: backgroundColor == const Color(0xFFFFFFFF)
          ? const Color(0xFFE0E0E0)
          : backgroundColor,
      width: 1,
    );
  }

  /// Creates a [MicrosoftSignInStyle] from button configuration.
  factory MicrosoftSignInStyle.fromConfiguration({
    required MicrosoftButtonShape shape,
    required MicrosoftButtonSize size,
    required MicrosoftButtonStyle style,
    required double width,
  }) {
    final buttonSize = size == MicrosoftButtonSize.large
        ? const Size(0, 40)
        : const Size(0, 32);

    final foregroundColor = style == MicrosoftButtonStyle.light
        ? const Color(0xFF5E5E5E)
        : Colors.white;

    final backgroundColor = style == MicrosoftButtonStyle.light
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF2F2F2F);

    final borderRadius = switch (shape) {
      MicrosoftButtonShape.rectangular => BorderRadius.zero,
      MicrosoftButtonShape.pill => BorderRadius.circular(buttonSize.height / 2),
      MicrosoftButtonShape.rounded => BorderRadius.circular(4),
    };

    return MicrosoftSignInStyle(
      size: Size(width, buttonSize.height),
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
    );
  }
}
