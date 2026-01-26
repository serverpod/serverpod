import '../serverpod.dart';
import 'health_indicator.dart';

/// Built-in health indicator that checks Redis connectivity.
///
/// This indicator sends a PING command to Redis and expects a PONG response
/// to verify that Redis is reachable and responding.
class RedisHealthIndicator extends HealthIndicator {
  final Serverpod _pod;

  /// Creates a Redis health indicator.
  RedisHealthIndicator(this._pod);

  @override
  String get name => 'redis:connection';

  @override
  Duration get timeout => const Duration(seconds: 2);

  @override
  Future<HealthCheckResult> check() async {
    final controller = _pod.redisController;
    if (controller == null) {
      return HealthCheckResult.fail(
        name: name,
        componentType: 'datastore',
        output: 'Redis controller not initialized',
      );
    }

    final stopwatch = Stopwatch()..start();
    try {
      final pong = await controller.ping();
      stopwatch.stop();

      if (pong) {
        return HealthCheckResult.pass(
          name: name,
          componentType: 'datastore',
          observedValue: stopwatch.elapsedMilliseconds.toDouble(),
          observedUnit: 'ms',
        );
      } else {
        return HealthCheckResult.fail(
          name: name,
          componentType: 'datastore',
          output: 'Redis PING did not return PONG',
        );
      }
    } catch (e) {
      stopwatch.stop();
      return HealthCheckResult.fail(
        name: name,
        componentType: 'datastore',
        output: 'Redis connection failed: $e',
      );
    }
  }
}
