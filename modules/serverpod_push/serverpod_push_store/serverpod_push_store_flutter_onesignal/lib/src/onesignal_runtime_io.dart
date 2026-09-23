import 'package:onesignal_flutter/onesignal_flutter.dart';

/// OneSignal SDK facade used by [OneSignalPushRegistrar] on iOS and Android.
class OneSignalRuntime {
  OneSignalRuntime._();

  static bool _initialized = false;
  static OnPushSubscriptionChangeObserver? _subscriptionAdapter;
  static OnNotificationWillDisplayListener? _receivedAdapter;
  static OnNotificationClickListener? _openedAdapter;

  static final _subscriptionListeners = <void Function(String? id)>[];
  static final _receivedListeners = <void Function(Map<String, dynamic>?)>[];
  static final _openedListeners = <void Function(Map<String, dynamic>?)>[];

  /// True when [id] is a server-assigned subscription (not a `local-` placeholder).
  static bool isServerAssigned(final String? id) =>
      id != null && id.isNotEmpty && !id.startsWith('local-');

  /// Initializes the native OneSignal SDK. Safe to call more than once.
  static Future<void> initialize(final String appId) async {
    if (_initialized) return;
    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    await OneSignal.initialize(appId);
    _initialized = true;
  }

  /// Current push subscription id, if any.
  static String? get subscriptionId => OneSignal.User.pushSubscription.id;

  /// Prompts for notification permission.
  static Future<bool> requestPermission() {
    return OneSignal.Notifications.requestPermission(true);
  }

  /// Identifies the current user with [externalId].
  static Future<void> login(final String externalId) {
    return OneSignal.login(externalId);
  }

  /// Clears the current OneSignal user.
  static Future<void> logout() => OneSignal.logout();

  /// Adds an email subscription for the current user.
  static Future<void> addEmail(final String email) {
    return OneSignal.User.addEmail(email);
  }

  /// Adds an SMS subscription for the current user.
  static Future<void> addSms(final String number) {
    return OneSignal.User.addSms(number);
  }

  /// Sets a single user tag.
  static Future<void> addTag(final String key, final String value) {
    return OneSignal.User.addTagWithKey(key, value);
  }

  /// Registers [listener] for subscription id changes.
  static void addSubscriptionListener(
    final void Function(String? id) listener,
  ) {
    _subscriptionListeners.add(listener);
    _subscriptionAdapter ??= (final state) {
      for (final item in List<void Function(String? id)>.of(
        _subscriptionListeners,
      )) {
        item(state.current.id);
      }
    };
    if (_subscriptionListeners.length == 1) {
      OneSignal.User.pushSubscription.addObserver(_subscriptionAdapter!);
    }
  }

  /// Removes a listener registered by [addSubscriptionListener].
  static void removeSubscriptionListener(
    final void Function(String? id) listener,
  ) {
    _subscriptionListeners.remove(listener);
    final adapter = _subscriptionAdapter;
    if (_subscriptionListeners.isEmpty && adapter != null) {
      OneSignal.User.pushSubscription.removeObserver(adapter);
      _subscriptionAdapter = null;
    }
  }

  /// Registers [listener] for foreground notification payloads.
  static void addReceivedListener(
    final void Function(Map<String, dynamic>? data) listener,
  ) {
    _receivedListeners.add(listener);
    _receivedAdapter ??= (final event) {
      for (final item in List<void Function(Map<String, dynamic>?)>.of(
        _receivedListeners,
      )) {
        item(event.notification.additionalData);
      }
    };
    if (_receivedListeners.length == 1) {
      OneSignal.Notifications.addForegroundWillDisplayListener(
        _receivedAdapter!,
      );
    }
  }

  /// Removes a listener registered by [addReceivedListener].
  static void removeReceivedListener(
    final void Function(Map<String, dynamic>? data) listener,
  ) {
    _receivedListeners.remove(listener);
    final adapter = _receivedAdapter;
    if (_receivedListeners.isEmpty && adapter != null) {
      OneSignal.Notifications.removeForegroundWillDisplayListener(adapter);
      _receivedAdapter = null;
    }
  }

  /// Registers [listener] for notification open payloads.
  static void addOpenedListener(
    final void Function(Map<String, dynamic>? data) listener,
  ) {
    _openedListeners.add(listener);
    _openedAdapter ??= (final event) {
      for (final item in List<void Function(Map<String, dynamic>?)>.of(
        _openedListeners,
      )) {
        item(event.notification.additionalData);
      }
    };
    if (_openedListeners.length == 1) {
      OneSignal.Notifications.addClickListener(_openedAdapter!);
    }
  }

  /// Removes a listener registered by [addOpenedListener].
  static void removeOpenedListener(
    final void Function(Map<String, dynamic>? data) listener,
  ) {
    _openedListeners.remove(listener);
    final adapter = _openedAdapter;
    if (_openedListeners.isEmpty && adapter != null) {
      OneSignal.Notifications.removeClickListener(adapter);
      _openedAdapter = null;
    }
  }
}
