/// A collection of [String] used in the `SignInAnonymouslyDialogLabels`.
/// When [null] the default/english labels will be used.
class SignInAnonymouslyDialogLabels {
  /// Button text for the sign-up submit button.
  /// Used in the sign-up form to create a new account.
  final String buttonTitleSignUp;

  /// Button text for navigating back.
  /// Used in various forms to return to the previous screen.
  final String buttonTitleBack;

  /// Constructor for the `SignInWithEmailDialog` labels.
  /// All parameters are required to ensure complete localization.
  SignInAnonymouslyDialogLabels({
    required this.buttonTitleSignUp,
    required this.buttonTitleBack,
  });

  /// Factory constructor that creates a new instance with default English labels.
  /// Individual values can be overridden by providing them as parameters.
  factory SignInAnonymouslyDialogLabels.enUS({
    String? buttonTitleSignUp,
    String? buttonTitleBack,
  }) {
    return SignInAnonymouslyDialogLabels(
      buttonTitleSignUp: buttonTitleSignUp ?? 'Sign Up anonymously',
      buttonTitleBack: buttonTitleBack ?? 'Back',
    );
  }
}
