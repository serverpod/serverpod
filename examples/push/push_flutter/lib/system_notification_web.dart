import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Asks the browser for notification permission.
Future<void> ensureSystemNotifications() async {
  if (web.Notification.permission == 'granted') return;
  await web.Notification.requestPermission().toDart;
}

/// Shows a standard browser [Notification] toast (title + body + icon).
Future<void> showSystemNotification({
  required final String title,
  required final String body,
}) async {
  if (web.Notification.permission != 'granted') {
    final permission =
        (await web.Notification.requestPermission().toDart).toDart;
    if (permission != 'granted') {
      throw StateError('Browser notification permission is $permission.');
    }
  }

  final origin = web.window.location.origin;
  final notification = web.Notification(
    title,
    web.NotificationOptions(
      body: body,
      icon: '$origin/icons/Icon-192.png',
      badge: '$origin/icons/Icon-192.png',
      tag: 'serverpod-push',
      renotify: true,
      requireInteraction: false,
      silent: false,
    ),
  );
  notification.onclick = ((web.Event event) {
    notification.close();
    web.window.focus();
  }).toJS;
}
