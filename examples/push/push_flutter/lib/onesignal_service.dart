import 'package:serverpod_push_store_flutter_onesignal/serverpod_push_store_flutter_onesignal.dart';

/// OneSignal App ID for the push example.
///
/// Pass `--dart-define=ONESIGNAL_APP_ID=...` when running the Flutter app.
const oneSignalAppId = String.fromEnvironment('ONESIGNAL_APP_ID');

/// Centralized wrapper for all OneSignal SDK calls.
class OneSignalService {
  OneSignalService._internal();

  static final OneSignalService instance = OneSignalService._internal();

  factory OneSignalService() => instance;

  bool _isInitialized = false;
  void Function(String? id)? _subscriptionObserver;

  /// Whether [initialize] has already run.
  bool get isInitialized => _isInitialized;

  /// Initializes the OneSignal SDK. Safe to call more than once.
  Future<void> initialize(final String appId) async {
    if (_isInitialized) return;
    await OneSignalRuntime.initialize(appId);
    _isInitialized = true;
  }

  /// Returns the current push subscription id, if any.
  String? get pushSubscriptionId => OneSignalRuntime.subscriptionId;

  /// True when [id] is a server-assigned subscription (not a `local-` placeholder).
  bool isRegistered(final String? id) => OneSignalRuntime.isServerAssigned(id);

  /// Registers [observer] and keeps the reference so OneSignal does not drop it.
  void addPushSubscriptionObserver(final void Function(String? id) observer) {
    removePushSubscriptionObserver();
    _subscriptionObserver = observer;
    OneSignalRuntime.addSubscriptionListener(observer);
  }

  /// Removes the observer registered by [addPushSubscriptionObserver].
  void removePushSubscriptionObserver() {
    final observer = _subscriptionObserver;
    if (observer != null) {
      OneSignalRuntime.removeSubscriptionListener(observer);
    }
    _subscriptionObserver = null;
  }

  /// Identifies the current user with [externalId].
  Future<void> login(final String externalId) {
    return OneSignalRuntime.login(externalId);
  }

  /// Clears the current OneSignal user.
  Future<void> logout() {
    return OneSignalRuntime.logout();
  }

  /// Adds an email subscription for the current user.
  Future<void> setEmail(final String email) {
    return OneSignalRuntime.addEmail(email);
  }

  /// Adds an SMS subscription for the current user.
  Future<void> setSmsNumber(final String number) {
    return OneSignalRuntime.addSms(number);
  }

  /// Sets a single user tag.
  Future<void> setTag(final String key, final String value) {
    return OneSignalRuntime.addTag(key, value);
  }

  /// Prompts for notification permission.
  Future<bool> requestPermission() {
    return OneSignalRuntime.requestPermission();
  }
}
