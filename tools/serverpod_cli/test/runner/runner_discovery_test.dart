import 'dart:io';

import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_shared/serverpod_shared.dart'
    show FileEx, bindUnixSocket;
import 'package:test/test.dart';

void main() {
  group('Given a server package directory,', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('rdt');
    });

    tearDown(() async {
      await tempDir.deleteIfExists(recursive: true);
    });

    test(
      'when no manifest exists, '
      'then no runner is resolved and nothing is reported as stale',
      () async {
        final resolution = await resolveRunner(tempDir.path);

        expect(resolution, isA<NoRunner>());
        expect((resolution as NoRunner).staleManifest, isNull);
      },
    );

    test(
      'when a manifest names a socket nothing listens on, '
      'then no runner is resolved and the manifest is reported as stale',
      () async {
        await _writeManifest(tempDir.path, pid: 9999);

        final resolution = await resolveRunner(tempDir.path);

        expect(resolution, isA<NoRunner>());
        expect((resolution as NoRunner).staleManifest?.pid, 9999);
      },
    );

    test(
      'when a manifest names a socket that is listening, '
      'then the runner is resolved as live',
      () async {
        final socketPath = await _listen(tempDir);
        await _writeManifest(tempDir.path, mcp: socketPath);

        final resolution = await resolveRunner(tempDir.path);

        expect(resolution, isA<LiveRunner>());
        expect((resolution as LiveRunner).versionWarning, isNull);
      },
    );

    test(
      'when the live runner speaks a different protocol version, '
      'then it is reported as incompatible with the way to replace it',
      () async {
        final socketPath = await _listen(tempDir);
        await _writeManifest(
          tempDir.path,
          mcp: socketPath,
          protocolVersion: RunnerManifest.currentProtocolVersion + 1,
        );

        final resolution = await resolveRunner(tempDir.path);

        expect(resolution, isA<IncompatibleRunner>());
        expect((resolution as IncompatibleRunner).message, contains('stop'));
      },
    );

    test(
      'when the live runner came from a different CLI version, '
      'then it is still live but carries a version warning',
      () async {
        final socketPath = await _listen(tempDir);
        await _writeManifest(
          tempDir.path,
          mcp: socketPath,
          cliVersion: '0.0.1-ancient',
        );

        final resolution = await resolveRunner(tempDir.path);

        expect(resolution, isA<LiveRunner>());
        expect(
          (resolution as LiveRunner).versionWarning,
          allOf(contains('0.0.1-ancient'), contains(templateVersion)),
        );
      },
    );

    test(
      'when the manifest names only an MCP socket, '
      'then liveness falls back to it, so a runner predating attach is found',
      () async {
        final socketPath = await _listen(tempDir);
        await _writeManifest(tempDir.path, tui: '', mcp: socketPath);

        expect(await resolveRunner(tempDir.path), isA<LiveRunner>());
      },
    );
  });
}

/// Binds a Unix socket under [dir] and returns its path.
Future<String> _listen(Directory dir) async {
  final path = '${dir.path}/live.sock';
  final server = await bindUnixSocket(path);
  addTearDown(server.close);
  server.listen((socket) => socket.destroy());
  return path;
}

Future<void> _writeManifest(
  String serverDir, {
  int pid = 4242,
  String? tui,
  String? mcp,
  int protocolVersion = RunnerManifest.currentProtocolVersion,
  String cliVersion = templateVersion,
}) => RunnerManifest(
  pid: pid,
  protocolVersion: protocolVersion,
  cliVersion: cliVersion,
  sockets: RunnerSockets(
    tui: tui ?? serverpodTuiSocketPath(serverDir),
    mcp: mcp ?? '$serverDir/absent.sock',
  ),
  config: const RunnerConfig(watch: true, flutter: true, serverArgs: []),
).writeTo(serverDir);
