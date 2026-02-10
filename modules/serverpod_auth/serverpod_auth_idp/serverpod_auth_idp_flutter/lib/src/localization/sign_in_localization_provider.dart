import 'package:flutter/widgets.dart';

@immutable
class BasicSignInTexts {
  const BasicSignInTexts({
    required this.noAuthenticationProvidersConfigured,
    required this.orContinueWith,
  });

  static const defaults = BasicSignInTexts(
    noAuthenticationProvidersConfigured:
        'No authentication providers configured',
    orContinueWith: 'or continue with',
  );

  final String noAuthenticationProvidersConfigured;

  final String orContinueWith;

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

@immutable
class EmailSignInTexts {
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

  final String title;

  final String forgotPassword;

  final String signIn;

  final String dontHaveAnAccount;

  final String signUp;

  final String signUpTitle;

  final String continueAction;

  final String alreadyHaveAnAccount;

  final String verifyAccountTitle;

  final String verifyResetCodeTitle;

  final String verificationMessage;

  final String verify;

  final String setAccountPasswordTitle;

  final String passwordLabel;

  final String backToSignUp;

  final String setNewPasswordTitle;

  final String newPasswordLabel;

  final String resetPasswordTitle;

  final String resetPasswordDescription;

  final String requestPasswordReset;

  final String resetPassword;

  final String backToSignIn;

  final String emailLabel;

  final String termsIntro;

  final String termsAndConditions;

  final String andText;

  final String privacyPolicy;

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

@immutable
class AppleSignInTexts {
  const AppleSignInTexts({
    required this.signInWith,
    required this.continueWith,
    required this.signUpWith,
    required this.signIn,
  });

  static const defaults = AppleSignInTexts(
    signInWith: 'Sign in with Apple',
    continueWith: 'Continue with Apple',
    signUpWith: 'Sign up with Apple',
    signIn: 'Sign in',
  );

  final String signInWith;

  final String continueWith;

  final String signUpWith;

  final String signIn;

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

@immutable
class GoogleSignInTexts {
  const GoogleSignInTexts({
    required this.signingIn,
    required this.signInWith,
    required this.signUpWith,
    required this.continueWith,
    required this.signIn,
  });

  static const defaults = GoogleSignInTexts(
    signingIn: 'Signing in...',
    signInWith: 'Sign in with Google',
    signUpWith: 'Sign up with Google',
    continueWith: 'Continue with Google',
    signIn: 'Sign in',
  );

  final String signingIn;

  final String signInWith;

  final String signUpWith;

  final String continueWith;

  final String signIn;

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

@immutable
class GitHubSignInTexts {
  const GitHubSignInTexts({
    required this.signInWith,
    required this.signUpWith,
    required this.continueWith,
  });

  static const defaults = GitHubSignInTexts(
    signInWith: 'Sign in with GitHub',
    signUpWith: 'Sign up with GitHub',
    continueWith: 'Continue with GitHub',
  );

  final String signInWith;

  final String signUpWith;

  final String continueWith;

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

@immutable
class AnonymousSignInTexts {
  const AnonymousSignInTexts({
    required this.continueWithoutAccount,
  });

  static const defaults = AnonymousSignInTexts(
    continueWithoutAccount: 'Continue without account',
  );

  final String continueWithoutAccount;

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

class SignInLocalizationProvider extends InheritedWidget {
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

  final BasicSignInTexts basic;

  final EmailSignInTexts email;

  final AppleSignInTexts apple;

  final GoogleSignInTexts google;

  final GitHubSignInTexts github;

  final AnonymousSignInTexts anonymous;

  static SignInLocalizationProvider? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SignInLocalizationProvider>();
  }

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

extension SignInLocalizationBuildContext on BuildContext {
  BasicSignInTexts get basicSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.basic ??
      BasicSignInTexts.defaults;

  EmailSignInTexts get emailSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.email ??
      EmailSignInTexts.defaults;

  AppleSignInTexts get appleSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.apple ??
      AppleSignInTexts.defaults;

  GoogleSignInTexts get googleSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.google ??
      GoogleSignInTexts.defaults;

  GitHubSignInTexts get githubSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.github ??
      GitHubSignInTexts.defaults;

  AnonymousSignInTexts get anonymousSignInTexts =>
      SignInLocalizationProvider.maybeOf(this)?.anonymous ??
      AnonymousSignInTexts.defaults;
}
