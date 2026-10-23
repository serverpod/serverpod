import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_mcp/client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod_cli/src/commands/start/mcp_socket.dart';
import 'package:serverpod_cli/src/mcp/bridge_mcp_server.dart';
import 'package:serverpod_cli/src/mcp/serverpod_issue_reporter.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

import '../test_util/fake_runner_api.dart';

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
/// tail_server_logs, tail_flutter_logs, spawn_flutter_app, get_flutter_app_dtd,
/// serverpod://vm-service) is advertised
/// upfront regardless of whether the runner is currently up. tail_runner_logs
/// is the bridge's own, answered from the runner's log file without a runner.
void main() {
  group(
    'Given a BridgeMcpServer wired to a running runner socket,',
    skip: !hasUnixSocketSupport(),
    () {
      late Directory tempServerDir;
      late McpSocketServer runner;
      late _Pair pair;
      late int applyMigrationCalls;
      late int stopCalls;

      setUp(() async {
        tempServerDir = await Directory.systemTemp.createTemp('bt');

        runner = McpSocketServer(serverDir: tempServerDir.path);
        await runner.start();

        applyMigrationCalls = 0;
        stopCalls = 0;
        runner.connect(
          FakeRunnerApi()
            ..onApplyMigrations = () async {
              applyMigrationCalls++;
            }
            ..onStop = () async {
              stopCalls++;
            },
        );

        pair = await _makeBridgePair(
          runner.socketPath,
          logPath: serverpodRunnerLogPath(tempServerDir.path),
          serverDir: tempServerDir.path,
        );
      });

      tearDown(() async {
        await pair.dispose();
        await runner.close();
        await _safeDelete(tempServerDir);
      });

      test(
        'when the bridge session ends after a call, '
        'then the runner is not asked to stop',
        () async {
          await pair.client.callTool(CallToolRequest(name: 'apply_migrations'));
          await pair.dispose();
          pair = await _makeBridgePair(
            runner.socketPath,
            logPath: serverpodRunnerLogPath(tempServerDir.path),
            serverDir: tempServerDir.path,
          );

          expect(stopCalls, 0);
        },
      );

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
              'spawn_flutter_app',
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
          logPath: serverpodRunnerLogPath(tempServerDir.path),
          serverDir: tempServerDir.path,
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
              'spawn_flutter_app',
              'get_flutter_app_dtd',
              'tail_runner_logs',
              'report_serverpod_issue',
            }),
          );
        },
      );

      test(
        'when calling apply_migrations with no runner, '
        'then the result is a not-running error pointing at serverpod runner start',
        () async {
          final result = await pair.client.callTool(
            CallToolRequest(name: 'apply_migrations'),
          );
          expect(result.isError, isTrue);
          final text = (result.content.first as TextContent).text;
          expect(text, contains('not running'));
          expect(text, contains('serverpod runner start'));
        },
      );

      test(
        'when calling tail_runner_logs with no log file, '
        'then the result is an error naming the missing file',
        () async {
          final result = await pair.client.callTool(
            CallToolRequest(name: 'tail_runner_logs'),
          );
          expect(result.isError, isTrue);
          final text = (result.content.first as TextContent).text;
          expect(text, contains('No runner log'));
          expect(text, contains('runner.log'));
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
    'Given a BridgeMcpServer for a project whose runner left a log file,',
    () {
      late Directory tempServerDir;
      late _Pair pair;
      final lines = [
        '--- serverpod runner 123 started ---',
        '2026-10-12T10:00:00.000 [INFO] Generating code.',
        '2026-10-12T10:00:01.000 [ERROR] Code generation failed.',
        'stderr: Unhandled exception: oops',
      ];

      setUp(() async {
        tempServerDir = await Directory.systemTemp.createTemp('bt');
        final logPath = serverpodRunnerLogPath(tempServerDir.path);
        await File(logPath).parent.create(recursive: true);
        await File(logPath).writeAsString(lines.join('\n'));
        // The socket path is a registry link the stopped runner removed.
        pair = await _makeBridgePair(
          '${tempServerDir.path}/registry/gone/mcp.sock',
          logPath: logPath,
          serverDir: tempServerDir.path,
        );
      });

      tearDown(() async {
        await pair.dispose();
        await _safeDelete(tempServerDir);
      });

      test(
        'when calling tail_runner_logs with no runner listening, '
        'then every line of the file is returned, oldest first',
        () async {
          final result = await pair.client.callTool(
            CallToolRequest(name: 'tail_runner_logs'),
          );
          expect(result.isError, isNull);
          final text = (result.content.single as TextContent).text;
          expect(jsonDecode(text), lines);
        },
      );

      test(
        'when calling tail_runner_logs with a limit below the line count, '
        'then only the newest lines are returned',
        () async {
          final result = await pair.client.callTool(
            CallToolRequest(name: 'tail_runner_logs', arguments: {'limit': 2}),
          );
          expect(result.isError, isNull);
          final text = (result.content.single as TextContent).text;
          expect(jsonDecode(text), lines.sublist(2));
        },
      );
    },
  );

  group(
    'Given a BridgeMcpServer with no runner listening,',
    () {
      late Directory tempServerDir;
      late _Pair pair;
      late List<http.Request> requests;
      late http.Response response;

      setUp(() async {
        tempServerDir = await Directory.systemTemp.createTemp('bt');
        requests = [];
        response = http.Response('', 201);
        pair = await _makeBridgePair(
          '${tempServerDir.path}/.dart_tool/serverpod/mcp.sock',
          logPath: serverpodRunnerLogPath(tempServerDir.path),
          serverDir: tempServerDir.path,
          issueReporter: ServerpodIssueReporter(
            url: Uri.parse('https://feedback.test/feedback'),
            client: MockClient((request) async {
              requests.add(request);
              return response;
            }),
          ),
        );
      });

      tearDown(() async {
        await pair.dispose();
        await _safeDelete(tempServerDir);
      });

      group('with a feedback service that creates issues,', () {
        group('when calling report_serverpod_issue for a bug,', () {
          late CallToolResult result;

          setUp(() async {
            result = await pair.client.callTool(
              CallToolRequest(
                name: 'report_serverpod_issue',
                arguments: {
                  'title': 'Migration drops index',
                  'description': 'Renaming a column drops its index.',
                  'type': 'bug',
                },
              ),
            );
          });

          test('then the result is not an error', () {
            expect(result.isError, isNull);
          });

          test('then the result says the report was sent', () {
            expect(
              (result.content.single as TextContent).text,
              contains('Report sent'),
            );
          });

          test(
            'then the report is sent with its title, description and type',
            () {
              final body =
                  jsonDecode(requests.single.body) as Map<String, dynamic>;
              expect(body, containsPair('title', 'Migration drops index'));
              expect(
                body,
                containsPair(
                  'description',
                  'Renaming a column drops its index.',
                ),
              );
              expect(body, containsPair('type', 'bug'));
            },
          );

          test(
            'then the report context names the MCP client that filed it',
            () {
              final body =
                  jsonDecode(requests.single.body) as Map<String, dynamic>;
              expect(
                body['context'],
                allOf(
                  containsPair('agent', 'bridge-test-client'),
                  containsPair('agentVersion', '0.0.0'),
                ),
              );
            },
          );

          test('then the report context holds the MCP protocol version', () {
            final body =
                jsonDecode(requests.single.body) as Map<String, dynamic>;
            expect(
              body['context'],
              containsPair(
                'mcpVersion',
                ProtocolVersion.latestSupported.versionString,
              ),
            );
          });
        });

        test(
          'when calling report_serverpod_issue without a type, '
          'then the report is sent as feedback',
          () async {
            await pair.client.callTool(
              CallToolRequest(
                name: 'report_serverpod_issue',
                arguments: {
                  'title': 'Migration tools are hard to discover',
                  'description': 'It took a while to find `create_migration`.',
                },
              ),
            );

            final body =
                jsonDecode(requests.single.body) as Map<String, dynamic>;
            expect(body, containsPair('type', 'feedback'));
          },
        );

        test(
          'when calling report_serverpod_issue with a title padded by whitespace, '
          'then the report is sent with the title trimmed',
          () async {
            await pair.client.callTool(
              CallToolRequest(
                name: 'report_serverpod_issue',
                arguments: {
                  'title': '  Migration drops index  ',
                  'description': 'Renaming a column drops its index.',
                },
              ),
            );

            final body =
                jsonDecode(requests.single.body) as Map<String, dynamic>;
            expect(body, containsPair('title', 'Migration drops index'));
          },
        );

        group(
          'when calling report_serverpod_issue with a blank description,',
          () {
            late CallToolResult result;

            setUp(() async {
              result = await pair.client.callTool(
                CallToolRequest(
                  name: 'report_serverpod_issue',
                  arguments: {
                    'title': 'Migration drops index',
                    'description': ' ',
                  },
                ),
              );
            });

            test('then the result is an error', () {
              expect(result.isError, isTrue);
            });

            test('then no report is sent', () {
              expect(requests, isEmpty);
            });
          },
        );
      });

      group('with a feedback service that rejects the report as invalid,', () {
        setUp(() {
          response = http.Response(
            jsonEncode({'error': '"title" is too long.'}),
            400,
          );
        });

        group('when calling report_serverpod_issue,', () {
          late CallToolResult result;

          setUp(() async {
            result = await pair.client.callTool(
              CallToolRequest(
                name: 'report_serverpod_issue',
                arguments: {
                  'title': 'Migration drops index',
                  'description': 'Renaming a column drops its index.',
                },
              ),
            );
          });

          test('then the result is an error', () {
            expect(result.isError, isTrue);
          });

          test('then the result holds the service error message', () {
            expect(
              (result.content.single as TextContent).text,
              contains('"title" is too long.'),
            );
          });

          test('then the result asks the agent to fix it and call again', () {
            expect(
              (result.content.single as TextContent).text,
              contains('Fix it and call again'),
            );
          });
        });
      });

      group('with a feedback service that fails internally,', () {
        setUp(() {
          response = http.Response(
            jsonEncode({'error': 'Something went wrong.'}),
            500,
          );
        });

        group('when calling report_serverpod_issue,', () {
          late CallToolResult result;

          setUp(() async {
            result = await pair.client.callTool(
              CallToolRequest(
                name: 'report_serverpod_issue',
                arguments: {
                  'title': 'Migration drops index',
                  'description': 'Renaming a column drops its index.',
                },
              ),
            );
          });

          test('then the result is an error', () {
            expect(result.isError, isTrue);
          });

          test('then the result suggests retrying once later', () {
            expect(
              (result.content.single as TextContent).text,
              contains('retry once later'),
            );
          });

          test('then the result points the user to GitHub issues', () {
            expect(
              (result.content.single as TextContent).text,
              contains('https://github.com/serverpod/serverpod/issues'),
            );
          });
        });
      });
    },
  );

  group(
    'Given a BridgeMcpServer that auto-connects after the runner appears,',
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
          final pair = await _makeBridgePair(
            socketPath,
            logPath: serverpodRunnerLogPath(tempServerDir.path),
            serverDir: tempServerDir.path,
          );
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
            FakeRunnerApi()
              ..onApplyMigrations = () async {
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

  group(
    'Given a BridgeMcpServer that has served a call through one runner,',
    skip: !hasUnixSocketSupport(),
    () {
      late Directory tempServerDir;
      late String socketPath;
      late _Pair pair;
      late McpSocketServer firstRunner;

      setUp(() async {
        tempServerDir = await Directory.systemTemp.createTemp('bt');
        addTearDown(() => _safeDelete(tempServerDir));
        socketPath = '${tempServerDir.path}/.dart_tool/serverpod/mcp.sock';
        pair = await _makeBridgePair(
          socketPath,
          logPath: serverpodRunnerLogPath(tempServerDir.path),
          serverDir: tempServerDir.path,
        );
        addTearDown(pair.dispose);

        firstRunner = McpSocketServer(serverDir: tempServerDir.path);
        await firstRunner.start();
        addTearDown(firstRunner.close);
        firstRunner.connect(FakeRunnerApi()..onApplyMigrations = () async {});
        final served = await pair.client.callTool(
          CallToolRequest(name: 'apply_migrations'),
        );
        expect(served.isError, anyOf(isNull, isFalse));
      });

      group('when that runner is replaced by another on the same socket,', () {
        var calls = 0;

        setUp(() async {
          calls = 0;
          await firstRunner.close();
          final replacement = McpSocketServer(serverDir: tempServerDir.path);
          await replacement.start();
          addTearDown(replacement.close);
          replacement.connect(
            FakeRunnerApi()
              ..onApplyMigrations = () async {
                calls++;
              }
              ..vmServiceUri = 'ws://x',
          );
        });

        test(
          'then the next call reaches the replacement through the same bridge',
          () async {
            final result = await pair.client.callTool(
              CallToolRequest(name: 'apply_migrations'),
            );

            expect(result.isError, anyOf(isNull, isFalse));
            expect(calls, 1);
          },
        );

        test('then the next resource read reaches the replacement', () async {
          final result = await pair.client.readResource(
            ReadResourceRequest(uri: 'serverpod://vm-service'),
          );

          final text = (result.contents.first as TextResourceContents).text;
          expect(
            jsonDecode(text),
            isNot(containsPair('error', 'not-running')),
          );
        });
      });
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

Future<_Pair> _makeBridgePair(
  String socketPath, {
  required String logPath,
  required String serverDir,
  ServerpodIssueReporter? issueReporter,
}) async {
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

  final bridge = BridgeMcpServer(
    bridgeChannel,
    socketPath: socketPath,
    logPath: logPath,
    serverDir: serverDir,
    issueReporter: issueReporter,
  );
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
