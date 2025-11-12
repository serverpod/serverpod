import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import '../common/widgets/password_requirements.dart';
import 'email_auth_controller.dart';
import 'forms/login.dart';
import 'forms/password_reset_start.dart';
import 'forms/registration_start.dart';
import 'forms/password_reset_complete.dart';
import 'forms/registration_complete.dart';
import 'forms/verification.dart';

/// A widget that provides email-based authentication functionality.
///
/// The widget can manage its own authentication state, or you can provide an
/// external [controller] for advanced use cases like sharing state across
/// multiple widgets or integrating with state management solutions.
///
/// When [controller] is not provided, you must supply [client] and optionally
/// [startScreen], [onAuthenticated], and [onError] callbacks. When [controller]
/// is provided, those parameters are handled by the controller itself.
///
/// Example with managed state:
/// ```
/// EmailSignInWidget(
///   client: client,
///   onAuthenticated: () => Navigator.push(...),
///   onError: (error) => showSnackBar(...),
/// )
/// ```
///
/// Example with external controller:
/// ```
/// final controller = EmailAuthController(
///   client: client,
///   onAuthenticated: ...,
/// );
///
/// EmailSignInWidget(
///   controller: controller,
/// )
/// ```
class EmailSignInWidget extends StatefulWidget {
  /// Controls the authentication state and behavior.
  ///
  /// If null, the widget creates and manages its own [EmailAuthController].
  /// In this case, [client] must be provided.
  ///
  /// If provided, the widget uses this controller instead of creating one,
  /// and [client], [startScreen], [onAuthenticated], and [onError] are ignored.
  final EmailAuthController? controller;

  /// The Serverpod client instance.
  ///
  /// Required when [controller] is null, ignored otherwise.
  final ServerpodClientShared? client;

  /// The initial screen to display.
  ///
  /// Ignored when [controller] is provided.
  final EmailFlowScreen startScreen;

  /// Callback when authentication is successful.
  ///
  /// Ignored when [controller] is provided.
  final VoidCallback? onAuthenticated;

  /// Callback when an error occurs during authentication.
  ///
  /// Ignored when [controller] is provided.
  final Function(Object error)? onError;

  /// The validation function to use for email validation.
  ///
  /// This function should throw a [FormatException] if the email is invalid.
  final void Function(String email)? emailValidation;

  /// Optional list of password requirements to display to the user.
  ///
  /// If provided, these requirements will be shown in password forms to guide
  /// users on password creation. If null, will use a recommended safe default
  /// defined at [PasswordRequirement.defaultRequirements].
  final List<PasswordRequirement>? passwordRequirements;

  /// Optional callback to call when the terms and conditions button is pressed.
  ///
  /// If not provided, defaults to null.
  final VoidCallback? onTermsAndConditionsPressed;

  /// Optional callback to call when the privacy policy button is pressed.
  ///
  /// If not provided, defaults to null.
  final VoidCallback? onPrivacyPolicyPressed;

  /// The duration of the countdown timer for resending the verification code.
  ///
  /// Defaults to 1 minute.
  final Duration resendCountdownDuration;

  /// Creates an email sign-in widget.
  const EmailSignInWidget({
    this.controller,
    this.client,
    this.startScreen = EmailFlowScreen.login,
    this.emailValidation,
    this.passwordRequirements,
    this.onAuthenticated,
    this.onError,
    this.onTermsAndConditionsPressed,
    this.onPrivacyPolicyPressed,
    this.resendCountdownDuration = const Duration(minutes: 1),
    super.key,
  }) : assert(
         (controller == null || client == null),
         'Either controller or client must be provided, but not both. When '
         'passing a controller, client, startScreen, onAuthenticated, and '
         'onError parameters are ignored.',
       ),
       assert(
         (onAuthenticated == null && onError == null) || controller == null,
         'Provide onAuthenticated or onError when using a controller '
         'as they are handled by the controller and will be ignored.',
       );

  @override
  State<EmailSignInWidget> createState() => _EmailSignInWidgetState();
}

class _EmailSignInWidgetState extends State<EmailSignInWidget> {
  late final EmailAuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        EmailAuthController(
          client: widget.client!,
          startScreen: widget.startScreen,
          onAuthenticated: widget.onAuthenticated,
          onError: widget.onError,
          emailValidation: widget.emailValidation,
          passwordRequirements: widget.passwordRequirements,
        );
    _controller.addListener(_onControllerStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerStateChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// Rebuild when controller state changes
  void _onControllerStateChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 600),
      reverse: _controller.currentScreen != _controller.startScreen,
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
      child: _buildScreen(),
    );
  }

  Widget _buildScreen() {
    return switch (_controller.currentScreen) {
      EmailFlowScreen.login => LoginForm(
        controller: _controller,
      ),
      EmailFlowScreen.startRegistration => StartRegistrationForm(
        controller: _controller,
        onTermsAndConditionsPressed: widget.onTermsAndConditionsPressed,
        onPrivacyPolicyPressed: widget.onPrivacyPolicyPressed,
      ),
      EmailFlowScreen.verifyRegistration => VerificationForm(
        title: 'Verify account',
        controller: _controller,
        onCompleted: _controller.verifyRegistrationCode,
        resendCountdownDuration: widget.resendCountdownDuration,
      ),
      EmailFlowScreen.completeRegistration => CompleteRegistrationForm(
        controller: _controller,
      ),
      EmailFlowScreen.requestPasswordReset => RequestPasswordResetForm(
        controller: _controller,
      ),
      EmailFlowScreen.verifyPasswordReset => VerificationForm(
        title: 'Verify reset code',
        controller: _controller,
        onCompleted: _controller.verifyPasswordResetCode,
        resendCountdownDuration: widget.resendCountdownDuration,
      ),
      EmailFlowScreen.completePasswordReset => CompletePasswordResetForm(
        controller: _controller,
      ),
    };
  }
}
