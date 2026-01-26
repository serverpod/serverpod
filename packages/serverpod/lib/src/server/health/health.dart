/// Health check system for orchestrator-friendly probes.
///
/// This library provides Kubernetes-style health endpoints:
/// - `/livez` - Is the process alive?
/// - `/readyz` - Can it handle requests?
/// - `/startupz` - Has initialization completed?
///
/// ## Usage
///
/// Health indicators are automatically registered based on configuration.
/// The `/startupz` endpoint automatically checks if Serverpod has completed
/// its startup sequence. You can add custom indicators for additional checks:
///
/// ```dart
/// final pod = Serverpod(
///   args,
///   Protocol(),
///   Endpoints(),
///   healthConfig: HealthConfig(
///     readinessIndicators: [
///       MyCustomServiceIndicator(),
///     ],
///     startupIndicators: [
///       CacheWarmupIndicator(),
///     ],
///   ),
/// );
///
/// await pod.start();
/// ```
///
/// ## Custom Indicators
///
/// Implement [HealthIndicator] to create custom checks:
///
/// ```dart
/// class StripeApiIndicator extends HealthIndicator {
///   @override
///   String get name => 'stripe:api';
///
///   @override
///   Future<HealthCheckResult> check() async {
///     try {
///       await stripeClient.ping();
///       return HealthCheckResult.pass(name: name);
///     } catch (e) {
///       return HealthCheckResult.fail(
///         name: name,
///         output: 'Stripe API unavailable: $e',
///       );
///     }
///   }
/// }
/// ```
library;

export 'database_health_indicator.dart';
export 'health_check_service.dart';
export 'health_config.dart';
export 'health_indicator.dart';
export 'health_response.dart';
export 'redis_health_indicator.dart';
export 'serverpod_startup_indicator.dart';
