import 'package:flutter/widgets.dart';

import '../localization/sign_in_localization_provider_widget.dart';

/// Texts for the GitHub Sign-In button.
@immutable
class GitHubSignInTexts {
  /// Creates a new [GitHubSignInTexts] configuration.
  const GitHubSignInTexts({
    required this.signInWith,
    required this.signUpWith,
    required this.continueWith,
  });

  /// Default english texts.
  static const defaults = GitHubSignInTexts(
    signInWith: 'Sign in with GitHub',
    signUpWith: 'Sign up with GitHub',
    continueWith: 'Continue with GitHub',
  );

  /// Text for "Sign in with GitHub".
  final String signInWith;

  /// Text for "Sign up with GitHub".
  final String signUpWith;

  /// Text for "Continue with GitHub".
  final String continueWith;

  /// Creates a copy of this object with updated values.
  GitHubSignInTexts copyWith({
    String? signInWith,
    String? signUpWith,
    String? continueWith,
  }) {
    return GitHubSignInTexts(
      signInWith: signInWith ?? this.signInWith,
      signUpWith: signUpWith ?? this.signUpWith,
      continueWith: continueWith ?? this.continueWith,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GitHubSignInTexts &&
        other.signInWith == signInWith &&
        other.signUpWith == signUpWith &&
        other.continueWith == continueWith;
  }

  @override
  int get hashCode => Object.hash(signInWith, signUpWith, continueWith);
}

/// Convenience getter for [GitHubSignInTexts] on [BuildContext].
extension GitHubSignInTextsBuildContextExtension on BuildContext {
  /// Returns GitHub Sign-In texts from context or defaults.
  GitHubSignInTexts get githubSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.github ??
      GitHubSignInTexts.defaults;
}
