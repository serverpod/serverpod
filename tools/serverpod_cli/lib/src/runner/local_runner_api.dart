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

/// [InProcessRunnerApi] over the in-process watch session and its
/// collaborators, for callers running inside the runner.
class LocalRunnerApi implements InProcessRunnerApi {
  LocalRunnerApi({
    required StartLogHistory logHistory,
    required void Function() requestShutdown,
    required bool watchModeEnabled,
    required String runMode,
  }) : _logHistory = logHistory,
       _requestShutdown = requestShutdown,
       _watchModeEnabled = watchModeEnabled,
       _runMode = runMode;

  final StartLogHistory _logHistory;
  final void Function() _requestShutdown;
  final bool _watchModeEnabled;
  final String _runMode;

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
    required String? Function() vmServiceUri,
  }) {
    _stack = _Stack(
      session: session,
      flutterManager: flutterManager,
      config: config,
      vmServiceUri: vmServiceUri,
    );
  }

  /// The stack, or [RunnerStartingException] naming what could not run.
  _Stack _require(String command) {
    final stack = _stack;
    if (stack == null) throw RunnerStartingException(command);
    return stack;
  }

  /// Stage transitions and Flutter app state, merged with the log history's
  /// events in [_eventGroup].
  final StreamController<RunnerEvent> _own =
      StreamController<RunnerEvent>.broadcast();

  RunnerStage _stage = RunnerStage.starting;
  int? _exitCode;

  @override
  RunnerStage get stage => _stage;

  /// Records that the runner reached [stage] and tells every attached client.
  ///
  /// [exitCode] carries what the runner leaves with on
  /// [RunnerStage.stopping]. The emitted event's running flag follows
  /// [stage], not [isRunning].
  ///
  /// An unchanged stage is announced anyway when it carries an exit code: that
  /// is the only thing telling an attached client why the runner is leaving,
  /// and a stage that was already published would otherwise swallow it.
  void setStage(RunnerStage stage, {int? exitCode}) {
    if (_stage == stage && exitCode == null) return;
    _stage = stage;
    if (exitCode != null) _exitCode = exitCode;
    _emit(
      StageChangedEvent(
        stage,
        exitCode: exitCode,
      ),
    );
  }

  /// Records that [appId] changed state.
  ///
  /// Reads `running`, `launching` and the URL from the Flutter manager rather
  /// than taking them as arguments. [launchStage] names what the toolchain is
  /// doing, for the progress a launching app reports.
  ///
  /// [url] is what the caller has just learned, falling back to the manager's.
  /// An omitted URL means the caller is reporting none, not that there is none.
  void recordFlutterAppState(
    String appId, {
    String? url,
    String? launchStage,
  }) => _emit(
    FlutterAppStateEvent(
      appId: appId,
      running: isFlutterAppRunning(appId) && !isFlutterAppLaunching(appId),
      launching: isFlutterAppLaunching(appId),
      url: url ?? _stack?.flutterManager.appUrls[appId],
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
    exitCode: _exitCode,
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
        if (isFlutterAppRunning(app.id) && !isFlutterAppLaunching(app.id))
          app.id,
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
    try {
      final stack = _require('creating a migration');
      return migrationResultFor(
        await stack.session.runSerialized(
          () => createMigrationAction(
            config: stack.config,
            tag: tag,
            force: force,
          ),
        ),
      );
    } on MigrationAbortedException {
      return const MigrationResult(
        message: 'Migration aborted due to warnings.',
        isError: true,
        abortedForWarnings: true,
      );
    } on Exception catch (e) {
      return MigrationResult(message: '$e', isError: true);
    }
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
      file = await stack.session.runSerialized(
        () => createRepairMigrationAction(
          config: stack.config,
          runMode: _runMode,
          tag: tag,
          force: force,
          targetMigrationVersion: targetVersion,
        ),
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

  // The run mode alone decides it, so it is known before the stack is, and the
  // snapshot a client attaches with already carries the final value.
  @override
  bool get canLaunchFlutterApps => FlutterAppManager.canLaunchAppsIn(_runMode);

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
    required this.vmServiceUri,
  });

  final WatchSession session;
  final FlutterAppManager flutterManager;
  final GeneratorConfig config;

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

/// Whether [outcome] wrote a server migration to disk.
///
/// The client half does not count.
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

/// Maps [outcome] to a `(message, isError)` pair.
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
