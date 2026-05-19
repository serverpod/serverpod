---
name: serverpod-upgrading
description: Upgrade Serverpod versions, add a database to a project created without one, or address breaking changes. Use when upgrading Serverpod, updating dependencies, or enabling database support on an existing project.
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

# Adding a database to a project created without one

Some Serverpod projects are created without a database. Add one by re-running the project creator (`serverpod create .`), which uses an interactive TUI. STOP and ask the user to run it; do not attempt to drive the TUI yourself.

**Detect no-database state:** `config/development.yaml` lacks a `database:` block, or there is no `docker-compose.yaml` at the server package root.

## Steps

1. Ask the user to run `serverpod create .` from inside the server package directory (e.g. `cd my_project_server && serverpod create .`).
2. Warn the user that the TUI does NOT remember previous project selections. They must re-pick the original options (Flutter, Redis, Auth, Web, Skills) PLUS choose `database: postgres` (or `sqlite`).
3. After completion, verify it landed: `config/development.yaml` has a `database:` block, `docker-compose.yaml` exists at the server package root, `config/passwords.yaml` has a `database` entry, and a default migration exists under `migrations/`.
4. Add `table: <table_name>` to any `.spy.yaml` model(s) the user wants persisted. See [Serverpod Models](../serverpod-models/SKILL.md).
5. Regenerate code: use the MCP `generate` tool if connected, otherwise run `serverpod generate`.
6. Create a migration: use the MCP if connected, otherwise run `serverpod create-migration`. See [Serverpod Migrations](../serverpod-migrations/SKILL.md).
7. Ask the user to start the database with `docker compose up -d` (from the server package directory) and apply the migration.

A `Dockerfile` is not added by this flow. It is a separate production deployment artifact, not required for local database support.

