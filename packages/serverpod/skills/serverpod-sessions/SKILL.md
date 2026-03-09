---
name: serverpod-sessions
description: Serverpod session types, lifecycle, InternalSession, cleanup callbacks. Use when creating manual sessions, debugging session-closed errors, or understanding session lifecycle.
---

# Serverpod Sessions

A Session provides access to database, cache, storage, messages, passwords, and logging. The framework creates and closes sessions automatically; only InternalSession requires manual management.

## Session types

| Type | Created for | Lifetime |
| ---- | ----------- | -------- |
| MethodCallSession | Endpoint methods | Single request |
| WebCallSession | Web server routes | Single request |
| MethodStreamSession | Stream methods | Stream duration |
| StreamingSession | WebSocket connections | Connection duration |
| FutureCallSession | Future calls | Task execution |
| InternalSession | Manual creation | Until closed |

## Manual sessions (InternalSession)

**Always close** in a `finally` block:

```dart
var session = await Serverpod.instance.createSession();
try {
  await doWork(session);
} finally {
  await session.close();
}
```

Unclosed sessions leak memory and never persist logs. Using a closed session throws `StateError`.

## Cleanup callbacks

```dart
session.addWillCloseListener((session) async {
  // Runs just before session closes (all session types)
});
```

## Common pitfall: using session after method returns

Sessions close when the endpoint returns. Do not capture for later use:

```dart
// BAD — session already closed when callback runs
Timer(Duration(seconds: 5), () => user.updateLastSeen(session));
```

**Fix:** Use a future call (`session.serverpod.futureCalls.callWithDelay(...)`) or create a new InternalSession inside the callback.
