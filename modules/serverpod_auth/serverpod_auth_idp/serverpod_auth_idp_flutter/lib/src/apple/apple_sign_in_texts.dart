import 'package:flutter/widgets.dart';

import '../localization/sign_in_localization_provider_widget.dart';

/// Texts for the Apple Sign-In button.
@immutable
class AppleSignInTexts {
  /// Creates a new [AppleSignInTexts] configuration.
  const AppleSignInTexts({
    required this.signInWith,
    required this.continueWith,
    required this.signUpWith,
    required this.signIn,
  });

  /// Default English texts.
  static const defaults = AppleSignInTexts(
    signInWith: 'Sign in with Apple',
    continueWith: 'Continue with Apple',
    signUpWith: 'Sign up with Apple',
    signIn: 'Sign in',
  );

  /// Text for "Sign in with Apple".
  final String signInWith;

  /// Text for "Continue with Apple".
  final String continueWith;

  /// Text for "Sign up with Apple".
  final String signUpWith;

  /// Short text for "Sign in".
  final String signIn;

  /// Creates a copy of this object with updated values.
  AppleSignInTexts copyWith({
    String? signInWith,
    String? continueWith,
    String? signUpWith,
    String? signIn,
  }) {
    return AppleSignInTexts(
      signInWith: signInWith ?? this.signInWith,
      continueWith: continueWith ?? this.continueWith,
      signUpWith: signUpWith ?? this.signUpWith,
      signIn: signIn ?? this.signIn,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppleSignInTexts &&
        other.signInWith == signInWith &&
        other.continueWith == continueWith &&
        other.signUpWith == signUpWith &&
        other.signIn == signIn;
  }

  @override
  int get hashCode => Object.hash(signInWith, continueWith, signUpWith, signIn);
}

/// Convenience getter for [AppleSignInTexts] on [BuildContext].
extension AppleSignInTextsBuildContextExtension on BuildContext {
  /// Returns Apple Sign-In texts from context or defaults.
  AppleSignInTexts get appleSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.apple ??
      AppleSignInTexts.defaults;
}
