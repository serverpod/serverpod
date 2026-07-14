import 'package:serverpod_shared/log.dart' hide log;
import 'package:serverpod_tui/serverpod_tui.dart';
import 'package:vm_service/vm_service.dart' show Event;

import '../../../util/serverpod_cli_logger.dart';
import '../flutter_log_event.dart';
import 'app.dart';
import 'tab_model.dart';

int _actionCounter = 0;

/// Dispatches a structured server log event to the TUI state.
void handleServerLogEvent(TuiAppStateHolder holder, Event event) {
  if (event.extensionKind != 'ext.serverpod.log') return;
  final data = event.extensionData?.data;
  if (data == null) return;

  final state = holder.state;
  final type = data['type'] as String?;
  switch (type) {
    case 'log':
      final entry = _logEntryFromData(data, scopeLabel: 'server');
      state.logHistory.add(entry);

      // An alert carries `metadata: {'alert': true}`. AlertMessage.parse
      // strips any `<...>` copy markup for display; the raw log line above
      // keeps the markup.
      final metadata = data['metadata'];
      if (metadata is Map && metadata['alert'] == true) {
        holder.showAlert(AlertMessage.parse(entry.message), time: entry.time);
      }

    case 'scope_start':
      final id = data['id'] as String? ?? '';
      final label = data['label'] as String? ?? '';
      // Don't track internal scopes as operations.
      if (label == 'INTERNAL') break;
      state.activeOperations[id] = TrackedOperation(
        id: id,
        label: label,
      );

    case 'scope_end':
      final id = data['id'] as String? ?? '';
      final op = state.activeOperations.remove(id);
      if (op != null) {
        op.stopwatch.stop();
        final serverDuration = (data['duration'] as num?)?.toDouble();
        state.logHistory.add(
          CompletedOperation(
            label: op.label,
            success: data['success'] as bool? ?? true,
            duration: serverDuration != null
                ? Duration(microseconds: (serverDuration * 1000000).round())
                : op.stopwatch.elapsed,
          ),
        );
      }
  }
  holder.markDirty();
}

/// Dispatches Flutter VM extension events to the matching app log tab.
///
/// Flutter framework assertions are emitted as `Flutter.Error` events when
/// structured errors are enabled. In that mode Flutter intentionally does not
/// repeat the error on stderr, so this stream is the authoritative source.
void handleFlutterExtensionEvent(
  StartAppStateHolder holder,
  String appId,
  Event event,
) {
  final tab = holder.state.appLogTabFor(appId);
  if (tab == null) return;

  final data = event.extensionData?.data;
  if (data == null) return;

  switch (event.extensionKind) {
    case 'Flutter.Error':
      final message = data['renderedErrorText'];
      if (message is! String || message.isEmpty) return;
      final eventTimestamp = event.timestamp;
      final hasEventTimestamp = eventTimestamp != null && eventTimestamp >= 0;
      final flutterEvent = FlutterLogEvent(
        time: hasEventTimestamp
            ? DateTime.fromMillisecondsSinceEpoch(eventTimestamp)
            : DateTime.now(),
        level: LogLevel.error,
        message: message,
        source: FlutterLogSource.flutterError,
        metadata: {'errorsSinceReload': data['errorsSinceReload']},
        timestampIsInferred: !hasEventTimestamp,
      );
      handleFlutterLogEvent(holder, appId, flutterEvent);
      _addRawFlutterEntry(
        tab,
        LogEntry(
          level: LogLevel.error,
          time: flutterEvent.time,
          message: message,
          scope: LogScope.root(appId),
        ),
      );
    case 'ext.serverpod.log':
      if (data['type'] != 'log') return;
      _addFlutterEntry(
        tab,
        _logEntryFromData(data, scopeLabel: appId),
      );
    default:
      return;
  }

  holder.markDirty();
}

/// Adds a raw Flutter stdout/stderr line to the history used by MCP.
///
/// The corresponding structured entry arrives separately through
/// [handleFlutterLogEvent], before the process flattens it into this stream.
void handleFlutterOutput(
  StartAppStateHolder holder,
  String appId,
  String line,
) {
  final tab = holder.state.appLogTabFor(appId);
  if (tab == null) return;

  tab.lines.add(line);
  holder.markDirty();
}

/// Adds a Flutter event with the structure supplied by its original source.
void handleFlutterLogEvent(
  StartAppStateHolder holder,
  String appId,
  FlutterLogEvent event,
) {
  final tab = holder.state.appLogTabFor(appId);
  if (tab == null) return;

  final loggerName = event.loggerName;
  tab.logHistory.add(
    LogEntry(
      level: event.level,
      time: event.time,
      message: loggerName == null
          ? event.message
          : '[$loggerName] ${event.message}',
      scope: LogScope.root(appId),
      error: event.error,
      stackTrace: event.stackTrace == null || event.stackTrace!.isEmpty
          ? null
          : StackTrace.fromString(event.stackTrace!),
      metadata: {
        ...?event.metadata,
        'source': event.source.name,
        'loggerName': ?loggerName,
        'levelIsInferred': event.levelIsInferred,
        'timestampIsInferred': event.timestampIsInferred,
      },
    ),
  );
  holder.markDirty();
}

LogEntry _logEntryFromData(
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

void _addFlutterEntry(AppLogTab tab, LogEntry entry) {
  tab.logHistory.add(entry);

  _addRawFlutterEntry(tab, entry);
}

void _addRawFlutterEntry(AppLogTab tab, LogEntry entry) {
  final raw = StringBuffer(entry.message);
  if (entry.error != null) {
    if (raw.isNotEmpty) raw.writeln();
    raw.write(entry.error);
  }
  if (entry.stackTrace != null) {
    if (raw.isNotEmpty) raw.writeln();
    raw.write(entry.stackTrace);
  }
  tab.lines.addAll(raw.toString().split('\n'));
}

/// Runs an async action as a tracked operation with spinner in the TUI.
///
/// Guards against concurrent actions - if [state.actionBusy] is true the action
/// is silently ignored. The action also requires [state.serverReady], unless
/// [allowWhenStartable] is set and the session is degraded but
/// [state.serverStartable] (used by the "Start server" recovery action, which
/// runs precisely when no server is up yet).
void runTrackedAction(
  StartAppStateHolder holder,
  String label,
  Future<void> Function() action, {
  bool allowWhenStartable = false,
}) {
  final state = holder.state;
  final ready =
      state.serverReady || (allowWhenStartable && state.serverStartable);
  if (state.actionBusy || !ready) return;

  state.actionBusy = true;
  final id =
      '${label.hashCode}_${DateTime.now().millisecondsSinceEpoch}_${++_actionCounter}';
  state.activeOperations[id] = TrackedOperation(id: id, label: label);
  holder.markDirty();

  action()
      .then((_) {
        _completeTrackedAction(holder, id, success: true);
      })
      .catchError((Object e) {
        _completeTrackedAction(holder, id, success: false);
        log.error('$label failed: $e');
      });
}

void _completeTrackedAction(
  StartAppStateHolder holder,
  String id, {
  required bool success,
}) {
  final state = holder.state;
  state.actionBusy = false;
  final op = state.activeOperations.remove(id);
  if (op != null) {
    op.stopwatch.stop();
    state.logHistory.add(
      CompletedOperation(
        label: op.label,
        success: success,
        duration: op.stopwatch.elapsed,
      ),
    );
  }
  holder.markDirty();
}

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
