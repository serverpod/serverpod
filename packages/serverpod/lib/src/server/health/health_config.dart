import 'health_indicator.dart';

/// Configuration for the health check system.
///
/// Use this to customize caching behavior and register custom health indicators.
///
/// Example:
/// ```dart
/// final pod = Serverpod(
///   args,
///   Protocol(),
///   Endpoints(),
///   healthConfig: HealthConfig(
///     cacheTtl: Duration(seconds: 2),
///     additionalReadinessIndicators: [
///       StripeApiIndicator(),
///       InventoryServiceIndicator(),
///     ],
///   ),
/// );
/// ```
class HealthConfig {
  /// How long to cache health check results.
  ///
  /// This prevents a "thundering herd" on the health endpoint during
  /// high-frequency probing. Default is 1 second.
  final Duration cacheTtl;

  /// Additional indicators to check for readiness (`/readyz`).
  ///
  /// Built-in indicators for database and Redis are automatically added
  /// based on configuration. Use this to add custom indicators for
  /// external services your application depends on.
  final List<HealthIndicator> additionalReadinessIndicators;

  /// Additional indicators to check for startup completion (`/startupz`).
  ///
  /// These are checked in addition to the built-in [ServerpodStartupIndicator]
  /// which verifies that the server's `start()` method has completed.
  /// Use this for checks that should only run during startup, such as
  /// cache warming or connection pool initialization.
  final List<HealthIndicator> additionalStartupIndicators;

  /// Creates a health configuration.
  const HealthConfig({
    this.cacheTtl = const Duration(seconds: 1),
    this.additionalReadinessIndicators = const [],
    this.additionalStartupIndicators = const [],
  });
}
