import 'package:flutter/material.dart';

/// A divider that takes up all available width.
class ExpandedDivider extends StatelessWidget {
  /// Creates an [ExpandedDivider].
  const ExpandedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Divider(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
        indent: 0,
        endIndent: 0,
      ),
    );
  }
}
