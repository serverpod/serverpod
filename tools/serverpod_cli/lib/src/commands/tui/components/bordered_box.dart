import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/tui/serverpod_theme.dart';

/// A container with a rounded border and optional title.
class BorderedBox extends StatelessComponent {
  const BorderedBox({
    super.key,
    required this.child,
    this.title,
    this.color,
    this.backgroundColor,
  });

  final Component child;
  final BorderTitle? title;
  final Color? color;
  final Color? backgroundColor;

  @override
  Component build(BuildContext context) {
    final serverpodTheme = ServerpodTheme.of(context);
    final theme = TuiTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.background,
        border: BoxBorder.all(
          style: BoxBorderStyle.rounded,
          color: color ?? serverpodTheme.subtleDivider,
        ),
        title: title,
      ),
      child: child,
    );
  }
}
