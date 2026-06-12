# Design: Unified Logging

This document describes the redesign of serverpod's logging system to consolidate all output through a single `LogWriter` abstraction, enabling structured log delivery to the CLI's TUI via the VM service.

## Problem

The server historically had three separate output paths:

1. **Session logs** - structured, per-session, routed through `LogWriter` implementations.
2. **Lifecycle messages** - direct `stdout.writeln()` calls for startup banners, shutdown notices, and similar.
3. **Ad-hoc stderr/stdout** - `stderr.writeln()` / `stdout.writeln()` / `print()` sprinkled across the framework for warnings, errors, and informational messages.

Only the first category was structured; the other two bypassed the writer chain entirely and never reached the TUI's structured log view.

The TUI can only display messages that arrive via the VM service extension protocol (`ext.serverpod.log`). Direct stderr/stdout writes go to the "Raw Output" tab, which is hidden by default and not actively monitored.

## Goals

- All server framework messages flow through a single logging abstraction.
- The CLI receives all messages as structured events (level, message, scope).
- Framework and session logging are first-class and typed - each with its own entry point (`log` vs `sessionLog`) - but share the same core primitives where that makes sense (`LogScope`, `LogLevel`, writer chain pattern).
- The generic types live in a shared package and carry no serverpod-specific semantics. Session-specific concepts (sessionId, endpoint, query duration, …) are typed fields on session-specific records, not stringly-typed metadata on generic entries.
- No serverpod-specific types (generated `TableRow` classes) in the logging interface.

## Implementation status

- Generic types (`LogLevel`, `LogScope`, `LogEntry`, `LogWriter`) and the `Log` class live in `serverpod_shared/lib/src/log/` and are web-safe (no `dart:io`, no `dart:isolate`). IO-specific writers (`TextLogWriter`, `SpinnerLogWriter`, `IsolatedLogWriter`) and the `IsolatedObject` primitive (which lives under `src/utils/` since it is not log-specific) are split into a separate `package:serverpod_shared/log_io.dart` library so the core package stays usable from web builds.
- Four top-level globals drive the framework: `log` + `logWriter` (in `serverpod_shared`) and `sessionLog` + `sessionLogWriter` (in `serverpod`). Identity is stable for the process lifetime - the `Log` / `SessionLog` instances and their backing `MultiLogWriter` / `MultiSessionLogWriter` chains are constructed at library init and never reassigned. Entry points configure logging by adding/removing writers to the chains, not by swapping the loggers. Framework code logs as `log.info(...)` / `sessionLog.open(...)` without reaching through `Serverpod.instance`. Session events flow as typed `SessionOpen` / `SessionEntry` / `SessionClose` records, not as generic `LogEntry` values with metadata.
- The CLI bridges `cli_tools.Logger` to `Log` via `ServerpodCliLogger`.
- `DatabaseSessionLogWriter`, `TextSessionLogWriter`, and `JsonSessionLogWriter` persist / echo session events; `VmServiceSessionLogWriter` surfaces them to the CLI on the same `ext.serverpod.log` wire channel as framework events.

## Design

### Core types

Generic, framework-agnostic. In `packages/serverpod_shared/lib/src/log/log_types.dart`.

```dart
class LogScope {
  final String id;
  final String label;
  final DateTime startTime;
  final LogScope? parent;
  final Map<String, Object?>? metadata;

  factory LogScope.root(String label);
  LogScope child({required String id, required String label, Map<String, Object?>? metadata});
}

class LogEntry {
  final DateTime time;
  final LogLevel level;
  final String message;
  final LogScope scope;
  final Object? error;
  final StackTrace? stackTrace;
  final Map<String, Object?>? metadata;
}

abstract class LogWriter {
  Future<void> log(LogEntry entry);
  Future<void> openScope(LogScope scope);
  Future<void> closeScope(
    LogScope scope, {
    required bool success,
    required Duration duration,
    Object? error,
    StackTrace? stackTrace,
  });
  Future<void> close() async {}
}
```

### Log

`Log` in `packages/serverpod_shared/lib/src/log/log.dart` is the user-facing API. Named `Log` (not `Logger`) to avoid clashing with `cli_tools.Logger`.

```dart
class Log {
  Log(LogWriter writer, {LogLevel logLevel = LogLevel.info});

  LogLevel logLevel;

  LogScope get currentScope; // from Zone, fallback to synthetic root

  void call(LogLevel level, LogEntryFactory factory);
  Future<void> flush();
  Future<void> close();
}
```

