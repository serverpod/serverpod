/// A collection of [String] used in the `SignInWithEmailDialog`.
/// When [null] the default/english labels will be used.
class SignInWithEmailDialogLabels {
  /// [TextField] label for `User name`.
  String? userName;

  /// [TextField] label for `Email`.
  String? email;

  /// [TextField] label for `Password`.
  String? password;

  /// [Button] text for `Create Account`.
  String? createAccount;

  /// [Button] text for `I have an account`.
  String? iHaveAnAccount;

  /// [Button] text for `Sign In`.
  String? signIn;

  /// [Button] text for `Forgot Pass`.
  String? forgotPassword;

  /// [Button] text for `Reset Password`.
  String? resetPassword;

  /// [TextField] label for `New Password`.
  String? newPassword;

  /// [Button] text for `Back`.
  String? back;

  /// [Text] for `Please check your email. We have sent you a code to verify your address.`.
  String? confirmEmailMessage;

  /// [TextField] label for `Validation Code`.
  String? validationCode;

  /// [Text] for `Please check your email. We have sent you a code to verify your account.`.
  String? confirmPasswordResetMessage;

  /// [Text] for `Please enter a user name`.
  String? userNameRequired;

  /// [Text] for `Invalid email`.
  String? invalidEmail;

  /// [Text] for `Minimum`. Used in `Minimum ${passwordLength} characters`.
  String? minimum;

  /// [Text] for `Maximum`. Used in `Maximum ${passwordLength} characters`.
  String? maximum;

  /// [Text] for `characters`. Used in `Minimum ${passwordLength} characters` and `Maximum ${passwordLength} characters`.
  String? characters;

  /// [Text] for `Email already in use`.
  String? emailInUse;

  /// [Text] for `Enter your code`.
  String? enterCode;

  /// [Text] for `Incorrect code`.
  String? incorrectCode;

  /// [Text] for `Incorrect password`.
  String? incorrectPassword;

  /// Optional labels for the `SignInWithEmailDialog`.
  SignInWithEmailDialogLabels({
    this.userName,
    this.email,
    this.password,
    this.createAccount,
    this.iHaveAnAccount,
    this.signIn,
    this.forgotPassword,
    this.resetPassword,
    this.newPassword,
    this.back,
    this.confirmEmailMessage,
    this.validationCode,
    this.confirmPasswordResetMessage,
    this.userNameRequired,
    this.invalidEmail,
    this.minimum,
    this.maximum,
    this.characters,
    this.emailInUse,
    this.enterCode,
    this.incorrectCode,
    this.incorrectPassword,
  });
}
