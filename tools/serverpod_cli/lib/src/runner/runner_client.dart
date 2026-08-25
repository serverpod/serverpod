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

/// A [RunnerApi] backed by a runner in another process.
///
/// Materializes the snapshot into a local [StartLogHistory] and keeps it
/// current from the event stream, so a renderer reads the same buffers either
/// way. Commands are forwarded over JSON-RPC.
///
/// Reconnects when the runner restarts, a detached runner outliving any one
/// client.
class RunnerClient implements RunnerApi {
  RunnerClient({
    required this.socketPath,
    StartLogHistory? history,
    Duration reconnectDelay = const Duration(milliseconds: 250),
    Duration? reconnectDeadline,
  }) : history = history ?? StartLogHistory(),
       _reconnectDelay = reconnectDelay,
       _reconnectDeadline = reconnectDeadline;

  /// The runner's attach socket.
  final String socketPath;

  final Duration _reconnectDelay;

  /// How long to keep reconnecting before declaring the runner [gone].
  ///
  /// Null keeps trying forever, which suits a UI a user can detach at will. A
  /// caller with nobody watching, such as a CI log stream, passes a bound.
  final Duration? _reconnectDeadline;

  /// The buffers a renderer reads.
  ///
  /// Filled from the snapshot, then kept current from events. A renderer that
  /// already owns a history passes it in.
  final StartLogHistory history;

  final StreamController<RunnerEvent> _events =
      StreamController<RunnerEvent>.broadcast();
  final StreamController<bool> _connectionChanges =
      StreamController<bool>.broadcast();

  json_rpc.Peer? _peer;
  Socket? _socket;

  /// Whether this client is a UI rather than a one-shot command.
  ///
  /// Set by [attach]. Gates both the snapshot request and the reconnect loop.
  bool _attached = false;

  /// Events received while a snapshot request is in flight, replayed once
  /// applied.
  ///
  /// Null when none is outstanding.
  List<RunnerEvent>? _heldEvents;
  bool _closed = false;
  final Completer<void> _gone = Completer<void>();

  RunnerStage _stage = RunnerStage.starting;
  bool _isRunning = false;
  bool _watchModeEnabled = false;
  bool _canLaunchFlutterApps = false;
  List<FlutterAppConfig> _flutterApps = const [];
  Set<String> _runningApps = {};
  final Map<String, String?> _appUrls = {};

  /// Whether a connection to the runner is open.
  bool get isConnected => _peer != null;

  /// Completes when the runner stopped answering for longer than the
  /// reconnect deadline this client was given.
  ///
  /// Never completes without a deadline. The runner is not coming back, either
  /// killed outright or aborted before it could announce it was stopping.
  Future<void> get gone => _gone.future;

  /// Fires with `true` when the client attaches and `false` when it loses
  /// the runner.
  Stream<bool> get connectionChanges => _connectionChanges.stream;

  /// The Flutter app URLs seen so far, keyed by app id.
  Map<String, String?> get flutterAppUrls => Map.unmodifiable(_appUrls);

  /// Opens a connection to issue commands on, nothing more.
  ///
  /// No snapshot, no reconnect: `serverpod stop` sends one command and expects
  /// the runner to go away under it. Asking for the snapshot is what marks a
  /// client as a UI - it is what arms the Flutter auto-launch - so a command
  /// that is not a UI must not ask for one.
  ///
  /// Throws [RunnerUnreachableException] when nothing is listening.
  Future<void> connect() async {
    if (!await _connectOnce()) throw RunnerUnreachableException(socketPath);
  }

  /// Connects, loads the first snapshot, and keeps reconnecting for as long as
  /// this client lives.
  ///
  /// What a renderer calls. The snapshot request tells the runner a UI has
  /// arrived; the reconnect loop is what lets a client outlive a runner
  /// restart, which a one-shot command has no use for.
  Future<void> attach() async {
    _attached = true;
    await connect();
  }

  /// Detaches. Never stops the runner: that is `serverpod stop`, or `⇧+Q`
  /// in the UI.
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

