import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'password_requirements.dart';

/// A password input field with visibility toggle.
///
/// Provides a [TextField] configured for entering passwords and a
/// suffix icon to toggle visibility. The field can be disabled when
/// [isLoading] is true.
class PasswordField extends StatefulWidget {
  /// The label displayed above the input.
  final String labelText;

  /// Controller for the underlying [TextField].
  final TextEditingController controller;

  /// Whether the field should be disabled to indicate loading state.
  final bool isLoading;

  /// Creates a [PasswordField].
  ///
  /// [controller] is required. [labelText] defaults to 'Password'.
  const PasswordField({
    this.labelText = 'Password',
    required this.controller,
    this.isLoading = false,
    super.key,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      enabled: !widget.isLoading,
      obscureText: !_passwordVisible,
      keyboardType: TextInputType.visiblePassword,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          PasswordRequirement.allowedCharacters,
        ),
      ],
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                key: ValueKey<bool>(_passwordVisible),
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
