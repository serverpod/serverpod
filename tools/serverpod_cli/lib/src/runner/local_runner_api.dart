import 'dart:async';
import 'dart:io';

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
import 'package:serverpod_shared/serverpod_shared.dart'
    show MigrationAbortedException;

/// [RunnerApi] over the in-process watch session, delegating every call to
/// [WatchSession], for surfaces that run inside the runner itself.
class LocalRunnerApi implements InProcessRunnerApi {
  LocalRunnerApi({
    required WatchSession session,
    required FlutterAppManager flutterManager,
    required StartLogHistory logHistory,
    required GeneratorConfig config,
    required String runMode,
    required String? Function() vmServiceUri,
    required void Function() requestShutdown,
  }) : _session = session,
       _flutterManager = flutterManager,
       _logHistory = logHistory,
       _config = config,
       _runMode = runMode,
       _vmServiceUri = vmServiceUri,
       _requestShutdown = requestShutdown;

  final WatchSession _session;
  final FlutterAppManager _flutterManager;
  final StartLogHistory _logHistory;
  final GeneratorConfig _config;
  final String _runMode;

  /// Resolved at call time rather than held: a degraded start has no proxy
  /// until the server first boots.
  final String? Function() _vmServiceUri;

  final void Function() _requestShutdown;

  @override
  bool get isRunning => _session.isRunning;

  @override
  Future<void> hotReload() => _session.forceReload();

  @override
  Future<void> hotRestart() => _session.forceRestart();

  @override
  Future<void> retryStart() => _session.retryStart();

  @override
  Future<void> stop() async => _requestShutdown();

  @override
  Future<MigrationResult> createMigration({
    String? tag,
    bool force = false,
  }) async {
    return migrationResultFor(
      await createMigrationAction(config: _config, tag: tag, force: force),
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
      file = await createRepairMigrationAction(
        config: _config,
        runMode: _runMode,
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
  Future<void> applyMigrations() => _session.applyMigration();

  @override
  List<FlutterAppConfig> get flutterApps => _flutterManager.apps.toList();

  @override
  bool isFlutterAppRunning(String appId) => _flutterManager.isRunning(appId);

  @override
  bool isFlutterAppLaunching(String appId) =>
      _flutterManager.isLaunching(appId);

  @override
  bool get isAnyFlutterAppRunning => _session.isFlutterAppRunning;

  @override
  Future<bool> launchFlutterApp(String appId) =>
      _session.spawnFlutterApp(appId);

  @override
  Future<void> restartFlutterApp(String appId) =>
      _session.relaunchFlutterApp(appId);

  @override
  Future<void> stopFlutterApp(String appId) => _session.stopFlutterApp(appId);

  @override
  Future<void> restartFlutterApps() => _session.restartFlutterApp();

  @override
  Map<String, String?> get flutterDtdUris => _flutterManager.dtdUris;

  @override
  List<Object> get logHistory => _logHistory.serverEntries.toList();

  @override
  List<String> flutterLogHistory(String appId) =>
      _logHistory.flutterLinesFor(appId).toList();

  @override
  String? get vmServiceUri => _vmServiceUri();

  @override
  Stream<void> get vmServiceUriChanges => _session.vmServiceUriChanges;
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
