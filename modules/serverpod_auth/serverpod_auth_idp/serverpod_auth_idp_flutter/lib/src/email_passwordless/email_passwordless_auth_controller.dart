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

  void _onEmailChanged() {
    if (state == EmailAuthState.loading) return;
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

  /// The ID of the login request of the code the user is asked to enter.
  UuidValue? _loginRequestId;

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

  /// Navigates to the email entry screen, to request a code for another email
  /// address. The pending login request is discarded locally.
  void navigateToStart() {
    verificationCodeController.clear();
    _loginRequestId = null;
    _currentScreen = EmailPasswordlessFlowScreen.start;
    _setState(EmailAuthState.idle);
  }

  /// Navigates to the verification screen for an existing login request, for
  /// example when starting the flow from a deep link.
  void navigateToVerify({required UuidValue loginRequestId}) {
    verificationCodeController.clear();
    _loginRequestId = loginRequestId;
    _currentScreen = EmailPasswordlessFlowScreen.verify;
    _setState(EmailAuthState.idle);
  }

  /// Clears the text controllers and the pending login request.
  void resetState({bool notify = true}) {
    emailController.clear();
    verificationCodeController.clear();
    _loginRequestId = null;
    _setState(_state, notify: notify);
  }

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
  Future<void> startLogin() async {
    await _guarded(
      targetScreen: EmailPasswordlessFlowScreen.verify,
      action: () async {
        final email = emailController.text.trim();
        emailValidation(email);
        _loginRequestId = await _endpoint.startLogin(email: email);
      },
    );
  }

  /// Verifies the code in [verificationCodeController] and signs the user in.
  ///
  /// On success, updates the session manager and calls [onAuthenticated].
  Future<void> finishLogin() async {
    await _guarded(
      targetState: EmailAuthState.authenticated,
      action: () async {
        final loginRequestId = _loginRequestId;
        if (loginRequestId == null) {
          throw StateError('No login request was found to finish.');
        }

        final authSuccess = await _endpoint.finishLogin(
          loginRequestId: loginRequestId,
          verificationCode: verificationCodeController.text.trim(),
        );

        await client.auth.updateSignedInUser(authSuccess);
      },
    );
  }

  /// Requests a new verification code for the same email address.
  ///
  /// The server does not send a new code until its resend cooldown has elapsed,
  /// and then the previous code is replaced. In the meantime, it answers with
  /// a request ID that can not be completed, so the UI must not offer to resend
  /// before the cooldown, which `ResendCodeButton` ensures with its countdown.
  @override
  Future<void> resendVerificationCode() async {
    if (_currentScreen != EmailPasswordlessFlowScreen.verify) {
      throw StateError('Cannot resend code on screen: $_currentScreen');
    }
    await _guarded(
      targetScreen: EmailPasswordlessFlowScreen.verify,
      action: () async {
        final email = emailController.text.trim();
        emailValidation(email);
        _loginRequestId = await _endpoint.startLogin(email: email);
      },
    );
  }

  void _setState(EmailAuthState newState, {bool notify = true}) {
    if (newState != EmailAuthState.error) _error = null;
    _state = newState;
    if (notify) notifyListeners();
  }

  Future<void> _guarded({
    EmailAuthState? targetState,
    EmailPasswordlessFlowScreen? targetScreen,
    required Future<void> Function() action,
  }) async {
    _debounce?.cancel();
    _setState(EmailAuthState.loading);
    try {
      await action();
      if (targetScreen != null) {
        if (targetScreen != _currentScreen) {
          verificationCodeController.clear();
        }
        _currentScreen = targetScreen;
        _setState(EmailAuthState.idle);
      } else if (targetState != null) {
        _setState(targetState);
        if (targetState == EmailAuthState.authenticated) {
          onAuthenticated?.call();
        }
      }
    } catch (e) {
      _error = e;
      _setState(EmailAuthState.error);
      debugPrint('[EmailPasswordlessAuthController] $_currentScreen: $e');

      if (e is ServerpodClientNetworkException) {
        Timer(const Duration(seconds: 1), () {
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
    _debounce?.cancel();
    emailController.dispose();
    verificationCodeController.dispose();
    legalNoticeAcceptedNotifier.dispose();
    super.dispose();
  }
}