Each call appends onto a rolling internal Future so writes serialize in invocation order. `flush()` awaits that tail; `close()` does the same and blocks further dispatches. Writer errors are swallowed - logging is best-effort.

Convenience methods (`debug`, `info`, `warning`, `error`, `isDebugEnabled`) are on `LogConvenience`. Scope management is on `LogScoping`.

#### Global `log` / `logWriter`

`serverpod_shared` exposes two stable top-level globals in `global_log.dart`:

```dart
final MultiLogWriter logWriter = MultiLogWriter([]);
final Log log = Log(logWriter, logLevel: LogLevel.info);
```

Both are `final`; their identity never changes after library init. Entry points configure logging by adding writers to `logWriter` (`logWriter.add(myWriter)`), not by replacing the `Log` instance. `Serverpod` teardown happens through an internal `ServerpodLogSetup` handle (see "Writer chains (server)" below) that tracks which writers it added and removes / disposes exactly those, leaving the globals in their pre-install state for the next Serverpod or test.

This model means `log` is genuinely a process-wide global, not a per-`Serverpod` field with a different name. Non-server code (CLI commands, migration tooling, tests) uses the same symbol without depending on the framework runtime. `sessionLog` / `sessionLogWriter` in `packages/serverpod/lib/src/server/log_manager/session_log.dart` follow the same pattern.

### Scopes

Every log entry belongs to a scope. Scopes form a tree rooted at a process-level root scope.

The current scope is read from the current `Zone` via a library-private symbol `_logScopeKey`, with a synthetic `LogScope.root('unknown')` as fallback. Scope propagation is opt-in: callers wrap their code in `log.progress(...)` - or any other `runZoned` that sets `_logScopeKey` - for nested log calls to inherit the scope.

```dart
extension LogScoping on Log {
  Future<T> progress<T>(
    String label,
    FutureOr<T> Function() runner, {
    Map<String, Object?>? metadata,
    bool Function(T result)? isSuccess,
  });
}
```

`progress` opens a child of the current scope, runs `runner` inside `runZoned(..., zoneValues: {_logScopeKey: scope})`, and closes the scope when done. The success signal is:

- If `runner` throws -> `success: false`.
- Else if `isSuccess` is supplied -> its return value.
- Else if `T` is `bool` -> the return value directly.
- Otherwise -> `true`.

There is no separate `openScope()` / `ScopedLog` API - all scope creation goes through `progress`.

### Session-side types

Live in `packages/serverpod/lib/src/server/log_manager/session_log.dart`. Kept in the `serverpod` package (not promoted to `serverpod_shared`) because they carry serverpod-specific concepts (sessions).

```dart
enum SessionKind { method, methodStream, stream, web, futureCall, internal, unknown }
enum SessionEntryKind { log, query, message }

class SessionOpen {
  final String sessionId;
  final SessionKind kind;
  final String label;
  final DateTime startTime;
  final String serverId;
  final String? endpoint;
  final String? method;
  final String? futureCallName;
}

class SessionClose {
  final String sessionId;
  final Duration duration;
  final bool success;
  final bool slow;
  final int numQueries;
  final String? authenticatedUserId;
  final Object? error;
  final StackTrace? stackTrace;
}

sealed class SessionEntry { /* sessionId, order, time, messageId */ }
class SessionLogEntry extends SessionEntry { /* level, message, error, stackTrace */ }
class SessionQueryEntry extends SessionEntry { /* query, duration, slow, numRowsAffected, error, stackTrace */ }
class SessionMessageEntry extends SessionEntry { /* endpoint, messageName, duration, slow, error, stackTrace */ }

abstract class SessionLogWriter {
  Future<void> open(SessionOpen event);
  Future<void> record(SessionEntry entry);
  Future<void> close(SessionClose event);
  Future<void> dispose() async {}
}

class MultiSessionLogWriter extends SessionLogWriter { /* fan-out, add/remove */ }

class SessionLog {
  SessionLog(SessionLogWriter writer);
  void open(SessionOpen event);
  void record(SessionEntry entry);
  void close(SessionClose event);
  Future<void> flush();
  Future<void> shutdown();
}

/// Stable globals. Identity never changes after library init - callers
/// configure the chain by adding writers to [sessionLogWriter].
final MultiSessionLogWriter sessionLogWriter = MultiSessionLogWriter([]);
final SessionLog sessionLog = SessionLog(sessionLogWriter);
```

### Why two chains (framework / session)

