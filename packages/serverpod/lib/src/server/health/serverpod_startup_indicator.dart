import '../serverpod.dart';
import 'health_indicator.dart';

/// Built-in health indicator that checks if Serverpod has completed startup.
///
/// This indicator is automatically added to the startup indicators and checks
/// whether the server's `start()` method has completed. It provides a simple
/// way to ensure the `/startupz` endpoint only returns healthy after the
/// server is fully initialized.
///
/// When startup is complete, the [observedValue] contains the server's start
/// time as a [DateTime].
class ServerpodStartupIndicator extends HealthIndicator<DateTime> {
  final Serverpod _pod;

  /// Creates a Serverpod startup indicator.
  ServerpodStartupIndicator(this._pod);

  @override
  String get name => 'serverpod:startup';

  @override
  String get componentType => HealthComponentType.system.name;

  @override
  Duration get timeout => const Duration(seconds: 1);

  @override
  Future<HealthCheckResult> check() async {
    if (_pod.isStartupComplete) {
      return pass(
        observedValue: _pod.startedTime,
      );
    } else {
      return fail(
        output: 'Serverpod has not completed startup',
      );
    }
  }
}
