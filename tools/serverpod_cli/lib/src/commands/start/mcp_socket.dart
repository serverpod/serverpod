import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:serverpod_cli/src/runner/runner_api.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'mcp_server.dart';

/// Manages a Unix socket that accepts MCP client connections.
///
/// One per server project, at `<serverDir>/.dart_tool/serverpod/mcp.sock`.
/// Clients speak JSON-RPC and drive the running dev environment.
///
/// Several may be attached at once, and [RunnerApi] serializes conflicting
/// commands between them.
class McpSocketServer {
  /// Absolute path to this server's socket file.
  final String socketPath;

  ServerSocket? _serverSocket;
  final Set<ServerpodMcpServer> _mcpServers = {};
  final Set<Socket> _clientSockets = {};
  InProcessRunnerApi? _runner;
  bool _closing = false;

  McpSocketServer({required String serverDir})
    : socketPath = serverpodMcpSocketPath(serverDir);

  /// Start listening for connections. Creates the parent directory if
  /// missing; [bindUnixSocket] takes care of unlinking any stale socket
  /// file left by a crashed previous run.
  Future<void> start() async {
    File(socketPath).parent.createSync(recursive: true);
    _serverSocket = await bindUnixSocket(socketPath);
    _serverSocket!.listen(_handleConnection);
  }

  /// Wires the MCP servers to [runner].
  ///
  /// Callable before or after clients connect. Already-connected ones are
  /// updated in place.
  void connect(InProcessRunnerApi runner) {
    _runner = runner;
    for (final server in _mcpServers) {
      server.runner = runner;
    }
  }

  /// Shuts the socket server and every connected client down.
  Future<void> close() async {
    _closing = true;
    await Future.wait([
      for (final server in _mcpServers.toList()) server.shutdown(),
    ]);
    _mcpServers.clear();
    for (final socket in _clientSockets.toList()) {
      socket.destroy();
    }
    _clientSockets.clear();
    await _serverSocket?.close();
    try {
      File(socketPath).deleteSync();
    } on FileSystemException {
      // Already gone.
    }
  }

  void _handleConnection(Socket socket) {
    // Reject connections that arrive after close() has started.
    if (_closing) {
      socket.destroy();
      return;
    }

    _clientSockets.add(socket);

    final server = ServerpodMcpServer(socketChannel(socket))..runner = _runner;
    _mcpServers.add(server);

    // Clean up on disconnect.
    unawaited(
      server.done.then((_) {
        _mcpServers.remove(server);
        _clientSockets.remove(socket);
      }),
    );
  }
}
