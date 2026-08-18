---
name: serverpod-sessions
description: Serverpod session types, lifecycle, InternalSession, cleanup callbacks. Use when creating sessions manually outside a request, when work outlives the request that started it, or when a closed session throws a StateError.
---

# Serverpod Sessions

A Session provides access to database, cache, storage, messages, passwords, and logging. The framework creates and closes sessions automatically; only InternalSession requires manual management. Do not store a request session for work that outlives the request/stream/future call.

## Session types

| Type | Created for | Lifetime |
| ---- | ----------- | -------- |
| MethodCallSession | Endpoint methods | Single request |
| WebCallSession | Web server routes | Single request |
| MethodStreamSession | Stream methods | Stream duration |
| FutureCallSession | Future calls | Task execution |
| InternalSession | Manual creation | Until closed |

## Manual sessions (InternalSession)

Prefer `withSession`, which closes the session for you and attaches the error and stack trace to the logs if the callback throws:

```dart
await Serverpod.instance.withSession((session) async {
  await doWork(session);
});
```

When the lifetime cannot be expressed as a callback, create the session manually and **always close** it in a `finally` block:

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

**Fix:** Use a future call (`session.serverpod.futureCalls.callWithDelay(...)`) or open a new session inside the callback with `Serverpod.instance.withSession(...)`.
