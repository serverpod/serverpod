import '../../common/sign_in_button_style.dart';
import 'style.dart';

// Maps the shared sign-in button enums to Google's GSI button enums. Shared by
// the native and web buttons, so these are named (rather than the file-private
// extensions the other providers use) to be importable across both files.

/// Maps [SignInButtonSize] to Google's [GSIButtonSize].
extension SignInButtonSizeGoogleMapping on SignInButtonSize {
  /// The matching [GSIButtonSize]. Google disallows the small size
  /// (Material/HIG minimum target size), so it falls back to medium.
  GSIButtonSize toGoogle() => switch (this) {
    SignInButtonSize.large => GSIButtonSize.large,
    SignInButtonSize.medium => GSIButtonSize.medium,
    SignInButtonSize.small => GSIButtonSize.medium,
  };
}

/// Maps [SignInButtonShape] to Google's [GSIButtonShape].
extension SignInButtonShapeGoogleMapping on SignInButtonShape {
  /// The matching [GSIButtonShape]. The web shape has no rounded option, so
  /// rounded maps to pill; the native button applies the rounded radius via a
  /// borderRadius override.
  GSIButtonShape toGoogle() => switch (this) {
    SignInButtonShape.rectangular => GSIButtonShape.rectangular,
    SignInButtonShape.rounded => GSIButtonShape.pill,
    SignInButtonShape.pill => GSIButtonShape.pill,
  };
}

/// Maps [SignInButtonLogoAlignment] to Google's [GSIButtonLogoAlignment].
extension SignInButtonLogoAlignmentGoogleMapping on SignInButtonLogoAlignment {
  /// The matching [GSIButtonLogoAlignment].
  GSIButtonLogoAlignment toGoogle() => switch (this) {
    SignInButtonLogoAlignment.left => GSIButtonLogoAlignment.left,
    SignInButtonLogoAlignment.center => GSIButtonLogoAlignment.center,
  };
}

/// Maps [SignInButtonTextVariant] to Google's [GSIButtonText].
extension SignInButtonTextVariantGoogleMapping on SignInButtonTextVariant {
  /// The matching [GSIButtonText].
  GSIButtonText toGoogle() => switch (this) {
    SignInButtonTextVariant.signInWith => GSIButtonText.signinWith,
    SignInButtonTextVariant.signUpWith => GSIButtonText.signupWith,
    SignInButtonTextVariant.continueWith => GSIButtonText.continueWith,
    SignInButtonTextVariant.signIn => GSIButtonText.signin,
  };
}
