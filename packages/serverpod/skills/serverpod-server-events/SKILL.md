---
name: serverpod-server-events
description: Serverpod message system — postMessage, addListener, createStream, global messages via Redis. Use when coordinating streams, sharing state across servers, or pub/sub messaging.
---

# Serverpod Server Events

Event messaging via `session.messages` on named channels. Messages must be serializable models. Local by default; global (cross-server) with Redis.

## Sending

```dart
session.messages.postMessage('user_updates', UserUpdate(...));

// Cross-server (requires Redis):
session.messages.postMessage('user_updates', message, global: true);
```

## Receiving

**Stream:**

```dart
var stream = session.messages.createStream<UserUpdate>('user_updates');
stream.listen((message) => print('Received: $message'));
```

**Listener:**

```dart
session.messages.addListener<UserUpdate>('user_updates', (message) {
  print('Received: $message');
});
```

Both receive local and global messages. Streams/listeners are removed when the session closes. Remove manually with `session.messages.removeListener(channel, callback)`. Models support inheritance, which is useful when wanting a fully typed interface for server events.
