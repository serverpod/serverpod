import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'mcp_server.dart';

/// Manages a Unix socket that accepts MCP client connections.
///
/// Each `serverpod start --watch` process listens on
/// `<serverDir>/.dart_tool/serverpod/mcp.sock`. There is at most one socket
/// per server project; a stale file left behind by a crashed previous run
/// is unlinked before binding. Clients connect to interact with the running
/// dev environment via JSON-RPC (MCP protocol). Only one client connection
/// is active at a time.
class McpSocketServer {
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
  Future<CreateMigrationMcpResult> Function({
    String? tag,
    bool force,
    String? targetMigrationVersion,
  })?
  _onCreateRepairMigration;
  Future<void> Function()? _onHotReload;
  Future<void> Function()? _onHotRestart;
  List<Object> Function()? _getLogHistory;
  Map<String, List<String>> Function()? _getFlutterLogHistory;
  String? Function()? _getVmServiceUri;
  Map<String, String?> Function()? _getFlutterDtdUris;
  Stream<void>? _vmServiceUriChanges;

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

  /// Wire the MCP server to watch session callbacks. Can be called before or
  /// after a client connects.
  void connect({
    required Future<void> Function() onApplyMigration,
    Future<CreateMigrationMcpResult> Function({String? tag, bool force})?
    onCreateMigration,
    Future<CreateMigrationMcpResult> Function({
      String? tag,
      bool force,
      String? targetMigrationVersion,
    })?
    onCreateRepairMigration,
    Future<void> Function()? onHotReload,
    Future<void> Function()? onHotRestart,
    List<Object> Function()? getLogHistory,
    Map<String, List<String>> Function()? getFlutterLogHistory,
    String? Function()? getVmServiceUri,
    Map<String, String?> Function()? getFlutterDtdUris,
    Stream<void>? vmServiceUriChanges,
  }) {
    _onApplyMigration = onApplyMigration;
    _onCreateMigration = onCreateMigration;
    _onCreateRepairMigration = onCreateRepairMigration;
    _onHotReload = onHotReload;
    _onHotRestart = onHotRestart;
    _getLogHistory = getLogHistory;
    _getFlutterLogHistory = getFlutterLogHistory;
    _getVmServiceUri = getVmServiceUri;
    _getFlutterDtdUris = getFlutterDtdUris;
    _vmServiceUriChanges = vmServiceUriChanges;
    final server = _mcpServer;
    if (server != null) {
      server.onApplyMigration = onApplyMigration;
      server.onCreateMigration = onCreateMigration;
      server.onCreateRepairMigration = onCreateRepairMigration;
      server.onHotReload = onHotReload;
      server.onHotRestart = onHotRestart;
      server.getLogHistory = getLogHistory;
      server.getFlutterLogHistory = getFlutterLogHistory;
      server.getVmServiceUri = getVmServiceUri;
      server.getFlutterDtdUris = getFlutterDtdUris;
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
    server.onCreateRepairMigration = _onCreateRepairMigration;
    server.onHotReload = _onHotReload;
    server.onHotRestart = _onHotRestart;
    server.getLogHistory = _getLogHistory;
    server.getFlutterLogHistory = _getFlutterLogHistory;
    server.getVmServiceUri = _getVmServiceUri;
    server.getFlutterDtdUris = _getFlutterDtdUris;
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
