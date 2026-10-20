import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import 'email_flow_controller.dart';

export 'email_flow_controller.dart' show EmailAuthState, InvalidEmailException;

/// Represents the different screens in the email authentication flow.
enum EmailFlowScreen {
  /// Login screen - user enters email and password to sign in.
  login,

  /// Start registration screen - user enters email and terms checkbox to start
  /// the registration process.
  startRegistration,

  /// Verify registration code screen - user enters verification code to proceed
  /// with the registration process.
  verifyRegistration,

  /// Complete registration screen - user enters password to complete the
  /// registration process.
  completeRegistration,

  /// Request password reset screen - user enters email to request password
  /// reset.
  requestPasswordReset,

  /// Verify password reset screen - user enters verification code to proceed
  /// with the password reset process.
  verifyPasswordReset,

  /// Complete password reset screen - user enters new password to complete the
  /// password reset process.
  completePasswordReset,
}

/// Controller for managing email-based authentication flows.
///
/// This controller handles all the business logic for email authentication,
/// including login, registration, and email verification. It can be used
/// with any UI implementation.
///
/// Example usage:
/// ```dart
/// final controller = EmailAuthController(
///   client: client,
///   onAuthenticated: () {
///     // Do something when the user is authenticated.
///     //
///     // NOTE: You should not navigate to the home screen here, otherwise
///     // the user will have to sign in again every time they open the app.
///   },
/// );
///
/// // Login
/// await controller.login();
///
/// // Start registration
/// await controller.startRegistration();
///
/// // Finish registration
/// await controller.finishRegistration();
///
/// // Listen to state changes
/// controller.addListener(() {
///   // UI will rebuild automatically
///   // Can use `controller.state` to access the current state.
/// });
/// ```
class EmailAuthController extends EmailFlowController<EmailFlowScreen> {
  /// Creates an email authentication controller.
  EmailAuthController({
    required super.client,
    super.startScreen = EmailFlowScreen.login,
    super.onAuthenticated,
    super.onError,
    super.emailValidation,
    super.passwordRequirements,
  });

  /// Default email validation function.
  ///
  /// This is the default validation function used by the controller. The
  /// [allowTopLevelDomains] and [allowEmailAliases] parameters can be used to
  /// customize the validation behavior.
  ///
  /// If [allowTopLevelDomains], users will be able to type only the top-level
  /// domain (e.g. email@example). This is useful when the email address is used
  /// for authentication, but a default domain is inferred by the app.
  ///
  /// If [allowEmailAliases] is `false`, users will not be able to use email
  /// aliases (e.g. email+alias@example.com), to keep a single user from
  /// creating multiple accounts. Aliases are allowed by default, since they
  /// are commonly used, e.g. to test an app with several accounts on one
  /// inbox.
  static void validateEmail(
    String email, {
    bool allowTopLevelDomains = false,
    bool allowEmailAliases = true,
  }) => EmailFlowController.validateEmail(
    email,
    allowTopLevelDomains: allowTopLevelDomains,
    allowEmailAliases: allowEmailAliases,
  );

  @override
  EmailFlowScreen get verifyPasswordResetScreen =>
      EmailFlowScreen.verifyPasswordReset;

  @override
  EmailFlowScreen get completePasswordResetScreen =>
      EmailFlowScreen.completePasswordReset;

  /// Navigates to a specific screen in the authentication flow.
  ///
  /// The [requestId] and [finishRequestToken] parameters can be used to
  /// navigate to account creation or password reset verification screens
  /// directly. This is useful when starting the flow from a deep link or push
  /// notification.
  @override
  void navigateTo(
    EmailFlowScreen screen, {
    UuidValue? requestId,
    String? finishRequestToken,
  }) {
    if (screen == EmailFlowScreen.startRegistration) {
      legalNoticeAcceptedNotifier.value = false;
    }
    if (screen == EmailFlowScreen.verifyRegistration ||
        screen == EmailFlowScreen.verifyPasswordReset) {
      verificationCodeController.clear();
    } else {
      this.requestId = null;
    }
    if (screen == EmailFlowScreen.completeRegistration ||
        screen == EmailFlowScreen.completePasswordReset) {
      passwordController.clear();
    } else {
      this.finishRequestToken = null;
    }

    if (requestId != null) this.requestId = requestId;
    if (finishRequestToken != null) {
      this.finishRequestToken = finishRequestToken;
    }

    showScreen(screen);
  }

