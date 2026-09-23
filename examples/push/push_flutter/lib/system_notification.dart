import 'system_notification_io.dart'
    if (dart.library.html) 'system_notification_web.dart'
    as impl;

/// Shows an operating-system notification while the example app is in front.
///
/// FCM delivers a foreground message to the app and does not draw a tray or
/// browser notification itself. This posts that notification locally.
class SystemNotification {
  /// Prepares the platform notification path and asks for permission on web.
  static Future<void> ensureInitialized() => impl.ensureSystemNotifications();

  /// Posts [title] and [body] to the system notification UI.
  static Future<void> show({
    required final String title,
    required final String body,
  }) {
    return impl.showSystemNotification(title: title, body: body);
  }
}
