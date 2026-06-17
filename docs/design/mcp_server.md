# Design: MCP Server for `serverpod start`

This document describes the MCP (Model Context Protocol) integration for `serverpod start`, allowing AI agents to programmatically interact with running dev environments.

The integration has two parts:

- A small **per-runner MCP server** that lives inside each `serverpod start` process and exposes dev operations against that instance (`apply_migrations`, `create_migration`, `create_repair_migration`, `hot_reload`, `hot_restart`, `tail_server_logs`, `tail_flutter_logs`, `get_flutter_app_dtd`, and the `serverpod://vm-service` resource).
- A long-lived **bridge MCP server** (`serverpod mcp-server`) that sits on stdio between the AI client and one runner. It is configured for a single server project, connects to that project's runner socket on demand, and forwards tool calls. The bridge survives runner restarts.

The per-runner server runs inside the CLI process, alongside the compiler, file watcher, and watch session. It is not part of the server subprocess (the Serverpod application). This keeps dev tooling concerns out of the framework itself - the `serverpod` package should not impose an MCP dependency or dev-time features on the application server. It also means the MCP server has access to the CLI's internal state (the incremental compiler, the server process handle, the restart lifecycle) which the server subprocess does not.

## Motivation

During development with `serverpod start`, file watching, code generation, compilation, and hot reload are fully automatic (when run with the default `--watch`). However, some operations require explicit intent - applying database migrations is destructive or schema-altering and should not happen automatically on file change.

These operations currently require stopping the server, re-running with flags, or manual SQL. An MCP server lets AI agents trigger them in-context during a development session.

The bridge layer solves a separate problem: when the runner process (`serverpod start`) exits or is restarted, the MCP socket it owns goes with it. AI clients do not automatically reconnect to a dropped MCP server, so without a bridge the integration breaks every time the dev process is restarted. A persistent stdio bridge stays up across runner restarts and transparently reconnects to the socket the next time a tool is called. The MCP socket is owned by the CLI process, not the pod subprocess, so a pod restart leaves the socket intact.

## Architecture

### Two processes, two MCP servers

```
AI client (e.g. Claude Code)
    │  stdio  (long-lived)
    ▼
serverpod mcp-server             <- BridgeMcpServer (this process)
    │
    │  connects to <serverDir>/.dart_tool/serverpod/mcp.sock
    │  reconnects transparently across runner restarts
    │
    ▼  unix socket  (re-established on demand)
serverpod start   <- ServerpodMcpServer (per-runner)
```

The bridge is **per-project**: each `serverpod mcp-server` is bound to one server directory and forwards to that project's runner. To work with multiple projects, configure one `serverpod mcp-server` entry per project (each with its own `--server-dir`).

### Transport: Unix domain sockets

Each runner binds to a Unix domain socket (AF_UNIX) rather than TCP or stdio. This avoids network exposure, port conflicts, and explicit permission management. The bridge connects to that socket as an MCP client and re-exposes the runner over stdio.

Requires Dart 3.11+ for AF_UNIX support on Windows.

### Project-local socket directory

The socket lives inside the server project's `.dart_tool/`:

```
<serverDir>/.dart_tool/serverpod/
└── mcp.sock
```

- `<serverDir>` is the server package directory (the package that depends on `serverpod`).
- There is exactly one socket per project; the filename is fixed (`mcp.sock`).
- `.dart_tool/` is already VCS-ignored and per-project, so the socket is scoped, easy to locate, and never committed.

**Why project-local.** Each bridge is configured for a specific project (one MCP-config entry per project, pointed at its `--server-dir`), so it does not need to discover instances machine-wide - it already knows exactly which socket to connect to. A fixed, project-relative path means no manifest, no PID bookkeeping, and no shared directory to manage permissions on: the socket inherits the project directory's permissions, which are already per-user in any normal checkout.

