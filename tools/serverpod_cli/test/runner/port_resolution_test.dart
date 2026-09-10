import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/port_resolution.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/runner/runner_registry.dart';
import 'package:serverpod_shared/serverpod_shared.dart'
    show FileEx, ServerpodAddresses, bindUnixSocket;
import 'package:test/test.dart';

import '../test_util/hold_lock.dart';
import '../test_util/short_temp_dir.dart';

void main() {
  group('Given configured ports and a server package,', () {
    late Directory root;
    late String serverDir;
    late RunnerRegistry registry;

    setUp(() async {
      root = await createShortTempDir('prt');
      serverDir = p.join(root.path, 'main', 'my_server');
      await Directory(serverDir).create(recursive: true);
      registry = RunnerRegistry(dir: Directory(p.join(root.path, 'registry')));
    });

    tearDown(() async {
      await root.deleteIfExists(recursive: true);
    });

    test(
      'when the configured ports are free, '
      'then the configured ports are kept',
      () async {
        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': await _freePort(), 'web': await _freePort()},
        );

        expect(resolution.useEphemeral, isFalse);
        expect(resolution.hasConflicts, isFalse);
      },
    );

    test(
      'when a port is held by something that is not a runner, '
      'then it is a conflict rather than a reason to move aside',
      () async {
        final occupied = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        addTearDown(occupied.close);

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': occupied.port},
        );

        expect(resolution.hasConflicts, isTrue);
        expect(resolution.conflicts['api'], occupied.port);
        expect(resolution.useEphemeral, isFalse);
      },
    );

    test(
      'when a port is held on the IPv6 loopback only, '
      'then it is still a conflict, the pod\'s socket need not answer on IPv4',
      () async {
        final occupied = await ServerSocket.bind(
          InternetAddress.loopbackIPv6,
          0,
        );
        addTearDown(occupied.close);

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': occupied.port},
        );

        expect(resolution.conflicts['api'], occupied.port);
      },
    );

    test(
      'when a port is held the way the pod holds one, bound on anyIPv6, '
      'then it is a conflict',
      () async {
        final occupied = await ServerSocket.bind(InternetAddress.anyIPv6, 0);
        addTearDown(occupied.close);

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': occupied.port},
        );

        expect(resolution.conflicts['api'], occupied.port);
      },
    );

    test(
      'when a sibling worktree has a live runner publishing the held port, '
      'then the stack falls back to ephemeral ports',
      () async {
        final occupied = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        addTearDown(occupied.close);
        addTearDown(
          (await _startSiblingRunner(
            registry,
            root.path,
            'wt2',
            'my_server',
            apiPort: occupied.port,
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': occupied.port},
        );

        expect(resolution.useEphemeral, isTrue);
        expect(resolution.hasConflicts, isFalse);
      },
    );

    test(
      'when a sibling worktree left a manifest but no live runner, '
      'then the held port is a conflict, not a reason to move aside',
      () async {
        final occupied = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        addTearDown(occupied.close);
        await _writeDeadSiblingManifest(
          registry,
          root.path,
          'wt2',
          'my_server',
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': occupied.port},
        );

        expect(resolution.hasConflicts, isTrue);
        expect(resolution.useEphemeral, isFalse);
      },
    );

    test(
      'when one of several ports is held by another runner, '
      'then all three fall back together rather than splitting the stack',
      () async {
        final occupied = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        addTearDown(occupied.close);
        addTearDown(
          (await _startSiblingRunner(
            registry,
            root.path,
            'wt2',
            'my_server',
            apiPort: occupied.port,
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {
            'api': occupied.port,
            'insights': await _freePort(),
            'web': await _freePort(),
          },
        );

        expect(resolution.useEphemeral, isTrue);
        expect(
          ephemeralPortEnvironment(const ['api', 'insights', 'web']).keys,
          containsAll(portEnvironmentVariables.values),
        );
      },
    );

    test(
      'when a live sibling runner holds entirely different ports, '
      'then the occupied port is a conflict rather than a reason to move',
      () async {
        final occupied = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        addTearDown(occupied.close);
        addTearDown(
          (await _startSiblingRunner(
            registry,
            root.path,
            'wt2',
            'my_server',
            apiPort: await _freePort(),
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': occupied.port},
        );

        expect(resolution.useEphemeral, isFalse);
        expect(resolution.conflicts, {'api': occupied.port});
      },
    );

    test(
      'when a live sibling runner has published no addresses at all, '
      'then the stack moves aside rather than blaming the port it cannot name',
      () async {
        final occupied = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        addTearDown(occupied.close);
        addTearDown(
          (await _startSiblingRunner(
            registry,
            root.path,
            'wt2',
            'my_server',
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': occupied.port},
        );

        expect(resolution.useEphemeral, isTrue);
        expect(resolution.hasConflicts, isFalse);
      },
    );

    test(
      'when a live sibling runner has published no addresses at all, '
      'then the port it could not account for is still named',
      () async {
        final occupied = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        addTearDown(occupied.close);
        addTearDown(
          (await _startSiblingRunner(
            registry,
            root.path,
            'wt2',
            'my_server',
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': occupied.port},
        );

        expect(resolution.unattributed, {'api': occupied.port});
      },
    );

    test(
      'when a sibling runner is silent and another holds the published port, '
      'then only the port neither accounts for is named',
      () async {
        final held = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
        final unknown = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        addTearDown(held.close);
        addTearDown(unknown.close);
        addTearDown(
          (await _startSiblingRunner(
            registry,
            root.path,
            'wt2',
            'my_server',
            apiPort: held.port,
          )).close,
        );
        addTearDown(
          (await _startSiblingRunner(
            registry,
            root.path,
            'wt3',
            'my_server',
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': held.port, 'web': unknown.port},
        );

        expect(resolution.useEphemeral, isTrue);
        expect(resolution.hasConflicts, isFalse);
        expect(resolution.unattributed, {'web': unknown.port});
      },
    );

    test(
      'when the ports are free but a sibling runner has not decided its ports, '
      'then the stack moves aside before the two race for the same ports',
      () async {
        addTearDown(
          (await _startSiblingRunner(
            registry,
            root.path,
            'wt2',
            'my_server',
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': await _freePort()},
        );

        expect(resolution.useEphemeral, isTrue);
        expect(resolution.hasConflicts, isFalse);
      },
    );

    test(
      'when the ports are free but a starting sibling has claimed one, '
      'then the stack moves aside before the two race for it',
      () async {
        final port = await _freePort();
        addTearDown(
          (await _startSiblingRunner(
            registry,
            root.path,
            'wt2',
            'my_server',
            claimedPorts: {'api': port},
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': port, 'web': await _freePort()},
        );

        expect(resolution.useEphemeral, isTrue);
        expect(resolution.hasConflicts, isFalse);
      },
    );

    test(
      'when the ports are free and a starting sibling claims other ports, '
      'then the configured ports are kept',
      () async {
        addTearDown(
          (await _startSiblingRunner(
            registry,
            root.path,
            'wt2',
            'my_server',
            claimedPorts: {'api': await _freePort()},
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': await _freePort()},
        );

        expect(resolution.useEphemeral, isFalse);
        expect(resolution.hasConflicts, isFalse);
      },
    );

    test(
      'when the ports are free and a sibling has moved aside, claiming none, '
      'then the configured ports are kept',
      () async {
        addTearDown(
          (await _startSiblingRunner(
            registry,
            root.path,
            'wt2',
            'my_server',
            claimedPorts: const {},
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': await _freePort()},
        );

        expect(resolution.useEphemeral, isFalse);
        expect(resolution.hasConflicts, isFalse);
      },
    );

    test(
      'when a port is held and the only sibling has claimed other ports, '
      'then the port is a conflict rather than a reason to move aside',
      () async {
        final occupied = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        addTearDown(occupied.close);
        addTearDown(
          (await _startSiblingRunner(
            registry,
            root.path,
            'wt2',
            'my_server',
            claimedPorts: {'api': await _freePort()},
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': occupied.port},
        );

        expect(resolution.useEphemeral, isFalse);
        expect(resolution.conflicts, {'api': occupied.port});
      },
    );

    test(
      'when the ports are free and a sibling runner published other ports, '
      'then the configured ports are kept',
      () async {
        addTearDown(
          (await _startSiblingRunner(
            registry,
            root.path,
            'wt2',
            'my_server',
            apiPort: await _freePort(),
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': await _freePort()},
        );

        expect(resolution.useEphemeral, isFalse);
        expect(resolution.hasConflicts, isFalse);
      },
    );

    test(
      'when a port is held and a sibling runner holds its lock but is silent, '
      'then the stack moves aside rather than blaming the port',
      () async {
        final occupied = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        addTearDown(occupied.close);
        final sibling = await _prepareSibling(root.path, 'wt2', 'my_server');
        await _writeManifest(sibling);
        await registry.register(sibling);
        await holdLockFromAnotherProcess(sibling);

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': occupied.port},
        );

        expect(resolution.useEphemeral, isTrue);
        expect(resolution.hasConflicts, isFalse);
        expect(resolution.unattributed, {'api': occupied.port});
      },
    );

    test(
      'when a sibling runner of another protocol publishes the held port, '
      'then the stack moves aside as it would for one speaking this version',
      () async {
        final occupied = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        addTearDown(occupied.close);
        addTearDown(
          (await _startSiblingRunner(
            registry,
            root.path,
            'wt2',
            'my_server',
            apiPort: occupied.port,
            protocolVersion: RunnerManifest.currentProtocolVersion + 1,
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': occupied.port},
        );

        expect(resolution.useEphemeral, isTrue);
        expect(resolution.hasConflicts, isFalse);
      },
    );

    test(
      'when a port is zero, '
      'then it is already ephemeral and needs no probe',
      () async {
        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': 0},
        );

        expect(resolution.useEphemeral, isFalse);
        expect(resolution.hasConflicts, isFalse);
      },
    );
  });

  group('Given a port resolution,', () {
    const ports = {'api': 0, 'insights': 8081, 'web': 0};

    test(
      'when the stack moved aside, '
      'then every listener binds an ephemeral port',
      () {
        final resolution = PortResolution(
          useEphemeral: true,
          conflicts: const {},
        );

        expect(resolution.ephemeralListeners(ports), [
          'api',
          'insights',
          'web',
        ]);
      },
    );

    test(
      'when the stack keeps its ports, '
      'then listeners configured with port zero still bind ephemeral ports',
      () {
        final resolution = PortResolution(
          useEphemeral: false,
          conflicts: const {},
        );

        expect(resolution.ephemeralListeners(ports), ['api', 'web']);
      },
    );

    test(
      'when the stack moved aside, '
      'then it claims no port',
      () {
        final resolution = PortResolution(
          useEphemeral: true,
          conflicts: const {},
        );

        expect(resolution.claimedPorts(ports), isEmpty);
      },
    );

    test(
      'when the stack keeps its ports, '
      'then it claims the ones configured with a fixed port',
      () {
        final resolution = PortResolution(
          useEphemeral: false,
          conflicts: const {},
        );

        expect(resolution.claimedPorts(ports), {'insights': 8081});
      },
    );
  });

  group('Given the ephemeral port overrides,', () {
    test(
      'when they are applied, '
      'then every configured listener is asked for zero, public port included',
      () {
        expect(ephemeralPortEnvironment(const ['api', 'insights', 'web']), {
          'SERVERPOD_API_SERVER_PORT': '0',
          'SERVERPOD_API_SERVER_PUBLIC_PORT': '0',
          'SERVERPOD_INSIGHTS_SERVER_PORT': '0',
          'SERVERPOD_INSIGHTS_SERVER_PUBLIC_PORT': '0',
          'SERVERPOD_WEB_SERVER_PORT': '0',
          'SERVERPOD_WEB_SERVER_PUBLIC_PORT': '0',
        });
      },
    );

    test(
      'when the pod reports the ports it bound, '
      'then the overrides pin them, so a restarted pod keeps its address',
      () {
        expect(
          pinResolvedPorts(
            const {
              'SERVERPOD_API_SERVER_PORT': '0',
              'SERVERPOD_API_SERVER_PUBLIC_PORT': '0',
              'SERVERPOD_WEB_SERVER_PORT': '0',
              'SERVERPOD_WEB_SERVER_PUBLIC_PORT': '0',
            },
            const ServerpodAddresses(
              api: 'http://localhost:52001',
              insights: 'http://localhost:52002',
            ),
          ),
          {
            'SERVERPOD_API_SERVER_PORT': '52001',
            'SERVERPOD_API_SERVER_PUBLIC_PORT': '52001',
            'SERVERPOD_WEB_SERVER_PORT': '0',
            'SERVERPOD_WEB_SERVER_PUBLIC_PORT': '0',
          },
        );
      },
    );

    test(
      'when the project configures no insights or web server, '
      'then neither is given a port, which would start one',
      () {
        expect(ephemeralPortEnvironment(const ['api']), {
          'SERVERPOD_API_SERVER_PORT': '0',
          'SERVERPOD_API_SERVER_PUBLIC_PORT': '0',
        });
      },
    );
  });
}

/// A port that was free a moment ago.
Future<int> _freePort() async {
  final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
  final port = socket.port;
  await socket.close();
  return port;
}

/// Starts a registered sibling runner whose socket answers liveness probes.
Future<ServerSocket> _startSiblingRunner(
  RunnerRegistry registry,
  String root,
  String worktree,
  String serverPackage, {
  int? apiPort,
  Map<String, int>? claimedPorts,
  int? protocolVersion,
}) async {
  final dir = await _prepareSibling(root, worktree, serverPackage);
  final socketPath = p.join(serverpodToolDirPath(dir), 'tui.sock');
  final socket = await bindUnixSocket(socketPath);
  socket.listen((client) => client.destroy());

  await _writeManifest(
    dir,
    apiPort: apiPort,
    claimedPorts: claimedPorts,
    protocolVersion: protocolVersion,
  );
  await registry.register(dir);
  return socket;
}

/// Writes the manifest and registry entry of a runner that is not listening.
Future<void> _writeDeadSiblingManifest(
  RunnerRegistry registry,
  String root,
  String worktree,
  String serverPackage,
) async {
  final dir = await _prepareSibling(root, worktree, serverPackage);
  await _writeManifest(dir);
  await registry.register(dir);
}

Future<String> _prepareSibling(
  String root,
  String worktree,
  String serverPackage,
) async {
  final dir = p.join(root, worktree, serverPackage);
  await Directory(dir).create(recursive: true);
  await Directory(serverpodToolDirPath(dir)).create(recursive: true);
  return dir;
}

Future<void> _writeManifest(
  String dir, {
  int? apiPort,
  Map<String, int>? claimedPorts,
  int? protocolVersion,
}) => RunnerManifest(
  pid: 4242,
  protocolVersion: protocolVersion ?? RunnerManifest.currentProtocolVersion,
  projectId: RunnerRegistry.idFor(dir),
  servers: apiPort == null
      ? null
      : ServerpodAddresses(api: 'http://localhost:$apiPort'),
  ports: claimedPorts,
  config: const RunnerConfig(watch: true, flutter: true, serverArgs: []),
).writeTo(dir);
