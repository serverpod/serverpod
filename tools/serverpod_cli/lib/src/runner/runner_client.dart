import 'dart:async';
import 'dart:io';

import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:serverpod_cli/src/runner/migration_result.dart';
import 'package:serverpod_cli/src/runner/runner_api.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_cli/src/runner/runner_socket_server.dart';
import 'package:serverpod_shared/serverpod_shared.dart' show connectUnixSocket;

/// Thrown when the runner cannot be reached.
class RunnerUnreachableException implements Exception {
  const RunnerUnreachableException(this.socketPath);

  final String socketPath;

  @override
  String toString() =>
      'No serverpod runner is listening at $socketPath. '
      'Start one with `serverpod start`.';
}

/// A [RunnerApi] for a runner in another process, mirrored into [history].
class RunnerClient implements RunnerApi {
  RunnerClient({
    required this.socketPath,
    StartLogHistory? history,
    Duration reconnectDelay = const Duration(milliseconds: 250),
    Duration? reconnectDeadline,
  }) : history = history ?? StartLogHistory(),
       _reconnectDelay = reconnectDelay,
       _reconnectDeadline = reconnectDeadline;

  final String socketPath;

  final Duration _reconnectDelay;

  /// How long to reconnect before the runner is [gone], or forever if null.
  final Duration? _reconnectDeadline;

  /// The buffers a renderer reads, kept current from the snapshot and events.
  final StartLogHistory history;

  final StreamController<RunnerEvent> _events =
      StreamController<RunnerEvent>.broadcast();
  final StreamController<bool> _connectionChanges =
      StreamController<bool>.broadcast();

  json_rpc.Peer? _peer;
  Socket? _socket;

  /// Whether this client takes snapshots and reconnects, until [gone].
  bool _attached = false;

  /// Events held while a snapshot request is in flight, then applied.
  List<RunnerEvent>? _heldEvents;
  bool _closed = false;
  final Completer<void> _gone = Completer<void>();

  RunnerStage _stage = RunnerStage.starting;
  int? _exitCode;
  bool _isRunning = false;
  bool _watchModeEnabled = false;
  bool _canLaunchFlutterApps = false;
  List<FlutterAppConfig> _flutterApps = const [];
  Set<String> _runningApps = {};
  Set<String> _launchingApps = {};
  final Map<String, String?> _appUrls = {};

  /// Completes once the runner stays unreachable past the reconnect deadline.
  ///
  /// A runner that stops normally announces it, so this means a kill or abort.
  Future<void> get gone => _gone.future;

  /// `true` after each connect's snapshot, `false` on losing the runner.
  ///
  /// A snapshot moves every scalar with no event, so recompute derived values.
  Stream<bool> get connectionChanges => _connectionChanges.stream;

  /// The last known URL of each Flutter app by id, or null for a stopped app.
  Map<String, String?> get flutterAppUrls => Map.unmodifiable(_appUrls);

  /// Connects for commands only, with no snapshot and no reconnect.
  ///
  /// Requesting a snapshot would arm the runner's Flutter auto-launch.
  Future<void> connect() async {
    if (!await _connectOnce()) throw RunnerUnreachableException(socketPath);
  }

  /// Connects, loads the snapshot, and reconnects until [close] or [gone].
  ///
  /// [waitFor] retries the first connection, which otherwise fails at once.
  Future<void> attach({Duration? waitFor}) async {
    _attached = true;
    if (waitFor == null) {
      await connect();
      return;
    }
    final waited = Stopwatch()..start();
    while (!await _connectOnce()) {
      if (_closed) return;
      if (waited.elapsed > waitFor) {
        throw RunnerUnreachableException(socketPath);
      }
      await Future<void>.delayed(_reconnectDelay);
    }
  }

  /// Detaches without stopping the runner.
  @override
  Future<void> close() async {
    _closed = true;
    final peer = _peer;
    _peer = null;
    try {
      await peer?.close();
    } catch (_) {}
    _socket?.destroy();
    _socket = null;
    await _events.close();
    await _connectionChanges.close();
  }

