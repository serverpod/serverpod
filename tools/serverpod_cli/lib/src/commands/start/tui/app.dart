import 'dart:async';

import 'package:nocterm/nocterm.dart' hide LogEntry;
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

import 'inspectable_scroll_controller.dart';
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
  void Function(int index)? _onStopApp;
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
    widgetState.onStopApp = _onStopApp;
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

  set onStopApp(void Function(int index)? cb) {
    _onStopApp = cb;
    _widgetState?.onStopApp = cb;
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
  final appPanelScrollController = ScrollController();

  /// Callbacks wired by the backend.
  VoidCallback? onHotReload;
  VoidCallback? onHotRestart;
  VoidCallback? onRestartFlutterApp;
  void Function(int index)? onLaunchApp;
  void Function(int index)? onStopApp;
  void Function({bool force})? onCreateMigration;
  void Function({bool force})? onCreateRepairMigration;
  VoidCallback? onApplyMigration;
  VoidCallback? onQuit;

  bool _minSplashElapsed = false;

  /// Auto-closes the launch panel a while after the last interaction, so a user
  /// launching or browsing several apps keeps the panel open until they pause.
  Timer? _launchPanelCloseTimer;

  static const _launchPanelCloseDelay = Duration(seconds: 3);

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
    _launchPanelCloseTimer?.cancel();
    component.holder.detach(this);
    rawScrollController.dispose();
    helpScrollController.dispose();
    appPanelScrollController.dispose();
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

  /// Launches the [index]th app and arms the launch-panel auto-close.
  void _launchApp(int index) {
    onLaunchApp?.call(index);
    _scheduleLaunchPanelClose();
    _rebuild();
  }

  /// (Re)starts the launch-panel auto-close countdown, so any interaction while
  /// the panel is open (launching or navigating) pushes the dismissal back.
  void _scheduleLaunchPanelClose() {
    _launchPanelCloseTimer?.cancel();
    _launchPanelCloseTimer = Timer(_launchPanelCloseDelay, () {
      final state = component.holder.state;
      if (state.showLaunchPanel) {
        state.showLaunchPanel = false;
        _rebuild();
      }
    });
  }

  /// Pushes the auto-close back only when it is already counting down, so
  /// navigating a panel that was opened without launching never arms it.
  void _bumpLaunchPanelCloseTimer() {
    if (_launchPanelCloseTimer?.isActive ?? false) {
      _scheduleLaunchPanelClose();
    }
  }

  /// Scrolls the log view holding [entry] so it stays in view after its
  /// stack trace expanded or collapsed via the clickable affordance.
  ///
  /// Expanding grows the entry downwards (towards newer entries), which in the
  /// bottom-anchored log view shoves the clicked line up - past the top edge
  /// for a long trace. Collapsing does the reverse and can drop the entry
  /// below the viewport when scrolled up. Runs after the toggle's frame so the
  /// re-laid-out geometry is measured, then scrolls just enough to keep the
  /// entry on screen; an entry taller than the viewport is pinned with its
  /// message and affordance line at the top and the trace filling the rest.
  void _keepToggledEntryInView(LogEntry entry) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final located = _locateLogEntry(entry);
      if (located == null) return;
      final (items, controller) = located;

      // The list renders newest-first (`reverse: true`), so builder index 0
      // is the last history item. Resolved inside the callback: entries
      // arriving during the toggle's frame shift the index.
      final itemIndex = items.lastIndexOf(entry);
      if (itemIndex < 0) return;
      final builderIndex = items.length - 1 - itemIndex;

      final geometry = controller.itemOffsetAndExtent(builderIndex);
      if (geometry == null) return;
      final (itemOffset, itemExtent) = geometry;

      if (itemExtent > controller.viewportDimension) {
        // In the reversed list the item's scroll-space end is its visual top.
        controller.jumpTo(
          itemOffset + itemExtent - controller.viewportDimension,
        );
      } else {
        controller.ensureVisible(
          itemOffset: itemOffset,
          itemExtent: itemExtent,
        );
      }
    });
  }

  /// Finds the log history and scroll controller of the view showing [entry]:
  /// the server log or one of the app log tabs. Null when the entry has been
  /// evicted from every history.
  (List<Object>, InspectableScrollController)? _locateLogEntry(LogEntry entry) {
    final state = component.holder.state;
    if (state.logHistory.contains(entry)) {
      return (state.logHistory, state.serverLogTab.scrollController);
    }
    for (final tab in state.appsTabArea?.tabs ?? const <PaneTab>[]) {
      if (tab is AppLogTab && tab.logHistory.contains(entry)) {
        return (tab.logHistory, tab.scrollController);
      }
    }
    return null;
  }

  /// Stops [tab]'s app while it is running or launching - the tab stays so its
  /// marker flips to stopped and it can be relaunched - and once stopped closes
  /// the tab, refocusing the last remaining app tab. Bound to the `X` key and
  /// the clickable `X Stop App`/`X Close Tab` status-line hint. Returns whether
  /// it acted, so the key handler can fall through when the tab is in neither
  /// state.
  bool _stopOrCloseAppTab(AppLogTab tab) {
    final state = component.holder.state;
    final appId = tab.appId;
    final running = state.isAppRunning?.call(appId) ?? false;
    final launching = state.isAppLaunching?.call(appId) ?? false;

    if (running || launching) {
      final index = state.launchableApps.indexWhere((a) => a.id == appId);
      if (index < 0) return false;
      onStopApp?.call(index);
      _rebuild();
      return true;
    }

    if (tab.stopped) {
      state.removeAppLogTab(appId);
      final lastTab = state.appsTabArea?.tabs.whereType<AppLogTab>().lastOrNull;
      if (lastTab == null) {
        state.launchPanelIndex = 0;
      } else {
        state.tabs.focusTab(lastTab);
        state.launchPanelIndex = state.launchableApps.indexWhere(
          (a) => a.id == lastTab.appId,
        );
      }
      _rebuild();
      return true;
    }

    return false;
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
      child: GestureDetector(
        onTap: () {
          if (state.showHelp) {
            state.showHelp = false;
            _rebuild();
          }
        },
        child: MainScreen(
          state: state,
          showSplash: state.showSplash,
          rawScrollController: rawScrollController,
          helpScrollController: helpScrollController,
          appPanelScrollController: appPanelScrollController,
          onToggleHelp: () {
            state.showHelp = !state.showHelp;
            _rebuild();
          },
          onTabSelected: _rebuild,
          onHotReload: onHotReload,
          onHotRestart: onHotRestart,
          onCreateMigration: onCreateMigration,
          onApplyMigration: onApplyMigration,
          onClearLogs: () {
            state.clearLogs();
            _rebuild();
          },
          onLaunchApp: _launchApp,
          onQuit: onQuit,
          onCopyAlert: copyAlert,
          onDismissAlert: dismissAlert,
          onStopOrCloseAppTab: _stopOrCloseAppTab,
          onToggleStackTrace: (entry) {
            state.toggleStackTrace(entry);
            _rebuild();
            _keepToggledEntryInView(entry);
          },
        ),
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

    // 'x' acts on the active Flutter app tab.
    if (event.logicalKey == LogicalKey.keyX) {
      final activeTab = state.appsTabArea?.selected;
      if (activeTab is AppLogTab && _stopOrCloseAppTab(activeTab)) {
        return true;
      }
    }

    if (state.showLaunchPanel) {
      final appCount = state.launchableApps.length;

      if (event.logicalKey == LogicalKey.escape ||
          (event.logicalKey == LogicalKey.keyR && event.isControlPressed)) {
        _launchPanelCloseTimer?.cancel();
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
        _bumpLaunchPanelCloseTimer();
        _rebuild();
        return true;
      }
      if (appCount > 0 &&
          (event.logicalKey == LogicalKey.arrowDown ||
              event.logicalKey == LogicalKey.keyJ)) {
        state.launchPanelIndex = (state.launchPanelIndex + 1) % appCount;
        _bumpLaunchPanelCloseTimer();
        _rebuild();
        return true;
      }
      // Enter launches the focused row.
      if (event.logicalKey == LogicalKey.enter &&
          state.launchPanelIndex < appCount) {
        _launchApp(state.launchPanelIndex);
        return true;
      }
      // Number keys remain shortcuts for the first nine apps.
      final digitIndex = _digitIndex(event.logicalKey);
      if (digitIndex != null && digitIndex < appCount && digitIndex < 9) {
        _launchApp(digitIndex);
        return true;
      }
    }

    if (state.showRawServerLogs) {
      if (event.logicalKey == LogicalKey.escape ||
          event.logicalKey == LogicalKey.backquote ||
          event.logicalKey == LogicalKey.keyS) {
        state.showRawServerLogs = false;
        _rebuild();
        return true;
      }
      if (event.logicalKey == LogicalKey.keyC && event.isControlPressed) {
        return false;
      }
      if (_handleScrollKey(rawScrollController, event)) {
        return true;
      }
    }

    // Ctrl+R: full relaunch of the selected Flutter app (kill `flutter run` and
    // re-spawn it) or launch it if it isn't running yet (e.g. after starting
    // with `--no-flutter`). Handled here rather than as a ButtonBar entry
    // because the Button widget matches only plain/Shift keys. Always consumed
    // so it never falls through to the plain-R hot reload / restart.
    // 0 apps inert; >0 toggle launch panel.
    if (event.logicalKey == LogicalKey.keyR && event.isControlPressed) {
      if (!state.canLaunchApps) return true;
      // Toggling the panel resets any pending auto-close so a freshly opened
      // panel is never dismissed by a timer from a previous launch.
      _launchPanelCloseTimer?.cancel();
      state.showLaunchPanel = !state.showLaunchPanel;
      if (state.showLaunchPanel) {
        state.launchPanelIndex = state.activeLaunchableIndex;
      }
      _rebuild();
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
    if (event.logicalKey == LogicalKey.keyE &&
        (focusedTab is ServerLogTab || focusedTab is AppLogTab)) {
      state.toggleAllStackTraces();
      _rebuild();
      return true;
    }

    if (event.logicalKey == LogicalKey.backquote ||
        event.logicalKey == LogicalKey.keyS) {
      state.showRawServerLogs = true;
      _rebuild();
      return true;
    }

    // Repair migration (Shift for force). Not shown in the bottom bar; it is
    // documented on the help screen instead.
    if (event.logicalKey == LogicalKey.keyP &&
        !event.isControlPressed &&
        !event.isAltPressed &&
        !event.isMetaPressed &&
        state.serverReady &&
        !state.actionBusy) {
      onCreateRepairMigration?.call(force: event.isShiftPressed);
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
