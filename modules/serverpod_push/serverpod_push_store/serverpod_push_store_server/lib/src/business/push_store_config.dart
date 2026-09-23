/// Configuration for the push store dispatcher and enqueue path.
class PushStoreConfig {
  /// Creates a config with the plan-5 defaults.
  const PushStoreConfig({
    this.scanInterval = const Duration(seconds: 5),
    this.batchesInFlight = 2,
    this.maxAttempts = 5,
    this.maxClaims = 15,
    this.maxDeliveryAge = const Duration(days: 2),
    this.baseBackoff = const Duration(seconds: 10),
    this.maxBackoff = const Duration(hours: 1),
    this.backoffJitter = 0.2,
    this.claimTimeout = const Duration(minutes: 5),
    this.maxFanOutPerEnqueue = 50000,
    this.fanOutBatchSize = 500,
    this.defaultDedupeWindow = const Duration(hours: 24),
    this.retentionPeriod = const Duration(days: 30),
    this.retentionBatchSize = 500,
    this.maxRetentionBatchesPerPass = 20,
    this.sweepBatchSize = 1000,
    this.authFailureThreshold = 3,
    this.authFailureCooldown = const Duration(seconds: 60),
  });

  /// Dispatcher tick interval.
  final Duration scanInterval;

  /// Claim-budget multiplier on `maxConcurrentRequests`.
  final int batchesInFlight;

  /// Send budget per delivery.
  final int maxAttempts;

  /// Crash budget per delivery. Incremented at claim.
  final int maxClaims;

  /// Age cap, keyed off `createdAt`.
  final Duration maxDeliveryAge;

  /// Starting backoff for exponent 0.
  final Duration baseBackoff;

  /// Backoff ceiling.
  final Duration maxBackoff;

  /// Fractional jitter applied to backoff, in `[-jitter, +jitter]`.
  final double backoffJitter;

  /// How long a row may sit in `sending` before the reaper releases it.
  final Duration claimTimeout;

  /// Guardrail against runaway fan-out, not a routine limit.
  final int maxFanOutPerEnqueue;

  /// Insert batch size for fan-out.
  final int fanOutBatchSize;

  /// Default `dedupeExpiresAt` window when a `dedupeKey` is supplied.
  final Duration defaultDedupeWindow;

  /// How long terminal deliveries are kept.
  final Duration retentionPeriod;

  /// Delete batch size for deliveries.
  final int retentionBatchSize;

  /// Max delete batches per retention pass.
  final int maxRetentionBatchesPerPass;

  /// Max rows the expiry sweep updates per cycle.
  final int sweepBatchSize;

  /// Consecutive 401/403 responses that open the circuit.
  final int authFailureThreshold;

  /// Base cooldown while the circuit is open. Grows with repeated trips.
  final Duration authFailureCooldown;
}
