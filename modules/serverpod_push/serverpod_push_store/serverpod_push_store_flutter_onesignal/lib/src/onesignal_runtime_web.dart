import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// OneSignal Web SDK facade used by [OneSignalPushRegistrar] on Flutter web.
class OneSignalRuntime {
  OneSignalRuntime._();

  static bool _initialized = false;
  static _OneSignalClient? _client;

  static final _subscriptionListeners = <void Function(String? id)>[];
  static final _receivedListeners = <void Function(Map<String, dynamic>?)>[];
  static final _openedListeners = <void Function(Map<String, dynamic>?)>[];

  static JSFunction? _subscriptionJs;
  static JSFunction? _receivedJs;
  static JSFunction? _openedJs;

  /// True when [id] is a server-assigned subscription (not a `local-` placeholder).
  static bool isServerAssigned(final String? id) =>
      id != null && id.isNotEmpty && !id.startsWith('local-');

  /// Initializes the OneSignal Web SDK. Safe to call more than once.
  static Future<void> initialize(final String appId) async {
    if (_initialized) return;
    final client = await _whenReady();
    try {
      await client
          .init(
            {
              'appId': appId,
              'serviceWorkerPath': 'onesignal/OneSignalSDKWorker.js',
              'serviceWorkerParam': {'scope': '/onesignal/'},
              'notifyButton': {'enable': false},
              'welcomeNotification': {'disable': true},
            }.jsify()!,
          )
          .toDart;
    } catch (e) {
      throw StateError(
        'OneSignal web init failed: $e. '
        'In the OneSignal dashboard, open this app → Platforms → add Web '
        '(Typical Site) for http://localhost, then hot-restart the app.',
      );
    }
    _client = client;
    _initialized = true;
    _ensureJsListeners();
  }

  /// Current push subscription id, if any.
  static String? get subscriptionId {
    final id = _client?.user.pushSubscription.id;
    if (id == null || id.isEmpty) return null;
    return id;
  }

  /// Prompts for notification permission.
  static Future<bool> requestPermission() async {
    final client = _client;
    if (client == null) return false;
    final result = await client.notifications.requestPermission().toDart;
    if (result != null && result.isA<JSBoolean>()) {
      return (result as JSBoolean).toDart;
    }
    return client.notifications.permission;
  }

  /// Identifies the current user with [externalId].
  static Future<void> login(final String externalId) async {
    final client = _client;
    if (client == null) return;
    await client.login(externalId).toDart;
  }

  /// Clears the current OneSignal user.
  static Future<void> logout() async {
    final client = _client;
    if (client == null) return;
    await client.logout().toDart;
  }

  /// Adds an email subscription for the current user.
  static Future<void> addEmail(final String email) async {
    final client = _client;
    if (client == null) return;
    await client.user.addEmail(email).toDart;
  }

  /// Adds an SMS subscription for the current user.
  static Future<void> addSms(final String number) async {
    final client = _client;
    if (client == null) return;
    await client.user.addSms(number).toDart;
  }

  /// Sets a single user tag.
  static Future<void> addTag(final String key, final String value) async {
    final client = _client;
    if (client == null) return;
    await client.user.addTag(key, value).toDart;
  }

  /// Registers [listener] for subscription id changes.
  static void addSubscriptionListener(
    final void Function(String? id) listener,
  ) {
    _subscriptionListeners.add(listener);
    _ensureJsListeners();
  }

  /// Removes a listener registered by [addSubscriptionListener].
  static void removeSubscriptionListener(
    final void Function(String? id) listener,
  ) {
    _subscriptionListeners.remove(listener);
    final js = _subscriptionJs;
    final subscription = _client?.user.pushSubscription;
    if (_subscriptionListeners.isEmpty && js != null && subscription != null) {
      subscription.removeEventListener('change', js);
      _subscriptionJs = null;
    }
  }

  /// Registers [listener] for foreground notification payloads.
  static void addReceivedListener(
    final void Function(Map<String, dynamic>? data) listener,
  ) {
    _receivedListeners.add(listener);
    _ensureJsListeners();
  }

  /// Removes a listener registered by [addReceivedListener].
  static void removeReceivedListener(
    final void Function(Map<String, dynamic>? data) listener,
  ) {
    _receivedListeners.remove(listener);
    final js = _receivedJs;
    final notifications = _client?.notifications;
    if (_receivedListeners.isEmpty && js != null && notifications != null) {
      notifications.removeEventListener('foregroundWillDisplay', js);
      _receivedJs = null;
    }
  }

  /// Registers [listener] for notification open payloads.
  static void addOpenedListener(
    final void Function(Map<String, dynamic>? data) listener,
  ) {
    _openedListeners.add(listener);
    _ensureJsListeners();
  }

