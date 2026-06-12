import 'package:flutter/widgets.dart';

import '../localization/sign_in_localization_provider_widget.dart';

/// Texts for the Microsoft Sign-In button.
@immutable
class MicrosoftSignInTexts {
  /// Creates a new [MicrosoftSignInTexts] configuration.
  const MicrosoftSignInTexts({this.signInButton});

  /// Defaults to provider-managed button text.
  static const defaults = MicrosoftSignInTexts(signInButton: null);

  /// Optional override text for the Microsoft sign-in button.
  ///
  /// If null, the button uses its configured text variant.
  final String? signInButton;

  /// Creates a copy of this object with updated values.
  MicrosoftSignInTexts copyWith({String? signInButton}) =>
      MicrosoftSignInTexts(signInButton: signInButton ?? this.signInButton);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MicrosoftSignInTexts && other.signInButton == signInButton;
  }

  @override
  int get hashCode => signInButton.hashCode;
}

/// Convenience getter for [MicrosoftSignInTexts] on [BuildContext].
extension MicrosoftSignInTextsBuildContextExtension on BuildContext {
  /// Returns Microsoft Sign-In texts from context or defaults.
  MicrosoftSignInTexts get microsoftSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.microsoft ??
      MicrosoftSignInTexts.defaults;
}
