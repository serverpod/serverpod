import 'package:flutter/widgets.dart';

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

/// Texts for the Apple Sign-In button.
@immutable
class AppleSignInTexts {
  /// Creates a new [AppleSignInTexts] configuration.
  const AppleSignInTexts({
    required this.signInWith,
    required this.continueWith,
    required this.signUpWith,
    required this.signIn,
  });

  /// Default English texts.
  static const defaults = AppleSignInTexts(
    signInWith: 'Sign in with Apple',
    continueWith: 'Continue with Apple',
    signUpWith: 'Sign up with Apple',
    signIn: 'Sign in',
  );

  /// Text for "Sign in with Apple".
  final String signInWith;

  /// Text for "Continue with Apple".
  final String continueWith;

  /// Text for "Sign up with Apple".
  final String signUpWith;

  /// Short text for "Sign in".
  final String signIn;

  /// Creates a copy of this object with updated values.
  AppleSignInTexts copyWith({
    String? signInWith,
    String? continueWith,
    String? signUpWith,
    String? signIn,
  }) {
    return AppleSignInTexts(
      signInWith: signInWith ?? this.signInWith,
      continueWith: continueWith ?? this.continueWith,
      signUpWith: signUpWith ?? this.signUpWith,
      signIn: signIn ?? this.signIn,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppleSignInTexts &&
        other.signInWith == signInWith &&
        other.continueWith == continueWith &&
        other.signUpWith == signUpWith &&
        other.signIn == signIn;
  }

  @override
  int get hashCode => Object.hash(signInWith, continueWith, signUpWith, signIn);
}

/// Texts for the Google Sign-In button on native platforms.
///
/// On web, Google renders its own localized text based on [GSIButtonText] and
/// locale, so these values are only applied for native buttons.
@immutable
class GoogleSignInTexts {
  /// Creates a new [GoogleSignInTexts] configuration.
  const GoogleSignInTexts({
    required this.signingIn,
    required this.signInWith,
    required this.signUpWith,
    required this.continueWith,
    required this.signIn,
  });

  /// Default English texts.
  static const defaults = GoogleSignInTexts(
    signingIn: 'Signing in...',
    signInWith: 'Sign in with Google',
    signUpWith: 'Sign up with Google',
    continueWith: 'Continue with Google',
    signIn: 'Sign in',
  );

  /// Text used while authentication is loading.
  final String signingIn;

  /// Text for "Sign in with Google".
  final String signInWith;

  /// Text for "Sign up with Google".
  final String signUpWith;

  /// Text for "Continue with Google".
  final String continueWith;

  /// Short text for "Sign in".
  final String signIn;

  /// Creates a copy of this object with updated values.
  GoogleSignInTexts copyWith({
    String? signingIn,
    String? signInWith,
    String? signUpWith,
    String? continueWith,
    String? signIn,
  }) {
    return GoogleSignInTexts(
      signingIn: signingIn ?? this.signingIn,
      signInWith: signInWith ?? this.signInWith,
      signUpWith: signUpWith ?? this.signUpWith,
      continueWith: continueWith ?? this.continueWith,
      signIn: signIn ?? this.signIn,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GoogleSignInTexts &&
        other.signingIn == signingIn &&
        other.signInWith == signInWith &&
        other.signUpWith == signUpWith &&
        other.continueWith == continueWith &&
        other.signIn == signIn;
  }

  @override
  int get hashCode =>
      Object.hash(signingIn, signInWith, signUpWith, continueWith, signIn);
}

/// Texts for the GitHub Sign-In button.
@immutable
class GitHubSignInTexts {
  /// Creates a new [GitHubSignInTexts] configuration.
  const GitHubSignInTexts({
    required this.signInWith,
    required this.signUpWith,
    required this.continueWith,
  });

  /// Default english texts.
  static const defaults = GitHubSignInTexts(
    signInWith: 'Sign in with GitHub',
    signUpWith: 'Sign up with GitHub',
    continueWith: 'Continue with GitHub',
  );

  /// Text for "Sign in with GitHub".
  final String signInWith;

  /// Text for "Sign up with GitHub".
  final String signUpWith;

  /// Text for "Continue with GitHub".
  final String continueWith;

  /// Creates a copy of this object with updated values.
  GitHubSignInTexts copyWith({
    String? signInWith,
    String? signUpWith,
    String? continueWith,
  }) {
    return GitHubSignInTexts(
      signInWith: signInWith ?? this.signInWith,
      signUpWith: signUpWith ?? this.signUpWith,
      continueWith: continueWith ?? this.continueWith,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GitHubSignInTexts &&
        other.signInWith == signInWith &&
        other.signUpWith == signUpWith &&
        other.continueWith == continueWith;
  }

  @override
  int get hashCode => Object.hash(signInWith, signUpWith, continueWith);
}

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

/// Inherited widget that provides customizable sign-in texts.
class SignInLocalizationProvider extends InheritedWidget {
  /// Creates a new [SignInLocalizationProvider].
  const SignInLocalizationProvider({
    this.basic = BasicSignInTexts.defaults,
    this.email = EmailSignInTexts.defaults,
    this.apple = AppleSignInTexts.defaults,
    this.google = GoogleSignInTexts.defaults,
    this.github = GitHubSignInTexts.defaults,
    this.anonymous = AnonymousSignInTexts.defaults,
    required super.child,
    super.key,
  });

  /// Basic sign-in texts.
  final BasicSignInTexts basic;

  /// Texts for the email sign-in flow.
  final EmailSignInTexts email;

  /// Texts for the Apple Sign-In button.
  final AppleSignInTexts apple;

  /// Texts for the Google Sign-In button.
  final GoogleSignInTexts google;

  /// Texts for the GitHub Sign-In button.
  final GitHubSignInTexts github;

  /// Texts for anonymous sign-in.
  final AnonymousSignInTexts anonymous;

  /// Returns the nearest localization provider in the widget tree, if any.
  static SignInLocalizationProvider? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SignInLocalizationProvider>();
  }

  /// Returns the nearest localization provider in the widget tree.
  ///
  /// Throws an assertion error in debug mode if no provider is found.
  static SignInLocalizationProvider of(BuildContext context) {
    final localizations = maybeOf(context);
    assert(
      localizations != null,
      'No SignInLocalizationProvider found in context',
    );
    return localizations!;
  }

  @override
  bool updateShouldNotify(SignInLocalizationProvider oldWidget) {
    return oldWidget.basic != basic ||
        oldWidget.email != email ||
        oldWidget.apple != apple ||
        oldWidget.google != google ||
        oldWidget.github != github ||
        oldWidget.anonymous != anonymous;
  }
}

/// Convenience getters sign-in text.
extension SignInLocalizationBuildContext on BuildContext {
  /// Returns basic sign-in texts from context or defaults.
  BasicSignInTexts get basicSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.basic ??
      BasicSignInTexts.defaults;

  /// Returns email sign-in texts from context or defaults.
  EmailSignInTexts get emailSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.email ??
      EmailSignInTexts.defaults;

  /// Returns Apple Sign-In texts from context or defaults.
  AppleSignInTexts get appleSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.apple ??
      AppleSignInTexts.defaults;

  /// Returns Google Sign-In texts from context or defaults.
  GoogleSignInTexts get googleSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.google ??
      GoogleSignInTexts.defaults;

  /// Returns GitHub Sign-In texts from context or defaults.
  GitHubSignInTexts get githubSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.github ??
      GitHubSignInTexts.defaults;

  /// Returns anonymous sign-in texts from context or defaults.
  AnonymousSignInTexts get anonymousSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.anonymous ??
      AnonymousSignInTexts.defaults;
}
