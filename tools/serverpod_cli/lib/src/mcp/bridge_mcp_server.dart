import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_mcp/client.dart';
import 'package:dart_mcp/server.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/mcp/serverpod_mcp_bridge.dart';
import 'package:serverpod_cli/src/mcp/socket_directory.dart';

/// MCP server that bridges a single MCP client (e.g. Claude Code on stdio)
/// to one running `serverpod start --watch` instance at a time.
///
/// The bridge is long-lived: it survives runner restarts, and lets the
/// client switch between running instances via the `connect`/`disconnect`
/// tools. Tool calls that target the runner (`apply_migrations`) are
/// forwarded over the runner's Unix socket using `dart_mcp`'s client API.
base class BridgeMcpServer extends MCPServer
    with ToolsSupport, ResourcesSupport {
  final ServerpodMcpBridge bridge;

  final MCPClient _client = MCPClient(
    Implementation(name: 'serverpod-bridge', version: templateVersion),
  );

  ServerConnection? _connection;
  String? _connectedId;
  int? _connectedPid;

  static final _instancesResource = Resource(
    uri: 'serverpod://instances',
    name: 'Instances',
    description:
        'List of running `serverpod start --watch` instances discovered '
        'on this machine.',
    mimeType: 'application/json',
  );

  BridgeMcpServer(super.channel, {required this.bridge})
    : super.fromStreamChannel(
        implementation: Implementation(
          name: 'serverpod-bridge',
          version: templateVersion,
        ),
        instructions:
            'Bridge to a running `serverpod start --watch` instance. Read '
            'serverpod://instances to discover running instances, then call '
            'the `connect` tool to attach to one. Tools that act on the '
            'running instance are forwarded over its MCP socket.',
      ) {
    registerTool(_connectTool, _connect);
    registerTool(_disconnectTool, _disconnect);
    registerTool(_spawnTool, _spawn);
    registerTool(_stopTool, _stop);
    registerTool(_applyMigrationsTool, _forwardApplyMigrations);
    registerTool(_hotReloadTool, _forwardHotReload);
    registerTool(_tailLogsTool, _forwardTailLogs);

    addResource(_instancesResource, _readInstances);

    bridge.onSocketsChanged = () {
      if (ready) updateResource(_instancesResource);
    };
  }

  // ---------------------------------------------------------------------------
  // Connection state
  // ---------------------------------------------------------------------------

  bool get _isConnected => _connection != null;

  CallToolResult _notConnectedError() => CallToolResult(
    content: [
      TextContent(
        text:
            'Not connected to a serverpod instance. Read serverpod://instances '
            'and call the `connect` tool first, or call `spawn` to start a '
            'new `serverpod start --watch` process.',
      ),
    ],
    isError: true,
  );

  // ---------------------------------------------------------------------------
  // connect / disconnect
  // ---------------------------------------------------------------------------

  static final _connectTool = Tool(
    name: 'connect',
    description:
        'Connect to a running `serverpod start --watch` instance. If only '
        'one instance is running, connects to it automatically when '
        '`instanceId` is omitted. Otherwise, pass the project name or PID '
        'shown by `serverpod://instances`.',
    inputSchema: Schema.object(
      properties: {
        'instanceId': Schema.string(
          description:
              'Project name or PID of the instance to connect to. Omit to '
              'auto-connect when exactly one instance is running.',
        ),
      },
    ),
  );

  Future<CallToolResult> _connect(CallToolRequest request) async {
    final instanceId = request.arguments?['instanceId'] as String?;

    await bridge.scan();
    final sockets = bridge.sockets;

    if (sockets.isEmpty) {
      return CallToolResult(
        content: [
          TextContent(
            text:
                'No `serverpod start --watch` instances running. Start one '
                'with the `spawn` tool, or run `serverpod start --watch` in '
                'another terminal.',
          ),
        ],
        isError: true,
      );
    }

    ServerpodMcpSocketInfo? target;
    if (instanceId != null) {
      target = bridge.findSocket(instanceId);
      if (target == null) {
        return CallToolResult(
          content: [
            TextContent(
              text:
                  'No instance found matching "$instanceId". '
                  'Available: ${_describeAvailable(sockets)}',
            ),
          ],
          isError: true,
        );
      }
    } else if (sockets.length == 1) {
      target = sockets.first;
    } else {
      return CallToolResult(
        content: [
          TextContent(
            text:
                'Multiple instances available. Pass `instanceId`: '
                '${_describeAvailable(sockets)}',
          ),
        ],
        isError: true,
      );
    }

    await _disconnectInternal();

    try {
      final socket = await Socket.connect(
        InternetAddress(target.path, type: InternetAddressType.unix),
        0,
      );
      final channel = socketChannel(socket);
      final connection = _client.connectServer(channel);

      final initResult = await connection.initialize(
        InitializeRequest(
          protocolVersion: ProtocolVersion.latestSupported,
          capabilities: _client.capabilities,
          clientInfo: _client.implementation,
        ),
      );

      if (initResult.protocolVersion?.isSupported != true) {
        await connection.shutdown();
        return CallToolResult(
          content: [
            TextContent(
              text:
                  'Unsupported MCP protocol version reported by instance '
                  '"${target.project}" (pid ${target.pid}).',
            ),
          ],
          isError: true,
        );
      }

      connection.notifyInitialized(InitializedNotification());

      _connection = connection;
      _connectedId = target.project.isEmpty ? '${target.pid}' : target.project;
      _connectedPid = target.pid;

      // Drop our state and update the resource if the instance dies on us.
      unawaited(
        connection.done.then((_) {
          if (_connection == connection) {
            _connection = null;
            _connectedId = null;
            _connectedPid = null;
            if (ready) updateResource(_instancesResource);
          }
        }),
      );

      if (ready) updateResource(_instancesResource);

      return CallToolResult(
        content: [
          TextContent(
            text: jsonEncode({
              'connected': true,
              'instanceId': _connectedId,
              'project': target.project,
              'pid': target.pid,
            }),
          ),
        ],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to connect: $e')],
        isError: true,
      );
    }
  }

  static final _disconnectTool = Tool(
    name: 'disconnect',
    description:
        'Detach from the currently connected serverpod instance '
        'without stopping it.',
    inputSchema: Schema.object(properties: {}),
  );

  Future<CallToolResult> _disconnect(CallToolRequest request) async {
    if (!_isConnected) {
      return CallToolResult(
        content: [TextContent(text: 'Not connected.')],
        isError: true,
      );
    }
    final id = _connectedId;
    await _disconnectInternal();
    if (ready) updateResource(_instancesResource);
    return CallToolResult(
      content: [
        TextContent(
          text: jsonEncode({'disconnected': true, 'instanceId': id}),
        ),
      ],
    );
  }

  Future<void> _disconnectInternal() async {
    final conn = _connection;
    _connection = null;
    _connectedId = null;
    _connectedPid = null;
    if (conn != null) {
      try {
        await conn.shutdown();
      } catch (_) {
        // Already gone.
      }
    }
  }

  // ---------------------------------------------------------------------------
  // spawn / stop
  // ---------------------------------------------------------------------------

  static final _spawnTool = Tool(
    name: 'spawn',
    description:
        'Start a new `serverpod start --watch` process detached from this '
        'one. The bridge discovers it via the shared MCP socket directory '
        'as soon as it advertises itself. Does not auto-connect - call '
        '`connect` afterwards.',
    inputSchema: Schema.object(
      properties: {
        'directory': Schema.string(
          description:
              'Server directory to start in (defaults to the bridge '
              "process's current working directory).",
        ),
        'args': Schema.list(
          items: Schema.string(description: 'Extra serverpod CLI flag'),
          description: 'Extra arguments appended to `serverpod start --watch`.',
        ),
      },
    ),
  );

  Future<CallToolResult> _spawn(CallToolRequest request) async {
    final directory = request.arguments?['directory'] as String?;
    final extraArgs =
        (request.arguments?['args'] as List?)?.cast<String>() ?? const [];

    final args = ['start', '--watch', ...extraArgs];

    try {
      final process = await Process.start(
        'serverpod',
        args,
        workingDirectory: directory,
        mode: ProcessStartMode.detached,
      );

      // Poll the socket directory for the new instance to appear.
      for (var i = 0; i < 20; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        await bridge.scan();
        final socket = bridge.sockets
            .where((s) => s.pid == process.pid)
            .firstOrNull;
        if (socket != null) {
          return CallToolResult(
            content: [
              TextContent(
                text: jsonEncode({
                  'pid': process.pid,
                  'project': socket.project,
                }),
              ),
            ],
          );
        }
      }

      return CallToolResult(
        content: [
          TextContent(
            text: jsonEncode({
              'pid': process.pid,
              'project': null,
              'note':
                  'Process started but did not register an MCP socket within '
                  '10s. It may still be initializing or have failed early.',
            }),
          ),
        ],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to spawn serverpod: $e')],
        isError: true,
      );
    }
  }

  static final _stopTool = Tool(
    name: 'stop',
    description:
        'Stop a running `serverpod start --watch` instance by '
        'sending SIGTERM.',
    inputSchema: Schema.object(
      properties: {
        'instanceId': Schema.string(
          description: 'Project name or PID of the instance to stop.',
        ),
      },
      required: ['instanceId'],
    ),
  );

  Future<CallToolResult> _stop(CallToolRequest request) async {
    final instanceId = request.arguments?['instanceId'] as String?;
    if (instanceId == null) {
      return CallToolResult(
        content: [TextContent(text: 'Missing required argument: instanceId')],
        isError: true,
      );
    }
    final socket = bridge.findSocket(instanceId);
    if (socket == null) {
      return CallToolResult(
        content: [
          TextContent(text: 'No instance found matching "$instanceId".'),
        ],
        isError: true,
      );
    }

    try {
      Process.killPid(socket.pid);
    } catch (_) {
      // Already gone.
    }

    if (_connectedPid == socket.pid) {
      await _disconnectInternal();
    }

    return CallToolResult(
      content: [
        TextContent(
          text: jsonEncode({
            'stopped': true,
            'pid': socket.pid,
            'project': socket.project,
          }),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Forwarded tools
  // ---------------------------------------------------------------------------

  static final _applyMigrationsTool = Tool(
    name: 'apply_migrations',
    description:
        'Apply pending database migrations on the connected serverpod '
        'instance. The server restarts with `--apply-migrations`. Call after '
        'creating a migration with `serverpod create-migration`.',
    inputSchema: Schema.object(),
  );

  Future<CallToolResult> _forwardApplyMigrations(
    CallToolRequest request,
  ) async {
    if (!_isConnected) return _notConnectedError();
    return _connection!.callTool(
      CallToolRequest(name: 'apply_migrations', arguments: request.arguments),
    );
  }

  static final _hotReloadTool = Tool(
    name: 'hot_reload',
    description:
        'Recompile the server kernel and hot-reload the running isolate on '
        'the connected serverpod instance. Falls back to a full restart if '
        'reload is not possible.',
    inputSchema: Schema.object(),
  );

  Future<CallToolResult> _forwardHotReload(CallToolRequest request) async {
    if (!_isConnected) return _notConnectedError();
    return _connection!.callTool(
      CallToolRequest(name: 'hot_reload', arguments: request.arguments),
    );
  }

  static final _tailLogsTool = Tool(
    name: 'tail_logs',
    description:
        'Return recent log entries from the connected serverpod instance '
        '(structured log entries plus completed operations). Newest last.',
    inputSchema: Schema.object(
      properties: {
        'limit': Schema.int(
          description: 'Max entries to return (default 200, max 10000).',
          minimum: 1,
          maximum: 10000,
        ),
      },
    ),
  );

  Future<CallToolResult> _forwardTailLogs(CallToolRequest request) async {
    if (!_isConnected) return _notConnectedError();
    return _connection!.callTool(
      CallToolRequest(name: 'tail_logs', arguments: request.arguments),
    );
  }

  // ---------------------------------------------------------------------------
  // Resources
  // ---------------------------------------------------------------------------

  ReadResourceResult _readInstances(ReadResourceRequest request) {
    final instances = bridge.sockets
        .map(
          (s) => {
            'pid': s.pid,
            'project': s.project,
            'socketPath': s.path,
            'connected': _connectedPid == s.pid,
          },
        )
        .toList();

    return ReadResourceResult(
      contents: [
        TextResourceContents(uri: request.uri, text: jsonEncode(instances)),
      ],
    );
  }

  String _describeAvailable(List<ServerpodMcpSocketInfo> sockets) {
    return sockets
        .map((s) => s.project.isEmpty ? '${s.pid}' : '${s.project} (${s.pid})')
        .join(', ');
  }
}
