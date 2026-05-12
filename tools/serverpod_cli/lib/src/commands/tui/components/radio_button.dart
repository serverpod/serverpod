import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/tui/serverpod_theme.dart';

/// A radio button component.
class RadioButton extends StatelessComponent {
  const RadioButton({
    required this.label,
    required this.value,
    this.style,
  });

  final bool value;
  final String label;
  final TextStyle? style;

  @override
  Component build(BuildContext context) {
    final theme = ServerpodTheme.of(context);
    final indicator = value ? '◉' : '○';
    final effectiveStyle = style ?? TextStyle(color: theme.subtleDivider);

    return Row(
      children: [
        Text(indicator, style: effectiveStyle),
        const SizedBox(width: 1),
        Text(label, style: effectiveStyle),
      ],
    );
  }
}
