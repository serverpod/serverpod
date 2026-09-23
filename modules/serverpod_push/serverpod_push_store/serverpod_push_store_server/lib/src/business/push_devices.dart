import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_push_core_server/serverpod_push_core_server.dart';

import '../generated/protocol.dart';
import 'crypto_util.dart';

/// Device registration, unregistration, acknowledge, and purge.
class PushDevices {
  /// Upserts a device. Never downgrades an owned row to anonymous.
  static Future<void> register(
    final Session session, {
    required final String provider,
    required final String credential,
    required final PushPlatform platform,
    final String? installationId,
    final String? locale,
    final String? appVersion,
  }) async {
    final impl = PushService.instance.providerByIdOrThrow(provider);
    final identityHash = sha256Hex(impl.identityKeyFor(credential));
    final userIdentifier = session.authenticated?.userIdentifier;
    final now = clock.now().toUtc();

    await session.db.transaction((final txn) async {
      if (installationId != null) {
        final superseded = await PushDevice.db.find(
          session,
          where: (final t) =>
              t.provider.equals(provider) &
              t.identityHash.equals(identityHash) &
              t.installationId.notEquals(installationId) &
              t.disabledAt.equals(null),
          transaction: txn,
        );
        for (final row in superseded) {
          await PushDevice.db.updateRow(
            session,
            row.copyWith(
              disabledAt: now,
              disabledReason: 'superseded',
              identityHash: 'superseded:${row.id}:$identityHash',
            ),
            columns: (final t) => [
              t.disabledAt,
              t.disabledReason,
              t.identityHash,
            ],
            transaction: txn,
          );
        }
      }

      final existing = await _findExisting(
        session,
        txn,
        provider: provider,
        identityHash: identityHash,
        installationId: installationId,
      );

      final resolvedUser = userIdentifier ?? existing?.userIdentifier;
      final row = PushDevice(
        id: existing?.id,
        provider: provider,
        credential: credential,
        identityHash: identityHash,
        platform: platform,
        userIdentifier: resolvedUser,
        installationId: installationId ?? existing?.installationId,
        locale: locale ?? existing?.locale,
        appVersion: appVersion ?? existing?.appVersion,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
        disabledAt: null,
        disabledReason: null,
      );

      if (existing != null) {
        await PushDevice.db.updateRow(
          session,
          row,
          columns: (final t) => [
            t.credential,
            t.identityHash,
            t.platform,
            t.userIdentifier,
            t.installationId,
            t.locale,
            t.appVersion,
            t.updatedAt,
            t.disabledAt,
            t.disabledReason,
          ],
          transaction: txn,
        );
        return;
      }

      final conflictOnInstallation = installationId != null;
      await PushDevice.db.upsertRow(
        session,
        row,
        conflictColumns: (final t) => conflictOnInstallation
            ? [t.provider, t.installationId]
            : [t.provider, t.identityHash],
        updateColumns: (final t) => [
          t.credential,
          if (conflictOnInstallation) t.identityHash,
          t.platform,
          t.userIdentifier,
          if (!conflictOnInstallation) t.installationId,
          t.locale,
          t.appVersion,
          t.updatedAt,
          t.disabledAt,
          t.disabledReason,
        ],
        transaction: txn,
      );
    });
  }

  /// Soft-deletes a device. Owned rows require the owning user.
  static Future<void> unregister(
    final Session session, {
    required final String provider,
    required final String credential,
  }) async {
    final impl = PushService.instance.providerByIdOrThrow(provider);
    final identityHash = sha256Hex(impl.identityKeyFor(credential));
    final now = clock.now().toUtc();

    await session.db.transaction((final txn) async {
      final existing = await PushDevice.db.findFirstRow(
        session,
        where: (final t) =>
            t.provider.equals(provider) & t.identityHash.equals(identityHash),
        transaction: txn,
      );
      if (existing == null) return;

      final owner = existing.userIdentifier;
      if (owner != null) {
        final caller = session.authenticated?.userIdentifier;
        if (caller == null || caller != owner) {
          throw StateError(
            'Cannot unregister an owned push device without authenticating '
            'as the owner.',
          );
        }
      }

      await PushDevice.db.updateRow(
        session,
        existing.copyWith(
          disabledAt: now,
          disabledReason: 'unregistered',
          updatedAt: now,
        ),
        columns: (final t) => [t.disabledAt, t.disabledReason, t.updatedAt],
        transaction: txn,
      );
    });
  }

  /// Records that a delivery was received or opened.
  ///
  /// Possession of the delivery id (injected into the push payload) is the
  /// capability. Anonymous devices can therefore be acknowledged without
  /// login. Owned devices still require the owning user, so a leaked id
  /// cannot write another user's receipt timestamps.
  static Future<void> acknowledge(
    final Session session, {
    required final UuidValue deliveryId,
    required final PushAckType type,
  }) async {
    await session.db.transaction((final txn) async {
      final delivery = await PushDelivery.db.findById(
        session,
        deliveryId,
        transaction: txn,
        include: PushDelivery.include(device: PushDevice.include()),
      );
      if (delivery == null) {
        throw PushAcknowledgeException(
          reason: PushAcknowledgeFailureReason.notFound,
        );
      }

      final device = delivery.device;
      if (device == null) {
        throw PushAcknowledgeException(
          reason: PushAcknowledgeFailureReason.notFound,
        );
      }

      final owner = device.userIdentifier;
      if (owner != null) {
        final caller = session.authenticated?.userIdentifier;
        if (caller == null) {
          throw PushAcknowledgeException(
            reason: PushAcknowledgeFailureReason.anonymousDevice,
          );
        }
        if (caller != owner) {
          throw PushAcknowledgeException(
            reason: PushAcknowledgeFailureReason.notOwned,
          );
        }
      }

      final now = clock.now().toUtc();
      await PushDelivery.db.updateRow(
        session,
        type == PushAckType.received
            ? delivery.copyWith(receivedAt: now)
            : delivery.copyWith(openedAt: now),
        columns: (final t) => [
          if (type == PushAckType.received) t.receivedAt else t.openedAt,
        ],
        transaction: txn,
      );
    });
  }

  /// Hard-deletes a device and, via cascade, its delivery history.
  static Future<void> purgeDevice(
    final Session session, {
    required final UuidValue deviceId,
    final Transaction? transaction,
  }) {
    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      final txn,
    ) async {
      await PushDevice.db.deleteWhere(
        session,
        where: (final t) => t.id.equals(deviceId),
        transaction: txn,
        noReturn: true,
      );
    });
  }

  static Future<PushDevice?> _findExisting(
    final Session session,
    final Transaction txn, {
    required final String provider,
    required final String identityHash,
    required final String? installationId,
  }) async {
    if (installationId != null) {
      final byInstallation = await PushDevice.db.findFirstRow(
        session,
        where: (final t) =>
            t.provider.equals(provider) &
            t.installationId.equals(installationId),
        transaction: txn,
      );
      if (byInstallation != null) return byInstallation;
    }
    return PushDevice.db.findFirstRow(
      session,
      where: (final t) =>
          t.provider.equals(provider) & t.identityHash.equals(identityHash),
      transaction: txn,
    );
  }
}
