import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/runner/log_codec.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart'
    show CompletedOperation, TrackedOperation;

/// Everything that happens after the snapshot.
///
/// Needs no new vocabulary: the runner already receives framework and session
/// events over `ext.serverpod.log`, combines them with log calls originating in
/// the CLI, and feeds its history. These are the same entries, forwarded.
///
/// Clients compute elapsed durations from start timestamps, so an animating
/// spinner generates no traffic.
sealed class RunnerEvent {
  const RunnerEvent();

  Map<String, Object?> toJson();

  /// Decodes an event, or null for a kind this client does not know.
  ///
  /// A newer runner may emit events an older client has never heard of.
  static RunnerEvent? fromJson(Map<String, Object?> json) =>
      switch (json['event']) {
        'log' => ServerLogEvent(decodeLogEntry(json)),
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
  const ServerLogEvent(this.entry);

  final LogEntry entry;

  @override
  Map<String, Object?> toJson() => {
    'event': 'log',
    ...encodeLogHistoryItem(entry),
  };
}

/// An operation, such as a hot reload, a migration, or a server scope, has
/// begun.
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

  /// The id [OperationStartedEvent] opened this operation under.
  ///
  /// [CompletedOperation] carries only a label, and labels are not unique.
  /// Two apps compiling report the same one. Without the id a client has to
  /// guess which tracked operation just ended.
  final String id;

  @override
  Map<String, Object?> toJson() => {
    ...encodeLogHistoryItem(operation),
    'event': 'operationCompleted',
    'operationId': id,
  };
}

/// A raw output line the pod printed.
///
/// The lines are the pod's whole output: every entry it logs, plus `print`,
/// crashes, and whatever it wrote before the runner subscribed to its
/// structured log. A renderer that shows the lines misses nothing.
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
  const FlutterLogEntryEvent({required this.appId, required this.entry});

  final String appId;
  final LogEntry entry;

  @override
  Map<String, Object?> toJson() => {
    'event': 'flutterLog',
    'appId': appId,
    ...encodeLogHistoryItem(entry),
  };
}

/// The runner moved between startup stages.
final class StageChangedEvent extends RunnerEvent {
  const StageChangedEvent(this.stage, {this.exitCode});

  final RunnerStage stage;

  /// Whether the pod is up, which only [RunnerStage.running] means.
  bool get isRunning => stage == RunnerStage.running;

  /// What the runner is about to exit with, on [RunnerStage.stopping].
  ///
  /// The pod's exit code, which only the runner sees: a client renders the
  /// stack rather than hosting it, and `--no-tui` is what CI reads the status
  /// of. Null on every other stage, and from a runner that does not send it,
  /// where a client can only assume a clean stop.
  final int? exitCode;

  @override
  Map<String, Object?> toJson() => {
    'event': 'stage',
    'stage': stage.name,
    if (exitCode != null) 'exitCode': exitCode,
  };
}

/// The set of configured Flutter apps changed, e.g. after the server pubspec
/// was edited.
final class FlutterAppsChangedEvent extends RunnerEvent {
  const FlutterAppsChangedEvent(this.apps);

  final List<FlutterAppConfig> apps;

  @override
  Map<String, Object?> toJson() => {
    'event': 'flutterApps',
    'apps': [for (final app in apps) encodeFlutterApp(app)],
  };
}

/// One Flutter app started, became ready, stopped, or reached a new stage of
/// its launch.
final class FlutterAppStateEvent extends RunnerEvent {
  const FlutterAppStateEvent({
    required this.appId,
    required this.running,
    this.url,
    this.launchStage,
  });

  final String appId;
  final bool running;

  /// The app's URL once it is serving one. Null on non-web devices and while
  /// it is still starting.
  final String? url;

  /// What the toolchain is doing right now, such as resolving dependencies or
  /// compiling, while the app launches.
  ///
  /// Null on every other transition, and from a runner that reports none. A
  /// cold Flutter build takes a minute. This fills the app's status
  /// line while it does, rather than a generic "Launching".
  final String? launchStage;

  @override
  Map<String, Object?> toJson() => {
    'event': 'flutterAppState',
    'appId': appId,
    'running': running,
    if (url != null) 'url': url,
    if (launchStage != null) 'launchStage': launchStage,
  };
}

/// Operations the runner dropped without completing them.
///
/// The pod's open request scopes die with it on a restart, and nothing will
/// report their end. Without this a client keeps them in flight for as long as
/// it stays attached.
final class OperationsDiscardedEvent extends RunnerEvent {
  const OperationsDiscardedEvent(this.ids);

  /// The ids [OperationStartedEvent] opened the operations under.
  final List<String> ids;

  @override
  Map<String, Object?> toJson() => {
    'event': 'operationsDiscarded',
    'operationIds': ids,
  };
}

/// A published address changed, so the manifest was rewritten.
///
/// The VM service URI is not the only address that can change, so the whole
/// manifest travels.
final class ManifestChangedEvent extends RunnerEvent {
  const ManifestChangedEvent(this.manifest);

  final RunnerManifest manifest;

  @override
  Map<String, Object?> toJson() => {
    'event': 'manifest',
    'manifest': manifest.toJson(),
  };
}

/// Rebuilds an [OperationStartedEvent] from the operation codec's record.
OperationStartedEvent _operationStarted(Map<String, Object?> json) {
  final decoded = decodeTrackedOperation(json);
  return OperationStartedEvent(decoded.operation, startedAt: decoded.startedAt);
}
