import 'package:nocterm/nocterm.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

class TextButton extends StatelessComponent {
  const TextButton({
    super.key,
    required this.name,
    required this.activationKeys,
    required this.onActivate,
    this.enabled = true,
    this.focused = false,
  });

  final String name;
  final List<LogicalKey> activationKeys;
  final void Function(LogicalKey) onActivate;
  final bool enabled;
  final bool focused;

  @override
  Component build(BuildContext context) {
    final theme = ServerpodTheme.of(context);
    final bgColor = enabled && focused
        ? theme.activationKey
        : theme.subtleDivider;

    return Focusable(
      focused: enabled && focused,
      onKeyEvent: (event) {
        if (!enabled) return false;
        if (event.isControlPressed ||
            event.isAltPressed ||
            event.isMetaPressed) {
          return false;
        }
        for (final key in activationKeys) {
          if (event.matches(key)) {
            onActivate(key);
            return true;
          }
        }
        return false;
      },
      child: GestureDetector(
        onTap: enabled ? () => onActivate(activationKeys.first) : null,
        child: Container(
          color: bgColor,
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Text(
            name,
            style: const TextStyle(color: Color.defaultColor),
          ),
        ),
      ),
    );
  }
}
