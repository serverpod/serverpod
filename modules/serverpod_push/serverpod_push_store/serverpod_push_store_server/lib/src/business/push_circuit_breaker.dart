import 'package:clock/clock.dart';

import 'push_store_config.dart';

/// Per-provider, per-process circuit breaker for auth failures (401/403).
class PushCircuitBreaker {
  /// Creates a breaker.
  PushCircuitBreaker(this._config);

  final PushStoreConfig _config;

  int _consecutiveFailures = 0;
  int _trips = 0;
  DateTime? _openUntil;

  /// Whether this provider should be skipped.
  bool isOpen([final DateTime? now]) {
    final until = _openUntil;
    if (until == null) return false;
    return (now ?? clock.now().toUtc()).isBefore(until);
  }

  /// Instant the breaker closes, or `null` if closed.
  DateTime? get openUntil => _openUntil;

  /// Records a successful (non-auth-failure) outcome, resetting the streak.
  void recordSuccess() {
    _consecutiveFailures = 0;
  }

  /// Records an auth failure. Opens the breaker after [PushStoreConfig.authFailureThreshold]
  /// consecutive failures. Cooldown grows with repeated trips.
  void recordAuthFailure([final DateTime? now]) {
    _consecutiveFailures += 1;
    if (_consecutiveFailures < _config.authFailureThreshold) return;
    _trips += 1;
    _consecutiveFailures = 0;
    final cooldown = _config.authFailureCooldown * _trips;
    _openUntil = (now ?? clock.now().toUtc()).add(cooldown);
  }

  /// FCM/HTTP auth failure codes that trip the breaker.
  static bool isAuthFailure(final String? errorCode) {
    return errorCode == 'UNAUTHENTICATED' || errorCode == 'PERMISSION_DENIED';
  }
}
