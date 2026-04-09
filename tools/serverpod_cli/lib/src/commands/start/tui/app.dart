import 'dart:async';

import 'package:nocterm/nocterm.dart';

import 'loading_screen.dart';
import 'main_screen.dart';
import 'state.dart';

/// Root TUI component for `serverpod start`.
///
/// Takes an initial state and a [Completer] that is completed with the app
/// state handle once [initState] fires. The backend callback then uses this
/// handle to push state changes via [setState].
class ServerpodWatchApp extends StatefulComponent {
  const ServerpodWatchApp({
    super.key,
    required this.initialState,
    required this.stateCompleter,
  });

  final ServerWatchState initialState;
  final Completer<ServerpodWatchAppState> stateCompleter;

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
    component.stateCompleter.complete(this);
  }

  ServerWatchState get state => _state;

  // -- State mutation methods called from the backend --

  void setSplashStage(String? stage) {
    setState(() => _state.splashStage = stage);
  }

  void addStructuredLog({
    required TuiLogLevel level,
    required DateTime timestamp,
    required String message,
  }) {
    setState(() {
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
    setState(() {
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
    setState(() {
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
    setState(() {
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
    setState(() {
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
    setState(() => _state.selectedTab = index);
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
