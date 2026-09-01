import 'dart:async';
import 'dart:io';

import 'package:async/async.dart' show StreamGroup;

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/start/flutter_app_manager.dart';
import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_cli/src/commands/start/watch_session.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/migrations/create_migration_action.dart';
import 'package:serverpod_cli/src/migrations/create_repair_migration_action.dart';
import 'package:serverpod_cli/src/runner/migration_result.dart';
import 'package:serverpod_cli/src/runner/runner_api.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_shared/serverpod_shared.dart'
    show MigrationAbortedException;

/// [RunnerApi] over the in-process watch session, delegating every call to
/// [WatchSession], for surfaces that run inside the runner itself.
class LocalRunnerApi implements InProcessRunnerApi {
  LocalRunnerApi({
    required StartLogHistory logHistory,
    required void Function() requestShutdown,
    required bool watchModeEnabled,
  }) : _logHistory = logHistory,
       _requestShutdown = requestShutdown,
       _watchModeEnabled = watchModeEnabled;

  final StartLogHistory _logHistory;
  final void Function() _requestShutdown;
  final bool _watchModeEnabled;

  /// The stack, null until [bindStack] provides one.
  _Stack? _stack;

  /// Wires the stack this serves.
  ///
  /// Everything that needs one reports [RunnerStartingException] until this
  /// is called. [stop] works throughout.
  void bindStack({
    required WatchSession session,
    required FlutterAppManager flutterManager,
    required GeneratorConfig config,
    required String runMode,
    required String? Function() vmServiceUri,
  }) {
    _stack = _Stack(
      session: session,
      flutterManager: flutterManager,
      config: config,
      runMode: runMode,
      vmServiceUri: vmServiceUri,
    );
  }

  /// The stack, or [RunnerStartingException] naming what could not run.
  _Stack _require(String command) {
    final stack = _stack;
    if (stack == null) throw RunnerStartingException(command);
    return stack;
  }

  /// Raises its own events, stage transitions and Flutter app state, merged
  /// with the ones the log history emits.
  final StreamController<RunnerEvent> _own =
      StreamController<RunnerEvent>.broadcast();

  RunnerStage _stage = RunnerStage.starting;

  @override
  RunnerStage get stage => _stage;

  /// Records that the runner reached [stage] and tells every attached client.
  ///
  /// [exitCode] carries what the runner leaves with on
  /// [RunnerStage.stopping]. The emitted event's running flag follows
  /// [stage], not [isRunning].
  void setStage(RunnerStage stage, {int? exitCode}) {
    if (_stage == stage) return;
    _stage = stage;
    _emit(
      StageChangedEvent(
        stage,
        isRunning: stage == RunnerStage.running,
        exitCode: exitCode,
      ),
    );
  }

  /// Records that [appId] changed state.
  ///
  /// Reads `running` and `launching` from the Flutter manager rather than
  /// taking them as arguments. [launchStage] names what the toolchain is
  /// doing, for the progress a launching app reports.
  void recordFlutterAppState(
    String appId, {
    String? url,
    String? launchStage,
  }) => _emit(
    FlutterAppStateEvent(
      appId: appId,
      running: isFlutterAppRunning(appId),
      launching: isFlutterAppLaunching(appId),
      url: url,
      launchStage: launchStage,
    ),
  );

  /// Records that the set of configured apps changed.
  void recordFlutterApps(List<FlutterAppConfig> apps) =>
      _emit(FlutterAppsChangedEvent(apps));

  /// Records that a published address changed.
  void recordManifest(RunnerManifest manifest) =>
      _emit(ManifestChangedEvent(manifest));

  void _emit(RunnerEvent event) {
    if (!_own.isClosed) _own.add(event);
  }

  /// Everything this runner raises, for every surface that renders it.
  ///
  /// One group, built once and broadcast, merging [_logHistory]'s events
  /// and [_own].
  late final StreamGroup<RunnerEvent> _eventGroup = StreamGroup.broadcast()
    ..add(_logHistory.events)
    ..add(_own.stream);

  @override
  Stream<RunnerEvent> get events => _eventGroup.stream;

  @override
  RunnerSnapshot snapshot() => RunnerSnapshot.from(
    history: _logHistory,
    stage: _stage,
    isRunning: isRunning,
    watchModeEnabled: _watchModeEnabled,
    canLaunchFlutterApps: canLaunchFlutterApps,
    flutterApps: flutterApps,
    launchingFlutterApps: {
      for (final app in flutterApps)
        if (isFlutterAppLaunching(app.id)) app.id,
    },
    runningFlutterApps: {
      for (final app in flutterApps)
        if (isFlutterAppRunning(app.id)) app.id,
    },
    flutterAppUrls: _stack?.flutterManager.appUrls ?? const {},
  );

  /// Stops emitting events.
  ///
  /// The buffers stay readable for a final snapshot.
  @override
  Future<void> close() async {
    await _own.close();
    await _logHistory.close();
    await _eventGroup.close();
  }

  @override
  bool get isRunning => _stack?.session.isRunning ?? false;

  @override
  Future<void> hotReload() => _require('hot reload').session.forceReload();

  @override
  Future<void> hotRestart() => _require('hot restart').session.forceRestart();

  @override
  Future<void> retryStart() =>
      _require('retrying the start').session.retryStart();

  @override
  Future<void> stop() async => _requestShutdown();

  @override
  Future<MigrationResult> createMigration({
    String? tag,
    bool force = false,
  }) async {
    return migrationResultFor(
      await createMigrationAction(
        config: _require('creating a migration').config,
        tag: tag,
        force: force,
      ),
    );
  }

