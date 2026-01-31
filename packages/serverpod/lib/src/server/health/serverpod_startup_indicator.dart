import '../serverpod.dart';
import 'health_indicator.dart';

/// Built-in health indicator that checks if Serverpod has completed startup.
///
/// This indicator is automatically added to the startup indicators and checks
/// whether the server's `start()` method has completed. It provides a simple
/// way to ensure the `/startupz` endpoint only returns healthy after the
/// server is fully initialized.
class ServerpodStartupIndicator extends HealthIndicator {
  final Serverpod _pod;

  /// Creates a Serverpod startup indicator.
  ServerpodStartupIndicator(this._pod);

  @override
  String get name => 'serverpod:startup';

  @override
  Duration get timeout => const Duration(seconds: 1);

  @override
  Future<HealthCheckResult> check() async {
    if (_pod.isRunning) {
      return HealthCheckResult.pass(
        name: name,
        componentType: HealthComponentType.system,
      );
    } else {
      return HealthCheckResult.fail(
        name: name,
        componentType: HealthComponentType.system,
        output: 'Serverpod has not completed startup',
      );
    }
  }
}
