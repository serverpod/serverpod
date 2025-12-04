import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';

import '../../../core.dart';
import '../../utils/session_extension.dart';

/// {@template rate_limited_request_attempt_util}
/// Utility class for tracking and rate limiting request attempts.
///
/// This class provides a reusable mechanism for rate limiting requests based on:
/// - Attempt count: Limits the total number of attempts
/// - Timeframe: Limits attempts within a rolling window
///
/// Both mechanisms can be used together, but at least one must be provided.
///
/// The [T] type parameter represents the type of the nonce.
/// {@endtemplate}
abstract class RateLimitedRequestAttemptUtil<T> {
  /// The configuration for the rate limiting.
  final RateLimitedRequestAttemptConfig<T> config;

  /// Creates a new [RateLimitedRequestAttemptUtil] instance.
  ///
  /// [config] specifies the domain, source, and rate limiting parameters.
  RateLimitedRequestAttemptUtil(this.config);

  /// Checks if the attempt is rate limited.
  ///
  /// If the attempt is rate limited, an [RateLimitedRequestAttemptException]
  /// is thrown.
  ///
  /// [nonce] is the unique identifier for the request (e.g., email, request ID, token).
  /// [extraData] is optional additional data to log with the attempt.
  Future<void> abortIfTooManyAttempts(
    final Session session, {
    required final T nonce,
    final Map<String, String>? extraData,
  }) async {
    final isRateLimited = await hasTooManyAttempts(
      session,
      nonce: nonce,
      extraData: extraData,
    );
    if (isRateLimited) {
      await config.onRateLimitExceeded?.call(session, nonce);
      throw RateLimitedRequestAttemptException();
    }
  }

  /// Checks if there have been too many attempts for the given nonce.
  ///
  /// [nonce] is the unique identifier for the request (e.g., email, request ID, token).
  /// [extraData] is optional additional data to log with the attempt.
  ///
  /// Returns `true` if the rate limit has been exceeded, `false` otherwise.
  Future<bool> hasTooManyAttempts(
    final Session session, {
    required final T nonce,
    final Map<String, String>? extraData,
  });

  /// Records an attempt for the given nonce.
  ///
  /// [nonce] is the unique identifier for the request (e.g., email, request ID, token).
  /// [extraData] is optional additional data to log with the attempt.
  Future<void> recordAttempt(
    final Session session, {
    required final T nonce,
    final Map<String, String>? extraData,
  });

  /// Counts the number of attempts for the given nonce.
  ///
  /// [nonce] is the unique identifier for the request (e.g., email, request ID, token).
  Future<int> countAttempts(
    final Session session, {
    required final T nonce,
  });

  /// Deletes all attempts that match the given filters.
  ///
  /// If [nonce] is provided, only attempts for the given nonce will be deleted.
  /// If [olderThan] is provided, only attempts older than the given duration will be deleted.
  ///
  /// If both are provided, only attempts for the given nonce and older than the
  /// given duration will be deleted.
  ///
  /// Returns the number of attempts deleted.
  Future<void> deleteAttempts(
    final Session session, {
    required final T nonce,
    final Duration? olderThan,
  });
}

/// {@macro rate_limited_request_attempt_util}
///
/// This rate limiting implementation uses the [RateLimitedRequestAttempt] model
/// to track attempts. Each attempt is logged in a separate transaction that is
/// never rolled back, ensuring rate limiting is always enforced.
class DatabaseRateLimitedRequestAttemptUtil<T>
    extends RateLimitedRequestAttemptUtil<T> {
  /// Creates a new [DatabaseRateLimitedRequestAttemptUtil] instance.
  DatabaseRateLimitedRequestAttemptUtil(super.config);

  @override
  Future<bool> hasTooManyAttempts(
    final Session session, {
    required final T nonce,
    final Map<String, String>? extraData,
  }) async {
    // NOTE: The attempt counting runs in a separate transaction, so that it is
    // never rolled back with the parent transaction.
    return session.db.transaction((final transaction) async {
      final savePoint = await transaction.createSavepoint();
      await recordAttempt(
        session,
        nonce: nonce,
        extraData: extraData,
        transaction: transaction,
      );

      final attemptCount = await countAttempts(
        session,
        nonce: nonce,
        transaction: transaction,
      );

      final isRateLimited =
          config.maxAttempts != null && attemptCount > config.maxAttempts!;

      if (isRateLimited) {
        await savePoint.rollback();
        return true;
      }

      await savePoint.release();
      return false;
    });
  }

  @override
  Future<void> recordAttempt(
    final Session session, {
    required final T nonce,
    final Map<String, String>? extraData,
    final Transaction? transaction,
  }) async {
    final combinedExtraData = {...?config.defaultExtraData, ...?extraData};

    final attempt = RateLimitedRequestAttempt(
      domain: config.domain,
      source: config.source,
      nonce: config.nonceToString(nonce),
      ipAddress: session.remoteIpAddress.toString(),
      attemptedAt: clock.now(),
      extraData: combinedExtraData.isNotEmpty ? combinedExtraData : null,
    );

    await RateLimitedRequestAttempt.db.insertRow(
      session,
      attempt,
      transaction: transaction,
    );
  }

  @override
  Future<int> countAttempts(
    final Session session, {
    required final T nonce,
    final Transaction? transaction,
  }) async {
    return await RateLimitedRequestAttempt.db.count(
      session,
      where: (final t) {
        var expression =
            t.domain.equals(config.domain) &
            t.source.equals(config.source) &
            t.nonce.equals(config.nonceToString(nonce));

        if (config.timeframe != null) {
          final oldestRelevantAttemptTimestamp = clock.now().subtract(
            config.timeframe!,
          );
          expression &= t.attemptedAt > oldestRelevantAttemptTimestamp;
        }

        return expression;
      },
      transaction: transaction,
    );
  }

  @override
  Future<int> deleteAttempts(
    final Session session, {
    final T? nonce,
    final Duration? olderThan,
    final Transaction? transaction,
  }) async {
    final timeframe = olderThan ?? config.timeframe ?? Duration.zero;
    final removeBefore = clock.now().subtract(timeframe);

    final deletedAttempts = await RateLimitedRequestAttempt.db.deleteWhere(
      session,
      where: (final t) {
        var expression =
            t.domain.equals(config.domain) &
            t.source.equals(config.source) &
            (t.attemptedAt < removeBefore);
        if (nonce != null) {
          expression &= t.nonce.equals(config.nonceToString(nonce));
        }
        return expression;
      },
      transaction: transaction,
    );

    return deletedAttempts.length;
  }
}
