import 'package:flutter/material.dart';

/// The type of Twitch Sign-In button to render.
enum TwitchButtonType {
  /// A standard button with text and logo.
  standard,

  /// An icon-only button with just the Twitch logo.
  icon,
}

/// The style/theme of the Twitch Sign-In button.
enum TwitchButtonStyle {
  /// Black background with white text (Twitch's default).
  black,

  /// White background with black text.
  white,
}

/// The size of the Twitch Sign-In button.
enum TwitchButtonSize {
  /// Large button (recommended).
  large,

  /// Medium button.
  medium,
}

/// The text to display on the Twitch Sign-In button.
enum TwitchButtonText {
  /// "Sign in with Twitch"
  signIn,

  /// "Sign up with Twitch"
  signUp,

  /// "Continue with Twitch"
  continueWith,
}

/// The shape of the Twitch Sign-In button.
enum TwitchButtonShape {
  /// Rectangular button with sharp corners.
  rectangular,

  /// Pill-shaped button with rounded ends.
  pill,

  /// Rounded button with moderate corner radius.
  rounded,
}

/// The alignment of the Twitch logo on the button.
enum TwitchButtonLogoAlignment {
  /// Logo aligned to the left of the text.
  left,

  /// Logo centered on the button.
  center,
}

/// The style configuration for the Twitch Sign-In button.
class TwitchSignInStyle {
  /// The size of the button.
  final Size size;

  /// The foreground color (text and icon).
  final Color foregroundColor;

  /// The background color of the button.
  final Color backgroundColor;

  /// The border radius of the button.
  final BorderRadius borderRadius;

  /// Creates a [TwitchSignInStyle] with the given properties.
  const TwitchSignInStyle({
    required this.size,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderRadius,
  });

  /// Gets the border side for the button.
  BorderSide get borderSide {
    return BorderSide(
      color: backgroundColor == Colors.white
          ? const Color(0xFFE0E0E0)
          : backgroundColor,
      width: 1,
    );
  }

  /// Creates a [TwitchSignInStyle] from button configuration.
  factory TwitchSignInStyle.fromConfiguration({
    required TwitchButtonShape shape,
    required TwitchButtonSize size,
    required TwitchButtonStyle style,
    required double width,
  }) {
    final buttonSize = switch (size) {
      TwitchButtonSize.large => const Size(0, 40),
      TwitchButtonSize.medium => const Size(0, 32),
    };

    final foregroundColor = switch (style) {
      TwitchButtonStyle.black => Colors.white,
      TwitchButtonStyle.white => const Color(0xFF24292F), // Twitch dark color
    };

    final backgroundColor = switch (style) {
      TwitchButtonStyle.black => const Color(0xFF24292F), // Twitch dark color
      TwitchButtonStyle.white => Colors.white,
    };

    final borderRadius = switch (shape) {
      TwitchButtonShape.rectangular => BorderRadius.zero,
      TwitchButtonShape.pill => BorderRadius.circular(buttonSize.height / 2),
      TwitchButtonShape.rounded => BorderRadius.circular(8),
    };

    return TwitchSignInStyle(
      size: Size(width, buttonSize.height),
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
    );
  }
}
