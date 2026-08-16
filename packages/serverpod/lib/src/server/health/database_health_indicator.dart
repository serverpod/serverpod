import '../serverpod.dart';
import 'health_indicator.dart';

/// Built-in health indicator that checks database connectivity.
///
/// This indicator uses the existing `testConnection()` method to verify
/// that the database is reachable and responding to queries.
class DatabaseHealthIndicator extends HealthIndicator<double> {
  final Serverpod _pod;

  /// Creates a database health indicator.
  const DatabaseHealthIndicator(this._pod);

  @override
  String get name => 'database:connection';

  @override
  String get componentType => HealthComponentType.datastore.name;

  @override
  String get observedUnit => 'ms';

  @override
  Duration get timeout => const Duration(seconds: 2);

  @override
  Future<HealthCheckResult> check() async {
    final stopwatch = Stopwatch()..start();
    try {
      final healthy = await _pod.internalSession.db.testConnection();
      stopwatch.stop();

      if (healthy) {
        return pass(
          observedValue: stopwatch.elapsedMilliseconds.toDouble(),
        );
      } else {
        return fail(
          output: 'Database connection test returned false',
        );
      }
    } catch (e) {
      stopwatch.stop();
      return fail(
        output: 'Database connection failed: $e',
      );
    }
  }
}
