# Design: Hot Reload and `serverpod start`

This document proposes adding a `serverpod start` command with file watching, incremental compilation, and hot reload support for Serverpod server development.

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

`serverpod generate --watch` (`generator_continuous.dart`) watches `lib/` for changes to model files (`.spy.yaml`) and endpoint files, then re-runs code generation with a 500ms debounce. It does not compile or reload the server.

`HotReloader` (`packages/serverpod/lib/src/hot_reload/hot_reload.dart`) connects to the Dart VM service from within the server process and calls `vmService.reloadSources()`. It is exposed via the Insights endpoint but not integrated into any CLI workflow.

Relic's hot reload support (`RelicApp._HotReloader`) listens for `kIsolateReload` VM events and automatically replays all registered `RouterInjectable`s (including `Server`) against a fresh `RelicRouter`, then re-mounts the handler. This means Relic-level routes, middleware, and handler closures are refreshed on hot reload without any additional work.

Signal-based shutdown: `Serverpod` listens for `SIGINT` and `SIGTERM` to trigger graceful shutdown (drain connections, close database pools, etc.).

### Related Issues

- [#4773](https://github.com/serverpod/serverpod/issues/4773): Allow running the server with hot reload/restart support
- [#1748](https://github.com/serverpod/serverpod/issues/1748): Hot reload support
- [#2403](https://github.com/serverpod/serverpod/issues/2403): Hot reload support

## Proposal

Add a `serverpod start` command that becomes the standard way to run a Serverpod server during development. Without flags, it wraps the server subprocess with code generation and Docker Compose management. With `--watch`, it adds file watching, incremental compilation, and hot reload.

```shell
serverpod start             # Start Docker, generate, compile, run
serverpod start --watch     # Start Docker, generate, compile, run, watch, hot reload
serverpod start --no-docker # Skip Docker, generate, compile, run
```

## Implementation Steps

### Simple `serverpod start` (subprocess wrapper)

The simplest useful version. The CLI:

1. Ensures Docker Compose services are running (see [Docker Compose management](#docker-compose-management)).
1. Runs `serverpod generate` (in-process).
1. Spawns `dart run bin/main.dart` via `Process.start` (see [Why `Process.start`](#why-processstart-instead-of-the-execute-helper)), forwarding any extra arguments (e.g. `--apply-migrations`, `--role`, `--mode`).
1. Forwards the subprocess's stdout/stderr to the terminal.
1. Forwards `SIGINT`/`SIGTERM` to the subprocess, waits for it to exit, then exits with the same code.
1. On exit, stops Docker Compose services if the CLI started them.

This replaces the multi-step manual workflow (`docker compose up -d`, `serverpod generate`, `dart run bin/main.dart`) with a single command.

```shell
serverpod start [-- <server-args>]
serverpod start -- --apply-migrations --mode production
serverpod start --no-docker  # Skip Docker Compose management
```

Arguments after `--` are passed through to the server process.

### Add `--watch` with hot restart

Add a `--watch` flag that watches for file changes and restarts the server. This step introduces the `ServerProcess` abstraction (see [ServerProcess abstraction](#serverprocess-abstraction)) to manage the subprocess lifecycle across restart cycles.

On file change:
1. If a `.spy.yaml` (or endpoint file) changed, run code generation.
1. Send `SIGTERM` to the subprocess, wait for graceful shutdown.
1. Re-spawn the server process.

This is slow (full cold start on every change) but correct and simple. The file watcher uses the `watcher` package with a debounce window (~500ms) to batch rapid changes.

The watcher monitors:
- `lib/**/*.dart` - application code (endpoints can live many places)
- `lib/**/*.spy.yaml`, `lib/**/*.spy`, `lib/**/*.spy.yml` - model files
- Shared model directories (from `config/generator.yaml`)

It ignores:
- The generated directory (`lib/src/generated/`)
- Hidden directories (`.dart_tool/`, etc.)

### Incremental compilation

Replace `dart bin/main.dart` with compilation to a `.dill` kernel file, then `dart <path>.dill`.

This step introduces `package:frontend_server_client` (vendored version, see [Design Decisions](#vendoring-frontend_server_client)). The Frontend Server runs as a persistent resident process:

- First run: `compile bin/main.dart` produces a `.dill` file.
- On file change: `recompile bin/main.dart <changed-files>` produces an incremental `.dill` delta. This is significantly faster than a full compile.
- On `package_config.json` change: Restart the Frontend Server process entirely (it reads package config only at startup), then do a full compile. This file changes when dependencies are added/removed in `pubspec.yaml` and `dart pub get` is run, or when transitive dependency versions change due to upgrades/downgrades.

The server subprocess is still killed and re-spawned (hot restart), but with much faster turnaround because recompilation is incremental.

### Hot reload via VM service

Replace kill-and-respawn with in-process hot reload. The server subprocess is started with `--enable-vm-service=0` (ephemeral port). The CLI:

1. Parses the VM service URI from the subprocess's stderr (Dart prints `The Dart VM service is listening on <uri>`).
1. Connects to the VM service via WebSocket.
1. After successful incremental compilation, calls `vmService.reloadSources()` on the main isolate.
1. Relic's `_HotReloader` automatically picks up the `kIsolateReload` event and refreshes routes and endpoints (see [Endpoint refresh](#endpoint-refresh-on-hot-reload)).

If `reloadSources()` reports failure (e.g. a change that cannot be hot-reloaded, such as modifying enum values or changing class hierarchy), the CLI logs the failure reason, falls back to hot restart (kill + re-spawn with the already-compiled `.dill`), and notifies the developer.

### Code generation integration

Unify file watching so `.spy.yaml` changes cascade correctly through generation, compilation, and reload.

```
.spy.yaml change --> code generation --> produces .dart files ---+
                                                                 +--> incremental compile --> hot reload
.dart file change -----------------------------------------------+
```

- Single watcher, single gate. One file watcher feeds both the code generator and the compiler. Ensure only one compile/reload cycle runs at a time. 
- Changes that arrive during compilation are buffered and merged into the next cycle.
- A `.spy.yaml` change triggers code generation, which writes `.dart` files, which the watcher picks up.
- Reuse existing logic. The `serverpod start` command reuses the `performGenerate` function and its analyzers directly, while owning the file watcher itself.

### Browser auto-refresh (web server)

For projects serving web pages, automatically refresh the browser after a successful hot reload.

A dev-only middleware injects a small script into HTML responses. The script polls a lightweight endpoint that returns a monotonically increasing version counter. When the version changes, the page reloads.

Server-side: A `GET /__dev/version` endpoint returns the current reload generation as a plain text number. The reload counter and dev-mode flag live in Relic (see [Dev-mode detection and reload counter](#dev-mode-detection-and-reload-counter)). The endpoint and middleware are only active in dev mode.

Client-side (injected into HTML responses):

```javascript
setInterval(async () => {
  try {
    const r = await fetch('/__dev/version');
    const v = await r.text();
    if (window.__v && v !== window.__v) location.reload();
    window.__v = v;
  } catch (_) {}
}, 500);
```

### IDE integration via VM service registration

Allow IDE debugging (breakpoints, step ping) and CLI hot reload to coexist without conflicts.

The CLI registers a custom `reloadSources` service extension on the VM service. When the IDE sends a reload request, it is routed through the CLI's incremental compilation pipeline rather than the VM's built-in source-based reload:

1. CLI starts server with `--enable-vm-service`, connects to VM service.
1. CLI registers a custom `reloadSources` service extension.
1. IDE attaches for debugging (breakpoints, stepping - all normal).
1. User presses IDE hot reload button -> IDE calls `reloadSources` -> routed to CLI's handler.
1. CLI does incremental compile via FES -> produces `.dill` -> calls the real `reloadSources` with the `.dill`.
1. Returns result to the IDE.

As a safety net for clients that don't respect registered service handlers, the CLI listens for `kIsolateReload` events. If it receives a reload it didn't trigger, it calls `reset` on the FES and performs a full recompile on the next file change. See [IDE coexistence and compiler state](#ide-coexistence-and-compiler-state) for details.

## Design Decisions

### Why incremental compilation over bare `vmService.reloadSources()`

Community hot reload packages for Dart ([hotreloader](https://pub.dev/packages/hotreloader), [shelf_hotreload](https://pub.dev/packages/shelf_hotreload), [Dart Frog](https://pub.dev/packages/dart_frog)) take a simpler approach: run with `--enable-vm-service`, watch files, call `vmService.reloadSources()` with no arguments. The VM's internal kernel service recompiles changed sources on-the-fly.

This has two limitations:

1. No incremental compilation state. The VM does not maintain a persistent compiler state between reloads. Each reload recompiles affected libraries from scratch rather than producing a minimal delta against the previous compilation. For small apps this is fine; for a Serverpod project with generated code, models, and modules it becomes noticeably slow.
1. Only works when running from source. If the process was started from a pre-compiled `.dill` (`dart app.dill`), the source files are not part of the runtime context and `reloadSources()` has nothing to reload from. This rules out combining compilation-based fast startup with hot reload.

The Frontend Server approach solves both: it maintains incremental compiler state across reloads (each recompile only processes the delta), and the resulting `.dill` is explicitly passed to `reloadSources(rootLibUri: dillUri)`, so it works regardless of how the process was started.

Outside the Dart core team's own tooling (Flutter, `build_runner`, `test_core`, DWDS), no third-party projects currently use `frontend_server_client` for incremental compilation and hot reload.

### Why no custom CLI-to-server protocol

Two communication channels are already available without introducing any custom protocol:

- Reload: The CLI connects to the subprocess's VM service (exposed via `--enable-vm-service`) and calls `reloadSources()`. This is a standard Dart VM service protocol call over WebSocket.
- Shutdown: The server already listens for `SIGINT`/`SIGTERM` and performs graceful shutdown. The CLI simply forwards signals to the subprocess.

A custom protocol (whether `json_rpc_2`, Serverpod's own protocol, or something else) could be introduced later if richer CLI-to-server communication is needed for future features like streaming diagnostic info back to the CLI.

### Why short polling over SSE/WebSocket for browser refresh

SSE connections are persistent HTTP/1.1 connections. Browsers limit concurrent connections per origin to ~6. Each page navigation opens a new `EventSource`, and with bfcache (back-forward cache), old pages may keep their connections alive. Navigate through 6 pages and the connection limit is exhausted. This is a known issue with other Dart web frameworks using SSE for dev reload.

Short polling avoids this entirely: each interaction is a quick request-response with no held connections. The 500ms latency is negligible for development tooling.

### IDE coexistence and compiler state

The Frontend Server (FES) maintains incremental compilation state - it tracks which libraries are at which version and what's been `accept`ed. If an IDE triggers `reloadSources()` independently (e.g., the user presses the IDE's hot reload button), the VM recompiles from source internally. The FES knows nothing about this, and its state diverges from what's actually loaded in the VM. Subsequent incremental compiles may produce incorrect deltas.

This is a fundamental issue: two independent compilers (FES and the VM's internal kernel service) cannot share incremental state. It applies even if the CLI detects the IDE and stops sending its own reload requests - the FES state is still stale.

The solution is to register a custom `reloadSources` service extension so all reload requests route through the CLI's FES. Flutter tools already use this pattern, and the Dart extensions for VS Code and IntelliJ respect registered service handlers. This ensures FES is the single source of truth for compilation.

The fallback for clients that bypass registered services: the CLI listens for `kIsolateReload` events on the VM service. If it receives one it didn't trigger, it calls `reset` on the FES and does a full recompile on the next file change - recovering to a consistent state at the cost of one non-incremental compile cycle.

To detect external reloads, the CLI uses a counter approach. Each successful `reloadSources()` call produces exactly one `kIsolateReload` event. The CLI tracks how many reloads it initiated vs how many events it observed:

```dart
int _initiatedReloads = 0;
int _observedReloads = 0;

// On successful reloadSources() call:
_initiatedReloads++;

// On kIsolateReload event:
_observedReloads++;
if (_observedReloads > _initiatedReloads) {
  // External reload detected - reset FES
}
```

Only successful reloads are counted (failed reloads don't fire the event), and the CLI serializes its own reload operations through the compile lock.

> [!NOTE]
> This is best-effort. Since `kIsolateReload` events carry no correlation ID, an external reload that arrives while a CLI-initiated reload is in flight can be misattributed - the counter catches up one event late, after the FES state has already diverged. In practice this is unlikely, if a stale FES produces a bad delta, the resulting compilation error or reload failure will trigger a full recompile anyway.

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

### `ServerProcess` abstraction

The CLI manages the server subprocess through a `ServerProcess` class that encapsulates the full lifecycle: spawning, signal forwarding, stdout/stderr streaming, stopping, and VM service connection and hot reload. This single object evolves across steps.

The `StartCommand` orchestrates file watching, code generation, and compilation, but delegates all subprocess and VM service interaction to `ServerProcess`.

### Why `Process.start` instead of the `execute()` helper

The existing `RunCommand` uses `cli_tools`' `execute()` helper, which runs a shell command (`bash -c`) and returns only the exit code. `StartCommand` needs the raw `Process` object because later steps require:

- Parsing the VM service URI from the process's stderr stream.
- Sending targeted signals (`SIGTERM` for graceful restart, `SIGKILL` as fallback).
- Holding a long-lived reference to the process across multiple reload cycles.

### Vendoring `frontend_server_client`

The upstream `frontend_server_client` package uses `Platform.resolvedExecutable` to locate the Dart binary. This breaks when the CLI is distributed as an AOT-compiled executable (the resolved executable is the CLI itself, not the Dart VM). A vendored or adapted version that accepts an explicit SDK root path is needed (while we wait for [dart-lang#2767](https://github.com/dart-lang/webdev/issues/2767)).

### Docker Compose management

Most Serverpod projects depend on Docker Compose services (Postgres, Redis) defined in a `docker-compose.yaml` in the server directory. Starting these is a manual step that developers often forget, leading to confusing connection errors on startup.

The `--docker` flag (on by default, negatable as `--no-docker`) automates this:

1. Detection: Check if `docker-compose.yaml` exists in the server directory. If not, skip silently - the project doesn't use Docker.
1. Already running: Run `docker compose ps --status running -q`. If stdout is non-empty, containers are already running - skip. This avoids interfering with containers the developer started manually or from a previous session.
1. Docker not available: If `docker compose ps` exits with a non-zero code, Docker itself isn't running. Log a warning and continue - the server will fail later with a clear connection error.
1. Start: Run `docker compose up -d` to start containers in detached mode.
1. Cleanup: On exit, run `docker compose stop` (not `down`) to stop the containers while preserving volumes and data. Only stop if the CLI started them - if they were already running, leave them alone.

Using `stop` instead of `down` is intentional: `down` removes containers, networks, and optionally volumes, which would destroy database state between runs. `stop` just halts the containers so they can be quickly restarted.

### Dev-mode detection and reload counter

The server needs to know it is running in a development context and how many reloads have occurred. Both belong in Relic, which already connects to the VM service and listens for `kIsolateReload` events via its `_HotReloader`.

Relic can expose:

```dart
// On RelicApp
int get reloadCount => _reloadCount;  // incremented in _reload()
bool get isDevMode => _reloadSubscription != null;
```

- `isDevMode`: `true` when the VM service is available (i.e., `_HotReloader` successfully connected and registered). This is the case when started by `serverpod start --watch` or from an IDE debugger. In production, the VM service is not enabled, so this is `false`.
- `reloadCount`: Incremented each time `_reload()` fires. Serverpod's `/__dev/version` endpoint simply returns `_app.reloadCount`.

This avoids Serverpod independently probing the VM service or maintaining its own event listener - Relic already has the connection and the events.

## Package Changes

### `serverpod_cli`

- New `StartCommand` in `lib/src/commands/start.dart`.
- New `FileWatcher` for unified file monitoring.
- New `KernelCompiler` wrapping `frontend_server_client` for incremental compilation.
- New `ServerProcess` manager for subprocess lifecycle (spawn, signal, VM service connection).
- Vendored or adapted `frontend_server_client` (for AOT-compiled CLI compatibility).

### `relic`

- Expose `reloadCount` and `isDevMode` on `RelicApp`.

### `serverpod`

- Modify `Server.injectIn` to re-initialize endpoints on hot reload replay.
- Add dev-mode middleware for `/__dev/version` endpoint and HTML script injection, using Relic's `reloadCount` and `isDevMode` (added to support this).
- The existing `HotReloader` class can be simplified or removed - reload is now triggered externally by the CLI via VM service. Relic handles the rest.

## Open Questions

1. Should `serverpod start` without `--watch` also compile to `.dill`? This would make cold start faster for repeated runs.

1. What about `serverpod generate --watch`? Once `serverpod start --watch` subsumes its functionality, should it be deprecated? Or kept as a lightweight alternative for users who run the server separately (e.g., from an IDE debugger)?

1. Multi-server setups. Should `serverpod start` support starting multiple processes? Or is that left to the user?
