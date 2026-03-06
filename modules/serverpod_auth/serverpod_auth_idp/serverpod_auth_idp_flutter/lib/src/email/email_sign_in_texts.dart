import 'package:flutter/widgets.dart';

import '../localization/sign_in_localization_provider_widget.dart';

/// Text for the email sign-in flow.
@immutable
class EmailSignInTexts {
  /// Creates a new [EmailSignInTexts] configuration.
  const EmailSignInTexts({
    required this.title,
    required this.forgotPassword,
    required this.signIn,
    required this.dontHaveAnAccount,
    required this.signUp,
    required this.signUpTitle,
    required this.continueAction,
    required this.alreadyHaveAnAccount,
    required this.verifyAccountTitle,
    required this.verifyResetCodeTitle,
    required this.verificationMessage,
    required this.verify,
    required this.setAccountPasswordTitle,
    required this.passwordLabel,
    required this.backToSignUp,
    required this.setNewPasswordTitle,
    required this.newPasswordLabel,
    required this.resetPasswordTitle,
    required this.resetPasswordDescription,
    required this.requestPasswordReset,
    required this.resetPassword,
    required this.backToSignIn,
    required this.emailLabel,
    required this.termsIntro,
    required this.termsAndConditions,
    required this.andText,
    required this.privacyPolicy,
  });

  /// Default english texts.
  static const defaults = EmailSignInTexts(
    title: 'Sign In with email',
    forgotPassword: 'Forgot password?',
    signIn: 'Sign in',
    dontHaveAnAccount: "Don't have an account?",
    signUp: 'Sign up',
    signUpTitle: 'Sign Up with email',
    continueAction: 'Continue',
    alreadyHaveAnAccount: 'Already have an account?',
    verifyAccountTitle: 'Verify account',
    verifyResetCodeTitle: 'Verify reset code',
    verificationMessage:
        'A verification email has been sent. Please check your email and '
        'enter the verification code below.',
    verify: 'Verify',
    setAccountPasswordTitle: 'Set account password',
    passwordLabel: 'Password',
    backToSignUp: 'Back to sign up',
    setNewPasswordTitle: 'Set new password',
    newPasswordLabel: 'New Password',
    resetPasswordTitle: 'Reset password',
    resetPasswordDescription: 'Enter the email address to reset password.',
    requestPasswordReset: 'Request password reset',
    resetPassword: 'Reset password',
    backToSignIn: 'Back to sign in',
    emailLabel: 'Email',
    termsIntro: 'I have read and accept the ',
    termsAndConditions: 'Terms and Conditions',
    andText: ' and ',
    privacyPolicy: 'Privacy Policy',
  );

  /// Title on the login form.
  final String title;

  /// Text for the "forgot password" action.
  final String forgotPassword;

  /// Generic sign-in text.
  final String signIn;

  /// Prompt shown when no account exists.
  final String dontHaveAnAccount;

  /// Generic sign-up text.
  final String signUp;

  /// Title on the start registration form.
  final String signUpTitle;

  /// Text for continue actions in the email flow.
  final String continueAction;

  /// Prompt shown when an account already exists.
  final String alreadyHaveAnAccount;

  /// Title for account verification.
  final String verifyAccountTitle;

  /// Title for password reset code verification.
  final String verifyResetCodeTitle;

  /// Message shown in verification screens.
  final String verificationMessage;

  /// Text for verification actions.
  final String verify;

  /// Title on the set account password screen.
  final String setAccountPasswordTitle;

  /// Label for the standard password field.
  final String passwordLabel;

  /// Text for returning to the sign-up screen.
  final String backToSignUp;

  /// Title on the set new password screen.
  final String setNewPasswordTitle;

  /// Label for the new password field.
  final String newPasswordLabel;

  /// Title on the password reset request screen.
  final String resetPasswordTitle;

  /// Description shown on the password reset request screen.
  final String resetPasswordDescription;

  /// Text for requesting a password reset.
  final String requestPasswordReset;

  /// Text for reset password actions.
  final String resetPassword;

  /// Text for returning to the sign-in screen.
  final String backToSignIn;

  /// Label for email text fields.
  final String emailLabel;

  /// Prefix text in the terms and privacy notice.
  final String termsIntro;

  /// Text for terms and conditions.
  final String termsAndConditions;

  /// Connector text between terms and privacy texts.
  final String andText;

  /// Text for privacy policy.
  final String privacyPolicy;

