import 'package:flutter/material.dart';

import '../../../common/widgets/buttons/text_button.dart';

/// Widget to display terms and privacy text with a checkbox.
class TermsAndPrivacyText extends StatelessWidget {
  /// Callback to call when the terms and conditions button is pressed.
  final VoidCallback onTermsAndConditionsPressed;

  /// Callback to call when the privacy policy button is pressed.
  final VoidCallback onPrivacyPolicyPressed;

  /// Callback to call when the checkbox is changed.
  final void Function(bool?) onCheckboxChanged;

  /// Whether the checkbox is checked.
  final bool isChecked;

  /// Creates a [TermsAndPrivacyText] widget.
  const TermsAndPrivacyText({
    super.key,
    required this.onTermsAndConditionsPressed,
    required this.onPrivacyPolicyPressed,
    required this.onCheckboxChanged,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onCheckboxChanged,
        ),
        Expanded(
          child: Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.copyWith(
                bodyMedium: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 12,
              ),
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 2,
                runSpacing: -6,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text("I have read and accept the "),
                  ),
                  HyperlinkTextButton(
                    onPressed: onTermsAndConditionsPressed,
                    label: 'Terms and Conditions',
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(" and "),
                  ),
                  HyperlinkTextButton(
                    onPressed: onPrivacyPolicyPressed,
                    label: 'Privacy Policy',
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text("."),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