**One runner per project.** Because the path is fixed, only one `serverpod start` can own a project's socket at a time. Before a runner takes over, it probes the socket (`_detectExistingInstance`); if another process is already listening, it bails out with a message instead of fighting over the path. A stale socket file left behind by a crashed runner is unlinked by `bindUnixSocket` before the next bind.

### `serverpod mcp-server` (the bridge)

```json
{
  "mcpServers": {
    "serverpod": {
      "command": "serverpod",
      "args": ["mcp-server", "--server-dir", "<path-to-server-package>"]
    }
  }
}
```

The `--server-dir` (`-s`) flag points the bridge at one server package. It is auto-detected from the current working directory when omitted, but should be passed explicitly in monorepos with multiple server projects. The bridge connects to that project's socket lazily, on the first tool or resource call.

#### Tools and resources exposed by the bridge

The bridge mirrors the runner's surface. Both the runner-side server and the bridge build their tool/resource lists from the same definitions in `runner_surface.dart` (`runnerStaticTools`, `runnerStaticResources`), so the two surfaces cannot drift. The bridge registers a thin forwarder for each at construction - so the full surface is advertised to the AI client immediately, before any runner is running - and each forwarder lazily connects to the runner when first invoked.

Forwarded tools:

| Tool                      | Behavior                                                                                                                        |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `apply_migrations`        | Apply pending database migrations without restarting the server. Call after creating a migration.                              |
| `create_migration`        | Create a new migration from the current model definitions. Writes files only; follow up with `apply_migrations`.               |
| `create_repair_migration` | Create a repair migration that brings the live database in line with a target migration version (default: latest).             |
| `hot_reload`              | Hot-reload the running server isolate, preserving in-memory state. Falls back to a restart. Mainly useful with `--no-watch`.    |
| `hot_restart`             | Restart the running server process, dropping all in-memory state. Use when reload would not suffice or to recover a stuck isolate. |
| `tail_server_logs`        | Return recent server log entries (structured logs plus completed operations). Newest last.                                     |
| `tail_flutter_logs`       | Return recent raw stdout/stderr lines from the Flutter app started by `serverpod start`. Newest last.                          |
| `get_flutter_app_dtd`     | Return the Dart Tooling Daemon (DTD) URI for the Flutter app. Null until the app publishes its DTD endpoint.                   |

Forwarded resource:

| Resource                 | Behavior                                                                                                                                              |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `serverpod://vm-service` | Dart VM service HTTP URI for the running server isolate. Stable across hot reloads; changes on restart (`hot_restart` or crash recovery). Subscribable. |

When no runner is listening, tool forwarders return an error telling the agent to start the server with `serverpod start`, and the resource reader returns a `not-running` marker. As soon as a runner is up, the next call connects and succeeds - no client-side reconnect step is needed.

For per-resource updates, the bridge subscribes to each forwarded resource on connect and re-emits `notifications/resources/updated` to the client. Resources that don't support subscription are silently skipped (reads still work).

### `apply_migrations` tool (runner side)

`apply_migrations` connects to the database directly and applies pending migrations against the live schema, leaving the running pod in place (hot reload picks up any model code changes). When an MCP client (the bridge, in practice) calls it:

1. The watch session applies pending migrations through the same serialized chain as restart and reload, so a migration cannot interleave with a recompile.
1. The tool returns success/failure status. On a database error or a disposed session, the tool returns an error.

The runner's MCP socket survives this operation because the socket is owned by the CLI process, not the server subprocess.

## Implementation

### Shared helpers (`lib/src/mcp/socket_directory.dart`)

- `serverpodMcpSocketPath(serverDir)` - the canonical socket path, `<serverDir>/.dart_tool/serverpod/mcp.sock`.
- `socketChannel(Socket)` - wraps a `Socket` in the line-delimited `StreamChannel<String>` that `dart_mcp` expects.