  /// Whether it is possible to navigate back to the previous screen.
  ///
  /// Returns `true` if the current screen is not the start screen.
  bool get canNavigateBack => currentScreen != startScreen;

  /// Navigates back to the previous screen in the authentication flow.
  ///
  /// Returns `true` if the navigation was successful, and `false` if already on
  /// the start screen and there is no previous screen to navigate back to.
  bool navigateBack() {
    if (!canNavigateBack) return false;

    navigateTo(switch (currentScreen) {
      EmailFlowScreen.login => EmailFlowScreen.startRegistration,
      EmailFlowScreen.startRegistration => EmailFlowScreen.login,
      EmailFlowScreen.verifyRegistration => EmailFlowScreen.startRegistration,
      EmailFlowScreen.completeRegistration => EmailFlowScreen.startRegistration,
      EmailFlowScreen.requestPasswordReset => EmailFlowScreen.login,
      EmailFlowScreen.verifyPasswordReset =>
        EmailFlowScreen.requestPasswordReset,
      EmailFlowScreen.completePasswordReset =>
        EmailFlowScreen.requestPasswordReset,
    });

    return true;
  }

  /// Starts the registration process for a new user with email only.
  ///
  /// Validates the email and transitions to the set password screen.
  /// On failure, transitions to error state with the error message.
  Future<void> startRegistration() async {
    await runGuarded(() async {
      final email = emailController.text.trim();
      emailValidation.call(email);
      requestId = await emailEndpoint.startRegistration(email: email);
      return EmailFlowScreen.verifyRegistration;
    });
  }

  /// Submits the registration process and sends verification email.
  ///
  /// Sends a verification email to the email address from the text controller.
  /// On success, transitions to verification screen.
  /// On failure, transitions to error state with the error message.
  Future<void> verifyRegistrationCode() async {
    await runGuarded(() async {
      final registrationRequestId = requestId;
      if (registrationRequestId == null) {
        throw StateError('No registration request was found to verify.');
      }

      finishRequestToken = await emailEndpoint.verifyRegistrationCode(
        accountRequestId: registrationRequestId,
        verificationCode: verificationCodeController.text.trim(),
      );
      return EmailFlowScreen.completeRegistration;
    });
  }

  /// Completes the registration process with the verification code.
  ///
  /// On success, updates the session manager and calls [onAuthenticated].
  /// On failure, transitions to error state with the error message.
  Future<void> finishRegistration() async {
    await runGuarded(() async {
      final finishRequestToken = this.finishRequestToken;
      if (finishRequestToken == null) {
        throw StateError('No registration request was found to finish.');
      }

      final authSuccess = await emailEndpoint.finishRegistration(
        registrationToken: finishRequestToken,
        password: passwordController.text,
      );

      await client.auth.updateSignedInUser(authSuccess);
      return null;
    });
  }

  /// Resends the verification code based on the current screen.
  ///
  /// Define the resend code according to the current screen (registration or
  /// password reset verification). Throws an error if the current screen is not
  /// a verification screen.
  @override
  Future<void> resendVerificationCode() async {
    await switch (currentScreen) {
      EmailFlowScreen.verifyRegistration => startRegistration(),
      EmailFlowScreen.verifyPasswordReset => startPasswordReset(),
      _ => throw StateError('Cannot resend code on screen: $currentScreen'),
    };
  }
}
