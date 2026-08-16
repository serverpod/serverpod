# Design: Hot Reload and `serverpod start`

This document describes the `serverpod start` command with file watching, incremental compilation, and hot reload support for Serverpod server development.

## Current State

There is no dedicated `serverpod start` command. The `serverpod run` command runs named scripts defined in the `serverpod/scripts` section of `pubspec.yaml`. By convention, projects define a `start` script:

```yaml
# pubspec.yaml
serverpod:
  scripts:
    start: dart run bin/main.dart
```

```shell
docker compose up -d        # Start Postgres, Redis, etc.
serverpod generate          # Generate code from .spy.yaml models and endpoints
serverpod run start         # Run the start script (or: dart run bin/main.dart)
```

Docker Compose management, code generation, and server execution are separate manual steps. There is no file watching or automatic reload.

### Existing pieces

`serverpod generate --watch` watches `lib/` for changes to model files (`.spy.yaml`) and endpoint files, then re-runs code generation with a 500ms debounce. It does not compile or reload the server.

`HotReloader` (`packages/serverpod/lib/src/hot_reload/hot_reload.dart`) connects to the Dart VM service from within the server process and calls `vmService.reloadSources()`. It is exposed via the Insights endpoint but not integrated into any CLI workflow.

Relic's hot reload support (`RelicApp._HotReloader`) listens for `kIsolateReload` VM events and automatically replays all registered `RouterInjectable`s (including `Server`) against a fresh `RelicRouter`, then re-mounts the handler. This means Relic-level routes, middleware, and handler closures are refreshed on hot reload without any additional work.

Signal-based shutdown: `Serverpod` listens for `SIGINT` and `SIGTERM` to trigger graceful shutdown (drain connections, close database pools, etc.).

### Related Issues