The shared tool/resource definitions live in `lib/src/mcp/runner_surface.dart` and are consumed by both the runner-side server and the bridge forwarders.

The low-level Unix socket primitives live in `serverpod_shared` (`bindUnixSocket`, `connectUnixSocket`, `hasUnixSocketSupport`, and the `sockaddr_un.sun_path` length checks). `bindUnixSocket` unlinks any stale file before binding and shortens the path to fit the platform's socket-path limit (104 bytes on macOS, 108 on Linux/Windows).

### Runner side (`lib/src/commands/start/mcp_socket.dart`)

`McpSocketServer({required serverDir})` derives its socket path from `serverDir`. `start()` creates the parent directory if missing, binds the `ServerSocket` (unlinking any stale file), and accepts at most one client at a time. `close()` shuts down the active MCP server, destroys the client socket, and deletes the socket file. New connections wait for any in-flight shutdown to settle and are rejected once `close()` has been called.

`ServerpodMcpServer` (`lib/src/commands/start/mcp_server.dart`) extends `MCPServer` with `ToolsSupport` and `ResourcesSupport`. It registers every tool in `runnerStaticTools` against callbacks wired by `start.dart`, and exposes the `serverpod://vm-service` resource, re-emitting an update whenever the `vmServiceUriChanges` stream fires.

### Bridge side (`lib/src/mcp/bridge_mcp_server.dart`)

`BridgeMcpServer({required socketPath})` registers a forwarder for every `runnerStaticTools`/`runnerStaticResources` entry at construction. On the first call it lazily connects to the runner socket via `_ensureConnected`, which coalesces concurrent callers so a burst of tool calls opens a single connection. Each forwarder delegates through `_connection.callTool`/`readResource`; if no runner is listening, the tool forwarder returns a "not running" error and the resource reader returns a `not-running` marker. The bridge subscribes to the static resources and re-emits `resources/updated` to the client. When the upstream `connection.done` fires (the runner died or restarted), it drops the connection so the next call reconnects transparently. There is no `connect`/`disconnect`/`spawn`/`stop` surface - a bridge maps to exactly one project for its whole life.

### CLI command (`lib/src/commands/mcp.dart`)

`serverpod mcp-server [--server-dir <path>]` resolves the server directory (auto-detected from the cwd via `ServerDirectoryFinder`, or the explicit flag), validates Unix socket support, computes the socket path, and wires `stdin`/`stdout` to a `BridgeMcpServer` via `dart_mcp`'s `stdioChannel`. It blocks on `server.done` so the process stays up as long as the AI client holds stdin open.

### Integration with watch mode

In `_startWatchSession()` (`start.dart`), `McpSocketServer(serverDir: serverDir)` is started and its callbacks are wired: `apply_migrations` -> `WatchSession.applyMigration`; `create_migration` -> a `_createMigrationForMcp` closure (over the shared `createMigrationAction` helper used by `serverpod create-migration` and the TUI button); `create_repair_migration` -> `_createRepairMigrationForMcp`; `hot_reload` -> `WatchSession.forceReload`; `hot_restart` -> `WatchSession.forceRestart`; `tail_server_logs`/`tail_flutter_logs` -> log-history getters; `serverpod://vm-service` -> the proxy URI; `get_flutter_app_dtd` -> the Flutter process's DTD URI. The MCP server is started regardless of `--watch` (the flag only controls auto-reload on file changes). The socket is closed on shutdown (signal, TUI quit, or session exit), which removes the file.

### Live migration apply

`WatchSession.applyMigration()` connects to the database directly via the CLI-side `applyPendingMigrations` runner and applies pending migrations against the live schema; the running pod is left in place, since hot reload picks up any model code changes. The call serializes through the same chain as restart and reload (so a migration cannot interleave with a recompile), and throws on failure (database error, session disposed) so the MCP server can report errors to the client. The same path runs unconditionally on `serverpod start` boot - the MCP tool covers the mid-session case where new migrations land while the pod is already up.

