import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/widgets.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../common/widgets/password_requirements/requirements.dart';
import 'email_auth_exceptions.dart';

/// Base class for the controllers of the email authentication flows, holding
/// the state, text inputs and requests shared by all of them.
///
/// The screens of a flow are values of [S]. Subclasses define the navigation
/// between them, and which screens the shared requests lead to.
abstract class EmailFlowController<S extends Enum> extends ChangeNotifier {
  /// The Serverpod client instance.
  final ServerpodClientShared client;

  /// The screen to display when starting the flow.
  final S startScreen;

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

  /// Creates the controller of an email authentication flow.
  EmailFlowController({
    required this.client,
    required this.startScreen,
    this.onAuthenticated,
    this.onError,
    void Function(String email)? emailValidation,
    List<PasswordRequirement>? passwordRequirements,
  }) : emailValidation = emailValidation ?? validateEmail,
       passwordRequirements =
           passwordRequirements ?? PasswordRequirement.defaultRequirements {
    _currentScreen = startScreen;

    emailController.addListener(() {
      if (state == EmailAuthState.loading) return;
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (emailController.text.isEmpty) {
          setState(EmailAuthState.idle);
        } else {
          try {
            this.emailValidation.call(emailController.text.trim());
            setState(EmailAuthState.idle);
          } catch (e) {
            _error = e;
            setState(EmailAuthState.error);
          }
        }
      });
    });

    passwordController.addListener(() {
      if (passwordController.text.isEmpty ||
          passwordController.text != _lastPassword) {
        setState(EmailAuthState.idle);
      }
      _lastPassword = passwordController.text;
    });

    legalNoticeAcceptedNotifier.addListener(notifyListeners);
  }

  String _lastPassword = '';

  Timer? _debounce;

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
  }) {
    if (!EmailValidator.validate(email, allowTopLevelDomains)) {
      throw const InvalidEmailException('Invalid email address');
    }
    if (!allowEmailAliases && email.contains('+')) {
      throw const InvalidEmailException('Email aliases are not allowed');
    }
  }

  late S _currentScreen;

  EmailAuthState _state = EmailAuthState.idle;

  /// The request ID of the current flow, if any.
  @protected
  UuidValue? requestId;

  /// The token to finish the current request, set after its verification code
  /// is verified.
  @protected
  String? finishRequestToken;

  /// The current screen in the authentication flow.
  S get currentScreen => _currentScreen;

  /// The current state of the authentication flow.
  EmailAuthState get state => _state;

  /// The screen showing the verification of the password reset code.
  @protected
  S get verifyPasswordResetScreen;

  /// The screen for setting the new password of a password reset.
  @protected
  S get completePasswordResetScreen;

  /// Navigates to a specific screen in the authentication flow.
  ///
  /// The [requestId] and [finishRequestToken] parameters can be used to
  /// navigate to verification or completion screens directly. This is useful
  /// when starting the flow from a deep link or push notification.
  void navigateTo(
    S screen, {
    UuidValue? requestId,
    String? finishRequestToken,
  });

  /// Shows [screen] and resets the state to idle.
  ///
  /// To be called by [navigateTo] after preparing the inputs for the screen.
  @protected
  void showScreen(S screen) {
    _currentScreen = screen;
    setState(EmailAuthState.idle);
  }

  /// Clears the text controllers and previously set request ID, if not on
  /// a verification code screen. Pass [notify] as `false` if calling before
  /// [navigateTo] to avoid notifying listeners twice.
  void resetState({bool notify = true}) {
    emailController.clear();
    passwordController.clear();
    verificationCodeController.clear();
    requestId = null;
    finishRequestToken = null;
    setState(_state, notify: notify);
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

  @override
  void dispose() {
    _debounce?.cancel();
    emailController.dispose();
    passwordController.dispose();
    verificationCodeController.dispose();
    super.dispose();
  }

  /// The email authentication endpoint of the [client].
  @protected
  EndpointEmailIdpBase get emailEndpoint {
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
    await runGuarded(() async {
      final authSuccess = await emailEndpoint.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      await client.auth.updateSignedInUser(authSuccess);
      return null;
    });
  }

  /// Starts the password reset process.
  ///
  /// Sends a password reset email to the provided email address.
  /// On success, transitions to the [verifyPasswordResetScreen].
  /// On failure, transitions to error state with the error message.
  Future<void> startPasswordReset() async {
    await runGuarded(() async {
      final email = emailController.text.trim();
      requestId = await emailEndpoint.startPasswordReset(email: email);
      return verifyPasswordResetScreen;
    });
  }

  /// Verifies the password reset verification code.
  ///
  /// On success, stores the finish password reset token to be used with
  /// [finishPasswordReset]. On failure, transitions to error state with the
  /// error message.
  Future<void> verifyPasswordResetCode() async {
    await runGuarded(() async {
      final passwordResetRequestId = requestId;
      if (passwordResetRequestId == null) {
        throw StateError('No password reset request was found to verify.');
      }

      finishRequestToken = await emailEndpoint.verifyPasswordResetCode(
        passwordResetRequestId: passwordResetRequestId,
        verificationCode: verificationCodeController.text.trim(),
      );
      return completePasswordResetScreen;
    });
  }

  /// Completes the password reset process with a new password.
  ///
  /// Use the [passwordController] to provide the new password. On success,
  /// updates the session manager and calls [onAuthenticated]. On failure,
  /// transitions to error state with the error message.
  Future<void> finishPasswordReset() async {
    await runGuarded(() async {
      final finishRequestToken = this.finishRequestToken;
      if (finishRequestToken == null) {
        throw StateError('No password reset request was found to finish.');
      }

      await emailEndpoint.finishPasswordReset(
        finishPasswordResetToken: finishRequestToken,
        newPassword: passwordController.text,
      );

      final authSuccess = await emailEndpoint.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      await client.auth.updateSignedInUser(authSuccess);
      return null;
    });
  }

  /// Resends the verification code based on the current screen.
  ///
  /// Throws an error if the current screen is not a verification screen.
  Future<void> resendVerificationCode();

  /// Sets the current state of the authentication flow and notifies listeners.
  @protected
  void setState(EmailAuthState newState, {bool notify = true}) {
    if (newState != EmailAuthState.error) _error = null;
    _state = newState;
    if (notify) notifyListeners();
  }

  /// Executes the given action and navigates to the screen it returns, or
  /// transitions to the authenticated state and calls [onAuthenticated] if it
  /// returns `null`.
  ///
  /// In case of an error, transitions to error state and calls [onError] only
  /// for exceptions that should be shown to the user.
  @protected
  Future<void> runGuarded(Future<S?> Function() action) async {
    setState(EmailAuthState.loading);
    try {
      final targetScreen = await action();
      if (targetScreen != null) {
        navigateTo(targetScreen);
      } else {
        setState(EmailAuthState.authenticated);
        onAuthenticated?.call();
      }
    } catch (e) {
      _error = e;
      setState(EmailAuthState.error);
      debugPrint('[$runtimeType] ${_currentScreen.name}: $e');

      // If we have a network error, start a timer to enable the action button
      // again after a short delay.
      if (e is ServerpodClientNetworkException) {
        Timer(const Duration(seconds: 1), () {
          setState(EmailAuthState.idle);
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
