import 'dart:async';

import 'package:nocterm/nocterm.dart';

import 'main_screen.dart';
import 'serverpod_theme.dart';
import 'state.dart';

/// Provides access to the shared [ServerWatchState] and a way to trigger
/// rebuilds on the currently mounted [ServerpodWatchAppState].
///
/// The backend mutates [state] directly, then calls [markDirty] to schedule
/// a rebuild. This avoids proxying every mutation method and survives
/// `NoctermApp` rebuilds that recreate the widget state.
class AppStateHolder {
  AppStateHolder(this.state);

  final ServerWatchState state;
  ServerpodWatchAppState? _widgetState;

  void _attach(ServerpodWatchAppState s) => _widgetState = s;
  void _detach(ServerpodWatchAppState s) {
    if (_widgetState == s) _widgetState = null;
  }

  /// Trigger a rebuild on the currently mounted state.
  void markDirty() => _widgetState?._rebuild();

  set onHotReload(VoidCallback? cb) => _widgetState?.onHotReload = cb;
  set onCreateMigration(VoidCallback? cb) =>
      _widgetState?.onCreateMigration = cb;
  set onApplyMigration(VoidCallback? cb) => _widgetState?.onApplyMigration = cb;
  set onQuit(VoidCallback? cb) => _widgetState?.onQuit = cb;
}

/// Root TUI component for `serverpod start`.
class ServerpodWatchApp extends StatefulComponent {
  const ServerpodWatchApp({
    super.key,
    required this.holder,
    required this.onReady,
  });

  final AppStateHolder holder;
  final void Function(AppStateHolder holder) onReady;

  @override
  State<ServerpodWatchApp> createState() => ServerpodWatchAppState();
}

class ServerpodWatchAppState extends State<ServerpodWatchApp> {
  final logScrollController = ScrollController();
  final rawScrollController = ScrollController();

  /// Callbacks wired by the backend.
  VoidCallback? onHotReload;
  VoidCallback? onCreateMigration;
  VoidCallback? onApplyMigration;
  VoidCallback? onQuit;

  bool _minSplashElapsed = false;

  @override
  void initState() {
    super.initState();
    component.holder._attach(this);
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
    component.holder._detach(this);
    super.dispose();
  }

  void _tryDismissSplash() {
    final state = component.holder.state;
    if (_minSplashElapsed && state.serverReady && state.showSplash) {
      state.showSplash = false;
      if (mounted) setState(() {});
    }
  }

  void _rebuild() {
    if (!mounted) return;
    _tryDismissSplash();
    setState(() {});
  }

  @override
  Component build(BuildContext context) {
    final state = component.holder.state;

    return ServerpodTheme(
      data: ServerpodThemeData.dark,
      child: Focusable(
        focused: true,
        onKeyEvent: _handleKeyEvent,
        child: MainScreen(
          state: state,
          showSplash: state.showSplash,
          logScrollController: logScrollController,
          rawScrollController: rawScrollController,
          onTabChanged: (index) {
            state.selectedTab = index;
            _rebuild();
          },
          onHotReload: onHotReload,
          onCreateMigration: onCreateMigration,
          onApplyMigration: onApplyMigration,
          onQuit: onQuit,
        ),
      ),
    );
  }

  bool _handleKeyEvent(KeyboardEvent event) {
    final state = component.holder.state;
    if (event.logicalKey == LogicalKey.tab) {
      state.selectedTab = (state.selectedTab + 1) % 2;
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
    // Vim-style scroll: j/k
    final controller = state.selectedTab == 0
        ? logScrollController
        : rawScrollController;
    if (event.logicalKey == LogicalKey.keyJ) {
      controller.scrollDown(1.0);
      return true;
    }
    if (event.logicalKey == LogicalKey.keyK) {
      controller.scrollUp(1.0);
      return true;
    }

    return false;
  }
}
