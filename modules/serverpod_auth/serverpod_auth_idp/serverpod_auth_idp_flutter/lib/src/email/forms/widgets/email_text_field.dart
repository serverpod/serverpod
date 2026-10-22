import 'package:flutter/material.dart';
import '../../email_auth_controller.dart';
import '../shared/shared_email_text_field.dart';

/// A text field for email input.
class EmailTextField extends StatelessWidget {
  /// The controller for the email authentication.
  final EmailAuthController controller;

  /// Creates a new [EmailTextField] widget.
  const EmailTextField({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      SharedEmailTextField(controller: controller);
}
