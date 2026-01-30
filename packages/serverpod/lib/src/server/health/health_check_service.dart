import 'dart:async';

import '../features.dart';
import '../serverpod.dart';
import 'database_health_indicator.dart';
import 'health_config.dart';
import 'health_indicator.dart';
import 'health_response.dart';
import 'redis_health_indicator.dart';
import 'serverpod_startup_indicator.dart';

/// Cached health check result with timestamp.
class _CachedResult {
  final HealthCheckResult result;
  final DateTime timestamp;

  _CachedResult(this.result, this.timestamp);

  bool isExpired(Duration ttl) {
    return DateTime.now().toUtc().difference(timestamp) > ttl;
  }
}

/// Service that manages health checks for the server.
///
/// This service:
/// - Executes health indicators with timeout enforcement
/// - Caches results to prevent thundering herd during high-frequency probing
/// - Aggregates results into RFC-compliant responses
class HealthCheckService {
  final Serverpod _pod;
  final HealthConfig _config;

  final List<HealthIndicator> _readinessIndicators = [];
  final List<HealthIndicator> _startupIndicators = [];

  // Caching
  final Map<String, _CachedResult> _cache = {};
  final Map<String, Future<HealthCheckResult>> _pendingChecks = {};

  /// Creates a health check service.
  HealthCheckService(this._pod, this._config) {
    _initializeBuiltInIndicators();
    _readinessIndicators.addAll(_config.readinessIndicators);
    _startupIndicators.addAll(_config.startupIndicators);
  }

  void _initializeBuiltInIndicators() {
    // Always add the Serverpod startup indicator first
    _startupIndicators.insert(0, ServerpodStartupIndicator(_pod));

    if (Features.enableDatabase) {
      _readinessIndicators.add(DatabaseHealthIndicator(_pod));
    }
    if (Features.enableRedis) {
      _readinessIndicators.add(RedisHealthIndicator(_pod));
    }
  }

  /// The list of readiness indicators being used.
  List<HealthIndicator> get readinessIndicators =>
      List.unmodifiable(_readinessIndicators);

  /// The list of startup indicators being used.
  List<HealthIndicator> get startupIndicators =>
      List.unmodifiable(_startupIndicators);

  /// Check liveness (`/livez`).
  ///
  /// Always returns healthy if the server can respond. This endpoint
  /// performs no external checks - if we can respond, we're alive.
  Future<HealthResponse> checkLiveness() async {
    return HealthResponse.alive();
  }

  /// Check readiness (`/readyz`).
  ///
  /// Runs all readiness indicators and returns an aggregate response.
  /// Returns unhealthy if any indicator fails.
  Future<HealthResponse> checkReadiness() async {
    final results = await _runIndicators(_readinessIndicators);
    return HealthResponse.fromResults(results);
  }

  /// Check startup (`/startupz`).
  ///
  /// Runs all startup indicators and returns an aggregate response.
  /// The built-in [ServerpodStartupIndicator] checks if the server has
  /// completed its startup sequence. Additional custom startup indicators
  /// can be added via [HealthConfig.startupIndicators].
  Future<HealthResponse> checkStartup() async {
    final results = await _runIndicators(_startupIndicators);
    return HealthResponse.fromResults(results);
  }

  /// Get all readiness indicator results.
  ///
  /// This is used by [HealthCheckManager] for historical persistence.
  Future<List<HealthCheckResult>> getReadinessResults() async {
    return _runIndicators(_readinessIndicators);
  }

  Future<List<HealthCheckResult>> _runIndicators(
    List<HealthIndicator> indicators,
  ) async {
    final futures = indicators.map(_getIndicatorResult);
    return Future.wait(futures);
  }

  Future<HealthCheckResult> _getIndicatorResult(
    HealthIndicator indicator,
  ) async {
    // Check cache first
    final cached = _cache[indicator.name];
    if (cached != null && !cached.isExpired(_config.cacheTtl)) {
      return cached.result;
    }

    // Return pending check if one exists (prevents thundering herd)
    var pending = _pendingChecks[indicator.name];
    if (pending != null) {
      return await pending;
    }

    // Start new check with timeout
    pending = _runWithTimeout(indicator);
    _pendingChecks[indicator.name] = pending;

    try {
      final result = await pending;
      _cache[indicator.name] = _CachedResult(result, DateTime.now().toUtc());
      return result;
    } finally {
      unawaited(_pendingChecks.remove(indicator.name));
    }
  }

  Future<HealthCheckResult> _runWithTimeout(HealthIndicator indicator) async {
    try {
      return await indicator.check().timeout(indicator.timeout);
    } on TimeoutException {
      return HealthCheckResult.fail(
        name: indicator.name,
        output:
            'Health check timed out after ${indicator.timeout.inMilliseconds}ms',
      );
    } catch (e) {
      return HealthCheckResult.fail(
        name: indicator.name,
        output: 'Health check failed: $e',
      );
    }
  }
}
