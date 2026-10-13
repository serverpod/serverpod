import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/widgets.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../common/widgets/password_requirements/requirements.dart';
import 'email_auth_exceptions.dart';

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

  /// Start passwordless login screen - user enters email to receive a
  /// verification code to sign in with, instead of a password.
  passwordlessStart,

  /// Verify passwordless login screen - user enters the verification code
  /// received by email to sign in.
  passwordlessVerify,
}

/// Controller for managing email-based authentication flows.
///
/// This controller handles all the business logic for email authentication,
/// including login, registration, email verification, and passwordless login
/// with a verification code sent by email. It can be used with any UI
/// implementation.
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
/// // Passwordless login
/// await controller.startPasswordlessLogin();
/// await controller.finishPasswordlessLogin();
///
/// // Listen to state changes
/// controller.addListener(() {
///   // UI will rebuild automatically
///   // Can use `controller.state` to access the current state.
/// });
/// ```
class EmailAuthController extends ChangeNotifier {
  /// The Serverpod client instance.
  final ServerpodClientShared client;

  /// The screen to display when starting the flow.
  final EmailFlowScreen startScreen;

  /// Callback when authentication is successful.
  final VoidCallback? onAuthenticated;

  /// Callback when an error occurs during authentication.
  ///
  /// The [error] parameter is an exception that should be shown to the user.
  /// Exceptions that should not be shown to the user are shown in the debug
  /// log, but not passed to the callback.
  final Function(Object error)? onError;

  /// The validation function to use for email validation.
  ///
  /// This function should throw an [InvalidEmailException] if the email is
  /// invalid, so the error can be displayed to the user.
  final void Function(String email) emailValidation;

  /// Optional list of password requirements to display to the user.
  ///
  /// If provided, these requirements will be shown in password forms to guide
  /// users on password creation. If null, will use a recommended safe default
  /// defined at [PasswordRequirement.defaultRequirements].
  final List<PasswordRequirement> passwordRequirements;

  /// Text controller for email input.
  late final emailController = TextEditingController();

  /// Text controller for password input.
  late final passwordController = TextEditingController();

  /// Text controller for verification code input.
  late final verificationCodeController = TextEditingController();

  /// Notifier for terms and conditions / privacy policy acceptance checkbox.
  late final legalNoticeAcceptedNotifier = ValueNotifier<bool>(false);

