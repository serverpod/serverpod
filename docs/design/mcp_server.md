# Design: MCP Server for `serverpod start --watch`

This document describes the MCP (Model Context Protocol) integration for `serverpod start --watch`, allowing AI agents to programmatically interact with running dev environments.

The integration has two parts:

- A small **per-runner MCP server** that lives inside each `serverpod start --watch` process and exposes dev operations against that instance (currently: `apply_migrations`, `create_migration`, `hot_reload`, `tail_logs`).
- A long-lived **bridge MCP server** (`serverpod mcp`) that sits on stdio between the AI client and the runners. It discovers running instances by scanning a shared socket directory, connects to one at a time, and forwards tool calls. The bridge survives runner restarts.

The per-runner server runs inside the CLI process, alongside the compiler, file watcher, and watch session. It is not part of the server subprocess (the Serverpod application). This keeps dev tooling concerns out of the framework itself - the `serverpod` package should not impose an MCP dependency or dev-time features on the application server. It also means the MCP server has access to the CLI's internal state (the incremental compiler, the server process handle, the restart lifecycle) which the server subprocess does not.

## Motivation

During development with `serverpod start --watch`, file watching, code generation, compilation, and hot reload are fully automatic. However, some operations require explicit intent - applying database migrations is destructive or schema-altering and should not happen automatically on file change.

These operations currently require stopping the server, re-running with flags, or manual SQL. An MCP server lets AI agents trigger them in-context during a development session.

The bridge layer solves a separate problem: when the runner process (`serverpod start --watch`) exits or is restarted, the MCP socket it owns goes with it. AI clients do not automatically reconnect to a dropped MCP server, so without a bridge the integration breaks every time the dev process is restarted. A persistent stdio bridge stays up across runner restarts and lets the client `connect` again. The MCP socket is owned by the CLI process, not the pod subprocess, so a pod restart leaves the socket intact.

## Architecture

### Two processes, two MCP servers

```
AI client (e.g. Claude Code)
    │  stdio  (long-lived)
    ▼
serverpod mcp             <- BridgeMcpServer (this process)
    │
    │  scans .../serverpod/serverpod-<pid>-<project>.sock
    │  connects to one at a time
    │
    ▼  unix socket  (re-established on each connect)
serverpod start --watch   <- ServerpodMcpServer (per-runner)
```

The bridge is **single-instance**: at any moment it forwards to at most one runner. Switching runners is an explicit `disconnect` then `connect` from the client. To bridge multiple AI windows to multiple projects, run one `serverpod mcp` per window.

### Transport: Unix domain sockets

Each runner binds to a Unix domain socket (AF_UNIX) rather than TCP or stdio. This avoids network exposure, port conflicts, and explicit permission management. The bridge connects to that socket as an MCP client and re-exposes the runner over stdio.

Requires Dart 3.11+ for AF_UNIX support on Windows.

### Shared socket directory

Sockets live in a shared, per-machine temp directory:

```
<systemTemp>/serverpod/
└── serverpod-<pid>-<project>.sock
```

- `<systemTemp>` is `Directory.systemTemp.path` (`/tmp` on Linux when `TMPDIR` is unset, `/var/folders/.../T/` on macOS, `C:\Users\<user>\AppData\Local\Temp` on Windows).
- `<pid>` is the runner's OS process id.
- `<project>` is the serverpod app name (`config.name`, with the `_server` suffix already stripped) sanitized to `[a-z0-9-]+`.

**Why a shared dir, not project-local.** A bridge process needs to discover all running instances on the machine via a single `Directory.listSync()`. Embedding the PID in the filename means discovery is stat-only - there is no separate manifest file to keep in sync, and stale files are easy to identify by checking whether the PID is still alive.

**Permissions.** The `serverpod/` directory is created with mode 0700 on POSIX so other local users cannot enter it - on Linux, where `<systemTemp>` is the shared `/tmp`, this is what keeps the per-runner sockets inaccessible to other users on the same machine. The directory is created via `Directory.systemTemp.createTempSync()` (which goes through `mkdtemp(3)` and gives 0700) and then renamed to the canonical name; rename preserves the inode and mode. Since the parent directory blocks traversal, the socket files inside don't need their own restrictive mode. On macOS and Windows the parent path is already per-user, so the 0700 is incidental there.

The bridge cleans up dead-PID sockets opportunistically the next time it scans.

### `serverpod mcp` (the bridge)

```json
{
  "mcpServers": {
    "serverpod": {
      "command": "serverpod",
      "args": ["mcp"]
    }
  }
}
```

The bridge does not need a `--directory` flag - it discovers running instances by directory scan. The AI client picks one with the `connect` tool.

#### Tools and resources exposed by the bridge

The bridge owns four native tools and one native resource. Everything else is **auto-forwarded**: on `connect`, the bridge calls `listTools()` and `listResources()` on the upstream runner and registers a thin forwarder for each item not already owned natively. On `disconnect` the forwarders are unregistered. The MCP `listChanged` capability propagates these registrations to the AI client, so the upstream surface appears and disappears as the connection state changes.

