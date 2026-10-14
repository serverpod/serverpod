/// Information about a failed [FutureCall] attempt.
class FutureCallRetryContext {
  /// The error thrown by the call.
  final Object error;

  /// The stack trace of [error].
  final StackTrace stackTrace;

  /// How many retries had already run when the call failed. It is 0 when the
  /// first run fails, 1 when the first retry fails, and so on.
  final int retryAttempt;

  /// Creates a new [FutureCallRetryContext].
  const FutureCallRetryContext({
    required this.error,
    required this.stackTrace,
    required this.retryAttempt,
  });
}

/// Decides whether, and after how long, a failed [FutureCall] is retried.
///
/// Subclasses must provide a `fromJson(Map<String, dynamic> json)`
/// constructor, so that the policy can be loaded when a retry is due.
abstract class FutureCallRetryPolicy {
  /// Creates a new [FutureCallRetryPolicy].
  const FutureCallRetryPolicy();

  /// Returns the delay before the next retry, or null to stop retrying.
  ///
  /// The policy is serialized again after each failed attempt, so a policy can
  /// keep state between attempts by updating its own fields.
  Duration? nextDelay(FutureCallRetryContext context);

  /// Throws an [ArgumentError] if the policy is configured in a way that can't
  /// work. Called when a [FutureCall] is scheduled with the policy.
  void validate() {}

  /// Serializes the policy, including any state it keeps between attempts.
  Map<String, dynamic> toJson();
}
