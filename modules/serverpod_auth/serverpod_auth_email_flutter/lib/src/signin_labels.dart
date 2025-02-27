/// A collection of [String] used in the `SignInWithEmailDialog`.
/// When [null] the default/english labels will be used.
class SignInWithEmailDialogLabels {
  /// Label text for the username input field.
  /// Used in the sign-up form TextField.
  String? inputLabelUserName;

  /// Label text for the email input field.
  /// Used in both sign-in and sign-up forms TextField.
  String? inputLabelEmail;

  /// Label text for the password input field.
  /// Used in both sign-in and sign-up forms TextField.
  String? inputLabelPassword;

  /// Button text for creating a new account.
  /// Used in the main dialog when in sign-up mode.
  String? buttonTitleCreateAccount;

  /// Button text for switching to sign-in mode.
  /// Used in the sign-up form to switch back to sign-in.
  String? buttonTitleIHaveAccount;

  /// Button text for signing in.
  /// Used in the main dialog when in sign-in mode.
  String? buttonTitleSignIn;

  /// Button text for the forgot password option.
  /// Used in the sign-in form below the password field.
  String? buttonTitleForgotPassword;

  /// Button text for initiating password reset.
  /// Used in the password reset form.
  String? buttonTitleResetPassword;

  /// Label text for the new password input field.
  /// Used in the password reset form TextField.
  String? inputLabelNewPassword;

  /// Button text for navigating back.
  /// Used in various forms to return to the previous screen.
  String? buttonTitleBack;

  /// Message shown after sending email verification code.
  /// Displayed in the email verification screen.
  String? messageEmailVerificationSent;

  /// Label text for the validation code input field.
  /// Used in both email verification and password reset forms TextField.
  String? inputLabelValidationCode;

  /// Message shown after sending password reset code.
  /// Displayed in the password reset verification screen.
  String? messagePasswordResetSent;

  /// Error message shown when username is empty.
  /// Displayed under the username field in sign-up form.
  String? errorMessageUserNameRequired;

  /// Error message shown for invalid email format.
  /// Displayed under the email field in both sign-in and sign-up forms.
  String? errorMessageInvalidEmail;

  /// Callback function that returns a formatted string for minimum length validation.
  /// Takes the required length as a parameter.
  /// Used for password length validation messages.
  String Function(int length)? minimumLengthMessage;

  /// Callback function that returns a formatted string for maximum length validation.
  /// Takes the maximum allowed length as a parameter.
  /// Used for password length validation messages.
  String Function(int length)? maximumLengthMessage;

  /// Error message shown when email is already registered.
  /// Displayed under the email field in sign-up form.
  String? errorMessageEmailInUse;

  /// Message prompting to enter verification code.
  /// Used in both email verification and password reset screens.
  String? messageEnterCode;

  /// Error message shown when verification code is incorrect.
  /// Displayed in both email verification and password reset forms.
  String? errorMessageIncorrectCode;

  /// Error message shown when password is incorrect.
  /// Displayed under the password field in sign-in form.
  String? errorMessageIncorrectPassword;

  /// Optional labels for the `SignInWithEmailDialog`.
  SignInWithEmailDialogLabels({
    this.inputLabelUserName,
    this.inputLabelEmail,
    this.inputLabelPassword,
    this.buttonTitleCreateAccount,
    this.buttonTitleIHaveAccount,
    this.buttonTitleSignIn,
    this.buttonTitleForgotPassword,
    this.buttonTitleResetPassword,
    this.inputLabelNewPassword,
    this.buttonTitleBack,
    this.messageEmailVerificationSent,
    this.inputLabelValidationCode,
    this.messagePasswordResetSent,
    this.errorMessageUserNameRequired,
    this.errorMessageInvalidEmail,
    this.minimumLengthMessage,
    this.maximumLengthMessage,
    this.errorMessageEmailInUse,
    this.messageEnterCode,
    this.errorMessageIncorrectCode,
    this.errorMessageIncorrectPassword,
  });
}