Two top-level globals drive this design: `log` (in `serverpod_shared`) and `sessionLog` (in `serverpod`). Each is backed by its own writer chain. The split is deliberate.

A tempting alternative is a **single generic chain** where session-specific context travels as a `Map<String, Object?>` on `LogEntry` / `LogScope`, and writers cast-out-by-key to reach the fields they need (e.g. `scope.metadata[sessionType]`, `entry.metadata[queryDuration]`). That was the earlier shape of this design. Two problems surfaced:

- **Stringly-typed session data.** Consumers stringified everything on the way in and destructured on the way out. A `Map<String, SessionScopeKeys.*>` vocabulary grew alongside the writers to keep the keys consistent - an entire file of string constants (`SessionScopeKeys`, `SessionEntryKeys`, `SessionTypeValues`, `SessionEntryTypeValues`) that the current design deletes. Every writer effectively re-implemented a typed schema on top of untyped metadata.
- **Filter wrappers to undo cross-contamination.** Because every writer saw every event, the framework-terminal writer had to be wrapped in a `NonSessionLogWriter` that dropped session-tagged events, and the session writers each re-implemented an "only-if-session-tagged" gate. Removing the wrapper doubled every session entry on the framework terminal. The wrapper also deleted.

Alternatives considered and rejected for this refactor:

1. **Add a channel discriminator to the generic `LogWriter` interface** (e.g. a required `channel` field on `LogEntry` / `LogScope`). Leaks serverpod-specific semantics - what counts as a "session" - into `serverpod_shared`, which wants to stay usable as a generic logging library by other projects.
2. **Shared `VmServiceLogWriter` as the only cross-cutting sink, keep everything else unified on one chain.** Doesn't address the stringly-typed metadata problem; sessions still round-trip through `Map<String, Object?>`.

The two-chain design keeps `serverpod_shared` neutral (the generic types know nothing about sessions), while session data stays typed end-to-end inside the `serverpod` package. `VmServiceLogWriter` and its session-aware sibling `VmServiceSessionLogWriter` are two small classes - the overhead of maintaining them is dwarfed by what was deleted from both sides.

### Writer implementations

Writers live in three tiers:

- **Shared core** (`package:serverpod_shared/serverpod_shared.dart`) - framework-agnostic and web-safe. Operate on `LogEntry` / `LogScope` values.
- **Shared IO** (`package:serverpod_shared/log_io.dart`) - writers that depend on `dart:io` / `dart:isolate` (`TextLogWriter`, `SpinnerLogWriter`, `IsolatedLogWriter`, `IsolatedObject`). Kept in a separate library so the core import works on web; callers that need terminal or isolate-based output import `log_io.dart` explicitly.
- **Server** (`serverpod`) - implement either `LogWriter` (framework chain) or `SessionLogWriter` (session chain). No writer implements both.
- **CLI** (`serverpod_cli`) - consumed by the serverpod CLI. `StdOutLogWriter` is the default writer for every command (`generate`, `create-migration`, etc.); `TuiLogWriter` is installed in place of it when `serverpod start --watch` runs in TUI mode.

#### Shared

**`SpinnerLogWriter`** - base class that manages braille progress spinners for terminal output. Handles the scope stack, timer animation, and clear-line/redraw lifecycle. Subclasses override `writeLogLine` and the spinner/completion formatters.

**`TextLogWriter`** - extends `SpinnerLogWriter`. Writes formatted text with ANSI level prefixes (`DEBUG:`, `WARNING:`, `ERROR:`) to stdout/stderr.

**`IsolatedLogWriter`** - wraps any `LogWriter` in a dedicated isolate via `IsolatedObject`. The writer factory runs on the isolate so timer-driven spinner animations keep updating even when the calling isolate is blocked.

**`MultiLogWriter`** / **`MultiSessionLogWriter`** - fan out to a mutable list of child writers. Support `add` / `remove` so the chain can be reconfigured after construction. Back the global `logWriter` / `sessionLogWriter`; `Serverpod` installs its defaults via `ServerpodLogSetup` (see "Writer chains (server)" below) and anything else - tests, CLI tooling - adds or removes writers directly.

#### Server - framework chain (`LogWriter`)

**`VmServiceLogWriter`** - posts framework events via `developer.postEvent('ext.serverpod.log', ...)`:

- `log(entry)` -> `{type: 'log', level, message, scopeId, ...}`
- `openScope(scope)` -> `{type: 'scope_start', id, label, parentId, ...}`
- `closeScope(scope)` -> `{type: 'scope_end', id, success, duration, ...}`

