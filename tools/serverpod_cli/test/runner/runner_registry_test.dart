import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_manifest_publisher.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/runner/runner_registry.dart';
import 'package:serverpod_shared/serverpod_shared.dart'
    show FileEx, bindUnixSocket;
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

  tearDown(() => tempDir.deleteBestEffort(recursive: true));

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
      'then its entry links its id to the canonical tool directory',
      () async {
        final serverDir = await _serverDir(tempDir, 'one');

        await registry.register('$serverDir/./');

        final entries = await registry.dir.list(followLinks: false).toList();
        expect(entries, hasLength(1));
        final link = entries.single;
        expect(link, isA<Link>());
        expect(link.path, registry.toolDirFor(RunnerRegistry.idFor(serverDir)));
        expect(await (link as Link).target(), serverpodToolDirPath(serverDir));
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
      await _listen(live);
      await _writeManifest(live);
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
      'when an entry is not a link, '
      'then it is skipped and the others are still read',
      () async {
        await File('${registry.dir.path}/garbage.json').writeAsString('{');

        expect(await registry.serverDirs(), containsAll([live, dead]));
      },
    );

    test(
      'when a registered package has been deleted, '
      'then scanning prunes its dangling link',
      () async {
        final gone = await _serverDir(tempDir, 'gone');
        await registry.register(gone);
        await Directory(gone).delete(recursive: true);

        await registry.scan();

        expect(await registry.serverDirs(), [live]);
      },
    );
  });

  group('Given a registry at a path too long for a socket,', () {
    late RunnerRegistry farRegistry;

    setUp(() {
      farRegistry = RunnerRegistry(
        dir: Directory('${tempDir.path}/${'r' * 120}'),
      );
    });

    test(
      'when a registered package sits at such a path as well, '
      'then scanning keeps its entry, since the runner is not known to be dead',
      () async {
        final far = await _serverDir(tempDir, 'f' * 120);
        await _writeManifest(far);
        await farRegistry.register(far);

        await farRegistry.scan();

        expect(await farRegistry.serverDirs(), [far]);
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
      'when the publisher finishes, '
      'then the manifest stays but the runner is unregistered',
      () async {
        await publisher.publish();

        await publisher.finish(exitCode: 1);

        expect(await registry.serverDirs(), isEmpty);
        expect((await RunnerManifest.readFrom(serverDir))?.exitCode, 1);
      },
    );
  });
}

/// Creates a server directory and returns its canonical, resolved path.
Future<String> _serverDir(Directory tempDir, String name) async {
  final dir = await Directory('${tempDir.path}/$name').create();
  return p.canonicalize(dir.resolveSymbolicLinksSync());
}

/// Binds the attach socket of the server package at [serverDir].
Future<void> _listen(String serverDir) async {
  final path = serverpodTuiSocketPath(serverDir);
  await File(path).parent.create(recursive: true);
  final server = await bindUnixSocket(path);
  addTearDown(server.close);
  server.listen((socket) => socket.destroy());
}

RunnerManifest _manifest(String serverDir) => RunnerManifest(
  pid: 4242,
  projectId: RunnerRegistry.idFor(serverDir),
  config: const RunnerConfig(watch: true, flutter: true, serverArgs: []),
);

Future<void> _writeManifest(String serverDir) =>
    _manifest(serverDir).writeTo(serverDir);
