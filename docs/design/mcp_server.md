# Design: MCP Server for `serverpod start --watch`

This document describes the MCP (Model Context Protocol) server exposed by `serverpod start --watch`, allowing AI agents to programmatically interact with the running dev environment.

The MCP server runs inside the CLI process, alongside the compiler, file watcher, and watch session. It is not part of the server subprocess (the Serverpod application). This keeps dev tooling concerns out of the framework itself - the `serverpod` package should not impose an MCP dependency or dev-time features on the application server. It also means the MCP server has access to the CLI's internal state (the incremental compiler, the server process handle, the restart lifecycle) which the server subprocess does not.

## Motivation

During development with `serverpod start --watch`, file watching, code generation, compilation, and hot reload are fully automatic. However, some operations require explicit intent - applying database migrations is destructive or schema-altering and should not happen automatically on file change.

These operations currently require stopping the server, re-running with flags, or manual SQL. An MCP server lets AI agents trigger them in-context during a development session.

## Architecture

### Transport: Unix domain sockets

The MCP server binds to a Unix domain socket (AF_UNIX) rather than TCP or stdio. The socket lives inside `.dart_tool/serverpod/` which is user-owned project-local state, so there is no network exposure, no port conflicts, and no need for explicit permission management. The socket is tied to the CLI process and cleaned up on exit.

Requires Dart 3.11+ for AF_UNIX support on Windows.

### Socket path

The socket file is stored in the project's tool directory:

```
<server_dir>/.dart_tool/serverpod/mcp.sock
```

This is the same directory used for `server.dill` and `vm-service-info.json`. Since the socket is project-scoped, there is no need for PID or project name in the filename - only one `serverpod start --watch` instance runs per project at a time.

### `serverpod mcp`

MCP clients typically communicate over stdio. The `serverpod mcp` command acts as a stdio-to-socket bridge, connecting to the project's `mcp.sock`:

```
MCP client  ──stdio──>  serverpod mcp  ──unix socket──>  CLI process
```

The command auto-detects the server directory the same way `serverpod start` does, and supports `--directory` / `-d` to specify it explicitly.

Example MCP config (Claude Code: `.mcp.json`, Cursor: `.cursor/mcp.json`)):

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

### `apply_migrations` tool

Restarts the server subprocess with `--apply-migrations` added to its arguments. This is a one-shot flag - subsequent restarts and reloads use the original args.

When an MCP client calls `apply_migrations`:

1. The watch session resets the compiler and does a full compile.
1. The server subprocess is stopped and restarted with `--apply-migrations` appended.
1. The tool returns success/failure status. On compilation failure or reentrancy, the tool returns an error.

## Implementation

### MCP socket server

`McpSocketServer` takes a full socket path, binds a `ServerSocket` to a Unix domain address, and converts socket connections to `StreamChannel<String>` using line-delimited JSON-RPC. Only one client connection is active at a time - new connections await shutdown of the previous client before proceeding.

### MCP server

`ServerpodMcpServer` extends `MCPServer` (from the `dart_mcp` package) with the `ToolsSupport` mixin. It registers the `apply_migrations` tool with a callback into the `WatchSession`.

### Integration with watch mode

In `_startWatchSession()` (start.dart), the MCP socket server is created with a socket path under `serverpodToolDir`. The `apply_migrations` callback is wired to `WatchSession.applyMigration`. The socket is cleaned up on exit.

### One-shot migration flag

`WatchSession.applyMigration()` does a full compile, stops the server, and creates a new server with `extraArgs: ['--apply-migrations']`. The method throws on failure (compilation error, already in progress, `--no-fes` mode) so the MCP server can report errors to the client.

### CLI command

The `serverpod mcp` command resolves the server directory via `GeneratorConfig.load()`, connects to `mcp.sock`, and bridges stdin/stdout with cleanup on disconnect.

## Design Decisions

### Why only CLI-internal operations are exposed via MCP

The MCP server exposes only operations that require the CLI's internal state. Stateless operations like `serverpod create-migration` or `serverpod generate` are better invoked directly as CLI commands.

Agents can discover CLI commands through a skill (a project-level instruction file that teaches the agent about available commands and workflows). This requires no code and no maintenance coupling to CLI flag changes. CLI commands also work without `serverpod start --watch` running; wrapping them in MCP would make them unavailable outside watch mode.

If an operation needs the CLI's in-memory state, it belongs on the MCP server. Otherwise, it's a CLI command documented via a skill.

Future MCP tool candidates include `server_status` (only the CLI knows whether the server subprocess is running, compiling, or errored).

## Dependencies

- `dart_mcp: ^0.4.x` - MCP server base class, tools/resources support.
- `stream_channel` - bidirectional stream abstraction.

## Open Questions

1. Should pressing `a` during watch mode also trigger apply-migration? This requires switching stdin to raw mode, which adds complexity (signal handling, non-TTY environments, Windows). May be better as a follow-up.
1. Should the MCP server expose resources (e.g. migration status, server state) in addition to tools? This would let AI agents observe state without polling.
