/// A rolling rate limit which allows [maxAttempts] in the most recent
/// [timeframe].
class RateLimit {
  /// The maximum number of attempts allowed within the timeframe.
  final int maxAttempts;

  /// The timeframe within which the attempts are allowed.
  final Duration timeframe;

  /// Creates a new [RateLimit] instance.
  const RateLimit({required this.maxAttempts, required this.timeframe});
}
