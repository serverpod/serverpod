import 'package:flutter/material.dart';

import '../web/wrapper.dart';

// Convenience export of the button configuration enums and style class.
export '../web/wrapper.dart'
    show
        GSIButtonType,
        GSIButtonTheme,
        GSIButtonSize,
        GSIButtonText,
        GSIButtonShape,
        GSIButtonLogoAlignment;

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
