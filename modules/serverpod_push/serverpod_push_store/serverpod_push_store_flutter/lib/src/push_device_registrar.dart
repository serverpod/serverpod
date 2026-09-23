import 'package:serverpod_push_store_client/serverpod_push_store_client.dart';

/// Data-overlay key the dispatcher writes with the delivery id.
const pushDeliveryIdDataKey = '_spDeliveryId';

/// Registers, unregisters, and acknowledges devices with the push store.
class PushDeviceRegistrar {
  /// Creates a registrar that talks to [caller].
  PushDeviceRegistrar(this._caller);

  final Caller _caller;

  /// Registers or updates a device token.
  Future<void> register({
    required final String provider,
    required final String credential,
    required final PushPlatform platform,
    final String? installationId,
    final String? locale,
    final String? appVersion,
  }) {
    return _caller.pushDevice.registerDevice(
      provider: provider,
      credential: credential,
      platform: platform,
      installationId: installationId,
      locale: locale,
      appVersion: appVersion,
    );
  }

  /// Soft-deletes a device.
  Future<void> unregister({
    required final String provider,
    required final String credential,
  }) {
    return _caller.pushDevice.unregisterDevice(
      provider: provider,
      credential: credential,
    );
  }

  /// Records that a delivery was received or opened.
  Future<void> acknowledge({
    required final UuidValue deliveryId,
    required final PushAckType type,
  }) {
    return _caller.pushDevice.acknowledge(
      deliveryId: deliveryId,
      type: type,
    );
  }
}
