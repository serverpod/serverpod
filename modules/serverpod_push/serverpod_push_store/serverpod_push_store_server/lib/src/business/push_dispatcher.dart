import 'dart:async';

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_push_core_server/serverpod_push_core_server.dart';
import 'package:serverpod_shared/log.dart';

import '../generated/protocol.dart';
import 'push_backoff.dart';
import 'push_circuit_breaker.dart';
import 'push_notifications.dart';
import 'push_store_config.dart';

enum _Task { reap, expire, retain }

/// Durable-queue dispatcher: claim, send, complete, reap, expire, retain.
class PushDispatcher {
  /// Creates a dispatcher bound to [serverpod].
  PushDispatcher({
    required final Serverpod serverpod,
    required final PushStoreConfig config,
  }) : _serverpod = serverpod,
       _config = config,
       _claimOwner = '${serverpod.serverId}/${const Uuid().v4()}';

  final Serverpod _serverpod;
  final PushStoreConfig _config;
  final String _claimOwner;

  Session? _session;
  Timer? _timer;
  var _cycleInFlight = false;
  var _stopping = false;
  DateTime? _startedAt;
  final _lastRun = <_Task, DateTime>{};
  final _breakers = <String, PushCircuitBreaker>{};
  final _inFlightSends = <Future<void>>{};

  static const _terminalStatuses = {
    PushDeliveryStatus.accepted,
    PushDeliveryStatus.abandoned,
    PushDeliveryStatus.discarded,
    PushDeliveryStatus.expired,
  };

  static const _claimableStatuses = {
    PushDeliveryStatus.pending,
    PushDeliveryStatus.failed,
  };

  /// Owner token written to `claimedBy`.
  String get claimOwner => _claimOwner;

  /// Opens the dispatcher session without starting the scan timer.
  @visibleForTesting
  Future<void> attachSessionForTest() async {
    _session ??= await _serverpod.createSession(enableLogging: false);
    _startedAt ??= clock.now().toUtc();
  }

  /// Runs one dispatcher cycle. When [forceMaintenance] is true, the reaper,
  /// expiry sweep, and retention all run regardless of cadence.
  @visibleForTesting
  Future<void> runCycleForTest({
    final bool forceMaintenance = false,
  }) async {
    if (_session == null) {
      await attachSessionForTest();
    }
    if (forceMaintenance) {
      _startedAt = clock.now().toUtc().subtract(const Duration(days: 2));
      _lastRun.clear();
    }
    await _tick();
  }

  /// Starts the scan timer. Creates a long-lived internal session.
  Future<void> start() async {
    _session = await _serverpod.createSession(enableLogging: false);
    _startedAt = clock.now().toUtc();
    _timer = Timer.periodic(_config.scanInterval, (final _) {
      unawaited(_tick());
    });
    unawaited(_tick());
  }

  /// Stops claiming, waits for in-flight sends, then releases unsent claims.
  Future<void> stopAndReleaseClaims() async {
    _stopping = true;
    _timer?.cancel();
    _timer = null;
    await Future.wait(_inFlightSends);
    final session = _session;
    if (session != null) {
      try {
        await PushDelivery.db.updateWhere(
          session,
          columnValues: (final t) => [
            t.status(PushDeliveryStatus.pending),
            t.nextAttemptAt(clock.now().toUtc()),
            t.claimedBy(null),
            t.claimedAt(null),
          ],
          where: (final t) =>
              t.status.equals(PushDeliveryStatus.sending) &
              t.claimedBy.equals(_claimOwner),
        );
      } catch (e, st) {
        _reportError(e, st, 'Failed to release push claims on shutdown.');
      }
      await session.close();
      _session = null;
    }
  }