- [#4773](https://github.com/serverpod/serverpod/issues/4773): Allow running the server with hot reload/restart support
- [#1748](https://github.com/serverpod/serverpod/issues/1748): Hot reload support
- [#2403](https://github.com/serverpod/serverpod/issues/2403): Hot reload support

## Overview

`serverpod start` is the standard way to run a Serverpod server during development. Without flags, it wraps the server subprocess with code generation and Docker Compose management. With `--watch`, it adds file watching, incremental compilation, and hot reload.

```shell
serverpod start                   # Start Docker, generate, compile, run, watch, hot reload
serverpod start --no-watch        # Skip the Frontend Server; start via `dart run`
serverpod start --no-docker       # Skip Docker Compose management
serverpod start --no-tui          # Disable the interactive terminal UI
```

Arguments after `--` are passed through to the server process:

```shell
serverpod start -- --apply-migrations --mode production
```

## Architecture

`serverpod start` always builds a `WatchSession` over the running pod and mounts the vm-service proxy in front of it. The `--watch` flag selects whether the session subscribes to a `FileWatcher` and whether the Frontend Server is running for incremental compiles.

### `--no-watch` mode

`--no-watch` is for users who don't want file-driven recompilation but still want a single command that handles Docker, generation, and the running pod (with TUI / MCP / IDE attach). The CLI:

1. Ensures Docker Compose services are running (see [Docker Compose management](#docker-compose-management)).
1. Runs initial code generation if generated outputs are stale.
1. Spawns the server via `dart run bin/main.dart` with `--enable-vm-service`, forwarding any extra arguments (e.g. `--apply-migrations`, `--role`, `--mode`).
1. Mounts the vm-service proxy in front of the pod and publishes the proxy URI so the IDE / TUI / MCP can attach.
1. Constructs a `WatchSession` with no `KernelCompiler` and no file watcher; manual reloads route through the VM's own kernel service via the proxy.
1. Forwards `SIGTERM` to the subprocess (the OS delivers `SIGINT` to both parent and child), waits for it to exit, then exits with the same code.
1. On exit, stops Docker Compose services if the CLI started them.

### Watch mode (`--watch`, default)

Watch mode runs the entire loop (generation, compilation, reload orchestration) in a single long-lived isolate so analyzers persist and can be updated incrementally on each file change.

The core components:

- **`FileWatcher`** - Monitors `lib/`, shared model directories, and optionally `web/` for changes. Categorizes changes into dart files, model files, `package_config.json` changes, and static file changes. Debounces with a configurable delay (default 500ms).
- **`KernelCompiler`** - Wraps a vendored `frontend_server_client` for incremental compilation. Manages full vs incremental compile state internally.
- **`ServerProcess`** - Manages the server subprocess lifecycle: spawning (from `.dill` or `dart run`), output streaming, VM service connection, hot reload, and graceful shutdown with SIGTERM (5s timeout, SIGKILL fallback).
- **`WatchSession`** - Orchestrates the reload cycle: generation, compilation, and reload. Handles the decision tree for each file change event.

#### File change handling (`WatchSession`)

On each debounced file change event:

1. **Static-only changes** (no dart/model files): If the VM service is connected, call `notifyStaticChange()` via the `ext.relic.notifyStaticChange` service extension to increment the static change counter (triggering browser refresh and template reload). No compilation needed.

2. **Dart/Model changes**:
   - Run code generation via `updateAnalyzers` + `performGenerate` on the affected paths.
   - If `package_config.json` changed: restart the FES process entirely (it reads package config only at startup), then full compile.
   - If dart files changed: incremental compile with changed paths.
   - If model-only changes: return after generation - the generated `.dart` files will trigger the next watcher cycle.

3. **Hot reload**: After successful compilation, attempt `vmService.reloadSources(rootLibUri: dillUri)` on the server process. Relic's `_HotReloader` automatically picks up the `kIsolateReload` event and refreshes routes and endpoints.

4. **Reload failure**: If `reloadSources()` fails (e.g. a structural change that cannot be hot-reloaded), the CLI does a full recompile, resets the FES, and restarts the server (stops old process, creates new one from the fresh `.dill`).

Changes that arrive during an active cycle are buffered and merged by `asyncMapBuffer` into the next cycle.

#### Incremental compilation (`KernelCompiler`)

The Frontend Server runs as a persistent resident process via the vendored `frontend_server_client`:

- First run: `compile bin/main.dart` produces a `.dill` file at `.dart_tool/serverpod/server.dill`.
- On file change: `recompile bin/main.dart <changed-files>` produces an incremental `.dill` delta. Significantly faster than a full compile.
- On `package_config.json` change: `restart()` kills the FES process and starts fresh, then does a full compile.
- On reload failure: `reset()` marks the next compile as full without restarting the FES process.

The compiler tracks whether a full or incremental compile is needed internally. After `start()`, `reset()`, or `restart()`, the next compile produces a complete kernel.

#### VM service connection

The server subprocess is started with `--enable-vm-service=0` (ephemeral port) and `--write-service-info=<path>`. The CLI reads the VM service URI from the service info JSON file (with polling and retries) rather than parsing stderr. This is more reliable and allows IDEs to use the same `vmServiceInfoFile` path in their launch configuration to auto-attach for debugging.

### IDE integration via the vm-service proxy

The CLI mounts a vm-service proxy in front of the pod's VM service URI. The proxy speaks the standard VM service protocol on its own URI, forwards messages between the IDE and the pod, and intercepts `reloadSources` calls so the CLI can drive the reload through the right pipeline:

1. CLI starts the server with `--enable-vm-service`, reads the pod's URI from the service-info file, and points the proxy at it.
1. The proxy publishes its own URI to the user-facing `vm-service-info.json` (the pod's URI stays internal in `vm-service-info.pod.json`).
1. IDE attaches to the proxy URI for debugging (breakpoints, stepping - all normal).
1. User presses IDE hot reload button -> IDE calls `reloadSources` against the proxy -> proxy invokes the CLI's reload callback.
1. In `--watch` mode the callback runs an incremental FES compile and calls `reload(dillPath)`, which sends `reloadSources` with `rootLibUri` pointing at the resulting `.dill`. In `--no-watch` mode the callback calls `reload(null)`, which sends `reloadSources` without `rootLibUri` so the VM's built-in kernel service recompiles changed sources.
1. The proxy returns the synthetic `ReloadReport` to the IDE.

The TUI's reload button, MCP's `hot_reload` tool, and IDE attach all converge on the same callback. Earlier iterations registered a custom `reloadSources` service extension on the pod's VM service, which conflicted with IDE attach (see [dart-lang/sdk#62822](https://github.com/dart-lang/sdk/issues/62822)). Mounting the proxy out-of-process avoids that conflict.

### Browser auto-refresh (web server)

For projects serving web pages, automatically refresh the browser after a static file change.

A dev-only middleware injects a small script into HTML responses. The script polls a lightweight endpoint that returns a monotonically increasing static change counter. When the counter changes, the page reloads.

Server-side: A `GET /__dev/version` endpoint returns the current static change count as a plain text number. The counter lives in Relic's `developerTools.staticChangeCount` and is incremented via the `ext.relic.notifyStaticChange` VM service extension called by the CLI. The endpoint and middleware are only active in dev mode.

The middleware also reloads HTML templates from disk when the static change counter increases, so template edits are picked up without a server restart.

Client-side (injected into HTML responses):

```javascript
var v = null;
setInterval(function() {
  fetch('/__dev/version')
    .then(function(r) { return r.text(); })
    .then(function(t) {
      if (v !== null && v !== t) location.reload();
      v = t;
    })
    .catch(function() {});
}, 500);
```

### Endpoint refresh on hot reload

When Relic fires a hot reload, it replays `Server.injectIn` which re-registers all Relic-level routes. However, `EndpointDispatch.initializeEndpoints()` is only called once during startup. The `connectors` map (which maps endpoint names to their handlers) is never refreshed. This means:

- Editing an existing endpoint method body: Works. Hot reload patches method bodies in-place, and the `MethodConnector.call` lambdas hold references to `Endpoint` instances whose methods get updated.
- Adding a new endpoint, method, or renaming: Not picked up. The `connectors` map still reflects the original `initializeEndpoints()` call.

The fix: re-call `initializeEndpoints()` during the Relic hot reload replay. When `Server.injectIn` is invoked and the server is already running (i.e., this is a replay, not initial setup), clear the existing connectors and re-run `endpoints.initializeEndpoints(this)`.

```dart
@override
void injectIn(RelicRouter router) {
  if (_running) {
    endpoints.connectors.clear();
    endpoints.modules.clear();
    endpoints.initializeEndpoints(this);
  }

  // ... existing route registration ...
}
```

> [!NOTE]
> This works because `initializeEndpoints` creates new `Endpoint` instances and registers new `MethodConnector`s with fresh closures. After hot reload, the class definitions have been updated in-place, so the new instances pick up the updated code.

## Design Decisions

### Why incremental compilation over bare `vmService.reloadSources()`

Community hot reload packages for Dart ([hotreloader](https://pub.dev/packages/hotreloader), [shelf_hotreload](https://pub.dev/packages/shelf_hotreload), [Dart Frog](https://pub.dev/packages/dart_frog)) take a simpler approach: run with `--enable-vm-service`, watch files, call `vmService.reloadSources()` with no arguments. The VM's internal kernel service recompiles changed sources on-the-fly.

This has two limitations:

1. No incremental compilation state. The VM does not maintain a persistent compiler state between reloads. Each reload recompiles affected libraries from scratch rather than producing a minimal delta against the previous compilation. For small apps this is fine; for a Serverpod project with generated code, models, and modules it becomes noticeably slow.
1. Only works when running from source. If the process was started from a pre-compiled `.dill` (`dart app.dill`), the source files are not part of the runtime context and `reloadSources()` has nothing to reload from. This rules out combining compilation-based fast startup with hot reload.

The Frontend Server approach solves both: it maintains incremental compiler state across reloads (each recompile only processes the delta), and the resulting `.dill` is explicitly passed to `reloadSources(rootLibUri: dillUri)`, so it works regardless of how the process was started.

Outside the Dart core team's own tooling (Flutter, `build_runner`, `test_core`, DWDS), no third-party projects currently use `frontend_server_client` for incremental compilation and hot reload.

### Why `--watch` bundles file watching with the Frontend Server

The original design proposed detecting external (IDE-initiated) reloads by tracking `kIsolateReload` event counts against CLI-initiated reload counts, then resetting the FES to recover from state divergence. This was not implemented.

A short-lived `--no-fes` flag was introduced to let users opt out of the FES compilation pipeline when running with an IDE debugger. It was removed once the vm-service proxy gave both modes the same reload-interception story: there was no longer a reason to have two flags for the same decision. `--watch` (default) means file watching plus the Frontend Server for fast incremental compilation; `--no-watch` means `dart run` plus the VM's own kernel service for reloads. Either way, manual reloads from the IDE, TUI, and MCP all flow through the proxy.

This is simpler than the counter-based fallback and avoids the `reloadSources` service-extension conflict described in [dart-lang/sdk#62822](https://github.com/dart-lang/sdk/issues/62822).

### Why no custom CLI-to-server protocol

Two communication channels are already available without introducing any custom protocol:

- Reload: The CLI connects to the subprocess's VM service (exposed via `--enable-vm-service`) and calls `reloadSources()`. This is a standard Dart VM service protocol call over WebSocket.
- Static change notification: The CLI calls the `ext.relic.notifyStaticChange` VM service extension to signal that static files (templates, CSS, images) have changed.
- Shutdown: The server already listens for `SIGINT`/`SIGTERM` and performs graceful shutdown. The CLI simply sends `SIGTERM` to the subprocess.

### Why short polling over SSE/WebSocket for browser refresh

SSE connections are persistent HTTP/1.1 connections. Browsers limit concurrent connections per origin to ~6. Each page navigation opens a new `EventSource`, and with bfcache (back-forward cache), old pages may keep their connections alive. Navigate through 6 pages and the connection limit is exhausted. This is a known issue with other Dart web frameworks using SSE for dev reload.

Short polling avoids this entirely: each interaction is a quick request-response with no held connections. The 500ms latency is negligible for development tooling.

### `ServerProcess` abstraction

The CLI manages the server subprocess through a `ServerProcess` class that encapsulates the full lifecycle: spawning (from `.dill` or `dart run`), output streaming, graceful shutdown (SIGTERM with 5s timeout, SIGKILL fallback), and VM service connection.

Key details:
- Only forwards `SIGTERM` to the child (not `SIGINT`) because the OS terminal delivers `SIGINT` to both parent and child automatically.
- VM service URI is read from the `--write-service-info` file with polling and retries (5 attempts, 200ms delay), rather than parsing stderr.
- Exposes a unified `reload(String? dillPath)`: a non-null path passes `rootLibUri` to `vmService.reloadSources` for FES-driven reload (`--watch`); `null` omits it so the VM's own kernel service recompiles changed sources (`--no-watch`). The vm-service proxy's interceptor invokes it in both cases.
- Exposes `notifyStaticChange()` for triggering browser refresh and template reload via the `ext.relic.notifyStaticChange` VM service extension.

The `StartCommand` orchestrates file watching, code generation, and compilation, but delegates all subprocess and VM service interaction to `ServerProcess`.

### Why `Process.start` instead of the `execute()` helper

The existing `RunCommand` uses `cli_tools`' `execute()` helper, which runs a shell command (`bash -c`) and returns only the exit code. `StartCommand` needs the raw `Process` object because:

- VM service interaction requires the process to be long-lived with a connected WebSocket.
- Sending targeted signals (`SIGTERM` for graceful restart, `SIGKILL` as fallback).
- Holding a long-lived reference to the process across multiple reload cycles.

### Vendoring `frontend_server_client`

The upstream `frontend_server_client` package uses `Platform.resolvedExecutable` to locate the Dart binary. This breaks when the CLI is distributed as an AOT-compiled executable (the resolved executable is the CLI itself, not the Dart VM). A vendored version at `lib/src/vendored/frontend_server_client.dart` accepts an explicit SDK root path instead (while we wait for [dart-lang#2767](https://github.com/dart-lang/webdev/issues/2767)).

### Docker Compose management

Most Serverpod projects depend on Docker Compose services (Postgres, Redis) defined in a `docker-compose.yaml` in the server directory. Starting these is a manual step that developers often forget, leading to confusing connection errors on startup.

The `--docker` flag (on by default, negatable as `--no-docker`) automates this:

1. Detection: Check if `docker-compose.yaml` exists in the server directory. If not, skip silently - the project doesn't use Docker.
1. Already running: Run `docker compose ps --status running -q`. If stdout is non-empty, containers are already running - skip. This avoids interfering with containers the developer started manually or from a previous session.
1. Docker not available: If `docker compose ps` exits with a non-zero code, Docker itself isn't running. Log a warning and continue - the server will fail later with a clear connection error.
1. Start: Run `docker compose up -d` to start containers in detached mode.
1. Cleanup: On exit, run `docker compose stop` (not `down`) to stop the containers while preserving volumes and data. Only stop if the CLI started them - if they were already running, leave them alone.

Using `stop` instead of `down` is intentional: `down` removes containers, networks, and optionally volumes, which would destroy database state between runs. `stop` just halts the containers so they can be quickly restarted.

### Dev-mode detection and static change counter

The server needs to know it is running in a development context. Relic provides this through its `developerTools`:

- `isDevMode`: `true` when the VM service is available (i.e., `_HotReloader` successfully connected and registered). This is the case when started by `serverpod start --watch` or from an IDE debugger. In production, the VM service is not enabled, so this is `false`.
- `staticChangeCount`: Incremented when the CLI calls `ext.relic.notifyStaticChange` via the VM service extension. Serverpod's `/__dev/version` endpoint returns this value, and the dev middleware checks it to trigger template reloads.

This avoids Serverpod independently probing the VM service or maintaining its own event listener - Relic already has the connection and the events.

## Package Changes

### `serverpod_cli`

- New `StartCommand` in `lib/src/commands/start.dart`.
- New `FileWatcher` for unified file monitoring (categorizes dart, model, static, and `package_config.json` changes).
- New `KernelCompiler` wrapping vendored `frontend_server_client` for incremental compilation.
- New `ServerProcess` manager for subprocess lifecycle (spawn, signal, VM service connection, reload, static change notification).
- New `WatchSession` for orchestrating the reload cycle (generation, compilation, reload).
- Vendored `frontend_server_client` at `lib/src/vendored/frontend_server_client.dart`.
- Shared `createAnalyzers`, `updateAnalyzers`, `performGenerate`, `watchPathsFromConfig` in `generator.dart` (used by both `serverpod generate --watch` and `serverpod start --watch`).

### `relic`

- Expose `developerTools.isDevMode` and `developerTools.staticChangeCount` on `RelicApp`.
- Register `ext.relic.notifyStaticChange` VM service extension for CLI-to-server static change notification.

### `serverpod`

- Modify `Server.injectIn` to re-initialize endpoints on hot reload replay.
- Add dev-mode middleware for `/__dev/version` endpoint, HTML script injection, and template reloading, using Relic's `developerTools.staticChangeCount` and `isDevMode`.

## Resolved Questions

1. **Should `serverpod start` without `--watch` compile to `.dill`?** No. `--no-watch` uses `dart run bin/main.dart` so the VM's own kernel service is available for manual reloads via the proxy. Compilation is only used in watch mode where the FES persists for incremental recompiles.

2. **What about `serverpod generate --watch`?** Kept as a lightweight alternative. Both `serverpod generate --watch` and `serverpod start --watch` share the same underlying generator code (`createAnalyzers`, `updateAnalyzers`, `performGenerate`). `generate --watch` is useful for users who run the server separately (e.g., from an IDE debugger).

## Open Questions

1. Multi-server setups. Should `serverpod start` support starting multiple processes? Or is that left to the user?
