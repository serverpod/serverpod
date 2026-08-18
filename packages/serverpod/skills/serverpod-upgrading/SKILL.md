---
name: serverpod-upgrading
description: Upgrade Serverpod — minor/patch updates, major upgrades (2.x to 3.0, 3.x to 4.0). Use when upgrading Serverpod versions or updating dependencies.
---

# Serverpod minor/patch upgrade

Requirements for this Serverpod version: Dart 3.10.3+, Flutter 3.38.4+. Check the release notes for the version being installed.

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

## Major upgrade: Serverpod 3.x to 4.0

After following the regular upgrade process, address the following breaking changes.

**Streaming:** The legacy streaming session and the deprecated streaming APIs are removed. Endpoints must use streaming methods (`Stream<T>` parameters and return types). See [Serverpod Streams](../serverpod-streams/SKILL.md).

**Future calls:** `pod.registerFutureCall(...)`, `FutureCall.invoke`, `pod.futureCallWithDelay(...)` and `pod.futureCallAtTime(...)` are removed. Define methods on the `FutureCall` class and schedule them through the generated `pod.futureCalls` API. See [Serverpod Scheduling](../serverpod-scheduling/SKILL.md).

**Server events:** `postMessage` now defaults to global delivery (falling back to local when Redis is disabled). Pass `scope: MessageScope.local` where messages must not leave the server instance.

**ORM:** The deprecated `orderDescending` parameter is removed. Use `orderBy: (t) => t.column.desc()` or `orderByList`.

**Endpoints:** The `ignoreEndpoint` annotation is removed. Use `@doNotGenerate`.

**Web server:** The deprecated widget classes and legacy static directory classes are removed. Use `WebWidget`, `TemplateWidget`, `ListWidget`, `JsonWidget`, `RedirectWidget` and `StaticRoute.directory(...)`. `WidgetRoute.build` now returns `Future<WebWidget?>`, where `null` responds with 404.

**Auth:** The `authenticationKeyManager` client parameter is removed; use `authSessionManager` (Flutter) or `authKeyProvider`. The native Google Sign-In web implementation is replaced by OAuth2, and dead email exceptions are removed.

**Server:** `SerializationManagerServer` is removed. Generated projects now import `src/generated/serverpod.dart` and create the server with `Serverpod(args)`; the `Serverpod(args, Protocol(), Endpoints())` form still works.

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

