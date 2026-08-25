import 'dart:async';

import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/runner/migration_result.dart';
import 'package:serverpod_cli/src/runner/runner_api.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_tui/serverpod_tui.dart' show TrackedOperation;

/// A [RunnerApi] whose every member is a settable field, so a test overrides
/// only the capability it exercises.
///
/// Defaults are inert: commands succeed and do nothing, collections are empty.
class FakeRunnerApi implements InProcessRunnerApi {
  @override
  bool isRunning = true;

  @override
  RunnerStage stage = RunnerStage.running;

  bool watchModeEnabled = true;

  @override
  bool canLaunchFlutterApps = true;

  List<String> serverLines = const [];

  final StreamController<RunnerEvent> eventController =
      StreamController<RunnerEvent>.broadcast();

  @override
  Stream<RunnerEvent> get events => eventController.stream;

  /// Pushes [event] to every attached client.
  void emit(RunnerEvent event) => eventController.add(event);

  @override
  Future<void> close() => eventController.close();

  @override
  RunnerSnapshot snapshot() {
    snapshotCalls++;
    return _snapshot();
  }

  /// How many times a client has asked for the snapshot, which is what marks
  /// one as a UI rather than a one-shot command.
  int snapshotCalls = 0;

  RunnerSnapshot _snapshot() => RunnerSnapshot(
    stage: stage,
    isRunning: isRunning,
    watchModeEnabled: watchModeEnabled,
    canLaunchFlutterApps: canLaunchFlutterApps,
    serverLines: serverLines,
    serverEntries: logHistory,
    activeOperations: activeOperations,
    flutterLines: flutterLogs,
    flutterApps: flutterApps,
    runningFlutterApps: runningFlutterApps,
  );

  List<({TrackedOperation operation, DateTime startedAt})> activeOperations =
      const [];

  Future<void> Function() onHotReload = () async {};
  Future<void> Function() onHotRestart = () async {};
  Future<void> Function() onRetryStart = () async {};
  Future<void> Function() onStop = () async {};
  Future<void> Function() onApplyMigrations = () async {};

  Future<MigrationResult> Function({String? tag, bool force})
  onCreateMigration = ({String? tag, bool force = false}) async =>
      const MigrationResult(message: 'Migration created.', created: true);

  Future<MigrationResult> Function({
    String? tag,
    bool force,
    String? targetVersion,
  })
  onCreateRepairMigration =
      ({String? tag, bool force = false, String? targetVersion}) async =>
          const MigrationResult(
            message: 'Repair migration created.',
            created: true,
          );

  @override
  List<FlutterAppConfig> flutterApps = const [];

  /// Sets [flutterApps] to stub configs with these ids, for tests that care
  /// about app resolution rather than app configuration.
  set flutterAppIds(List<String> ids) => flutterApps = [
    for (final id in ids)
      FlutterAppConfig(
        id: id,
        name: id,
        relativePathParts: const [],
        serverPackageDirectoryPathParts: const [],
      ),
  ];

  Set<String> runningFlutterApps = {};
  Set<String> launchingFlutterApps = {};
  Map<String, String?> flutterAppUrls = const {};

  Future<bool> Function(String appId) onLaunchFlutterApp = (_) async => false;
  Future<void> Function(String appId) onRestartFlutterApp = (_) async {};
  Future<void> Function(String appId) onStopFlutterApp = (_) async {};
  Future<void> Function() onRestartFlutterApps = () async {};

  @override
  Map<String, String?> flutterDtdUris = const {};

  @override
  List<Object> logHistory = const [];

  Map<String, List<String>> flutterLogs = const {};

  @override
  String? vmServiceUri;

  final StreamController<void> vmServiceUriChangesController =
      StreamController<void>.broadcast();

  @override
  Future<void> hotReload() => onHotReload();

  @override
  Future<void> hotRestart() => onHotRestart();

  @override
  Future<void> retryStart() => onRetryStart();

  @override
  Future<void> stop() => onStop();

  @override
  Future<MigrationResult> createMigration({String? tag, bool force = false}) =>
      onCreateMigration(tag: tag, force: force);

  @override
  Future<MigrationResult> createRepairMigration({
    String? tag,
    bool force = false,
    String? targetVersion,
  }) => onCreateRepairMigration(
    tag: tag,
    force: force,
    targetVersion: targetVersion,
  );

  @override
  Future<void> applyMigrations() => onApplyMigrations();

  @override
  bool isFlutterAppRunning(String appId) => runningFlutterApps.contains(appId);

  @override
  bool isFlutterAppLaunching(String appId) =>
      launchingFlutterApps.contains(appId);

  @override
  bool get isAnyFlutterAppRunning => runningFlutterApps.isNotEmpty;

  @override
  Future<bool> launchFlutterApp(String appId) => onLaunchFlutterApp(appId);

  @override
  Future<void> restartFlutterApp(String appId) => onRestartFlutterApp(appId);

  @override
  Future<void> stopFlutterApp(String appId) => onStopFlutterApp(appId);

  @override
  Future<void> restartFlutterApps() => onRestartFlutterApps();

  @override
  List<String> flutterLogHistory(String appId) =>
      flutterLogs[appId] ?? const [];

  @override
  Stream<void> get vmServiceUriChanges => vmServiceUriChangesController.stream;
}
