import 'dart:async';
import 'dart:convert';

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
      'then all tools that operate on the running server are available',
      () async {
        final result = await connection.listTools();

        expect(
          result.tools.map((t) => t.name),
          containsAll([
            'apply_migrations',
            'create_migration',
            'create_repair_migration',
            'hot_reload',
            'hot_restart',
            'tail_server_logs',
            'tail_flutter_logs',
            'spawn_flutter_app',
            'get_flutter_app_dtd',
          ]),
        );
      },
    );

    group('with no connected callback', () {
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

      test(
        'when calling hot_restart, '
        'then it returns an error',
        () async {
          final result = await connection.callTool(
            CallToolRequest(name: 'hot_restart'),
          );

          expect(result.isError, isTrue);
          expect(
            (result.content.first as TextContent).text,
            contains('not connected'),
          );
        },
      );

      test(
        'when calling create_repair_migration, '
        'then it returns an error',
        () async {
          final result = await connection.callTool(
            CallToolRequest(name: 'create_repair_migration'),
          );

          expect(result.isError, isTrue);
          expect(
            (result.content.first as TextContent).text,
            contains('not connected'),
          );
        },
      );
      test(
        'when calling tail_flutter_logs without a callback, '
        'then it returns an error',
        () async {
          final result = await connection.callTool(
            CallToolRequest(name: 'tail_flutter_logs'),
          );

          expect(result.isError, isTrue);
          expect(
            (result.content.first as TextContent).text,
            contains('Flutter log history not available'),
          );
        },
      );

      test(
        'when calling get_flutter_app_dtd without a callback, '
        'then it returns an error',
        () async {
          final result = await connection.callTool(
            CallToolRequest(name: 'get_flutter_app_dtd'),
          );

          expect(result.isError, isTrue);
          expect(
            (result.content.first as TextContent).text,
            contains('Flutter DTD not available'),
          );
        },
      );

      test(
        'when calling spawn_flutter_app without a callback, '
        'then it returns an error',
        () async {
          final result = await connection.callTool(
            CallToolRequest(name: 'spawn_flutter_app'),
          );

          expect(result.isError, isTrue);
          expect(
            (result.content.first as TextContent).text,
            contains('Flutter app launching is not available'),
          );
        },
      );
    });

    group('with a connected callback', () {
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

      test(
        'when calling hot_restart, '
        'then it invokes the callback and returns success',
        () async {
          var called = false;
          server.onHotRestart = () async {
            called = true;
          };

          final result = await connection.callTool(
            CallToolRequest(name: 'hot_restart'),
          );

          expect(called, isTrue);
          expect(result.isError, isNull);
          expect(
            (result.content.first as TextContent).text,
            contains('Hot restart completed'),
          );
        },
      );

      test(
        'when the hot_restart callback throws, '
        'then the tool result is an error with the message',
        () async {
          server.onHotRestart = () async {
            throw Exception('createServer null');
          };

          final result = await connection.callTool(
            CallToolRequest(name: 'hot_restart'),
          );

          expect(result.isError, isTrue);
          expect(
            (result.content.first as TextContent).text,
            contains('createServer null'),
          );
        },
      );

      test(
        'when calling create_repair_migration without args, '
        'then the callback is invoked with null tag, force=false, and null version',
        () async {
          String? receivedTag;
          bool? receivedForce;
          String? receivedVersion;
          server.onCreateRepairMigration =
              ({
                String? tag,
                bool force = false,
                String? targetMigrationVersion,
              }) async {
                receivedTag = tag;
                receivedForce = force;
                receivedVersion = targetMigrationVersion;
                return const CreateMigrationMcpResult(
                  message: 'Repair migration "v1" created at /tmp/v1.sql.',
                );
              };

          final result = await connection.callTool(
            CallToolRequest(name: 'create_repair_migration'),
          );

          expect(receivedTag, isNull);
          expect(receivedForce, isFalse);
          expect(receivedVersion, isNull);
          expect(result.isError, isNull);
          expect(
            (result.content.first as TextContent).text,
            contains('Repair migration "v1" created'),
          );
        },
      );

      test(
        'when calling create_repair_migration with tag, force, and version, '
        'then the callback receives them',
        () async {
          String? receivedTag;
          bool? receivedForce;
          String? receivedVersion;
          server.onCreateRepairMigration =
              ({
                String? tag,
                bool force = false,
                String? targetMigrationVersion,
              }) async {
                receivedTag = tag;
                receivedForce = force;
                receivedVersion = targetMigrationVersion;
                return const CreateMigrationMcpResult(message: 'ok');
              };

          await connection.callTool(
            CallToolRequest(
              name: 'create_repair_migration',
              arguments: {
                'tag': 'fix-drift',
                'force': true,
                'version': '20240101000000',
              },
            ),
          );

          expect(receivedTag, 'fix-drift');
          expect(receivedForce, isTrue);
          expect(receivedVersion, '20240101000000');
        },
      );

      test(
        'when create_repair_migration returns an error result, '
        'then the tool result is flagged as error',
        () async {
          server.onCreateRepairMigration =
              ({
                String? tag,
                bool force = false,
                String? targetMigrationVersion,
              }) async {
                return const CreateMigrationMcpResult(
                  message: 'No repair migration created.',
                  isError: true,
                );
              };

          final result = await connection.callTool(
            CallToolRequest(name: 'create_repair_migration'),
          );

          expect(result.isError, isTrue);
          expect(
            (result.content.first as TextContent).text,
            contains('No repair migration created'),
          );
        },
      );

      test(
        'when the create_repair_migration callback throws, '
        'then the tool result is an error with the message',
        () async {
          server.onCreateRepairMigration =
              ({
                String? tag,
                bool force = false,
                String? targetMigrationVersion,
              }) async {
                throw Exception('live db unreachable');
              };

          final result = await connection.callTool(
            CallToolRequest(name: 'create_repair_migration'),
          );

          expect(result.isError, isTrue);
          expect(
            (result.content.first as TextContent).text,
            contains('live db unreachable'),
          );
        },
      );
      group('with Flutter log history for one app', () {
        setUp(() {
          server.getFlutterAppIds = () => ['admin'];
          server.getFlutterLogHistory = (appId) => switch (appId) {
            'admin' => [
              'line 1',
              'line 2',
              'line 3',
            ],
            _ => <String>[],
          };
        });

        test(
          'when calling tail_flutter_logs with an appId and a limit, '
          'then it returns the most recent lines as JSON',
          () async {
            final result = await connection.callTool(
              CallToolRequest(
                name: 'tail_flutter_logs',
                arguments: {'limit': 2, 'appId': 'admin'},
              ),
            );

            expect(result.isError, isNull);
            final lines =
                jsonDecode((result.content.first as TextContent).text)
                    as List<dynamic>;
            expect(lines, ['line 2', 'line 3']);
          },
        );

        test(
          'when calling tail_flutter_logs without an appId, '
          'then it returns that app\'s lines',
          () async {
            final result = await connection.callTool(
              CallToolRequest(name: 'tail_flutter_logs'),
            );

            expect(result.isError, isNull);
            expect(
              jsonDecode((result.content.first as TextContent).text),
              ['line 1', 'line 2', 'line 3'],
            );
          },
        );
      });

      group('with Flutter log history for several apps', () {
        setUp(() {
          server.getFlutterAppIds = () => ['admin', 'customer'];
          server.getFlutterLogHistory = (appId) => switch (appId) {
            'admin' => ['a'],
            'customer' => ['b', 'c'],
            _ => <String>[],
          };
        });

        test(
          'when calling tail_flutter_logs without an appId, '
          'then it errors listing the available app ids',
          () async {
            final result = await connection.callTool(
              CallToolRequest(name: 'tail_flutter_logs'),
            );

            expect(result.isError, isTrue);
            final text = (result.content.first as TextContent).text;
            expect(text, contains('admin'));
            expect(text, contains('customer'));
          },
        );

        test(
          'when calling tail_flutter_logs with an unknown appId, '
          'then it errors listing the available app ids',
          () async {
            final result = await connection.callTool(
              CallToolRequest(
                name: 'tail_flutter_logs',
                arguments: {'appId': 'nope'},
              ),
            );

            expect(result.isError, isTrue);
            final text = (result.content.first as TextContent).text;
            expect(text, contains('nope'));
            expect(text, contains('admin'));
            expect(text, contains('customer'));
          },
        );
      });

      group('with spawn_flutter_app wired to a single app', () {
        late List<String> spawnCalls;
        late bool reportAlreadyRunning;

        setUp(() {
          spawnCalls = [];
          reportAlreadyRunning = false;
          server.getFlutterAppIds = () => ['admin'];
          server.onSpawnFlutterApp = (appId) async {
            spawnCalls.add(appId);
            return reportAlreadyRunning;
          };
        });

        test(
          'when calling spawn_flutter_app without an appId, '
          'then it launches the only configured app',
          () async {
            final result = await connection.callTool(
              CallToolRequest(name: 'spawn_flutter_app'),
            );

            expect(result.isError, isNull);
            expect(spawnCalls, ['admin']);
            expect(
              (result.content.first as TextContent).text,
              contains('Launching Flutter app "admin"'),
            );
          },
        );

        test(
          'when the app is already running, '
          'then it reports that without an error',
          () async {
            reportAlreadyRunning = true;

            final result = await connection.callTool(
              CallToolRequest(
                name: 'spawn_flutter_app',
                arguments: {'appId': 'admin'},
              ),
            );

            expect(result.isError, isNull);
            expect(spawnCalls, ['admin']);
            expect(
              (result.content.first as TextContent).text,
              contains('already running'),
            );
          },
        );

        test(
          'when the launch callback throws, '
          'then it returns an error naming the app',
          () async {
            server.onSpawnFlutterApp = (_) async =>
                throw StateError('flutter missing');

            final result = await connection.callTool(
              CallToolRequest(name: 'spawn_flutter_app'),
            );

            expect(result.isError, isTrue);
            expect(
              (result.content.first as TextContent).text,
              contains('Failed to launch Flutter app "admin"'),
            );
          },
        );
      });

      group('with spawn_flutter_app wired to several apps', () {
        late List<String> spawnCalls;

        setUp(() {
          spawnCalls = [];
          server.getFlutterAppIds = () => ['admin', 'customer'];
          server.onSpawnFlutterApp = (appId) async {
            spawnCalls.add(appId);
            return false;
          };
        });

        test(
          'when calling spawn_flutter_app without an appId, '
          'then it errors listing the available app ids and launches nothing',
          () async {
            final result = await connection.callTool(
              CallToolRequest(name: 'spawn_flutter_app'),
            );

            expect(result.isError, isTrue);
            final text = (result.content.first as TextContent).text;
            expect(text, contains('admin'));
            expect(text, contains('customer'));
            expect(spawnCalls, isEmpty);
          },
        );

        test(
          'when calling spawn_flutter_app with an explicit appId, '
          'then it launches that app',
          () async {
            final result = await connection.callTool(
              CallToolRequest(
                name: 'spawn_flutter_app',
                arguments: {'appId': 'customer'},
              ),
            );

            expect(result.isError, isNull);
            expect(spawnCalls, ['customer']);
            expect(
              (result.content.first as TextContent).text,
              contains('Launching Flutter app "customer"'),
            );
          },
        );

        test(
          'when calling spawn_flutter_app with an unknown appId, '
          'then it errors listing the available app ids and launches nothing',
          () async {
            final result = await connection.callTool(
              CallToolRequest(
                name: 'spawn_flutter_app',
                arguments: {'appId': 'nope'},
              ),
            );

            expect(result.isError, isTrue);
            final text = (result.content.first as TextContent).text;
            expect(text, contains('nope'));
            expect(text, contains('admin'));
            expect(text, contains('customer'));
            expect(spawnCalls, isEmpty);
          },
        );
      });

      group('with spawn_flutter_app but no configured apps', () {
        setUp(() {
          server.getFlutterAppIds = () => [];
          server.onSpawnFlutterApp = (_) async => false;
        });

        test(
          'when calling spawn_flutter_app, '
          'then it errors that no apps are configured',
          () async {
            final result = await connection.callTool(
              CallToolRequest(name: 'spawn_flutter_app'),
            );

            expect(result.isError, isTrue);
            expect(
              (result.content.first as TextContent).text,
              contains('No Flutter apps are configured'),
            );
          },
        );
      });

      group('with launched Flutter apps', () {
        setUp(() {
          // "portal" is launched but not ready (null); "admin" is ready (URI).
          // A non-launched app would simply be absent from the map.
          server.getFlutterDtdUris = () => {
            'admin': 'ws://127.0.0.1:9100/ws',
            'portal': null,
          };
        });

        test(
          'when calling get_flutter_app_dtd, '
          'then it returns the map of launched apps to DTD URIs',
          () async {
            final result = await connection.callTool(
              CallToolRequest(name: 'get_flutter_app_dtd'),
            );

            expect(result.isError, isNull);
            expect(
              jsonDecode((result.content.first as TextContent).text),
              {'admin': 'ws://127.0.0.1:9100/ws', 'portal': null},
            );
          },
        );
      });

      group('with no launched Flutter apps', () {
        setUp(() {
          server.getFlutterDtdUris = () => {};
        });

        test(
          'when calling get_flutter_app_dtd, '
          'then it returns an empty map',
          () async {
            final result = await connection.callTool(
              CallToolRequest(name: 'get_flutter_app_dtd'),
            );

            expect(result.isError, isNull);
            expect(
              jsonDecode((result.content.first as TextContent).text),
              <String, Object?>{},
            );
          },
        );
      });
    });
  });
}
