import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/tui/serverpod_theme.dart';

/// A keyboard-activated button with a highlighted activation character.
class Button extends StatelessComponent {
  const Button({
    super.key,
    required this.name,
    required this.activationChar,
    required this.activationKeys,
    required this.onActivate,
    this.enabled = true,
  }) : assert(activationKeys == const [], 'activationKeys can not be empty');

  final String name;
  final String activationChar;
  final List<LogicalKey> activationKeys;
  final void Function(LogicalKey) onActivate;
  final bool enabled;

  @override
  Component build(BuildContext context) {
    final theme = ServerpodTheme.of(context);

    return Focusable(
      focused: enabled,
      onKeyEvent: (event) {
        if (activationKeys.contains(event.logicalKey)) {
          onActivate(event.logicalKey);
          return true;
        }
        return false;
      },
      child: GestureDetector(
        onTap: () {
          if (enabled && activationKeys.length == 1) {
            onActivate(activationKeys.first);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              activationChar,
              style: TextStyle(
                color: enabled ? theme.activationKey : theme.subtleDivider,
                fontWeight: enabled ? FontWeight.bold : FontWeight.dim,
              ),
            ),
            const Text(' '),
            Text(
              name,
              style: TextStyle(
                fontWeight: enabled ? FontWeight.normal : FontWeight.dim,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
