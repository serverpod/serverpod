---
name: serverpod-overview
description: Serverpod overview — what it is, project structure, how to work with. Always use at least once when working with projects that use Serverpod.
---

# Serverpod Overview

Serverpod is an open-source backend framework for Flutter written in Dart. A Serverpod project consists of usually three packages:

`my_project_server` - the server code.
`my_project_client` - generated client code.
`my_project_flutter` - a Flutter app (imports the client).

There can also be packages that share code, e.g., `my_project_shared`.

The server starts in `lib/server.dart`, which creates the generated `Serverpod` class from `src/generated/serverpod.dart` (pre-wired with the project's protocol and endpoints) with `final pod = Serverpod(args);` and then `await pod.start();`.

The server exposes endpoint classes that the client calls via generated RPC client. Add methods to the endpoints, the code generation will recreate them on the client side. Models are defined in YAML and generate Dart classes for both server and client.

Serverpod projects use a PostgreSQL database for persistence (SQLite is also supported) and include an ORM, caching, real-time streaming (using Dart streams), file uploads, scheduling (called future calls), logging, and a built-in web server (Relic).

## Which skill to use

| Task | Skill |
| ---- | ----- |
| Define or change models, database schema, `.spy.yaml` | [serverpod-models](../serverpod-models/SKILL.md) |
| Create or update database migrations | [serverpod-migrations](../serverpod-migrations/SKILL.md) |
| Query the database, relations, transactions | [serverpod-database](../serverpod-database/SKILL.md) |
| Add RPC endpoints called from the client | [serverpod-endpoints](../serverpod-endpoints/SKILL.md) |
| Real-time features over WebSockets | [serverpod-streams](../serverpod-streams/SKILL.md) |
| Pub/sub between servers or streams | [serverpod-server-events](../serverpod-server-events/SKILL.md) |
| Sign in users, scopes, user profiles | [serverpod-auth](../serverpod-auth/SKILL.md) |
| Write server tests | [serverpod-testing](../serverpod-testing/SKILL.md) |
| Config files, env vars, secrets, run modes | [serverpod-configuration](../serverpod-configuration/SKILL.md) |
| Scheduled and recurring work (future calls) | [serverpod-scheduling](../serverpod-scheduling/SKILL.md) |
| Cache data | [serverpod-caching](../serverpod-caching/SKILL.md) |
| Upload and store files | [serverpod-file-uploads](../serverpod-file-uploads/SKILL.md) |
| Logging and debugging server calls | [serverpod-logging](../serverpod-logging/SKILL.md) |
| Session lifecycle, manual sessions | [serverpod-sessions](../serverpod-sessions/SKILL.md) |
| HTTP routes, webhooks, web pages, Flutter web | [serverpod-webserver](../serverpod-webserver/SKILL.md) |
| Add or create modules | [serverpod-modules](../serverpod-modules/SKILL.md) |
| Kubernetes probes and health checks | [serverpod-health-checks](../serverpod-health-checks/SKILL.md) |
| Upgrade Serverpod versions | [serverpod-upgrading](../serverpod-upgrading/SKILL.md) |

Deployment, hosting and the Insights companion app are documented at https://docs.serverpod.dev.

## Running the server

Most likely the server is already running with hot reload and `serverpod generate --watch`. NEVER attempt to start the server. The user is running the server with the `serverpod start` command (as an agent do NOT run this command, instead prompt the user to run `serverpod start`, if necessary). Hot reload will update the generated code and quickly restart the server when files are changed.

ALWAYS use the MCP server instead of the command line. A running `serverpod start` exposes:

- `create_migration` and `apply_migrations` for the database (after you change data models).
- `create_repair_migration` when the database has drifted out of sync with the migrations. It only writes the repair file; follow up with `apply_migrations`.
- `tail_server_logs` to read logs from the server.
- `tail_flutter_logs` to read raw stdout/stderr from a Flutter app.
- `hot_reload` to reload the server and the Flutter app while keeping in-memory state. Only needed with `--no-watch`, since `serverpod start` reloads on file changes.
- `hot_restart` to restart the server and the Flutter app, dropping in-memory state. ALWAYS call it after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` to get the Dart Tooling Daemon URI of a running Flutter app. Pass it to the `dart` MCP to drive the app.

Tools that target a Flutter app take an optional `appId`, which is the map key under `serverpod: flutter_apps:`. It is required only when the project declares more than one app.

## Working on the project with no running instance

- NEVER use the CLI unless you have already attempted to use the MCP.
- ONLY if you cannot connect to the MCP server, the code can be generated by calling `serverpod generate`.
- NEVER edit the generated code, as it will be overwritten by the next generation.

After generating the code, database migrations can be created by calling `serverpod create-migration`. Use ONLY if you cannot use the MCP.

```bash
# Use `--force` to create migrations with destructive changes
# Use the `--tag` flag to name the migration
serverpod create-migration [--force] [--tag <tag>]
```

See the [Serverpod Migrations](../serverpod-migrations/SKILL.md) skill for more details.

Checklist after doing changes:

1. `dart analyze` (CLI, or the `dart` MCP server)
2. `dart format` (CLI, or the `dart` MCP server)
3. Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
4. Check `serverpod` MCP `tail_server_logs` (and `tail_flutter_logs` for a Flutter app) for any issues
