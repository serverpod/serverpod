# Design: The Serverpod runner

`serverpod start` runs the terminal UI, the MCP server, the file watcher, the
Frontend Server, and the pod in a single process. The terminal UI binds a pty,
an agent working in a worktree has none. It can use the `--no-tui` flag, but 
then a human can no longer participate.

This document separates the long-lived part of `serverpod start` from the
terminal UI, so a UI can be attached later, attached several times, or not at
all. 

>[!NOTE]
>[`mcp_server.md`](mcp_server.md) already calls the `serverpod start`
process the *runner*, and this document narrows the term to exclude the UI.

## Current state

`StartCommand` (`tools/serverpod_cli/lib/src/commands/start.dart`) owns Docker
Compose, code generation, the `KernelCompiler` (and its resident Frontend
Server), the `ServerProcess`, the `FileWatcher`, the `WatchSession` reload loop,
Flutter app spawning, the MCP socket, the vm-service proxy, and the nocterm
terminal UI. 

Two consumers already attach from outside without a terminal.

- An IDE, over the vm-service proxy. The CLI mounts a proxy in front of the
  pod's VM service, publishes the proxy URI to `vm-service-info.json`, and the
  IDE connects over TCP for debugging.
- An agent, over the Unix socket at
  `<serverDir>/.dart_tool/serverpod/mcp.sock`, where `serverDir` is the server
  package, the one that depends on `serverpod`. It connects through the
  `serverpod mcp-server` bridge. [`mcp_server.md`](mcp_server.md) describes its reconnect
  and lifetime semantics.

The terminal UI is the only consumer that must run inside the runner process.

>[!NOTE]
>[`hot_reload.md`](hot_reload.md) describes the reload pipeline and
[`tui.md`](tui.md) the UI.


## Goals

- Start the development stack without a terminal, and attach a UI later.
- Make `serverpod start` idempotent, so a caller need not know whether the stack
  is already running in this worktree.
- Run several runners concurrently in different worktrees of the same codebase.

Out of scope is sharing a database or Docker Compose stack between worktrees.
Each worktree provides its own, through embedded Postgres or its own compose
project. The reload pipeline, the logging protocol, and the visual design of the
UI are unchanged.