  Future<bool> _connectOnce() async {
    if (_closed) return false;
    final Socket socket;
    try {
      socket = await connectUnixSocket(
        socketPath,
        timeout: const Duration(seconds: 2),
      );
    } catch (_) {
      return false;
    }
    if (_closed) {
      socket.destroy();
      return false;
    }

    final peer = json_rpc.Peer(socketChannel(socket));
    peer.registerMethod(runnerEventNotification, (json_rpc.Parameters params) {
      final event = RunnerEvent.fromJson(
        Map<String, Object?>.from(params.value as Map),
      );
      if (event != null) _apply(event);
    });
    _socket = socket;
    unawaited(_listenUntilClosed(peer));

    if (_attached) {
      final held = <RunnerEvent>[];
      _heldEvents = held;
      try {
        _applySnapshot(
          RunnerSnapshot.fromJson(
            Map<String, Object?>.from(
              await peer.sendRequest(
                    runnerSnapshotMethod,
                    const <String, Object?>{},
                  )
                  as Map,
            ),
          ),
        );
      } catch (_) {
        _heldEvents = null;
        await peer.close();
        if (identical(_socket, socket)) _socket = null;
        socket.destroy();
        return false;
      }
      _heldEvents = null;
      if (_closed) {
        await peer.close();
        if (identical(_socket, socket)) _socket = null;
        socket.destroy();
        return false;
      }
      for (final event in held) {
        _apply(event);
      }
    }

    _peer = peer;
    if (!_connectionChanges.isClosed) _connectionChanges.add(true);
    return true;
  }

  /// Runs [peer] and reports its disconnect if it is still the current [_peer].
  ///
  /// Listening precedes the snapshot request, so a failed handshake ends here
  /// too, and reporting it would race the caller's own retry.
  Future<void> _listenUntilClosed(json_rpc.Peer peer) async {
    try {
      await peer.listen();
    } catch (_) {
    } finally {
      if (identical(_peer, peer)) _onDisconnected();
    }
  }

  void _onDisconnected() {
    if (_closed) return;
    _peer = null;
    _socket = null;
    if (!_connectionChanges.isClosed) _connectionChanges.add(false);
    if (_attached) unawaited(_reconnect());
  }

  Future<void> _reconnect() async {
    final deadline = _reconnectDeadline;
    final lost = Stopwatch()..start();
    while (!_closed && _peer == null) {
      await Future<void>.delayed(_reconnectDelay);
      if (_closed) return;
      if (await _connectOnce()) return;
      if (deadline != null && lost.elapsed > deadline) {
        _attached = false;
        if (!_gone.isCompleted) _gone.complete();
        return;
      }
    }
  }

  /// Replaces scalars and history, since a reconnect may reach a new runner.
  void _applySnapshot(RunnerSnapshot snapshot) {
    _stage = snapshot.stage;
    _exitCode = snapshot.exitCode;
    _isRunning = snapshot.isRunning;
    _watchModeEnabled = snapshot.watchModeEnabled;
    _canLaunchFlutterApps = snapshot.canLaunchFlutterApps;
    _flutterApps = snapshot.flutterApps;
    _runningApps = {...snapshot.runningFlutterApps};
    _launchingApps = {...snapshot.launchingFlutterApps};
    _appUrls
      ..clear()
      ..addAll(snapshot.flutterAppUrls);

    history.serverEntries
      ..clear()
      ..addAll(snapshot.serverEntries);
    history.serverLines
      ..clear()
      ..addAll(snapshot.serverLines);
    history.activeOperations.clear();
    history.operationStartTimes.clear();
    for (final active in snapshot.activeOperations) {
      history.activeOperations[active.operation.id] = active.operation;
      history.operationStartTimes[active.operation.id] = active.startedAt;
    }
    history.replaceFlutterLines(snapshot.flutterLines);
    _markChanged();
  }