  /// Creates a copy of this object with updated values.
  EmailSignInTexts copyWith({
    String? title,
    String? forgotPassword,
    String? signIn,
    String? dontHaveAnAccount,
    String? signUp,
    String? signUpTitle,
    String? continueAction,
    String? alreadyHaveAnAccount,
    String? verifyAccountTitle,
    String? verifyResetCodeTitle,
    String? verificationMessage,
    String? verify,
    String? setAccountPasswordTitle,
    String? passwordLabel,
    String? backToSignUp,
    String? setNewPasswordTitle,
    String? newPasswordLabel,
    String? resetPasswordTitle,
    String? resetPasswordDescription,
    String? requestPasswordReset,
    String? resetPassword,
    String? backToSignIn,
    String? emailLabel,
    String? termsIntro,
    String? termsAndConditions,
    String? andText,
    String? privacyPolicy,
  }) {
    return EmailSignInTexts(
      title: title ?? this.title,
      forgotPassword: forgotPassword ?? this.forgotPassword,
      signIn: signIn ?? this.signIn,
      dontHaveAnAccount: dontHaveAnAccount ?? this.dontHaveAnAccount,
      signUp: signUp ?? this.signUp,
      signUpTitle: signUpTitle ?? this.signUpTitle,
      continueAction: continueAction ?? this.continueAction,
      alreadyHaveAnAccount: alreadyHaveAnAccount ?? this.alreadyHaveAnAccount,
      verifyAccountTitle: verifyAccountTitle ?? this.verifyAccountTitle,
      verifyResetCodeTitle: verifyResetCodeTitle ?? this.verifyResetCodeTitle,
      verificationMessage: verificationMessage ?? this.verificationMessage,
      verify: verify ?? this.verify,
      setAccountPasswordTitle:
          setAccountPasswordTitle ?? this.setAccountPasswordTitle,
      passwordLabel: passwordLabel ?? this.passwordLabel,
      backToSignUp: backToSignUp ?? this.backToSignUp,
      setNewPasswordTitle: setNewPasswordTitle ?? this.setNewPasswordTitle,
      newPasswordLabel: newPasswordLabel ?? this.newPasswordLabel,
      resetPasswordTitle: resetPasswordTitle ?? this.resetPasswordTitle,
      resetPasswordDescription:
          resetPasswordDescription ?? this.resetPasswordDescription,
      requestPasswordReset: requestPasswordReset ?? this.requestPasswordReset,
      resetPassword: resetPassword ?? this.resetPassword,
      backToSignIn: backToSignIn ?? this.backToSignIn,
      emailLabel: emailLabel ?? this.emailLabel,
      termsIntro: termsIntro ?? this.termsIntro,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      andText: andText ?? this.andText,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmailSignInTexts &&
        other.title == title &&
        other.forgotPassword == forgotPassword &&
        other.signIn == signIn &&
        other.dontHaveAnAccount == dontHaveAnAccount &&
        other.signUp == signUp &&
        other.signUpTitle == signUpTitle &&
        other.continueAction == continueAction &&
        other.alreadyHaveAnAccount == alreadyHaveAnAccount &&
        other.verifyAccountTitle == verifyAccountTitle &&
        other.verifyResetCodeTitle == verifyResetCodeTitle &&
        other.verificationMessage == verificationMessage &&
        other.verify == verify &&
        other.setAccountPasswordTitle == setAccountPasswordTitle &&
        other.passwordLabel == passwordLabel &&
        other.backToSignUp == backToSignUp &&
        other.setNewPasswordTitle == setNewPasswordTitle &&
        other.newPasswordLabel == newPasswordLabel &&
        other.resetPasswordTitle == resetPasswordTitle &&
        other.resetPasswordDescription == resetPasswordDescription &&
        other.requestPasswordReset == requestPasswordReset &&
        other.resetPassword == resetPassword &&
        other.backToSignIn == backToSignIn &&
        other.emailLabel == emailLabel &&
        other.termsIntro == termsIntro &&
        other.termsAndConditions == termsAndConditions &&
        other.andText == andText &&
        other.privacyPolicy == privacyPolicy;
  }

  @override
  int get hashCode => Object.hashAll([
    title,
    forgotPassword,
    signIn,
    dontHaveAnAccount,
    signUp,
    signUpTitle,
    continueAction,
    alreadyHaveAnAccount,
    verifyAccountTitle,
    verifyResetCodeTitle,
    verificationMessage,
    verify,
    setAccountPasswordTitle,
    passwordLabel,
    backToSignUp,
    setNewPasswordTitle,
    newPasswordLabel,
    resetPasswordTitle,
    resetPasswordDescription,
    requestPasswordReset,
    resetPassword,
    backToSignIn,
    emailLabel,
    termsIntro,
    termsAndConditions,
    andText,
    privacyPolicy,
  ]);
}

/// Convenience getter for [EmailSignInTexts] on [BuildContext].
extension EmailSignInTextsBuildContextExtension on BuildContext {
  /// Returns email sign-in texts from context or defaults.
  EmailSignInTexts get emailSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.email ??
      EmailSignInTexts.defaults;
}
