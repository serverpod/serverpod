import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/runner/log_codec.dart';
import 'package:serverpod_cli/src/runner/runner_stage.dart';
import 'package:serverpod_tui/serverpod_tui.dart' show TrackedOperation;

export 'package:serverpod_cli/src/runner/runner_stage.dart';

/// Everything a client needs to render the runner the moment it connects.
///
/// Sent once, on connect. It serializes what the runner already retains rather
/// than a second buffer, so its bounds are the log history's.
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
  });

  /// The snapshot of a runner whose buffers live in [history].
  ///
  /// Both [RunnerApi] implementations answer `snapshot()` through this, so it
  /// is the one place deciding which buffers are copied and how a start time
  /// missing from [StartLogHistory.operationStartTimes] is filled.
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
  );

  final RunnerStage stage;
  final bool isRunning;
  final bool watchModeEnabled;

  /// Whether launching a Flutter app can do anything, which it cannot outside
  /// development.
  ///
  /// Only the runner knows the run mode the stack started with. A client that
  /// guessed would offer a key that silently does nothing.
  final bool canLaunchFlutterApps;

  /// The retained server history, oldest first: log entries and completed
  /// operations, as [encodeLogHistoryItem] writes them.
  final List<Object> serverEntries;

  /// The pod's retained raw output lines, oldest first.
  final List<String> serverLines;

  /// Operations that have started and not finished, with the time each began
  /// so a client can show how long one it did not witness has been running.
  final List<({TrackedOperation operation, DateTime startedAt})>
  activeOperations;

  /// Retained raw output lines per Flutter app id.
  final Map<String, List<String>> flutterLines;

  /// The configured companion apps.
  final List<FlutterAppConfig> flutterApps;

  /// Which of [flutterApps] are running.
  final Set<String> runningFlutterApps;

  /// Which of [flutterApps] are between their spawn and their ready signal.
  final Set<String> launchingFlutterApps;

  /// Where each running app is serving, keyed by app id.
  ///
  /// Carried rather than left to the events. A URL publishes once, when the
  /// app comes up.
  final Map<String, String?> flutterAppUrls;

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
  );
}

/// Encodes the configuration of one companion Flutter app.
///
/// Only what a client renders or addresses the app by. The paths and run
/// arguments stay in the runner, the only process that launches it.
Map<String, Object?> encodeFlutterApp(FlutterAppConfig app) => {
  'id': app.id,
  'name': app.name,
  'autoLaunch': app.autoLaunch,
  if (app.device != null) 'device': app.device,
};

/// Decodes what [encodeFlutterApp] produced.
///
/// Path parts come back empty, since a client never launches an app itself. It
/// asks the runner to.
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
