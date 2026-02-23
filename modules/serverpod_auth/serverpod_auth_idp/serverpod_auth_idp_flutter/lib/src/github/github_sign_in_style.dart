import 'package:flutter/material.dart';

/// The type of GitHub Sign-In button to render.
enum GitHubButtonType {
  /// A standard button with text and logo.
  standard,

  /// An icon-only button with just the GitHub logo.
  icon,
}

/// The style/theme of the GitHub Sign-In button.
enum GitHubButtonStyle {
  /// Black background with white text (GitHub's default).
  black,

  /// White background with black text.
  white,
}

/// The size of the GitHub Sign-In button.
enum GitHubButtonSize {
  /// Large button (recommended).
  large,

  /// Medium button.
  medium,
}

/// The text to display on the GitHub Sign-In button.
enum GitHubButtonText {
  /// "Sign in with GitHub"
  signIn,

  /// "Sign up with GitHub"
  signUp,

  /// "Continue with GitHub"
  continueWith,
}

/// The shape of the GitHub Sign-In button.
enum GitHubButtonShape {
  /// Rectangular button with sharp corners.
  rectangular,

  /// Pill-shaped button with rounded ends.
  pill,

  /// Rounded button with moderate corner radius.
  rounded,
}

/// The alignment of the GitHub logo on the button.
enum GitHubButtonLogoAlignment {
  /// Logo aligned to the left of the text.
  left,

  /// Logo centered on the button.
  center,
}

/// The style configuration for the GitHub Sign-In button.
class GitHubSignInStyle {
  /// The size of the button.
  final Size size;

  /// The foreground color (text and icon).
  final Color foregroundColor;

  /// The background color of the button.
  final Color backgroundColor;

  /// The border radius of the button.
  final BorderRadius borderRadius;

  /// Creates a [GitHubSignInStyle] with the given properties.
  const GitHubSignInStyle({
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

  /// Creates a [GitHubSignInStyle] from button configuration.
  factory GitHubSignInStyle.fromConfiguration({
    required GitHubButtonShape shape,
    required GitHubButtonSize size,
    required GitHubButtonStyle style,
    required double width,
  }) {
    final buttonSize = switch (size) {
      GitHubButtonSize.large => const Size(0, 40),
      GitHubButtonSize.medium => const Size(0, 32),
    };

    final foregroundColor = switch (style) {
      GitHubButtonStyle.black => Colors.white,
      GitHubButtonStyle.white => const Color(0xFF24292F),
    };

    final backgroundColor = switch (style) {
      GitHubButtonStyle.black => const Color(0xFF24292F),
      GitHubButtonStyle.white => Colors.white,
    };

    final borderRadius = switch (shape) {
      GitHubButtonShape.rectangular => BorderRadius.zero,
      GitHubButtonShape.pill => BorderRadius.circular(buttonSize.height / 2),
      GitHubButtonShape.rounded => BorderRadius.circular(8),
    };

    return GitHubSignInStyle(
      size: Size(width, buttonSize.height),
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
    );
  }
}
