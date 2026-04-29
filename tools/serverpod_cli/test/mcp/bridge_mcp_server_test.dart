import 'dart:async';
import 'dart:convert';

import 'package:dart_mcp/client.dart';
import 'package:serverpod_cli/src/commands/start/mcp_server.dart';
import 'package:serverpod_cli/src/commands/start/mcp_socket.dart';
import 'package:serverpod_cli/src/mcp/bridge_mcp_server.dart';
import 'package:serverpod_cli/src/mcp/serverpod_mcp_bridge.dart';
import 'package:serverpod_cli/src/util/platform_check.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

/// End-to-end test for the bridge:
///
///   test client (in-memory channel)
///       ↕  MCP
///   BridgeMcpServer
///       ↕  MCP over Unix socket (real)
///   McpSocketServer  (with apply_migrations callback)
///
/// Verifies the bridge can `connect` to a discovered runner and forward
/// `apply_migrations` to it.
void main() {
  group(
    'Given a BridgeMcpServer connected to a real runner socket',
    skip: !hasUnixSocketSupport(),
    () {
      late McpSocketServer runner;
      late ServerpodMcpBridge bridge;
      late BridgeMcpServer bridgeServer;
      late ServerConnection client;
      late String project;

      setUp(() async {
        // Short project name to stay under macOS Unix-socket path limits
        // (~104 chars total; systemTemp can already eat ~50).
        project = 'bt${DateTime.now().microsecondsSinceEpoch % 100000}';

        runner = McpSocketServer(project: project);
        await runner.start();

        bridge = ServerpodMcpBridge();
        await bridge.scan();

        // In-memory channel pair for the test client.
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

        bridgeServer = BridgeMcpServer(bridgeChannel, bridge: bridge);
        client = MCPClient(
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
      });

      tearDown(() async {
        await client.shutdown();
        await bridgeServer.shutdown();
        await bridge.dispose();
        await runner.close();
      });

      test(
        'when listing tools before connect, '
        'then only the bridge-native tools are exposed',
        () async {
          final result = await client.listTools();
          final names = result.tools.map((t) => t.name).toSet();
          expect(
            names,
            containsAll(<String>{'connect', 'disconnect', 'spawn', 'stop'}),
          );
          // Forwarded tools are not registered until connect.
          expect(names, isNot(contains('apply_migrations')));
          expect(names, isNot(contains('create_migration')));
          expect(names, isNot(contains('hot_reload')));
          expect(names, isNot(contains('tail_logs')));
        },
      );

      test(
        'when listing tools after connect, '
        'then forwarded runner tools also appear',
        () async {
          runner.connect(onApplyMigration: () async {});

          await client.callTool(
            CallToolRequest(
              name: 'connect',
              arguments: {'instanceId': project},
            ),
          );

          final result = await client.listTools();
          final names = result.tools.map((t) => t.name).toSet();
          expect(
            names,
            containsAll(<String>{
              'connect',
              'disconnect',
              'spawn',
              'stop',
              'apply_migrations',
              'create_migration',
              'hot_reload',
              'tail_logs',
            }),
          );
        },
      );

      test(
        'when reading serverpod://instances, '
        'then the runner socket appears in the list',
        () async {
          final result = await client.readResource(
            ReadResourceRequest(uri: 'serverpod://instances'),
          );
          final text = (result.contents.first as TextResourceContents).text;
          final instances = jsonDecode(text) as List;

          final entry = instances.cast<Map<String, dynamic>>().firstWhere(
            (e) => e['project'] == project,
          );
          expect(entry['socketPath'], runner.socketPath);
          expect(entry['connected'], isFalse);
        },
      );

      test(
        'when calling apply_migrations before connect, '
        'then it errors because the tool is not yet registered',
        () async {
          final result = await client.callTool(
            CallToolRequest(name: 'apply_migrations'),
          );
          expect(result.isError, isTrue);
        },
      );

      test(
        'when calling connect then apply_migrations, '
        'then the runner-side callback is invoked',
        () async {
          var called = 0;
          runner.connect(
            onApplyMigration: () async {
              called++;
            },
          );

          final connectResult = await client.callTool(
            CallToolRequest(
              name: 'connect',
              arguments: {'instanceId': project},
            ),
          );
          expect(
            connectResult.isError,
            anyOf(isNull, isFalse),
            reason:
                'connect should succeed: '
                '${(connectResult.content.first as TextContent).text}',
          );

          final applyResult = await client.callTool(
            CallToolRequest(name: 'apply_migrations'),
          );
          expect(applyResult.isError, anyOf(isNull, isFalse));
          expect(called, 1);
          expect(
            (applyResult.content.first as TextContent).text,
            contains('Migrations applied'),
          );
        },
      );

      test(
        'when calling connect then create_migration with tag and force, '
        'then the runner-side callback receives the arguments',
        () async {
          String? receivedTag;
          bool? receivedForce;
          runner.connect(
            onApplyMigration: () async {},
            onCreateMigration: ({String? tag, bool force = false}) async {
              receivedTag = tag;
              receivedForce = force;
              return const CreateMigrationMcpResult(
                message: 'Migration "v1" created at /tmp/v1.',
              );
            },
          );

          await client.callTool(
            CallToolRequest(
              name: 'connect',
              arguments: {'instanceId': project},
            ),
          );

          final result = await client.callTool(
            CallToolRequest(
              name: 'create_migration',
              arguments: {'tag': 'add-users', 'force': true},
            ),
          );

          expect(result.isError, anyOf(isNull, isFalse));
          expect(receivedTag, 'add-users');
          expect(receivedForce, isTrue);
          expect(
            (result.content.first as TextContent).text,
            contains('Migration "v1" created'),
          );
        },
      );

      test(
        'when connect is called with an unknown instanceId, '
        'then it returns an error listing available instances',
        () async {
          final result = await client.callTool(
            CallToolRequest(
              name: 'connect',
              arguments: {'instanceId': 'no-such-project'},
            ),
          );
          expect(result.isError, isTrue);
          expect(
            (result.content.first as TextContent).text,
            allOf(
              contains('No instance found'),
              contains(project),
            ),
          );
        },
      );

      test(
        'when disconnect is called after connect, '
        'then subsequent apply_migrations errors',
        () async {
          runner.connect(onApplyMigration: () async {});

          await client.callTool(
            CallToolRequest(
              name: 'connect',
              arguments: {'instanceId': project},
            ),
          );

          final disconnectResult = await client.callTool(
            CallToolRequest(name: 'disconnect'),
          );
          expect(disconnectResult.isError, anyOf(isNull, isFalse));

          final applyResult = await client.callTool(
            CallToolRequest(name: 'apply_migrations'),
          );
          expect(applyResult.isError, isTrue);
        },
      );
    },
  );
}
