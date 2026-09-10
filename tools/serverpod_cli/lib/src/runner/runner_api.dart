import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/runner/migration_result.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';

/// Everything the runner can do or report, whoever is asking.
///
/// Commands never prompt. See `docs/design/runner.md#runner-api`.
abstract interface class RunnerApi {
  /// The state a client renders on connect, before applying [events].
  RunnerSnapshot snapshot();

  /// Every change after [snapshot], as a broadcast stream.
  Stream<RunnerEvent> get events;

  /// Stops [events], leaving the snapshot buffers readable for a final render.
  Future<void> close();

  RunnerStage get stage;

  /// Whether the server process is up. False during a degraded start.
  bool get isRunning;

  /// Hot-reloads the server isolate, then every running Flutter app.
  Future<void> hotReload();

  /// Restarts the server process, then hot-restarts every running Flutter app.
  Future<void> hotRestart();

  /// Regenerates, compiles and boots a degraded start's server.
  Future<void> retryStart();

  /// Signals the runner to shut down, without waiting for it to exit.
  Future<void> stop();

  /// Creates a migration from the model definitions, without applying it.
  Future<MigrationResult> createMigration({String? tag, bool force});

  /// Creates a repair migration toward [targetVersion], by default the latest.
  Future<MigrationResult> createRepairMigration({
    String? tag,
    bool force,
    String? targetVersion,
  });

  /// Applies pending migrations without restarting the server.
  Future<void> applyMigrations();

  List<FlutterAppConfig> get flutterApps;

  /// Whether launching an app can do anything, which only development allows.
  bool get canLaunchFlutterApps;

  bool isFlutterAppRunning(String appId);

  bool isFlutterAppLaunching(String appId);

  bool get isAnyFlutterAppRunning;

  /// Launches [appId], completing with whether it was already running.
  Future<bool> launchFlutterApp(String appId);

  /// Stops and relaunches [appId], or launches it when it is not running.
  Future<void> restartFlutterApp(String appId);

  Future<void> stopFlutterApp(String appId);

  /// Relaunches every running app, or launches the first when none runs.
  ///
  /// Unlike [hotRestart], it leaves the server alone and picks up new deps.
  Future<void> restartFlutterApps();
}

/// What a runner offers only to callers in its own process, the MCP server.
abstract interface class InProcessRunnerApi implements RunnerApi {
  /// DTD URIs by running app id, null until an app publishes one.
  Map<String, String?> get flutterDtdUris;

  List<Object> get logHistory;

  List<String> flutterLogHistory(String appId);

  /// The VM service proxy's HTTP URI, null until the server has booted.
  String? get vmServiceUri;

  /// Fires on restart and crash recovery, not on hot reload.
  Stream<void> get vmServiceUriChanges;
}

/// Thrown by a command that needs the stack while the runner is starting.
class RunnerStartingException implements Exception {
  const RunnerStartingException(this.command);

  final String command;

  @override
  String toString() =>
      'The runner is still starting, so $command is not available yet.';
}