  /// Removes a listener registered by [addOpenedListener].
  static void removeOpenedListener(
    final void Function(Map<String, dynamic>? data) listener,
  ) {
    _openedListeners.remove(listener);
    final js = _openedJs;
    final notifications = _client?.notifications;
    if (_openedListeners.isEmpty && js != null && notifications != null) {
      notifications.removeEventListener('click', js);
      _openedJs = null;
    }
  }

  static void _ensureJsListeners() {
    final client = _client;
    if (client == null) return;

    if (_subscriptionJs == null && _subscriptionListeners.isNotEmpty) {
      _subscriptionJs = ((JSObject event) {
        final current = event.getProperty('current'.toJS);
        final id = _readId(current);
        for (final item in List<void Function(String? id)>.of(
          _subscriptionListeners,
        )) {
          item(id);
        }
      }).toJS;
      client.user.pushSubscription.addEventListener('change', _subscriptionJs!);
    }

    if (_receivedJs == null && _receivedListeners.isNotEmpty) {
      _receivedJs = ((JSObject event) {
        final data = _additionalData(event);
        for (final item in List<void Function(Map<String, dynamic>?)>.of(
          _receivedListeners,
        )) {
          item(data);
        }
      }).toJS;
      client.notifications.addEventListener(
        'foregroundWillDisplay',
        _receivedJs!,
      );
    }

    if (_openedJs == null && _openedListeners.isNotEmpty) {
      _openedJs = ((JSObject event) {
        final data = _additionalData(event);
        for (final item in List<void Function(Map<String, dynamic>?)>.of(
          _openedListeners,
        )) {
          item(data);
        }
      }).toJS;
      client.notifications.addEventListener('click', _openedJs!);
    }
  }

  static Future<_OneSignalClient> _whenReady() {
    final completer = Completer<_OneSignalClient>();
    if (!globalContext.has('OneSignalDeferred')) {
      globalContext.setProperty('OneSignalDeferred'.toJS, JSArray());
    }
    final deferred = globalContext.getProperty('OneSignalDeferred'.toJS);
    if (deferred == null || deferred.isUndefined || !deferred.isA<JSObject>()) {
      completer.completeError(
        StateError(
          'OneSignal Web SDK is not loaded. Include OneSignalSDK.page.js '
          'and window.OneSignalDeferred in web/index.html.',
        ),
      );
      return completer.future;
    }
    (deferred as JSObject).callMethod(
      'push'.toJS,
      ((JSAny client) {
        if (!completer.isCompleted) {
          completer.complete(_OneSignalClient.from(client));
        }
      }).toJS,
    );
    return completer.future;
  }

  static String? _readId(final JSAny? value) {
    if (value == null || value.isUndefined) return null;
    final decoded = value.dartify();
    if (decoded == null) return null;
    if (decoded is String) return decoded.isEmpty ? null : decoded;
    if (decoded is Map && decoded['id'] is String) {
      final id = decoded['id']! as String;
      return id.isEmpty ? null : id;
    }
    return null;
  }

  static Map<String, dynamic>? _additionalData(final JSObject event) {
    final notification = event.getProperty('notification'.toJS);
    if (notification == null ||
        notification.isUndefined ||
        !notification.isA<JSObject>()) {
      return null;
    }
    final data = (notification as JSObject).getProperty('additionalData'.toJS);
    if (data == null || data.isUndefined) return null;
    final decoded = data.dartify();
    if (decoded is Map) {
      return {
        for (final entry in decoded.entries) entry.key.toString(): entry.value,
      };
    }
    return null;
  }
}

extension type _OneSignalClient._(JSObject _) implements JSObject {
  factory _OneSignalClient.from(final JSAny value) =>
      _OneSignalClient._(value as JSObject);

  external JSPromise<JSAny?> init(final JSAny options);
  external JSPromise<JSAny?> login(final String externalId);
  external JSPromise<JSAny?> logout();

  @JS('User')
  external _OneSignalUser get user;

  @JS('Notifications')
  external _OneSignalNotifications get notifications;
}

extension type _OneSignalUser._(JSObject _) implements JSObject {
  @JS('PushSubscription')
  external _OneSignalPushSub get pushSubscription;

  external JSPromise<JSAny?> addEmail(final String email);
  external JSPromise<JSAny?> addSms(final String number);
  external JSPromise<JSAny?> addTag(final String key, final String value);
}

extension type _OneSignalPushSub._(JSObject _) implements JSObject {
  external String? get id;

  external void addEventListener(final String event, final JSFunction listener);
  external void removeEventListener(
    final String event,
    final JSFunction listener,
  );
}

extension type _OneSignalNotifications._(JSObject _) implements JSObject {
  external JSPromise<JSAny?> requestPermission();
  external bool get permission;

  external void addEventListener(final String event, final JSFunction listener);
  external void removeEventListener(
    final String event,
    final JSFunction listener,
  );
}
