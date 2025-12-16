import 'package:flutter/material.dart' hide IconAlignment;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// The style of Apple Sign-In button.
typedef AppleButtonStyle = SignInWithAppleButtonStyle;

/// The size of the Apple Sign-In button.
enum AppleButtonSize {
  /// A large button (about 40px tall).
  large,

  /// A medium-sized button (about 32px tall).
  medium,

  /// A small button (about 20px tall).
  small,
}

/// The type of Apple Sign-In button.
enum AppleButtonText {
  /// The button text is "Sign in with Apple".
  signinWith,

  /// The button text is "Continue with Apple".
  continueWith,

  /// The button text is "Sign up with Apple".
  signupWith,

  /// The button text is "Sign in".
  signin,
}

/// The shape of the Apple Sign-In button.
enum AppleButtonShape {
  /// The rectangular-shaped button.
  rectangular,

  /// The pill-shaped button (StadiumBorder).
  pill,
}

/// The alignment of the Apple logo. The default value is left.
///
/// This attribute only applies to the standard button type.
typedef AppleButtonLogoAlignment = IconAlignment;

/// The style of the rendered Apple button.
class AppleSignInStyle {
  /// The size of the button.
  final Size size;

  /// The border radius of the button.
  final BorderRadius borderRadius;

  /// Creates an [AppleSignInStyle] with the given properties.
  const AppleSignInStyle({
    required this.size,
    required this.borderRadius,
  });

  /// Creates an [AppleSignInStyle] from the button configuration.
  ///
  /// Values are translated from the enum values to actual style properties
  /// matching Google Sign-In button dimensions for consistency.
  factory AppleSignInStyle.fromConfiguration({
    required AppleButtonShape shape,
    required AppleButtonSize size,
    required double width,
  }) {
    final height = switch (size) {
      AppleButtonSize.large => 40.0,
      AppleButtonSize.medium => 32.0,
      AppleButtonSize.small => 20.0,
    };

    return AppleSignInStyle(
      size: Size(width, height),
      borderRadius: switch (shape) {
        AppleButtonShape.rectangular => BorderRadius.circular(4),
        AppleButtonShape.pill => BorderRadius.circular(height / 2),
      },
    );
  }
}