  Future<void> _tick() async {
    if (_cycleInFlight || _stopping) return;
    _cycleInFlight = true;
    try {
      final now = await _dbNow();
      if (_due(_Task.reap, now, const Duration(minutes: 1))) {
        await _reapStaleClaims(now);
      }
      if (_due(_Task.expire, now, const Duration(minutes: 1))) {
        await _sweepExpired(now);
      }
      await _dispatch(now);
      if (_due(_Task.retain, now, const Duration(hours: 1))) {
        await _retentionPass(now);
      }
    } catch (e, st) {
      _reportError(e, st, 'serverpod_push dispatcher cycle failed');
    } finally {
      _cycleInFlight = false;
    }
  }

  bool _due(final _Task task, final DateTime now, final Duration cadence) {
    final last = _lastRun[task] ?? _startedAt;
    if (last != null && now.difference(last) < cadence) return false;
    _lastRun[task] = now;
    return true;
  }

  Future<DateTime> _dbNow() async {
    final result = await _session!.db.unsafeQuery(
      "SELECT (NOW() AT TIME ZONE 'UTC') AS now",
    );
    final value = result.first.first;
    if (value is DateTime) return value.toUtc();
    return DateTime.parse(value.toString()).toUtc();
  }

  Future<void> _dispatch(final DateTime now) async {
    for (final provider in PushService.instance.providers) {
      if (_stopping) return;
      final breaker = _breaker(provider.provider);
      if (breaker.isOpen(now)) {
        log.warning(
          'serverpod_push: skipping provider "${provider.provider}" '
          '(circuit open until ${breaker.openUntil}).',
        );
        continue;
      }
      await _dispatchProvider(provider, now);
    }
  }

  Future<void> _dispatchProvider(
    final PushProvider provider,
    final DateTime now,
  ) async {
    final budget = provider.maxConcurrentRequests * _config.batchesInFlight;
    while (!_stopping) {
      final claimed = await _claimBatch(provider.provider, now, budget);
      if (claimed.isEmpty) return;

      final byNotification = groupBy(
        claimed,
        (final d) => d.notificationId,
      );
      final jobs = <List<PushDelivery>>[];
      for (final group in byNotification.values) {
        for (final chunk in group.slices(provider.maxTargetsPerRequest)) {
          jobs.add(chunk.toList());
        }
      }

      var next = 0;
      Future<void> worker() async {
        while (true) {
          final index = next++;
          if (index >= jobs.length) return;
          await _sendJob(provider, jobs[index], now);
        }
      }

      final workers = [
        for (
          var i = 0;
          i < provider.maxConcurrentRequests && i < jobs.length;
          i++
        )
          worker(),
      ];
      final done = Future.wait(workers);
      _inFlightSends.add(done);
      try {
        await done;
      } finally {
        _inFlightSends.remove(done);
      }

      if (claimed.length < budget) return;
    }
  }

  Future<List<PushDelivery>> _claimBatch(
    final String providerId,
    final DateTime now,
    final int budget,
  ) {
    if (budget <= 0) return Future.value(const []);
    return _session!.db.transaction((final transaction) async {
      final claimed = await PushDelivery.db.find(
        _session!,
        where: (final t) =>
            t.provider.equals(providerId) &
            t.status.inSet(_claimableStatuses) &
            (t.nextAttemptAt <= now) &
            (t.expiresAt.equals(null) | (t.expiresAt > now)),
        orderBy: (final t) => t.nextAttemptAt,
        limit: budget,
        transaction: transaction,
        lockMode: LockMode.forUpdate,
        lockBehavior: LockBehavior.skipLocked,
        include: PushDelivery.include(
          notification: PushNotification.include(),
          device: PushDevice.include(),
        ),
      );
      if (claimed.isEmpty) return claimed;

      return PushDelivery.db.update(
        _session!,
        [
          for (final d in claimed)
            d.copyWith(
              status: PushDeliveryStatus.sending,
              claimedBy: _claimOwner,
              claimedAt: now,
              claimCount: d.claimCount + 1,
              firstAttemptAt: d.firstAttemptAt ?? now,
            ),
        ],
        columns: (final t) => [
          t.status,
          t.claimedBy,
          t.claimedAt,
          t.claimCount,
          t.firstAttemptAt,
        ],
        transaction: transaction,
      );
    });
  }

