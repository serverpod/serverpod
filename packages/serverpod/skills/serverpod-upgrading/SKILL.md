---
name: serverpod-upgrading
description: Upgrade Serverpod — minor/patch updates, major upgrade to v3, pubspec updates across all packages. Use when upgrading Serverpod versions or updating dependencies.
---

# Serverpod Upgrading

Requirements: Dart 3.10.3+, Flutter 3.38.4+.

Use the same pinned Serverpod version across all packages.

1. Update the CLI to the latest version: `dart install serverpod_cli`
2. Run `serverpod version` to get the updated Serverpod version.
4. Update all Serverpod packages in all pubspecs to the Serverpod version.
5. Run `dart pub upgrade` + `serverpod generate` from the server directory.
6. Follow the [migration workflow](../serverpod-migrations/SKILL.md).

Ensure that the Dockerfile uses at least `FROM dart:3.10.3 AS build`.

## Major upgrade: to Serverpod 3.0

After following the regular upgrade process, ensure that the following breaking changes are addressed.

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
