import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:serverpod_push_store_client/serverpod_push_store_client.dart';
import 'package:serverpod_push_store_flutter/serverpod_push_store_flutter.dart';

/// Binds OneSignal to [PushDeviceRegistrar].
class OneSignalPushRegistrar {
  /// Creates a registrar.
  ///
  /// When [initializeSdk] is true (default), [start] calls
  /// `OneSignal.initialize(appId)`. Set it to false if the host app already
  /// initialized OneSignal.
  OneSignalPushRegistrar({
    required final Caller caller,
    required this.appId,
    required this.platform,
    this.installationId,
    this.locale,
    this.appVersion,
    this.initializeSdk = true,
  }) : _registrar = PushDeviceRegistrar(caller);

  final PushDeviceRegistrar _registrar;

  /// OneSignal App ID.
  final String appId;

  /// Platform reported to the store.
  final PushPlatform platform;

  /// Stable installation id, used as the upsert key when set.
  final String? installationId;

  /// Optional locale forwarded to `registerDevice`.
  final String? locale;

  /// Optional app version forwarded to `registerDevice`.
  final String? appVersion;

  /// Whether [start] should call `OneSignal.initialize`.
  final bool initializeSdk;

  OnPushSubscriptionChangeObserver? _subscriptionObserver;
  OnNotificationWillDisplayListener? _displayListener;
  OnNotificationClickListener? _clickListener;

  /// Initializes OneSignal (unless already done), registers the current
  /// subscription id, and listens for refresh / receive / open events.
  ///
  /// Does not request notification permission — the host app should do that
  /// after the OneSignal verification dialog (or equivalent).
  Future<void> start() async {
    if (initializeSdk) {
      await OneSignal.initialize(appId);
    }

    final currentId = OneSignal.User.pushSubscription.id;
    if (currentId != null && currentId.isNotEmpty) {
      await _register(currentId);
    }

    _subscriptionObserver = (final state) {
      final id = state.current.id;
      if (id != null && id.isNotEmpty) {
        unawaited(_register(id));
      }
    };
    OneSignal.User.pushSubscription.addObserver(_subscriptionObserver!);

    _displayListener = (final event) {
      unawaited(_ack(event.notification.additionalData, PushAckType.received));
    };
    OneSignal.Notifications.addForegroundWillDisplayListener(_displayListener!);

    _clickListener = (final event) {
      unawaited(_ack(event.notification.additionalData, PushAckType.opened));
    };
    OneSignal.Notifications.addClickListener(_clickListener!);
  }

  /// Cancels listeners. Does not unregister the device or shut down OneSignal.
  Future<void> stop() async {
    final subscriptionObserver = _subscriptionObserver;
    if (subscriptionObserver != null) {
      OneSignal.User.pushSubscription.removeObserver(subscriptionObserver);
    }
    final displayListener = _displayListener;
    if (displayListener != null) {
      OneSignal.Notifications.removeForegroundWillDisplayListener(
        displayListener,
      );
    }
    final clickListener = _clickListener;
    if (clickListener != null) {
      OneSignal.Notifications.removeClickListener(clickListener);
    }
    _subscriptionObserver = null;
    _displayListener = null;
    _clickListener = null;
  }

  Future<void> _register(final String subscriptionId) {
    return _registrar.register(
      provider: OneSignalPushRegistrar.providerId,
      credential: subscriptionId,
      platform: platform,
      installationId: installationId,
      locale: locale,
      appVersion: appVersion,
    );
  }

  Future<void> _ack(
    final Map<String, dynamic>? data,
    final PushAckType type,
  ) async {
    final raw = data?[pushDeliveryIdDataKey];
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

  /// Provider id registered with the store (`onesignal`).
  static const providerId = 'onesignal';
}
