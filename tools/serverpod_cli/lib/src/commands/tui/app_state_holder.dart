import 'dart:async';

import 'package:meta/meta.dart';
import 'package:serverpod_cli/src/commands/tui/app.dart';
import 'package:serverpod_cli/src/commands/tui/state.dart';
import 'package:stream_transform/stream_transform.dart';

/// Provides access to the shared [ServerpodState] and a way to trigger
/// rebuilds on the currently mounted [ServerpodAppState].
///
/// The backend mutates [state] directly, then calls [markDirty] to schedule
/// a rebuild. This avoids proxying every mutation method and survives
/// `NoctermApp` rebuilds that recreate the widget state.
abstract class ServerpodAppStateHolder<S extends ServerpodState> {
  ServerpodAppStateHolder() {
    _dirtySub = _dirtyController.stream
        .throttle(_rebuildInterval, trailing: true)
        .listen((_) => widgetState?.rebuild());
  }

  final StreamController<void> _dirtyController = StreamController<void>();
  late final StreamSubscription<void> _dirtySub;

  /// Shared state that can be mutated.
  S get state;

  /// The currently mounted widget state, if not null;
  /// This is used to trigger rebuilds.
  ServerpodAppState? get widgetState;

  /// Throttle window for [markDirty]. A trickle of log events from an
  /// idle `--verbose` pod (health checks, session logs, VM extension
  /// events) would otherwise drive one `setState` per event and
  /// consume a full CPU core. `trailing: true` means the first mark
  /// in a window renders immediately (keypresses stay responsive),
  /// and any further marks inside the window coalesce into a single
  /// trailing rebuild so the final state is never missed.
  ///
  /// 80ms matches the spinner tick cadence - faster rebuilds aren't
  /// perceptible since the spinner is the fastest-moving element on
  /// screen. At ~7ms/frame (layout+paint dominated), 12.5 FPS keeps
  /// the CPU floor around ~9% vs ~21% at 30 FPS.
  static const _rebuildInterval = Duration(milliseconds: 80);

  /// Attaches to a mounted widget state.
  void attach(covariant ServerpodAppState widgetState);

  /// Detaches from an unmounted widget state.
  void detach(covariant ServerpodAppState widgetState);

  /// Schedule a rebuild on the currently mounted state. Coalesced
  /// via a throttled stream; see [_rebuildInterval].
  @mustCallSuper
  void markDirty() => _dirtyController.add(null);

  /// Releases the dirty-event stream. The holder typically lives for
  /// the process lifetime, but tests that construct it directly
  /// should call this so the subscription doesn't outlive the test.
  @mustCallSuper
  Future<void> dispose() async {
    await _dirtySub.cancel();
    await _dirtyController.close();
  }
}
