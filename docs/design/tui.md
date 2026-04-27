# Design: Terminal UI for `serverpod start --watch`

This document describes the nocterm-based terminal UI for the `serverpod start` command, replacing plain text logging with an interactive dashboard.

> **Note:** This document is the original design proposal. The implementation
> has since landed and the logging architecture has been generalised - see
> [`logging.md`](logging.md) for the current `LogWriter`/`LogScope` types
> and the live VM-service event protocol (`scope_start` / `scope_end` / `log`).
> References below to `TuiLogger`, `IsolatedLogger`, `TextStdOutLogWriter`,
> `JsonStdOutLogWriter`, and the `session_start` / `session_log` / `session_query`
> / `session_end` event names are historical; treat the layout, key bindings,
> and component breakdown as authoritative and the wire protocol details as
> superseded.

## Current State

`serverpod start --watch` outputs plain text log messages to stdout via the `cli_tools` `Logger` singleton. Server process stdout/stderr is forwarded directly to the terminal. There is no interactivity - the only control is Ctrl+C to quit.

The server logs to stdout via `TextStdOutLogWriter` or `JsonStdOutLogWriter` (configurable via `config.sessionLogs.consoleLogFormat`). Lifecycle messages (startup, shutdown) are written directly to stdout via `_writeLifecycleMessage()`. There are no VM service extensions registered by the server for log streaming.

## Overview

