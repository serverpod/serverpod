import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/runner/log_codec.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart'
    show CompletedOperation, TrackedOperation;

/// Everything after the snapshot. See `docs/design/runner.md#attach-protocol`.
sealed class RunnerEvent {
  const RunnerEvent();

  Map<String, Object?> toJson();

  /// Decodes an event, or null for a kind only a newer runner knows.
  static RunnerEvent? fromJson(Map<String, Object?> json) =>
      switch (json['event']) {
        'log' => ServerLogEvent(
          decodeLogEntry(json),
          duplicatesLine: json['duplicatesLine'] as bool? ?? false,
        ),
        'operationStarted' => _operationStarted(json),
        'operationCompleted' => OperationCompletedEvent(
          decodeLogHistoryItem({...json, 'type': 'operation'})
              as CompletedOperation,
          id: json['operationId'] as String? ?? '',
        ),
        'serverLine' => ServerLineEvent(json['line'] as String? ?? ''),
        'flutterLine' => FlutterLineEvent(
          appId: json['appId'] as String? ?? '',
          line: json['line'] as String? ?? '',
        ),
        'flutterLog' => FlutterLogEntryEvent(
          appId: json['appId'] as String? ?? '',
          entry: decodeLogEntry(json),
          appendedToLines: json['appendedToLines'] as bool? ?? false,
        ),
        'stage' => StageChangedEvent(
          RunnerStage.byName(json['stage'] as String?),
          exitCode: json['exitCode'] as int?,
        ),
        'flutterApps' => FlutterAppsChangedEvent([
          for (final app in json['apps'] as List? ?? const [])
            if (app is Map<String, Object?>) decodeFlutterApp(app),
        ]),
        'flutterAppState' => FlutterAppStateEvent(
          appId: json['appId'] as String? ?? '',
          running: json['running'] as bool? ?? false,
          launching: json['launching'] as bool? ?? false,
          url: json['url'] as String?,
          launchStage: json['launchStage'] as String?,
        ),
        'manifest' => ManifestChangedEvent(
          RunnerManifest.fromJson(
            json['manifest'] as Map<String, Object?>? ?? const {},
          ),
        ),
        'operationsDiscarded' => OperationsDiscardedEvent([
          for (final id in json['operationIds'] as List? ?? const []) '$id',
        ]),
        _ => null,
      };
}

/// A structured entry appended to the server log.
final class ServerLogEvent extends RunnerEvent {
  const ServerLogEvent(this.entry, {this.duplicatesLine = false});

  final LogEntry entry;

  /// Whether a [ServerLineEvent] carries this entry too, as the pod prints it.
  final bool duplicatesLine;

  @override
  Map<String, Object?> toJson() => {
    'event': 'log',
    ...encodeLogHistoryItem(entry),
    if (duplicatesLine) 'duplicatesLine': true,
  };
}

/// An operation, such as a compile or a server scope, has begun.
final class OperationStartedEvent extends RunnerEvent {
  const OperationStartedEvent(this.operation, {required this.startedAt});

  final TrackedOperation operation;
  final DateTime startedAt;

  @override
  Map<String, Object?> toJson() => {
    'event': 'operationStarted',
    ...encodeTrackedOperation(operation, startedAt: startedAt),
  };
}

/// An operation has finished, with the duration the runner measured.
final class OperationCompletedEvent extends RunnerEvent {
  const OperationCompletedEvent(this.operation, {required this.id});

  final CompletedOperation operation;

  /// The [OperationStartedEvent] id, since labels are not unique.
  final String id;

  @override
  Map<String, Object?> toJson() => {
    ...encodeLogHistoryItem(operation),
    'event': 'operationCompleted',
    'operationId': id,
  };
}

/// A raw output line the pod printed, including crashes before its VM service.
final class ServerLineEvent extends RunnerEvent {
  const ServerLineEvent(this.line);

  final String line;

  @override
  Map<String, Object?> toJson() => {'event': 'serverLine', 'line': line};
}

/// A raw output line from a Flutter app.
final class FlutterLineEvent extends RunnerEvent {
  const FlutterLineEvent({required this.appId, required this.line});

  final String appId;
  final String line;

  @override
  Map<String, Object?> toJson() => {
    'event': 'flutterLine',
    'appId': appId,
    'line': line,
  };
}

/// A structured entry from a Flutter app.
final class FlutterLogEntryEvent extends RunnerEvent {
  const FlutterLogEntryEvent({
    required this.appId,
    required this.entry,
    this.appendedToLines = false,
  });

  final String appId;
  final LogEntry entry;

  /// Whether the runner appended the text to the app's lines, so a mirror must.
  ///
  /// True for a VM service event such as `Flutter.Error`, which never printed.
  final bool appendedToLines;

  @override
  Map<String, Object?> toJson() => {
    'event': 'flutterLog',
    'appId': appId,
    if (appendedToLines) 'appendedToLines': true,
    ...encodeLogHistoryItem(entry),
  };
}

/// The runner entered a [RunnerStage].
final class StageChangedEvent extends RunnerEvent {
  const StageChangedEvent(this.stage, {this.exitCode});

  final RunnerStage stage;

  bool get isRunning => stage == RunnerStage.running;

  /// The exit code on [RunnerStage.stopping]. A client reads null as clean.
  final int? exitCode;

  @override
  Map<String, Object?> toJson() => {
    'event': 'stage',
    'stage': stage.name,
    if (exitCode != null) 'exitCode': exitCode,
  };
}

/// The configured Flutter apps changed.
final class FlutterAppsChangedEvent extends RunnerEvent {
  const FlutterAppsChangedEvent(this.apps);

  final List<FlutterAppConfig> apps;

  @override
  Map<String, Object?> toJson() => {
    'event': 'flutterApps',
    'apps': [for (final app in apps) encodeFlutterApp(app)],
  };
}

/// A Flutter app started, became ready, stopped, or moved on in its launch.
final class FlutterAppStateEvent extends RunnerEvent {
  const FlutterAppStateEvent({
    required this.appId,
    required this.running,
    required this.launching,
    this.url,
    this.launchStage,
  });

  final String appId;
  final bool running;

  /// Whether the app is between its spawn and its ready signal.
  final bool launching;

  /// The app's URL, null on non-web devices and while it starts.
  final String? url;

  /// The toolchain step of a launching app, such as compiling, or null.
  final String? launchStage;

  @override
  Map<String, Object?> toJson() => {
    'event': 'flutterAppState',
    'appId': appId,
    'running': running,
    'launching': launching,
    if (url != null) 'url': url,
    if (launchStage != null) 'launchStage': launchStage,
  };
}

/// Operations that will never complete, such as a dead pod's open scopes.
final class OperationsDiscardedEvent extends RunnerEvent {
  const OperationsDiscardedEvent(this.ids);

  final List<String> ids;

  @override
  Map<String, Object?> toJson() => {
    'event': 'operationsDiscarded',
    'operationIds': ids,
  };
}

/// A published address changed, and the runner rewrote its manifest.
final class ManifestChangedEvent extends RunnerEvent {
  const ManifestChangedEvent(this.manifest);

  final RunnerManifest manifest;

  @override
  Map<String, Object?> toJson() => {
    'event': 'manifest',
    'manifest': manifest.toJson(),
  };
}

OperationStartedEvent _operationStarted(Map<String, Object?> json) {
  final decoded = decodeTrackedOperation(json);
  return OperationStartedEvent(decoded.operation, startedAt: decoded.startedAt);
}