  Future<void> _sendJob(
    final PushProvider provider,
    final List<PushDelivery> deliveries,
    final DateTime now,
  ) async {
    if (deliveries.isEmpty) return;
    final notification = deliveries.first.notification;
    if (notification == null ||
        notification.schemaVersion > pushMessageSchemaVersion) {
      for (final delivery in deliveries) {
        await _completeRow(
          delivery,
          now,
          PushSendResult(
            target: PushDeviceTarget(
              provider: '',
              credential: '',
              platform: PushPlatform.android,
            ),
            outcome: PushDeliveryOutcome.retryable,
            errorCode: 'SCHEMA',
            errorMessage: 'Notification missing or schemaVersion too new.',
          ),
        );
      }
      return;
    }

    final requests = <PushSendRequest>[];
    final requestDeliveries = <PushDelivery>[];
    for (final delivery in deliveries) {
      final device = delivery.device;
      if (device == null || device.disabledAt != null) {
        await _completeRow(
          delivery,
          now,
          PushSendResult(
            target: PushDeviceTarget(
              provider: delivery.provider,
              credential: device?.credential ?? '',
              platform: device?.platform ?? PushPlatform.android,
            ),
            outcome: PushDeliveryOutcome.invalidToken,
            errorCode: 'DEVICE_DISABLED',
          ),
        );
        continue;
      }
      requests.add(
        PushSendRequest(
          target: PushDeviceTarget(
            provider: device.provider,
            credential: device.credential,
            platform: device.platform,
          ),
          dataOverlay: {
            pushDeliveryIdDataKey: delivery.id!.uuid,
          },
          expiresAt:
              delivery.expiresAt ??
              delivery.createdAt.add(_config.maxDeliveryAge),
        ),
      );
      requestDeliveries.add(delivery);
    }
    if (requests.isEmpty) return;

    List<PushSendResult> results;
    try {
      results = await provider
          .send(message: notification.message, requests: requests)
          .timeout(provider.sendTimeout);
    } on TimeoutException {
      // Leave rows in `sending` so the reaper (claimTimeout > 2 * sendTimeout)
      // is what makes them claimable again — avoiding a duplicate send while
      // the original HTTP call is still in flight.
      return;
    } catch (e, st) {
      _reportError(e, st, 'Push provider "${provider.provider}" send failed.');
      results = [
        for (final request in requests)
          PushSendResult(
            target: request.target,
            outcome: PushDeliveryOutcome.retryable,
            errorMessage: e.toString(),
          ),
      ];
    }

    final byTarget = <String, PushSendResult>{};
    for (final result in results) {
      byTarget[_targetKey(result.target)] = result;
    }

    for (var i = 0; i < requestDeliveries.length; i++) {
      final delivery = requestDeliveries[i];
      final request = requests[i];
      final result =
          byTarget[_targetKey(request.target)] ??
          (i < results.length
              ? results[i]
              : PushSendResult(
                  target: request.target,
                  outcome: PushDeliveryOutcome.retryable,
                  errorMessage:
                      'Provider returned fewer results than requests.',
                ));
      await _completeRow(delivery, now, result);
    }
  }

  static String _targetKey(final PushDeviceTarget target) =>
      '${target.provider}\u0000${target.credential}\u0000${target.platform.name}';

