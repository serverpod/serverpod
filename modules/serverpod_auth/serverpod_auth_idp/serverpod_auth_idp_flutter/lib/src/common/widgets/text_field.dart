import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A standard text field used across authentication forms.
///
/// Wraps a [TextField] with consistent styling and an optional loading
/// disabled state.
class CustomTextField extends StatelessWidget {
  /// Controller for the input value.
  final TextEditingController controller;

  /// Label text shown above the input.
  final String labelText;

  /// Keyboard type to use for the input.
  final TextInputType keyboardType;

  /// Optional hint text displayed inside the input.
  final String? hintText;

  /// When true, disables the field to indicate a loading state.
  final bool isLoading;

  /// An error message to display when the input is invalid.
  final String? errorText;

  /// Optional input formatters to apply to the input.
  final List<TextInputFormatter>? inputFormatters;

  /// Creates an [CustomTextField].
  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.hintText,
    this.isLoading = false,
    this.errorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: hintText,
        errorText: errorText,
      ),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      enabled: !isLoading,
    );
  }
}
