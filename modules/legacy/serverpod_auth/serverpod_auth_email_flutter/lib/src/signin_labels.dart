/// A collection of [String] used in the `SignInWithEmailDialog`.
/// When [null] the default/english labels will be used.
class SignInWithEmailDialogLabels {
  /// Hint text for the username input field.
  /// Used in the sign-up form TextField.
  final String inputHintUserName;

  /// Hint text for the email input field.
  /// Used in both sign-in and sign-up forms TextField.
  final String inputHintEmail;

  /// Hint text for the password input field.
  /// Used in both sign-in and sign-up forms TextField.
  final String inputHintPassword;

  /// Button text for the sign-up submit button.
  /// Used in the sign-up form to create a new account.
  final String buttonTitleSignUp;

  /// Button text for navigating to sign-up form.
  /// Used in the sign-in form to switch to account creation.
  final String buttonTitleOpenSignUp;

  /// Button text for navigating to sign-in form.
  /// Used in the sign-up form to return to sign-in.
  final String buttonTitleOpenSignIn;

  /// Button text for the sign-in submit button.
  /// Used in the sign-in form to authenticate the user.
  final String buttonTitleSignIn;

  /// Button text for the forgot password option.
  /// Used in the sign-in form below the password field.
  final String buttonTitleForgotPassword;

  /// Button text for initiating password reset.
  /// Used in the password reset form.
  final String buttonTitleResetPassword;

  /// Hint text for the new password input field.
  /// Used in the password reset form TextField.
  final String inputHintNewPassword;

  /// Button text for navigating back.
  /// Used in various forms to return to the previous screen.
  final String buttonTitleBack;

  /// Message shown after sending email verification code.
  /// Displayed in the email verification screen.
  final String messageEmailVerificationSent;

  /// Hint text for the validation code input field.
  /// Used in both email verification and password reset forms TextField.
  final String inputHintValidationCode;

  /// Message shown after sending password reset code.
  /// Displayed in the password reset verification screen.
  final String messagePasswordResetSent;

  /// Error message shown when username is empty.
  /// Displayed under the username field in sign-up form.
  final String errorMessageUserNameRequired;

  /// Error message shown for invalid email format.
  /// Displayed under the email field in both sign-in and sign-up forms.
  final String errorMessageInvalidEmail;

  /// Callback function that returns a formatted string for minimum length validation.
  /// Takes the required length as a parameter.
  /// Used for password length validation messages.
  final String Function(int length) minimumLengthMessage;

  /// Callback function that returns a formatted string for maximum length validation.
  /// Takes the maximum allowed length as a parameter.
  /// Used for password length validation messages.
  final String Function(int length) maximumLengthMessage;

  /// Error message shown when email is already registered.
  /// Displayed under the email field in sign-up form.
  final String errorMessageEmailInUse;

  /// Message prompting to enter verification code.
  /// Used in both email verification and password reset screens.
  final String messageEnterCode;

  /// Error message shown when verification code is incorrect.
  /// Displayed in both email verification and password reset forms.
  final String errorMessageIncorrectCode;

  /// Error message shown when password is incorrect.
  /// Displayed under the password field in sign-in form.
  final String errorMessageIncorrectPassword;

  /// Constructor for the `SignInWithEmailDialog` labels.
  /// All parameters are required to ensure complete localization.
  SignInWithEmailDialogLabels({
    required this.inputHintUserName,
    required this.inputHintEmail,
    required this.inputHintPassword,
    required this.buttonTitleSignUp,
    required this.buttonTitleOpenSignUp,
    required this.buttonTitleOpenSignIn,
    required this.buttonTitleSignIn,
    required this.buttonTitleForgotPassword,
    required this.buttonTitleResetPassword,
    required this.inputHintNewPassword,
    required this.buttonTitleBack,
    required this.messageEmailVerificationSent,
    required this.inputHintValidationCode,
    required this.messagePasswordResetSent,
    required this.errorMessageUserNameRequired,
    required this.errorMessageInvalidEmail,
    required this.minimumLengthMessage,
    required this.maximumLengthMessage,
    required this.errorMessageEmailInUse,
    required this.messageEnterCode,
    required this.errorMessageIncorrectCode,
    required this.errorMessageIncorrectPassword,
  });

  /// Factory constructor that creates a new instance with default English labels.
  /// Individual values can be overridden by providing them as parameters.
  factory SignInWithEmailDialogLabels.enUS({
    String? inputHintUserName,
    String? inputHintEmail,
    String? inputHintPassword,
    String? buttonTitleSignUp,
    String? buttonTitleOpenSignUp,
    String? buttonTitleOpenSignIn,
    String? buttonTitleSignIn,
    String? buttonTitleForgotPassword,
    String? buttonTitleResetPassword,
    String? inputHintNewPassword,
    String? buttonTitleBack,
    String? messageEmailVerificationSent,
    String? inputHintValidationCode,
    String? messagePasswordResetSent,
    String? errorMessageUserNameRequired,
    String? errorMessageInvalidEmail,
    String Function(int length)? minimumLengthMessage,
    String Function(int length)? maximumLengthMessage,
    String? errorMessageEmailInUse,
    String? messageEnterCode,
    String? errorMessageIncorrectCode,
    String? errorMessageIncorrectPassword,
  }) {
    return SignInWithEmailDialogLabels(
      inputHintUserName: inputHintUserName ?? 'User name',
      inputHintEmail: inputHintEmail ?? 'Email',
      inputHintPassword: inputHintPassword ?? 'Password',
      buttonTitleSignUp: buttonTitleSignUp ?? 'Sign Up',
      buttonTitleOpenSignUp: buttonTitleOpenSignUp ?? 'Create Account',
      buttonTitleOpenSignIn: buttonTitleOpenSignIn ?? 'I have an account',
      buttonTitleSignIn: buttonTitleSignIn ?? 'Sign In',
      buttonTitleForgotPassword: buttonTitleForgotPassword ?? 'Forgot Pass',
      buttonTitleResetPassword: buttonTitleResetPassword ?? 'Reset Password',
      inputHintNewPassword: inputHintNewPassword ?? 'New password',
      buttonTitleBack: buttonTitleBack ?? 'Back',
      messageEmailVerificationSent:
          messageEmailVerificationSent ??
          'Please check your email. We have sent you a code to verify your address.',
      inputHintValidationCode: inputHintValidationCode ?? 'Validation code',
      messagePasswordResetSent:
          messagePasswordResetSent ??
          'Please check your email. We have sent you a code to verify your account.',
      errorMessageUserNameRequired:
          errorMessageUserNameRequired ?? 'Please enter a user name',
      errorMessageInvalidEmail: errorMessageInvalidEmail ?? 'Invalid email',
      minimumLengthMessage:
          minimumLengthMessage ?? ((length) => 'Minimum $length characters'),
      maximumLengthMessage:
          maximumLengthMessage ?? ((length) => 'Maximum $length characters'),
      errorMessageEmailInUse: errorMessageEmailInUse ?? 'Email already in use',
      messageEnterCode: messageEnterCode ?? 'Enter your code',
      errorMessageIncorrectCode: errorMessageIncorrectCode ?? 'Incorrect code',
      errorMessageIncorrectPassword:
          errorMessageIncorrectPassword ?? 'Incorrect password',
    );
  }
}
