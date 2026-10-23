@Tags(['integration'])
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:dart_mcp/client.dart';
import 'package:dart_mcp/stdio.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../test_util/endpoint_validation_helpers.dart';
import '../test_util/file_system_entity_helpers.dart';

void main() {
  group('Given two checkouts with the same server package and no runner,', () {
    late Directory temporary;
    late Directory firstCheckout;
    late Directory secondCheckout;
    late String firstServerDir;
    late String secondServerDir;

    setUpAll(() async {
      temporary = await Directory.systemTemp.createTemp('mcp');
      addTearDown(() => temporary.deleteWithRetry(recursive: true));
      firstCheckout = Directory(p.join(temporary.path, 'checkout a'));
      secondCheckout = Directory(p.join(temporary.path, 'checkout b'));
      firstServerDir = p.canonicalize(
        p.join(firstCheckout.path, 'projectname_server'),
      );
      secondServerDir = p.canonicalize(
        p.join(secondCheckout.path, 'projectname_server'),
      );

      for (final serverDir in [firstServerDir, secondServerDir]) {
        final pubspec = File(p.join(serverDir, 'pubspec.yaml'));
        await pubspec.parent.create(recursive: true);
        await pubspec.writeAsString('''
name: projectname_server
environment:
  sdk: ^3.12.2
dependencies:
  serverpod: any
''');
      }
    });

    group(
      'when initializing and calling tools through bridges configured with the same relative server directory,',
      timeout: const Timeout(Duration(minutes: 3)),
      () {
        late _BridgeReplies first;
        late _BridgeReplies second;

        setUpAll(() async {
          first = await _readBridgeReplies(
            workingDirectory: firstCheckout.path,
            serverDirectory: './projectname_server',
            registryDirectory: p.join(temporary.path, 'r'),
          );
          second = await _readBridgeReplies(
            workingDirectory: secondCheckout.path,
            serverDirectory: './projectname_server',
            registryDirectory: p.join(temporary.path, 'r'),
          );
        });

        test(
          'then initialization identifies each checkout and its recovery.',
          () {
            expect(
              first.instructions,
              contains('Manage the Serverpod server in $firstServerDir '),
            );
            expect(
              first.instructions,
              contains('`--directory` set to `$firstServerDir`'),
            );
            expect(
              second.instructions,
              contains('Manage the Serverpod server in $secondServerDir '),
            );
            expect(
              second.instructions,
              contains('`--directory` set to `$secondServerDir`'),
            );
          },
        );

        test('then failed tool calls direct recovery to their own checkout.', () {
          expect(first.notRunning.isError, isTrue);
          expect(second.notRunning.isError, isTrue);
          expect(
            (first.notRunning.content.single as TextContent).text,
            'The server in $firstServerDir is not running. Call '
            '`tail_runner_logs` to see whether it is still starting or why it '
            'stopped, then run `serverpod runner start` with '
            '`--directory` set to `$firstServerDir` and call this tool again.',
          );
          expect(
            (second.notRunning.content.single as TextContent).text,
            'The server in $secondServerDir is not running. Call '
            '`tail_runner_logs` to see whether it is still starting or why it '
            'stopped, then run `serverpod runner start` with '
            '`--directory` set to `$secondServerDir` and call this tool again.',
          );
        });

        test('then missing logs direct recovery to their own checkout.', () {
          expect(first.missingLog.isError, isTrue);
          expect(second.missingLog.isError, isTrue);
          expect(
            (first.missingLog.content.single as TextContent).text,
            contains('`--directory` set to `$firstServerDir`'),
          );
          expect(
            (second.missingLog.content.single as TextContent).text,
            contains('`--directory` set to `$secondServerDir`'),
          );
        });
      },
    );
  });
}

typedef _BridgeReplies = ({
  String instructions,
  CallToolResult notRunning,
  CallToolResult missingLog,
});

/// Exercises the CLI's directory resolution and stdio protocol without starting
/// a runner or applying migrations. Each process has its own working directory.
Future<_BridgeReplies> _readBridgeReplies({
  required String workingDirectory,
  required String serverDirectory,
  required String registryDirectory,
}) async {
  final packageConfig = (await Isolate.packageConfig)!.toFilePath();
  final process = await Process.start(
    Platform.resolvedExecutable,
    [
      '--disable-dart-dev',
      '--packages=$packageConfig',
      await resolveServerpodCliEntrypoint(),
      '--no-analytics',
      '--no-interactive',
      'mcp-server',
      '--server-dir',
      serverDirectory,
    ],
    workingDirectory: workingDirectory,
    environment: {
      // Skip the unrelated Flutter installation check in this CLI-only test.
      'CI': 'true',
      'SERVERPOD_RUNNER_REGISTRY_DIR': registryDirectory,
    },
  );
  final stderr = StringBuffer();
  final stderrSubscription = process.stderr
      .transform(utf8.decoder)
      .listen(
        stderr.write,
      );
  final client = MCPClient(
    Implementation(name: 'mcp-command-test', version: '0.0.0'),
  );
  final connection = client.connectServer(
    stdioChannel(input: process.stdout, output: process.stdin),
  );

  try {
    final initialized = await connection
        .initialize(
          InitializeRequest(
            protocolVersion: ProtocolVersion.latestSupported,
            capabilities: client.capabilities,
            clientInfo: client.implementation,
          ),
        )
        .timeout(const Duration(seconds: 90));
    connection.notifyInitialized(InitializedNotification());

    final notRunning = await connection
        .callTool(CallToolRequest(name: 'apply_migrations'))
        .timeout(const Duration(seconds: 10));
    final missingLog = await connection
        .callTool(CallToolRequest(name: 'tail_runner_logs'))
        .timeout(const Duration(seconds: 10));

    return (
      instructions: initialized.instructions!,
      notRunning: notRunning,
      missingLog: missingLog,
    );
  } catch (error) {
    throw TestFailure('MCP bridge failed: $error\n$stderr');
  } finally {
    await client.shutdown();
    try {
      await process.exitCode.timeout(const Duration(seconds: 5));
    } on TimeoutException {
      process.kill(ProcessSignal.sigkill);
      await process.exitCode;
    }
    await stderrSubscription.cancel();
  }
}
