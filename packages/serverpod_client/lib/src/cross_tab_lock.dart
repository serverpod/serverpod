/// A mutual-exclusion lock shared across cooperating execution contexts that
/// hold the same credentials, such as browser tabs of one origin.
///
/// Used to serialize operations that must not run concurrently across tabs,
/// like rotating a shared refresh credential.
abstract interface class CrossTabLock {
  /// Runs [action] while holding the lock, waiting for current holders in
  /// other contexts to finish first.
  Future<T> synchronize<T>(Future<T> Function() action);
}
