import 'package:flutter/material.dart';

import '../../../common/widgets/buttons/action_button.dart';
import '../../../common/widgets/gaps.dart';
import '../../../common/widgets/password_field.dart';
import '../../../common/widgets/password_requirements.dart';
import '../../email_auth_controller.dart';
import 'form_standard_layout.dart';

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
  void initState() {
    super.initState();
    widget.controller.passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    widget.controller.passwordController.removeListener(_onPasswordChanged);
    super.dispose();
  }

  void _onPasswordChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final passwordRequirements = widget.controller.passwordRequirements;
    final password = widget.controller.passwordController.text;
    final isValidPassword = passwordRequirements.isValid(password);

    return FormStandardLayout(
      title: widget.title,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PasswordField(
            labelText: widget.passwordLabelText,
            controller: widget.controller.passwordController,
            isLoading: widget.controller.isLoading,
          ),
          if (passwordRequirements.isNotEmpty) ...[
            tinyGap,
            PasswordRequirements(
              password: password,
              requirements: passwordRequirements,
            ),
          ],
        ],
      ),
      actionButton: ActionButton(
        onPressed: isValidPassword ? widget.onActionPressed : null,
        label: widget.actionButtonLabel,
        isLoading: widget.controller.isLoading,
      ),
      bottomText: widget.bottomText,
    );
  }
}
