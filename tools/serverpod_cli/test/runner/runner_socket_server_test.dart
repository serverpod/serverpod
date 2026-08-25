import 'dart:async';
import 'dart:io';

import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:serverpod_cli/src/runner/migration_result.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_cli/src/runner/runner_socket_server.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart' show TrackedOperation;
import 'package:test/test.dart';

import '../test_util/fake_runner_api.dart';

/// A client attached to [socketPath], with the events it has received.
class _AttachedClient {
  _AttachedClient(this.peer, this.events, this._socket);

  final json_rpc.Peer peer;
  final List<RunnerEvent> events;
  final Socket _socket;

  Future<void> close() async {
    await peer.close();
    _socket.destroy();
  }
}

Future<_AttachedClient> _attach(String socketPath) async {
  final socket = await Socket.connect(
    InternetAddress(socketPath, type: InternetAddressType.unix),
    0,
  );
  final peer = json_rpc.Peer(socketChannel(socket));
  final events = <RunnerEvent>[];
  peer.registerMethod(runnerEventNotification, (json_rpc.Parameters params) {
    final event = RunnerEvent.fromJson(
      Map<String, Object?>.from(params.value as Map),
    );
    if (event != null) events.add(event);
  });
  unawaited(peer.listen());
  return _AttachedClient(peer, events, socket);
}