  Future<void> _completeRow(
    final PushDelivery delivery,
    final DateTime now,
    final PushSendResult result,
  ) {
    return _session!.db.transaction((final txn) async {
      var status = delivery.status;
      var attempts = delivery.attempts;
      var backoffExponent = delivery.backoffExponent;
      var nextAttemptAt = delivery.nextAttemptAt;
      var lastOutcome = result.outcome;
      final lastErrorCode = result.errorCode;
      var lastErrorMessage = result.errorMessage;
      var providerMessageId = delivery.providerMessageId;

      final ageExpired = !delivery.createdAt
          .add(_config.maxDeliveryAge)
          .isAfter(now);
      final crashBudgetExhausted = delivery.claimCount >= _config.maxClaims;

      if (ageExpired && result.outcome != PushDeliveryOutcome.accepted) {
        status = PushDeliveryStatus.expired;
        lastOutcome = PushDeliveryOutcome.expired;
      } else if (crashBudgetExhausted &&
          result.outcome != PushDeliveryOutcome.accepted &&
          result.outcome != PushDeliveryOutcome.invalidToken &&
          result.outcome != PushDeliveryOutcome.expired &&
          result.outcome != PushDeliveryOutcome.rateLimited) {
        status = PushDeliveryStatus.abandoned;
        lastErrorMessage = lastErrorMessage ?? 'maxClaims exhausted';
      } else {
        switch (result.outcome) {
          case PushDeliveryOutcome.accepted:
            status = PushDeliveryStatus.accepted;
            attempts += 1;
            providerMessageId = result.providerMessageId ?? providerMessageId;
          case PushDeliveryOutcome.retryable:
            attempts += 1;
            backoffExponent += 1;
            if (attempts >= _config.maxAttempts) {
              status = PushDeliveryStatus.abandoned;
            } else {
              status = PushDeliveryStatus.failed;
              nextAttemptAt = now.add(pushBackoff(backoffExponent, _config));
            }
          case PushDeliveryOutcome.rateLimited:
            backoffExponent += 1;
            status = PushDeliveryStatus.failed;
            final backoff = pushBackoff(backoffExponent, _config);
            final retryAfter = result.retryAfter ?? Duration.zero;
            nextAttemptAt = now.add(
              backoff >= retryAfter ? backoff : retryAfter,
            );
          case PushDeliveryOutcome.invalidToken:
            attempts += 1;
            status = PushDeliveryStatus.discarded;
            await _discardDeviceAndSiblings(
              txn,
              delivery,
              now,
            );
          case PushDeliveryOutcome.permanentFailure:
            attempts += 1;
            status = PushDeliveryStatus.abandoned;
          case PushDeliveryOutcome.expired:
            status = PushDeliveryStatus.expired;
        }
      }

      await PushDelivery.db.updateWhere(
        _session!,
        columnValues: (final t) => [
          t.status(status),
          t.attempts(attempts),
          t.backoffExponent(backoffExponent),
          t.nextAttemptAt(nextAttemptAt),
          t.lastAttemptAt(now),
          t.lastOutcome(lastOutcome),
          t.lastErrorCode(lastErrorCode),
          t.lastErrorMessage(lastErrorMessage),
          t.providerMessageId(providerMessageId),
          t.claimedBy(null),
          t.claimedAt(null),
        ],
        where: (final t) =>
            t.id.equals(delivery.id) &
            t.status.equals(PushDeliveryStatus.sending),
        transaction: txn,
      );

      final breaker = _breaker(delivery.provider);
      if (result.outcome == PushDeliveryOutcome.retryable &&
          PushCircuitBreaker.isAuthFailure(result.errorCode)) {
        breaker.recordAuthFailure(now);
        if (breaker.isOpen(now)) {
          log.error(
            'serverpod_push: circuit open for "${delivery.provider}" '
            'until ${breaker.openUntil}.',
          );
          _reportError(
            StateError('Push provider "${delivery.provider}" circuit open.'),
            StackTrace.current,
            'Auth circuit breaker opened for "${delivery.provider}".',
          );
        }
      } else if (result.outcome == PushDeliveryOutcome.accepted) {
        breaker.recordSuccess();
      }
    });
  }