Available to any VM-service client that subscribes to the `Extension` stream. The CLI's TUI mode is the current consumer.

#### Server - session chain (`SessionLogWriter`)

**`TextSessionLogWriter`** - emits session events as aligned columnar text (TIME / ID / TYPE / CONTEXT / DETAILS) directly to stdout (stderr for errors). Renamed from the previous `SessionTextStdOutLogWriter`; wire format unchanged.

**`JsonSessionLogWriter`** - emits session events as single-line JSON to stdout (stderr for errors). Every session opens and closes with a `protocol.SessionLogEntry` row; log/query/message entries emit `protocol.LogEntry` / `QueryLogEntry` / `MessageLogEntry` rows keyed by a synthetic per-session `sessionLogId`. Renamed from `JsonStdOutLogWriter`.

**`DatabaseSessionLogWriter`** - persists typed session events to `serverpod_session_log` / `serverpod_log` / `serverpod_query_log` / `serverpod_message_log`. Consumes the typed records directly, so the generated `TableRow` classes stay internal to this writer. The writer is created before the database is up and attaches its internal `Session` later via `attach(session)`; before that it's a no-op.

**`VmServiceSessionLogWriter`** - session counterpart of `VmServiceLogWriter`. Emits session events on the same `ext.serverpod.log` wire channel, reusing the existing `scope_start` / `log` / `scope_end` event types so the current CLI `handleServerLogEvent` keeps working. Session-specific fields (kind, endpoint, method, duration, slow, numQueries, …) are namespaced under a top-level `session` sub-object that session-aware consumers can unpack.

#### CLI

**`StdOutLogWriter`** - extends `SpinnerLogWriter`. Delegates log formatting to `cli_tools.StdOutLogger` for `LogType`-aware output (bullets, headers, boxes, etc.). `LogType` is read from `LogEntry.metadata[logTypeKey]`. The underlying `StdOutLogger` accepts all levels - filtering is done by `Log`, not the writer.

**`TuiLogWriter`** - writer for the nocterm TUI. `log` appends a `LogEntry` to `AppStateHolder.state.logHistory`; `openScope` creates a `TrackedOperation` in `activeOperations`; `closeScope` completes it as `CompletedOperation`. Supports buffering before the TUI is mounted via `attach(holder)`.

### ServerpodCliLogger

Bridges `cli_tools.Logger` to `Log`. All serverpod CLI commands use `cli_tools.Logger` as their logging interface; `ServerpodCliLogger` implements it by delegating to a `Log` instance:

- `info(msg, type: TextLogType.bullet)` -> `Log.call()` with `LogType` stashed in `LogEntry.metadata[logTypeKey]`.
- `progress(msg, runner)` -> `Log.progress(msg, runner)`.

This lets the CLI use any `LogWriter`-based backend (TUI, terminal, …) while preserving `LogType` formatting.

### Writer chains (server)

The global `logWriter` / `sessionLogWriter` chains start empty at library
init. `ServerpodLogSetup` owns the lifecycle of a set of writers attached
to them: `installDefaults()` constructs the standard Serverpod bundle,
`applyConfig(config)` adds the config-dependent session writers once
[ServerpodConfig] is known, and `close()` removes and disposes exactly
the writers this setup contributed so the globals return to a clean state.

```dart
class ServerpodLogSetup {
  ServerpodLogSetup();                                  // empty
  static ServerpodLogSetup installDefaults();           // standard bundle
  DatabaseSessionLogWriter? get databaseWriter;         // for DB session attach

  void addLogWriter(LogWriter writer);
  void addSessionLogWriter(SessionLogWriter writer);

  @internal
  void applyConfig(ServerpodConfig config);             // called by Serverpod

  Future<void> close();                                 // idempotent
}
```

`installDefaults()` installs the framework- and session-chain writers that
don't depend on config:

```
logWriter        += TextLogWriter | IsolatedLogWriter(TextLogWriter.new)
                 += VmServiceLogWriter

sessionLogWriter += VmServiceSessionLogWriter
```

`applyConfig(config)` then appends, based on `config.sessionLogs`:

```
sessionLogWriter += TextSessionLogWriter | JsonSessionLogWriter   -- if consoleEnabled
sessionLogWriter += DatabaseSessionLogWriter                       -- if persistentEnabled and non-sqlite
```

`close()` flushes both chains, removes every tracked writer in reverse of
`add` order, and `close()` / `dispose()`s them so isolate-based writers
release their isolates. The global `Log` / `SessionLog` instances and
their MultiWriters themselves are never closed - the next Serverpod or
the next test sees a clean chain.