void main() {
  group('Given a runner attach socket,', () {
    late Directory tempDir;
    late RunnerSocketServer server;
    late FakeRunnerApi runner;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('rss');
      server = RunnerSocketServer(serverDir: tempDir.path);
      await server.start();
      runner = FakeRunnerApi();
      server.connect(runner);
    });

    tearDown(() async {
      await server.close();
      await runner.eventController.close();
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test(
      'when a client asks for the snapshot, '
      'then it receives the runner state it needs to render immediately',
      () async {
        runner
          ..stage = RunnerStage.degraded
          ..isRunning = false
          ..flutterAppIds = ['admin']
          ..runningFlutterApps = {'admin'}
          ..logHistory = [
            LogEntry(
              time: DateTime.utc(2026, 8, 25),
              level: LogLevel.warning,
              message: 'Compilation failed.',
              scope: LogScope.root('server'),
            ),
          ]
          ..flutterLogs = {
            'admin': ['line one'],
          };

        final client = await _attach(server.socketPath);
        addTearDown(client.close);

        final snapshot = RunnerSnapshot.fromJson(
          Map<String, Object?>.from(
            await client.peer.sendRequest(runnerSnapshotMethod, const {})
                as Map,
          ),
        );

        expect(snapshot.stage, RunnerStage.degraded);
        expect(snapshot.isRunning, isFalse);
        expect(snapshot.flutterApps.single.id, 'admin');
        expect(snapshot.runningFlutterApps, {'admin'});
        expect(snapshot.flutterLines['admin'], ['line one']);
        final entry = snapshot.serverEntries.single as LogEntry;
        expect(entry.message, 'Compilation failed.');
        expect(entry.level, LogLevel.warning);
      },
    );

    test(
      'when a client attaches mid-operation, '
      'then the snapshot carries the operation and when it began',
      () async {
        final startedAt = DateTime.utc(2026, 8, 25, 12);
        runner.activeOperations = [
          (
            operation: TrackedOperation(id: 'op-1', label: 'Hot reload'),
            startedAt: startedAt,
          ),
        ];

        final client = await _attach(server.socketPath);
        addTearDown(client.close);

        final snapshot = RunnerSnapshot.fromJson(
          Map<String, Object?>.from(
            await client.peer.sendRequest(runnerSnapshotMethod, const {})
                as Map,
          ),
        );

        expect(snapshot.activeOperations.single.operation.label, 'Hot reload');
        expect(snapshot.activeOperations.single.startedAt, startedAt);
      },
    );

    test(
      'when a client has not asked for the snapshot, '
      'then nothing is forwarded to it until it does',
      () async {
        final client = await _attach(server.socketPath);
        addTearDown(client.close);

        runner.emit(const ServerLineEvent('before the snapshot'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(client.events, isEmpty);

        await client.peer.sendRequest(runnerSnapshotMethod, const {});
        runner.emit(const ServerLineEvent('after the snapshot'));
        await _waitFor(() => client.events.isNotEmpty);

        final line = client.events.single as ServerLineEvent;
        expect(line.line, 'after the snapshot');
      },
    );

    test(
      'when the runner emits events, '
      'then an attached client receives them after its snapshot',
      () async {
        final client = await _attach(server.socketPath);
        addTearDown(client.close);
        await client.peer.sendRequest(runnerSnapshotMethod, const {});

        runner
          ..emit(const StageChangedEvent(RunnerStage.running, isRunning: true))
          ..emit(
            const FlutterLineEvent(appId: 'admin', line: 'Reloaded in 12ms'),
          );
        await _waitFor(() => client.events.length >= 2);

        expect(client.events, hasLength(2));
        final stage = client.events.first as StageChangedEvent;
        expect(stage.stage, RunnerStage.running);
        expect(stage.isRunning, isTrue);
        final line = client.events.last as FlutterLineEvent;
        expect(line.appId, 'admin');
        expect(line.line, 'Reloaded in 12ms');
      },
    );

    test(
      'when two clients are attached, '
      'then both receive every event',
      () async {
        final first = await _attach(server.socketPath);
        final second = await _attach(server.socketPath);
        addTearDown(first.close);
        addTearDown(second.close);
        await first.peer.sendRequest(runnerSnapshotMethod);
        await second.peer.sendRequest(runnerSnapshotMethod);

        runner.emit(
          const StageChangedEvent(RunnerStage.stopping, isRunning: false),
        );
        await _waitFor(
          () => first.events.isNotEmpty && second.events.isNotEmpty,
        );

        expect(first.events, hasLength(1));
        expect(second.events, hasLength(1));
      },
    );

    test(
      'when one client disconnects, '
      'then the other keeps receiving events',
      () async {
        final first = await _attach(server.socketPath);
        final second = await _attach(server.socketPath);
        addTearDown(second.close);
        await first.peer.sendRequest(runnerSnapshotMethod);
        await second.peer.sendRequest(runnerSnapshotMethod);

        await first.close();

        runner.emit(
          const StageChangedEvent(RunnerStage.running, isRunning: true),
        );
        await _waitFor(() => second.events.isNotEmpty);

        expect(second.events, hasLength(1));
      },
    );

    test(
      'when a client issues a command, '
      'then it reaches the runner',
      () async {
        var reloads = 0;
        runner.onHotReload = () async => reloads++;

        final client = await _attach(server.socketPath);
        addTearDown(client.close);

        await client.peer.sendRequest('hotReload', const {});

        expect(reloads, 1);
      },
    );

    test(
      'when a client creates a migration that stopped for warnings, '
      'then the result says so rather than prompting',
      () async {
        runner.onCreateMigration = ({String? tag, bool force = false}) async =>
            const MigrationResult(
              message: 'Server migration aborted due to warnings.',
              isError: true,
              abortedForWarnings: true,
            );

        final client = await _attach(server.socketPath);
        addTearDown(client.close);

        final result = Map<String, Object?>.from(
          await client.peer.sendRequest('createMigration', const {}) as Map,
        );

        expect(result['isError'], isTrue);
        expect(result['abortedForWarnings'], isTrue);
        expect(result['created'], isFalse);
      },
    );

    test(
      'when a client passes command parameters, '
      'then the runner receives them',
      () async {
        String? seenTag;
        bool? seenForce;
        runner.onCreateMigration = ({String? tag, bool force = false}) async {
          seenTag = tag;
          seenForce = force;
          return const MigrationResult(message: 'ok');
        };

        final client = await _attach(server.socketPath);
        addTearDown(client.close);

        await client.peer.sendRequest('createMigration', {
          'tag': 'v2',
          'force': true,
        });

        expect(seenTag, 'v2');
        expect(seenForce, isTrue);
      },
    );

    test(
      'when a client launches a Flutter app by id, '
      'then the runner reports whether it was already running',
      () async {
        runner.onLaunchFlutterApp = (appId) async => appId == 'admin';

        final client = await _attach(server.socketPath);
        addTearDown(client.close);

        final result = Map<String, Object?>.from(
          await client.peer.sendRequest('launchFlutterApp', {'appId': 'admin'})
              as Map,
        );

        expect(result['alreadyRunning'], isTrue);
      },
    );
  });
}

/// Polls [condition] until it holds.
///
/// Events cross a real socket, so a test can't assume how many event-loop
/// turns they take. `pumpEventQueue` is not a barrier for pending I/O.
Future<void> _waitFor(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Condition was not met within $timeout.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}
