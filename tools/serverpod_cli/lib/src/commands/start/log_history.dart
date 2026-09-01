import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:serverpod_cli/src/commands/start/flutter_log_event.dart';
import 'package:serverpod_cli/src/runner/line_sink.dart';
import 'package:serverpod_cli/src/runner/log_codec.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/util/strip_ansi.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart'
    show BoundedQueueList, CompletedOperation, TrackedOperation;
import 'package:vm_service/vm_service.dart' show Event;

/// In-memory log retention for one `serverpod start` session.
///
/// The watch loop fills these buffers regardless of how the session was
/// started, so the MCP `tail_server_logs` and `tail_flutter_logs` tools return
/// the same content with and without the TUI. The TUI renders the very same
/// buffers - it observes them through [onChanged], [onServerEntry] and
/// [onFlutterEntry] instead of owning them.
class StartLogHistory {
  /// Maximum number of structured server entries kept.
  static const maxServerEntries = 10000;

  /// Maximum number of raw output lines kept per Flutter app.
  static const maxFlutterLines = 10000;

  /// Maximum number of raw server output lines kept.
  static const maxServerLines = 10000;

  /// The pod's raw stdout and stderr, oldest first, ANSI-free.
  ///
  /// Separate from [serverEntries]: those are structured entries the pod
  /// reports over its VM service, while this is what it actually printed -
  /// which is the only place a crash before the VM service is up shows at all.
  final BoundedQueueList<String> serverLines = BoundedQueueList<String>(
    maxServerLines,
  );

  /// Structured server history, oldest first: [LogEntry] from the pod's
  /// `ext.serverpod.log` events, [CompletedOperation] for finished server
  /// scopes and CLI actions.
  final BoundedQueueList<Object> serverEntries = BoundedQueueList<Object>(
    maxServerEntries,
  );

  /// Server scopes and CLI actions that have started but not completed, keyed
  /// by scope id.
  final Map<String, TrackedOperation> activeOperations = {};

  /// IDs of operations opened by the current server process.
  ///
  /// These distinguish server scopes from CLI-driven operations when the
  /// process exits before it can emit matching `scope_end` events.
  final Set<String> _activeServerScopeIds = {};

  final Map<String, BoundedQueueList<String>> _flutterLines = {};

  /// Called after every mutation so a presentation layer can schedule a
  /// repaint. Null when nothing renders the buffers (`--no-tui`).
  void Function()? onChanged;

  /// Called for each [LogEntry] appended to [serverEntries], after it has been
  /// added.
  void Function(LogEntry entry)? onServerEntry;

  /// Called for each structured entry decoded from a Flutter app's VM service
  /// extension events, after its flattened text has been added to the app's
  /// line buffer.
  void Function(String appId, LogEntry entry)? onFlutterEntry;

  /// Called for each raw server output line appended to [serverLines].
  void Function(String line)? onServerLine;

  /// When each of [activeOperations] began, so a client attaching mid-operation
  /// can tell how long it has been running.
  ///
  /// [TrackedOperation] measures with a [Stopwatch] it starts on construction,
  /// which cannot cross a socket.
  final Map<String, DateTime> operationStartTimes = {};

  final StreamController<RunnerEvent> _events =
      StreamController<RunnerEvent>.broadcast();

  /// Every mutation, as an attach-protocol event.
  ///
  /// Broadcast and additive: the single [onChanged]/[onServerEntry] hooks stay
  /// for the in-process terminal UI, which took them first, while any number of
  /// attached clients read this.
  Stream<RunnerEvent> get events => _events.stream;

  void _emit(RunnerEvent event) {
    if (!_events.isClosed) _events.add(event);
  }

  /// Stops emitting events.
  ///
  /// The buffers stay readable for a final snapshot.
  Future<void> close() => _events.close();

  /// The retained output of every Flutter app that has produced any, by id.
  Map<String, List<String>> get flutterLines =>
      UnmodifiableMapView(_flutterLines);

  /// The raw output lines of the Flutter app [appId], oldest first.
  ///
  /// Created on first use, so output is retained even when nothing displays
  /// the app (there are no log tabs without the TUI).
  BoundedQueueList<String> flutterLinesFor(String appId) =>
      _flutterLines.putIfAbsent(
        appId,
        () => BoundedQueueList<String>(maxFlutterLines),
      );

