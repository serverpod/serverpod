import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/tui/serverpod_theme.dart';

/// A keyboard-activated button with a highlighted activation character.
///
/// When [onShiftActivate] is non-null, the button also dispatches `Shift+key`
/// to that callback and appends a `⇧` glyph to [name] as a discoverability
/// cue (terminals can't tell us when Shift is pressed without a key, so the
/// hint is shown statically). Help (`H`) lists what each `⇧` does.
class Button extends StatelessComponent {
  const Button({
    super.key,
    required this.name,
    required this.activationChar,
    required this.activationKeys,
    required this.onActivate,
    this.onShiftActivate,
    this.enabled = true,
  }) : assert(activationKeys.length > 0, 'activationKeys can not be empty');

  final String name;
  final String activationChar;
  final List<LogicalKey> activationKeys;
  final void Function(LogicalKey) onActivate;
  final void Function(LogicalKey)? onShiftActivate;
  final bool enabled;

  @override
  Component build(BuildContext context) {
    final theme = ServerpodTheme.of(context);
    final hasShiftVariant = onShiftActivate != null;

    return Focusable(
      focused: enabled,
      onKeyEvent: (event) {
        for (final key in activationKeys) {
          if (hasShiftVariant) {
            if (event.matches(key, shift: false)) {
              onActivate(key);
              return true;
            }
            if (event.matches(key, shift: true)) {
              onShiftActivate!(key);
              return true;
            }
          } else if (event.matches(key)) {
            onActivate.call(key);
            return true;
          }
        }
        return false;
      },
      child: GestureDetector(
        onTap: () {
          if (enabled && activationKeys.length == 1) {
            onActivate.call(activationKeys.first);
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
              hasShiftVariant ? '$name⇧' : name,
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

class Tip extends StatelessComponent {
  const Tip(this.tip);

  final String tip;

  @override
  Component build(BuildContext context) {
    final theme = ServerpodTheme.of(context);
    return Text('💡 Tip: $tip', style: TextStyle(color: theme.brightText));
  }
}
