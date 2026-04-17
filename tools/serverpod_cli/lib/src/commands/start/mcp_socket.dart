import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:serverpod_cli/src/util/platform_check.dart';

import 'mcp_server.dart';

/// Manages a Unix socket that accepts MCP client connections.
///
/// Each `serverpod start --watch` process listens on
/// `<systemTemp>/serverpod/serverpod-<pid>-<project>.sock`. Clients connect
/// to interact with the running dev environment via JSON-RPC (MCP protocol).
/// Only one client connection is active at a time.
class McpSocketServer {
  /// Sanitized project name embedded in the socket filename.
  final String project;

  /// Absolute path to this server's socket file.
  final String socketPath;

  ServerSocket? _serverSocket;
  Socket? _clientSocket;
  ServerpodMcpServer? _mcpServer;
  Future<void>? _pendingShutdown;
  bool _closing = false;

  /// Callbacks wired once via [connect].
  Future<void> Function()? _onApplyMigration;
  List<Object> Function()? _getLogHistory;

  McpSocketServer({required String project})
    : project = sanitizeProjectName(project),
      socketPath = serverpodMcpSocketPath(
        pid: pid,
        project: project,
      );

  /// Start listening for connections.
  Future<void> start() async {
    ensureServerpodMcpSocketDir();
    _serverSocket = await bindUnixSocket(socketPath);
    _serverSocket!.listen(_handleConnection);
  }

  /// Wire the MCP server to watch session callbacks. Can be called before or
  /// after a client connects.
  void connect({
    required Future<void> Function() onApplyMigration,
    List<Object> Function()? getLogHistory,
  }) {
    _onApplyMigration = onApplyMigration;
    _getLogHistory = getLogHistory;
    final server = _mcpServer;
    if (server != null) {
      server.onApplyMigration = onApplyMigration;
      server.getLogHistory = getLogHistory;
    }
  }

  /// Shut down the socket server and clean up.
  Future<void> close() async {
    _closing = true;
    await _pendingShutdown;
    await _mcpServer?.shutdown();
    _clientSocket?.destroy();
    await _serverSocket?.close();
    try {
      File(socketPath).deleteSync();
    } on FileSystemException {
      // Already gone.
    }
  }

  Future<void> _handleConnection(Socket socket) async {
    // Serialize connection handling - wait for any in-flight shutdown.
    await _pendingShutdown;

    // Reject connections that arrive after close() has started.
    if (_closing) {
      socket.destroy();
      return;
    }

    // Only one client at a time - shut down previous.
    final shutdown = _mcpServer?.shutdown();
    if (shutdown != null) {
      _pendingShutdown = shutdown;
      await shutdown;
      _pendingShutdown = null;
    }

    // Re-check after awaiting - close() may have been called in the meantime.
    if (_closing) {
      socket.destroy();
      return;
    }

    _clientSocket?.destroy();
    _clientSocket = socket;

    final channel = socketChannel(socket);
    final server = ServerpodMcpServer(channel);
    _mcpServer = server;

    // Wire callbacks if already connected.
    server.onApplyMigration = _onApplyMigration;
    server.getLogHistory = _getLogHistory;

    // Clean up on disconnect.
    unawaited(
      server.done.then((_) {
        if (_mcpServer == server) {
          _mcpServer = null;
          _clientSocket = null;
        }
      }),
    );
  }
}
