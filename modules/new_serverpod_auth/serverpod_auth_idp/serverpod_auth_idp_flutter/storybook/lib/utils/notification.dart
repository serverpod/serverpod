import 'package:flutter/material.dart';

extension ContextShowSnackBar on BuildContext {
  /// Shows an error snack bar with the given message.
  void showErrorSnackBar(String message) {
    _showSnackBar(message: message, backgroundColor: Colors.red);
  }

  /// Shows a success snack bar with the given message.
  void showSuccessSnackBar(String message) {
    _showSnackBar(message: message, backgroundColor: Colors.green);
  }

  /// Shows a snack bar with the given message and background color.
  void _showSnackBar({
    required String message,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
