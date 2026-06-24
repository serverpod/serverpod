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

  /// An explicit border color, overriding the background-derived default.
  final Color? overrideBorderColor;

  /// Creates a [GoogleSignInStyle] with the given properties.
  const GoogleSignInStyle({
    required this.size,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderRadius,
    this.overrideBorderColor,
  });

  /// Gets the border side for native buttons.
  BorderSide get borderSide {
    return BorderSide(
      color:
          overrideBorderColor ??
          (backgroundColor == Colors.white
              ? const Color(0xFFE0E0E0)
              : backgroundColor),
      width: 1,
    );
  }

  /// Creates a [GoogleSignInStyle] from the button configuration.
  ///
  /// Values are translated from the enum values to actual style properties
  /// using the Google Sign-In documentation as reference.
  ///
  /// [borderRadius] overrides the shape-derived radius when provided. The web
  /// [GSIButtonShape] only exposes rectangular and pill, so the Flutter button
  /// uses this to support additional shapes (e.g. rounded).
  ///
  /// [backgroundColor]/[foregroundColor]/[borderColor] override the
  /// theme-derived colors, letting the Flutter button adopt the shared uniform
  /// (and theme-aware) colors.
  factory GoogleSignInStyle.fromConfiguration({
    required GSIButtonTheme theme,
    required GSIButtonShape shape,
    required GSIButtonSize size,
    required double width,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
  }) {
    final height = switch (size) {
      GSIButtonSize.large => 40.0,
      GSIButtonSize.medium => 32.0,
      GSIButtonSize.small => 20.0,
    };

    return GoogleSignInStyle(
      size: Size(width, height),
      foregroundColor:
          foregroundColor ??
          switch (theme) {
            GSIButtonTheme.outline => Colors.black,
            GSIButtonTheme.filledBlue => Colors.white,
            GSIButtonTheme.filledBlack => Colors.white,
          },
      backgroundColor:
          backgroundColor ??
          switch (theme) {
            GSIButtonTheme.outline => Colors.white,
            GSIButtonTheme.filledBlue => const Color(0xFF1A73E8),
            GSIButtonTheme.filledBlack => Colors.black,
          },
      borderRadius:
          borderRadius ??
          switch (shape) {
            GSIButtonShape.rectangular => BorderRadius.circular(4),
            GSIButtonShape.pill => BorderRadius.circular(height / 2),
          },
      overrideBorderColor: borderColor,
    );
  }
}
