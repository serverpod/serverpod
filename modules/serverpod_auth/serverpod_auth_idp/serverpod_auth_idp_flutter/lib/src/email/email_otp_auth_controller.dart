import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import 'email_flow_controller.dart';

/// Represents the screens of the passwordless email authentication flow.
enum EmailOtpFlowScreen {
  /// Start screen - user enters email to receive a one-time password, or
  /// optionally signs in with a password instead.
  start,

  /// Verify screen - user enters the one-time password received by email to
  /// sign in.
  verify,

  /// Complete registration screen - shown after verifying the one-time
  /// password when no account exists for the email. The user accepts the
  /// terms and optionally sets a password to create the account.
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

/// Controller for the passwordless email authentication flow, where users sign
/// in or sign up with a one-time password (OTP) sent to their email.
///
/// The flow starts on [EmailOtpFlowScreen.start]. Requesting and verifying a
/// code signs in existing accounts, while emails without an account continue
/// to [EmailOtpFlowScreen.completeRegistration] to create one. If
/// [allowPasswordSignIn] is `true`, users can also sign in with their password
/// and reset it.
///
/// The server must expose an endpoint extending `EmailOtpIdpBaseEndpoint`,
/// and be configured to send the codes, see
/// `EmailIdpConfig.sendOtpLoginVerificationCode`.
///
/// Example usage:
/// ```dart
/// final controller = EmailOtpAuthController(
///   client: client,
///   onAuthenticated: () {
///     // Do something when the user is authenticated.
///   },
/// );
///
/// // Request a one-time password for the email in `emailController`.
/// await controller.startOtpLogin();
///
/// // Verify the code in `verificationCodeController`, which signs in existing
/// // accounts.
/// await controller.verifyOtpCode();
///
/// // Create the account for an email without one.
/// await controller.finishOtpRegistration();
/// ```
class EmailOtpAuthController extends EmailFlowController<EmailOtpFlowScreen> {
  /// Whether users can choose to sign in with their password on the
  /// [EmailOtpFlowScreen.start] screen.
  ///
  /// Defaults to `false`.
  final bool allowPasswordSignIn;

  /// Creates a passwordless email authentication controller.
  EmailOtpAuthController({
    required super.client,
    this.allowPasswordSignIn = false,
    super.onAuthenticated,
    super.onError,
    super.emailValidation,
    super.passwordRequirements,
  }) : super(startScreen: EmailOtpFlowScreen.start);

  bool _isPasswordSignInExpanded = false;

  bool _otpAllowPassword = false;

  bool _isRegistrationPasswordExpanded = false;

  /// The token to complete the sign-in of an existing account, kept after the
  /// one-time password was verified so that [verifyOtpCode] can retry the
  /// completion if it fails, without verifying the already used code again.
  String? _otpLoginToken;

  /// Whether the password sign-in is expanded on the
  /// [EmailOtpFlowScreen.start] screen.
  bool get isPasswordSignInExpanded =>
      allowPasswordSignIn && _isPasswordSignInExpanded;

  /// Whether the server allows setting a password when creating an account
  /// through the passwordless flow.
  ///
  /// Set when the one-time password is verified for an email without account.
  bool get otpAllowPassword => _otpAllowPassword;

  /// Whether the optional password field is expanded on the
  /// [EmailOtpFlowScreen.completeRegistration] screen.
  bool get isRegistrationPasswordExpanded =>
      otpAllowPassword && _isRegistrationPasswordExpanded;

  EndpointEmailOtpIdpBase get _otpEndpoint {
    final endpoint = emailEndpoint;
    if (endpoint is EndpointEmailOtpIdpBase) return endpoint;
    throw StateError(
      'The email authentication endpoint does not support passwordless '
      'logins. Make sure your server endpoint extends '
      '"EmailOtpIdpBaseEndpoint" instead of "EmailIdpBaseEndpoint".',
    );
  }

  @override
  EmailOtpFlowScreen get verifyPasswordResetScreen =>
      EmailOtpFlowScreen.verifyPasswordReset;

  @override
  EmailOtpFlowScreen get completePasswordResetScreen =>
      EmailOtpFlowScreen.completePasswordReset;

  /// Expands or collapses the password sign-in on the
  /// [EmailOtpFlowScreen.start] screen.
  ///
  /// Does nothing if [allowPasswordSignIn] is `false`.
  void togglePasswordSignIn() {
    if (!allowPasswordSignIn) return;
    _isPasswordSignInExpanded = !_isPasswordSignInExpanded;
    passwordController.clear();
    setState(EmailAuthState.idle);
  }

  /// Expands or collapses the optional password field on the
  /// [EmailOtpFlowScreen.completeRegistration] screen.
  ///
  /// Collapsing clears the password, so that a hidden password is not set for
  /// the account. Does nothing if [otpAllowPassword] is `false`.
  void toggleRegistrationPassword() {
    if (!otpAllowPassword) return;
    _isRegistrationPasswordExpanded = !_isRegistrationPasswordExpanded;
    passwordController.clear();
    setState(EmailAuthState.idle);
  }

