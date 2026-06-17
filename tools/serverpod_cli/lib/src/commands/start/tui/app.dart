import 'dart:async';

import 'package:nocterm/nocterm.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

import 'main_screen.dart';

import 'state.dart';
import 'tab_model.dart';

/// State holder for [ServerpodWatchApp].
class StartAppStateHolder extends TuiAppStateHolder<ServerWatchState> {
  StartAppStateHolder(this._state);

  final ServerWatchState _state;

  ServerpodWatchAppState? _widgetState;
  VoidCallback? _onHotReload;
  VoidCallback? _onHotRestart;
  VoidCallback? _onRestartFlutterApp;
  void Function(int index)? _onLaunchApp;
  void Function({bool force})? _onCreateMigration;
  void Function({bool force})? _onCreateRepairMigration;
  VoidCallback? _onApplyMigration;
  VoidCallback? _onQuit;

  @override
  ServerWatchState get state => _state;

  @override
  TuiAppState? get widgetState => _widgetState;

  @override
  void attach(ServerpodWatchAppState widgetState) {
    _widgetState = widgetState;
    widgetState.onHotReload = _onHotReload;
    widgetState.onHotRestart = _onHotRestart;
    widgetState.onRestartFlutterApp = _onRestartFlutterApp;
    widgetState.onLaunchApp = _onLaunchApp;
    widgetState.onCreateMigration = _onCreateMigration;
    widgetState.onCreateRepairMigration = _onCreateRepairMigration;
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

  set onHotRestart(VoidCallback? cb) {
    _onHotRestart = cb;
    _widgetState?.onHotRestart = cb;
  }

  set onRestartFlutterApp(VoidCallback? cb) {
    _onRestartFlutterApp = cb;
    _widgetState?.onRestartFlutterApp = cb;
  }

  set onLaunchApp(void Function(int index)? cb) {
    _onLaunchApp = cb;
    _widgetState?.onLaunchApp = cb;
  }

  set onCreateMigration(void Function({bool force})? cb) {
    _onCreateMigration = cb;
    _widgetState?.onCreateMigration = cb;
  }

  set onCreateRepairMigration(void Function({bool force})? cb) {
    _onCreateRepairMigration = cb;
    _widgetState?.onCreateRepairMigration = cb;
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
class ServerpodWatchApp extends TuiApp<StartAppStateHolder> {
  const ServerpodWatchApp({
    super.key,
    required super.holder,
    required this.onReady,
  });

  final void Function(StartAppStateHolder holder) onReady;

  @override
  TuiAppState createState() => ServerpodWatchAppState();
}

class ServerpodWatchAppState extends TuiAppState<ServerpodWatchApp> {
  final rawScrollController = ScrollController();
  final helpScrollController = ScrollController();

  /// Callbacks wired by the backend.
  VoidCallback? onHotReload;
  VoidCallback? onHotRestart;
  VoidCallback? onRestartFlutterApp;
  void Function(int index)? onLaunchApp;
  void Function({bool force})? onCreateMigration;
  void Function({bool force})? onCreateRepairMigration;
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
    if (_minSplashElapsed && state.showSplash) {
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
  void onExit() {
    final quit = onQuit;
    if (quit != null) {
      quit();
    } else {
      super.onExit();
    }
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
        rawScrollController: rawScrollController,
        helpScrollController: helpScrollController,
        onToggleHelp: () {
          state.showHelp = !state.showHelp;
          _rebuild();
        },
        onHotReload: onHotReload,
        onHotRestart: onHotRestart,
        onCreateMigration: onCreateMigration,
        onCreateRepairMigration: onCreateRepairMigration,
        onApplyMigration: onApplyMigration,
        onClearLogs: () {
          state.clearLogs();
          _rebuild();
        },
        onLaunchApp: (index) {
          onLaunchApp?.call(index);
          // Mirror the keyboard path: a click also dismisses the panel.
          state.showLaunchPanel = false;
          _rebuild();
        },
        onTabSelected: _rebuild,
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
      // Let Ctrl-C bubble to the base TuiAppState so copy/exit still work.
      if (event.logicalKey == LogicalKey.keyC && event.isControlPressed) {
        return false;
      }
      // Route navigation keys to the help overlay's controller; absorb the
      // rest so they don't fall through to tab/scroll handling underneath.
      _handleScrollKey(helpScrollController, event);
      return true;
    }

    if (state.showRawServerLogs) {
      if (event.logicalKey == LogicalKey.escape ||
          event.logicalKey == LogicalKey.backquote ||
          event.logicalKey == LogicalKey.period) {
        state.showRawServerLogs = false;
        _rebuild();
        return true;
      }
      if (event.logicalKey == LogicalKey.keyC && event.isControlPressed) {
        return false;
      }
      _handleScrollKey(rawScrollController, event);
      return true;
    }

    if (state.showLaunchPanel) {
      final appCount = state.launchableApps.length;

      if (event.logicalKey == LogicalKey.escape ||
          (event.logicalKey == LogicalKey.keyR && event.isControlPressed)) {
        state.showLaunchPanel = false;
        _rebuild();
        return true;
      }
      // Cursor navigation (arrows or vim-style j/k), wrapping at the ends.
      if (appCount > 0 &&
          (event.logicalKey == LogicalKey.arrowUp ||
              event.logicalKey == LogicalKey.keyK)) {
        state.launchPanelIndex =
            (state.launchPanelIndex - 1 + appCount) % appCount;
        _rebuild();
        return true;
      }
      if (appCount > 0 &&
          (event.logicalKey == LogicalKey.arrowDown ||
              event.logicalKey == LogicalKey.keyJ)) {
        state.launchPanelIndex = (state.launchPanelIndex + 1) % appCount;
        _rebuild();
        return true;
      }
      // Enter launches the focused row.
      if (event.logicalKey == LogicalKey.enter &&
          state.launchPanelIndex < appCount) {
        onLaunchApp?.call(state.launchPanelIndex);
        state.showLaunchPanel = false;
        _rebuild();
        return true;
      }
      // Number keys remain shortcuts for the first nine apps.
      final digitIndex = _digitIndex(event.logicalKey);
      if (digitIndex != null && digitIndex < appCount && digitIndex < 9) {
        onLaunchApp?.call(digitIndex);
        state.showLaunchPanel = false;
        _rebuild();
        return true;
      }
      return true;
    }

    // Ctrl+R: 0 apps inert; 1 app direct action; >1 toggle launch panel.
    if (event.logicalKey == LogicalKey.keyR && event.isControlPressed) {
      if (!state.canLaunchApps) return true;
      if (state.launchableApps.length <= 1) {
        onRestartFlutterApp?.call();
      } else {
        state.showLaunchPanel = !state.showLaunchPanel;
        if (state.showLaunchPanel) {
          state.launchPanelIndex = state.activeLaunchableIndex;
        }
        _rebuild();
      }
      return true;
    }

    // Tab, arrows, and digits share one global tab order. Side-by-side mode
    // skips single-tab areas during cycling (the server pane stays visible);
    // digit shortcuts always jump by index across every tab.
    final sideBySide = state.useSideBySideLayout;
    if (event.logicalKey == LogicalKey.arrowLeft) {
      state.tabs.cycleTabs(-1, sideBySide: sideBySide);
      _rebuild();
      return true;
    }
    if (event.logicalKey == LogicalKey.arrowRight) {
      state.tabs.cycleTabs(1, sideBySide: sideBySide);
      _rebuild();
      return true;
    }
    if (event.matches(LogicalKey.tab, shift: false)) {
      state.tabs.cycleTabs(1, sideBySide: sideBySide);
      _rebuild();
      return true;
    }
    if (event.matches(LogicalKey.tab, shift: true)) {
      state.tabs.cycleTabs(-1, sideBySide: sideBySide);
      _rebuild();
      return true;
    }

    final digitIndex = _digitIndex(event.logicalKey);
    if (digitIndex != null) {
      state.tabs.selectAllTabs(digitIndex);
      _rebuild();
      return true;
    }

    final focusedTab = state.tabs.focusedTab;
    if (event.logicalKey == LogicalKey.keyE && focusedTab is ServerLogTab) {
      state.expandStackTraces = !state.expandStackTraces;
      _rebuild();
      return true;
    }

    if (event.logicalKey == LogicalKey.backquote ||
        event.logicalKey == LogicalKey.period) {
      state.showRawServerLogs = true;
      _rebuild();
      return true;
    }

    final scrollController =
        focusedTab?.scrollController ?? state.serverLogTab.scrollController;
    return _handleScrollKey(scrollController, event);
  }

  int? _digitIndex(LogicalKey key) {
    return switch (key) {
      LogicalKey.digit1 => 0,
      LogicalKey.digit2 => 1,
      LogicalKey.digit3 => 2,
      LogicalKey.digit4 => 3,
      LogicalKey.digit5 => 4,
      LogicalKey.digit6 => 5,
      LogicalKey.digit7 => 6,
      LogicalKey.digit8 => 7,
      LogicalKey.digit9 => 8,
      _ => null,
    };
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
