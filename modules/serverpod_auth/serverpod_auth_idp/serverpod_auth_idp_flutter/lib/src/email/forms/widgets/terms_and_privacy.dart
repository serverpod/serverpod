import 'package:flutter/material.dart';

import '../../../localization/sign_in_localization_provider.dart';
import '../../../common/widgets/buttons/text_button.dart';

/// Widget to display terms and privacy text with a checkbox.
class TermsAndPrivacyText extends StatelessWidget {
  /// Callback to call when the terms and conditions button is pressed.
  final VoidCallback? onTermsAndConditionsPressed;

  /// Callback to call when the privacy policy button is pressed.
  final VoidCallback? onPrivacyPolicyPressed;

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
  }) : assert(
         ((onTermsAndConditionsPressed ?? onPrivacyPolicyPressed) != null),
         'At least one of "onTermsAndConditionsPressed" or '
         '"onPrivacyPolicyPressed" must be provided.',
       );

  @override
  Widget build(BuildContext context) {
    final texts = context.emailSignInTexts;
    final onTermsAndConditionsPressed = this.onTermsAndConditionsPressed;
    final onPrivacyPolicyPressed = this.onPrivacyPolicyPressed;
    final textStyle =
        Theme.of(context).textTheme.bodySmall ?? const TextStyle(fontSize: 12);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onCheckboxChanged,
        ),
        Expanded(
          child: DefaultTextStyle.merge(
            style: textStyle,
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 2,
              runSpacing: -6,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(texts.termsIntro),
                ),
                if (onTermsAndConditionsPressed != null)
                  HyperlinkTextButton(
                    onPressed: onTermsAndConditionsPressed,
                    label: texts.termsAndConditions,
                    fontSize: textStyle.fontSize,
                  ),
                if (onTermsAndConditionsPressed != null &&
                    onPrivacyPolicyPressed != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(texts.andText),
                  ),
                if (onPrivacyPolicyPressed != null)
                  HyperlinkTextButton(
                    onPressed: onPrivacyPolicyPressed,
                    label: texts.privacyPolicy,
                    fontSize: textStyle.fontSize,
                  ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text("."),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
