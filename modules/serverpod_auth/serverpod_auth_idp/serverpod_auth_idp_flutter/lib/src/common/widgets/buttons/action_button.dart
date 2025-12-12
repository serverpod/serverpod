import 'package:flutter/material.dart';

import '../loading_indicator.dart';

/// A primary action button used in forms (e.g., Sign in / Register).
class ActionButton extends StatelessWidget {
  /// Callback invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// Label displayed inside the button.
  final String label;

  /// When true, shows a loading indicator and disables the button.
  final bool isLoading;

  /// Creates an [ActionButton] widget.
  const ActionButton({
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        textStyle: Theme.of(context).textTheme.bodyLarge,
        shape: const StadiumBorder(),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? const LoadingIndicator() : Text(label),
    );
  }
}
