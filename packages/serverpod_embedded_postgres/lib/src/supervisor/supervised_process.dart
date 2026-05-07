/// Common surface for both freshly-spawned and reattached postmasters.
///
/// `Supervisor` (live Process handle) and `AttachedSupervisor` (PID-only,
/// from a `detach: true` previous run) both implement this so the public
/// facade can hold either without branching on subtype.
abstract interface class SupervisedProcess {
  /// OS PID of the running postmaster, or null after [stop] completes.
  int? get pid;

  /// True between construction and the first successful [stop] (or the
  /// process exiting on its own).
  bool get isRunning;

  /// Tail of the postmaster's stdout+stderr (most recent ~200 lines).
  /// For attached supervisors this is a tail of the persisted log file.
  List<String> get logTail;

  /// Smart shutdown: SIGINT -> after `timeout/2` SIGTERM -> after `timeout`
  /// SIGKILL. Removes the supervisor pidfile.
  Future<void> stop({Duration timeout = const Duration(seconds: 10)});
}
