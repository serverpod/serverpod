import '../serverpod.dart';
import 'health_indicator.dart';

/// Built-in health indicator that checks Redis connectivity.
///
/// This indicator sends a PING command to Redis and expects a PONG response
/// to verify that Redis is reachable and responding.
class RedisHealthIndicator extends HealthIndicator<double> {
  final Serverpod _pod;

  /// Creates a Redis health indicator.
  RedisHealthIndicator(this._pod);

  @override
  String get name => 'redis:connection';

  @override
  String get componentType => HealthComponentType.datastore.name;

  @override
  String get observedUnit => 'ms';

  @override
  Duration get timeout => const Duration(seconds: 2);

  @override
  Future<HealthCheckResult> check() async {
    final controller = _pod.redisController;
    if (controller == null) {
      return fail(
        output:
            'Redis is enabled but controller not initialized - '
            'check Redis configuration',
      );
    }

    final stopwatch = Stopwatch()..start();
    try {
      final pong = await controller.ping();
      stopwatch.stop();

      if (pong) {
        return pass(
          observedValue: stopwatch.elapsedMilliseconds.toDouble(),
        );
      } else {
        return fail(
          output: 'Redis PING did not return PONG',
        );
      }
    } catch (e) {
      stopwatch.stop();
      return fail(
        output: 'Redis connection failed: $e',
      );
    }
  }
}
