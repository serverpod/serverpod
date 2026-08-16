import 'package:serverpod/serverpod.dart';

/// A fake health indicator for testing custom indicator behavior.
///
/// Unlike a mock, this is a real implementation that can be configured
/// to return specific results. Use this in integration tests to verify
/// that custom health indicators work correctly with the health check system.
///
/// Example:
/// ```dart
/// final indicator = FakeHealthIndicator(
///   name: 'test:service',
///   isHealthy: false,
///   failureMessage: 'Service unavailable',
/// );
///
/// final pod = Serverpod(
///   [],
///   Protocol(),
///   Endpoints(),
///   healthConfig: HealthConfig(
///     additionalReadinessIndicators: [indicator],
///   ),
/// );
/// ```
class FakeHealthIndicator extends HealthIndicator<double> {
  final String _name;
  final Duration _timeout;

  /// Whether this indicator should report as healthy.
  bool isHealthy;

  /// The failure message to include when unhealthy.
  String? failureMessage;

  /// Artificial delay before returning the result.
  ///
  /// Use this to test timeout behavior by setting a delay longer than
  /// the indicator's timeout.
  Duration delay;

  /// The number of times [check] has been called.
  ///
  /// Use this to verify caching behavior - if results are cached,
  /// this counter should not increase on subsequent calls within the TTL.
  int checkCount = 0;

  /// Creates a fake health indicator.
  ///
  /// By default, the indicator is healthy with no delay.
  FakeHealthIndicator({
    required String name,
    this.isHealthy = true,
    this.failureMessage,
    this.delay = Duration.zero,
    Duration timeout = const Duration(seconds: 5),
  }) : _name = name,
       _timeout = timeout;

  @override
  String get name => _name;

  @override
  Duration get timeout => _timeout;

  @override
  Future<HealthCheckResult> check() async {
    checkCount++;
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }
    if (isHealthy) {
      return pass();
    }
    return fail(
      output: failureMessage ?? 'Fake indicator failure',
    );
  }
}
