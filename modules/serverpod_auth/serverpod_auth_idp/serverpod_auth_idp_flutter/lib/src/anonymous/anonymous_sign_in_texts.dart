import 'package:flutter/widgets.dart';

import '../localization/sign_in_localization_provider_widget.dart';

/// Texts for the anonymous sign-in widget.
@immutable
class AnonymousSignInTexts {
  /// Creates a new [AnonymousSignInTexts] configuration.
  const AnonymousSignInTexts({this.signInButton});

  /// Default English texts.
  static const defaults = AnonymousSignInTexts(signInButton: null);

  /// Optional override text for the anonymous sign-in button.
  ///
  /// If null, the default provider text is used.
  final String? signInButton;

  /// Creates a copy of this object with updated values.
  AnonymousSignInTexts copyWith({String? signInButton}) =>
      AnonymousSignInTexts(signInButton: signInButton ?? this.signInButton);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnonymousSignInTexts && other.signInButton == signInButton;
  }

  @override
  int get hashCode => signInButton.hashCode;
}

/// Convenience getter for [AnonymousSignInTexts] on [BuildContext].
extension AnonymousSignInTextsBuildContextExtension on BuildContext {
  /// Returns anonymous sign-in texts from context or defaults.
  AnonymousSignInTexts get anonymousSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.anonymous ??
      AnonymousSignInTexts.defaults;
}
