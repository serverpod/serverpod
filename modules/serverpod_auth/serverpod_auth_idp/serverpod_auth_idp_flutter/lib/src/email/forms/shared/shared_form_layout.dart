import 'package:flutter/material.dart';

import '../widgets/form_standard_layout.dart';

/// Layout of the forms shared by the email authentication flows, based on
/// [FormStandardLayout], which keeps the title and the action button at the
/// same positions on every screen of a flow.
///
/// If [scrollableContent] is `true`, content that does not fit the form, e.g.
/// on narrow screens or with expanded fields, scrolls instead of overflowing.
/// The content must then not contain flexible widgets.
class SharedFormLayout extends StatelessWidget {
  /// Whether the content scrolls when it does not fit the form.
  final bool scrollableContent;

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
    required this.scrollableContent,
    required this.title,
    required this.content,
    required this.actionButton,
    this.bottomText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormStandardLayout(
      title: title,
      content: scrollableContent
          ? SingleChildScrollView(child: content)
          : content,
      actionButton: actionButton,
      bottomText: bottomText,
    );
  }
}
