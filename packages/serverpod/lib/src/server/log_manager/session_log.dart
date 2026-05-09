import 'dart:async';

import 'package:meta/meta.dart';
import 'package:serverpod_shared/log.dart' show LogLevel;

import '../../generated/protocol.dart' as protocol;

/// Discriminates session subtypes in [SessionOpen.type] and other
/// session records.
enum SessionKind {
  /// A one-shot method-call session.
  method,

  /// A server-streaming method-call session.
  methodStream,

  /// A long-lived websocket streaming session.
  stream,

  /// A web-server session (HTTP request).
  web,

  /// A scheduled future-call session.
  futureCall,

  /// An internal serverpod session with no client.
  internal,

  /// Fallback for sessions of an unrecognised subtype.
  unknown,
}

/// Kind of a [SessionEntry]: plain log message, database query, or
/// streaming-message handler.
enum SessionEntryKind {
  /// A free-form log message produced via `session.log(...)`.
  log,

  /// A database query observed through the session.
  query,

  /// A streaming-message handler record (stream sessions only).
  message,
}

/// Event signalling that a session has begun. Carries the identifying
/// fields so writers that persist or echo the session can record the
/// opening row / header.
class SessionOpen {
  /// Creates a [SessionOpen] event.
  const SessionOpen({
    required this.sessionId,
    required this.kind,
    required this.label,
    required this.startTime,
    required this.serverId,
    this.endpoint,
    this.method,
    this.futureCallName,
  });

  /// Stable identifier for the session; used to correlate all entries
  /// and the later [SessionClose].
  final String sessionId;

  /// Session subtype.
  final SessionKind kind;

  /// Human-readable label (e.g. `endpoint.method`, `WEB /path`, `STREAM …`).
  final String label;

  /// Wall-clock time at which the session started.
  final DateTime startTime;

  /// Server instance handling the session.
  final String serverId;

  /// Endpoint name (when applicable).
  final String? endpoint;

  /// Method name on [endpoint] (when applicable).
  final String? method;

  /// Name of the future call (only set for [SessionKind.futureCall]).
  final String? futureCallName;
}

/// Event signalling that a session has ended. Carries the close-time
/// fields that aren't known at open time (final duration, authenticated
/// user, aggregate query count, success/error outcome).
class SessionClose {
  /// Creates a [SessionClose] event.
  const SessionClose({
    required this.sessionId,
    required this.duration,
    required this.success,
    required this.slow,
    required this.numQueries,
    this.authenticatedUserId,
    this.error,
    this.stackTrace,
  });

  /// Identifier matching the [SessionOpen.sessionId].
  final String sessionId;

  /// Total time the session was open.
  final Duration duration;

  /// Whether the session completed without throwing.
  final bool success;

  /// Whether the total session duration exceeded the slow-session
  /// threshold configured for this session.
  final bool slow;

  /// Total number of database queries observed in this session (counted
  /// unconditionally, independent of whether individual query entries
  /// were persisted).
  final int numQueries;

  /// Authenticated user for this session, if any. Set at close time
  /// because authentication may complete after the session opens.
  final String? authenticatedUserId;

  /// Error captured when the session failed.
  final Object? error;

  /// Stack trace for [error], if any.
  final StackTrace? stackTrace;
}

/// Common base for per-session log entries. Every entry belongs to a
/// session identified by [sessionId] and carries a monotonic [order]
/// assigned by the producer at call time so persisted order matches
/// caller order even when writes race downstream.
sealed class SessionEntry {
  const SessionEntry({
    required this.sessionId,
    required this.order,
    required this.time,
    this.messageId,
  });

  /// Session this entry belongs to.
  final String sessionId;

  /// Per-session monotonic counter, assigned at call time.
  final int order;

  /// Wall-clock time at which the entry was produced.
  final DateTime time;

  /// Per-session message id (only set during streaming-message
  /// dispatch); carried on log / query entries produced while a
  /// message is being handled so they correlate to the message row.
  final int? messageId;

  /// Discriminator for switch-style consumers.
  SessionEntryKind get kind;
}

/// Free-form log message produced via `session.log(...)`.
class SessionLogEntry extends SessionEntry {
  /// Creates a [SessionLogEntry].
  const SessionLogEntry({
    required super.sessionId,
    required super.order,
    required super.time,
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
    super.messageId,
  });

  /// Severity of the log message.
  final LogLevel level;

  /// The log message.
  final String message;

  /// Error captured alongside this entry, if any.
  final String? error;

  /// Stack trace for [error], if any.
  final StackTrace? stackTrace;

  @override
  SessionEntryKind get kind => SessionEntryKind.log;
}

/// Database query observed within a session.
class SessionQueryEntry extends SessionEntry {
  /// Creates a [SessionQueryEntry].
  const SessionQueryEntry({
    required super.sessionId,
    required super.order,
    required super.time,
    required this.query,
    required this.duration,
    required this.slow,
    this.numRowsAffected,
    this.error,
    this.stackTrace,
    super.messageId,
  });

  /// The SQL (or equivalent) query text.
  final String query;

  /// Query execution time.
  final Duration duration;

  /// Whether [duration] exceeded the slow-query threshold.
  final bool slow;

  /// Rows affected, if the adapter reported a count.
  final int? numRowsAffected;

  /// Error captured when the query failed.
  final String? error;

  /// Stack trace for [error], if any.
  final StackTrace? stackTrace;

  @override
  SessionEntryKind get kind => SessionEntryKind.query;
}

