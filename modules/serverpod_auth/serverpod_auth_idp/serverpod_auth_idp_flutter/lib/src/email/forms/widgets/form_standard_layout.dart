import 'package:flutter/material.dart';

import '../../../common/widgets/gaps.dart';

/// Widget to display a standard layout for forms.
class FormStandardLayout extends StatelessWidget {
  /// The title of the form.
  final String title;

  /// The content of the form.
  final Widget content;

  /// The action button of the form.
  final Widget actionButton;

  /// Optional text widget to display below the action button.
  final Widget? bottomText;

  /// Creates a [FormStandardLayout] widget.
  const FormStandardLayout({
    required this.title,
    required this.content,
    required this.actionButton,
    this.bottomText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.left,
          ),
          largeGap,
          Expanded(child: content),
          actionButton,
          tinyGap,
          bottomText ?? const SizedBox(height: 20),
        ],
      ),
    );
  }
}
