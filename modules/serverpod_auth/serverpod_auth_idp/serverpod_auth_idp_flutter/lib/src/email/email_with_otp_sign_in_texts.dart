import 'package:flutter/widgets.dart';

import '../localization/sign_in_localization_provider_widget.dart';

/// Texts for the passwordless email sign-in flow with one-time passwords, see
/// `EmailOtpSignInWidget`.
///
/// The texts shared with the password based flow, such as the email field and
/// the password reset screens, are set through [EmailSignInTexts].
@immutable
class EmailWithOtpSignInTexts {
  /// Creates a new [EmailWithOtpSignInTexts] configuration.
  const EmailWithOtpSignInTexts({
    required this.startTitle,
    required this.sendCode,
    required this.signInWithPassword,
    required this.signInWithCode,
    required this.verifyTitle,
    required this.verificationMessage,
    required this.verifyAction,
    required this.createAccountTitle,
    required this.createAccountMessage,
    required this.addPassword,
    required this.removePassword,
    required this.passwordLabel,
    required this.createAccount,
  });

  /// Default English texts.
  static const defaults = EmailWithOtpSignInTexts(
    startTitle: 'Sign In with email',
    sendCode: 'Send code',
    signInWithPassword: 'Sign in with password',
    signInWithCode: 'Sign in with a code',
    verifyTitle: 'Check your email',
    verificationMessage:
        'We sent a sign-in code to your email. Enter it below to continue.',
    verifyAction: 'Continue',
    createAccountTitle: 'Create your account',
    createAccountMessage: 'No account exists for this email yet.',
    addPassword: 'Add a password (optional)',
    removePassword: 'Continue without a password',
    passwordLabel: 'Password',
    createAccount: 'Create account',
  );

  /// Title on the start screen.
  final String startTitle;

  /// Text for the action requesting a one-time password.
  final String sendCode;

  /// Text for expanding the password sign-in on the start screen.
  final String signInWithPassword;

  /// Text for collapsing the password sign-in on the start screen.
  final String signInWithCode;

  /// Title on the verification screen.
  final String verifyTitle;

  /// Message shown on the verification screen.
  final String verificationMessage;

  /// Text for the action verifying the code, which signs in or continues to
  /// account creation.
  final String verifyAction;

  /// Title on the screen creating an account for an email without one.
  final String createAccountTitle;

  /// Message shown on the screen creating an account.
  final String createAccountMessage;

  /// Text for showing the optional password field when creating an account.
  final String addPassword;

  /// Text for hiding the optional password field when creating an account.
  final String removePassword;

  /// Label for the password field when creating an account.
  final String passwordLabel;

  /// Text for the action creating an account.
  final String createAccount;

  /// Creates a copy of this object with updated values.
  EmailWithOtpSignInTexts copyWith({
    String? startTitle,
    String? sendCode,
    String? signInWithPassword,
    String? signInWithCode,
    String? verifyTitle,
    String? verificationMessage,
    String? verifyAction,
    String? createAccountTitle,
    String? createAccountMessage,
    String? addPassword,
    String? removePassword,
    String? passwordLabel,
    String? createAccount,
  }) {
    return EmailWithOtpSignInTexts(
      startTitle: startTitle ?? this.startTitle,
      sendCode: sendCode ?? this.sendCode,
      signInWithPassword: signInWithPassword ?? this.signInWithPassword,
      signInWithCode: signInWithCode ?? this.signInWithCode,
      verifyTitle: verifyTitle ?? this.verifyTitle,
      verificationMessage: verificationMessage ?? this.verificationMessage,
      verifyAction: verifyAction ?? this.verifyAction,
      createAccountTitle: createAccountTitle ?? this.createAccountTitle,
      createAccountMessage: createAccountMessage ?? this.createAccountMessage,
      addPassword: addPassword ?? this.addPassword,
      removePassword: removePassword ?? this.removePassword,
      passwordLabel: passwordLabel ?? this.passwordLabel,
      createAccount: createAccount ?? this.createAccount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmailWithOtpSignInTexts &&
        other.startTitle == startTitle &&
        other.sendCode == sendCode &&
        other.signInWithPassword == signInWithPassword &&
        other.signInWithCode == signInWithCode &&
        other.verifyTitle == verifyTitle &&
        other.verificationMessage == verificationMessage &&
        other.verifyAction == verifyAction &&
        other.createAccountTitle == createAccountTitle &&
        other.createAccountMessage == createAccountMessage &&
        other.addPassword == addPassword &&
        other.removePassword == removePassword &&
        other.passwordLabel == passwordLabel &&
        other.createAccount == createAccount;
  }

  @override
  int get hashCode => Object.hashAll([
    startTitle,
    sendCode,
    signInWithPassword,
    signInWithCode,
    verifyTitle,
    verificationMessage,
    verifyAction,
    createAccountTitle,
    createAccountMessage,
    addPassword,
    removePassword,
    passwordLabel,
    createAccount,
  ]);
}

/// Convenience getter for [EmailWithOtpSignInTexts] on [BuildContext].
extension EmailWithOtpSignInTextsBuildContextExtension on BuildContext {
  /// Returns the passwordless email sign-in texts from context or defaults.
  EmailWithOtpSignInTexts get emailWithOtpSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.emailWithOtp ??
      EmailWithOtpSignInTexts.defaults;
}
