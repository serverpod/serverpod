import 'package:meta/meta.dart';

import '../../../serverpod.dart';

/// Known component types for health indicators.
///
/// These values follow the RFC Health Check Response Format conventions.
/// Custom component types can also be used as plain strings.
enum HealthComponentType {
  /// Data storage components (databases, caches, file systems).
  datastore,

  /// System-level components (CPU, memory, process health).
  system,

  /// Generic component type for custom services.
  component,
}

/// Base class for health indicators that check service dependencies.
///
/// Health indicators are used by the health check system to determine
/// whether the server is ready to handle requests. Each indicator checks
/// a specific dependency (database, Redis, external service, etc.).
///
/// The type parameter [T] specifies the type of [observedValue] that this
/// indicator produces, providing type safety when creating results.
///
/// Example implementation:
/// ```dart
/// class MyServiceHealthIndicator extends HealthIndicator<double> {
///   @override
///   String get name => 'myservice:connection';
///
///   @override
///   String get componentType => HealthComponentType.component.name;
///
///   @override
///   String get observedUnit => 'ms';
///
///   @override
///   Future<HealthCheckResult> check() async {
///     final stopwatch = Stopwatch()..start();
///     try {
///       await myService.ping();
///       stopwatch.stop();
///       return pass(observedValue: stopwatch.elapsedMilliseconds.toDouble());
///     } catch (e) {
///       return fail(output: 'Connection failed: $e');
///     }
///   }
/// }
/// ```
abstract class HealthIndicator<T extends Object> {
  /// Const ctor to allow subclasses the same
  const HealthIndicator();

  /// Human-readable name for this indicator.
  ///
  /// Should follow the format `component:aspect`, e.g.:
  /// - `database:connection`
  /// - `redis:latency`
  /// - `stripe:api`
  String get name;

  /// Unique identifier for the component instance.
  ///
  /// Useful when there are multiple instances of the same component type,
  /// e.g., `primary-db`, `replica-db`. Returns `null` by default.
  String? get componentId => null;

  /// Type of the component.
  ///
  /// Use constants from [HealthComponentType] or custom strings.
  /// Returns `null` by default.
  String? get componentType => null;

  /// Unit of the observed value, e.g., `ms`, `percent`, `bytes`.
  ///
  /// Returns `null` by default.
  String? get observedUnit => null;

  /// Maximum time to wait for this check before considering it failed.
  ///
  /// This prevents a slow check from blocking the entire health endpoint.
  /// Default is 5 seconds.
  Duration get timeout => const Duration(seconds: 5);

  /// Perform the health check and return the result.
  ///
  /// Implementations should catch exceptions and return a failed result
  /// rather than throwing. Use the [pass] and [fail] helper methods to
  /// create results with consistent metadata.
  Future<HealthCheckResult> check();

  /// Creates a passing health check result for this indicator.
  ///
  /// This method automatically populates [name], [componentId],
  /// [componentType], and [observedUnit] from this indicator's properties.
  HealthCheckResult pass({
    T? observedValue,
    String? output,
    DateTime? time,
  }) {
    return HealthCheckResult._(
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

  /// Creates a failing health check result for this indicator.
  ///
  /// This method automatically populates [name], [componentId],
  /// [componentType], and [observedUnit] from this indicator's properties.
  HealthCheckResult fail({
    T? observedValue,
    String? output,
    DateTime? time,
  }) {
    return HealthCheckResult._(
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

  /// The observed value from the check.
  ///
  /// Can be any JSON-serializable value, for example:
  /// - Response time in milliseconds (double)
  /// - ISO 8601 datetime for timestamps (DateTime, serialized automatically)
  /// - Categorical values like 'connected', 'degraded' (String)
  final Object? observedValue;

  /// Unit of the observed value, e.g., `ms`, `percent`, `bytes`.
  final String? observedUnit;

  /// Human-readable output message, especially useful for failures.
  final String? output;

  /// Timestamp when this check was performed.
  final DateTime time;

  /// Creates a health check result.
  const HealthCheckResult._({
    required this.name,
    required this.status,
    this.componentId,
    this.componentType,
    this.observedValue,
    this.observedUnit,
    this.output,
    required this.time,
  });

  /// Whether this check passed.
  bool get isHealthy => status == HealthStatus.pass;

  /// Converts this result to a JSON map following the RFC format.
  Map<String, dynamic> toJson() {
    return {
      'componentId': ?componentId,
      'componentType': ?componentType,
      if (observedValue != null)
        'observedValue': SerializationManager.toEncodable(observedValue),
      'observedUnit': ?observedUnit,
      'status': status.name,
      'time': time.toIso8601String(),
      'output': ?output,
    };
  }
}

@internal
extension HealthCheckResultInternal on HealthCheckResult {
  static const create = HealthCheckResult._;
}
