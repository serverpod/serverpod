/// Specifies the type of row-level lock to acquire.
enum LockMode {
  /// Exclusive lock that blocks all other locks.
  /// Use when you intend to update or delete the selected rows.
  forUpdate,

  /// Exclusive lock that allows [forKeyShare] locks.
  /// Use when updating non-key columns only.
  forNoKeyUpdate,

  /// Shared lock that blocks exclusive locks but allows other shared locks.
  /// Use when you need to ensure rows don't change while reading.
  forShare,

  /// Weakest lock that only blocks changes to key columns.
  forKeyShare,
}

/// Specifies the behavior when a lock cannot be immediately acquired.
enum LockBehavior {
  /// Wait until the lock becomes available.
  wait,

  /// Throw an exception immediately if the row is locked.
  noWait,

  /// Skip rows that are currently locked.
  skipLocked,
}
