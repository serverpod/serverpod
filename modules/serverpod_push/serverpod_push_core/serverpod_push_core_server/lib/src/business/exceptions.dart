/// Thrown when a provider id is not registered with [PushService].
class PushUnknownProviderException implements Exception {
  /// The unknown provider id.
  final String provider;

  /// Creates the exception.
  const PushUnknownProviderException(this.provider);

  @override
  String toString() => 'Unknown push provider "$provider".';
}

/// Thrown when a message exceeds a provider's [PushProvider.maxPayloadBytes].
class PushPayloadTooLargeException implements Exception {
  /// Provider whose ceiling was exceeded.
  final String provider;

  /// Measured payload size in bytes.
  final int actualBytes;

  /// Provider ceiling in bytes.
  final int limitBytes;

  /// Creates the exception.
  const PushPayloadTooLargeException(
    this.provider,
    this.actualBytes,
    this.limitBytes,
  );

  @override
  String toString() =>
      'Push payload for "$provider" is $actualBytes bytes, '
      'exceeding the limit of $limitBytes.';
}

/// Thrown when `timeToLive` exceeds a provider's [PushProvider.maxTimeToLive].
class PushTimeToLiveTooLongException implements Exception {
  /// Provider whose ceiling was exceeded.
  final String provider;

  /// Requested time to live.
  final Duration requested;

  /// Provider ceiling.
  final Duration limit;

  /// Creates the exception.
  const PushTimeToLiveTooLongException(
    this.provider,
    this.requested,
    this.limit,
  );

  @override
  String toString() =>
      'timeToLive $requested for "$provider" exceeds the limit of $limit.';
}

/// Thrown when `notBefore` is not strictly before `expiresAt`.
class PushInvalidScheduleException implements Exception {
  /// Scheduled start (inclusive).
  final DateTime notBefore;

  /// Delivery deadline.
  final DateTime expiresAt;

  /// Creates the exception.
  const PushInvalidScheduleException({
    required this.notBefore,
    required this.expiresAt,
  });

  @override
  String toString() =>
      'Invalid push schedule: notBefore $notBefore is not before '
      'expiresAt $expiresAt.';
}

/// Thrown when fan-out would exceed `maxFanOutPerEnqueue`.
class PushAudienceTooLargeException implements Exception {
  /// Resolved device count.
  final int actual;

  /// Configured ceiling.
  final int limit;

  /// Creates the exception.
  const PushAudienceTooLargeException(this.actual, this.limit);

  @override
  String toString() =>
      'Push audience of $actual devices exceeds the limit of $limit.';
}

/// Thrown when FCM (or another signing provider) is missing private-key
/// material needed to mint an access token.
class PushMissingCredentialsException implements Exception {
  /// Provider that needs credentials.
  final String provider;

  /// Human-readable description of what is missing.
  final String message;

  /// Creates the exception.
  const PushMissingCredentialsException(this.provider, this.message);

  @override
  String toString() =>
      'Push provider "$provider" is missing credentials: $message';
}
