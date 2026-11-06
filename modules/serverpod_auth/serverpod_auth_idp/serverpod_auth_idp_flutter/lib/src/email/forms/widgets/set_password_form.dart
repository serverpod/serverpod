import 'package:flutter/material.dart';

import '../../email_auth_controller.dart';
import '../shared/shared_set_password_form.dart';

/// Set new password form widget.
///
/// Displays a password field for users to set a new password after verification.
/// Can be used for both password reset and registration completion.
class SetPasswordForm extends StatefulWidget {
  /// The controller that manages authentication state and logic.
  final EmailAuthController controller;

  /// The title to display on the form.
  final String title;

  /// The label text for the password field.
  final String passwordLabelText;

  /// The label text for the action button.
  final String actionButtonLabel;

  /// The callback to call when the action button is pressed.
  final VoidCallback onActionPressed;

  /// Widget to display at the bottom of the form.
  final Widget bottomText;

  /// Creates a [SetPasswordForm] widget.
  const SetPasswordForm({
    super.key,
    required this.controller,
    required this.title,
    required this.passwordLabelText,
    required this.actionButtonLabel,
    required this.onActionPressed,
    required this.bottomText,
  });

  @override
  State<SetPasswordForm> createState() => _SetPasswordFormState();
}

class _SetPasswordFormState extends State<SetPasswordForm> {
  @override
  Widget build(BuildContext context) => SharedSetPasswordForm(
    controller: widget.controller,
    title: widget.title,
    passwordLabelText: widget.passwordLabelText,
    actionButtonLabel: widget.actionButtonLabel,
    onActionPressed: widget.onActionPressed,
    bottomText: widget.bottomText,
  );
}
