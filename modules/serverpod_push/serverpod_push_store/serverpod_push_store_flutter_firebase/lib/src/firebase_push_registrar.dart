import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:serverpod_push_store_client/serverpod_push_store_client.dart';
import 'package:serverpod_push_store_flutter/serverpod_push_store_flutter.dart';

/// Binds Firebase Cloud Messaging to [PushDeviceRegistrar].
class FirebasePushRegistrar {
  /// Creates a registrar.
  FirebasePushRegistrar({
    required final Caller caller,
    required this.platform,
    this.installationId,
    this.locale,
    this.appVersion,
    this.vapidKey,
    final FirebaseMessaging? messaging,
  }) : _registrar = PushDeviceRegistrar(caller),
       _messaging = messaging ?? FirebaseMessaging.instance;

  final PushDeviceRegistrar _registrar;
  final FirebaseMessaging _messaging;

  /// Platform reported to the store.
  final PushPlatform platform;

  /// Stable installation id, used as the upsert key when set.
  final String? installationId;

  /// Optional locale forwarded to `registerDevice`.
  final String? locale;

  /// Optional app version forwarded to `registerDevice`.
  final String? appVersion;

  /// Web Push certificate key. Required for `getToken` on Flutter web.
  final String? vapidKey;

  StreamSubscription<String>? _tokenSub;
  StreamSubscription<RemoteMessage>? _messageSub;
  StreamSubscription<RemoteMessage>? _openedSub;

  /// Requests notification permission, registers the current token, and
  /// listens for refresh / receive / open events.
  Future<void> start() async {
    await _messaging.requestPermission();
    final token = await _messaging.getToken(vapidKey: vapidKey);
    if (token != null) {
      await _register(token);
    }

    _tokenSub = _messaging.onTokenRefresh.listen(_register);
    _messageSub = FirebaseMessaging.onMessage.listen(
      (final message) => unawaited(_ack(message, PushAckType.received)),
    );
    _openedSub = FirebaseMessaging.onMessageOpenedApp.listen(
      (final message) => unawaited(_ack(message, PushAckType.opened)),
    );
  }

  /// Cancels listeners. Does not unregister the device.
  Future<void> stop() async {
    await _tokenSub?.cancel();
    await _messageSub?.cancel();
    await _openedSub?.cancel();
    _tokenSub = null;
    _messageSub = null;
    _openedSub = null;
  }

  Future<void> _register(final String token) {
    return _registrar.register(
      provider: 'fcm',
      credential: token,
      platform: platform,
      installationId: installationId,
      locale: locale,
      appVersion: appVersion,
    );
  }

  Future<void> _ack(
    final RemoteMessage message,
    final PushAckType type,
  ) async {
    final raw = message.data[pushDeliveryIdDataKey];
    if (raw is! String || raw.isEmpty) return;
    try {
      await _registrar.acknowledge(
        deliveryId: UuidValue.withValidation(raw),
        type: type,
      );
    } catch (e, st) {
      debugPrint('serverpod_push: acknowledge failed: $e\n$st');
    }
  }
}
