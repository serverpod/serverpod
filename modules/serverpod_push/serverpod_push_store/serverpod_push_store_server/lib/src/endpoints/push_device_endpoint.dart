import 'package:serverpod/serverpod.dart';
import 'package:serverpod_push_core_server/serverpod_push_core_server.dart';

import '../business/push_devices.dart';

/// Device registration endpoint. Anonymous registration is legitimate;
/// deployments should rate-limit this endpoint at the edge.
class PushDeviceEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  /// Registers or updates a device token.
  Future<void> registerDevice(
    final Session session, {
    required final String provider,
    required final String credential,
    required final PushPlatform platform,
    final String? installationId,
    final String? locale,
    final String? appVersion,
  }) {
    return PushDevices.register(
      session,
      provider: provider,
      credential: credential,
      platform: platform,
      installationId: installationId,
      locale: locale,
      appVersion: appVersion,
    );
  }

  /// Soft-deletes a device. Owned rows require the owning user.
  Future<void> unregisterDevice(
    final Session session, {
    required final String provider,
    required final String credential,
  }) {
    return PushDevices.unregister(
      session,
      provider: provider,
      credential: credential,
    );
  }

  /// Records that a delivery was received or opened.
  ///
  /// Anonymous devices may acknowledge without login. Owned devices require
  /// the owning user.
  Future<void> acknowledge(
    final Session session, {
    required final UuidValue deliveryId,
    required final PushAckType type,
  }) {
    return PushDevices.acknowledge(
      session,
      deliveryId: deliveryId,
      type: type,
    );
  }
}
