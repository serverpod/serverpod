import 'package:flutter/material.dart';

import '../widgets/form_inline_action_layout.dart';
import '../widgets/form_standard_layout.dart';

/// Layout of the forms shared by the email authentication flows.
///
/// Uses [FormInlineActionLayout] if [inlineAction] is `true`, which grows
/// with its content, and [FormStandardLayout] otherwise, which has a fixed
/// height and keeps the action button at the bottom.
class SharedFormLayout extends StatelessWidget {
  /// Whether to place the action button right below the content.
  final bool inlineAction;

  /// The title of the form.
  final String title;

  /// The content of the form.
  final Widget content;

  /// The action button of the form.
  final Widget actionButton;

  /// Optional widget to display below the action button.
  final Widget? bottomText;

  /// Creates a [SharedFormLayout] widget.
  const SharedFormLayout({
    required this.inlineAction,
    required this.title,
    required this.content,
    required this.actionButton,
    this.bottomText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (inlineAction) {
      return FormInlineActionLayout(
        title: title,
        content: content,
        actionButton: actionButton,
        bottomText: bottomText,
      );
    }
    return FormStandardLayout(
      title: title,
      content: content,
      actionButton: actionButton,
      bottomText: bottomText,
    );
  }
}
