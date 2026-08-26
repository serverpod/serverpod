import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/runner/migration_result.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';

/// Everything the runner can do or report, independent of who is asking.
///
/// The runner is the long-lived `serverpod start` process. This interface is
/// implemented once, over the watch session, and projected by every surface.
///
/// It never prompts. An interactive decision, such as confirming a migration
/// that has warnings, is a parameter, and a command missing one fails and says
/// so. Every command stays answerable with no client attached.
///
/// Conflicting commands are serialized, so overlapping migrations or reloads
/// from two callers are well-defined rather than racy.
abstract interface class RunnerApi {
  /// Everything a client needs on connect: the bounded history, the operations
  /// in flight, the per-app Flutter buffers, and the current startup stage.
  ///
  /// A client renders this first, then applies [events], so one attaching to a
  /// runner that has been up for hours sees the whole picture.
  RunnerSnapshot snapshot();

  /// Everything after [snapshot].
  ///
  /// Broadcast. Several clients can attach.
  Stream<RunnerEvent> get events;

  /// Releases this surface. Stops emitting on [events] and closes whatever
  /// backs it.
  ///
  /// The buffers a snapshot reads stay readable afterwards, so a final render
  /// during teardown still shows what happened.
  Future<void> close();

  /// How far the runner has got.
  RunnerStage get stage;

  /// Whether the server process is up.
  ///
  /// False during a degraded start, where the project failed to generate or
  /// compile and [retryStart] is the way back.
  bool get isRunning;

  /// Recompiles and hot-reloads the running server isolate, preserving
  /// in-memory state, then reloads every running Flutter app.
  Future<void> hotReload();

  /// Restarts the server process, dropping in-memory state, then hot-restarts
  /// every running Flutter app.
  Future<void> hotRestart();

  /// Recovers from a degraded start. Regenerates, then compiles and boots the
  /// server.
  ///
  /// A no-op once a server is running.
  Future<void> retryStart();

  /// Signals the runner to shut down, without waiting for it to finish
  /// exiting.
  Future<void> stop();

  /// Creates a migration from the current model definitions, without applying
  /// it.
  Future<MigrationResult> createMigration({String? tag, bool force});

  /// Creates a repair migration bringing the live database in line with
  /// [targetVersion], defaulting to the latest migration version.
  Future<MigrationResult> createRepairMigration({
    String? tag,
    bool force,
    String? targetVersion,
  });

  /// Applies pending database migrations without restarting the server.
  Future<void> applyMigrations();

  /// The configured companion Flutter apps.
  ///
  /// Id-keyed throughout. Tab indices belong to the UI, not to the runner.
  List<FlutterAppConfig> get flutterApps;

  /// Whether launching one of [flutterApps] can do anything.
  ///
  /// False outside development, where the launcher declines. Reported rather
  /// than left for a client to infer, so a UI does not offer a key that
  /// silently does nothing.
  bool get canLaunchFlutterApps;

  /// Whether [appId] is running.
  bool isFlutterAppRunning(String appId);

  /// Whether [appId] is starting up.
  bool isFlutterAppLaunching(String appId);

  /// Whether any configured app is running.
  bool get isAnyFlutterAppRunning;

  /// Launches [appId] unless it is already running.
  ///
  /// Completes with `true` when the app was already running and no process was
  /// spawned, `false` when a launch was started.
  Future<bool> launchFlutterApp(String appId);

  /// Relaunches [appId]: stops and starts it when running, launches it when
  /// stopped.
  Future<void> restartFlutterApp(String appId);

  /// Stops [appId] without relaunching.
  Future<void> stopFlutterApp(String appId);

  /// Fully relaunches every running Flutter app, or launches the first
  /// configured one when none is running.
  ///
  /// Unlike the Flutter hot restart bundled into [hotRestart], this drives only
  /// the Flutter processes, so it picks up new dependencies.
  Future<void> restartFlutterApps();
}

/// What a runner offers only to callers running inside it.
///
/// These read live in-process state the attach protocol does not carry, such
/// as the VM service proxy in front of the pod and the Flutter manager's DTD
/// URIs. The MCP server, which always runs in the runner, is the only caller.
abstract interface class InProcessRunnerApi implements RunnerApi {
  /// Dart Tooling Daemon URIs keyed by launched app id.
  ///
  /// Unlaunched apps are absent. A launched app that has not published its DTD
  /// yet maps to null.
  Map<String, String?> get flutterDtdUris;

  /// The retained server log history, oldest first.
  List<Object> get logHistory;

  /// The retained raw output lines of the Flutter app [appId], oldest first.
  List<String> flutterLogHistory(String appId);

  /// The HTTP URI of the VM service proxy in front of the pod, or `null`
  /// before the server has booted.
  String? get vmServiceUri;

  /// Fires whenever [vmServiceUri] changes, which happens on restart and on
  /// crash recovery but not on hot reload.
  Stream<void> get vmServiceUriChanges;
}

/// Thrown by every command a runner cannot serve until its stack is up.
///
/// The runner binds its attach socket before it has a stack. Everything
/// that needs the stack reports this until then. `stop` works throughout.
class RunnerStartingException implements Exception {
  const RunnerStartingException(this.command);

  final String command;

  @override
  String toString() =>
      'The runner is still starting; $command is not available yet.';
}
