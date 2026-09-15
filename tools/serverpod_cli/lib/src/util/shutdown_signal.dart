import 'dart:async';
import 'dart:io';

/// Runs [action] with SIGINT/SIGTERM handling active through [cleanup].
///
/// The action observes the shutdown request and finishes its active work.
/// Cleanup runs on success or failure, before returning or propagating an error.
/// Signal subscriptions are always cancelled last, even if cleanup throws.
Future<T> runWithShutdownSignals<T>(
  Future<T> Function(ShutdownSignal shutdown) action, {
  Future<void> Function()? cleanup,
}) async {
  final shutdown = ShutdownSignal();
  try {
    return await action(shutdown);
  } finally {
    try {
      await cleanup?.call();
    } finally {
      await shutdown.dispose();
    }
  }
}

/// One-shot shutdown request shared between command work and its callers.
///
/// When [listenForSignals] is true (the default for non-TUI), SIGINT and
/// SIGTERM complete [future] with 0. The TUI passes `false` because
/// `runServerpodApp` already owns the signal subscriptions and forwards
/// them via its own callback. Either way, callers can [complete] the
/// signal directly (e.g. when the server crashes or the Quit button is
/// pressed) so the wait-for-exit point only ever has to await [future].
///
/// Call [dispose] to cancel the signal subscriptions, if any.
class ShutdownSignal {
  final Completer<int> _completer = Completer<int>();
  StreamSubscription<void>? _sigintSub;
  StreamSubscription<void>? _sigtermSub;

  ShutdownSignal({bool listenForSignals = true}) {
    if (!listenForSignals) return;
    _sigintSub = ProcessSignal.sigint.watch().listen(_completeFromSignal);
    if (!Platform.isWindows) {
      _sigtermSub = ProcessSignal.sigterm.watch().listen(_completeFromSignal);
    }
  }

  void _completeFromSignal(ProcessSignal _) => complete(0);

  /// Completes [future] with [code] if it isn't completed yet; no-op
  /// otherwise. Safe to call from multiple paths (signal handlers, the
  /// Quit button, server-exit forwarders).
  void complete([int code = 0]) {
    if (!_completer.isCompleted) _completer.complete(code);
  }

  /// Whether shutdown has been requested.
  bool get isShutdown => _completer.isCompleted;

  /// Completes with the requested exit code.
  Future<int> get future => _completer.future;

  /// Cancels the signal subscriptions.
  Future<void> dispose() async {
    try {
      await _sigintSub?.cancel();
    } finally {
      await _sigtermSub?.cancel();
    }
  }
}
