import 'package:flutter/widgets.dart';

import 'sign_in_localization_provider_widget.dart';

/// Texts for basic sign-in UI elements.
@immutable
class BasicSignInTexts {
  /// Creates a new [BasicSignInTexts] configuration.
  const BasicSignInTexts({
    required this.noAuthenticationProvidersConfigured,
    required this.orContinueWith,
  });

  /// Default english texts.
  static const defaults = BasicSignInTexts(
    noAuthenticationProvidersConfigured:
        'No authentication providers configured',
    orContinueWith: 'or continue with',
  );

  /// Message shown when no identity provider is available on the server.
  final String noAuthenticationProvidersConfigured;

  /// Text shown in the divider above social sign-in options.
  final String orContinueWith;

  /// Creates a copy of this object with updated values.
  BasicSignInTexts copyWith({
    String? noAuthenticationProvidersConfigured,
    String? orContinueWith,
  }) {
    return BasicSignInTexts(
      noAuthenticationProvidersConfigured:
          noAuthenticationProvidersConfigured ??
          this.noAuthenticationProvidersConfigured,
      orContinueWith: orContinueWith ?? this.orContinueWith,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicSignInTexts &&
        other.noAuthenticationProvidersConfigured ==
            noAuthenticationProvidersConfigured &&
        other.orContinueWith == orContinueWith;
  }

  @override
  int get hashCode =>
      Object.hash(noAuthenticationProvidersConfigured, orContinueWith);
}

/// Convenience getter for [BasicSignInTexts] on [BuildContext].
extension BasicSignInTextsBuildContextExtension on BuildContext {
  /// Returns basic sign-in texts from context or defaults.
  BasicSignInTexts get basicSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.basic ??
      BasicSignInTexts.defaults;
}