  /// Replaces every app's retained output with [lines], dropping the buffer of
  /// any app [lines] does not name.
  ///
  /// A reconnecting client can meet a runner whose project no longer
  /// configures an app it holds output for.
  void replaceFlutterLines(Map<String, List<String>> lines) {
    _flutterLines.removeWhere((appId, _) => !lines.containsKey(appId));
    for (final entry in lines.entries) {
      flutterLinesFor(entry.key)
        ..clear()
        ..addAll(entry.value);
    }
    onChanged?.call();
  }

  /// Appends [line] to the raw output of the Flutter app [appId].
  void addFlutterLine(String appId, String line) {
    flutterLinesFor(appId).add(line);
    _emit(FlutterLineEvent(appId: appId, line: line));
    onChanged?.call();
  }

  /// Whether the runner is receiving the pod's structured log.
  ///
  /// False from the moment a pod process starts until the runner has
  /// subscribed to its VM service, and again once that process is gone.
  /// `postEvent` drops what it posts while nobody is listening, so for that
  /// window - which covers the whole boot sequence - the raw line is the only
  /// copy an entry has. After it, the pod's stdout writer repeats every entry
  /// verbatim.
  ///
  /// This is the one place that knows the difference, so it is the one place
  /// that decides: see [addServerLine].
  bool _serverStructuredLogging = false;

  /// Records that the pod's structured log is now reaching
  /// [recordServerLogEvent].
  void markServerStructuredLogging() => _serverStructuredLogging = true;

  /// Records that the pod process is gone, taking its structured log with it.
  void serverProcessGone() {
    _serverStructuredLogging = false;
    discardActiveServerScopes();
  }

  /// Appends [line] to the pod's raw output.
  ///
  /// A line the pod's structured log does not also carry joins
  /// [serverEntries]: it is part of the account, and putting it there is what
  /// keeps that account in order, which two buffers with no shared timestamp
  /// could not be merged into afterwards.
  void addServerLine(String line) {
    final duplicatesEntry = _serverStructuredLogging;
    serverLines.add(line);
    if (!duplicatesEntry) serverEntries.add(line);
    _emit(ServerLineEvent(line, duplicatesEntry: duplicatesEntry));
    onServerLine?.call(line);
    onChanged?.call();
  }

  /// An [IOSink] that records everything written to it as the pod's raw
  /// output, optionally passing the original writes on to [forwardTo] - the
  /// terminal in a foreground session, the runner's log file when detached.
  IOSink serverOutputSink({IOSink? forwardTo}) =>
      LineSink(addServerLine, forwardTo);

  /// An [IOSink] that records everything written to it as raw output lines of
  /// the Flutter app [appId].
  ///
  /// [forwardTo] receives everything verbatim, ANSI styling included, and is
  /// the real stdout/stderr outside the TUI; under the TUI it is null, since
  /// the TUI owns the terminal and renders the recorded lines itself.
  IOSink flutterOutputSink(String appId, {IOSink? forwardTo}) =>
      LineSink((line) => addFlutterLine(appId, line), forwardTo);

  /// Records an `ext.serverpod.log` event posted by the pod over its VM
  /// service. Other extension events are ignored.
  void recordServerLogEvent(Event event) {
    if (event.extensionKind != 'ext.serverpod.log') return;
    final data = event.extensionData?.data;
    if (data == null) return;

    switch (data['type'] as String?) {
      case 'log':
        final entry = _logEntryFromEventData(data, scopeLabel: 'server');
        serverEntries.add(entry);
        _emit(ServerLogEvent(entry));
        onServerEntry?.call(entry);

      case 'scope_start':
        final label = data['label'] as String? ?? '';
        // Don't track internal scopes as operations.
        if (label == 'INTERNAL') break;
        final id = data['id'] as String? ?? '';
        final operation = TrackedOperation(id: id, label: label);
        final startedAt = DateTime.now();
        activeOperations[id] = operation;
        _activeServerScopeIds.add(id);
        operationStartTimes[id] = startedAt;
        _emit(OperationStartedEvent(operation, startedAt: startedAt));

      case 'scope_end':
        final id = data['id'] as String? ?? '';
        // Ignore events from a process whose scopes have already been
        // discarded. This also prevents a delayed event from removing a
        // non-server operation that later reused the same id.
        if (!_activeServerScopeIds.remove(id)) break;
        final operation = activeOperations.remove(id);
        operationStartTimes.remove(id);
        if (operation == null) break;
        operation.stopwatch.stop();
        final serverDuration = (data['duration'] as num?)?.toDouble();
        final completed = CompletedOperation(
          label: operation.label,
          success: data['success'] as bool? ?? true,
          duration: serverDuration != null
              ? Duration(microseconds: (serverDuration * 1000000).round())
              : operation.stopwatch.elapsed,
        );
        serverEntries.add(completed);
        _emit(OperationCompletedEvent(completed, id: id));
    }
    onChanged?.call();
  }

