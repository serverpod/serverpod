import 'package:flutter/widgets.dart';

import '../localization/sign_in_localization_provider_widget.dart';

/// Texts for the Google Sign-In button on native platforms.
///
/// On web, Google renders its own localized text based on [GSIButtonText] and
/// locale, so these values are only applied for native buttons.
@immutable
class GoogleSignInTexts {
  /// Creates a new [GoogleSignInTexts] configuration.
  const GoogleSignInTexts({
    required this.signingIn,
    required this.signInWith,
    required this.signUpWith,
    required this.continueWith,
    required this.signIn,
  });

  /// Default English texts.
  static const defaults = GoogleSignInTexts(
    signingIn: 'Signing in...',
    signInWith: 'Sign in with Google',
    signUpWith: 'Sign up with Google',
    continueWith: 'Continue with Google',
    signIn: 'Sign in',
  );

  /// Text used while authentication is loading.
  final String signingIn;

  /// Text for "Sign in with Google".
  final String signInWith;

  /// Text for "Sign up with Google".
  final String signUpWith;

  /// Text for "Continue with Google".
  final String continueWith;

  /// Short text for "Sign in".
  final String signIn;

  /// Creates a copy of this object with updated values.
  GoogleSignInTexts copyWith({
    String? signingIn,
    String? signInWith,
    String? signUpWith,
    String? continueWith,
    String? signIn,
  }) {
    return GoogleSignInTexts(
      signingIn: signingIn ?? this.signingIn,
      signInWith: signInWith ?? this.signInWith,
      signUpWith: signUpWith ?? this.signUpWith,
      continueWith: continueWith ?? this.continueWith,
      signIn: signIn ?? this.signIn,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GoogleSignInTexts &&
        other.signingIn == signingIn &&
        other.signInWith == signInWith &&
        other.signUpWith == signUpWith &&
        other.continueWith == continueWith &&
        other.signIn == signIn;
  }

  @override
  int get hashCode =>
      Object.hash(signingIn, signInWith, signUpWith, continueWith, signIn);
}

/// Convenience getter for [GoogleSignInTexts] on [BuildContext].
extension GoogleSignInTextsBuildContextExtension on BuildContext {
  /// Returns Google Sign-In texts from context or defaults.
  GoogleSignInTexts get googleSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.google ??
      GoogleSignInTexts.defaults;
}
