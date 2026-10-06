import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../common/email_code_form_controller.dart';
import '../email/email_auth_controller.dart'
    show EmailAuthController, EmailAuthState;
import 'email_passwordless_auth_exceptions.dart';

/// Represents the screens in the passwordless email authentication flow.
enum EmailPasswordlessFlowScreen {
  /// The user enters an email address to receive a verification code.
  start,

  /// The user enters the verification code received by email.
  verify,
}

/// Controller for managing passwordless email authentication.
///
/// With passwordless email authentication, the user enters an email address,
/// receives a verification code, and enters it to sign in. A new account is
/// created when the email address is new, unless the server disallows sign-up.
///
/// The controller handles the logic of the flow, and can be used with any UI
/// implementation. Pair it with the `EmailPasswordlessSignInWidget` for the
/// ready-made UI.
///
/// Example usage:
/// ```dart
/// final controller = EmailPasswordlessAuthController(
///   client: client,
///   onAuthenticated: () {
///     // Do something when the user is authenticated.
///     //
///     // NOTE: You should not navigate to the home screen here, otherwise
///     // the user will have to sign in again every time they open the app.
///   },
/// );
///
/// controller.emailController.text = 'user@example.com';
/// await controller.startLogin();
///
/// controller.verificationCodeController.text = '123456';
/// await controller.finishLogin();
/// ```
///
/// See also: https://github.com/serverpod/serverpod/issues/2100.
class EmailPasswordlessAuthController extends ChangeNotifier
    implements EmailCodeFormController {
  /// The Serverpod client instance.
  final ServerpodClientShared client;

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
  /// This function should throw an `InvalidEmailException` if the email is
  /// invalid, so the error can be displayed to the user.
  final void Function(String email) emailValidation;

  @override
  late final emailController = TextEditingController();

  @override
  late final verificationCodeController = TextEditingController();

  /// Notifier for the terms and conditions / privacy policy acceptance
  /// checkbox, shown on the email entry screen if the widget is configured with
  /// the callbacks to display them.
  late final legalNoticeAcceptedNotifier = ValueNotifier<bool>(false);

  /// Creates a passwordless email authentication controller.
  EmailPasswordlessAuthController({
    required this.client,
    this.onAuthenticated,
    this.onError,
    void Function(String email)? emailValidation,
  }) : emailValidation = emailValidation ?? EmailAuthController.validateEmail {
    emailController.addListener(_onEmailChanged);
    legalNoticeAcceptedNotifier.addListener(notifyListeners);
  }

  Timer? _debounce;
  Timer? _networkErrorTimer;
  bool _disposed = false;

  void _onEmailChanged() {
    if (_disposed || state == EmailAuthState.loading) return;
    if (_resendCooldownActive) {
      _resendCooldownActive = false;
      _setState(_state);
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (emailController.text.isEmpty) {
        _setState(EmailAuthState.idle);
        return;
      }
      try {
        emailValidation(emailController.text.trim());
        _setState(EmailAuthState.idle);
      } catch (e) {
        _error = e;
        _setState(EmailAuthState.error);
      }
    });
  }

  EmailPasswordlessFlowScreen _currentScreen =
      EmailPasswordlessFlowScreen.start;
  EmailAuthState _state = EmailAuthState.idle;
  Object? _error;

  /// The ID of the latest login request that the server created for this
  /// controller, together with the normalized email address that it was created
  /// for ([_loginRequestEmail], `null` when it is not known).
  ///
  /// It is only replaced when the server creates a new request, so that a
  /// failing request, for example within the resend cooldown of the server,
  /// never discards the ID of the code that the user has been sent.
  UuidValue? _loginRequestId;
  String? _loginRequestEmail;

  bool _resendCooldownActive = false;

  /// The current screen in the authentication flow.
  EmailPasswordlessFlowScreen get currentScreen => _currentScreen;

  /// The current state of the authentication flow.
  EmailAuthState get state => _state;

  @override
  bool get isLoading => _state == EmailAuthState.loading;

  /// Whether the user is authenticated.
  bool get isAuthenticated => client.auth.isAuthenticated;

  @override
  Object? get error => _state == EmailAuthState.error ? _error : null;

  @override
  String? get errorMessage => _error?.toString();

  /// Whether the server rejected the latest request for a code because a code
  /// was sent to the email address a short time ago.
  ///
  /// This is not an error: the code that was sent earlier can still be used, so
  /// the UI should tell the user to use it, or to wait before requesting a new
  /// one. It is reset by the next action and when the email address changes.
  /// [onError] is not called for it.
  bool get resendCooldownActive => _resendCooldownActive;

  /// Navigates to the email entry screen, to request a code for another email
  /// address.
  ///
  /// The latest login request is remembered together with its email address, so
  /// that requesting a code for the same email address again, while the server
  /// still refuses to send a new one, returns to the verification screen.
  void navigateToStart() {
    verificationCodeController.clear();
    _resendCooldownActive = false;
    _currentScreen = EmailPasswordlessFlowScreen.start;
    _setState(EmailAuthState.idle);
  }

  /// Navigates to the verification screen for an existing login request, for
  /// example when starting the flow from a deep link.
  void navigateToVerify({required UuidValue loginRequestId}) {
    verificationCodeController.clear();
    _loginRequestId = loginRequestId;
    _loginRequestEmail = null;
    _resendCooldownActive = false;
    _currentScreen = EmailPasswordlessFlowScreen.verify;
    _setState(EmailAuthState.idle);
  }

  /// Clears the text controllers and the remembered login request.
  void resetState({bool notify = true}) {
    emailController.clear();
    verificationCodeController.clear();
    _forgetLoginRequest();
    _resendCooldownActive = false;
    _setState(_state, notify: notify);
  }

  void _forgetLoginRequest() {
    _loginRequestId = null;
    _loginRequestEmail = null;
  }

  static String _normalizeEmail(String email) => email.trim().toLowerCase();

  EndpointEmailPasswordlessIdpBase get _endpoint {
    try {
      return client.getEndpointOfType<EndpointEmailPasswordlessIdpBase>();
    } on ServerpodClientEndpointNotFound catch (_) {
      throw StateError(
        'No passwordless email authentication endpoint found. Make sure you '
        'have extended "EmailPasswordlessIdpBaseEndpoint" in your server and '
        'exposed it.',
      );
    }
  }

  /// Requests a verification code for the email address in [emailController].
  ///
  /// On success, navigates to the verification screen. The server responds the
  /// same way whether the email address has an account or not, so this does not
  /// reveal if an account exists.
  ///
  /// The server does not send a new code until its resend cooldown has elapsed.
  /// Within it, the call fails, and the ID of the code that was sent before is
  /// kept. If that code was requested for the same email address by this
  /// controller, the verification screen is shown, otherwise the current screen
  /// stays. In both cases [resendCooldownActive] is `true`, and this is not
  /// reported as an error.
  ///
  /// Calls made while another action is in progress are ignored.
  Future<void> startLogin() => _requestCode(EmailPasswordlessFlowScreen.verify);

  /// Verifies the code in [verificationCodeController] and signs the user in.
  ///
  /// On success, updates the session manager and calls [onAuthenticated]. Calls
  /// made while another action is in progress are ignored.
  Future<void> finishLogin() async {
    await _guarded(
      targetState: EmailAuthState.authenticated,
      action: () async {
        final loginRequestId = _loginRequestId;
        if (loginRequestId == null ||
            _currentScreen != EmailPasswordlessFlowScreen.verify) {
          throw StateError('No login request was found to finish.');
        }

        final AuthSuccess authSuccess;
        try {
          authSuccess = await _endpoint.finishLogin(
            loginRequestId: loginRequestId,
            verificationCode: verificationCodeController.text.trim(),
          );
        } on EmailPasswordlessLoginException catch (e) {
          if (e.reason ==
                  EmailPasswordlessLoginExceptionReason.tooManyAttempts ||
              e.reason == EmailPasswordlessLoginExceptionReason.expired) {
            _forgetLoginRequest();
          }
          rethrow;
        }

        await client.auth.updateSignedInUser(authSuccess);
        _forgetLoginRequest();
      },
    );
  }

  /// Requests a new verification code for the same email address.
  ///
  /// The server does not send a new code until its resend cooldown has elapsed,
  /// and then the previous code is replaced. Before that, the request fails and
  /// the code that was sent keeps working, see [startLogin] and
  /// [resendCooldownActive]. `ResendCodeButton` avoids this with its countdown,
  /// which should be at least as long as the cooldown of the server.
  @override
  Future<void> resendVerificationCode() async {
    if (_currentScreen != EmailPasswordlessFlowScreen.verify) {
      throw StateError('Cannot resend code on screen: $_currentScreen');
    }
    await _requestCode(EmailPasswordlessFlowScreen.verify);
  }

  Future<void> _requestCode(EmailPasswordlessFlowScreen targetScreen) async {
    var cooldown = false;

    await _guarded(
      targetScreen: targetScreen,
      action: () async {
        final email = emailController.text.trim();
        emailValidation(email);

        final UuidValue loginRequestId;
        try {
          loginRequestId = await _endpoint.startLogin(email: email);
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
        if (!cooldown) return targetScreen;

        final hasRequestForEmail =
            _loginRequestId != null &&
            _loginRequestEmail == _normalizeEmail(emailController.text);
        return hasRequestForEmail ? targetScreen : _currentScreen;
      },
    );
  }

  void _setState(EmailAuthState newState, {bool notify = true}) {
    if (_disposed) return;
    if (newState != EmailAuthState.error) _error = null;
    _state = newState;
    if (notify) notifyListeners();
  }

  Future<void> _guarded({
    EmailAuthState? targetState,
    EmailPasswordlessFlowScreen? targetScreen,
    EmailPasswordlessFlowScreen Function()? onSuccess,
    required Future<void> Function() action,
  }) async {
    if (_disposed || isLoading) return;

    _debounce?.cancel();
    _networkErrorTimer?.cancel();
    _resendCooldownActive = false;
    _setState(EmailAuthState.loading);
    try {
      await action();
      final screen = onSuccess?.call() ?? targetScreen;
      if (screen != null) {
        if (screen != _currentScreen) {
          verificationCodeController.clear();
        }
        _currentScreen = screen;
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
      debugPrint('[EmailPasswordlessAuthController] $_currentScreen: $e');

      if (e is ServerpodClientNetworkException) {
        _networkErrorTimer = Timer(const Duration(seconds: 1), () {
          _setState(EmailAuthState.idle);
        });
      }

      final userFriendlyError = convertPasswordlessToUserFacingException(e);
      if (userFriendlyError != null) {
        onError?.call(userFriendlyError);
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    _networkErrorTimer?.cancel();
    emailController.removeListener(_onEmailChanged);
    legalNoticeAcceptedNotifier.removeListener(notifyListeners);
    emailController.dispose();
    verificationCodeController.dispose();
    legalNoticeAcceptedNotifier.dispose();
    super.dispose();
  }
}