  /// Discards every owned active scope.
  ///
  /// Attached clients are told which, since no `scope_end` will follow for
  /// a process that is gone.
  void discardActiveServerScopes() {
    if (_activeServerScopeIds.isEmpty) return;

    final discarded = <String>[];
    for (final id in _activeServerScopeIds) {
      if (activeOperations.remove(id) == null) continue;
      operationStartTimes.remove(id);
      discarded.add(id);
    }
    _activeServerScopeIds.clear();
    if (discarded.isEmpty) return;
    _emit(OperationsDiscardedEvent(discarded));
    onChanged?.call();
  }

  /// Records a structured log [event] from the Flutter app [appId], as
  /// reported by its process.
  ///
  /// Adds no raw lines: the process writes the same text to its output sink,
  /// which is already recorded. Only the structured entry is decoded and
  /// handed to [onFlutterEntry].
  void recordFlutterLogEvent(String appId, FlutterLogEvent event) {
    final entry = _flutterLogEntry(appId, event);
    _emit(FlutterLogEntryEvent(appId: appId, entry: entry));
    onFlutterEntry?.call(appId, entry);
    onChanged?.call();
  }

  /// Records a VM service extension event from the Flutter app [appId].
  ///
  /// Framework assertions arrive as `Flutter.Error` events; with structured
  /// errors enabled Flutter deliberately does not repeat them on stderr, so
  /// this stream is the only source for them. Apps built on Serverpod's
  /// logging also post `ext.serverpod.log` events. Both are flattened into the
  /// app's raw line buffer and handed to [onFlutterEntry] as one entry.
  void recordFlutterExtensionEvent(String appId, Event event) {
    final data = event.extensionData?.data;
    if (data == null) return;

    final LogEntry entry;
    switch (event.extensionKind) {
      case 'Flutter.Error':
        final message = data['renderedErrorText'];
        if (message is! String || message.isEmpty) return;
        final timestamp = event.timestamp;
        final hasTimestamp = timestamp != null && timestamp >= 0;
        entry = _flutterLogEntry(
          appId,
          FlutterLogEvent(
            time: hasTimestamp
                ? DateTime.fromMillisecondsSinceEpoch(timestamp)
                : DateTime.now(),
            level: LogLevel.error,
            message: message,
            source: FlutterLogSource.flutterError,
            metadata: {'errorsSinceReload': ?data['errorsSinceReload']},
            timestampIsInferred: !hasTimestamp,
          ),
        );

      case 'ext.serverpod.log':
        if (data['type'] != 'log') return;
        entry = _logEntryFromEventData(data, scopeLabel: appId);

      default:
        return;
    }

    addFlutterEntryLines(appId, entry);
    _emit(
      FlutterLogEntryEvent(appId: appId, entry: entry, appendedToLines: true),
    );
    onFlutterEntry?.call(appId, entry);
    onChanged?.call();
  }

  /// Records a log entry the CLI itself produced, as opposed to one the pod
  /// reported over its VM service.
  ///
  /// The two share [serverEntries] because a reader wants one chronological
  /// account: "generating code", "compilation failed" and the pod's own
  /// startup lines are one story, and the CLI half is the half that explains
  /// why a stack never came up.
  void recordCliLogEntry(LogEntry entry) {
    serverEntries.add(entry);
    _emit(ServerLogEvent(entry));
    onServerEntry?.call(entry);
    onChanged?.call();
  }

  /// Records the start of a CLI operation - a `log.progress` scope - so a
  /// client attaching mid-flight sees it running rather than nothing at all.
  void startCliOperation(String id, String label) {
    final operation = TrackedOperation(id: id, label: label);
    final startedAt = DateTime.now();
    activeOperations[id] = operation;
    operationStartTimes[id] = startedAt;
    _emit(OperationStartedEvent(operation, startedAt: startedAt));
    onChanged?.call();
  }

