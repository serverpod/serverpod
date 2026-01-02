import 'package:flutter/material.dart';

/// The size of the Anonymous Sign-In button.
enum AnonymousButtonSize {
  /// A large button (about 40px tall).
  large,

  /// A medium-sized button (about 32px tall).
  medium,

  /// A small button (about 20px tall).
  small,
}

/// The shape of the Anonymous Sign-In button.
enum AnonymousButtonShape {
  /// The rectangular-shaped button.
  rectangular,

  /// The pill-shaped button (StadiumBorder).
  pill,
}

/// The style of the rendered Anonymous Sign-In button.
class AnonymousSignInStyle {
  /// The size of the button.
  final Size size;

  /// The border radius of the button.
  final BorderRadius borderRadius;

  /// Creates an [AnonymousSignInStyle] with the given properties.
  const AnonymousSignInStyle({
    required this.size,
    required this.borderRadius,
  });

  /// Creates an [AnonymousSignInStyle] from the button configuration.
  ///
  /// Values are translated from the enum values to actual style properties
  /// matching Google Sign-In button dimensions for consistency.
  factory AnonymousSignInStyle.fromConfiguration({
    required AnonymousButtonShape shape,
    required AnonymousButtonSize size,
    required double width,
  }) {
    final height = switch (size) {
      AnonymousButtonSize.large => 40.0,
      AnonymousButtonSize.medium => 32.0,
      AnonymousButtonSize.small => 20.0,
    };

    return AnonymousSignInStyle(
      size: Size(width, height),
      borderRadius: switch (shape) {
        AnonymousButtonShape.rectangular => BorderRadius.circular(4),
        AnonymousButtonShape.pill => BorderRadius.circular(height / 2),
      },
    );
  }
}