Native tools (always present):

| Tool         | Behavior                                                                                                                                                                                                                       |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `connect`    | Attach to a running instance. `instanceId` accepts the project name or PID shown in `serverpod://instances`. Auto-picks if exactly one instance is running and the argument is omitted. Calling `connect` again switches instances. |
| `disconnect` | Detach from the current instance without stopping it.                                                                                                                                                                          |
| `spawn`      | Start a new `serverpod start --watch` process detached from the bridge. Optional `directory` to choose the server dir; optional `args` appended to the CLI. Polls the socket dir for up to ~10s for the new instance to appear. Does **not** auto-connect. |
| `stop`       | Send SIGTERM to the named instance. Auto-disconnects if it was the connected one.                                                                                                                                              |

Native resource (always present):

| Resource                | Behavior                                                                                                                                                      |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `serverpod://instances` | JSON list of `{pid, project, socketPath, connected}` for each live runner. Updated when the socket directory changes or when the bridge connects/disconnects. |

Currently auto-forwarded from the runner once connected: the tools `apply_migrations`, `create_migration`, `hot_reload`, `tail_logs`, and the resource `serverpod://vm-service`. Adding a new tool or resource on the runner side requires no bridge changes - it appears in the AI client automatically on the next `connect`. Names that collide with a native bridge tool (`connect`/`disconnect`/`spawn`/`stop`) or URI (`serverpod://instances`) are skipped to keep the bridge's surface authoritative.

For per-resource updates, the bridge subscribes to each forwarded resource on `connect` and re-emits `notifications/resources/updated` upstream. Resources that don't support subscription are silently skipped (reads still work).

### `apply_migrations` tool (runner side)

Restarts the server subprocess with `--apply-migrations` added to its arguments. This is a one-shot flag - subsequent restarts and reloads use the original args.

When an MCP client (the bridge, in practice) calls `apply_migrations`:

1. The watch session resets the compiler and does a full compile.
1. The server subprocess is stopped and restarted with `--apply-migrations` appended.
1. The tool returns success/failure status. On compilation failure or reentrancy, the tool returns an error.

The runner's MCP socket survives the server-subprocess restart because the socket is owned by the CLI process, not the server subprocess.

## Implementation

### Shared helpers (`lib/src/mcp/socket_directory.dart`)

- `serverpodMcpSocketDir`, `ensureServerpodMcpSocketDir` - the shared dir under `Directory.systemTemp`.
- `serverpodMcpSocketPath({pid, project})` - canonical filename.
- `sanitizeProjectName(name)` - `[^a-z0-9-]` -> `-`, collapse runs, strip ends.
- `listServerpodMcpSockets()` - returns `(pid, project, path)` tuples for every live socket; deletes stale ones whose PID no longer exists. Liveness check: `kill -0 <pid>` on POSIX, `tasklist` on Windows.
- `socketChannel(Socket)` - wraps a `Socket` in the line-delimited `StreamChannel<String>` that `dart_mcp` expects.

### Runner side (`lib/src/commands/start/mcp_socket.dart`)

`McpSocketServer({required project})` derives its socket path from the current `pid` and the sanitized project. `start()` ensures the shared dir exists, binds the `ServerSocket`, and accepts at most one client at a time. `close()` shuts down the active MCP server, destroys the client socket, and unlinks the socket file. New connections wait for any in-flight shutdown to settle and are rejected once `close()` has been called.

`ServerpodMcpServer` (`lib/src/commands/start/mcp_server.dart`) extends `MCPServer` with `ToolsSupport` and `ResourcesSupport`. It registers `apply_migrations`, `create_migration`, `hot_reload`, and `tail_logs` tools against callbacks wired by `start.dart` (`WatchSession.applyMigration`, a `createMigrationAction`-backed closure, `WatchSession.forceReload`, and a log-history getter respectively). It also exposes the `serverpod://vm-service` resource.

### Bridge side (`lib/src/mcp/`)

- `ServerpodMcpBridge` - owns the discovered socket list. `scan()` re-reads the dir; `startWatching()` subscribes to `Directory.watch()` and coalesces bursts into single rescans via `asyncMapBuffer`; `findSocket(id)` matches by project then PID; `dispose()` cancels the watcher.
- `BridgeMcpServer extends MCPServer with ToolsSupport, ResourcesSupport` - registers the native tools `connect`/`disconnect`/`spawn`/`stop` and the native `serverpod://instances` resource at construction. On each `connect`, calls `listTools()`/`listResources()` on the upstream `ServerConnection`, then `registerTool` / `addResource` for every item not in the bridge-native deny set, with thin closures that delegate via `_connection.callTool`/`readResource`. The corresponding `unregisterTool`/`removeResource` happens in `_disconnectInternal`, so `listChanged` notifications cleanly publish and unpublish the upstream surface as the connection toggles. When the upstream connection completes (runner died), `_disconnectInternal` runs from the `connection.done` callback so forwarded tools/resources disappear from the AI client.

