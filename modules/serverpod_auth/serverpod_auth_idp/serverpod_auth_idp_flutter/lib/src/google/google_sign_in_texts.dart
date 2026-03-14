import 'package:flutter/widgets.dart';

import '../localization/sign_in_localization_provider_widget.dart';

/// Texts for the Google Sign-In button on native platforms.
///
/// On web, Google renders its own localized text based on [GSIButtonText] and
/// locale, so this value is only applied for native buttons.
@immutable
class GoogleSignInTexts {
  /// Creates a new [GoogleSignInTexts] configuration.
  const GoogleSignInTexts({this.signInButton});

  /// Defaults to provider-managed button text.
  static const defaults = GoogleSignInTexts(signInButton: null);

  /// Optional override text for the Google sign-in button.
  ///
  /// If null, the button uses its configured text variant.
  final String? signInButton;

  /// Creates a copy of this object with updated values.
  GoogleSignInTexts copyWith({String? signInButton}) =>
      GoogleSignInTexts(signInButton: signInButton ?? this.signInButton);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GoogleSignInTexts && other.signInButton == signInButton;
  }

  @override
  int get hashCode => signInButton.hashCode;
}

/// Convenience getter for [GoogleSignInTexts] on [BuildContext].
extension GoogleSignInTextsBuildContextExtension on BuildContext {
  /// Returns Google Sign-In texts from context or defaults.
  GoogleSignInTexts get googleSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.google ??
      GoogleSignInTexts.defaults;
}
