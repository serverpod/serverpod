import 'package:flutter/widgets.dart';

import '../localization/sign_in_localization_provider_widget.dart';

/// Texts for the Facebook Sign-In button.
@immutable
class FacebookSignInTexts {
  /// Creates a new [FacebookSignInTexts] configuration.
  const FacebookSignInTexts({this.signInButton});

  /// Defaults to provider-managed button text.
  static const defaults = FacebookSignInTexts(signInButton: null);

  /// Optional override text for the Facebook sign-in button.
  ///
  /// If null, the button uses its configured text variant.
  final String? signInButton;

  /// Creates a copy of this object with updated values.
  FacebookSignInTexts copyWith({String? signInButton}) =>
      FacebookSignInTexts(signInButton: signInButton ?? this.signInButton);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FacebookSignInTexts && other.signInButton == signInButton;
  }

  @override
  int get hashCode => signInButton.hashCode;
}

/// Convenience getter for [FacebookSignInTexts] on [BuildContext].
extension FacebookSignInTextsBuildContextExtension on BuildContext {
  /// Returns Facebook Sign-In texts from context or defaults.
  FacebookSignInTexts get facebookSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.facebook ??
      FacebookSignInTexts.defaults;
}
