import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/port_resolution.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_shared/serverpod_shared.dart'
    show FileEx, bindUnixSocket;
import 'package:test/test.dart';

void main() {
  group('Given configured ports and a server package,', () {
    late Directory root;
    late String serverDir;

    setUp(() async {
      root = await Directory.systemTemp.createTemp('prt');
      serverDir = p.join(root.path, 'main', 'my_server');
      await Directory(serverDir).create(recursive: true);
      await Directory(p.join(root.path, 'main', '.git')).create();
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
          ports: {'api': occupied.port},
        );

        expect(resolution.hasConflicts, isTrue);
        expect(resolution.conflicts['api'], occupied.port);
        expect(resolution.useEphemeral, isFalse);
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
            root.path,
            'wt2',
            'my_server',
            apiPort: occupied.port,
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
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
        await _writeDeadSiblingManifest(root.path, 'wt2', 'my_server');

        final resolution = await resolvePorts(
          serverDir: serverDir,
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
            root.path,
            'wt2',
            'my_server',
            apiPort: occupied.port,
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          ports: {
            'api': occupied.port,
            'insights': await _freePort(),
            'web': await _freePort(),
          },
        );

        expect(resolution.useEphemeral, isTrue);
        expect(
          ephemeralPortEnvironment(const ['api', 'insights', 'web']).keys,
          hasLength(3),
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
            root.path,
            'wt2',
            'my_server',
            apiPort: await _freePort(),
          )).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
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
          (await _startSiblingRunner(root.path, 'wt2', 'my_server')).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
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
          (await _startSiblingRunner(root.path, 'wt2', 'my_server')).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
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
            root.path,
            'wt2',
            'my_server',
            apiPort: held.port,
          )).close,
        );
        addTearDown(
          (await _startSiblingRunner(root.path, 'wt3', 'my_server')).close,
        );

        final resolution = await resolvePorts(
          serverDir: serverDir,
          ports: {'api': held.port, 'web': unknown.port},
        );

        expect(resolution.useEphemeral, isTrue);
        expect(resolution.hasConflicts, isFalse);
        expect(resolution.unattributed, {'web': unknown.port});
      },
    );

    test(
      'when a port is zero, '
      'then it is already ephemeral and needs no probe',
      () async {
        final resolution = await resolvePorts(
          serverDir: serverDir,
          ports: {'api': 0},
        );

        expect(resolution.useEphemeral, isFalse);
        expect(resolution.hasConflicts, isFalse);
      },
    );
  });

  group('Given the ephemeral port overrides,', () {
    test(
      'when they are applied, '
      'then every configured listener is asked for port zero',
      () {
        expect(ephemeralPortEnvironment(const ['api', 'insights', 'web']), {
          'SERVERPOD_API_SERVER_PORT': '0',
          'SERVERPOD_INSIGHTS_SERVER_PORT': '0',
          'SERVERPOD_WEB_SERVER_PORT': '0',
        });
      },
    );

    test(
      'when the project configures no insights or web server, '
      'then neither is given a port, which would start one',
      () {
        expect(ephemeralPortEnvironment(const ['api']), {
          'SERVERPOD_API_SERVER_PORT': '0',
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

/// Stands up a runner in a sibling worktree that actually answers.
///
/// A listening socket rather than a stray file: liveness is a real probe, so a
/// manifest alone would not count.
Future<ServerSocket> _startSiblingRunner(
  String root,
  String worktree,
  String serverPackage, {
  int? apiPort,
}) async {
  final dir = await _prepareSibling(root, worktree, serverPackage);
  final socketPath = p.join(serverpodToolDirPath(dir), 'tui.sock');
  final socket = await bindUnixSocket(socketPath);
  socket.listen((client) => client.destroy());

  await _writeManifest(dir, socketPath, apiPort: apiPort);
  return socket;
}

/// Leaves behind the manifest of a runner that is no longer listening.
Future<void> _writeDeadSiblingManifest(
  String root,
  String worktree,
  String serverPackage,
) async {
  final dir = await _prepareSibling(root, worktree, serverPackage);
  await _writeManifest(dir, p.join(serverpodToolDirPath(dir), 'tui.sock'));
}

Future<String> _prepareSibling(
  String root,
  String worktree,
  String serverPackage,
) async {
  final dir = p.join(root, worktree, serverPackage);
  await Directory(dir).create(recursive: true);
  await Directory(p.join(root, worktree, '.git')).create(recursive: true);
  await Directory(serverpodToolDirPath(dir)).create(recursive: true);
  return dir;
}

Future<void> _writeManifest(String dir, String socketPath, {int? apiPort}) =>
    RunnerManifest(
      pid: 4242,
      sockets: RunnerSockets(tui: socketPath, mcp: ''),
      servers: apiPort == null
          ? null
          : RunnerServerUris(api: 'http://localhost:$apiPort'),
      config: const RunnerConfig(watch: true, flutter: true, serverArgs: []),
    ).writeTo(dir);