  void _apply(RunnerEvent event) {
    final held = _heldEvents;
    if (held != null) {
      held.add(event);
      return;
    }
    switch (event) {
      case ServerLogEvent(:final entry):
        history.serverEntries.add(entry);
        history.onServerEntry?.call(entry);

      case OperationStartedEvent(:final operation, :final startedAt):
        history.activeOperations[operation.id] = operation;
        history.operationStartTimes[operation.id] = startedAt;

      case OperationCompletedEvent(:final operation, :final id):
        history.activeOperations.remove(id);
        history.operationStartTimes.remove(id);
        history.serverEntries.add(operation);

      case ServerLineEvent(:final line):
        history.serverLines.add(line);

      case FlutterLineEvent(:final appId, :final line):
        history.flutterLinesFor(appId).add(line);

      case FlutterLogEntryEvent(
        :final appId,
        :final entry,
        :final appendedToLines,
      ):
        if (appendedToLines) history.addFlutterEntryLines(appId, entry);
        history.onFlutterEntry?.call(appId, entry);

      case StageChangedEvent(:final stage, :final exitCode):
        _stage = stage;
        if (exitCode != null) _exitCode = exitCode;
        _isRunning = stage == RunnerStage.running;

      case FlutterAppsChangedEvent(:final apps):
        _flutterApps = apps;

      case FlutterAppStateEvent(
        :final appId,
        :final running,
        :final launching,
        :final url,
      ):
        if (running) {
          _runningApps.add(appId);
        } else {
          _runningApps.remove(appId);
        }
        if (launching) {
          _launchingApps.add(appId);
        } else {
          _launchingApps.remove(appId);
        }
        // A running app's progress update has no URL, so keep the last.
        _appUrls[appId] = url ?? (running ? _appUrls[appId] : null);

      case OperationsDiscardedEvent(:final ids):
        for (final id in ids) {
          history.activeOperations.remove(id);
          history.operationStartTimes.remove(id);
        }

      case ManifestChangedEvent():
        break;
    }

    if (!_events.isClosed) _events.add(event);
    _markChanged();
  }

  /// Calls [StartLogHistory.onChanged], which direct buffer writes skip.
  void _markChanged() => history.onChanged?.call();

  /// Sends [method], or throws [RunnerUnreachableException] when detached.
  Future<Object?> _send(String method, [Map<String, Object?>? params]) async {
    final peer = _peer;
    if (peer == null) throw RunnerUnreachableException(socketPath);
    return peer.sendRequest(method, params ?? const <String, Object?>{});
  }

  @override
  RunnerStage get stage => _stage;

  /// The exit code the runner named on reaching [RunnerStage.stopping].
  int? get exitCode => _exitCode;

  @override
  bool get isRunning => _isRunning;

  @override
  RunnerSnapshot snapshot() => RunnerSnapshot.from(
    history: history,
    stage: _stage,
    isRunning: _isRunning,
    watchModeEnabled: _watchModeEnabled,
    canLaunchFlutterApps: _canLaunchFlutterApps,
    flutterApps: _flutterApps,
    runningFlutterApps: _runningApps,
    launchingFlutterApps: _launchingApps,
    flutterAppUrls: _appUrls,
    exitCode: _exitCode,
  );

  @override
  Stream<RunnerEvent> get events => _events.stream;

  @override
  Future<void> hotReload() => _send('hotReload');

  @override
  Future<void> hotRestart() => _send('hotRestart');

  @override
  Future<void> retryStart() => _send('retryStart');

  @override
  Future<void> stop() => _send('stop');

  @override
  Future<void> applyMigrations() => _send('applyMigrations');

  @override
  Future<MigrationResult> createMigration({String? tag, bool force = false}) =>
      _send('createMigration', {
        'tag': ?tag,
        'force': force,
      }).then(_migrationResult);

  @override
  Future<MigrationResult> createRepairMigration({
    String? tag,
    bool force = false,
    String? targetVersion,
  }) => _send('createRepairMigration', {
    'tag': ?tag,
    'force': force,
    'targetVersion': ?targetVersion,
  }).then(_migrationResult);

  @override
  List<FlutterAppConfig> get flutterApps => _flutterApps;

  @override
  bool isFlutterAppRunning(String appId) => _runningApps.contains(appId);

  @override
  bool get canLaunchFlutterApps => _canLaunchFlutterApps;

  bool get watchModeEnabled => _watchModeEnabled;

  @override
  bool isFlutterAppLaunching(String appId) => _launchingApps.contains(appId);

  @override
  bool get isAnyFlutterAppRunning => _runningApps.isNotEmpty;

  @override
  Future<bool> launchFlutterApp(String appId) =>
      _send('launchFlutterApp', {'appId': appId}).then(
        (result) => (result as Map?)?['alreadyRunning'] as bool? ?? false,
      );

  @override
  Future<void> restartFlutterApp(String appId) =>
      _send('restartFlutterApp', {'appId': appId});

  @override
  Future<void> stopFlutterApp(String appId) =>
      _send('stopFlutterApp', {'appId': appId});

  @override
  Future<void> restartFlutterApps() => _send('restartFlutterApps');
}

MigrationResult _migrationResult(Object? result) => MigrationResult.fromJson(
  Map<String, Object?>.from(result as Map? ?? const {}),
);
