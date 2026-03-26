import 'package:flutter/widgets.dart';

import '../localization/sign_in_localization_provider_widget.dart';

/// Texts for the Apple Sign-In button.
@immutable
class AppleSignInTexts {
  /// Creates a new [AppleSignInTexts] configuration.
  const AppleSignInTexts({this.signInButton});

  /// Defaults to provider-managed button text.
  static const defaults = AppleSignInTexts(signInButton: null);

  /// Optional override text for the Apple sign-in button.
  ///
  /// If null, the button uses its configured text variant.
  final String? signInButton;

  /// Creates a copy of this object with updated values.
  AppleSignInTexts copyWith({String? signInButton}) =>
      AppleSignInTexts(signInButton: signInButton ?? this.signInButton);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppleSignInTexts && other.signInButton == signInButton;
  }

  @override
  int get hashCode => signInButton.hashCode;
}

/// Convenience getter for [AppleSignInTexts] on [BuildContext].
extension AppleSignInTextsBuildContextExtension on BuildContext {
  /// Returns Apple Sign-In texts from context or defaults.
  AppleSignInTexts get appleSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.apple ??
      AppleSignInTexts.defaults;
}
