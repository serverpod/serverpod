import 'dart:async';
import 'dart:io';

import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:serverpod_cli/src/runner/runner_api.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// The JSON-RPC method a client calls to get the snapshot.
const runnerSnapshotMethod = 'snapshot';

/// The JSON-RPC notification the runner pushes events on.
const runnerEventNotification = 'event';

/// Serves the attach protocol on `<serverDir>/.dart_tool/serverpod/tui.sock`.
///
/// JSON-RPC 2.0, line-delimited, reusing the framing the MCP socket already
/// uses. Both expose the same [RunnerApi], on separate sockets, since MCP's
/// request and response vocabulary does not fit a continuous event stream.
///
/// Several clients may attach at once, and each gets the snapshot on request
/// followed by every subsequent event. A connection that never asks for one is
/// sent nothing. A dropped client disturbs neither the others nor the runner.
///
/// Commands take their parameters by name, and callers pass an object even
/// when every field is optional. `json_rpc_2` rejects a positional or absent
/// parameter list for a handler that reads named ones.
class RunnerSocketServer {
  RunnerSocketServer({required String serverDir})
    : socketPath = serverpodTuiSocketPath(serverDir);

  /// Absolute path to this runner's attach socket.
  final String socketPath;

  ServerSocket? _serverSocket;
  RunnerApi? _runner;
  StreamSubscription<void>? _eventSub;
  final Set<json_rpc.Peer> _peers = {};
  final Set<Socket> _sockets = {};
  bool _closing = false;

  /// Binds the socket.
  ///
  /// [bindUnixSocket] unlinks a stale file left by a crashed previous run
  /// before binding.
  Future<void> start() async {
    File(socketPath).parent.createSync(recursive: true);
    _serverSocket = await bindUnixSocket(socketPath);
    _serverSocket!.listen(_handleConnection);
  }

  /// Wires the runner whose state is served, and starts forwarding its events
  /// to every attached client.
  void connect(RunnerApi runner) {
    _runner = runner;
    _eventSub?.cancel();
    _eventSub = runner.events.listen((event) {
      if (_peers.isEmpty) return;
      final payload = event.toJson();
      for (final peer in _peers.toList()) {
        try {
          peer.sendNotification(runnerEventNotification, payload);
        } on StateError {
          _peers.remove(peer);
        }
      }
    });
  }

  /// Closes the socket and every attached client.
  Future<void> close() async {
    _closing = true;
    await _eventSub?.cancel();
    _eventSub = null;
    for (final socket in _sockets.toList()) {
      try {
        await socket.flush();
      } catch (_) {}
    }
    await Future.wait([for (final peer in _peers.toList()) peer.close()]);
    _peers.clear();
    for (final socket in _sockets.toList()) {
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
    final peer = json_rpc.Peer(socketChannel(socket));
    _register(peer);

    unawaited(
      peer.listen().whenComplete(() {
        _peers.remove(peer);
        _sockets.remove(socket);
      }),
    );
  }

  void _register(json_rpc.Peer peer) {
    peer.registerMethod(
      runnerSnapshotMethod,
      () => _withRunner((runner) => runner.snapshot().toJson()),
    );

    peer.registerMethod('hotReload', () => _run((r) => r.hotReload()));
    peer.registerMethod('hotRestart', () => _run((r) => r.hotRestart()));
    peer.registerMethod('retryStart', () => _run((r) => r.retryStart()));
    peer.registerMethod('stop', () => _run((r) => r.stop()));
    peer.registerMethod(
      'applyMigrations',
      () => _run((r) => r.applyMigrations()),
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
      () => _run((r) => r.restartFlutterApps()),
    );
  }

  /// Runs [body] against the attached runner, reporting a JSON-RPC error when
  /// none is attached yet rather than pretending the command ran.
  T _withRunner<T>(T Function(RunnerApi runner) body) {
    final runner = _runner;
    if (runner == null) throw _notReady();
    return body(runner);
  }

  /// Runs a command that reports nothing but success or failure.
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

/// A parameter the caller may omit, as `null` rather than a rejected request.
String? _optionalString(json_rpc.Parameter parameter) =>
    parameter.exists ? parameter.asString : null;