  Future<void> _discardDeviceAndSiblings(
    final Transaction txn,
    final PushDelivery delivery,
    final DateTime now,
  ) async {
    await PushDevice.db.updateWhere(
      _session!,
      columnValues: (final t) => [
        t.disabledAt(now),
        t.disabledReason('invalidToken'),
      ],
      where: (final t) => t.id.equals(delivery.deviceId),
      transaction: txn,
    );
    await PushDelivery.db.updateWhere(
      _session!,
      columnValues: (final t) => [
        t.status(PushDeliveryStatus.discarded),
        t.claimedBy(null),
        t.claimedAt(null),
        t.lastOutcome(PushDeliveryOutcome.invalidToken),
        t.lastAttemptAt(now),
      ],
      where: (final t) =>
          t.deviceId.equals(delivery.deviceId) &
          t.id.notEquals(delivery.id) &
          t.status.inSet({
            PushDeliveryStatus.pending,
            PushDeliveryStatus.failed,
            PushDeliveryStatus.sending,
          }),
      transaction: txn,
    );
  }

  Future<void> _reapStaleClaims(final DateTime now) async {
    final stale =
        PushDelivery.t.status.equals(PushDeliveryStatus.sending) &
        (PushDelivery.t.claimedAt < now.subtract(_config.claimTimeout));

    // Crash budget is checked here, not only at send completion: a send that
    // always times out never reaches `_completeRow`, and would otherwise
    // retry forever with `attempts` stuck at 0.
    await PushDelivery.db.updateWhere(
      _session!,
      columnValues: (final t) => [
        t.status(PushDeliveryStatus.abandoned),
        t.claimedBy(null),
        t.claimedAt(null),
        t.lastErrorMessage('maxClaims exhausted'),
      ],
      where: (final t) => stale & (t.claimCount >= _config.maxClaims),
    );
    await PushDelivery.db.updateWhere(
      _session!,
      columnValues: (final t) => [
        t.status(PushDeliveryStatus.failed),
        t.nextAttemptAt(now),
        t.claimedBy(null),
        t.claimedAt(null),
      ],
      where: (final t) => stale,
    );
  }

  Future<void> _sweepExpired(final DateTime now) async {
    await PushDelivery.db.updateWhere(
      _session!,
      columnValues: (final t) => [
        t.status(PushDeliveryStatus.expired),
        t.claimedBy(null),
        t.claimedAt(null),
      ],
      where: (final t) =>
          t.status.inSet(_claimableStatuses) &
          ((t.expiresAt.notEquals(null) & (t.expiresAt <= now)) |
              (t.createdAt < now.subtract(_config.maxDeliveryAge))),
      limit: _config.sweepBatchSize,
    );
  }

  Future<void> _retentionPass(final DateTime now) async {
    final cutoff = now.subtract(_config.retentionPeriod);

    for (var i = 0; i < _config.maxRetentionBatchesPerPass; i++) {
      final ids = (await PushDelivery.db.find(
        _session!,
        where: (final t) =>
            t.status.inSet(_terminalStatuses) & (t.createdAt < cutoff),
        limit: _config.retentionBatchSize,
      )).map((final d) => d.id!).toSet();
      if (ids.isEmpty) break;

      await PushDelivery.db.deleteWhere(
        _session!,
        where: (final t) => t.id.inSet(ids),
        noReturn: true,
      );
      if (ids.length < _config.retentionBatchSize) break;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }

    await PushNotification.db.deleteWhere(
      _session!,
      where: (final t) =>
          ((t.dedupeExpiresAt.notEquals(null) & (t.dedupeExpiresAt <= now)) |
              (t.dedupeExpiresAt.equals(null) & (t.createdAt < cutoff))) &
          t.deliveries.none(),
      noReturn: true,
    );
  }

  PushCircuitBreaker _breaker(final String providerId) {
    return _breakers.putIfAbsent(
      providerId,
      () => PushCircuitBreaker(_config),
    );
  }

  void _reportError(
    final Object error,
    final StackTrace stackTrace,
    final String message,
  ) {
    log.error('serverpod_push: $message', error: error, stackTrace: stackTrace);
    final session = _session;
    if (session != null) {
      _serverpod.experimental.submitDiagnosticEvent(
        ExceptionEvent(error, stackTrace, message: message),
        session: session,
      );
    }
  }
}
