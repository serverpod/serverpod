import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/commands/start/flutter_log_event.dart';
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

  /// Structured server history, oldest first: [LogEntry] from the pod's
  /// `ext.serverpod.log` events, [CompletedOperation] for finished server
  /// scopes and CLI actions.
  final BoundedQueueList<Object> serverEntries = BoundedQueueList<Object>(
    maxServerEntries,
  );

  /// Server scopes and CLI actions that have started but not completed, keyed
  /// by scope id.
  final Map<String, TrackedOperation> activeOperations = {};

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

  /// The raw output lines of the Flutter app [appId], oldest first.
  ///
  /// Created on first use, so output is retained even when nothing displays
  /// the app (there are no log tabs without the TUI).
  BoundedQueueList<String> flutterLinesFor(String appId) =>
      _flutterLines.putIfAbsent(
        appId,
        () => BoundedQueueList<String>(maxFlutterLines),
      );

  /// Appends [line] to the raw output of the Flutter app [appId].
  void addFlutterLine(String appId, String line) {
    flutterLinesFor(appId).add(line);
    onChanged?.call();
  }

  /// An [IOSink] that records everything written to it as raw output lines of
  /// the Flutter app [appId].
  ///
  /// [forwardTo] receives everything verbatim, ANSI styling included, and is
  /// the real stdout/stderr outside the TUI; under the TUI it is null, since
  /// the TUI owns the terminal and renders the recorded lines itself.
  IOSink flutterOutputSink(String appId, {IOSink? forwardTo}) =>
      _FlutterOutputSink(this, appId, forwardTo);

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
        onServerEntry?.call(entry);

      case 'scope_start':
        final label = data['label'] as String? ?? '';
        // Don't track internal scopes as operations.
        if (label == 'INTERNAL') break;
        final id = data['id'] as String? ?? '';
        activeOperations[id] = TrackedOperation(id: id, label: label);

      case 'scope_end':
        final id = data['id'] as String? ?? '';
        final operation = activeOperations.remove(id);
        if (operation == null) break;
        operation.stopwatch.stop();
        final serverDuration = (data['duration'] as num?)?.toDouble();
        serverEntries.add(
          CompletedOperation(
            label: operation.label,
            success: data['success'] as bool? ?? true,
            duration: serverDuration != null
                ? Duration(microseconds: (serverDuration * 1000000).round())
                : operation.stopwatch.elapsed,
          ),
        );
    }
    onChanged?.call();
  }

  /// Records a structured log [event] from the Flutter app [appId], as
  /// reported by its process.
  ///
  /// Adds no raw lines: the process writes the same text to its output sink,
  /// which is already recorded. Only the structured entry is decoded and
  /// handed to [onFlutterEntry].
  void recordFlutterLogEvent(String appId, FlutterLogEvent event) {
    onFlutterEntry?.call(appId, _flutterLogEntry(appId, event));
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

    _addFlutterEntryLines(appId, entry);
    onFlutterEntry?.call(appId, entry);
    onChanged?.call();
  }

  /// Drops every retained server entry and Flutter line.
  ///
  /// In-progress [activeOperations] are kept so a running hot reload or
  /// migration still completes into the cleared history.
  void clear() {
    serverEntries.clear();
    for (final lines in _flutterLines.values) {
      lines.clear();
    }
    onChanged?.call();
  }

  /// Appends [entry]'s message, error and stack trace as raw lines of the
  /// Flutter app [appId], mirroring how the app would have printed them.
  void _addFlutterEntryLines(String appId, LogEntry entry) {
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

/// The [LogLevel] named by [level]; unknown names are treated as info.
LogLevel parseLogLevel(String level) {
  return switch (level) {
    'debug' => LogLevel.debug,
    'info' => LogLevel.info,
    'warning' || 'warn' => LogLevel.warning,
    'error' => LogLevel.error,
    'fatal' => LogLevel.fatal,
    _ => LogLevel.info,
  };
}

/// [IOSink] that splits what is written to it into ANSI-free lines and records
/// them as raw output of one Flutter app, optionally passing the original
/// writes on to another sink unchanged.
class _FlutterOutputSink implements IOSink {
  _FlutterOutputSink(this._history, this._appId, this._forwardTo);

  final StartLogHistory _history;
  final String _appId;
  final IOSink? _forwardTo;
  final StringBuffer _lineBuffer = StringBuffer();

  @override
  void add(List<int> data) {
    _forwardTo?.add(data);
    _record(utf8.decode(data, allowMalformed: true));
  }

  /// Forwards text as text rather than as bytes, so the terminal keeps
  /// encoding it the way it would have without this sink in between.
  @override
  void write(Object? object) {
    _forwardTo?.write(object);
    _record('$object');
  }

  @override
  void writeln([Object? object = '']) => write('$object\n');

  @override
  void writeAll(Iterable<Object?> objects, [String separator = '']) =>
      write(objects.join(separator));

  @override
  void writeCharCode(int charCode) => write(String.fromCharCode(charCode));

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _history.addFlutterLine(_appId, stripAnsi('ERROR: $error'));
    if (stackTrace != null) {
      _history.addFlutterLine(_appId, stripAnsi('$stackTrace'));
    }
    _forwardTo?.addError(error, stackTrace);
  }

  @override
  Future<void> addStream(Stream<List<int>> stream) => stream.forEach(add);

  @override
  Future<void> flush() async => _forwardTo?.flush();

  /// Records whatever was written without a trailing newline. Never closes
  /// [_forwardTo]: outside the TUI that is the process's own stdout/stderr.
  @override
  Future<void> close() async {
    if (_lineBuffer.isNotEmpty) _emitLine();
  }

  @override
  Encoding get encoding => utf8;

  @override
  set encoding(Encoding value) {}

  @override
  Future<void> get done => Future.value();

  /// Splits [text] on newlines, holding back a trailing partial line until the
  /// rest of it arrives.
  void _record(String text) {
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (char == '\n') {
        _emitLine();
      } else if (char != '\r') {
        _lineBuffer.writeCharCode(char.codeUnitAt(0));
      }
    }
  }

  void _emitLine() {
    _history.addFlutterLine(_appId, stripAnsi(_lineBuffer.toString()));
    _lineBuffer.clear();
  }
}
