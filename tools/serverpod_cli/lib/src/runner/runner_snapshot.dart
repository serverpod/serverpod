import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/runner/log_codec.dart';
import 'package:serverpod_cli/src/runner/runner_stage.dart';
import 'package:serverpod_tui/serverpod_tui.dart' show TrackedOperation;

export 'package:serverpod_cli/src/runner/runner_stage.dart';

/// Everything a client needs to render the runner when it attaches.
class RunnerSnapshot {
  const RunnerSnapshot({
    required this.stage,
    required this.isRunning,
    required this.watchModeEnabled,
    required this.canLaunchFlutterApps,
    required this.serverEntries,
    required this.serverLines,
    required this.activeOperations,
    required this.flutterLines,
    required this.flutterApps,
    required this.runningFlutterApps,
    required this.launchingFlutterApps,
    this.flutterAppUrls = const {},
    this.exitCode,
  });

  /// The snapshot of a runner whose buffers live in [history].
  factory RunnerSnapshot.from({
    required StartLogHistory history,
    required RunnerStage stage,
    required bool isRunning,
    required bool watchModeEnabled,
    required bool canLaunchFlutterApps,
    required List<FlutterAppConfig> flutterApps,
    required Set<String> runningFlutterApps,
    required Set<String> launchingFlutterApps,
    Map<String, String?> flutterAppUrls = const {},
    int? exitCode,
  }) => RunnerSnapshot(
    stage: stage,
    isRunning: isRunning,
    watchModeEnabled: watchModeEnabled,
    canLaunchFlutterApps: canLaunchFlutterApps,
    serverEntries: history.serverEntries.toList(),
    serverLines: history.serverLines.toList(),
    activeOperations: [
      for (final entry in history.activeOperations.entries)
        (
          operation: entry.value,
          startedAt: history.operationStartTimes[entry.key] ?? DateTime.now(),
        ),
    ],
    flutterLines: {
      for (final app in flutterApps)
        if (history.flutterLines[app.id] case final lines?)
          app.id: lines.toList(),
    },
    flutterApps: flutterApps,
    runningFlutterApps: runningFlutterApps,
    launchingFlutterApps: launchingFlutterApps,
    flutterAppUrls: flutterAppUrls,
    exitCode: exitCode,
  );

  final RunnerStage stage;
  final bool isRunning;
  final bool watchModeEnabled;

  /// Whether launching an app can do anything, which the run mode decides.
  final bool canLaunchFlutterApps;

  /// The log entries and completed operations, oldest first.
  final List<Object> serverEntries;

  final List<String> serverLines;

  /// The operations in flight, with the time each began.
  final List<({TrackedOperation operation, DateTime startedAt})>
  activeOperations;

  final Map<String, List<String>> flutterLines;

  final List<FlutterAppConfig> flutterApps;

  final Set<String> runningFlutterApps;

  final Set<String> launchingFlutterApps;

  /// App URLs by id, carried here since an app publishes its URL only once.
  final Map<String, String?> flutterAppUrls;

  /// The exit code once stopping, carried here since events do not replay.
  final int? exitCode;

  Map<String, Object?> toJson() => {
    'stage': stage.name,
    'isRunning': isRunning,
    'watchModeEnabled': watchModeEnabled,
    'canLaunchFlutterApps': canLaunchFlutterApps,
    'serverLines': serverLines,
    'serverEntries': [
      for (final entry in serverEntries) encodeLogHistoryItem(entry),
    ],
    'activeOperations': [
      for (final active in activeOperations)
        encodeTrackedOperation(active.operation, startedAt: active.startedAt),
    ],
    'flutterLines': flutterLines,
    'flutterApps': [
      for (final app in flutterApps) encodeFlutterApp(app),
    ],
    'runningFlutterApps': runningFlutterApps.toList(),
    'launchingFlutterApps': launchingFlutterApps.toList(),
    'flutterAppUrls': flutterAppUrls,
    if (exitCode != null) 'exitCode': exitCode,
  };

  static RunnerSnapshot fromJson(Map<String, Object?> json) => RunnerSnapshot(
    stage: RunnerStage.byName(json['stage'] as String?),
    isRunning: json['isRunning'] as bool? ?? false,
    watchModeEnabled: json['watchModeEnabled'] as bool? ?? false,
    canLaunchFlutterApps: json['canLaunchFlutterApps'] as bool? ?? false,
    serverLines: [
      for (final line in json['serverLines'] as List? ?? const []) '$line',
    ],
    serverEntries: [
      for (final entry in _list(json['serverEntries']))
        ?decodeLogHistoryItem(entry),
    ],
    activeOperations: [
      for (final entry in _list(json['activeOperations']))
        decodeTrackedOperation(entry),
    ],
    flutterLines: switch (json['flutterLines']) {
      final Map<Object?, Object?> map => {
        for (final entry in map.entries)
          '${entry.key}': [
            for (final line in entry.value as List? ?? const []) '$line',
          ],
      },
      _ => const {},
    },
    flutterApps: [
      for (final entry in _list(json['flutterApps'])) decodeFlutterApp(entry),
    ],
    runningFlutterApps: {
      for (final id in json['runningFlutterApps'] as List? ?? const []) '$id',
    },
    launchingFlutterApps: {
      for (final id in json['launchingFlutterApps'] as List? ?? const []) '$id',
    },
    flutterAppUrls: switch (json['flutterAppUrls']) {
      final Map<Object?, Object?> map => {
        for (final entry in map.entries) '${entry.key}': entry.value as String?,
      },
      _ => const {},
    },
    exitCode: json['exitCode'] as int?,
  );
}

/// Encodes what a client shows of [app], leaving paths and run args behind.
Map<String, Object?> encodeFlutterApp(FlutterAppConfig app) => {
  'id': app.id,
  'name': app.name,
  'autoLaunch': app.autoLaunch,
  if (app.device != null) 'device': app.device,
};

/// Decodes what [encodeFlutterApp] produced, with empty path parts.
FlutterAppConfig decodeFlutterApp(Map<String, Object?> json) =>
    FlutterAppConfig(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      autoLaunch: json['autoLaunch'] as bool? ?? false,
      device: json['device'] as String?,
      relativePathParts: const [],
      serverPackageDirectoryPathParts: const [],
    );

List<Map<String, Object?>> _list(Object? value) => [
  for (final entry in value as List? ?? const [])
    if (entry is Map<String, Object?>) entry,
];
