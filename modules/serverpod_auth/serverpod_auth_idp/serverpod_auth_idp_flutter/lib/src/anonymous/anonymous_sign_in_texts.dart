import 'package:flutter/widgets.dart';

import '../localization/sign_in_localization_provider_widget.dart';

/// Texts for the anonymous sign-in widget.
@immutable
class AnonymousSignInTexts {
  /// Creates a new [AnonymousSignInTexts] configuration.
  const AnonymousSignInTexts({
    required this.continueWithoutAccount,
  });

  /// Default English texts.
  static const defaults = AnonymousSignInTexts(
    continueWithoutAccount: 'Continue without account',
  );

  /// Text for anonymous sign-in action.
  final String continueWithoutAccount;

  /// Creates a copy of this object with updated values.
  AnonymousSignInTexts copyWith({
    String? continueWithoutAccount,
  }) {
    return AnonymousSignInTexts(
      continueWithoutAccount:
          continueWithoutAccount ?? this.continueWithoutAccount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnonymousSignInTexts &&
        other.continueWithoutAccount == continueWithoutAccount;
  }

  @override
  int get hashCode => continueWithoutAccount.hashCode;
}

/// Convenience getter for [AnonymousSignInTexts] on [BuildContext].
extension AnonymousSignInTextsBuildContextExtension on BuildContext {
  /// Returns anonymous sign-in texts from context or defaults.
  AnonymousSignInTexts get anonymousSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.anonymous ??
      AnonymousSignInTexts.defaults;
}
