---
name: serverpod-upgrading
description: Upgrade Serverpod — minor/patch updates, major upgrade to v3, pubspec updates across all packages. Use when upgrading Serverpod versions or updating dependencies.
---

# Serverpod Upgrading

## Minor/patch upgrades

Use the same pinned Serverpod version across all packages.

1. **Update CLI:** `dart pub global activate serverpod_cli`
2. **Update pubspecs** in every package:
   - Server: `serverpod`, `serverpod_test` (dev), module server packages
   - Client: `serverpod_client`, module client packages
   - Flutter: `serverpod_flutter`, module Flutter packages
3. **Fetch and regenerate:** `dart pub upgrade` + `serverpod generate` from server directory
4. **Migrations (if needed):** `serverpod create-migration` + `dart run bin/main.dart --apply-migrations`

## Major upgrade: to Serverpod 3.0

Requirements: Dart 3.8.0+, Flutter 3.32.0+.

### Steps

1. Update CLI: `dart pub global activate serverpod_cli`
2. Update all pubspecs to `3.0.0`+ and SDK constraint: `sdk: '>=3.8.0 <4.0.0'`
3. Update Dockerfile: `FROM dart:3.8 AS build`
4. `dart pub upgrade` + `serverpod generate`
5. Create and apply migration (session log user ID changed to String)

### Breaking changes

**Web server (Relic):**

- `handleCall`: `HttpRequest` → `Request`, `Future<bool>` → `FutureOr<Result>`, return `Response.ok(...)` instead of writing to response
- `request.remoteIpAddress` → `request.remoteInfo`; `request.headers.value('name')` → `request.headers['name']`
- Widget renames: `AbstractWidget`→`WebWidget`, `Widget`→`TemplateWidget`, `WidgetList`→`ListWidget`, `WidgetJson`→`JsonWidget`, `WidgetRedirect`→`RedirectWidget`
- `RouteStaticDirectory(...)` → `StaticRoute.directory(Directory(...))` with `cacheControlFactory`

**Session.request:** Optional `request` property on Session (null for non-HTTP sessions).

**Enum serialization:** Default now `byName`. Add `serialized: byIndex` in YAML to keep old behavior.

**Models:** `SerializableEntity` → `SerializableModel`. YAML: `parent=table` → `relation(parent=table)`; `database` → `scope=serverOnly`; `api` → `!persist`.

**Auth:** `session.authenticated` is now synchronous. `AuthenticationInfo.authId` non-nullable, `userIdentifier` is `String`. Client: `authenticationKeyManager` → `authKeyProvider`. Custom handlers receive unwrapped Bearer token.

**Deprecated:** Legacy streaming endpoints; use streaming methods.

### Checklist

1. CLI, pubspecs (versions + SDK), Dockerfile
2. Route classes, widgets, static routes
3. Enum serialization strategy
4. `SerializableEntity` → `SerializableModel`, YAML keywords
5. Auth usage updates
6. Migration + tests

## Mini to full Serverpod

From server directory: `serverpod create .` — adds full config and structure. Back up first. Then add DB, create-migration, apply.
