import 'package:clock/clock.dart';

/// Wider than the coarse system timers used on Windows, where [DateTime.now]
/// can stay unchanged across a database round trip.
const coarseClockMargin = Duration(seconds: 1);

/// Runs [action] [coarseClockMargin] before the real current time.
///
/// Age filters keep a row whose timestamp equals the cutoff
/// (`createdAt < now - olderThan`). A row written and then deleted inside one
/// clock tick would otherwise survive `olderThan: Duration.zero`.
Future<T> inTheRecentPast<T>(final Future<T> Function() action) {
  return withClock(
    Clock.fixed(DateTime.now().subtract(coarseClockMargin)),
    action,
  );
}

/// Test clocks based on a duration.
extension CoarseClockDuration on Duration {
  /// A fixed clock strictly after this duration has elapsed.
  ///
  /// Expiry is strict (`expiresAt.isBefore(now)`). Advancing by exactly this
  /// duration is still inside the valid window when the row was created during
  /// the same clock tick as [DateTime.now].
  Clock clockPastLifetime() {
    return Clock.fixed(DateTime.now().add(this + coarseClockMargin));
  }
}