### CLI command (`lib/src/commands/mcp.dart`)

Validates Unix socket support, instantiates `ServerpodMcpBridge`, scans + starts watching, then wires `stdin`/`stdout` to a `BridgeMcpServer` via `dart_mcp`'s `stdioChannel`. Blocks on `server.done` so the process stays up as long as the AI client holds stdin open.

### Integration with watch mode

In `_startWatchSession()` and `_runTuiBackend()` (`start.dart`), the runner-side `McpSocketServer` is constructed with `project: config.name`. The `apply_migrations` callback is wired to `WatchSession.applyMigration`; the `create_migration` callback is a closure over `createMigrationAction(config: ...)` (the shared helper also used by the `serverpod create-migration` CLI command and the TUI "Create Migration" button); `hot_reload` is `WatchSession.forceReload`; `tail_logs` reads from `holder.state.logHistory` in the TUI path. The socket is closed on shutdown (signal, TUI quit, or session exit), which removes the file from the shared dir.

### One-shot migration flag

`WatchSession.applyMigration()` does a full compile, stops the server, and creates a new server with `extraArgs: ['--apply-migrations']`. The method throws on failure (compilation error, already in progress, `--no-fes` mode) so the MCP server can report errors to the client.

## Design Decisions

### Why a shared temp dir rather than project-local sockets

A project-local socket (e.g. under `.dart_tool/serverpod/`) is invisible to a bridge that doesn't already know which projects to watch. Putting all sockets in one well-known directory means the bridge can discover instances with a stat-only scan. The PID embedded in the filename keeps discovery self-correcting (dead PIDs are obviously stale) without a separate manifest or daemon.

### Why a bridge at all

Without a bridge, the MCP connection is bound to the runner's lifetime: stopping or restarting the `serverpod start --watch` process tears down the AI client's MCP server, and Claude Code does not auto-reconnect. A persistent stdio bridge breaks that coupling: runners are ephemeral, the bridge survives, and the client just calls `connect` again. (The MCP client never talks to the server subprocess directly, so server restarts triggered by `apply_migrations` or hot reload do not break the connection.)

### Single-instance bridge

Forwarding to one runner at a time keeps tool semantics unambiguous - the client always knows which project an `apply_migrations` call lands on. Multi-attach would force every forwarded tool to grow a target argument and risk silent cross-project effects. Users with multiple projects open run one bridge per AI window.

### What belongs on the MCP server

Any operation that the AI agent reaches for mid-session against a running dev environment belongs on the MCP server, whether or not it strictly needs the CLI's in-memory state. Keeping those operations behind the socket gives agents a stable, discoverable interface tied to the specific running instance (no ambiguity about which project directory the action lands in) and avoids forcing the agent to shell out with the right flags and working directory each time.

- Operations that need the CLI's in-memory state (compiler, server lifecycle) - `apply_migrations`, `hot_reload` - must live here.
- Operations that are conceptually per-instance but don't strictly need in-memory state - `create_migration`, `tail_logs` - are exposed here too. The alternative (shelling out to `serverpod create-migration`) forces a context switch, adds a failure mode where the agent runs in the wrong directory, and makes tool discovery dependent on a shipped skill file.

Commands that are project-setup / one-shot / infrastructure (`serverpod create`, `serverpod generate` outside watch mode, `serverpod mcp` itself) stay as CLI commands. They don't belong to a running instance and don't benefit from being forwarded through a socket.

Future MCP tool candidates include `server_status` (only the CLI knows whether the server subprocess is running, compiling, or errored).

## Dependencies

- `dart_mcp: ^0.5.x` - MCP server and client base classes; `stdioChannel` for the bridge transport.
- `stream_channel` - bidirectional stream abstraction.
- `stream_transform` - `asyncMapBuffer` for coalescing socket-dir watcher events.

## Migration from the previous design

The previous integration used a project-local socket at `<server>/.dart_tool/serverpod/mcp.sock` and shipped `serverpod mcp` as a transparent stdio-to-socket pipe. That socket path is no longer used. AI client config that just runs `serverpod mcp` continues to work; configs that invoked it from a particular project directory no longer need to - the bridge discovers instances independently of the AI client's working directory.

## Open Questions

1. Should pressing `a` during watch mode also trigger apply-migration? This requires switching stdin to raw mode, which adds complexity (signal handling, non-TTY environments, Windows). May be better as a follow-up.
1. Should the runner-side server expose resources (e.g. migration status, server state) in addition to tools? This would let AI agents observe state without polling. Adds bridge work because forwarded resources have to be declared upfront in `dart_mcp`.
1. Should the bridge auto-reconnect when a previously-connected runner reappears (same project name, new PID)? Today the client must call `connect` again. Auto-reconnect is convenient but can mask runner crashes; keep manual until the friction is concrete.