  /// Records the end of the CLI operation [id], if it is still open.
  ///
  /// [error] follows it into the history as an entry of its own, since
  /// [CompletedOperation] has nowhere to carry a reason.
  void completeCliOperation(
    String id, {
    required bool success,
    required Duration duration,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final operation = activeOperations.remove(id);
    final startedAt = operationStartTimes.remove(id);
    if (operation == null) return;
    operation.stopwatch.stop();
    final completed = CompletedOperation(
      label: operation.label,
      success: success,
      duration: duration,
    );
    serverEntries.add(completed);
    _emit(OperationCompletedEvent(completed, id: id));
    if (error != null) {
      recordCliLogEntry(
        LogEntry(
          time: DateTime.now(),
          level: LogLevel.error,
          message: operation.label,
          scope: LogScope(
            id: id,
            label: operation.label,
            startTime: startedAt ?? DateTime.now(),
          ),
          error: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
    onChanged?.call();
  }

  /// Drops every retained server entry and Flutter line.
  ///
  /// In-progress [activeOperations] are kept so a running hot reload or
  /// migration still completes into the cleared history.
  void clear() {
    serverEntries.clear();
    serverLines.clear();
    for (final lines in _flutterLines.values) {
      lines.clear();
    }
    onChanged?.call();
  }

  /// Appends [entry]'s message, error and stack trace as raw lines of the
  /// Flutter app [appId], mirroring how the app would have printed them.
  ///
  /// Emits no line events: the caller emits the structured entry covering the
  /// same text, and a client rendering both would print it twice. That entry
  /// carries `appendedToLines` instead, so an attached client can run this
  /// against its own copy of the buffer and hold the same lines.
  void addFlutterEntryLines(String appId, LogEntry entry) {
    final raw = StringBuffer(entry.message);
    if (entry.error != null) {
      if (raw.isNotEmpty) raw.writeln();
      raw.write(entry.error);
    }
    if (entry.stackTrace != null) {
      if (raw.isNotEmpty) raw.writeln();
      raw.write(entry.stackTrace);
    }
    flutterLinesFor(appId).addAll(stripAnsi(raw.toString()).split('\n'));
  }
}

/// The [LogEntry] for a Flutter app's structured log [event], scoped to
/// [appId]. ANSI styling is stripped; the source's own severity, timestamp and
/// logger name are preserved in the message and metadata.
LogEntry _flutterLogEntry(String appId, FlutterLogEvent event) {
  final loggerName = event.loggerName;
  final message = loggerName == null
      ? event.message
      : '[$loggerName] ${event.message}';
  final error = event.error;
  final stackTrace = event.stackTrace;
  return LogEntry(
    level: event.level,
    time: event.time,
    message: stripAnsi(message),
    scope: LogScope.root(appId),
    error: error == null ? null : stripAnsi(error),
    stackTrace: stackTrace == null || stackTrace.isEmpty
        ? null
        : StackTrace.fromString(stripAnsi(stackTrace)),
    metadata: {
      ...?event.metadata,
      'source': event.source.name,
      'loggerName': ?loggerName,
      'levelIsInferred': event.levelIsInferred,
      'timestampIsInferred': event.timestampIsInferred,
    },
  );
}

/// The [LogEntry] carried by an `ext.serverpod.log` event of type `log`.
LogEntry _logEntryFromEventData(
  Map<String, dynamic> data, {
  required String scopeLabel,
}) {
  final stackTrace = data['stackTrace'] as String?;
  return LogEntry(
    level: parseLogLevel(data['level'] as String? ?? 'info'),
    time:
        DateTime.tryParse(data['timestamp'] as String? ?? '') ?? DateTime.now(),
    message: data['message'] as String? ?? '',
    scope: LogScope.root(scopeLabel),
    error: data['error']?.toString(),
    stackTrace: stackTrace != null && stackTrace.isNotEmpty
        ? StackTrace.fromString(stackTrace)
        : null,
    metadata: data['metadata'] is Map
        ? Map<String, Object?>.from(data['metadata'] as Map)
        : null,
  );
}

/// A [LogWriter] that folds the CLI's own logging into a [StartLogHistory].
///
/// Without this the runner's `log.*` calls reach only its log file, and an
/// attached client shows the pod's output with nothing around it: no
/// generation errors, no compile failures, no progress for the minutes a cold
/// start takes. The in-process terminal UI used to get this by owning the
/// logger; a detached runner has to put it somewhere a client can read.
class StartLogHistoryWriter extends LogWriter {
  StartLogHistoryWriter(this._history);

  final StartLogHistory _history;

  @override
  Future<void> log(LogEntry entry) async => _history.recordCliLogEntry(entry);

  @override
  Future<void> openScope(LogScope scope) async =>
      _history.startCliOperation(scope.id, scope.label);

  @override
  Future<void> closeScope(
    LogScope scope, {
    required bool success,
    required Duration duration,
    Object? error,
    StackTrace? stackTrace,
  }) async => _history.completeCliOperation(
    scope.id,
    success: success,
    duration: duration,
    error: error,
    stackTrace: stackTrace,
  );
}
