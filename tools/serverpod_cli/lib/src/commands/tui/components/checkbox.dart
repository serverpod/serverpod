import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/tui/serverpod_theme.dart';

/// A check box component
class Checkbox extends StatelessComponent {
  const Checkbox({
    super.key,
    required this.label,
    required this.value,
    this.style,
  });

  final String label;
  final bool value;
  final TextStyle? style;

  @override
  Component build(BuildContext context) {
    final theme = ServerpodTheme.of(context);
    final marker = value ? '[✔]' : '[ ]';
    final effectiveStyle = style ?? TextStyle(color: theme.subtleDivider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(marker, style: effectiveStyle),
        const SizedBox(width: 1),
        Text(label, style: effectiveStyle),
      ],
    );
  }
}