  @override
  Future<MigrationResult> createRepairMigration({
    String? tag,
    bool force = false,
    String? targetVersion,
  }) async {
    final File? file;
    try {
      final stack = _require('creating a repair migration');
      file = await createRepairMigrationAction(
        config: stack.config,
        runMode: stack.runMode,
        tag: tag,
        force: force,
        targetMigrationVersion: targetVersion,
      );
    } on MigrationAbortedException {
      return const MigrationResult(
        message: 'Repair migration aborted due to warnings.',
        isError: true,
        abortedForWarnings: true,
      );
    } on Exception catch (e) {
      return MigrationResult(message: '$e', isError: true);
    }

    if (file == null) {
      return const MigrationResult(
        message: 'Repair migration skipped. No schema drift detected.',
      );
    }

    final versionName = p.basenameWithoutExtension(file.path);
    return MigrationResult(
      message: 'Repair migration "$versionName" created at ${file.path}.',
      created: true,
    );
  }

  @override
  Future<void> applyMigrations() =>
      _require('applying migrations').session.applyMigration();

  @override
  List<FlutterAppConfig> get flutterApps =>
      _stack?.flutterManager.apps.toList() ?? const [];

  @override
  bool isFlutterAppRunning(String appId) =>
      _stack?.flutterManager.isRunning(appId) ?? false;

  @override
  bool isFlutterAppLaunching(String appId) =>
      _stack?.flutterManager.isLaunching(appId) ?? false;

  @override
  bool get canLaunchFlutterApps =>
      _stack?.flutterManager.canLaunchApps ?? false;

  @override
  bool get isAnyFlutterAppRunning =>
      _stack?.session.isFlutterAppRunning ?? false;

  @override
  Future<bool> launchFlutterApp(String appId) =>
      _require('launching an app').session.spawnFlutterApp(appId);

  @override
  Future<void> restartFlutterApp(String appId) =>
      _require('restarting an app').session.relaunchFlutterApp(appId);

  @override
  Future<void> stopFlutterApp(String appId) =>
      _require('stopping an app').session.stopFlutterApp(appId);

  @override
  Future<void> restartFlutterApps() =>
      _require('restarting the apps').session.restartFlutterApp();

  @override
  Map<String, String?> get flutterDtdUris =>
      _stack?.flutterManager.dtdUris ?? const {};

  @override
  List<Object> get logHistory => _logHistory.serverEntries.toList();

  @override
  List<String> flutterLogHistory(String appId) =>
      _logHistory.flutterLinesFor(appId).toList();

  @override
  String? get vmServiceUri => _stack?.vmServiceUri();

  @override
  Stream<void> get vmServiceUriChanges =>
      _stack?.session.vmServiceUriChanges ?? const Stream.empty();
}

/// The collaborators that only exist once the stack is up.
class _Stack {
  _Stack({
    required this.session,
    required this.flutterManager,
    required this.config,
    required this.runMode,
    required this.vmServiceUri,
  });

  final WatchSession session;
  final FlutterAppManager flutterManager;
  final GeneratorConfig config;
  final String runMode;

  /// The VM service proxy's URI, resolved at call time. A degraded start has
  /// no proxy until the server boots.
  final String? Function() vmServiceUri;
}

/// Returns [outcome] as a [MigrationResult].
MigrationResult migrationResultFor(CreateMigrationOutcome outcome) {
  final described = _describe(outcome);
  return MigrationResult(
    message: described.message,
    isError: described.isError,
    abortedForWarnings: _isAborted(outcome),
    created: _isCreated(outcome),
  );
}

/// Whether [outcome] wrote a server migration to disk. The client half
/// does not count.
bool _isCreated(CreateMigrationOutcome outcome) => switch (outcome) {
  CreateMigrationCreated() => true,
  CreateMigrationServerClientCreated(:final serverResult) => _isCreated(
    serverResult,
  ),
  _ => false,
};

/// Whether [outcome] failed only for want of `force`.
bool _isAborted(CreateMigrationOutcome outcome) => switch (outcome) {
  CreateMigrationAborted() => true,
  CreateMigrationServerClientCreated(
    :final serverResult,
    :final clientResult,
  ) =>
    _isAborted(serverResult) || _isAborted(clientResult),
  _ => false,
};

/// Maps a [CreateMigrationOutcome] to a `(message, isError)` pair. The
/// message carries no retry instruction.
({String message, bool isError}) _describe(
  CreateMigrationOutcome outcome, {
  bool isServer = true,
}) {
  final label = '${isServer ? 'Server' : 'Client'} migration';
  return switch (outcome) {
    CreateMigrationCreated(:final versionName, :final migrationDirectory) => (
      message: '$label "$versionName" created at $migrationDirectory.',
      isError: false,
    ),
    CreateMigrationNoChanges() => (
      message: '$label skipped. No changes detected.',
      isError: false,
    ),
    CreateMigrationAborted() => (
      message: '$label aborted due to warnings.',
      isError: true,
    ),
    CreateMigrationFailed(:final message) => (
      message: message,
      isError: true,
    ),
    CreateMigrationServerClientCreated(
      :final serverResult,
      :final clientResult,
    ) =>
      () {
        final serverDescription = _describe(serverResult);
        final clientDescription = _describe(clientResult, isServer: false);
        return (
          message: '${serverDescription.message}\n${clientDescription.message}',
          isError: serverDescription.isError || clientDescription.isError,
        );
      }(),
  };
}
