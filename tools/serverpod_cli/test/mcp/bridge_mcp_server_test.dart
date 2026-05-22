import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_mcp/client.dart';
import 'package:serverpod_cli/src/commands/start/mcp_socket.dart';
import 'package:serverpod_cli/src/mcp/bridge_mcp_server.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

/// End-to-end test for the thin-proxy bridge:
///
///   test client (in-memory channel)
///       ↕  MCP
///   BridgeMcpServer
///       ↕  MCP over Unix socket (real)
///   McpSocketServer  (with apply_migrations callback)
///
/// The bridge auto-connects on the first tool/resource call. The runner's
/// static surface (apply_migrations, create_migration, hot_reload, hot_restart,
/// tail_server_logs, tail_flutter_logs, get_flutter_app_dtd,
/// serverpod://vm-service) is advertised
/// upfront regardless of whether the runner is currently up.
void main() {
  group(
    'Given a BridgeMcpServer wired to a running runner socket',
    skip: !hasUnixSocketSupport(),
    () {
      late Directory tempServerDir;
      late McpSocketServer runner;
      late _Pair pair;
      late int applyMigrationCalls;

      setUp(() async {
        tempServerDir = await Directory.systemTemp.createTemp('bt');

        runner = McpSocketServer(serverDir: tempServerDir.path);
        await runner.start();

        applyMigrationCalls = 0;
        runner.connect(
          onApplyMigration: () async {
            applyMigrationCalls++;
          },
        );

        pair = await _makeBridgePair(runner.socketPath);
      });

      tearDown(() async {
        await pair.dispose();
        await runner.close();
        await _safeDelete(tempServerDir);
      });

      test(
        'when listing tools, '
        'then the runner static surface is exposed (no connect/disconnect/spawn/stop)',
        () async {
          final result = await pair.client.listTools();
          final names = result.tools.map((t) => t.name).toSet();
          expect(
            names,
            containsAll(<String>{
              'apply_migrations',
              'create_migration',
              'create_repair_migration',
              'hot_reload',
              'hot_restart',
              'tail_server_logs',
              'tail_flutter_logs',
              'get_flutter_app_dtd',
            }),
          );
          expect(names, isNot(contains('connect')));
          expect(names, isNot(contains('disconnect')));
          expect(names, isNot(contains('spawn')));
          expect(names, isNot(contains('stop')));
        },
      );

      test(
        'when listing resources, '
        'then serverpod://vm-service is exposed and serverpod://instances is not',
        () async {
          final result = await pair.client.listResources();
          final uris = result.resources.map((r) => r.uri).toSet();
          expect(uris, contains('serverpod://vm-service'));
          expect(uris, isNot(contains('serverpod://instances')));
        },
      );

      test(
        'when calling apply_migrations, '
        'then the bridge auto-connects and the runner callback runs',
        () async {
          final result = await pair.client.callTool(
            CallToolRequest(name: 'apply_migrations'),
          );
          expect(result.isError, anyOf(isNull, isFalse));
          expect(applyMigrationCalls, 1);
        },
      );
    },
  );

  group(
    'Given a BridgeMcpServer wired to a socket with no runner listening',
    skip: !hasUnixSocketSupport(),
    () {
      late Directory tempServerDir;
      late _Pair pair;

      setUp(() async {
        tempServerDir = await Directory.systemTemp.createTemp('bt');
        // No runner started: the socket file does not exist yet.
        pair = await _makeBridgePair(
          '${tempServerDir.path}/.dart_tool/serverpod/mcp.sock',
        );
      });

      tearDown(() async {
        await pair.dispose();
        await _safeDelete(tempServerDir);
      });

      test(
        'when listing tools before the runner starts, '
        'then the static runner surface is still advertised',
        () async {
          final result = await pair.client.listTools();
          final names = result.tools.map((t) => t.name).toSet();
          expect(
            names,
            containsAll(<String>{
              'apply_migrations',
              'create_migration',
              'create_repair_migration',
              'hot_reload',
              'hot_restart',
              'tail_server_logs',
              'tail_flutter_logs',
              'get_flutter_app_dtd',
            }),
          );
        },
      );

      test(
        'when calling apply_migrations with no runner, '
        'then the result is a not-running error asking the user to start serverpod',
        () async {
          final result = await pair.client.callTool(
            CallToolRequest(name: 'apply_migrations'),
          );
          expect(result.isError, isTrue);
          final text = (result.content.first as TextContent).text;
          expect(text, contains('not running'));
          expect(text, contains('serverpod start'));
        },
      );

      test(
        'when reading serverpod://vm-service with no runner, '
        'then the payload encodes a not-running error',
        () async {
          final result = await pair.client.readResource(
            ReadResourceRequest(uri: 'serverpod://vm-service'),
          );
          final text = (result.contents.first as TextResourceContents).text;
          final payload = jsonDecode(text) as Map<String, dynamic>;
          expect(payload['error'], 'not-running');
        },
      );
    },
  );

  group(
    'Given a BridgeMcpServer that auto-connects after the runner appears',
    skip: !hasUnixSocketSupport(),
    () {
      test(
        'when the first call lands before the runner starts and the second after, '
        'then the second call succeeds',
        () async {
          final tempServerDir = await Directory.systemTemp.createTemp('bt');
          addTearDown(() => _safeDelete(tempServerDir));

          final socketPath =
              '${tempServerDir.path}/.dart_tool/serverpod/mcp.sock';
          final pair = await _makeBridgePair(socketPath);
          addTearDown(pair.dispose);

          // First call: no runner -> not-running.
          var result = await pair.client.callTool(
            CallToolRequest(name: 'apply_migrations'),
          );
          expect(result.isError, isTrue);

          // Bring the runner up.
          final runner = McpSocketServer(serverDir: tempServerDir.path);
          await runner.start();
          addTearDown(runner.close);
          var calls = 0;
          runner.connect(
            onApplyMigration: () async {
              calls++;
            },
          );

          // Second call: bridge transparently reconnects.
          result = await pair.client.callTool(
            CallToolRequest(name: 'apply_migrations'),
          );
          expect(result.isError, anyOf(isNull, isFalse));
          expect(calls, 1);
        },
      );
    },
  );
}

class _Pair {
  _Pair(this.bridge, this.client);

  final BridgeMcpServer bridge;
  final ServerConnection client;

  Future<void> dispose() async {
    await client.shutdown();
    await bridge.shutdown();
  }
}

Future<_Pair> _makeBridgePair(String socketPath) async {
  final clientToBridge = StreamController<String>();
  final bridgeToClient = StreamController<String>();
  final bridgeChannel = StreamChannel<String>(
    clientToBridge.stream,
    bridgeToClient.sink,
  );
  final clientChannel = StreamChannel<String>(
    bridgeToClient.stream,
    clientToBridge.sink,
  );

  final bridge = BridgeMcpServer(bridgeChannel, socketPath: socketPath);
  final client = MCPClient(
    Implementation(name: 'bridge-test-client', version: '0.0.0'),
  ).connectServer(clientChannel);

  await client.initialize(
    InitializeRequest(
      protocolVersion: ProtocolVersion.latestSupported,
      capabilities: ClientCapabilities(),
      clientInfo: Implementation(
        name: 'bridge-test-client',
        version: '0.0.0',
      ),
    ),
  );

  return _Pair(bridge, client);
}

Future<void> _safeDelete(Directory dir) async {
  try {
    await dir.delete(recursive: true);
  } on FileSystemException {
    // Best effort.
  }
}
