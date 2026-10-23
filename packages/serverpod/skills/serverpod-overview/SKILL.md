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

Each of these feature areas has its own `serverpod-*` skill; use the one that matches the task. The Insights companion app is not covered by a skill and is documented at https://docs.serverpod.dev.

## Running the server

The development stack is run by the Serverpod runner, one background process per server package. It generates code, compiles the server with hot reload, launches the companion Flutter apps and serves the `serverpod` MCP. While it runs it watches for file changes to run incremental code generation and hot reload the server (and the Flutter app, when the project has one).

- `serverpod start` ensures a runner is running, spawning one when none is, and attaches to it: the interactive terminal UI on a terminal, a plain log stream otherwise or with `--no-tui`. It blocks until the user leaves. Leaving a `start` that spawned the runner stops it; leaving one that attached to a runner already running keeps it running. This is what the user runs. `serverpod start --no-attach` behaves as `serverpod runner start`.
- `serverpod runner start` ensures a runner is running the same way, prints its addresses and returns, leaving it running in the background. This is how you start it. A cold start compiles the whole project and can take minutes. Companion Flutter apps declared with `auto_launch` launch once a UI attaches; launch any app before that with the MCP tool `spawn_flutter_app`.
- `serverpod runner attach` attaches a UI to a runner already running, the same way `serverpod start` does, and never spawns one. Leaving it keeps the runner running.
- `serverpod runner status` prints whether the runner is starting, running, stopping or up with a project that failed to build, the API, Insights and web URLs and the log path.
- `serverpod runner stop` stops the runner.

All of them resolve the server package from the current directory, or take `--directory <server package>` (`-d`).

Do not check whether the server is running before acting: make the changes and call the `serverpod` MCP tools. When nothing is running, the MCP answers with an explicit "the server is not running" error. Then:

1. Call `tail_runner_logs` to learn whether a runner is still starting or why it stopped.
2. If none is running, run `serverpod runner start` in the server package. It returns zero once the server is up. It returns non-zero when the project does not build (the runner stays up and, with watch on, the default, starts the server once a change makes it build), when a configured port is held by something other than a Serverpod runner, or when Docker refused. Fix the cause instead of retrying. The one exception is a `serverpod runner start` your shell killed on a timeout before it returned: the runner keeps starting in the background, and running the command again waits for it.
3. Call the MCP tool again. The MCP reconnects by itself.

Leave the runner running when you are done; the user attaches to it with `serverpod start`. Run `serverpod runner stop` only when asked. Starting the stack with `--watch`, `--target`, `--flutter`, `--docker` or server arguments that differ from the running runner's fails and names the difference; stop that runner first.

ALWAYS use the MCP server instead of the command line for the tasks below. The `serverpod runner` commands are the exception: they manage the stack itself. A running runner exposes:

- `create_migration` and `apply_migrations` for the database (after you change data models).
- `create_repair_migration` when the database has drifted out of sync with the migrations. It only writes the repair file; follow up with `apply_migrations`.
- `tail_server_logs` to read logs from the server.
- `tail_runner_logs` to read the output of the runner itself (code generation, compilation, Docker, raw server output). The only tool that also works while the server is starting or after it stopped.
- `tail_flutter_logs` to read raw stdout/stderr from a Flutter app.
- `hot_reload` to reload the server and the Flutter app while keeping in-memory state. Only needed with `--no-watch`, since the runner reloads on file changes.
- `hot_restart` to restart the server and the Flutter app, dropping in-memory state. ALWAYS call it after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` to get the Dart Tooling Daemon URI of a running Flutter app. Pass it to the `dart` MCP to drive the app.

Tools that target a Flutter app take an optional `appId`, which is the map key under `serverpod: flutter_apps:`. It is required only when the project declares more than one app.

## Several servers at once

Each server package has exactly one runner, keyed by the package directory: its manifest, lock, log and sockets live in `<server package>/.dart_tool/serverpod/`, and every runner registers itself under `~/.serverpod/runners/`. So a workspace with several server packages, and several checkouts or worktrees of the same project, each run their own runner. Start each with `serverpod runner start --directory <server package>`. An MCP bridge serves one server package, so the agent configuration needs one `serverpod mcp-server --server-dir <server package>` entry per server. The bridge serves the package its `--server-dir` names, not the directory you are in, and says which in its instructions and errors. Check that before applying migrations or restarting from another checkout or worktree.

The packages usually share a `config/development.yaml` with the same ports (8080, 8081, 8082). The first runner binds them. A runner that finds them claimed by another runner moves all of its listeners to ephemeral ports together, and keeps those ports across its own restarts while they stay free. Never assume `localhost:8080`: read the addresses from `serverpod runner status` or from what `serverpod runner start` printed. Flutter apps the runner launches receive the right URL through `--dart-define=SERVER_URL=...`; an app started by hand, a browser tab or `curl` must use the address from `status`.

A configured port held by anything other than a Serverpod runner, such as a server started by hand with `dart run bin/main.dart`, is an error: stop that process or change the port in `config/development.yaml`.

The embedded PostgreSQL (`database.dataPath`) is per checkout. It listens on its Unix socket, and on loopback TCP at `database.port` when the run mode has a database password. That port is a fourth listener: it moves aside with the server ports, and `status` prints the database address. A database this checkout already runs, started by `serverpod database start`, is joined rather than moved. Only a project that uses the Docker Compose database shares host ports, and the compose project is named after the server directory, so two checkouts of such a project would share one set of containers. Start a checkout that uses this shared Compose stack only when no other checkout is using it. Otherwise, leave the existing stack running and do not start this checkout's runner unless the user explicitly asks to switch checkouts.

## Working on the project with no running instance

- NEVER run `serverpod generate` or `serverpod create-migration` while the MCP is available: the runner generates code on save and the MCP creates migrations. The `serverpod runner` commands manage the stack itself and are always allowed.
- ONLY when the MCP is not available or `serverpod runner start` could not bring the server up, generate the code by calling `serverpod generate`.
- NEVER edit the generated code, as it will be overwritten by the next generation. This does not cover the SQL of a created migration, which may be edited — see the [Serverpod Migrations](../serverpod-migrations/SKILL.md) skill.

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
