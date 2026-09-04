import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/runner/log_codec.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart'
    show CompletedOperation, TrackedOperation;

/// Everything that happens after the snapshot.
///
/// The same entries the runner feeds its own history, forwarded. It receives
/// framework and session events over `ext.serverpod.log` and combines them
/// with the CLI's own log calls.
///
/// Clients compute elapsed durations from start timestamps.
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
        'serverLine' => ServerLineEvent(
          json['line'] as String? ?? '',
          duplicatesEntry: json['duplicatesEntry'] as bool? ?? false,
        ),
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
          isRunning: json['isRunning'] as bool? ?? false,
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
  /// [CompletedOperation] carries only a label, and labels are not unique. Two
  /// apps compiling report the same one.
  final String id;

  @override
  Map<String, Object?> toJson() => {
    ...encodeLogHistoryItem(operation),
    'event': 'operationCompleted',
    'operationId': id,
  };
}

/// A raw output line the pod printed.
final class ServerLineEvent extends RunnerEvent {
  const ServerLineEvent(this.line, {this.duplicatesEntry = false});

  final String line;

  /// Whether a [ServerLogEvent] carries this same text.
  ///
  /// The pod writes every entry to both its stdout and its VM service, so once
  /// the runner receives the structured half, rendering both prints it twice.
  /// False for output that was never an entry, such as `print`, a crash, or
  /// anything logged before the runner subscribed.
  ///
  /// Only the runner can decide this. The two copies reach a client as
  /// unrelated events.
  final bool duplicatesEntry;

  @override
  Map<String, Object?> toJson() => {
    'event': 'serverLine',
    'line': line,
    if (duplicatesEntry) 'duplicatesEntry': true,
  };
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

  /// Whether the runner also appended this entry's text to the app's raw line
  /// buffer, which a client must also do to hold the same buffer.
  ///
  /// True for an entry that reached the runner over the VM service, which the
  /// app does not also print, so the runner flattens it into the lines itself.
  /// False for one decoded from output the app did print.
  ///
  /// Only the runner can decide this. A client sees the same event either way.
  final bool appendedToLines;

  @override
  Map<String, Object?> toJson() => {
    'event': 'flutterLog',
    'appId': appId,
    if (appendedToLines) 'appendedToLines': true,
    ...encodeLogHistoryItem(entry),
  };
}

/// The runner moved between startup stages.
final class StageChangedEvent extends RunnerEvent {
  const StageChangedEvent(
    this.stage, {
    required this.isRunning,
    this.exitCode,
  });

  final RunnerStage stage;
  final bool isRunning;

  /// What the runner is about to exit with, on [RunnerStage.stopping].
  ///
  /// The pod's exit code, which only the runner sees. Null on every other
  /// stage, and from a runner that omits it, where a client assumes a clean
  /// stop.
  final int? exitCode;

  @override
  Map<String, Object?> toJson() => {
    'event': 'stage',
    'stage': stage.name,
    'isRunning': isRunning,
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
    required this.launching,
    this.url,
    this.launchStage,
  });

  final String appId;
  final bool running;

  /// Whether the app is between its spawn and its ready signal.
  ///
  /// Distinct from [running]. A launching app has no URL and cannot be hot
  /// reloaded, though it can be stopped. A UI shows it as busy, not absent.
  final bool launching;

  /// The app's URL once it is serving one, and null on non-web devices and
  /// while still starting.
  final String? url;

  /// What the toolchain is doing, such as resolving dependencies or
  /// compiling, while [launching].
  ///
  /// Null on every other transition, and from a runner that reports none. A
  /// cold Flutter build takes a minute, and this fills the app's status line
  /// meanwhile.
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

/// Operations the runner dropped without completing.
///
/// The pod's open request scopes die with it on a restart, and nothing reports
/// their end. Without this a client keeps them in flight indefinitely.
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
