import 'package:flutter/widgets.dart';

/// The parts of an email authentication controller that are needed by the
/// shared email form widgets, such as `EmailTextField` and `VerificationForm`.
///
/// Implemented by `EmailAuthController` and `EmailPasswordlessAuthController`.
abstract interface class EmailCodeFormController implements Listenable {
  /// Text controller for email input.
  TextEditingController get emailController;

  /// Text controller for verification code input.
  TextEditingController get verificationCodeController;

  /// Whether the controller is currently processing a request.
  bool get isLoading;

  /// The current error, if the controller is in an error state.
  Object? get error;

  /// The current error message, if any.
  String? get errorMessage;

  /// Requests a new verification code for the current flow.
  Future<void> resendVerificationCode();
}
