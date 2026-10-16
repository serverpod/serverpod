import 'package:flutter/material.dart';

import '../../../common/widgets/gaps.dart';

/// Layout for forms that place the action button right below their content,
/// so that content expanding above it pushes it down.
///
/// Unlike `FormStandardLayout`, which keeps the action button at the bottom.
class FormInlineActionLayout extends StatelessWidget {
  /// The title of the form.
  final String title;

  /// The content of the form, shown above the action button.
  final Widget content;

  /// The action button of the form.
  final Widget actionButton;

  /// Optional widget to display below the action button.
  final Widget? bottomText;

  /// Creates a [FormInlineActionLayout] widget.
  const FormInlineActionLayout({
    required this.title,
    required this.content,
    required this.actionButton,
    this.bottomText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // At least the height of `FormStandardLayout`, so switching screens does
    // not resize the widget unless the content needs more space.
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 330),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.left,
          ),
          largeGap,
          content,
          smallGap,
          actionButton,
          if (bottomText case final bottomText?) ...[
            tinyGap,
            bottomText,
          ],
        ],
      ),
    );
  }
}
