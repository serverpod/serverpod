import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A compact text-styled button typically used for secondary actions.
class HyperlinkTextButton extends StatelessWidget {
  /// Callback invoked when the button is pressed.
  final VoidCallback onPressed;

  /// The label displayed inside the button.
  final String label;

  /// Padding around the button.
  final EdgeInsets padding;

  /// Creates a [HyperlinkTextButton] widget.
  const HyperlinkTextButton({
    required this.onPressed,
    required this.label,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = Theme.of(context).textTheme.bodyMedium?.fontSize ?? 0;

    return SizedBox(
      height: math.max(24, fontSize),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