  /// Runs [peer] until the runner goes away, then starts reconnecting.
  ///
  /// A runner shutting down mid-message ends the peer with an error, which is
  /// the ordinary way a `serverpod stop` reaches an attached client.
  ///
  /// Only the peer this client is on reports a disconnect. Listening starts
  /// before the snapshot request, since `sendRequest` needs it to pump the
  /// response, so a peer whose handshake failed ends here too. Reporting that
  /// as a lost connection would start a reconnect loop beside the caller's own
  /// retry.
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
    final deadline = _reconnectDeadline == null
        ? null
        : DateTime.now().add(_reconnectDeadline);
    while (!_closed && _peer == null) {
      await Future<void>.delayed(_reconnectDelay);
      if (_closed) return;
      if (await _connectOnce()) return;
      if (deadline != null && DateTime.now().isAfter(deadline)) {
        _attached = false;
        if (!_gone.isCompleted) _gone.complete();
        return;
      }
    }
  }

  /// Replaces the local state with the runner's.
  void _applySnapshot(RunnerSnapshot snapshot) {
    _stage = snapshot.stage;
    _isRunning = snapshot.isRunning;
    _watchModeEnabled = snapshot.watchModeEnabled;
    _canLaunchFlutterApps = snapshot.canLaunchFlutterApps;
    _flutterApps = snapshot.flutterApps;
    _runningApps = {...snapshot.runningFlutterApps};

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

      case OperationCompletedEvent(:final operation):
        history.activeOperations.removeWhere(
          (_, active) => active.label == operation.label,
        );
        history.operationStartTimes.removeWhere(
          (id, _) => !history.activeOperations.containsKey(id),
        );
        history.serverEntries.add(operation);

      case ServerLineEvent(:final line, :final duplicatesEntry):
        history.serverLines.add(line);
        if (!duplicatesEntry) history.serverEntries.add(line);
        history.onServerLine?.call(line);

      case FlutterLineEvent(:final appId, :final line):
        history.flutterLinesFor(appId).add(line);

      case FlutterLogEntryEvent(
        :final appId,
        :final entry,
        :final appendedToLines,
      ):
        if (appendedToLines) history.addFlutterEntryLines(appId, entry);
        history.onFlutterEntry?.call(appId, entry);

      case StageChangedEvent(:final stage, :final isRunning):
        _stage = stage;
        _isRunning = isRunning;

      case FlutterAppsChangedEvent(:final apps):
        _flutterApps = apps;

      case FlutterAppStateEvent(:final appId, :final running, :final url):
        if (running) {
          _runningApps.add(appId);
        } else {
          _runningApps.remove(appId);
        }
        _appUrls[appId] = url;

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

  /// Tells the renderer to repaint through [StartLogHistory.onChanged], the
  /// same channel the in-process runner fires.
  void _markChanged() => history.onChanged?.call();

  /// Sends [method] to the runner, or throws when detached.
  Future<Object?> _send(String method, [Map<String, Object?>? params]) async {
    final peer = _peer;
    if (peer == null) throw RunnerUnreachableException(socketPath);
    return peer.sendRequest(method, params ?? const <String, Object?>{});
  }

  @override
  RunnerStage get stage => _stage;

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

  /// Which apps the runner reports as running.
  Set<String> get runningFlutterApps => Set.unmodifiable(_runningApps);

  @override
  bool get canLaunchFlutterApps => _canLaunchFlutterApps;

  /// Whether the runner was started in watch mode.
  ///
  /// Exposed alongside [stage] and [isRunning] so a renderer can read the
  /// scalars without building a whole [snapshot], which copies every retained
  /// log line.
  bool get watchModeEnabled => _watchModeEnabled;

  @override
  bool isFlutterAppLaunching(String appId) => false;

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

  /// Not carried over the attach protocol: DTD is an agent concern, served by
  /// the MCP socket, and no renderer shows it.
  @override
  Map<String, String?> get flutterDtdUris => const {};

  @override
  List<Object> get logHistory => history.serverEntries.toList();

  @override
  List<String> flutterLogHistory(String appId) =>
      history.flutterLinesFor(appId).toList();

  /// Not carried over the attach protocol: an attached UI never drives the VM
  /// service, and `serverpod status` reads it from the manifest.
  @override
  String? get vmServiceUri => null;

  @override
  Stream<void> get vmServiceUriChanges =>
      events.where((event) => event is ManifestChangedEvent);
}

MigrationResult _migrationResult(Object? result) => MigrationResult.fromJson(
  Map<String, Object?>.from(result as Map? ?? const {}),
);
