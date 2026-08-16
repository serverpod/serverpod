import 'package:serverpod/serverpod.dart';

import '../../../core.dart';

/// Callback called when a request is retrieved.
///
/// Should include the challenge relation in the query.
/// Returns `null` if the request is not found.
typedef GetRequestCallback<T> =
    Future<T?> Function(
      Session session,
      UuidValue requestId, {
      required Transaction? transaction,
    });

/// Callback called when a request has expired.
///
/// Should delete the request outside of the transaction so it's not rolled back.
typedef OnExpiredCallback<T> =
    Future<void> Function(
      Session session,
      T request,
    );

/// Callback called when a request is linked to a completion challenge.
///
/// Should update the request to link the completion challenge ID.
/// May throw [ChallengeAlreadyUsedException] if the challenge has already
/// been linked.
typedef LinkCompletionTokenCallback<T> =
    Future<void> Function(
      Session session,
      T request,
      SecretChallenge completionChallenge, {
      required Transaction? transaction,
    });

/// Configuration for challenge verification with all protection mechanisms.
///
/// This class provides callbacks for workflow-specific logic while keeping the
/// core verification logic generic and reusable.
///
/// Type parameter [T] represents the request type (e.g.,
/// EmailAccountRequest, EmailAccountPasswordResetRequest).
class SecretChallengeVerificationConfig<T> {
  /// Retrieves the request by ID.
  ///
  /// Should include the challenge relation in the query.
  /// Returns `null` if the request is not found.
  final GetRequestCallback<T> getRequest;

  /// Checks if the request has already been used/verified.
  final bool Function(T request) isAlreadyUsed;

  /// Extracts the challenge from the request.
  final SecretChallenge Function(T request) getChallenge;

  /// Checks if the request has expired.
  final bool Function(T request) isExpired;

  /// Called when the request has expired.
  ///
  /// Should delete the request outside of the transaction so it's not rolled
  /// back.
  final OnExpiredCallback<T> onExpired;

  /// Links the completion token challenge to the request.
  ///
  /// Should update the request to link the completion challenge ID.
  /// May throw [ChallengeAlreadyUsedException] if the challenge has already
  /// been linked.
  final LinkCompletionTokenCallback<T> linkCompletionToken;

  /// Optional rate limiting for verification attempts.
  ///
  /// If provided, rate limiting will be handled internally by [SecretChallengeUtil].
  /// If not provided, no rate limiting will be applied.
  final RateLimitedRequestAttemptUtil<UuidValue>? rateLimiter;

  /// Creates a new [SecretChallengeVerificationConfig].
  SecretChallengeVerificationConfig({
    required this.getRequest,
    required this.isAlreadyUsed,
    required this.getChallenge,
    required this.isExpired,
    required this.onExpired,
    required this.linkCompletionToken,
    this.rateLimiter,
  });
}

/// Configuration for completion token validation with all protection mechanisms.
///
/// This class provides callbacks for workflow-specific logic while keeping the
/// core completion token validation logic generic and reusable.
///
/// Type parameter [T] represents the request type (e.g.,
/// EmailAccountRequest, EmailAccountPasswordResetRequest).
class SecretChallengeCompletionConfig<T> {
  /// Retrieves the request by ID.
  ///
  /// Should include the completion challenge relation in the query.
  /// Returns `null` if the request is not found.
  final GetRequestCallback<T> getRequest;

  /// Extracts the completion challenge from the request.
  ///
  /// Returns `null` if the request has not been verified yet (completion
  /// challenge not linked).
  final SecretChallenge? Function(T request) getCompletionChallenge;

  /// Checks if the request has expired.
  final bool Function(T request) isExpired;

  /// Called when the request has expired.
  ///
  /// Should delete the request outside of the transaction so it's not rolled
  /// back.
  final OnExpiredCallback<T> onExpired;

  /// Optional rate limiting for completion attempts.
  ///
  /// If provided, rate limiting will be handled internally by [SecretChallengeUtil].
  /// If not provided, no rate limiting will be applied.
  final RateLimitedRequestAttemptUtil<UuidValue>? rateLimiter;

  /// Creates a new [SecretChallengeCompletionConfig].
  SecretChallengeCompletionConfig({
    required this.getRequest,
    required this.getCompletionChallenge,
    required this.isExpired,
    required this.onExpired,
    this.rateLimiter,
  });
}

/// Extension methods for [SecretChallengeVerificationConfig].
extension SecretChallengeVerificationConfigExtension<T>
    on SecretChallengeVerificationConfig<T> {
  /// Records an attempts and checks if the request has too many attempts.
  ///
  /// Returns `true` if the request has too many attempts, `false` otherwise.
  /// If no rate limiter is provided, returns `false`.
  Future<bool> hasTooManyAttempts(
    final Session session, {
    required final UuidValue nonce,
    final Map<String, String>? extraData,
  }) async {
    return await rateLimiter?.hasTooManyAttempts(
          session,
          nonce: nonce,
          extraData: extraData,
        ) ??
        false;
  }
}

/// Extension methods for [SecretChallengeCompletionConfig].
extension SecretChallengeCompletionConfigExtension<T>
    on SecretChallengeCompletionConfig<T> {
  /// Records an attempts and checks if the request has too many attempts.
  ///
  /// Returns `true` if the request has too many attempts, `false` otherwise.
  /// If no rate limiter is provided, returns `false`.
  Future<bool> hasTooManyAttempts(
    final Session session, {
    required final UuidValue nonce,
    final Map<String, String>? extraData,
  }) async {
    return await rateLimiter?.hasTooManyAttempts(
          session,
          nonce: nonce,
          extraData: extraData,
        ) ??
        false;
  }
}
