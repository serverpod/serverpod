import 'dart:async';

import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/event_handler.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/start/tui/tab_model.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/runner/migration_result.dart';
import 'package:serverpod_cli/src/runner/runner_client.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Drives a [ServerWatchState] from an attached [RunnerClient].
///
/// See `docs/design/runner.md#division-of-state`.
class RunnerStateBinding {
  RunnerStateBinding({
    required this.client,
    required this.holder,
    required this.onStopRequested,
    this.onRunnerStopped,
  });

  final RunnerClient client;
  final StartAppStateHolder holder;

  /// Called when this client detaches, or its stop request is refused.
  final void Function() onStopRequested;

  /// Called with the exit code the runner announces, not on a lost connection.
  final void Function(int exitCode)? onRunnerStopped;

  final List<StreamSubscription<void>> _subs = [];

  ServerWatchState get _state => holder.state;

  /// Wires the UI to the client's history, actions and events.
  void bind() {
    client.history.attachHolder(holder);

    _bindActions();
    _applyRunnerState();

    _subs.add(client.events.listen(_onEvent));
    _subs.add(
      client.connectionChanges.listen((connected) {
        if (connected) _applyRunnerState();
        holder.markDirty();
      }),
    );
  }

  Future<void> dispose() async {
    for (final sub in _subs) {
      await sub.cancel();
    }
    _subs.clear();
  }

  void _bindActions() {
    _state.isAppRunning = client.isFlutterAppRunning;
    _state.isAppLaunching = client.isFlutterAppLaunching;

    holder.onQuit = onStopRequested;
    holder.onStopStack = () => unawaited(
      client.stop().catchError((Object e) {
        // A refused stop announces nothing, so nothing else ends this session.
        log.error('Stopping the runner failed: $e');
        onStopRequested();
      }),
    );
    holder.onHotReload = () =>
        runTrackedAction(holder, 'Hot reload', client.hotReload);
    holder.onHotRestart = () {
      final running = client.isRunning;
      runTrackedAction(
        holder,
        running ? 'Hot restart' : 'Rebuild & start',
        running ? client.hotRestart : client.retryStart,
        allowWhenStartable: !running,
      );
    };
    holder.onRestartFlutterApp = () => runTrackedAction(
      holder,
      client.isAnyFlutterAppRunning
          ? 'Restart Flutter app'
          : 'Start Flutter app',
      client.restartFlutterApps,
    );
    holder.onApplyMigration = () =>
        runTrackedAction(holder, 'Applying migrations', client.applyMigrations);
    holder.onCreateMigration = ({bool force = false}) => runTrackedAction(
      holder,
      force ? 'Force-creating migration' : 'Creating migration',
      () => _createMigration(
        () => client.createMigration(force: force),
        forceHint: 'Use ⇧+M to force-create it anyway.',
      ),
    );
    holder.onCreateRepairMigration = ({bool force = false}) => runTrackedAction(
      holder,
      force ? 'Force-creating repair migration' : 'Creating repair migration',
      () => _createMigration(
        () => client.createRepairMigration(force: force),
        forceHint: 'Use ⇧+P to force-create it anyway.',
      ),
    );

    holder.onLaunchApp = (index) {
      final app = _appAt(index);
      if (app == null) return;
      final running = client.isFlutterAppRunning(app.id);
      runTrackedAction(
        holder,
        running ? 'Relaunch ${app.name}' : 'Launch ${app.name}',
        () => client.restartFlutterApp(app.id),
      );
    };
    holder.onStopApp = (index) {
      final app = _appAt(index);
      if (app == null) return;
      runTrackedAction(
        holder,
        'Stop ${app.name}',
        () => client.stopFlutterApp(app.id),
      );
    };
  }