  @override
  void navigateTo(
    EmailOtpFlowScreen screen, {
    UuidValue? requestId,
    String? finishRequestToken,
  }) {
    // Leaving or restarting the verification abandons the pending sign-in.
    _otpLoginToken = null;
    if (screen == EmailOtpFlowScreen.completeRegistration) {
      legalNoticeAcceptedNotifier.value = false;
      _isRegistrationPasswordExpanded = false;
    }
    if (screen == EmailOtpFlowScreen.verify ||
        screen == EmailOtpFlowScreen.verifyPasswordReset) {
      verificationCodeController.clear();
    } else {
      this.requestId = null;
    }
    if (screen == EmailOtpFlowScreen.completeRegistration ||
        screen == EmailOtpFlowScreen.completePasswordReset) {
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
      EmailOtpFlowScreen.start ||
      EmailOtpFlowScreen.verify ||
      EmailOtpFlowScreen.completeRegistration ||
      EmailOtpFlowScreen.requestPasswordReset => EmailOtpFlowScreen.start,
      EmailOtpFlowScreen.verifyPasswordReset ||
      EmailOtpFlowScreen.completePasswordReset =>
        EmailOtpFlowScreen.requestPasswordReset,
    });

    return true;
  }

  @override
  void resetState({bool notify = true}) {
    _otpLoginToken = null;
    super.resetState(notify: notify);
  }

  @override
  Future<void> resendVerificationCode() async {
    await switch (currentScreen) {
      EmailOtpFlowScreen.verify => startOtpLogin(),
      EmailOtpFlowScreen.verifyPasswordReset => startPasswordReset(),
      _ => throw StateError('Cannot resend code on screen: $currentScreen'),
    };
  }

  /// Starts a passwordless login by requesting a one-time password for the
  /// email from the text controller.
  ///
  /// On success, transitions to the [EmailOtpFlowScreen.verify] screen.
  /// On failure, transitions to error state with the error message.
  Future<void> startOtpLogin() async {
    await runGuarded(() async {
      final email = emailController.text.trim();
      emailValidation.call(email);
      requestId = await _otpEndpoint.startOtpLogin(email: email);
      return EmailOtpFlowScreen.verify;
    });
  }

  /// Verifies the one-time password from the verification code controller.
  ///
  /// If an account exists for the email, the user is signed in and
  /// [onAuthenticated] is called. Otherwise, transitions to the
  /// [EmailOtpFlowScreen.completeRegistration] screen for the user to accept
  /// the terms and create the account with [finishOtpRegistration].
  /// On failure, transitions to error state with the error message.
  ///
  /// If the code was verified but completing the sign-in failed, e.g. due to a
  /// network error, calling this again retries the completion without
  /// verifying the code again. If the server no longer accepts the completion,
  /// e.g. because its response was lost after it succeeded, the user has to
  /// request a new code.
  Future<void> verifyOtpCode() async {
    await runGuarded(() async {
      final pendingOtpLoginToken = _otpLoginToken;
      if (pendingOtpLoginToken != null) {
        await _finishOtpLogin(pendingOtpLoginToken);
        return null;
      }

      final otpLoginRequestId = requestId;
      if (otpLoginRequestId == null) {
        throw StateError('No login request was found to verify.');
      }

      final result = await _otpEndpoint.verifyOtpLoginCode(
        otpLoginRequestId: otpLoginRequestId,
        verificationCode: verificationCodeController.text.trim(),
      );

      if (result.accountExists) {
        _otpLoginToken = result.token;
        await _finishOtpLogin(result.token);
        return null;
      }

      finishRequestToken = result.token;
      _otpAllowPassword = result.allowPassword;
      return EmailOtpFlowScreen.completeRegistration;
    });
  }

  Future<void> _finishOtpLogin(String otpLoginToken) async {
    final AuthSuccess authSuccess;
    try {
      authSuccess = await _otpEndpoint.finishOtpLogin(
        otpLoginToken: otpLoginToken,
      );
    } on EmailAccountRequestException catch (e) {
      // The server rejected the token, so retrying can not succeed. This also
      // happens if a previous completion succeeded but its response was lost.
      _otpLoginToken = null;
      throw OtpLoginRejectedException(e);
    }

    _otpLoginToken = null;
    await client.auth.updateSignedInUser(authSuccess);
  }

  /// Creates the account for an email verified through the passwordless flow.
  ///
  /// Must only be called after the user accepted the terms. The password from
  /// the [passwordController] is set for the account if not empty and
  /// [otpAllowPassword] is `true`.
  ///
  /// On success, updates the session manager and calls [onAuthenticated].
  /// On failure, transitions to error state with the error message.
  Future<void> finishOtpRegistration() async {
    await runGuarded(() async {
      final finishRequestToken = this.finishRequestToken;
      if (finishRequestToken == null) {
        throw StateError('No login request was found to finish.');
      }

      final password = passwordController.text;
      final authSuccess = await _otpEndpoint.finishOtpRegistration(
        otpLoginToken: finishRequestToken,
        password: _otpAllowPassword && password.isNotEmpty ? password : null,
      );

      await client.auth.updateSignedInUser(authSuccess);
      return null;
    });
  }
}

/// Exception thrown when the server no longer accepts the completion of a
/// passwordless sign-in, e.g. because the code expired or was already used.
///
/// The user has to request a new code to sign in.
class OtpLoginRejectedException implements Exception {
  /// The exception with which the server rejected the completion.
  final EmailAccountRequestException serverException;

  /// Creates a new [OtpLoginRejectedException].
  const OtpLoginRejectedException(this.serverException);

  @override
  String toString() => 'OtpLoginRejectedException($serverException)';
}
