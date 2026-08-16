import 'package:flutter/material.dart';

import 'requirements.dart';

/// Widget that displays password requirements.
///
/// Shows a list of password requirements with their validation status.
/// Requirements are displayed in gray bodySmall text. Localized using
/// [PasswordRequirementTexts] from [BuildContext].
class PasswordRequirements extends StatelessWidget {
  /// The password text to validate against requirements.
  final String password;

  /// The list of password requirements to display.
  final List<PasswordRequirement> requirements;

  /// Creates a [PasswordRequirements] widget.
  const PasswordRequirements({
    required this.password,
    required this.requirements,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (requirements.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final textStyle =
        theme.textTheme.bodySmall?.copyWith(color: Colors.grey) ??
        const TextStyle(fontSize: 12, color: Colors.grey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var requirement in requirements)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Row(
              children: [
                Icon(
                  requirement.validator(password)
                      ? Icons.check_circle
                      : Icons.cancel,
                  size: 16,
                  color: requirement.validator(password)
                      ? Colors.green
                      : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  PasswordRequirement.localized(
                    requirement,
                    context.passwordRequirementTexts,
                  ),
                  style: password.isEmpty
                      ? textStyle
                      : requirement.validator(password)
                      ? textStyle.copyWith(color: Colors.green)
                      : textStyle,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
