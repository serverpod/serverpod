import 'dart:async';

import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/tui/app.dart';
import 'package:serverpod_cli/src/commands/tui/app_state_holder.dart';

import 'main_screen.dart';

import 'state.dart';

/// State holder for [ServerpodWatchApp].
class StartAppStateHolder extends ServerpodAppStateHolder<ServerWatchState> {
  StartAppStateHolder(this._state);

  final ServerWatchState _state;

  ServerpodWatchAppState? _widgetState;
  VoidCallback? _onHotReload;
  VoidCallback? _onCreateMigration;
  VoidCallback? _onApplyMigration;
  VoidCallback? _onQuit;

  @override
  ServerWatchState get state => _state;

  @override
  ServerpodAppState? get widgetState => _widgetState;

  @override
  void attach(ServerpodWatchAppState widgetState) {
    _widgetState = widgetState;
    widgetState.onHotReload = _onHotReload;
    widgetState.onCreateMigration = _onCreateMigration;
    widgetState.onApplyMigration = _onApplyMigration;
    widgetState.onQuit = _onQuit;
  }

  @override
  void detach(ServerpodWatchAppState widgetState) {
    if (_widgetState == widgetState) _widgetState = null;
  }

  set onHotReload(VoidCallback? cb) {
    _onHotReload = cb;
    _widgetState?.onHotReload = cb;
  }

  set onCreateMigration(VoidCallback? cb) {
    _onCreateMigration = cb;
    _widgetState?.onCreateMigration = cb;
  }

  set onApplyMigration(VoidCallback? cb) {
    _onApplyMigration = cb;
    _widgetState?.onApplyMigration = cb;
  }

  set onQuit(VoidCallback? cb) {
    _onQuit = cb;
    _widgetState?.onQuit = cb;
  }
}

/// Root TUI component for `serverpod start`.
class ServerpodWatchApp extends ServerpodApp<StartAppStateHolder> {
  const ServerpodWatchApp({
    super.key,
    required super.holder,
    required this.onReady,
  });

  final void Function(StartAppStateHolder holder) onReady;

  @override
  ServerpodAppState createState() => ServerpodWatchAppState();
}

class ServerpodWatchAppState extends ServerpodAppState<ServerpodWatchApp> {
  final logScrollController = ScrollController();
  final rawScrollController = ScrollController();
  final helpScrollController = ScrollController();

  /// Callbacks wired by the backend.
  VoidCallback? onHotReload;
  VoidCallback? onCreateMigration;
  VoidCallback? onApplyMigration;
  VoidCallback? onQuit;

  bool _minSplashElapsed = false;

  @override
  void initState() {
    super.initState();
    component.holder.attach(this);
    // Keep splash visible for at least 5 seconds.
    Timer(const Duration(seconds: 5), () {
      _minSplashElapsed = true;
      _tryDismissSplash();
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      component.onReady(component.holder);
    });
  }

  @override
  void dispose() {
    component.holder.detach(this);
    super.dispose();
  }

  void _tryDismissSplash() {
    final state = component.holder.state;
    if (_minSplashElapsed && state.serverReady && state.showSplash) {
      state.showSplash = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void rebuild() {
    _rebuild();
  }

  void _rebuild() {
    if (!mounted) return;
    _tryDismissSplash();
    setState(() {});
  }

  @override
  Component buildApp(BuildContext context) {
    final state = component.holder.state;

    return Focusable(
      focused: true,
      onKeyEvent: _handleKeyEvent,
      child: MainScreen(
        state: state,
        showSplash: state.showSplash,
        logScrollController: logScrollController,
        rawScrollController: rawScrollController,
        helpScrollController: helpScrollController,
        onToggleHelp: () {
          state.showHelp = !state.showHelp;
          _rebuild();
        },
        onTabChanged: (index) {
          state.selectedTab = index;
          _rebuild();
        },
        onHotReload: onHotReload,
        onCreateMigration: onCreateMigration,
        onApplyMigration: onApplyMigration,
        onQuit: onQuit,
      ),
    );
  }

  bool _handleKeyEvent(KeyboardEvent event) {
    final state = component.holder.state;

    if (state.showHelp) {
      if (event.logicalKey == LogicalKey.escape) {
        state.showHelp = false;
        _rebuild();
        return true;
      }
      // Route navigation keys to the help overlay's controller; absorb the
      // rest so they don't fall through to tab/scroll handling underneath.
      _handleScrollKey(helpScrollController, event);
      return true;
    }

    // Tab cycling: Tab and Right cycle forward, Left cycles back.
    const tabCount = 2;
    if (event.logicalKey == LogicalKey.tab ||
        event.logicalKey == LogicalKey.arrowRight) {
      state.selectedTab = (state.selectedTab + 1) % tabCount;
      _rebuild();
      return true;
    }
    if (event.logicalKey == LogicalKey.arrowLeft) {
      state.selectedTab = (state.selectedTab - 1 + tabCount) % tabCount;
      _rebuild();
      return true;
    }
    if (event.logicalKey == LogicalKey.digit1) {
      state.selectedTab = 0;
      _rebuild();
      return true;
    }
    if (event.logicalKey == LogicalKey.digit2) {
      state.selectedTab = 1;
      _rebuild();
      return true;
    }

    final c = state.selectedTab == 0
        ? logScrollController
        : rawScrollController;
    return _handleScrollKey(c, event);
  }

  /// Handles scroll keyboard [event] for [controller].
  ///
  /// When the controller is in reverse mode ([controller.isReversed]),
  /// up/down semantics are inverted.
  bool _handleScrollKey(ScrollController controller, KeyboardEvent event) {
    final reverse = controller.isReversed;
    final quarter = controller.viewportDimension / 4;
    final half = controller.viewportDimension / 2;

    void up([double amount = 1.0]) =>
        reverse ? controller.scrollDown(amount) : controller.scrollUp(amount);
    void down([double amount = 1.0]) =>
        reverse ? controller.scrollUp(amount) : controller.scrollDown(amount);
    void pageUp() => reverse ? controller.pageDown() : controller.pageUp();
    void pageDown() => reverse ? controller.pageUp() : controller.pageDown();
    void toStart() =>
        reverse ? controller.scrollToEnd() : controller.scrollToStart();
    void toEnd() =>
        reverse ? controller.scrollToStart() : controller.scrollToEnd();

    switch (event.logicalKey) {
      // Quarter screen (Shift+arrows) - before plain arrows.
      case LogicalKey.arrowUp when event.isShiftPressed:
        up(quarter);
      case LogicalKey.arrowDown when event.isShiftPressed:
        down(quarter);

      // Single line
      case LogicalKey.arrowUp || LogicalKey.keyK:
        up();
      case LogicalKey.arrowDown || LogicalKey.keyJ || LogicalKey.enter:
        down();

      // Half screen
      case LogicalKey.keyU:
        up(half);
      case LogicalKey.keyD:
        down(half);

      // Full screen
      case LogicalKey.pageUp || LogicalKey.backspace || LogicalKey.keyB:
        pageUp();
      case LogicalKey.pageDown || LogicalKey.space || LogicalKey.keyF:
        pageDown();

      // Start / end - G with shift = end, g without = start.
      case LogicalKey.keyG when event.isShiftPressed:
        toEnd();
      case LogicalKey.home || LogicalKey.keyG:
        toStart();
      case LogicalKey.end:
        toEnd();

      default:
        return false;
    }
    return true;
  }
}
