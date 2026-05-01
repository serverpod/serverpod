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
      'then apply_migrations, create_migration, hot_reload, and tail_logs are available',
      () async {
        final result = await connection.listTools();

        expect(
          result.tools.map((t) => t.name),
          containsAll([
            'apply_migrations',
            'create_migration',
            'hot_reload',
            'tail_logs',
          ]),
        );
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

      test(
        'when calling create_migration, '
        'then it returns an error',
        () async {
          final result = await connection.callTool(
            CallToolRequest(name: 'create_migration'),
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

      test(
        'when calling create_migration without args, '
        'then the callback is invoked with null tag and force=false',
        () async {
          String? receivedTag;
          bool? receivedForce;
          server.onCreateMigration = ({String? tag, bool force = false}) async {
            receivedTag = tag;
            receivedForce = force;
            return const CreateMigrationMcpResult(
              message: 'Migration "v1" created at /tmp/v1.',
            );
          };

          final result = await connection.callTool(
            CallToolRequest(name: 'create_migration'),
          );

          expect(receivedTag, isNull);
          expect(receivedForce, isFalse);
          expect(result.isError, isNull);
          expect(
            (result.content.first as TextContent).text,
            contains('Migration "v1" created'),
          );
        },
      );

      test(
        'when calling create_migration with tag and force, '
        'then the callback receives them',
        () async {
          String? receivedTag;
          bool? receivedForce;
          server.onCreateMigration = ({String? tag, bool force = false}) async {
            receivedTag = tag;
            receivedForce = force;
            return const CreateMigrationMcpResult(message: 'ok');
          };

          await connection.callTool(
            CallToolRequest(
              name: 'create_migration',
              arguments: {'tag': 'add-users', 'force': true},
            ),
          );

          expect(receivedTag, 'add-users');
          expect(receivedForce, isTrue);
        },
      );

      test(
        'when create_migration returns an error result, '
        'then the tool result is flagged as error',
        () async {
          server.onCreateMigration = ({String? tag, bool force = false}) async {
            return const CreateMigrationMcpResult(
              message: 'database feature disabled',
              isError: true,
            );
          };

          final result = await connection.callTool(
            CallToolRequest(name: 'create_migration'),
          );

          expect(result.isError, isTrue);
          expect(
            (result.content.first as TextContent).text,
            contains('database feature disabled'),
          );
        },
      );

      test(
        'when the create_migration callback throws, '
        'then the tool result is an error with the message',
        () async {
          server.onCreateMigration = ({String? tag, bool force = false}) async {
            throw Exception('model parse failed');
          };

          final result = await connection.callTool(
            CallToolRequest(name: 'create_migration'),
          );

          expect(result.isError, isTrue);
          expect(
            (result.content.first as TextContent).text,
            contains('model parse failed'),
          );
        },
      );
    });
  });
}
