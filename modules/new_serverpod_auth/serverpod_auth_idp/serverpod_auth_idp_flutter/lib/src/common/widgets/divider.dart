import 'package:flutter/material.dart';

class ExpandedDivider extends StatelessWidget {
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
