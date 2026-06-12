import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../common/text_formatters.dart';
import '../../../localization/sign_in_localization_provider.dart';
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
    final texts = context.emailSignInTexts;

    return CustomTextField(
      controller: controller.emailController,
      labelText: texts.emailLabel,
      keyboardType: TextInputType.emailAddress,
      isLoading: controller.isLoading,
      errorText: controller.error is InvalidEmailException
          ? controller.errorMessage
          : null,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[\s()<>[\]\\,;:]')),
        const LetterCaseTextFormatter(letterCase: LetterCase.lowercase),
      ],
    );
  }
}
