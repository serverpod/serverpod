import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface.withOpacity(0.8),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_rounded,
            color: theme.colorScheme.primary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Brought to you by the Serverpod team with love',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
