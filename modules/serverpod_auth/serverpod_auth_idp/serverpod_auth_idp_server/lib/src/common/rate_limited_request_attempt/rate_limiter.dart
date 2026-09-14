import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';

import '../../../core.dart';
import '../../utils/session_extension.dart';

/// Tracks attempts for opaque string keys scoped by domain and source.
///
/// Callers provide a stable string representation, for example `requestId.uuid`.
abstract class RateLimiter {
  /// The namespace, limit, and optional rolling window.
  final RateLimiterConfig config;

  /// Creates a limiter with the given configuration.
  RateLimiter(this.config);

  /// Atomically admits and records an attempt if budget remains.
  ///
  /// Returns `true` when recorded, or `false` when rejected. Rejected attempts
  /// are not recorded and invoke [RateLimiterConfig.onRateLimitExceeded].
  /// Admitted attempts survive a rollback of the caller's transaction.
  Future<bool> tryRecordAttempt(
    final Session session, {
    required final String key,
    final Map<String, String>? extraData,
  });

  /// Counts attempts for [key] within the configured window, or all time.
  Future<int> countAttempts(
    final Session session, {
    required final String key,
    final Transaction? transaction,
  });

  /// Deletes attempts within this limiter's domain and source.
  ///
  /// If [key] is omitted, matches every key in this scope. If [before] is
  /// provided, only attempts strictly before it are removed. Omitting [before]
  /// removes all matching attempts, regardless of the configured window.
  /// Returns the number of deleted attempts.
  Future<int> deleteAttempts(
    final Session session, {
    final String? key,
    final DateTime? before,
    final Transaction? transaction,
  });
}

/// Tracks attempts using the [RateLimitedRequestAttempt] model.
///
/// Admitted attempts are committed independently of the caller's transaction.
/// Rejected attempts are rolled back before the rate limit callback runs.
class DatabaseRateLimiter extends RateLimiter {
  /// Creates a new [DatabaseRateLimiter] instance.
  DatabaseRateLimiter(super.config);

  @override
  Future<bool> tryRecordAttempt(
    final Session session, {
    required final String key,
    final Map<String, String>? extraData,
  }) async {
    // NOTE: The attempt counting runs in a separate transaction, so that it is
    // never rolled back with the parent transaction.
    final rateLimitExceeded = await session.db.transaction((
      final transaction,
    ) async {
      // Taken before the savepoint, so that rolling the savepoint back on a
      // rate limited attempt does not release it early.
      await _lockAttemptKey(session, key: key, transaction: transaction);

      final savePoint = await transaction.createSavepoint();
      await _recordAttempt(
        session,
        key: key,
        extraData: extraData,
        transaction: transaction,
      );

      final attemptCount = await countAttempts(
        session,
        key: key,
        transaction: transaction,
      );

      final isRateLimited = attemptCount > config.maxAttempts;

      if (isRateLimited) {
        await savePoint.rollback();
        return true;
      }

      await savePoint.release();
      return false;
    });

    if (rateLimitExceeded) {
      await config.onRateLimitExceeded?.call(session, key);
    }

    return !rateLimitExceeded;
  }

  /// Serialises concurrent [tryRecordAttempt] checks for the same [key].
  ///
  /// Recording the attempt and counting the attempts are two statements, and
  /// two PostgreSQL transactions running them at once cannot see each other's
  /// uncommitted insert. Without a lock both would read the same count and both
  /// would be let through, so a burst of parallel requests would spend the
  /// budget once between them instead of once each.
  ///
  /// A transaction scoped advisory lock for the bucket makes the pair
  /// atomic against other checks for the same key while leaving different
  /// keys free to run in parallel. It is released when the transaction ends.
  ///
  /// No-op on SQLite, which permits only one write transaction at a time and
  /// therefore already serialises these checks - the same reasoning that makes
  /// `lockRows` a no-op on that adapter.
  Future<void> _lockAttemptKey(
    final Session session, {
    required final String key,
    required final Transaction transaction,
  }) async {
    if (session.db.dialect != DatabaseDialect.postgres) return;

    await session.db.unsafeQuery(
      'SELECT pg_advisory_xact_lock(@key)',
      parameters: QueryParameters.named({'key': _lockKey(key)}),
      transaction: transaction,
    );
  }

  /// A stable 64 bit key for [key] within this limiter's domain and source.
  ///
  /// FNV-1a. A collision would only make two unrelated keys wait on each
  /// other, never let an attempt through, so the hash carries no security
  /// weight.
  int _lockKey(final String key) {
    const offsetBasis = 0xcbf29ce484222325;
    const prime = 0x100000001b3;

    var hash = offsetBasis;
    for (final unit in utf8.encode(
      '${config.domain}:${config.source}:$key',
    )) {
      hash = (hash ^ unit) * prime;
    }

    return hash;
  }

  Future<void> _recordAttempt(
    final Session session, {
    required final String key,
    final Map<String, String>? extraData,
    final Transaction? transaction,
  }) async {
    final combinedExtraData = {...?config.defaultExtraData, ...?extraData};

    final attempt = RateLimitedRequestAttempt(
      domain: config.domain,
      source: config.source,
      key: key,
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
    required final String key,
    final Transaction? transaction,
  }) async {
    return await RateLimitedRequestAttempt.db.count(
      session,
      where: (final t) {
        var expression =
            t.domain.equals(config.domain) &
            t.source.equals(config.source) &
            t.key.equals(key);

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
    final String? key,
    final DateTime? before,
    final Transaction? transaction,
  }) async {
    final deletedAttempts = await RateLimitedRequestAttempt.db.deleteWhere(
      session,
      where: (final t) {
        var expression =
            t.domain.equals(config.domain) & t.source.equals(config.source);
        if (before != null) {
          expression &= t.attemptedAt < before;
        }
        if (key != null) {
          expression &= t.key.equals(key);
        }
        return expression;
      },
      transaction: transaction,
    );

    return deletedAttempts.length;
  }
}
