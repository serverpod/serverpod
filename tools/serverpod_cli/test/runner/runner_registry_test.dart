import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_manifest_publisher.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/runner/runner_registry.dart';
import 'package:serverpod_cli/src/runner/runner_stage.dart';
import 'package:serverpod_shared/serverpod_shared.dart' show bindUnixSocket;
import 'package:test/test.dart';

import '../test_util/hold_lock.dart';
import '../test_util/short_temp_dir.dart';

void main() {
  late Directory tempDir;
  late RunnerRegistry registry;

  setUp(() async {
    tempDir = await createShortTempDir('rrt');
    registry = RunnerRegistry(dir: Directory('${tempDir.path}/registry'));
  });

  tearDown(() async {
    try {
      tempDir.deleteSync(recursive: true);
    } on FileSystemException {
      // A test may have removed it already.
    }
  });

  group('Given a default registry directory set for tests,', () {
    test(
      'when a registry is built without a directory, '
      'then it lives there rather than under the user home',
      () {
        RunnerRegistry.defaultDir = Directory('${tempDir.path}/default');
        addTearDown(() => RunnerRegistry.defaultDir = null);

        expect(RunnerRegistry().dir.path, '${tempDir.path}/default');
      },
    );
  });

  group('Given an empty registry,', () {
    test(
      'when scanned, '
      'then nothing is found and no directory is created',
      () async {
        expect(await registry.scan(), isEmpty);
        expect(await registry.dir.exists(), isFalse);
      },
    );

    test(
      'when a server directory is registered, '
      'then its entry names the canonical directory and nothing else',
      () async {
        final serverDir = await _serverDir(tempDir, 'one');

        await registry.register('$serverDir/./');

        final entries = await registry.dir.list().toList();
        expect(entries, hasLength(1));
        final decoded = jsonDecode(
          await (entries.single as File).readAsString(),
        );
        expect(decoded, {'serverDir': serverDir});
      },
    );

    test(
      'when the same directory is registered twice, '
      'then there is one entry',
      () async {
        final serverDir = await _serverDir(tempDir, 'one');

        await registry.register(serverDir);
        await registry.register(serverDir);

        expect(await registry.serverDirs(), [serverDir]);
      },
    );

    test(
      'when a directory that was never registered is unregistered, '
      'then nothing is thrown',
      () async {
        await registry.unregister('${tempDir.path}/absent');
      },
    );
  });

  group('Given registered server directories,', () {
    late String live;
    late String dead;

    setUp(() async {
      live = await _serverDir(tempDir, 'live');
      dead = await _serverDir(tempDir, 'dead');
      await _writeManifest(live, mcp: await _listen(tempDir));
      await _writeManifest(dead);
      await registry.register(live);
      await registry.register(dead);
    });

    test(
      'when scanned, '
      'then the one with a listening runner is returned as live',
      () async {
        final found = await registry.scan();

        expect(found.map((r) => r.serverDir), [live]);
        expect(found.single.resolution, isA<LiveRunner>());
      },
    );

    test(
      'when scanned, '
      'then the entry whose runner is gone is pruned',
      () async {
        await registry.scan();

        expect(await registry.serverDirs(), [live]);
      },
    );

    test(
      'when the runner of an entry holds its lock but does not answer, '
      'then scanning keeps the entry',
      () async {
        final busy = await _serverDir(tempDir, 'busy');
        await _writeManifest(busy);
        await holdLockFromAnotherProcess(busy);
        await registry.register(busy);

        await registry.scan();

        expect(await registry.serverDirs(), containsAll([live, busy]));
      },
    );

    test(
      'when an entry is not JSON, '
      'then it is skipped and the others are still read',
      () async {
        await File('${registry.dir.path}/garbage.json').writeAsString('{');

        expect(await registry.serverDirs(), containsAll([live, dead]));
      },
    );
  });

  group('Given a manifest publisher with a registry,', () {
    late String serverDir;
    late RunnerManifestPublisher publisher;

    setUp(() async {
      serverDir = await _serverDir(tempDir, 'pub');
      publisher = RunnerManifestPublisher(
        serverDir: serverDir,
        manifest: _manifest(serverDir),
        registry: registry,
      );
    });

    test(
      'when the manifest is published, '
      'then the runner is registered',
      () async {
        await publisher.publish();

        expect(await registry.serverDirs(), [serverDir]);
      },
    );

    test(
      'when the publisher is disposed, '
      'then the runner is unregistered',
      () async {
        await publisher.publish();

        await publisher.dispose();

        expect(await registry.serverDirs(), isEmpty);
      },
    );

    test(
      'when a manifest is left behind for an aborted start, '
      'then the manifest stays but the runner is unregistered',
      () async {
        await publisher.publish();

        await publisher.leaveBehind(
          publisher.manifest.copyWith(stage: RunnerStage.stopping, exitCode: 1),
        );

        expect(await registry.serverDirs(), isEmpty);
        expect((await RunnerManifest.readFrom(serverDir))?.exitCode, 1);
      },
    );
  });
}

Future<String> _serverDir(Directory tempDir, String name) async {
  final dir = await Directory('${tempDir.path}/$name').create();
  return dir.resolveSymbolicLinksSync();
}

Future<String> _listen(Directory dir) async {
  final path = '${dir.path}/live.sock';
  final server = await bindUnixSocket(path);
  addTearDown(server.close);
  server.listen((socket) => socket.destroy());
  return path;
}

RunnerManifest _manifest(String serverDir, {String? mcp}) => RunnerManifest(
  pid: 4242,
  sockets: RunnerSockets(
    tui: serverpodTuiSocketPath(serverDir),
    mcp: mcp ?? '$serverDir/absent.sock',
  ),
  config: const RunnerConfig(watch: true, flutter: true, serverArgs: []),
);

Future<void> _writeManifest(String serverDir, {String? mcp}) =>
    _manifest(serverDir, mcp: mcp).writeTo(serverDir);
