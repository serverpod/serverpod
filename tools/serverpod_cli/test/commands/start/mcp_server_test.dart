import 'dart:async';

import 'package:dart_mcp/client.dart';
import 'package:serverpod_cli/src/commands/start/mcp_server.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

/// Creates a connected server and client connection for testing.
Future<({ServerpodMcpServer server, ServerConnection connection})>
_createPair() async {
  final serverToClient = StreamController<String>();
  final clientToServer = StreamController<String>();

  final serverChannel = StreamChannel<String>(
    clientToServer.stream,
    serverToClient.sink,
  );
  final clientChannel = StreamChannel<String>(
    serverToClient.stream,
    clientToServer.sink,
  );

  final server = ServerpodMcpServer(serverChannel);
  final client = MCPClient(
    Implementation(name: 'test-client', version: '0.1.0'),
  );
  final connection = client.connectServer(clientChannel);

  // Initialize the MCP connection.
  await connection.initialize(
    InitializeRequest(
      protocolVersion: ProtocolVersion.latestSupported,
      capabilities: ClientCapabilities(),
      clientInfo: Implementation(name: 'test-client', version: '0.1.0'),
    ),
  );

  return (server: server, connection: connection);
}

void main() {
  group('Given a ServerpodMcpServer', () {
    late ServerpodMcpServer server;
    late ServerConnection connection;

    setUp(() async {
      final pair = await _createPair();
      server = pair.server;
      connection = pair.connection;
    });

    tearDown(() async {
      await connection.shutdown();
      await server.shutdown();
    });

    test(
      'when listing tools, '
      'then apply_migrations is available',
      () async {
        final result = await connection.listTools();

        expect(result.tools, hasLength(1));
        expect(result.tools.first.name, 'apply_migrations');
      },
    );

    group('Given no connected callback', () {
      test(
        'when calling apply_migrations, '
        'then it returns an error',
        () async {
          final result = await connection.callTool(
            CallToolRequest(name: 'apply_migrations'),
          );

          expect(result.isError, isTrue);
          expect(
            (result.content.first as TextContent).text,
            contains('not connected'),
          );
        },
      );
    });

    group('Given a connected callback', () {
      test(
        'when calling apply_migrations, '
        'then it invokes the callback and returns success',
        () async {
          var called = false;
          server.onApplyMigration = () async {
            called = true;
          };

          final result = await connection.callTool(
            CallToolRequest(name: 'apply_migrations'),
          );

          expect(called, isTrue);
          expect(result.isError, isNull);
          expect(
            (result.content.first as TextContent).text,
            contains('Migrations applied'),
          );
        },
      );

      test(
        'when the callback throws, '
        'then it returns an error with the message',
        () async {
          server.onApplyMigration = () async {
            throw Exception('database locked');
          };

          final result = await connection.callTool(
            CallToolRequest(name: 'apply_migrations'),
          );

          expect(result.isError, isTrue);
          expect(
            (result.content.first as TextContent).text,
            contains('database locked'),
          );
        },
      );
    });
  });
}
