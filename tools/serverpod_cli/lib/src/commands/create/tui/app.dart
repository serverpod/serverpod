import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/create/tui/main_screen.dart';
import 'package:serverpod_cli/src/commands/create/tui/state_holder.dart';
import 'package:serverpod_cli/src/commands/tui/app.dart';

/// Root TUI component for `serverpod create`.
class ServerpodCreateApp extends ServerpodApp<CreateAppStateHolder> {
  const ServerpodCreateApp({
    super.key,
    required super.holder,
    required this.name,
    required this.onCreate,
    required this.onQuit,
    required this.onSkipFlutterBuild,
  });

  final String name;
  final VoidCallback onCreate;
  final VoidCallback onQuit;
  final VoidCallback onSkipFlutterBuild;

  @override
  ServerpodAppState createState() => ServerpodCreateAppState();
}

class ServerpodCreateAppState extends ServerpodAppState<ServerpodCreateApp> {
  final _scrollController = ScrollController();
  final _logScrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _logScrollController.dispose();
    super.dispose();
  }

  @override
  Component buildApp(BuildContext context) {
    final state = component.holder.state;

    return Focusable(
      focused: true,
      onKeyEvent: _handleKeyEvent,
      child: MainScreen(
        name: component.name,
        holder: component.holder,
        logScrollController: _logScrollController,
        scrollController: _scrollController,
        onCreate: component.onCreate,
        onQuit: component.onQuit,
        onToggleHelp: () {
          state.showHelp = !state.showHelp;
          rebuild();
        },
      ),
    );
  }

  bool _handleKeyEvent(KeyboardEvent event) {
    final state = component.holder.state;

    if (event.logicalKey == LogicalKey.keyS) {
      component.onSkipFlutterBuild();
      return true;
    }

    // Dismiss help overlay.
    if (state.showHelp && event.logicalKey == LogicalKey.escape) {
      state.showHelp = false;
      rebuild();
      return true;
    }
    // When help is open, absorb all keys except H (toggle) and Q (quit).
    if (state.showHelp) return true;

    // Scrolling.
    final c = state.creatingProject ? _logScrollController : _scrollController;

    final quarter = c.viewportDimension / 4;
    final half = c.viewportDimension / 2;

    switch (event.logicalKey) {
      // Quarter screen (Shift+arrows) - before plain arrows.
      case LogicalKey.arrowUp when event.isShiftPressed:
        c.scrollUp(quarter);
      case LogicalKey.arrowDown when event.isShiftPressed:
        c.scrollDown(quarter);

      // Single line
      case LogicalKey.keyK:
        c.scrollUp();
      case LogicalKey.keyJ:
        c.scrollDown();

      // Half screen
      case LogicalKey.keyU:
        c.scrollUp(half);
      case LogicalKey.keyD:
        c.scrollDown(half);

      // Full screen
      case LogicalKey.pageUp || LogicalKey.backspace || LogicalKey.keyB:
        c.pageUp();
      case LogicalKey.pageDown || LogicalKey.space || LogicalKey.keyF:
        c.pageDown();

      // Start / end - G with shift = end, g without = start.
      case LogicalKey.keyG when event.isShiftPressed:
        c.scrollToEnd();
      case LogicalKey.home || LogicalKey.keyG:
        c.scrollToStart();
      case LogicalKey.end:
        c.scrollToEnd();

      default:
        return false;
    }
    return true;
  }
}
