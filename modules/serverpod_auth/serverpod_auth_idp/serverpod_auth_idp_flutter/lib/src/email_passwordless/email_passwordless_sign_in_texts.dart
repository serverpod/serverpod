import 'package:flutter/widgets.dart';

import '../localization/sign_in_localization_provider_widget.dart';

/// Texts for the passwordless email sign-in flow.
///
/// The labels shared with the email and password flow, such as the email field
/// label, are taken from `EmailSignInTexts`.
@immutable
class EmailPasswordlessSignInTexts {
  /// Creates a new [EmailPasswordlessSignInTexts] configuration.
  const EmailPasswordlessSignInTexts({
    required this.title,
    required this.description,
    required this.continueAction,
    required this.verifyTitle,
    required this.verificationMessage,
    required this.verify,
    required this.useDifferentEmail,
    required this.resendCooldownMessage,
  });

  /// Default English texts.
  static const defaults = EmailPasswordlessSignInTexts(
    title: 'Continue with email',
    description: 'Enter your email address to receive a sign-in code.',
    continueAction: 'Send code',
    verifyTitle: 'Enter your code',
    verificationMessage:
        'We sent a code to your email. Enter it below to continue.',
    verify: 'Verify',
    useDifferentEmail: 'Use a different email',
    resendCooldownMessage:
        'A code was sent recently. Use that code, or wait a moment before '
        'requesting a new one.',
  );

  /// Title on the email entry form.
  final String title;

  /// Description shown above the email field.
  final String description;

  /// Label of the button that requests the code.
  final String continueAction;

  /// Title on the verification code form.
  final String verifyTitle;

  /// Message shown on the verification code form.
  final String verificationMessage;

  /// Label of the button that verifies the code.
  final String verify;

  /// Label of the button that returns to the email entry form.
  final String useDifferentEmail;

  /// Message shown when the server refuses to send a new code because one was
  /// sent a short time ago. The code that was sent earlier can still be used.
  final String resendCooldownMessage;

  /// Creates a copy of this object with updated values.
  EmailPasswordlessSignInTexts copyWith({
    String? title,
    String? description,
    String? continueAction,
    String? verifyTitle,
    String? verificationMessage,
    String? verify,
    String? useDifferentEmail,
    String? resendCooldownMessage,
  }) {
    return EmailPasswordlessSignInTexts(
      title: title ?? this.title,
      description: description ?? this.description,
      continueAction: continueAction ?? this.continueAction,
      verifyTitle: verifyTitle ?? this.verifyTitle,
      verificationMessage: verificationMessage ?? this.verificationMessage,
      verify: verify ?? this.verify,
      useDifferentEmail: useDifferentEmail ?? this.useDifferentEmail,
      resendCooldownMessage:
          resendCooldownMessage ?? this.resendCooldownMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmailPasswordlessSignInTexts &&
        other.title == title &&
        other.description == description &&
        other.continueAction == continueAction &&
        other.verifyTitle == verifyTitle &&
        other.verificationMessage == verificationMessage &&
        other.verify == verify &&
        other.useDifferentEmail == useDifferentEmail &&
        other.resendCooldownMessage == resendCooldownMessage;
  }

  @override
  int get hashCode => Object.hash(
    title,
    description,
    continueAction,
    verifyTitle,
    verificationMessage,
    verify,
    useDifferentEmail,
    resendCooldownMessage,
  );
}

/// Convenience getter for [EmailPasswordlessSignInTexts] on [BuildContext].
extension EmailPasswordlessSignInTextsBuildContextExtension on BuildContext {
  /// Returns passwordless email sign-in texts from context or defaults.
  EmailPasswordlessSignInTexts get emailPasswordlessSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.emailPasswordless ??
      EmailPasswordlessSignInTexts.defaults;
}