## Design Decisions

### Why a project-local socket rather than a shared temp dir

A bridge is configured per project, so it always knows which socket to connect to - there is nothing to discover. A fixed, project-relative path under `.dart_tool/` avoids a shared machine-wide directory, a manifest file, PID bookkeeping, and any special permission handling: the socket inherits the project directory's (already per-user) permissions and is VCS-ignored. The single fixed path also doubles as a cheap lock - a second `serverpod start` for the same project detects the live socket and bails instead of colliding.

### Why a bridge at all

Without a bridge, the MCP connection is bound to the runner's lifetime: stopping or restarting the `serverpod start` process tears down the AI client's MCP server, and Claude Code does not auto-reconnect. A persistent stdio bridge breaks that coupling: runners are ephemeral, the bridge survives, and it reconnects to the socket on the next tool call. (The MCP client never talks to the server subprocess directly, so server restarts triggered by `apply_migrations`, `hot_reload`, or `hot_restart` do not break the connection.)

### One bridge per project

Binding each bridge to a single project keeps tool semantics unambiguous - the client always knows which project an `apply_migrations` call lands on. A multi-project bridge would force every forwarded tool to grow a target argument and risk silent cross-project effects. Users with multiple projects open configure one bridge entry per project.

### What belongs on the MCP server

Any operation that the AI agent reaches for mid-session against a running dev environment belongs on the MCP server, whether or not it strictly needs the CLI's in-memory state. Keeping those operations behind the socket gives agents a stable, discoverable interface tied to the specific running instance (no ambiguity about which project directory the action lands in) and avoids forcing the agent to shell out with the right flags and working directory each time.

- Operations that need the CLI's in-memory state (compiler, server lifecycle) - `hot_reload`, `hot_restart` - must live here.
- Operations that are conceptually per-instance but don't strictly need in-memory state - `apply_migrations`, `create_migration`, `create_repair_migration`, `tail_server_logs`, `tail_flutter_logs` - are exposed here too. The alternative (shelling out to a CLI command) forces a context switch, adds a failure mode where the agent runs in the wrong directory, and makes tool discovery dependent on a shipped skill file.

Commands that are project-setup / one-shot / infrastructure (`serverpod create`, `serverpod generate` outside watch mode, `serverpod mcp-server` itself) stay as CLI commands. They don't belong to a running instance and don't benefit from being forwarded through a socket.

Future MCP tool candidates include `server_status` (only the CLI knows whether the server subprocess is running, compiling, or errored).

## Dependencies

- `dart_mcp: ^0.5.x` - MCP server and client base classes; `stdioChannel` for the bridge transport.
- `stream_channel` - bidirectional stream abstraction for the socket channel.

## History

An earlier iteration of this integration put sockets in a shared, per-machine temp directory (`<systemTemp>/serverpod/serverpod-<pid>-<project>.sock`) and used a multi-instance bridge: a single `serverpod mcp-server` discovered all running runners by scanning that directory and exposed `connect`/`disconnect`/`spawn`/`stop` tools plus a `serverpod://instances` resource for the agent to pick an instance. That was replaced by the current project-local, one-bridge-per-project model. The trade-off: the agent configures one bridge per project (pointed at `--server-dir`) instead of one bridge for the whole machine, in exchange for a much simpler design - no shared directory, no PID-keyed filenames, no discovery scan, no manual `connect` step, and transparent auto-reconnect across runner restarts.

## Open Questions

1. Should pressing `a` during watch mode also trigger apply-migration? This requires switching stdin to raw mode, which adds complexity (signal handling, non-TTY environments, Windows). May be better as a follow-up.
1. Should the runner expose more state as resources (e.g. migration status, compile/run state) in addition to `serverpod://vm-service`? This would let AI agents observe state without polling. Each new resource has to be declared in `runner_surface.dart` so the bridge can forward it.