#### Ownership

`Serverpod` owns its `ServerpodLogSetup` - it constructs one via
`installDefaults()` during its own construction and calls `close()` on
shutdown. Entry points don't need to pass anything in:

```dart
void main(List<String> args) async {
  final pod = Serverpod(args, Protocol(), Endpoints());
  await pod.run();
}
```

Tests that need to observe or silence specific log output add writers to
the global `logWriter` / `sessionLogWriter` chains directly before
constructing `Serverpod`; those writers coexist with the defaults
`Serverpod` installs and are the test's responsibility to remove.

`Serverpod` itself makes exactly two calls against its setup: it invokes
`applyConfig(config)` once, after its own config load, and
`databaseWriter?.attach(internalSession)` once the database pool is up.
Every other mutation of the global chains happens through the setup.

### Writer chain (CLI)

```
CLI headless mode:
  ServerpodCliLogger
    -> Log -> IsolatedLogWriter(StdOutLogWriter.new)        -- terminal

CLI TUI mode:
  ServerpodCliLogger
    -> Log -> TuiLogWriter                                  -- nocterm TUI
```

In TUI mode the CLI also subscribes to the server process's `ext.serverpod.log` VM-service events and dispatches them into the same `TuiLogWriter` via `handleServerLogEvent`, so the TUI shows CLI-side progress (code generation, hot-reload) and server-side events (lifecycle, sessions) on one timeline. Headless mode does not subscribe - the server's own stdout, produced by its `TextLogWriter`, is inherited by the CLI process and printed unchanged.

### Session integration

`SessionLogManager` builds a `SessionOpen` record in its constructor (sessionId, kind, label, serverId, endpoint, method, futureCallName) and dispatches it through `sessionLog.open(...)`. Query / message / log dispatches build `SessionQueryEntry` / `SessionMessageEntry` / `SessionLogEntry` records and call `sessionLog.record(...)`. At teardown `finalizeLog` builds a `SessionClose` (duration, success, slow, numQueries, authenticatedUserId, error, stackTrace) and calls `sessionLog.close(...)`. Order is assigned by the producer at call time so persisted order matches caller order even when writes race downstream.

Long-lived streaming sessions with `logStreamingSessionsContinuously: false` buffer `SessionEntry` records in memory and flush them at `finalizeLog`. The session-open `SessionOpen` is deferred to the same point so a session that produces no events is never advertised to the chain.

**Framework `log` vs session `log`.** Framework `log.info(...)` calls made from inside an endpoint go to the framework chain and are recorded there, not on the session handling the request. This is intentional: if a caller wants a message recorded as part of the session, they call `session.log(...)`. Framework `log` is the right place for cross-cutting, non-session output and stays separate by design - the two chains are deliberately not correlated.

### Ad-hoc stdout/stderr migration

Framework code now routes through `log` in the common case. The remaining direct `stdout.writeln` / `stderr.writeln` calls are intentional last-resort paths that must not depend on the async log chain:

- `Serverpod` constructor catch block - fires before the log chain is drained and when `exit()` is about to be called; avoids losing the init error message to an un-flushed async pipeline.
- `_drainBeforeExit` / command-line help output (`--help`) - synchronous writes just before process exit or during argument parsing, where the async `Log` pipeline isn't a good fit.

Terminal writers (`TextLogWriter`, `TextSessionLogWriter`, `JsonSessionLogWriter`, `StdOutLogWriter`) also write to stdout/stderr, but that's their job - they are the sinks the chain hands events to, not ad-hoc bypasses.

### Multi-isolate

`Log` / `SessionLog` and their writer chains live on the main isolate. `IsolatedLogWriter` is the only writer that spans isolates: it moves a single underlying writer (typically `TextLogWriter`) onto a dedicated isolate so timer-driven spinner animations keep firing when the main isolate is blocked. For logs produced on *other* spawned isolates (hot-reload hosts, future-call workers, …), `VmServiceLogWriter.postEvent` is the escape hatch - `developer.postEvent` is process-wide, so posts from any isolate surface on the same `ext.serverpod.log` event stream.

## Open questions

1. **Recursion guard.** If a `LogWriter.log()` throws, `Log.call` currently swallows the error (`catch (_) {}`). That prevents recursion but also hides writer bugs. Consider a one-shot direct-to-stderr fallback for the first writer error per process, so the failure is visible without looping.
