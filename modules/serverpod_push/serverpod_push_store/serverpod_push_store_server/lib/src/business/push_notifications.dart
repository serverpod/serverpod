import 'package:collection/collection.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_push_core_server/serverpod_push_core_server.dart';

import '../generated/protocol.dart';
import 'push_enqueue_result.dart';
import 'push_store.dart';

/// Current [PushMessage] schema version written on every notification row.
const pushMessageSchemaVersion = 1;

/// Overlay probe used at enqueue to reserve space for the delivery-id key.
const _ackOverlaySizeProbe = {
  pushDeliveryIdDataKey: '00000000-0000-0000-0000-000000000000',
};

/// Server-side enqueue API.
class PushNotifications {
  /// Fan-out [message] to every enabled device belonging to [userIdentifiers].
  static Future<PushEnqueueResult> sendToUsers(
    final Session session, {
    required final PushMessage message,
    required final Iterable<String> userIdentifiers,
    final String? dedupeKey,
    final Duration? dedupeWindow,
    final DateTime? notBefore,
    final Transaction? transaction,
  }) {
    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      final txn,
    ) async {
      final devices = await _resolveEnabledDevices(
        session,
        userIdentifiers,
        txn,
      );
      return _enqueue(
        session,
        txn,
        message: message,
        devices: devices,
        dedupeKey: dedupeKey,
        dedupeWindow: dedupeWindow,
        notBefore: notBefore,
      );
    });
  }

  /// Fan-out [message] to an explicit device list.
  static Future<PushEnqueueResult> sendToDevices(
    final Session session, {
    required final PushMessage message,
    required final Iterable<UuidValue> deviceIds,
    final String? dedupeKey,
    final Duration? dedupeWindow,
    final DateTime? notBefore,
    final Transaction? transaction,
  }) {
    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      final txn,
    ) async {
      final ids = deviceIds.toSet();
      if (ids.isEmpty) return PushEnqueueResult.empty();
      final devices = await PushDevice.db.find(
        session,
        where: (final t) =>
            t.id.inSet(ids) & t.disabledAt.equals(null),
        transaction: txn,
      );
      return _enqueue(
        session,
        txn,
        message: message,
        devices: devices,
        dedupeKey: dedupeKey,
        dedupeWindow: dedupeWindow,
        notBefore: notBefore,
      );
    });
  }

  static Future<PushEnqueueResult> _enqueue(
    final Session session,
    final Transaction txn, {
    required final PushMessage message,
    required final List<PushDevice> devices,
    required final String? dedupeKey,
    required final Duration? dedupeWindow,
    required final DateTime? notBefore,
  }) async {
    final now = DateTime.now().toUtc();
    final expiresAt = message.timeToLive == null
        ? null
        : now.add(message.timeToLive!);
    final startAt = notBefore ?? now;

    if (expiresAt != null && !startAt.isBefore(expiresAt)) {
      throw PushInvalidScheduleException(
        notBefore: startAt,
        expiresAt: expiresAt,
      );
    }

    if (devices.isEmpty) {
      return PushEnqueueResult.empty();
    }

    final config = PushStore.instance.config;
    if (devices.length > config.maxFanOutPerEnqueue) {
      throw PushAudienceTooLargeException(
        devices.length,
        config.maxFanOutPerEnqueue,
      );
    }

    for (final providerId in devices.map((final d) => d.provider).toSet()) {
      final provider = PushService.instance.providerByIdOrThrow(providerId);
      final bytes = provider.payloadBytesFor(message, _ackOverlaySizeProbe);
      if (bytes > provider.maxPayloadBytes) {
        throw PushPayloadTooLargeException(
          providerId,
          bytes,
          provider.maxPayloadBytes,
        );
      }
      final ttl = message.timeToLive;
      if (ttl != null && ttl > provider.maxTimeToLive) {
        throw PushTimeToLiveTooLongException(
          providerId,
          ttl,
          provider.maxTimeToLive,
        );
      }
    }

    final notification = await _upsertNotification(
      session,
      txn,
      message: message,
      dedupeKey: dedupeKey,
      dedupeExpiresAt: dedupeKey == null
          ? null
          : now.add(dedupeWindow ?? config.defaultDedupeWindow),
    );

    var created = 0;
    for (final chunk in devices.slices(config.fanOutBatchSize)) {
      final inserted = await PushDelivery.db.insert(
        session,
        [
          for (final device in chunk)
            PushDelivery(
              notificationId: notification.row.id!,
              deviceId: device.id!,
              provider: device.provider,
              status: PushDeliveryStatus.pending,
              nextAttemptAt: startAt,
              expiresAt: expiresAt,
            ),
        ],
        ignoreConflicts: true,
        transaction: txn,
      );
      created += inserted.length;
    }

    return PushEnqueueResult(
      notificationId: notification.row.id!,
      deduped: notification.reused,
      deliveriesCreated: created,
    );
  }

  static Future<List<PushDevice>> _resolveEnabledDevices(
    final Session session,
    final Iterable<String> userIdentifiers,
    final Transaction txn,
  ) async {
    final ids = userIdentifiers.toSet();
    if (ids.isEmpty) return const [];
    return PushDevice.db.find(
      session,
      where: (final t) =>
          t.userIdentifier.inSet(ids) & t.disabledAt.equals(null),
      transaction: txn,
    );
  }

  static Future<({PushNotification row, bool reused})> _upsertNotification(
    final Session session,
    final Transaction txn, {
    required final PushMessage message,
    required final String? dedupeKey,
    required final DateTime? dedupeExpiresAt,
  }) async {
    if (dedupeKey == null) {
      final row = await PushNotification.db.insertRow(
        session,
        PushNotification(
          message: message,
          schemaVersion: pushMessageSchemaVersion,
        ),
        transaction: txn,
      );
      return (row: row, reused: false);
    }

    for (var attempt = 0; attempt < 2; attempt++) {
      final inserted = await PushNotification.db.insert(
        session,
        [
          PushNotification(
            message: message,
            schemaVersion: pushMessageSchemaVersion,
            dedupeKey: dedupeKey,
            dedupeExpiresAt: dedupeExpiresAt,
          ),
        ],
        ignoreConflicts: true,
        transaction: txn,
      );
      if (inserted.isNotEmpty) {
        return (row: inserted.single, reused: false);
      }

      final existing = await PushNotification.db.findFirstRow(
        session,
        where: (final t) => t.dedupeKey.equals(dedupeKey),
        transaction: txn,
      );
      if (existing != null) {
        return (row: existing, reused: true);
      }
    }

    throw StateError(
      'Failed to insert or read back push notification for dedupeKey '
      '"$dedupeKey".',
    );
  }
}
