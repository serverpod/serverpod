import 'package:serverpod/serverpod.dart';

import 'rate_limiter.dart';

/// Limits attempts for each string key within a domain and source.
class RateLimiterConfig {
  /// Namespace for the provider, such as `email` or `anonymous`.
  final String domain;

  /// Operation within the domain, such as `failed_login`.
  final String source;

  /// Maximum number of admitted attempts per key. Must be positive.
  final int maxAttempts;

  /// Rolling window for counting attempts. If omitted, all attempts count.
  /// Must be positive when provided.
  final Duration? timeframe;

  /// Metadata included with each admitted attempt.
  /// Per-attempt values override defaults with the same name.
  final Map<String, String>? defaultExtraData;

  /// Called for each rejected attempt, after the limiter transaction ends.
  ///
  /// Receives the caller's key unchanged. May throw a provider-specific
  /// exception or clean up a request independently of the caller transaction.
  final Future<void> Function(Session session, String key)? onRateLimitExceeded;

  /// Creates the configuration for a [RateLimiter].
  ///
  /// Throws [ArgumentError] for non-positive limits or windows.
  RateLimiterConfig({
    required this.domain,
    required this.source,
    required this.maxAttempts,
    this.timeframe,
    this.defaultExtraData,
    this.onRateLimitExceeded,
  }) {
    if (maxAttempts <= 0) {
      throw ArgumentError.value(maxAttempts, 'maxAttempts', 'Must be positive');
    }
    if (timeframe != null && timeframe! <= Duration.zero) {
      throw ArgumentError.value(timeframe, 'timeframe', 'Must be positive');
    }
  }
}
