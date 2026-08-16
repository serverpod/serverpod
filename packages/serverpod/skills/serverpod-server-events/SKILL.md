---
name: serverpod-server-events
description: Serverpod message system — postMessage, addListener, createStream, global messages via Redis. Use when coordinating streams, sharing state across servers, or pub/sub messaging.
---

# Serverpod Server Events

Event messaging via `session.messages` on named channels. Messages must be serializable models. By default (`MessageScope.auto`) messages are delivered across the cluster when Redis is enabled, otherwise locally within the server instance.

## Sending

```dart
await session.messages.postMessage('user_updates', UserUpdate(...));

// Restrict delivery with a scope:
await session.messages.postMessage('user_updates', message, scope: MessageScope.local);
await session.messages.postMessage('user_updates', message, scope: MessageScope.global);
```

`MessageScope.local` delivers synchronously within this server only. `MessageScope.global` requires Redis and throws a `StateError` if it is not enabled. With Redis enabled, delivery is asynchronous and best effort, and listeners receive a deserialized copy of the message rather than the posted instance.

## Receiving

**Stream:**

```dart
var stream = session.messages.createStream<UserUpdate>('user_updates');
stream.listen((message) => print('Received: $message'));
```

If a message on the channel is not of type `T`, the stream emits an error. Use exact serializable types or a deliberate shared base type.

**Listener:**

```dart
session.messages.addListener<UserUpdate>('user_updates', (message) {
  print('Received: $message');
});
```

Both receive local and global messages. Streams/listeners are removed when the session closes. Remove manually with `session.messages.removeListener(channel, callback)`. Models support inheritance, which is useful when wanting a fully typed interface for server events.
