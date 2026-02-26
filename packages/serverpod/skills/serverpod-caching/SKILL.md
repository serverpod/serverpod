---
name: serverpod-caching
description: Serverpod caching — local and Redis caches, cache keys, lifetime, CacheMissHandler. Use when caching data, optimizing queries, or working with session.caches.
---

# Serverpod Caching

In-memory and optional Redis caches via `session.caches`. Cached objects must be serializable models or primitives supported by Serverpod.

## Cache types

- **`session.caches.local`** — in-memory, current server instance
- **`session.caches.localPriority`** — in-memory, for frequently accessed entries
- **`session.caches.global`** — Redis-backed, shared across instances (requires Redis config)

## Basic usage

```dart
await session.caches.local.put('UserData-$userId', userData,
  lifetime: Duration(minutes: 5));

var userData = await session.caches.local.get<UserData>('UserData-$userId');
```

## CacheMissHandler

Load on miss and store automatically:

```dart
var userData = await session.caches.local.get(
  'UserData-$userId',
  CacheMissHandler(
    () async => UserData.db.findById(session, userId),
    lifetime: Duration(minutes: 5),
  ),
);
```

Returns `null` if the handler returns `null` (nothing stored).

## Collections and primitives

```dart
await session.caches.local.put('userCount', 17, lifetime: Duration(minutes: 5));
var count = await session.caches.local.get<int>('userCount');
```

If relevant set a **lifetime** to avoid unbounded growth. Use stable, unique keys (e.g. `'EntityName-$id'`).
