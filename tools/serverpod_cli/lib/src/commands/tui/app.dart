import 'dart:async';

import 'package:meta/meta.dart';
import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/tui/app_state_holder.dart';
import 'package:serverpod_cli/src/commands/tui/components/spinner.dart';

/// A root TUI component.
abstract class ServerpodApp<T extends ServerpodAppStateHolder>
    extends StatefulComponent {
  const ServerpodApp({super.key, required this.holder});

  final T holder;

  @override
  ServerpodAppState<ServerpodApp> createState();
}

/// The logic and internal state for a [ServerpodApp].
abstract class ServerpodAppState<S extends ServerpodApp> extends State<S> {
  @override
  void initState() {
    super.initState();
    component.holder.attach(this);
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void dispose() {
    component.holder.detach(this);
    super.dispose();
  }

  void rebuild() {
    setState(() {});
  }

  /// Describes the part of the user interface represented by this component.
  Component buildApp(BuildContext context);

  @override
  @protected
  Component build(BuildContext context) {
    final state = component.holder.state;

    return NoctermApp(
      child: Builder(
        builder: (context) {
          final themeData = TuiTheme.of(context);
          return TuiTheme(
            data: themeData.copyWith(
              background: Color.defaultColor,
            ),
            child: SpinnerScope(
              active: state.activeOperations.isNotEmpty,
              child: buildApp(context),
            ),
          );
        },
      ),
    );
  }
}

/// Ctrl-C handling shared by the Serverpod TUIs: copy the current selection if
/// there is one, otherwise require a second press within [_exitArmWindow] to
/// quit. Reads and writes [ServerpodState.selectedText] and
/// [ServerpodState.ctrlCHint].
mixin CtrlCExitHandler<S extends ServerpodApp> on ServerpodAppState<S> {
  static const _exitArmWindow = Duration(seconds: 2);

  bool _exitArmed = false;
  Timer? _exitArmTimer;
  Timer? _hintClearTimer;

  /// Runs the graceful shutdown when a second Ctrl-C confirms exit.
  void onCtrlCQuit();

  /// Handles [event] when it is Ctrl-C, returning true so callers can
  /// `if (handleCtrlC(event)) return true;` from their key handler.
  ///
  /// Always returns true for Ctrl-C so nocterm's signal handler never falls
  /// back to its abrupt default shutdown, which would bypass backend cleanup.
  /// Exit goes through [onCtrlCQuit].
  bool handleCtrlC(KeyboardEvent event) {
    if (event.logicalKey != LogicalKey.keyC || !event.isControlPressed) {
      return false;
    }

    final state = component.holder.state;

    if (state.selectedText.isNotEmpty) {
      ClipboardManager.copy(state.selectedText);
      _disarmExit();
      _showHint('Copied to clipboard', autoClear: true);
      return true;
    }

    if (_exitArmed) {
      _disarmExit();
      onCtrlCQuit();
      return true;
    }

    _exitArmed = true;
    _showHint('Press Ctrl-C again to exit', autoClear: false);
    _exitArmTimer?.cancel();
    _exitArmTimer = Timer(_exitArmWindow, () {
      _exitArmed = false;
      _clearHint();
    });
    return true;
  }

  /// Cancels pending timers. Call from the host state's [dispose].
  void disposeCtrlC() {
    _exitArmTimer?.cancel();
    _hintClearTimer?.cancel();
  }

  void _showHint(String message, {required bool autoClear}) {
    component.holder.state.ctrlCHint = message;
    _hintClearTimer?.cancel();
    if (autoClear) _hintClearTimer = Timer(_exitArmWindow, _clearHint);
    rebuild();
  }

  void _clearHint() {
    component.holder.state.ctrlCHint = null;
    rebuild();
  }

  void _disarmExit() {
    _exitArmed = false;
    _exitArmTimer?.cancel();
  }
}
