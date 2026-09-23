import 'package:serverpod/serverpod.dart';

/// Result of [PushNotifications.sendToUsers] / [PushNotifications.sendToDevices].
class PushEnqueueResult {
  /// Id of the notification row. `null` when the audience resolved empty and
  /// no row was written.
  final UuidValue? notificationId;

  /// True when an existing notification with this `dedupeKey` was reused and
  /// no new deliveries were written for a new message body.
  final bool deduped;

  /// Number of delivery rows actually inserted (conflicts ignored).
  final int deliveriesCreated;

  /// Creates a result.
  const PushEnqueueResult({
    required this.notificationId,
    required this.deduped,
    required this.deliveriesCreated,
  });

  /// Empty-audience result: no notification row, no deliveries.
  factory PushEnqueueResult.empty() => const PushEnqueueResult(
    notificationId: null,
    deduped: false,
    deliveriesCreated: 0,
  );
}