  /// Creates an email authentication controller.
  EmailAuthController({
    required this.client,
    this.startScreen = EmailFlowScreen.login,
    this.onAuthenticated,
    this.onError,
    void Function(String email)? emailValidation,
    List<PasswordRequirement>? passwordRequirements,
  }) : emailValidation = emailValidation ?? validateEmail,
       passwordRequirements =
           passwordRequirements ?? PasswordRequirement.defaultRequirements {
    _currentScreen = startScreen;

    emailController.addListener(() {
      if (_disposed || state == EmailAuthState.loading) return;
      if (_resendCooldownActive) {
        _resendCooldownActive = false;
        _setState(_state);
      }
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (emailController.text.isEmpty) {
          _setState(EmailAuthState.idle);
        } else {
          try {
            this.emailValidation.call(emailController.text.trim());
            _setState(EmailAuthState.idle);
          } catch (e) {
            _error = e;
            _setState(EmailAuthState.error);
          }
        }
      });
    });

    passwordController.addListener(() {
      if (passwordController.text.isEmpty ||
          passwordController.text != _lastPassword) {
        _setState(EmailAuthState.idle);
      }
      _lastPassword = passwordController.text;
    });

    legalNoticeAcceptedNotifier.addListener(notifyListeners);
  }

  /// The last typed password for comparison of changed value.
  String _lastPassword = '';

  /// Debounce timer for email validation.
  Timer? _debounce;

  /// Timer to enable the action button again after a network error.
  Timer? _networkErrorTimer;

  bool _disposed = false;

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
  /// aliases (e.g. email+alias@example.com). This is a good practice to avoid
  /// a single user creating multiple accounts.
  static void validateEmail(
    String email, {
    bool allowTopLevelDomains = false,
    bool allowEmailAliases = false,
  }) {
    if (!EmailValidator.validate(email, allowTopLevelDomains)) {
      throw const InvalidEmailException('Invalid email address');
    }
    if (!allowEmailAliases && email.contains('+')) {
      throw const InvalidEmailException('Email aliases are not allowed');
    }
  }

  late EmailFlowScreen _currentScreen;

  /// Stores the request ID for the current flow, if any.
  UuidValue? _requestId;

  /// Stores the finish account registration or password reset request token
  /// after verification code is verified.
  String? _finishRequestToken;

  /// The ID of the latest passwordless login request that the server created
  /// for this controller, together with the normalized email address that it
  /// was created for ([_loginRequestEmail], `null` when it is not known).
  ///
  /// It is only replaced when the server creates a new request, so that a
  /// failing request, for example within the resend cooldown of the server,
  /// never discards the ID of the code that the user has been sent.
  UuidValue? _loginRequestId;
  String? _loginRequestEmail;

  bool _resendCooldownActive = false;

  EmailAuthState _state = EmailAuthState.idle;

  /// The current screen in the authentication flow.
  EmailFlowScreen get currentScreen => _currentScreen;

  /// The current state of the authentication flow.
  EmailAuthState get state => _state;

  /// Navigates to a specific screen in the authentication flow.
  ///
  /// The [requestId] and [finishRequestToken] parameters can be used to
  /// navigate to account creation, password reset or passwordless login
  /// verification screens directly. This is useful when starting the flow from
  /// a deep link or push notification.
  ///
  /// The latest passwordless login request is remembered together with its
  /// email address, so that requesting a code for the same email address
  /// again, while the server still refuses to send a new one, returns to the
  /// [EmailFlowScreen.passwordlessVerify] screen.
  void navigateTo(
    EmailFlowScreen screen, {
    UuidValue? requestId,
    String? finishRequestToken,
  }) {
    _resendCooldownActive = false;
    _applyScreen(
      screen,
      requestId: requestId,
      finishRequestToken: finishRequestToken,
    );
    _setState(EmailAuthState.idle);
  }

  /// Updates the screen and the data related to it, without notifying.
  void _applyScreen(
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
      _requestId = null;
    }
    if (screen == EmailFlowScreen.passwordlessStart ||
        screen == EmailFlowScreen.passwordlessVerify) {
      verificationCodeController.clear();
    }
    if (screen == EmailFlowScreen.completeRegistration ||
        screen == EmailFlowScreen.completePasswordReset) {
      passwordController.clear();
    } else {
      _finishRequestToken = null;
    }

    if (requestId != null) {
      if (screen == EmailFlowScreen.passwordlessVerify) {
        _loginRequestId = requestId;
        _loginRequestEmail = null;
      } else {
        _requestId = requestId;
      }
    }
    if (finishRequestToken != null) _finishRequestToken = finishRequestToken;

    _currentScreen = screen;
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
      EmailFlowScreen.passwordlessStart => EmailFlowScreen.login,
      EmailFlowScreen.passwordlessVerify => EmailFlowScreen.passwordlessStart,
    });

    return true;
  }

  /// Clears the text controllers and previously set request IDs, including
  /// the remembered passwordless login request. Pass [notify] as `false` if
  /// calling before [navigateTo] to avoid notifying listeners twice.
  void resetState({bool notify = true}) {
    emailController.clear();
    passwordController.clear();
    verificationCodeController.clear();
    _requestId = null;
    _finishRequestToken = null;
    _forgetLoginRequest();
    _resendCooldownActive = false;
    _setState(_state, notify: notify);
  }

  /// Whether the controller is currently processing a request.
  bool get isLoading => _state == EmailAuthState.loading;

  /// Whether the user is authenticated.
  bool get isAuthenticated => client.auth.isAuthenticated;

  /// The current error message, if any.
  String? get errorMessage => _error?.toString();

  /// The current error, if any.
  Object? get error => _state == EmailAuthState.error ? _error : null;
  Object? _error;

  /// Whether the server rejected the latest request for a passwordless login
  /// code because a code was sent to the email address a short time ago.
  ///
  /// This is not an error: the code that was sent earlier can still be used, so
  /// the UI should tell the user to use it, or to wait before requesting a new
  /// one. It is reset by the next action, by navigating, and when the email
  /// address changes. [onError] is not called for it.
  bool get resendCooldownActive => _resendCooldownActive;

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    _networkErrorTimer?.cancel();
    legalNoticeAcceptedNotifier.removeListener(notifyListeners);
    emailController.dispose();
    passwordController.dispose();
    verificationCodeController.dispose();
    legalNoticeAcceptedNotifier.dispose();
    super.dispose();
  }

  /// Gets the email authentication endpoint from the client.
  EndpointEmailIdpBase get _emailEndpoint {
    try {
      return client.getEndpointOfType<EndpointEmailIdpBase>();
    } on ServerpodClientEndpointNotFound catch (_) {
      throw StateError(
        'No email authentication endpoint found. Make sure you have extended '
        '"EndpointEmailIdpBase" in your server and exposed it.',
      );
    }
  }

  /// Logs in a user with email and password from the text controllers.
  ///
  /// On success, updates the session manager and calls [onAuthenticated].
  /// On failure, transitions to error state with the error message.
  Future<void> login() async {
    await _guarded(EmailAuthState.authenticated, null, () async {
      final authSuccess = await _emailEndpoint.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      await client.auth.updateSignedInUser(authSuccess);
    });
  }

  /// Starts the registration process for a new user with email only.
  ///
  /// Validates the email and transitions to the set password screen.
  /// On failure, transitions to error state with the error message.
  Future<void> startRegistration() async {
    await _guarded(null, EmailFlowScreen.verifyRegistration, () async {
      final email = emailController.text.trim();
      emailValidation.call(email);
      _requestId = await _emailEndpoint.startRegistration(email: email);
    });
  }

  /// Submits the registration process and sends verification email.
  ///
  /// Sends a verification email to the email address from the text controller.
  /// On success, transitions to verification screen.
  /// On failure, transitions to error state with the error message.
  Future<void> verifyRegistrationCode() async {
    await _guarded(null, EmailFlowScreen.completeRegistration, () async {
      final registrationRequestId = _requestId;
      if (registrationRequestId == null) {
        throw StateError('No registration request was found to verify.');
      }

      _finishRequestToken = await _emailEndpoint.verifyRegistrationCode(
        accountRequestId: registrationRequestId,
        verificationCode: verificationCodeController.text.trim(),
      );
    });
  }

  /// Completes the registration process with the verification code.
  ///
  /// On success, updates the session manager and calls [onAuthenticated].
  /// On failure, transitions to error state with the error message.
  Future<void> finishRegistration() async {
    await _guarded(EmailAuthState.authenticated, null, () async {
      final finishRequestToken = _finishRequestToken;
      if (finishRequestToken == null) {
        throw StateError('No registration request was found to finish.');
      }

      final authSuccess = await _emailEndpoint.finishRegistration(
        registrationToken: finishRequestToken,
        password: passwordController.text,
      );

      await client.auth.updateSignedInUser(authSuccess);
    });
  }

  /// Starts the password reset process.
  ///
  /// Sends a password reset email to the provided email address.
  /// On success, transitions to password reset pending state.
  /// On failure, transitions to error state with the error message.
  Future<void> startPasswordReset() async {
    await _guarded(null, EmailFlowScreen.verifyPasswordReset, () async {
      final email = emailController.text.trim();
      _requestId = await _emailEndpoint.startPasswordReset(email: email);
    });
  }

  /// Verifies the password reset verification code.
  ///
  /// On success, stores the finish password reset token to be used with
  /// [finishPasswordReset]. On failure, transitions to error state with the
  /// error message.
  Future<void> verifyPasswordResetCode() async {
    await _guarded(null, EmailFlowScreen.completePasswordReset, () async {
      final passwordResetRequestId = _requestId;
      if (passwordResetRequestId == null) {
        throw StateError('No password reset request was found to verify.');
      }

      _finishRequestToken = await _emailEndpoint.verifyPasswordResetCode(
        passwordResetRequestId: passwordResetRequestId,
        verificationCode: verificationCodeController.text.trim(),
      );
    });
  }

  /// Completes the password reset process with a new password.
  ///
  /// Use the [passwordController] to provide the new password. On success,
  /// updates the session manager and calls [onAuthenticated]. On failure,
  /// transitions to error state with the error message.
  Future<void> finishPasswordReset() async {
    await _guarded(EmailAuthState.authenticated, null, () async {
      final finishRequestToken = _finishRequestToken;
      if (finishRequestToken == null) {
        throw StateError('No password reset request was found to finish.');
      }

      await _emailEndpoint.finishPasswordReset(
        finishPasswordResetToken: finishRequestToken,
        newPassword: passwordController.text,
      );

      final authSuccess = await _emailEndpoint.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      await client.auth.updateSignedInUser(authSuccess);
    });
  }

  /// Requests a passwordless login code for the email address in
  /// [emailController].
  ///
  /// On success, navigates to the [EmailFlowScreen.passwordlessVerify] screen.
  /// The server responds the same way whether the email address has an account
  /// or not, so this does not reveal if an account exists. An account is
  /// created when the code for a new email address is verified, unless the
  /// server disallows sign-up.
  ///
  /// The server does not send a new code until its resend cooldown has elapsed.
  /// Within it, the call fails, and the ID of the code that was sent before is
  /// kept. If that code was requested for the same email address by this
  /// controller, the verification screen is shown, otherwise the current screen
  /// stays. In both cases [resendCooldownActive] is `true`, and this is not
  /// reported as an error.
  Future<void> startPasswordlessLogin() async {
    var cooldown = false;

    await _guarded(
      null,
      EmailFlowScreen.passwordlessVerify,
      () async {
        final email = emailController.text.trim();
        emailValidation.call(email);

        final UuidValue loginRequestId;
        try {
          loginRequestId = await _emailEndpoint.startPasswordlessLogin(
            email: email,
          );
        } on EmailPasswordlessLoginException catch (e) {
          if (e.reason !=
              EmailPasswordlessLoginExceptionReason.resendCooldown) {
            rethrow;
          }

          cooldown = true;
          return;
        }

        _loginRequestId = loginRequestId;
        _loginRequestEmail = _normalizeEmail(email);
      },
      onSuccess: () {
        _resendCooldownActive = cooldown;
        if (!cooldown) return EmailFlowScreen.passwordlessVerify;

        final hasRequestForEmail =
            _loginRequestId != null &&
            _loginRequestEmail == _normalizeEmail(emailController.text);
        return hasRequestForEmail
            ? EmailFlowScreen.passwordlessVerify
            : _currentScreen;
      },
    );
  }

  /// Verifies the passwordless login code in [verificationCodeController] and
  /// signs the user in.
  ///
  /// On success, updates the session manager and calls [onAuthenticated].
  /// On failure, transitions to error state with the error message.
  Future<void> finishPasswordlessLogin() async {
    await _guarded(EmailAuthState.authenticated, null, () async {
      final loginRequestId = _loginRequestId;
      if (loginRequestId == null ||
          _currentScreen != EmailFlowScreen.passwordlessVerify) {
        throw StateError('No passwordless login request was found to finish.');
      }

      final AuthSuccess authSuccess;
      try {
        authSuccess = await _emailEndpoint.finishPasswordlessLogin(
          loginRequestId: loginRequestId,
          verificationCode: verificationCodeController.text.trim(),
        );
      } on EmailPasswordlessLoginException catch (e) {
        if (e.reason == EmailPasswordlessLoginExceptionReason.tooManyAttempts ||
            e.reason == EmailPasswordlessLoginExceptionReason.expired) {
          _forgetLoginRequest();
        }
        rethrow;
      }

      await client.auth.updateSignedInUser(authSuccess);
      _forgetLoginRequest();
    });
  }

  void _forgetLoginRequest() {
    _loginRequestId = null;
    _loginRequestEmail = null;
  }

  static String _normalizeEmail(String email) => email.trim().toLowerCase();

  /// Resends the verification code based on the current screen.
  ///
  /// Define the resend code according to the current screen (registration,
  /// password reset or passwordless login verification). Throws an error if the
  /// current screen is not a verification screen.
  ///
  /// For the passwordless login, the server does not send a new code until its
  /// resend cooldown has elapsed, see [startPasswordlessLogin] and
  /// [resendCooldownActive]. The code entered so far is kept.
  Future<void> resendVerificationCode() async {
    await switch (_currentScreen) {
      EmailFlowScreen.verifyRegistration => startRegistration(),
      EmailFlowScreen.verifyPasswordReset => startPasswordReset(),
      EmailFlowScreen.passwordlessVerify => startPasswordlessLogin(),
      _ => throw StateError('Cannot resend code on screen: $_currentScreen'),
    };
  }

  /// Sets the current state of the authentication flow and notifies listeners.
  void _setState(EmailAuthState newState, {bool notify = true}) {
    if (_disposed) return;
    if (newState != EmailAuthState.error) _error = null;
    _state = newState;
    if (notify) notifyListeners();
  }

  /// Executes the given action and transitions to the target state on success.
  /// If the target state is authenticated, calls [onAuthenticated] callback.
  /// In case of an error, transitions to error state and calls [onError] only
  /// for exceptions that should be shown to the user.
  ///
  /// If [onSuccess] is provided, the screen it returns is used instead of
  /// [targetScreen]. Calls made while another action is in progress, or after
  /// the controller is disposed, are ignored.
  Future<void> _guarded(
    EmailAuthState? targetState,
    EmailFlowScreen? targetScreen,
    Future<void> Function() action, {
    EmailFlowScreen Function()? onSuccess,
  }) async {
    if ((targetState == null) && (targetScreen == null)) {
      throw ArgumentError('Provide either targetState or targetScreen.');
    }
    if (_disposed || isLoading) return;

    _debounce?.cancel();
    _networkErrorTimer?.cancel();
    _resendCooldownActive = false;
    _setState(EmailAuthState.loading);
    try {
      await action();
      final screen = onSuccess?.call() ?? targetScreen;
      if (screen != null) {
        // Resending the passwordless code keeps the code entered so far.
        if (screen != _currentScreen ||
            screen != EmailFlowScreen.passwordlessVerify) {
          _applyScreen(screen);
        }
        _setState(EmailAuthState.idle);
      } else if (targetState != null) {
        _setState(targetState);
        if (targetState == EmailAuthState.authenticated) {
          onAuthenticated?.call();
        }
      }
    } catch (e) {
      if (_disposed) return;

      _error = e;
      _setState(EmailAuthState.error);
      debugPrint('[EmailAuthController] $_currentScreen -> $targetState: $e');

      // If we have a network error, start a timer to enable the action button
      // again after a short delay.
      if (e is ServerpodClientNetworkException) {
        _networkErrorTimer = Timer(const Duration(seconds: 1), () {
          _setState(EmailAuthState.idle);
        });
      }

      final userFriendlyError = convertToUserFacingException(e);
      if (userFriendlyError != null) {
        onError?.call(userFriendlyError);
      }
    }
  }
}

/// Represents the state of the email authentication flow.
enum EmailAuthState {
  /// Initial idle state of each screen.
  idle,

  /// Loading state while processing any request.
  loading,

  /// A request ended with error. The error can be retrieved from the controller.
  error,

  /// Authentication was successful, either by login, registration, or password reset.
  authenticated,
}

/// Exception thrown when an email is invalid.
class InvalidEmailException implements Exception {
  /// The reason why the email is invalid. This must be a human-readable message
  /// that can be displayed to the user.
  final String reason;

  /// Creates a new [InvalidEmailException].
  const InvalidEmailException(this.reason);

  @override
  String toString() => reason;
}
