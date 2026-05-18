/// Bounded ring buffer for the most recent N stdout/stderr lines from the
/// supervised postmaster.
///
/// Used to attach a log tail to thrown exceptions ([StartupTimeoutException],
/// [CrashedException]) so users can diagnose without re-running.
class LogBuffer {
  /// Maximum number of lines retained. Older lines are dropped.
  final int capacity;

  final List<String> _lines = [];

  /// Creates a buffer that retains at most [capacity] lines (default 200,
  /// per the spec).
  LogBuffer({this.capacity = 200});

  /// Appends [line], evicting the oldest if at capacity.
  void add(String line) {
    if (_lines.length >= capacity) _lines.removeAt(0);
    _lines.add(line);
  }

  /// Returns the buffered lines in insertion order. The returned list is
  /// a defensive copy; callers can mutate it freely.
  List<String> snapshot() => List.unmodifiable(_lines);
}
