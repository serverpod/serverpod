import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../common/widgets/text_field.dart';
import '../../email_auth_controller.dart';

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
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller.emailController,
      labelText: 'Email',
      keyboardType: TextInputType.emailAddress,
      isLoading: controller.isLoading,
      errorText: controller.error is InvalidEmailException
          ? controller.errorMessage
          : null,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[\s()<>[\]\\,;:]')),
      ],
    );
  }
}
