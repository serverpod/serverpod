import 'package:flutter/widgets.dart';

import '../localization/sign_in_localization_provider_widget.dart';

/// Texts for the GitHub Sign-In button.
@immutable
class GitHubSignInTexts {
  /// Creates a new [GitHubSignInTexts] configuration.
  const GitHubSignInTexts({this.signInButton});

  /// Defaults to provider-managed button text.
  static const defaults = GitHubSignInTexts(signInButton: null);

  /// Optional override text for the GitHub sign-in button.
  ///
  /// If null, the button uses its configured text variant.
  final String? signInButton;

  /// Creates a copy of this object with updated values.
  GitHubSignInTexts copyWith({String? signInButton}) =>
      GitHubSignInTexts(signInButton: signInButton ?? this.signInButton);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GitHubSignInTexts && other.signInButton == signInButton;
  }

  @override
  int get hashCode => signInButton.hashCode;
}

/// Convenience getter for [GitHubSignInTexts] on [BuildContext].
extension GitHubSignInTextsBuildContextExtension on BuildContext {
  /// Returns GitHub Sign-In texts from context or defaults.
  GitHubSignInTexts get githubSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.github ??
      GitHubSignInTexts.defaults;
}
