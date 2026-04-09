import 'package:nocterm/nocterm.dart';

import 'loading_screen.dart';
import 'main_screen.dart';
import 'state.dart';

/// Root TUI component for `serverpod start`.
///
/// Uses a [GlobalKey] so the backend can retrieve the state handle via
/// [GlobalKey.currentState] after the first frame has been rendered.
/// The [onReady] callback fires after the first frame, when [setState]
/// is safe to call.
class ServerpodWatchApp extends StatefulComponent {
  const ServerpodWatchApp({
    super.key,
    required this.initialState,
    required this.onReady,
  });

  final ServerWatchState initialState;
  final void Function(ServerpodWatchAppState appState) onReady;

  @override
  State<ServerpodWatchApp> createState() => ServerpodWatchAppState();
}

class ServerpodWatchAppState extends State<ServerpodWatchApp> {
  late final ServerWatchState _state;

  /// Callbacks wired by the backend.
  VoidCallback? onHotReload;
  VoidCallback? onCreateMigration;
  VoidCallback? onApplyMigration;
  VoidCallback? onQuit;

  @override
  void initState() {
    super.initState();
    _state = component.initialState;
    // Schedule the onReady callback after the first frame is fully rendered.
    // At that point the element is mounted and setState is safe.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      component.onReady(this);
    });
  }

  ServerWatchState get state => _state;

  /// Whether this state is still mounted in the component tree.
  /// Guards against setState calls after the TUI has started tearing down.
  bool get isMounted => mounted;

  void _safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  // -- State mutation methods called from the backend --

  void setSplashStage(String? stage) {
    _safeSetState(() => _state.splashStage = stage);
  }

  void addStructuredLog({
    required TuiLogLevel level,
    required DateTime timestamp,
    required String message,
  }) {
    _safeSetState(() {
      _state.logHistory.add(
        TuiLogEntry(
          timestamp: timestamp,
          level: level,
          message: message,
        ),
      );
      if (_state.logHistory.length > ServerWatchState.maxLogEntries) {
        _state.logHistory.removeAt(0);
      }
    });
  }

  void addRawLine(String line) {
    _safeSetState(() {
      _state.rawLines.add(line);
      if (_state.rawLines.length > ServerWatchState.maxRawLines) {
        _state.rawLines.removeAt(0);
      }
    });
  }

  void startTrackedOperation({
    required String id,
    required String label,
    DateTime? timestamp,
  }) {
    _safeSetState(() {
      _state.activeOperations[id] = TrackedOperation(
        id: id,
        label: label,
        startTime: timestamp ?? DateTime.now(),
      );
    });
  }

  void addOperationEntry({
    required String sessionId,
    required String message,
    TuiLogLevel? level,
    double? duration,
    DateTime? timestamp,
  }) {
    _safeSetState(() {
      final op = _state.activeOperations[sessionId];
      if (op != null) {
        op.entries.add(
          OperationSubEntry(
            timestamp: timestamp ?? DateTime.now(),
            message: message,
            level: level,
            duration: duration,
          ),
        );
      }
    });
  }

  void endTrackedOperation({
    required String id,
    required bool success,
    double? duration,
  }) {
    _safeSetState(() {
      final op = _state.activeOperations.remove(id);
      if (op != null) {
        final elapsed = duration != null
            ? Duration(microseconds: (duration * 1000000).round())
            : DateTime.now().difference(op.startTime);
        _state.logHistory.add(
          CompletedOperation(
            label: op.label,
            success: success,
            duration: elapsed,
            entries: op.entries,
          ),
        );
        if (_state.logHistory.length > ServerWatchState.maxLogEntries) {
          _state.logHistory.removeAt(0);
        }
      }
    });
  }

  void setSelectedTab(int index) {
    _safeSetState(() => _state.selectedTab = index);
  }

  @override
  Component build(BuildContext context) {
    if (_state.splashStage != null) {
      return LoadingScreen(stage: _state.splashStage!);
    }

    return Focusable(
      focused: true,
      onKeyEvent: _handleKeyEvent,
      child: MainScreen(
        state: _state,
        onTabChanged: setSelectedTab,
        onHotReload: onHotReload,
        onCreateMigration: onCreateMigration,
        onApplyMigration: onApplyMigration,
        onQuit: onQuit,
      ),
    );
  }

  bool _handleKeyEvent(KeyboardEvent event) {
    if (event.logicalKey == LogicalKey.tab) {
      setSelectedTab((_state.selectedTab + 1) % 2);
      return true;
    }
    if (event.logicalKey == LogicalKey.digit1) {
      setSelectedTab(0);
      return true;
    }
    if (event.logicalKey == LogicalKey.digit2) {
      setSelectedTab(1);
      return true;
    }
    return false;
  }
}