Fixed ports in `config/development.yaml` collide when several worktrees run at
once, so the concurrency goal depends on [Address
publication](#address-publication). That change is largely independent of the
split, but it lands after it, since the manifest it publishes into has to exist
first.


## Overview

Three commands now augment `start`, which keeps its name and its meaning, but
become idempotent.

```shell
serverpod start   # Ensure the runner is up, then attach a UI
serverpod attach  # Attach to an already-running runner
serverpod stop    # Shut the runner down
serverpod status  # Print the runner's state and addresses
```

`serverpod start` now spawns a runner if none is running (for the server package),
and otherwise goes straight to the attach step. The stack is up when the command
returns zero.

The runner runs detached in a session of its own. It records its sockets,
addresses, and effective configuration in `.dart_tool/serverpod/runner.json`,
holds an exclusive lock on `.dart_tool/serverpod/runner.lock`, and writes its
output to `.dart_tool/serverpod/runner.log`. Clients find it through the
manifest and speak json-rpc (dart vm-service, mcp, or bespoke tui protocol) with
the runner.

### Attaching

`serverpod start` attaches by default. `--no-attach` brings the runner up, prints
its address, and returns, which is the path an agent takes.

An invocation that spawns the runner attaches to it immediately rather than
waiting for it to come up. The runner binds its attach socket as soon as it
holds the lock and publishes its manifest there and then - before the
existing-server check, port resolution, Docker, generation and the first
compile - so the client resolves the runner, attaches, and renders that work as
it happens instead of leaving the terminal blank for the minutes a cold start
takes. A startup that fails is then watched rather than reported after a
timeout: the runner announces the stop with the code it is leaving with, and
takes the manifest back down. Published any later, a start that aborts - a port
held by something else, Docker refusing - has nothing to attach to, and the
caller learns only that no runner came up in time, with the reason in the
runner's log file. Until there is a stack, the socket serves the log
history alone: commands answer that the runner is still starting, except
`stop`, which has to work on a start that is going nowhere. `--no-attach` still
waits, since it has nothing to render: the manifest carries the runner's
`stage`, and the command returns once it leaves `starting`. A runner whose
stack is up returns zero; one that aborted returns the runner's own exit code
with the tail of its log, and one that is up but degraded - the project does
not build, so no server runs - returns non-zero and says the runner is still
there to recover from.

`--tui` / `--no-tui` keeps its current meaning and selects the renderer. The
terminal UI is used when `--tui` holds and `stdout.hasTerminal`, and a
plain-text log stream in the foreground otherwise. `serverpod attach` takes the
same pair.

| Invocation | Result |
|------------|--------|
| `serverpod start` | Runner up, terminal UI if a pty is available |
| `serverpod start --no-tui` | Runner up, plain log stream in the foreground |
| `serverpod start --no-attach` | Runner up, address printed, command returns |
| `serverpod attach` | Terminal UI if a pty is available |
| `serverpod attach --no-tui` | Plain log stream in the foreground |

`--no-tui` remains what CI, piped output, and `docker logs`-style workflows use.
It has no effect together with `--no-attach`, since nothing renders, and is
ignored there.

### Lifetime

Detaching a UI does not stop the runner, whoever started it. The stack is
stopped with `serverpod stop`, or with `⇧+Q` in the UI, next to the `Q` that
only detaches.

The runner stopping ends the session for every attached UI. It announces the
stop with the exit code it is leaving with, and a UI leaves with that code,
printing the tail of the log once the alternate screen is gone. A connection
that drops without the announcement is a crash or a kill, and the UI keeps
reconnecting, so a runner restarted from another terminal is picked back up.

>[!NOTE]
>The rejected alternative is to shut down on detach when the detaching invocation
spawned the runner. That keeps Ctrl+C closer to its current behaviour, but the
same key then stops the server or does not, depending on how the session began.

## Architecture

### Surfaces

| Consumer | Transport | Entry point | Protocol |
|----------|-----------|-------------|----------|
| IDE | TCP | `vm-service-info.json` | VM service |
| Agent | Unix socket | `serverpod mcp-server` | MCP over JSON-RPC 2.0 |
| Human / UI | Unix socket | `serverpod attach` | Runner protocol (below) |
| Pod clients | TCP | runner manifest | HTTP |

`serverpod attach` follows `serverpod mcp-server`. It resolves the server
directory, connects to a socket, renders what arrives, reconnects when the
runner restarts, and holds no orchestration logic.

### Runner manifest and discovery

Discovery artifacts are consolidated into
`<serverDir>/.dart_tool/serverpod/runner.json`, written as soon as the runner
holds its lock and socket, rewritten as its `stage` moves and its addresses
change, and removed when it shuts down. A start that aborts leaves the file
behind at stage `stopping` with an `exitCode` instead: the caller that spawned
the runner is polling for the manifest, and one that came and went between two
polls would read as a runner that never came up. The next runner replaces it.

```json
{
  "protocolVersion": 1,
  "cliVersion": "4.0.0",
  "pid": 48213,
  "stage": "running",
  "sockets": {
    "tui": ".dart_tool/serverpod/tui.sock",
    "mcp": ".dart_tool/serverpod/mcp.sock"
  },
  "vmService": {
    "proxy": "http://127.0.0.1:51234/abc=/",
    "pod": "http://127.0.0.1:51235/def=/"
  },
  "servers": {
    "api": "http://localhost:8080",
    "insights": "http://localhost:8081",
    "web": "http://localhost:8082"
  },
  "docker": { "startedByRunner": true, "project": "myproject" },
  "config": { "watch": true, "flutter": true, "serverArgs": ["--mode", "production"] }
}
```

The manifest is read by

- `status`, which prints it
- `attach` and `start`, to decide whether a runner exists
- pod clients, to find the addresses

A crashed runner leaves the file behind, so liveness is decided by connecting to
the socket, and a manifest whose socket refuses the connection is replaced.
`_detectExistingInstance` in `start.dart` already runs that probe with
`connectUnixSocket` before any bind, documented in
[`mcp_server.md`](mcp_server.md) under "One runner per project". It moves to the
manifest resolution path.

New here is an exclusive lock, taken on `.dart_tool/serverpod/runner.lock` in
the server package. Probing is a check followed by a use, so two runners starting
at the same moment can both probe, find nothing, and bind, and `bindUnixSocket`
unlinks the stale socket file, so the second displaces the first. The resident
Frontend Server writes `.dart_tool/serverpod/server.dill`, and Docker Compose
teardown is conditional on the runner having started the services, so one runner
per server package has to be enforced rather than left to a fixed socket path.
The runner fails immediately if it cannot take the lock.

The lock is an advisory lock on an open file descriptor, through
`RandomAccessFile.lock`. The kernel releases it when the process dies, so a
crashed runner leaves nothing to clean up, unlike the manifest and the socket
file.

A detached runner survives `dart pub global activate serverpod_cli`, so a new
client can meet an old runner. A client refuses to attach when `protocolVersion`
differs and prints the stop-and-restart instruction. A differing `cliVersion` at
equal `protocolVersion` is a warning.

Socket paths stay in `.dart_tool/`. `bindUnixSocket` and `connectUnixSocket`
enforce the `sockaddr_un.sun_path` limit through `requireUnixSocketPathFits`,
and `shortestPath` picks the shorter of the relative and absolute forms. From
inside the project the relative form is about 30 bytes, under the 104-byte macOS
limit even in a nested worktree. A consumer whose working directory is far from
the project gets no benefit from the relative form, and a nested worktree can
push the absolute path past the limit. That applies to the MCP bridge, which the
agent client launches with an arbitrary cwd and a `--server-dir` argument. Such
consumers resolve the path with `shortestPathRelativeTo` against `serverDir`, as
`serverpod_embedded_postgres` does for PostgreSQL's socket directory.

### Runner API

MCP and the UI keep separate sockets. Agent configurations reach `mcp.sock`
through the bridge, and MCP's request/response vocabulary of tools and resources
does not fit the continuous event stream the UI consumes.

The capabilities behind the two sockets are shared. The MCP tool and resource
declarations already are, through `runnerStaticTools` and
`runnerStaticResources` in `lib/src/mcp/runner_surface.dart`. The
implementations are not. They exist as the callbacks passed to
`McpSocketServer.connect(...)` in `lib/src/commands/start/mcp_socket.dart` -
`onHotReload`, `onHotRestart`, `onApplyMigration`, `onCreateMigration`,
`onCreateRepairMigration`, `getLogHistory`, `getFlutterAppIds`,
`onSpawnFlutterApp`, `getVmServiceUri`, and others. A parameter list is not a
type, so adding a capability today means editing

- `runner_surface.dart`, for the declaration
- the `ServerpodMcpServer` field and its registration
- the `McpSocketServer` field, constructor parameter, and copy-through

The two surfaces have drifted.

- MCP migration calls return `CreateMigrationMcpResult`. The UI's equivalents
  return nothing and write their outcome to the log.
- Log history crosses the boundary as `List<Object> Function()`, untyped,
  carrying whatever the UI state holds.
- `FlutterAppManager.launch`, `.stop`, and `.restart` take an `appId`, but the
  UI reaches them through `holder.onLaunchApp(int index)`.

The callbacks become a type, implemented once over the watch session and
projected by both socket servers.

```dart
/// Everything the runner can do or report, independent of who is asking.
abstract interface class RunnerApi {
  /// Bounded history and in-flight operations, for a client that has just
  /// connected. Serialized from `StartLogHistory`.
  RunnerSnapshot snapshot();

  /// Everything after the snapshot. Log events, operation start and end,
  /// startup stage transitions.
  Stream<RunnerEvent> get events;

  Future<void> hotReload();
  Future<void> hotRestart();
  Future<void> stop();

  /// `force` is a parameter, never a prompt. A call that would require
  /// confirmation the caller did not give fails and says so.
  Future<MigrationResult> createMigration({String? tag, bool force});
  Future<MigrationResult> createRepairMigration({
    String? tag,
    bool force,
    String? targetVersion,
  });
  Future<MigrationResult> applyMigrations();

  /// Forwards to `FlutterAppManager`, which is already id-keyed. Tab indices
  /// belong to the UI, not to the runner.
  List<FlutterAppConfig> get flutterApps;
  Future<void> launchFlutterApp(String appId);
  Future<void> stopFlutterApp(String appId);
  Future<void> restartFlutterApp(String appId);

  /// Addresses and process state, as written to `runner.json`. The stream
  /// replaces the ad-hoc `Stream<void>? vmServiceUriChanges` callback, since
  /// the vm-service URI is not the only address that can change.
  RunnerManifest get manifest;
  Stream<RunnerManifest> get manifestChanges;
}
```

`MigrationResult` is `CreateMigrationMcpResult` renamed and moved out of
`mcp_server.dart`, where it landed because MCP needed it first.

Reload keeps its single point of convergence. Per
[`hot_reload.md`](hot_reload.md), the UI's reload button, MCP's `hot_reload`
tool, and IDE `reloadSources` calls through the proxy reach one callback. Attach
reaches the same one.

Both sockets accept several concurrent clients. A developer on the UI and an
agent on MCP can issue commands at the same time today, so a one-connection
limit buys no exclusivity and only prevents a second UI. Conflicting commands,
such as overlapping `applyMigrations` calls, are serialized on `RunnerApi`.

### Address publication

The pod's listeners stay on TCP. Browsers cannot connect to a Unix socket, and
the auto-refresh script from [`hot_reload.md`](hot_reload.md) polls
`GET /__dev/version` over an ordinary HTTP origin.

The runner binds the ports from `config/development.yaml`, falls back to
ephemeral ports when they are taken, and publishes the resolved addresses in the
manifest. Unconditional ephemeral ports would also avoid collisions, at the cost
of an address that changes on every restart. The three listeners fall back as a
block rather than independently.

Fallback applies when another Serverpod runner holds the port, which the runner
recognizes by the manifest in the owning directory. A port held by anything else
is an error.

Two consequences elsewhere.

- `ServerConfig` in `serverpod_shared/lib/src/config.dart` distinguishes the
  bind `port` from the advertised `publicHost`, `publicPort`, and
  `publicScheme`, and the server builds client-facing URLs from the latter.
  `publicPort` has to be derived from the resolved bind port, or the server
  advertises 8080 while listening elsewhere.
- Flutter apps the runner launches receive the resolved URL through
  `--dart-define`. Apps started by hand, browser tabs, and `curl` read it from
  the manifest, which `serverpod status` prints.

### Attach protocol

JSON-RPC 2.0 over a Unix socket, line-delimited, reusing the framing in
`lib/src/mcp/socket_directory.dart`. `json_rpc2` is already a dependency for MCP
and is required for the VM service. Serverpod's internal RPC engine would first
need Unix socket support, and adopting it would not remove the `json_rpc2`
dependency.

The protocol has three parts, of which only the snapshot is new.

A *snapshot* is sent on connect, so a UI attaching to a runner that has been up
for some time renders the full picture immediately. It carries

- the bounded log history
- the operations in progress, with start timestamps and sub-entries
- the per-app Flutter buffers
- the current stage of startup

`StartLogHistory` in `lib/src/commands/start/log_history.dart` holds and bounds
all of this through `maxServerEntries` and `maxFlutterLines`. The snapshot is a
serialization of it and inherits those bounds.

*Events* follow the snapshot, and need no new vocabulary. The runner receives
framework and session events over `ext.serverpod.log` per
[`logging.md`](logging.md), combines them with log calls originating in the CLI,
and feeds `StartLogHistory`. Attach forwards the same events, and `RunnerEvent`
names the union of the existing `LogEntry` and `FlutterLogEvent` types. Clients
compute elapsed durations from the start timestamps, so spinner animation
generates no traffic.

*Commands* are reload, restart, create and apply migrations, launch a Flutter
app, and stop. They project `RunnerApi`.

The runner does not prompt. Interactive decisions in the UI, such as confirming
a migration that has warnings, become command parameters. A command missing a
required answer fails and reports why, leaving the client to decide whether to
ask. Every command stays answerable with no client attached.

### Division of state

| Held by the runner | Held by the client |
|--------------------|--------------------|
| Log history, tracked operations | Scroll position |
| Startup stage | Selected tab |
| Flutter app registry, per-app buffers | Expanded or collapsed operations |
| Reload and restart counters | Key bindings |

Startup stage is runner-side so that a client attaching during a slow first
compilation sees progress rather than an empty screen. Scroll position is
client-side so that two clients scroll independently.

### Process groups and signals

The pod, the Frontend Server, and any Flutter apps are children of the CLI
process, in the terminal's process group. [`hot_reload.md`](hot_reload.md) notes
that the operating system delivers SIGINT to parent and child alike, so a runner
spawned in that process group would still die on Ctrl+C in the attached
terminal.

The runner is therefore spawned detached, in a session of its own, with standard
output and error redirected to `.dart_tool/serverpod/runner.log`. The in-memory
ring buffer is bounded and cannot record a run nobody watched. The file is
size-capped and rotated, since the runner is expected to stay up for days.

- In the runner, SIGINT and SIGTERM trigger a graceful shutdown, as the headless
  path does today.
- In an attached client, SIGINT detaches and cannot reach the pod.
- Ordinary shutdown goes over the protocol, from `serverpod stop`.

### Flutter apps

`--flutter` currently launches the apps marked `auto_launch: true` when the
stack starts. Auto-launch moves to UI attachment, so the apps launch when a UI
first attaches in a runner lifetime. A later attach does not relaunch them, so
an app the developer stopped stays stopped across a detach.

Suppressing auto-launch for `--no-attach` alone would be the smaller change,
but `--flutter` would then mean different things depending on which invocation
spawned the runner, and a stack started by an agent would never launch apps for
the developer who attaches to it later.

## Design decisions

### Why `start` remains composite rather than becoming an alias

`start` as "ensure the stack is up, then attach" gives callers idempotency
without changing what developers type. It can then be invoked with options that
disagree with the runner already running, such as `--no-docker` against a runner
that started Docker, or different arguments after `--`.

The manifest records the runner's effective configuration. On disagreement,
`start` fails, names the differing options, and gives the way to replace the
running instance. Attaching anyway with a warning would leave a caller that
reads only the exit status believing it got what it asked for.

The check covers `--watch`, `--docker`, and the server arguments after `--`,
which the runner cannot change after startup. Options describing the client
rather than the stack, `--attach` and `--tui`, are excluded.

### Why the split is useful beyond multi-agent workflows

The integration pattern in [`tui.md`](tui.md) exists because the UI shares a
process with the backend. nocterm's `runApp()` occupies the main isolate, which
forces

- a `Completer` to hand the UI state back to the code that drives it
- a logger that buffers messages emitted before the UI exists and flushes them
  once it does
- careful ordering to replace the UI-backed logger before printing a crash,
  whose output would otherwise land on an alternate screen that has already been
  torn down

None of it is needed once the renderer is a separate process reading a stream.
The split also makes the UI testable without a pty.

## Package changes

### `serverpod_cli`

- `StartCommand` loses the terminal UI and gains idempotency, manifest writing,
  the directory lock, and detached spawning.
- New `AttachCommand`, `StopCommand`, and `StatusCommand`.
- New `--attach` / `--no-attach` flag on `StartCommand`. `--tui` / `--no-tui`
  keeps its current meaning and is accepted by `AttachCommand` too.
- The callbacks passed to `McpSocketServer.connect(...)` extracted into
  `RunnerApi`, shared by both socket servers, which drop their one-client
  restriction.
- `_detectExistingInstance` moves to the manifest resolution path and is joined
  by an exclusive lock on `.dart_tool/serverpod/runner.lock`.
- `StartLogHistory` gains snapshot serialization.
- A new socket server for attach, and the client that renders it.

### `serverpod`

- Resolve the bind ports dynamically when the configured ports are unavailable,
  and derive `publicPort` from the resolved value.

### Repository

- `DART_VERSION` raised to `^3.11.0`, with the checked-in pubspecs regenerated
  from `templates/pubspecs`. `FLUTTER_VERSION` and the floor entries of the CI
  version matrices move to the lowest Flutter release bundling Dart 3.11.
- The `hasUnixSocketSupport()` guard in `mcp-server` is dropped, along with the
  Windows caveat in [`mcp_server.md`](mcp_server.md).

## Resolved questions

### Unix sockets on Windows

Unix sockets on Windows require Dart 3.11, while `serverpod` and `serverpod_cli`
are constrained to `^3.10.3`. The constraint is raised to `^3.11.0` for 4.0.

The split is therefore unconditional. The alternative, version-gating the
concurrency story on Windows, would mean keeping the current in-process path
alive as a second implementation of the same watch loop for as long as the floor
stayed at 3.10, and every subsequent change to the runner would have to land in
both. Raising the floor also lets `serverpod mcp-server`, which fails on Windows
today, work there.

### Auto-launching Flutter apps

Apps marked `auto_launch: true` launch on the *first* UI attach in a runner
lifetime. Detaching and attaching again does not relaunch them.

An attach is a client asking for the snapshot, not a client opening the socket.
Liveness is decided by connecting to the attach socket, so `status`, `stop`, a
second `start` and another worktree's port resolution all connect and hang up
without saying anything; counting those as attaches would launch Flutter apps
for nobody, including on the `--no-attach` path an agent takes.

So the first attach of a session is distinguished from subsequent ones. Relaunch
on every attach would restart apps the developer had deliberately stopped, and
would make an attach/detach cycle an expensive operation for no stated gain. The
developer who never detaches sees no change from today: the first attach is the
one that follows `serverpod start`.