  /// Creates and applies a migration, throwing if creating it fails.
  Future<void> _createMigration(
    Future<MigrationResult> Function() create, {
    required String forceHint,
  }) async {
    final result = await create();
    if (result.isError) {
      final hint = result.abortedForWarnings ? ' $forceHint' : '';
      throw Exception('${result.message}$hint');
    }
    log.info(result.message);
    try {
      await client.applyMigrations();
    } catch (e) {
      log.error('The migration was created but not applied: $e');
      log.info('Press A to apply it once the database is reachable.');
    }
  }

  FlutterAppConfig? _appAt(int index) {
    final apps = client.flutterApps;
    if (index < 0 || index >= apps.length) return null;
    return apps[index];
  }

  /// Applies the client's state to the UI on bind and after each reconnect.
  void _applyRunnerState() {
    final isRunning = client.isRunning;
    final stage = client.stage;
    _state.watchModeEnabled = client.watchModeEnabled;
    _state.serverReady = isRunning;
    _state.serverStartable = !isRunning && stage == RunnerStage.degraded;
    _state.showSplash = stage == RunnerStage.starting;
    // The runner may have announced stopping before this binding existed.
    if (stage == RunnerStage.stopping) {
      onRunnerStopped?.call(client.exitCode ?? 0);
    }
    _syncApps(client.flutterApps);
    for (final app in client.flutterApps) {
      final running = client.isFlutterAppRunning(app.id);
      final launching = client.isFlutterAppLaunching(app.id);
      if (!running && !launching && _state.appLogTabFor(app.id) == null) {
        continue;
      }
      _markAppTab(
        app.id,
        running: running,
        launching: launching,
        url: client.flutterAppUrls[app.id],
      );
    }
    holder.markDirty();
  }

  void _onEvent(RunnerEvent event) {
    switch (event) {
      case StageChangedEvent(:final stage, :final isRunning, :final exitCode):
        _state.serverReady = isRunning;
        _state.serverStartable = !isRunning && stage == RunnerStage.degraded;
        if (stage != RunnerStage.starting) _state.showSplash = false;
        if (stage == RunnerStage.stopping) onRunnerStopped?.call(exitCode ?? 0);

      case FlutterAppsChangedEvent(:final apps):
        _syncApps(apps);

      case FlutterAppStateEvent(
        :final appId,
        :final running,
        :final launching,
        :final url,
        :final launchStage,
      ):
        _markAppTab(
          appId,
          running: running,
          launching: launching,
          url: url,
          launchStage: launchStage,
        );

      case ServerLogEvent() ||
          ServerLineEvent() ||
          OperationStartedEvent() ||
          OperationCompletedEvent() ||
          FlutterLineEvent() ||
          FlutterLogEntryEvent() ||
          OperationsDiscardedEvent() ||
          ManifestChangedEvent():
        break;
    }
    holder.markDirty();
  }

  void _syncApps(List<FlutterAppConfig> apps) {
    final ids = {for (final app in apps) app.id};
    for (final existing in _state.launchableApps) {
      if (ids.contains(existing.id)) continue;
      _state.removeAppLogTab(existing.id);
    }
    _state
      ..launchableApps = apps
      ..canLaunchApps = apps.isNotEmpty && client.canLaunchFlutterApps;
    if (apps.isNotEmpty) _state.createAppsTabAreaIfNeeded();
  }

  /// Opens or updates the log tab for [appId].
  void _markAppTab(
    String appId, {
    required bool running,
    required bool launching,
    String? url,
    String? launchStage,
  }) {
    final app = client.flutterApps.where((a) => a.id == appId).firstOrNull;
    final tab = _state.getOrCreateAppLogTab(
      appId: appId,
      label: app?.name ?? appId,
    );
    if (launching &&
        tab.runState != AppRunState.launching &&
        _state.showLaunchPanel) {
      _state.tabs.focusTab(tab);
    }
    tab
      ..runState = running
          ? AppRunState.ready
          : launching
          ? AppRunState.launching
          : AppRunState.stopped
      ..startupStage = launching ? (launchStage ?? tab.startupStage) : null
      ..url = url
      ..device = app?.device;
  }
}
