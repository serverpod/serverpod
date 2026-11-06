import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/text_formatters.dart';
import '../../../common/widgets/text_field.dart';
import '../../../localization/sign_in_localization_provider.dart';
import '../../email_flow_controller.dart';

/// A text field for email input, shared by the email authentication flows.
class SharedEmailTextField extends StatelessWidget {
  /// The controller of the email authentication flow.
  final EmailFlowController<Enum> controller;

  /// Creates a [SharedEmailTextField] widget.
  const SharedEmailTextField({required this.controller, super.key});

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
