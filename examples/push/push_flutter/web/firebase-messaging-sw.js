// Firebase Messaging service worker for Flutter web.
// Uses compat builds so this plain JS file works without bundling.
//
// Replace the placeholders with your Firebase web app config. They must
// match the --dart-define values passed to `flutter run -d chrome`.

importScripts('https://www.gstatic.com/firebasejs/11.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/11.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'YOUR_FIREBASE_API_KEY',
  authDomain: 'YOUR_PROJECT.firebaseapp.com',
  databaseURL: 'https://YOUR_PROJECT-default-rtdb.firebaseio.com',
  projectId: 'YOUR_PROJECT',
  storageBucket: 'YOUR_PROJECT.firebasestorage.app',
  messagingSenderId: 'YOUR_SENDER_ID',
  appId: 'YOUR_APP_ID',
  measurementId: 'YOUR_MEASUREMENT_ID',
});

const messaging = firebase.messaging();

function showPureNotification(title, body) {
  const origin = self.location.origin;
  return self.registration.showNotification(title, {
    body,
    icon: `${origin}/icons/Icon-192.png`,
    badge: `${origin}/icons/Icon-192.png`,
    tag: 'serverpod-push',
    renotify: true,
    requireInteraction: false,
    silent: false,
  });
}

// Notification payloads are shown by the browser. Data-only payloads are not,
// so surface those here when the tab is in the background.
messaging.onBackgroundMessage((payload) => {
  const notification = payload.notification || {};
  const data = payload.data || {};
  const title = notification.title || data.title || 'Serverpod Push';
  const body =
    notification.body || data.body || data.case || 'Broadcast from the push example';
  return showPureNotification(title, body);
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      for (const client of clientList) {
        if ('focus' in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow('/');
      }
    }),
  );
});
