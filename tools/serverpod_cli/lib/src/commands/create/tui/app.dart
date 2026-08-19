import 'dart:math' as math;

import 'package:nocterm/nocterm.dart' hide LogEntry;
import 'package:serverpod_cli/src/commands/create/tui/main_screen.dart';
import 'package:serverpod_cli/src/commands/create/tui/state_holder.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

/// Root TUI component for `serverpod create`.
class ServerpodCreateApp extends TuiApp<CreateAppStateHolder> {
  const ServerpodCreateApp({
    super.key,
    required super.holder,
    required this.onCreate,
    required this.onQuit,
    this.isUpgrade = false,
  });

  final VoidCallback onCreate;
  final VoidCallback onQuit;

  /// Whether the app was launched to upgrade a project.
  final bool isUpgrade;

  @override
  TuiAppState createState() => ServerpodCreateAppState();
}

class ServerpodCreateAppState extends TuiAppState<ServerpodCreateApp> {
  final _scrollController = ScrollController();
  final _logScrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _logScrollController.dispose();
    super.dispose();
  }

  @override
  void onExit() => component.onQuit();

  Component _buildMainScreen() {
    return Focusable(
      focused: true,
      // Pass all keys through to the form fields below.
      onKeyEvent: (_) => false,
      child: MainScreen(
        holder: component.holder,
        logScrollController: _logScrollController,
        scrollController: _scrollController,
        onCreate: component.onCreate,
        onQuit: component.onQuit,
        isUpgrade: component.isUpgrade,
      ),
    );
  }

  @override
  Component buildApp(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 80 || constraints.maxHeight > 24) {
          return Container(
            color: Color.defaultColor,
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints.tight(
                Size(
                  math.min(constraints.maxWidth, 80),
                  math.min(constraints.maxHeight, 24),
                ),
              ),
              child: _buildMainScreen(),
            ),
          );
        }
        return _buildMainScreen();
      },
    );
  }
}
