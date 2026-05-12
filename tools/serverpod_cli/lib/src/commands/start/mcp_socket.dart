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
  Future<CreateMigrationMcpResult> Function({String? tag, bool force})?
  _onCreateMigration;
  Future<void> Function()? _onHotReload;
  List<Object> Function()? _getLogHistory;
  String? Function()? _getVmServiceUri;
  Stream<void>? _vmServiceUriChanges;

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
    Future<CreateMigrationMcpResult> Function({String? tag, bool force})?
    onCreateMigration,
    Future<void> Function()? onHotReload,
    List<Object> Function()? getLogHistory,
    String? Function()? getVmServiceUri,
    Stream<void>? vmServiceUriChanges,
  }) {
    _onApplyMigration = onApplyMigration;
    _onCreateMigration = onCreateMigration;
    _onHotReload = onHotReload;
    _getLogHistory = getLogHistory;
    _getVmServiceUri = getVmServiceUri;
    _vmServiceUriChanges = vmServiceUriChanges;
    final server = _mcpServer;
    if (server != null) {
      server.onApplyMigration = onApplyMigration;
      server.onCreateMigration = onCreateMigration;
      server.onHotReload = onHotReload;
      server.getLogHistory = getLogHistory;
      server.getVmServiceUri = getVmServiceUri;
      server.vmServiceUriChanges = vmServiceUriChanges;
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
    server.onCreateMigration = _onCreateMigration;
    server.onHotReload = _onHotReload;
    server.getLogHistory = _getLogHistory;
    server.getVmServiceUri = _getVmServiceUri;
    server.vmServiceUriChanges = _vmServiceUriChanges;

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