The TUI replaces the scrolling text output with an interactive terminal dashboard using [nocterm](https://github.com/knopp/nocterm), a Flutter-like TUI framework for Dart. Components are built directly in `serverpod_cli`, following patterns from [nocterm_components](https://github.com/serverpod/nocterm_components) as a reference.

```shell
serverpod start --watch                 # TUI (if TTY available and VM service enabled)
serverpod start                         # TUI (same conditions)
serverpod start --watch --no-tui        # Plain text mode (forced)
serverpod start --watch --no-fes        # Plain text mode (no VM service, TUI not possible)
```

The TUI requires both an interactive terminal (`stdout.hasTerminal`) and the VM service to be enabled (i.e., not `--no-fes`). Without the VM service, the structured logging channel from the server is unavailable, so the TUI falls back to headless mode.

### TUI layout

**Loading screen** - shown during startup (Docker, code generation, initial compilation):

```
     ____                                        _
    / ___|  ___  _ ____   _____ _ __ _ __   ___  __| |
    \___ \ / _ \| '__\ \ / / _ \ '__| '_ \ / _ \ / _` |
     ___) |  __/| |   \ V /  __/ |  | |_) | (_) | (_| |
    |____/ \___||_|    \_/ \___|_|  | .__/ \___/ \__,_|
                                    |_|
    ████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
    Starting Docker Compose services...
```

**Main screen** - shown once the server is running:

```
┌─Log Messages────────────────────────────────────────┐
│ info  14:32:55 SERVERPOD version: 3.5.0, dart: 3.11 │
│ info  14:32:56 Database connected                    │
│ info  14:32:56 All servers started                   │
│ info  14:32:56 Serverpod start complete              │
│ ── ✓ Compiling server (0.3s) ────────────────────── │
│ ── ✓ POST /api/user/create (42ms) ──────────────── │
│ ── ✓ GET /api/user/list (12ms) ─────────────────── │
│                                                      │
│  ⠹ POST /api/data/import... (2.1s)                   │
│    info  Importing batch 3/10                        │
│    query SELECT ... (3ms)                            │
│  ⠹ GET /api/user/profile... (0.1s)                   │
│  ⠹ Compiling server... (0.3s)                        │
├──────────────────────────────────────────────────────┤
 R Hot Reload  M Create Migration  A Apply Migration  Q Quit
```

Active operations (server sessions, CLI progress) are **pinned at the bottom** of the log area with animated spinners. Completed operations collapse into divider-style summary lines in the log history. See [Tracked operations](#tracked-operations) for details.

Tabs: **Log Messages** (structured, default) | **Raw Output** (stdout/stderr, for debugging).

## Architecture

### Log channels

There are three distinct logging systems that produce output across the CLI and server. Each needs different handling in TUI mode.

#### 1. `cli_tools` Logger (CLI side)

The `log` singleton from `cli_tools` is used throughout the CLI: `WatchSession`, `compileWithProgress`, `KernelCompiler`, `ServerProcess`, and `StartCommand` itself. Messages like "Starting server in watch mode...", "Server reloaded.", "Compilation failed." come from here.

**TUI handling**: Replace with a `TuiLogger` implementing `Logger` via `initializeLoggerWith()`. Routes all `log.info()` / `log.warning()` / `log.error()` / `log.debug()` calls to the TUI state as structured log entries. `Logger.progress()` maps to a [tracked operation](#tracked-operations). Since `appState` isn't available until the `Completer` fires, `TuiLogger` buffers messages during startup and flushes once attached.

**Headless handling**: Unchanged - uses existing `IsolatedLogger`.

**Tab**: "Log Messages" (default, visible).

#### 2. `LogWriter` interface (server side)

The server's structured logging system. `SessionLogManager` writes session logs (endpoint calls, queries, streaming messages) through `LogWriter` implementations: `TextStdOutLogWriter` (human-readable to stdout), `JsonStdOutLogWriter` (JSON to stdout), `DatabaseSessionLogWriter` (persisted to database), composed via `MultipleLogWriter` and `CachedLogWriter`.

Lifecycle messages (`_writeLifecycleMessage()`) are a separate path - direct `stdout.writeln()` calls in `serverpod.dart` for startup/shutdown status ("SERVERPOD version: ...", "All servers started", "Serverpod start complete", etc.). Error reporting (`_reportException()`) writes directly to `stderr.writeln()`.

**TUI handling**: Add a new `VmServiceLogWriter` implementing `LogWriter` that posts structured events via `developer.postEvent('ext.serverpod.log', ...)`. The CLI subscribes via the existing VM service connection (`vmService.onExtensionEvent`). Each event carries level, timestamp, message, and optional metadata (source, endpoint, session type). Lifecycle messages and error reporting also post events through the same extension. Server sessions are [tracked operations](#tracked-operations) - their logs and queries are grouped under the session rather than interleaved in the main log.

The extension is only active when the VM service is enabled (dev mode). Production builds have no VM service, so this is a no-op.

**Headless handling**: Unchanged - `TextStdOutLogWriter` / `JsonStdOutLogWriter` write to stdout as today.

**Tab**: "Log Messages" (default, visible).

#### 3. Raw stdout/stderr (server side)

Direct `stdout.writeln()` / `stderr.writeln()` / `print()` calls from user code, third-party packages, crash stack traces, unhandled exceptions, and pre-VM-service startup output (before the extension is registered). Also includes lifecycle messages and error reporting that currently write directly to stdout/stderr (these should eventually migrate to channel 2, but raw capture is the safety net).

**TUI handling**: Captured via `TuiLogSink` (an `IOSink`) passed to `ServerProcess`'s existing `stdoutSink` / `stderrSink` parameters. Lines are buffered and displayed in a separate tab.

**Headless handling**: Unchanged - forwarded directly to terminal stdout/stderr.

**Tab**: "Raw Output" (hidden by default, toggled via tab bar).

#### Summary

| Channel | Origin | TUI rendering | Tab |
|---------|--------|---------------|-----|
| `cli_tools` Logger | CLI (`log.info()`, etc.) | `TuiLogger` -> structured log entries | "Log Messages" |
| `LogWriter` / lifecycle | Server (session logs, startup/shutdown) | `VmServiceLogWriter` -> VM service events -> structured log entries | "Log Messages" |
| Raw stdout/stderr | Server (`print()`, crashes, third-party) | `TuiLogSink` -> raw lines | "Raw Output" |

### Tracked operations

CLI progress operations (`Logger.progress()`) and server sessions are unified under a single concept: **tracked operations**. A tracked operation has a start, a live duration, optional sub-entries (logs, queries), and an end with success/failure.

#### TUI rendering

**While active** - pinned at the bottom of the log area (between the log scroll and the button bar), with an animated braille spinner and live elapsed duration updating at ~80ms using dynamic unit formatting (μs/ms/s/m/h):

```
│  ⠹ POST /api/data/import... (2.1s)                   │
│    info  Importing batch 3/10                        │
│    query SELECT ... (3ms)                            │
│  ⠹ GET /api/user/profile... (0.1s)                   │
│  ⠹ Compiling server... (0.3s)                        │
├──────────────────────────────────────────────────────┤
 R Hot Reload  M Create Migration  A Apply Migration  Q Quit
```

- Always visible regardless of log scroll position.
- Server sessions show their sub-entries (log entries, queries) indented below the operation header.
- CLI progress operations (compiling, code gen) have no sub-entries.
- Multiple concurrent operations stack in the pinned area.

**On completion** - the pinned entry disappears and a `LogDivider`-style summary line is appended to the log history:

```
│ ── ✓ POST /api/user/create (42ms) ──────────────── │  <- completed, collapsed
│ ── ✗ POST /api/data/import (2.1s) ─────────────── │  <- failed, expandable
│ ── ✓ Compiling server (0.3s) ────────────────────── │
```

- ✓ for success, ✗ for failure.
- Completed lines are expandable to reveal sub-entries (logs, queries, error details).
- Failed operations show error details by default.

#### Sources

| Source | Start | Sub-entries | End |
|--------|-------|-------------|-----|
| `Logger.progress()` (CLI) | `TuiLogger` creates tracked op | None | Runner completes with success/failure |
| Server session | `VmServiceLogWriter.openLog()` | `logEntry()`, `logQuery()`, `logMessage()` | `closeLog()` |

#### VM service extension protocol

All events are posted via `developer.postEvent('ext.serverpod.log', data)`. The CLI subscribes via `vmService.onExtensionEvent`.

**Standalone log** (lifecycle messages, errors - not associated with a session):

```json
{"type": "log", "level": "info", "message": "SERVERPOD version: 3.5.0", "timestamp": "..."}
```

**Session lifecycle** (tracked operations):

```json
{"type": "session_start", "id": "sess_42", "label": "POST /api/user/create", "timestamp": "..."}

{"type": "session_log", "sessionId": "sess_42", "level": "info", "message": "Importing batch 3/10", "timestamp": "..."}

{"type": "session_query", "sessionId": "sess_42", "query": "SELECT ...", "duration": 3, "timestamp": "..."}

{"type": "session_end", "id": "sess_42", "success": true, "timestamp": "..."}
```

**Progress** (CLI-originated, but the protocol supports server-side progress too for future use):

```json
{"type": "progress_start", "id": "prog_1", "label": "Compiling server", "timestamp": "..."}

{"type": "progress_end", "id": "prog_1", "success": true, "timestamp": "..."}
```

The CLI tracks active operation IDs and computes elapsed duration locally from the start timestamp. CLI-originated progress (`Logger.progress()`) uses the same tracked operation model but does not go through the VM service - `TuiLogger` creates them directly in the TUI state.

### TUI integration pattern

nocterm's `runApp()` blocks the main isolate. All backend work runs in a callback triggered after the TUI delivers its state handle via a `Completer`.

```dart
Future<int> _runWatchModeWithTui({...}) async {
  final initialState = ServerWatchState(splashStage: 'Starting...');
  final stateCompleter = Completer<ServerpodWatchAppState>();

  stateCompleter.future.then((appState) async {
    // Replace CLI logger with TUI-aware logger.
    initializeLoggerWith(TuiLogger(appState));

    // Docker -> Code gen -> Compile -> Start server
    // (existing logic, log messages routed to TUI via TuiLogger)

    // Subscribe to server events via VM service.
    await vmService.streamListen('Extension');
    vmService.onExtensionEvent.listen((event) {
      if (event.extensionKind != 'ext.serverpod.log') return;
      final data = event.extensionData!.data;
      switch (data['type']) {
        case 'log':
          appState.addStructuredLog(...);
        case 'session_start':
          appState.startTrackedOperation(id: data['id'], label: data['label']);
        case 'session_log':
        case 'session_query':
          appState.addOperationEntry(sessionId: data['sessionId'], ...);
        case 'session_end':
          appState.endTrackedOperation(id: data['id'], success: data['success']);
      }
    });

    // Wire button callbacks.
    appState.onHotReload = () => session.forceReload();
    appState.onApplyMigration = () => session.applyMigration();
    appState.onQuit = () => shutdownApp(0);

    appState.setSplashStage(null); // Switch to main screen.
  });

  await runApp(
    NoctermApp(child: ServerpodWatchApp(initialState, stateCompleter)),
  );

  return exitCode;
}
```

### Headless mode

The TUI is used when all three conditions are met: `--tui` flag is true (default), `stdout.hasTerminal` is true, and the VM service is enabled (not `--no-fes`). Otherwise, falls back to the existing `IsolatedLogger` + direct stdout forwarding.

```dart
final tui = commandConfig.value(StartOption.tui) &&
    stdout.hasTerminal &&
    !noFes;

if (tui) {
  exitCode = await _runWithTui(...);  // new TUI path (both watch and one-shot)
} else if (watch) {
  exitCode = await _runWatchMode(...);  // existing watch path
} else {
  // existing one-shot path
}
```


### Signal handling

In TUI mode, nocterm's backend handles `SIGINT`/`SIGTERM` and triggers `shutdownApp()`. The `_ShutdownSignal` listener used in headless mode is skipped to avoid conflicts. The Q button also calls `shutdownApp(0)`.

## Package Changes

### `serverpod` (server)

- New `VmServiceLogWriter` implementing `LogWriter` that posts structured events via `developer.postEvent('ext.serverpod.log', ...)`.
- Wire `VmServiceLogWriter` into the log writer chain when VM service is available (dev mode).
- Post lifecycle messages (`_writeLifecycleMessage`) as structured events in addition to stdout.

### `serverpod_cli`

- New `--tui` flag on `StartCommand` (default: `true`, negatable as `--no-tui`, auto-detect from TTY).
- New `_runWatchModeWithTui()` function in `start.dart`.
- New files in `lib/src/commands/start/tui/`:
  - `state.dart` - `ServerWatchState` with structured log entries, raw log lines, splash stage, reload/restart counters.
  - `app.dart` - Root `StatefulComponent`, `Completer`-based state bridge.
  - `loading_screen.dart` - ASCII art + progress bar.
  - `main_screen.dart` - Two-tab layout (structured logs / raw output) + action buttons.
  - `tui_logger.dart` - `Logger` implementation routing CLI messages to TUI state, with startup buffering.
  - `tui_log_sink.dart` - `IOSink` capturing server stdout/stderr into raw output tab.
- New dependency: `nocterm: ^0.6.0`.

## Design Decisions

### Why structured logging via VM service instead of parsing stdout

The server already writes to stdout in two formats (`TextStdOutLogWriter`, `JsonStdOutLogWriter`). Parsing either format from the CLI has drawbacks:

- **Text format**: Requires reverse-engineering the table layout, handling multi-line messages, and guessing log levels from formatting. Fragile across versions.
- **JSON format**: Better, but still mixes with non-JSON output (lifecycle messages, `print()` calls, crash dumps). Requires line-by-line JSON detection and fallback handling.
- **Both**: The CLI becomes coupled to the server's stdout format. Any format change breaks the TUI.

The VM service extension approach decouples the transport from the display:
- Log events carry typed metadata (level, timestamp, source, endpoint) that the TUI renders directly.
- stdout/stderr remain available as a raw fallback channel for unstructured output.
- The extension is only active in dev mode - zero overhead in production.
- The VM service connection already exists for hot reload and static change notification.

### Why hide raw output by default

Structured logs are the curated developer experience - the server explicitly tells the CLI what matters. Raw stdout contains noise: VM service URIs, Observatory banners, third-party package output, debug prints left in user code. Showing both by default would duplicate information (structured + unstructured versions of the same message) and clutter the display.

The raw output tab is still accessible for debugging scenarios where unstructured output is needed (crash investigation, third-party library issues, missing structured events).

### Why `--tui` / `--no-tui` with auto-detection

`--tui` defaults to `true` (negatable as `--no-tui`). TUI activates when all conditions are met:
- Interactive terminal (`stdout.hasTerminal`) - not piped, not CI
- VM service enabled (not `--no-fes`) - structured logging channel available
- `--tui` flag not explicitly disabled

This means `--no-fes` implicitly disables TUI, which is correct: without the VM service, the TUI can't receive structured server logs and sessions. `--no-tui` provides an explicit opt-out for other cases.

## Open Questions

None currently.