/// Streaming-message handler record (only produced for
/// [SessionKind.stream] / [SessionKind.methodStream]).
class SessionMessageEntry extends SessionEntry {
  /// Creates a [SessionMessageEntry]. [messageId] is required for
  /// message entries (unlike on other [SessionEntry] kinds where it is
  /// optional).
  const SessionMessageEntry({
    required super.sessionId,
    required super.order,
    required super.time,
    required this.endpoint,
    required this.messageName,
    required int messageId,
    required this.duration,
    required this.slow,
    this.error,
    this.stackTrace,
  }) : super(messageId: messageId);

  /// Endpoint that received the message.
  final String endpoint;

  /// Dart class name of the message.
  final String messageName;

  /// Handler execution time.
  final Duration duration;

  /// Whether [duration] exceeded the slow-session threshold.
  final bool slow;

  /// Error captured when the handler failed.
  final String? error;

  /// Stack trace for [error], if any.
  final StackTrace? stackTrace;

  @override
  SessionEntryKind get kind => SessionEntryKind.message;
}

/// Sink for session-shaped events.
///
/// Parallels [LogWriter] from `serverpod_shared`, but speaks
/// strongly-typed session records instead of generic `LogEntry` /
/// `LogScope`. Implementations persist, echo, or forward session
/// events to a downstream consumer.
abstract class SessionLogWriter {
  /// Records the start of a session.
  Future<void> open(SessionOpen event);

  /// Records an in-session entry (log, query, or message).
  Future<void> record(SessionEntry entry);

  /// Records the end of a session.
  Future<void> close(SessionClose event);

  /// Releases any resources held by the writer. Counterpart to
  /// [LogWriter.close] on the generic side.
  Future<void> dispose() async {}
}

/// Fans out to a mutable list of child [SessionLogWriter]s. Mirrors
/// `MultiLogWriter` for the session side of the chain.
class MultiSessionLogWriter extends SessionLogWriter {
  /// Creates a [MultiSessionLogWriter] fanning out to [_writers]. The
  /// list is held by reference and may be mutated via [add] / [remove].
  MultiSessionLogWriter(this._writers);

  final List<SessionLogWriter> _writers;

  /// Appends [writer] to the chain. Useful when a writer can only be
  /// constructed after the chain has been built (e.g. a DB writer that
  /// needs a database session).
  void add(SessionLogWriter writer) => _writers.add(writer);

  /// Removes [writer] from the chain, if present.
  bool remove(SessionLogWriter writer) => _writers.remove(writer);

  @override
  Future<void> open(SessionOpen event) =>
      _writers.map((w) => w.open(event)).wait;

  @override
  Future<void> record(SessionEntry entry) =>
      _writers.map((w) => w.record(entry)).wait;

  @override
  Future<void> close(SessionClose event) =>
      _writers.map((w) => w.close(event)).wait;

  @override
  Future<void> dispose() => _writers.map((w) => w.dispose()).wait;
}

/// Typed entry point for session logging. Mirrors `Log` on the
/// framework side: callers invoke `sessionLog.open(...)` /
/// `sessionLog.record(...)` / `sessionLog.close(...)` without knowing
/// which writers are attached.
///
/// Each call appends onto a rolling internal Future so writes serialize
/// in invocation order. [flush] awaits that tail; [close] does the same
/// and blocks further dispatches.
class SessionLog {
  /// Creates a [SessionLog] that forwards to [_writer].
  SessionLog(this._writer);

  final SessionLogWriter _writer;
  Future<void> _latest = Future.value();
  bool _closed = false;

  /// Records a session start.
  void open(SessionOpen event) {
    if (_closed) return;
    _latest = _latest.then((_) async {
      try {
        await _writer.open(event);
      } catch (_) {
        // Writer errors are best-effort; don't let them break the chain.
      }
    });
  }

  /// Records an in-session entry.
  void record(SessionEntry entry) {
    if (_closed) return;
    _latest = _latest.then((_) async {
      try {
        await _writer.record(entry);
      } catch (_) {}
    });
  }

  /// Records a session end.
  void close(SessionClose event) {
    if (_closed) return;
    _latest = _latest.then((_) async {
      try {
        await _writer.close(event);
      } catch (_) {}
    });
  }

  /// Awaits in-flight writes without blocking further dispatches.
  Future<void> flush() => _latest;

  /// Awaits in-flight writes and blocks further dispatches.
  Future<void> shutdown() async {
    _closed = true;
    await flush();
    await _writer.dispose();
  }
}

/// Global writer chain that backs [sessionLog]. Callers configure the
/// chain by adding writers with [MultiSessionLogWriter.add] and removing
/// them with [MultiSessionLogWriter.remove]; identity is stable for the
/// process lifetime.
final MultiSessionLogWriter sessionLogWriter = MultiSessionLogWriter([]);

/// Global [SessionLog] that forwards to [sessionLogWriter]. Identity is
/// stable: the instance is constructed at library init and never
/// reassigned. Entry points configure session logging by mutating
/// [sessionLogWriter], not by replacing [sessionLog].
final SessionLog sessionLog = SessionLog(sessionLogWriter);

/// Maps serverpod's generated [protocol.LogLevel] to the shared
/// [LogLevel] used on session entries.
@internal
LogLevel toSessionLogLevel(protocol.LogLevel level) => switch (level) {
  protocol.LogLevel.debug => LogLevel.debug,
  protocol.LogLevel.info => LogLevel.info,
  protocol.LogLevel.warning => LogLevel.warning,
  protocol.LogLevel.error => LogLevel.error,
  protocol.LogLevel.fatal => LogLevel.fatal,
};
