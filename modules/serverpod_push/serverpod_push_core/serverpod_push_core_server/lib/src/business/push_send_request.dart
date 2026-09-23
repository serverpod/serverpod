import '../generated/protocol.dart';

/// One target inside a [PushProvider.send] call.
///
/// The per-target [dataOverlay] is what makes `acknowledge` implementable:
/// the delivery id is per-delivery, while the message is shared across N rows.
/// The provider merges the overlay over `message.data`; colliding keys prefer
/// the overlay.
class PushSendRequest {
  /// Device address for this send.
  final PushDeviceTarget target;

  /// Merged over `message.data` by the provider. Keys collide toward the overlay.
  final Map<String, String> dataOverlay;

  /// Absolute expiry for this specific delivery. Providers derive FCM `ttl`
  /// and APNs `apns-expiration` from this and nothing else. If it is already
  /// past, the provider returns [PushDeliveryOutcome.expired] without making a
  /// network call.
  final DateTime expiresAt;

  /// Creates a send request for one device.
  const PushSendRequest({
    required this.target,
    required this.dataOverlay,
    required this.expiresAt,
  });
}
