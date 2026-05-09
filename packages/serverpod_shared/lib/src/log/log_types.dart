/// Log severity level.
enum LogLevel {
  /// Fine-grained diagnostic information, normally disabled in production.
  debug,

  /// Informational messages describing normal operation.
  info,

  /// Recoverable issues worth flagging but not halting the flow.
  warning,

  /// Errors the caller is expected to handle or surface.
  error,

  /// Unrecoverable failures. Usually followed by process teardown.
  fatal,
}

/// A scoped operation. Scopes form a tree - every scope has a parent except the
/// root scope.
///
/// A scope begins with [LogWriter.openScope] and ends with
/// [LogWriter.closeScope]. Log entries within the scope reference it via
/// [LogEntry.scope].
class LogScope {
  /// Stable identifier for this scope. Unique within a process lifetime;
  /// referenced by [LogEntry.scope] and by scope open/close events.
  final String id;

  /// Human-readable label describing the scoped operation.
  final String label;

  /// Wall-clock time at which the scope was opened.
  final DateTime startTime;

  /// Enclosing scope, or `null` if this is a root scope.
  final LogScope? parent;

  /// Optional scope-level structured metadata (arbitrary key/value pairs).
  final Map<String, Object?>? metadata;

  /// Creates a scope. Prefer [LogScope.root] or [child] over calling this
  /// directly.
  const LogScope({
    required this.id,
    required this.label,
    required this.startTime,
    this.parent,
    this.metadata,
  });

  /// Creates a root scope for a process.
  factory LogScope.root(String label) => LogScope(
    id: 'root',
    label: label,
    startTime: DateTime.now(),
  );

  /// Creates a child scope under this scope.
  LogScope child({
    required String id,
    required String label,
    Map<String, Object?>? metadata,
  }) => LogScope(
    id: id,
    label: label,
    startTime: DateTime.now(),
    parent: this,
    metadata: metadata,
  );
}

/// A single log entry. Always belongs to a [LogScope].
class LogEntry {
  /// Wall-clock time at which the entry was produced.
  final DateTime time;

  /// Severity of the entry.
  final LogLevel level;

  /// The log message.
  final String message;

  /// Scope the entry was emitted from.
  final LogScope scope;

  /// Optional error associated with this entry.
  final Object? error;

  /// Optional stack trace captured alongside [error].
  final StackTrace? stackTrace;

  /// Optional entry-level structured metadata.
  final Map<String, Object?>? metadata;

  /// Creates a log entry.
  const LogEntry({
    required this.time,
    required this.level,
    required this.message,
    required this.scope,
    this.error,
    this.stackTrace,
    this.metadata,
  });
}

/// Transport layer for log output. Implementations decide where logs go
/// (terminal, database, VM service, TUI, etc.).
///
/// Use [MultiLogWriter] to fan out to multiple writers.
abstract class LogWriter {
  /// Writes a single log entry.
  Future<void> log(LogEntry entry);

  /// Begins a scoped operation.
  Future<void> openScope(LogScope scope);

  /// Ends a scoped operation.
  Future<void> closeScope(
    LogScope scope, {
    required bool success,
    required Duration duration,
    Object? error,
    StackTrace? stackTrace,
  });

  /// Releases any resources held by the writer.
  Future<void> close() async {}
}

/// A [LogWriter] that fans out to multiple child writers.
class MultiLogWriter extends LogWriter {
  final List<LogWriter> _writers;

  /// Creates a [MultiLogWriter] that fans out to [_writers]. The list is
  /// held by reference and may be mutated via [add] / [remove].
  MultiLogWriter(this._writers);

  /// Appends [writer] to the chain. Useful when a writer can only be
  /// constructed after the chain has already been built (e.g. a writer
  /// that needs a database session that doesn't exist yet at startup).
  void add(LogWriter writer) => _writers.add(writer);

  /// Removes [writer] from the chain, if present. Counterpart to [add];
  /// used when the chain needs to be reconfigured after construction
  /// (e.g. swapping a console writer once config has been loaded).
  bool remove(LogWriter writer) => _writers.remove(writer);

  @override
  Future<void> log(LogEntry entry) => _writers.map((w) => w.log(entry)).wait;

  @override
  Future<void> openScope(LogScope scope) =>
      _writers.map((w) => w.openScope(scope)).wait;

  @override
  Future<void> closeScope(
    LogScope scope, {
    required bool success,
    required Duration duration,
    Object? error,
    StackTrace? stackTrace,
  }) => _writers
      .map(
        (w) => w.closeScope(
          scope,
          success: success,
          duration: duration,
          error: error,
          stackTrace: stackTrace,
        ),
      )
      .wait;

  @override
  Future<void> close() => _writers.map((w) => w.close()).wait;
}
