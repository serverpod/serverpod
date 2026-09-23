import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:serverpod_push_store_client/serverpod_push_store_client.dart';
import 'package:serverpod_push_store_flutter/serverpod_push_store_flutter.dart';

import 'onesignal_runtime.dart';

/// Binds OneSignal to [PushDeviceRegistrar] on every Flutter platform.
class OneSignalPushRegistrar {
  /// Creates a registrar.
  ///
  /// When [initializeSdk] is true (default), [start] calls
  /// [OneSignalRuntime.initialize]. Set it to false if the host app already
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

  /// Whether [start] should initialize the OneSignal SDK.
  final bool initializeSdk;

  void Function(String? id)? _subscriptionListener;
  void Function(Map<String, dynamic>? data)? _receivedListener;
  void Function(Map<String, dynamic>? data)? _openedListener;

  /// Initializes OneSignal (unless already done), registers the current
  /// subscription id, and listens for refresh / receive / open events.
  ///
  /// Does not request notification permission — the host app should do that
  /// after the OneSignal verification dialog (or equivalent).
  Future<void> start() async {
    if (initializeSdk) {
      await OneSignalRuntime.initialize(appId);
    }

    final currentId = OneSignalRuntime.subscriptionId;
    if (OneSignalRuntime.isServerAssigned(currentId)) {
      await _register(currentId!);
    }

    _subscriptionListener = (final id) {
      if (OneSignalRuntime.isServerAssigned(id)) {
        unawaited(_register(id!));
      }
    };
    OneSignalRuntime.addSubscriptionListener(_subscriptionListener!);

    _receivedListener = (final data) {
      unawaited(_ack(data, PushAckType.received));
    };
    OneSignalRuntime.addReceivedListener(_receivedListener!);

    _openedListener = (final data) {
      unawaited(_ack(data, PushAckType.opened));
    };
    OneSignalRuntime.addOpenedListener(_openedListener!);
  }

  /// Cancels listeners. Does not unregister the device or shut down OneSignal.
  Future<void> stop() async {
    final subscriptionListener = _subscriptionListener;
    if (subscriptionListener != null) {
      OneSignalRuntime.removeSubscriptionListener(subscriptionListener);
    }
    final receivedListener = _receivedListener;
    if (receivedListener != null) {
      OneSignalRuntime.removeReceivedListener(receivedListener);
    }
    final openedListener = _openedListener;
    if (openedListener != null) {
      OneSignalRuntime.removeOpenedListener(openedListener);
    }
    _subscriptionListener = null;
    _receivedListener = null;
    _openedListener = null;
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
