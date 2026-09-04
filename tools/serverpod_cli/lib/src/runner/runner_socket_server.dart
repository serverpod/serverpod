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

/// The JSON-RPC notification the runner pushes a replacement snapshot on.
///
/// Sent when the runner behind this socket is swapped, not on every change,
/// which the events carry. A client applies it wholesale, like the snapshot it
/// asked for on connect.
const runnerSnapshotNotification = 'snapshotChanged';

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

  /// Invoked the first time a client asks for the snapshot, and never again for
  /// this runner.
  ///
  /// Auto-launching Flutter apps hangs off this, so they appear when a UI
  /// first arrives rather than when the stack came up. A connection alone does
  /// not identify a UI, which is why the snapshot request is the trigger.
  ///
  /// Assigning this after a client has already arrived runs it immediately.
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
    _eventSub = runner.events.listen(
      (event) => _broadcast(runnerEventNotification, event.toJson),
    );
    refreshSnapshot();
  }

  /// Hands every attached client the runner's current snapshot.
  ///
  /// For a scalar no event announces. A client that attached during startup
  /// was told the stage, whether apps can be launched, and which apps exist,
  /// all for a runner that had no stack yet.
  void refreshSnapshot() {
    final runner = _runner;
    if (runner == null) return;
    _broadcast(runnerSnapshotNotification, () => runner.snapshot().toJson());
  }

  /// Sends [method] to every attached client.
  ///
  /// [payload] is built only when there is someone to send it to. Under
  /// `--no-attach` there is never a peer, and the runner stays up for days.
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

  /// Closes the socket and every attached client.
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
    final peer = json_rpc.Peer(socketChannel(socket));
    _register(peer);

    unawaited(_serve(peer, socket));
  }

  /// Serves [peer] until it goes away, then forgets it.
  ///
  /// A client that drops mid-message ends its peer with an error. That is a
  /// disconnect, not a runner fault, so it must not escape and take the
  /// runner's event forwarding with it.
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
