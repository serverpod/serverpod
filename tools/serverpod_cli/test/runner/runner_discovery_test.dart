import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/runner/runner_registry.dart';
import 'package:serverpod_shared/serverpod_shared.dart'
    show FileEx, bindUnixSocket;
import 'package:test/test.dart';

import '../test_util/hold_lock.dart';
import '../test_util/short_temp_dir.dart';

void main() {
  group('Given a server package at a path too long for a Unix socket,', () {
    late Directory tempDir;
    late String serverDir;
    late RunnerRegistry registry;

    setUp(() async {
      // The registry link has to fit where the package does not.
      tempDir = await createShortTempDir('rdt');
      serverDir = '${tempDir.path}/${'p' * 120}';
      await Directory(serverpodToolDirPath(serverDir)).create(recursive: true);
      registry = RunnerRegistry(dir: Directory('${tempDir.path}/r'));
      await _writeManifest(serverDir);
    });

    tearDown(() async {
      await tempDir.deleteIfExists(recursive: true);
    });

    test(
      'when its runner is registered and listening, '
      'then it is resolved as live through the registry link',
      () async {
        await registry.register(serverDir);
        final linked = p.join(
          registry.toolDirFor(RunnerRegistry.idFor(serverDir)),
          serverpodTuiSocketName,
        );
        await _listenAt(linked);

        final resolution = await resolveRunner(serverDir, registry: registry);

        expect(resolution, isA<LiveRunner>());
        expect((resolution as LiveRunner).tuiSocket, linked);
      },
    );

    test(
      'when the registry sits at a path too long for a socket as well, '
      'then resolving throws naming both paths, not reporting no runner',
      () async {
        final far = RunnerRegistry(
          dir: Directory('${tempDir.path}/${'r' * 120}'),
        );

        await expectLater(
          resolveRunner(serverDir, registry: far),
          throwsA(
            isA<SocketException>().having(
              (e) => e.message,
              'message',
              allOf(contains(serverDir), contains(far.dir.path)),
            ),
          ),
        );
      },
    );
  });

  group('Given a server package directory,', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await createShortTempDir('rdt');
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
      'when nothing listens beside the manifest, '
      'then no runner is resolved and the manifest is reported as stale',
      () async {
        await _writeManifest(tempDir.path, pid: 9999);

        final resolution = await resolveRunner(tempDir.path);

        expect(resolution, isA<NoRunner>());
        expect((resolution as NoRunner).staleManifest?.pid, 9999);
      },
    );

    test(
      'when the attach socket beside the manifest is listening, '
      'then the runner is resolved as live at that socket, registry or not',
      () async {
        final socketPath = await _listen(tempDir);
        await _writeManifest(tempDir.path);
        final registry = RunnerRegistry(
          dir: Directory('${tempDir.path}/registry'),
        );
        await registry.register(tempDir.path);

        final resolution = await resolveRunner(
          tempDir.path,
          registry: registry,
        );

        expect(resolution, isA<LiveRunner>());
        expect((resolution as LiveRunner).versionWarning, isNull);
        expect(resolution.tuiSocket, socketPath);
      },
    );

    test(
      'when the live runner speaks a different protocol version, '
      'then it is reported as incompatible with the way to replace it',
      () async {
        await _listen(tempDir);
        await _writeManifest(
          tempDir.path,
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
        await _listen(tempDir);
        await _writeManifest(tempDir.path, cliVersion: '0.0.1-ancient');

        final resolution = await resolveRunner(tempDir.path);

        expect(resolution, isA<LiveRunner>());
        expect(
          (resolution as LiveRunner).versionWarning,
          allOf(contains('0.0.1-ancient'), contains(templateVersion)),
        );
      },
    );

    test(
      'when only the MCP socket beside the manifest is listening, '
      'then liveness falls back to it',
      () async {
        await _listen(tempDir, name: serverpodMcpSocketName);
        await _writeManifest(tempDir.path);

        expect(await resolveRunner(tempDir.path), isA<LiveRunner>());
      },
    );
  });

  group('Given a manifest whose runner does not answer,', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await createShortTempDir('rdl');
      await _writeManifest(tempDir.path, pid: 424242);
    });

    tearDown(() async {
      await tempDir.deleteIfExists(recursive: true);
    });

    test(
      'when its process still holds the lock, '
      'then it is resolved as no runner with the lock held',
      () async {
        await holdLockFromAnotherProcess(tempDir.path);

        final resolution = await resolveRunner(tempDir.path);

        expect(
          resolution,
          isA<NoRunner>()
              .having((r) => r.lockHeld, 'lockHeld', isTrue)
              .having((r) => r.staleManifest?.pid, 'pid', 424242),
        );
      },
    );

    test(
      'when the lock is free, '
      'then it is resolved as no runner with the lock free',
      () async {
        final resolution = await resolveRunner(tempDir.path);

        expect(
          resolution,
          isA<NoRunner>().having((r) => r.lockHeld, 'lockHeld', isFalse),
        );
      },
    );
  });
}

/// Binds the runner socket [name] beside the manifest of the server package
/// at [dir] and returns its path.
Future<String> _listen(
  Directory dir, {
  String name = serverpodTuiSocketName,
}) async {
  final path = p.join(serverpodToolDirPath(dir.path), name);
  await File(path).parent.create(recursive: true);
  return _listenAt(path);
}

/// Binds a Unix socket at [path] and returns it.
Future<String> _listenAt(String path) async {
  final server = await bindUnixSocket(path);
  addTearDown(server.close);
  server.listen((socket) => socket.destroy());
  return path;
}

Future<void> _writeManifest(
  String serverDir, {
  int pid = 4242,
  int protocolVersion = RunnerManifest.currentProtocolVersion,
  String cliVersion = templateVersion,
}) => RunnerManifest(
  pid: pid,
  protocolVersion: protocolVersion,
  cliVersion: cliVersion,
  projectId: RunnerRegistry.idFor(serverDir),
  config: const RunnerConfig(watch: true, flutter: true, serverArgs: []),
).writeTo(serverDir);
