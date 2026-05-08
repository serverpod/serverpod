import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/tui/components/button.dart';
import 'package:serverpod_cli/src/commands/tui/components/wrap.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Wrap(spacing: 2, children: buttons),
    );
  }
}
