import 'health_indicator.dart';

/// Aggregated response from multiple health indicators.
///
/// Follows the draft RFC for Health Check Response Format:
/// https://datatracker.ietf.org/doc/html/draft-inadarei-api-health-check-06
class HealthResponse {
  /// Overall status of the health check.
  ///
  /// [HealthStatus.pass] if all checks passed, [HealthStatus.fail] otherwise.
  final HealthStatus status;

  /// Individual check results grouped by indicator name.
  ///
  /// The key is the indicator name (e.g., `database:connection`),
  /// the value is a list of results (supporting multiple instances).
  final Map<String, List<HealthCheckResult>> checks;

  /// Human-readable notes about the overall health status.
  final String? notes;

  /// Detailed output message, especially useful for failures.
  final String? output;

  /// Timestamp when this response was generated.
  final DateTime time;

  /// Creates a health response.
  const HealthResponse({
    required this.status,
    required this.checks,
    this.notes,
    this.output,
    required this.time,
  });

  /// Creates a health response from a list of check results.
  factory HealthResponse.fromResults(List<HealthCheckResult> results) {
    final checks = <String, List<HealthCheckResult>>{};
    for (final result in results) {
      checks.putIfAbsent(result.name, () => []).add(result);
    }

    final hasFailure = results.any((r) => r.status == HealthStatus.fail);
    final failedChecks = results.where((r) => r.status == HealthStatus.fail);

    String? notes;
    String? output;
    if (hasFailure) {
      final failedNames = failedChecks.map((r) => r.name).toSet().join(', ');
      notes = 'Failed checks: $failedNames';
      output = failedChecks
          .where((r) => r.output != null)
          .map((r) => '${r.name}: ${r.output}')
          .join('; ');
      if (output.isEmpty) output = null;
    }

    return HealthResponse(
      status: hasFailure ? HealthStatus.fail : HealthStatus.pass,
      checks: checks,
      notes: notes,
      output: output,
      time: DateTime.now().toUtc(),
    );
  }

  /// Creates a minimal passing response (for /livez).
  factory HealthResponse.alive() {
    return HealthResponse(
      status: HealthStatus.pass,
      checks: const {},
      time: DateTime.now().toUtc(),
    );
  }

  /// Creates a failing response for when startup is not complete.
  factory HealthResponse.startupIncomplete() {
    return HealthResponse(
      status: HealthStatus.fail,
      checks: const {},
      notes: 'Server startup not complete',
      time: DateTime.now().toUtc(),
    );
  }

  /// Whether the overall status is healthy.
  bool get isHealthy => status == HealthStatus.pass;

  /// HTTP status code for this response (200 for pass, 503 for fail).
  int get httpStatusCode => isHealthy ? 200 : 503;

  /// Converts this response to a JSON map following the RFC format.
  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      if (notes != null) 'notes': notes,
      if (output != null) 'output': output,
      if (checks.isNotEmpty)
        'checks': checks.map(
          (key, value) => MapEntry(key, value.map((r) => r.toJson()).toList()),
        ),
      'time': time.toIso8601String(),
    };
  }
}
