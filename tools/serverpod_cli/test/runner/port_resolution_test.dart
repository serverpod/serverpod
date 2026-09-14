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

  Future<ServerSocket> holdPort([InternetAddress? address]) async {
    final socket = await ServerSocket.bind(
      address ?? InternetAddress.loopbackIPv4,
      0,
    );
    addTearDown(socket.close);
    return socket;
  }

  Future<void> startSibling({
    String worktree = 'wt2',
    int? apiPort,
    Map<String, int>? claimedPorts,
    int? protocolVersion,
  }) async {
    final socket = await _startSiblingRunner(
      registry,
      root.path,
      worktree,
      'my_server',
      apiPort: apiPort,
      claimedPorts: claimedPorts,
      protocolVersion: protocolVersion,
    );
    addTearDown(socket.close);
  }

  group('Given free ports,', () {
    test(
      'when the project resolves its ports, '
      'then the configured ports are kept and claimed',
      () async {
        final ports = {'api': await _freePort(), 'web': await _freePort()};

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: ports,
        );

        expect(resolution.useEphemeral, isFalse);
        expect(resolution.hasConflicts, isFalse);
        expect(resolution.overrides, isEmpty);
        expect(claimedPorts(ports, resolution.overrides), ports);
      },
    );

    test(
      'when the project resolves its ports, suggesting the ports the last runner here bound, '
      'then only a listener configured with port zero gets its last port back',
      () async {
        final api = await _freePort();
        final previousApi = await _freePort();
        final previousWeb = await _freePort();

        final resolution = await resolvePorts(
          serverDir: serverDir,
          registry: registry,
          ports: {'api': api, 'web': 0},
          suggested: {'api': previousApi, 'web': previousWeb},
        );

        expect(resolution.useEphemeral, isFalse);
        expect(resolution.overrides, {'web': previousWeb});
        expect(
          claimedPorts({'api': api, 'web': 0}, resolution.overrides),
          {'api': api, 'web': previousWeb},
        );
      },
    );
  });

  group(
    'Given free ports and a live sibling runner that has not decided its ports,',
    () {
      setUp(() async {
        await startSibling();
      });

      test(
        'when the project resolves its ports, '
        'then the stack moves aside before the two race for the same ports',
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': await _freePort()},
          );

          expect(resolution.useEphemeral, isTrue);
          expect(resolution.hasConflicts, isFalse);
        },
      );
    },
  );

  group(
    'Given free ports and a starting sibling runner that has claimed one of them,',
    () {
      late int port;

      setUp(() async {
        port = await _freePort();
        await startSibling(claimedPorts: {'api': port});
      });

      test(
        'when the project resolves its ports, '
        'then the stack moves aside before the two race for it',
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': port, 'web': await _freePort()},
          );

          expect(resolution.useEphemeral, isTrue);
          expect(resolution.hasConflicts, isFalse);
        },
      );
    },
  );

  group(
    'Given free ports and a starting sibling runner claiming other ports,',
    () {
      setUp(() async {
        await startSibling(claimedPorts: {'api': await _freePort()});
      });

      test(
        'when the project resolves its ports, '
        'then the configured ports are kept',
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': await _freePort()},
          );

          expect(resolution.useEphemeral, isFalse);
          expect(resolution.hasConflicts, isFalse);
        },
      );
    },
  );

  group(
    'Given free ports and a sibling runner that has moved aside, claiming none,',
    () {
      setUp(() async {
        await startSibling(claimedPorts: const {});
      });

      test(
        'when the project resolves its ports, '
        'then the configured ports are kept',
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': await _freePort()},
          );

          expect(resolution.useEphemeral, isFalse);
          expect(resolution.hasConflicts, isFalse);
        },
      );
    },
  );

  group(
    'Given free ports and a live sibling runner that published other ports,',
    () {
      setUp(() async {
        await startSibling(apiPort: await _freePort());
      });

      test(
        'when the project resolves its ports, '
        'then the configured ports are kept',
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': await _freePort()},
          );

          expect(resolution.useEphemeral, isFalse);
          expect(resolution.hasConflicts, isFalse);
        },
      );
    },
  );

  group('Given a held port,', () {
    late ServerSocket occupied;

    setUp(() async {
      occupied = await holdPort();
    });

    test(
      'when the project resolves its ports, '
      'then it is a conflict rather than a reason to move aside',
      () async {
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
  });

  group(
    'Given a held port and a live sibling runner publishing it,',
    () {
      late ServerSocket occupied;

      setUp(() async {
        occupied = await holdPort();
        await startSibling(apiPort: occupied.port);
      });

      test(
        'when the project resolves its ports, '
        'then the stack falls back to ephemeral ports',
        () async {
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
        'when the project resolves it alongside insights and web ports, '
        'then all three fall back together rather than splitting the stack',
        () async {
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
          expect(resolution.overrides, {'api': 0, 'insights': 0, 'web': 0});
        },
      );

      test(
        'when the project resolves its ports, suggesting a configured port as the one the last runner here bound, '
        'then that listener binds a new ephemeral port, keeping the block moved',
        () async {
          final web = await _freePort();

          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': occupied.port, 'web': web},
            suggested: {'web': web},
          );

          expect(resolution.useEphemeral, isTrue);
          expect(resolution.overrides, {'api': 0, 'web': 0});
        },
      );
    },
  );

  group(
    'Given a held port, a live sibling runner publishing it and a free port the last runner here bound,',
    () {
      late ServerSocket occupied;
      late int previous;

      setUp(() async {
        occupied = await holdPort();
        await startSibling(apiPort: occupied.port);
        previous = await _freePort();
      });

      test(
        'when the project resolves its ports, suggesting that port, '
        'then that listener gets the port back and claims it',
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': occupied.port},
            suggested: {'api': previous},
          );

          expect(resolution.useEphemeral, isTrue);
          expect(resolution.overrides, {'api': previous});
          expect(
            claimedPorts({'api': occupied.port}, resolution.overrides),
            {'api': previous},
          );
        },
      );
    },
  );

  group(
    'Given a held port and a live sibling runner of another protocol publishing it,',
    () {
      late ServerSocket occupied;

      setUp(() async {
        occupied = await holdPort();
        await startSibling(
          apiPort: occupied.port,
          protocolVersion: RunnerManifest.currentProtocolVersion + 1,
        );
      });

      test(
        'when the project resolves its ports, '
        'then the stack moves aside as it would for one speaking this version',
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': occupied.port},
          );

          expect(resolution.useEphemeral, isTrue);
          expect(resolution.hasConflicts, isFalse);
        },
      );
    },
  );

  group(
    'Given a held port and a sibling worktree that left a manifest but no live runner,',
    () {
      late ServerSocket occupied;

      setUp(() async {
        occupied = await holdPort();
        await _writeDeadSiblingManifest(
          registry,
          root.path,
          'wt2',
          'my_server',
        );
      });

      test(
        'when the project resolves its ports, '
        'then the held port is a conflict, not a reason to move aside',
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': occupied.port},
          );

          expect(resolution.hasConflicts, isTrue);
          expect(resolution.useEphemeral, isFalse);
        },
      );
    },
  );

  group(
    'Given a held port and a live sibling runner holding entirely different ports,',
    () {
      late ServerSocket occupied;

      setUp(() async {
        occupied = await holdPort();
        await startSibling(apiPort: await _freePort());
      });

      test(
        'when the project resolves its ports, '
        'then the occupied port is a conflict rather than a reason to move',
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': occupied.port},
          );

          expect(resolution.useEphemeral, isFalse);
          expect(resolution.conflicts, {'api': occupied.port});
        },
      );
    },
  );

  group(
    'Given a held port and an only sibling runner that has claimed other ports,',
    () {
      late ServerSocket occupied;

      setUp(() async {
        occupied = await holdPort();
        await startSibling(claimedPorts: {'api': await _freePort()});
      });

      test(
        'when the project resolves its ports, '
        'then the port is a conflict rather than a reason to move aside',
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': occupied.port},
          );

          expect(resolution.useEphemeral, isFalse);
          expect(resolution.conflicts, {'api': occupied.port});
        },
      );
    },
  );

  group(
    'Given a held port and a live sibling runner that has published no addresses at all,',
    () {
      late ServerSocket occupied;

      setUp(() async {
        occupied = await holdPort();
        await startSibling();
      });

      test(
        'when the project resolves its ports, '
        'then the stack moves aside rather than blaming the port it cannot name',
        () async {
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
        'when the project resolves its ports, '
        'then the port it could not account for is still named',
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': occupied.port},
          );

          expect(resolution.unattributed, {'api': occupied.port});
        },
      );
    },
  );

  group(
    'Given a held port and a sibling runner that holds its lock but is silent,',
    () {
      late ServerSocket occupied;

      setUp(() async {
        occupied = await holdPort();
        final sibling = await _prepareSibling(root.path, 'wt2', 'my_server');
        await _writeManifest(sibling);
        await registry.register(sibling);
        await holdLockFromAnotherProcess(sibling);
      });

      test(
        'when the project resolves its ports, '
        'then the stack moves aside rather than blaming the port',
        () async {
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
    },
  );

  group(
    'Given a port held on the IPv6 loopback only,',
    () {
      late ServerSocket occupied;

      setUp(() async {
        occupied = await holdPort(InternetAddress.loopbackIPv6);
      });

      test(
        'when the project resolves its ports, '
        'then it is still a conflict, '
        "the pod's socket need not answer on IPv4.",
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': occupied.port},
          );

          expect(resolution.conflicts['api'], occupied.port);
        },
      );
    },
  );

  group(
    'Given a port held the way the pod holds one, bound on anyIPv6,',
    () {
      late ServerSocket occupied;

      setUp(() async {
        occupied = await holdPort(InternetAddress.anyIPv6);
      });

      test(
        'when the project resolves its ports, '
        'then it is a conflict',
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': occupied.port},
          );

          expect(resolution.conflicts['api'], occupied.port);
        },
      );
    },
  );

  group(
    'Given two held ports, one published by a live sibling runner while another sibling runner is silent,',
    () {
      late ServerSocket held;
      late ServerSocket unknown;

      setUp(() async {
        held = await holdPort();
        unknown = await holdPort();
        await startSibling(apiPort: held.port);
        await startSibling(worktree: 'wt3');
      });

      test(
        'when the project resolves its ports, '
        'then only the port neither accounts for is named',
        () async {
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
    },
  );

  group(
    'Given the port the last runner here bound held by another process,',
    () {
      late ServerSocket previous;

      setUp(() async {
        previous = await holdPort();
      });

      test(
        'when the project resolves a port configured as zero, suggesting that port, '
        'then the listener binds a new ephemeral port instead',
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': 0},
            suggested: {'api': previous.port},
          );

          expect(resolution.overrides, {'api': 0});
        },
      );
    },
  );

  group(
    'Given a sibling runner that has claimed the port the last runner here bound,',
    () {
      late int previous;

      setUp(() async {
        previous = await _freePort();
        await startSibling(claimedPorts: {'api': previous});
      });

      test(
        'when the project resolves a port configured as zero, suggesting that port, '
        'then the listener does not take it back',
        () async {
          final resolution = await resolvePorts(
            serverDir: serverDir,
            registry: registry,
            ports: {'api': 0},
            suggested: {'api': previous},
          );

          expect(resolution.overrides, {'api': 0});
        },
      );
    },
  );

  test(
    'Given a port configured as zero, '
    'when the project resolves its ports, '
    'then it is already ephemeral and needs no probe',
    () async {
      final resolution = await resolvePorts(
        serverDir: serverDir,
        registry: registry,
        ports: {'api': 0},
      );

      expect(resolution.useEphemeral, isFalse);
      expect(resolution.hasConflicts, isFalse);
      expect(resolution.overrides, {'api': 0});
      expect(claimedPorts({'api': 0}, resolution.overrides), isEmpty);
    },
  );

  group('Given the port overrides,', () {
    test(
      'when they are applied, '
      'then every configured listener is asked for zero, public port included',
      () {
        expect(
          portOverrideEnvironment(const {'api': 0, 'insights': 0, 'web': 0}),
          {
            'SERVERPOD_API_SERVER_PORT': '0',
            'SERVERPOD_API_SERVER_PUBLIC_PORT': '0',
            'SERVERPOD_INSIGHTS_SERVER_PORT': '0',
            'SERVERPOD_INSIGHTS_SERVER_PUBLIC_PORT': '0',
            'SERVERPOD_WEB_SERVER_PORT': '0',
            'SERVERPOD_WEB_SERVER_PUBLIC_PORT': '0',
          },
        );
      },
    );

    test(
      'when a listener reuses a port, '
      'then it and its public port are asked for that port, the rest for zero',
      () {
        expect(
          portOverrideEnvironment(const {'api': 0, 'web': 54321}),
          {
            'SERVERPOD_API_SERVER_PORT': '0',
            'SERVERPOD_API_SERVER_PUBLIC_PORT': '0',
            'SERVERPOD_WEB_SERVER_PORT': '54321',
            'SERVERPOD_WEB_SERVER_PUBLIC_PORT': '54321',
          },
        );
      },
    );

    test(
      'when the pod reports the ports it bound, '
      'then the overrides pin them, so a restarted pod keeps its address',
      () {
        expect(
          pinResolvedPorts(
            const {'api': 0, 'web': 0, 'insights': 52003},
            const ServerpodAddresses(
              api: 'http://localhost:52001',
              insights: 'http://localhost:52002',
            ),
          ),
          {'api': 52001, 'web': 0, 'insights': 52003},
        );
      },
    );

    test(
      'when the project configures no insights or web server, '
      'then neither is given a port, which would start one',
      () {
        expect(portOverrideEnvironment(const {'api': 0}), {
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
