import 'dart:async';
import 'dart:io';

import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:serverpod_cli/src/runner/runner_api.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

const runnerSnapshotMethod = 'snapshot';

const runnerEventNotification = 'event';

/// Serves the attach protocol. See `docs/design/runner.md#attach-protocol`.
///
/// Callers pass an object even with no parameters, as `json_rpc_2` rejects an
/// absent list for handlers that read named ones.
class RunnerSocketServer {
  RunnerSocketServer({required String serverDir})
    : socketPath = serverpodTuiSocketPath(serverDir);

  final String socketPath;

  /// Runs once, on the first snapshot request, or at once if one has arrived.
  ///
  /// Liveness probes never request a snapshot, so they do not trigger it.
  void Function()? get onFirstClientAttached => _onFirstClientAttached;

  set onFirstClientAttached(void Function()? callback) {
    _onFirstClientAttached = callback;
    if (_hadClient) callback?.call();
  }

  void Function()? _onFirstClientAttached;

  ServerSocket? _serverSocket;
  RunnerApi? _runner;
  bool _hadClient = false;
  StreamSubscription<void>? _eventSub;
  final Set<json_rpc.Peer> _peers = {};
  final Set<Socket> _sockets = {};
  bool _closing = false;

  Future<void> start() async {
    File(socketPath).parent.createSync(recursive: true);
    _serverSocket = await bindUnixSocket(socketPath);
    _serverSocket!.listen(_handleConnection);
  }

  void connect(RunnerApi runner) {
    _runner = runner;
    _eventSub?.cancel();
    _eventSub = runner.events.listen(
      (event) => _broadcast(runnerEventNotification, event.toJson),
    );
  }

  /// Sends [method] to every attached client, building [payload] only if any.
  void _broadcast(String method, Map<String, Object?> Function() payload) {
    if (_peers.isEmpty) return;
    final params = payload();
    for (final peer in _peers.toList()) {
      try {
        peer.sendNotification(method, params);
      } on StateError {
        _peers.remove(peer);
      }
    }
  }

  Future<void> close() async {
    _closing = true;
    await _eventSub?.cancel();
    _eventSub = null;
    await ([
      for (final peer in _peers.toList()) peer.close().catchError((_) {}),
    ]).wait;
    _peers.clear();
    for (final socket in _sockets.toList()) {
      try {
        await socket.close();
      } catch (_) {}
      socket.destroy();
    }
    _sockets.clear();
    await _serverSocket?.close();
    await File(socketPath).deleteIfExists();
  }

  void _handleConnection(Socket socket) {
    if (_closing) {
      socket.destroy();
      return;
    }

    _sockets.add(socket);

    // Most connections are silent liveness probes, so peers are built lazily.
    json_rpc.Peer? peer;
    final input = StreamController<List<int>>();
    unawaited(socket.done.catchError((_) {}));
    socket.listen(
      (chunk) {
        if (peer == null) {
          final served = json_rpc.Peer(
            socketChannel(socket, input: input.stream),
          );
          peer = served;
          _register(served);
          unawaited(_serve(served, socket));
        }
        input.add(chunk);
      },
      onError: input.addError,
      onDone: () {
        input.close();
        if (peer == null) {
          _sockets.remove(socket);
          socket.destroy();
        }
      },
      cancelOnError: false,
    );
  }

  /// Serves [peer] until it goes away, swallowing a dropped client's error.
  Future<void> _serve(json_rpc.Peer peer, Socket socket) async {
    try {
      await peer.listen();
    } catch (_) {
    } finally {
      _peers.remove(peer);
      _sockets.remove(socket);
    }
  }

  void _register(json_rpc.Peer peer) {
    peer.registerMethod(runnerSnapshotMethod, (json_rpc.Parameters _) {
      _peers.add(peer);
      if (!_hadClient) {
        _hadClient = true;
        _onFirstClientAttached?.call();
      }
      return _withRunner((runner) => runner.snapshot().toJson());
    });

    peer.registerMethod(
      'hotReload',
      (json_rpc.Parameters _) => _run((r) => r.hotReload()),
    );
    peer.registerMethod(
      'hotRestart',
      (json_rpc.Parameters _) => _run((r) => r.hotRestart()),
    );
    peer.registerMethod(
      'retryStart',
      (json_rpc.Parameters _) => _run((r) => r.retryStart()),
    );
    peer.registerMethod(
      'stop',
      (json_rpc.Parameters _) => _run((r) => r.stop()),
    );
    peer.registerMethod(
      'applyMigrations',
      (json_rpc.Parameters _) => _run((r) => r.applyMigrations()),
    );

    peer.registerMethod(
      'createMigration',
      (json_rpc.Parameters params) => _withRunner(
        (runner) async => (await runner.createMigration(
          tag: _optionalString(params['tag']),
          force: params['force'].asBoolOr(false),
        )).toJson(),
      ),
    );

    peer.registerMethod(
      'createRepairMigration',
      (json_rpc.Parameters params) => _withRunner(
        (runner) async => (await runner.createRepairMigration(
          tag: _optionalString(params['tag']),
          force: params['force'].asBoolOr(false),
          targetVersion: _optionalString(params['targetVersion']),
        )).toJson(),
      ),
    );

    peer.registerMethod(
      'launchFlutterApp',
      (json_rpc.Parameters params) => _withRunner(
        (runner) async => {
          'alreadyRunning': await runner.launchFlutterApp(
            params['appId'].asString,
          ),
        },
      ),
    );
    peer.registerMethod(
      'restartFlutterApp',
      (json_rpc.Parameters params) =>
          _run((r) => r.restartFlutterApp(params['appId'].asString)),
    );
    peer.registerMethod(
      'stopFlutterApp',
      (json_rpc.Parameters params) =>
          _run((r) => r.stopFlutterApp(params['appId'].asString)),
    );
    peer.registerMethod(
      'restartFlutterApps',
      (json_rpc.Parameters _) => _run((r) => r.restartFlutterApps()),
    );
  }

  /// Runs [body] against the runner, or throws before [connect] provides one.
  T _withRunner<T>(T Function(RunnerApi runner) body) {
    final runner = _runner;
    if (runner == null) throw _notReady();
    return body(runner);
  }

  Future<Map<String, Object?>> _run(
    Future<void> Function(RunnerApi runner) body,
  ) async {
    await _withRunner(body);
    return const {};
  }

  json_rpc.RpcException _notReady() => json_rpc.RpcException(
    -32002,
    'The runner is still starting up and has nothing to serve yet.',
  );
}

String? _optionalString(json_rpc.Parameter parameter) =>
    parameter.exists ? parameter.asString : null;
