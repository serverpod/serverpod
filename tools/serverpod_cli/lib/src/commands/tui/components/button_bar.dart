import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/tui/components/button.dart';

/// A horizontal bar of [Button] widgets with consistent spacing.
///
/// Renders buttons with a 1-column left margin, 2-column gaps between
/// adjacent buttons, and a 1-column right margin, matching the standard
/// TUI button bar layout.
class ButtonBar extends StatelessComponent {
  const ButtonBar({super.key, required this.buttons});

  final List<Button> buttons;

  @override
  Component build(BuildContext context) {
    return Container(
      color: Color.defaultColor,
      child: Row(
        children: [
          const SizedBox(width: 1),
          for (var index = 0; index < buttons.length; index++) ...[
            if (index > 0) const SizedBox(width: 2),
            buttons[index],
          ],
          const SizedBox(width: 1),
        ],
      ),
    );
  }
}
