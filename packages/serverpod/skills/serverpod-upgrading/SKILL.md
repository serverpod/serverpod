---
name: serverpod-upgrading
description: Upgrade Serverpod — minor/patch updates, major upgrade to v3. Use when upgrading Serverpod versions or updating dependencies.
---

# Serverpod minor/patch upgrade

Requirements: Dart 3.10.3+, Flutter 3.38.4+.

Use the same pinned Serverpod version across all packages. Use the CLI to do the upgrade. Ask the user to start the server with `serverpod start` after the upgrade. NEVER update the CLI tooling, instead STOP and ask the user to do it.

1. Check the latest version of Serverpod: https://pub.dev/packages/serverpod (unless the user has requested a specific version).
2. Run `serverpod version` to verify that the tooling has the correct version. If not, STOP and ask the user to install the correct version (`dart install serverpod_cli` for latest or `dart install serverpod_cli 3.x.x` for specific version).
3. Update all Serverpod packages in all relevant package pubspec.yaml (server, client, flutter, shared).
4. Run `dart pub upgrade` in all packages.
5. Run `serverpod generate`.
6. Run `serverpod create-migration`.
7. Run `dart analyze` in the root of the project and address any issues.
8. Ensure that the Dockerfile uses at least `FROM dart:3.10.3 AS build`.
9. Inform the user that the upgrade is complete and they should start the server with `serverpod start`.

## Major upgrade: Serverpod 2.x to 3.0

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

