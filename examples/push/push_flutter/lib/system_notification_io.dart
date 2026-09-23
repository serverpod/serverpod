import 'package:flutter/services.dart';

const _channel = MethodChannel('serverpod_push_example/notifications');

/// Creates the Android notification channel used for FCM and local posts.
///
/// Ignores MissingPluginException so a Dart-only hot restart still works
/// until the native activity is rebuilt.
Future<void> ensureSystemNotifications() async {
  try {
    await _channel.invokeMethod<void>('ensureChannel');
  } on MissingPluginException {
    // Native side not rebuilt yet; show() will create the channel later.
  }
}

/// Asks Android to show a high-importance notification.
Future<void> showSystemNotification({
  required final String title,
  required final String body,
}) {
  return _channel.invokeMethod<void>('show', {
    'title': title,
    'body': body,
  });
}
