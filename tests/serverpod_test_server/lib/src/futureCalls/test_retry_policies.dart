import 'package:serverpod/serverpod.dart';

/// A project retry policy that retries after the same delay, used to test that
/// retry policies declared in a project are registered in its protocol.
class TestRetryPolicy extends FutureCallRetryPolicy {
  /// The maximum number of retries.
  final int maxAttempts;

  /// The delay before every retry.
  final Duration delay;

  TestRetryPolicy({required this.maxAttempts, required this.delay});

  factory TestRetryPolicy.fromJson(Map<String, dynamic> json) {
    return TestRetryPolicy(
      maxAttempts: json['maxAttempts'] as int,
      delay: Duration(milliseconds: json['delayMs'] as int),
    );
  }

  @override
  Duration? nextDelay(FutureCallRetryContext context) {
    if (context.retryAttempt >= maxAttempts) return null;
    return delay;
  }

  @override
  Map<String, dynamic> toJson() => {
    'maxAttempts': maxAttempts,
    'delayMs': delay.inMilliseconds,
  };
}

/// A subclass of [TestRetryPolicy], used to test that a subclass is saved and
/// loaded as itself rather than as its superclass.
class TestRetryPolicyWithDoubling extends TestRetryPolicy {
  TestRetryPolicyWithDoubling({
    required super.maxAttempts,
    required super.delay,
  });

  factory TestRetryPolicyWithDoubling.fromJson(Map<String, dynamic> json) {
    return TestRetryPolicyWithDoubling(
      maxAttempts: json['maxAttempts'] as int,
      delay: Duration(milliseconds: json['delayMs'] as int),
    );
  }

  @override
  Duration? nextDelay(FutureCallRetryContext context) {
    var delay = super.nextDelay(context);
    if (delay == null) return null;
    return delay * (1 << context.retryAttempt);
  }
}
