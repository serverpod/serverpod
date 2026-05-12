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
      ),
    );
  }

  bool _handleKeyEvent(KeyboardEvent event) {
    if (event.logicalKey == LogicalKey.keyS) {
      component.onSkipFlutterBuild();
      return true;
    }

    return false;
  }
}
