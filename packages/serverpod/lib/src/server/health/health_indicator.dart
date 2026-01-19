/// Base class for health indicators that check service dependencies.
///
/// Health indicators are used by the health check system to determine
/// whether the server is ready to handle requests. Each indicator checks
/// a specific dependency (database, Redis, external service, etc.).
///
/// Example implementation:
/// ```dart
/// class MyServiceHealthIndicator extends HealthIndicator {
///   @override
///   String get name => 'myservice:connection';
///
///   @override
///   Future<HealthCheckResult> check() async {
///     try {
///       await myService.ping();
///       return HealthCheckResult.pass(name: name);
///     } catch (e) {
///       return HealthCheckResult.fail(
///         name: name,
///         output: 'Connection failed: $e',
///       );
///     }
///   }
/// }
/// ```
abstract class HealthIndicator {
  /// Human-readable name for this indicator.
  ///
  /// Should follow the format `component:aspect`, e.g.:
  /// - `database:connection`
  /// - `redis:latency`
  /// - `stripe:api`
  String get name;

  /// Maximum time to wait for this check before considering it failed.
  ///
  /// This prevents a slow check from blocking the entire health endpoint.
  /// Default is 5 seconds.
  Duration get timeout => const Duration(seconds: 5);

  /// Perform the health check and return the result.
  ///
  /// Implementations should catch exceptions and return a failed result
  /// rather than throwing.
  Future<HealthCheckResult> check();
}

/// The status of a health check.
enum HealthStatus {
  /// The check passed - the component is healthy.
  pass,

  /// The check failed - the component is unhealthy.
  fail,
}

/// Result of a single health indicator check.
///
/// Follows the draft RFC for Health Check Response Format:
/// https://datatracker.ietf.org/doc/html/draft-inadarei-api-health-check-06
class HealthCheckResult {
  /// The name of the indicator that produced this result.
  final String name;

  /// Whether the check passed or failed.
  final HealthStatus status;

  /// Unique identifier for the component instance.
  ///
  /// Useful when there are multiple instances of the same component type,
  /// e.g., `primary-db`, `replica-db`.
  final String? componentId;

  /// Type of the component, e.g., `datastore`, `system`, `component`.
  final String? componentType;

  /// The observed value from the check, e.g., response time in milliseconds.
  final double? observedValue;

  /// Unit of the observed value, e.g., `ms`, `percent`, `bytes`.
  final String? observedUnit;

  /// Human-readable output message, especially useful for failures.
  final String? output;

  /// Timestamp when this check was performed.
  final DateTime time;

  /// Creates a health check result.
  const HealthCheckResult({
    required this.name,
    required this.status,
    this.componentId,
    this.componentType,
    this.observedValue,
    this.observedUnit,
    this.output,
    required this.time,
  });

  /// Creates a passing health check result.
  factory HealthCheckResult.pass({
    required String name,
    String? componentId,
    String? componentType,
    double? observedValue,
    String? observedUnit,
    String? output,
    DateTime? time,
  }) {
    return HealthCheckResult(
      name: name,
      status: HealthStatus.pass,
      componentId: componentId,
      componentType: componentType,
      observedValue: observedValue,
      observedUnit: observedUnit,
      output: output,
      time: time ?? DateTime.now().toUtc(),
    );
  }

  /// Creates a failing health check result.
  factory HealthCheckResult.fail({
    required String name,
    String? componentId,
    String? componentType,
    double? observedValue,
    String? observedUnit,
    String? output,
    DateTime? time,
  }) {
    return HealthCheckResult(
      name: name,
      status: HealthStatus.fail,
      componentId: componentId,
      componentType: componentType,
      observedValue: observedValue,
      observedUnit: observedUnit,
      output: output,
      time: time ?? DateTime.now().toUtc(),
    );
  }

  /// Whether this check passed.
  bool get isHealthy => status == HealthStatus.pass;

  /// Converts this result to a JSON map following the RFC format.
  Map<String, dynamic> toJson() {
    return {
      if (componentId != null) 'componentId': componentId,
      if (componentType != null) 'componentType': componentType,
      if (observedValue != null) 'observedValue': observedValue,
      if (observedUnit != null) 'observedUnit': observedUnit,
      'status': status.name,
      'time': time.toIso8601String(),
      if (output != null) 'output': output,
    };
  }
}
