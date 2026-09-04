import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/commands/attach/log_renderer.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_cli/src/runner/runner_socket_server.dart';
import 'package:serverpod_shared/log.dart';
import 'package:test/test.dart';

import '../../test_util/fake_runner_api.dart';

void main() {
  group('Given a runner and a plain-text attach session,', () {
    late Directory tempDir;
    late RunnerSocketServer server;
    late FakeRunnerApi runner;
    late _RecordingSink sink;
    late StreamController<ProcessSignal> interrupts;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('lrt');
      server = RunnerSocketServer(serverDir: tempDir.path);
      await server.start();
      runner = FakeRunnerApi();
      server.connect(runner);
      sink = _RecordingSink();
      interrupts = StreamController<ProcessSignal>();
    });

    tearDown(() async {
      await interrupts.close();
      await server.close();
      if (!runner.eventController.isClosed) {
        await runner.eventController.close();
      }
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test(
      'when it attaches to a runner that has been up for a while, '
      'then the retained history is printed before anything new',
      () async {
        runner
          ..stage = RunnerStage.running
          ..logHistory = [
            LogEntry(
              time: DateTime.utc(2026, 8, 25),
              level: LogLevel.info,
              message: 'Earlier line.',
              scope: LogScope.root('server'),
            ),
          ]
          ..flutterAppIds = ['admin']
          ..flutterLogs = {
            'admin': ['flutter line'],
          };

        final session = attachWithLogStream(
          server.socketPath,
          out: sink,
          interrupts: interrupts.stream,
        );
        await _waitFor(
          () => sink.lines.any((l) => l.contains('Earlier line.')),
        );

        expect(sink.lines, contains(contains('Earlier line.')));
        expect(sink.lines, contains('[admin] flutter line'));
        expect(sink.lines, contains('--- server running ---'));

        interrupts.add(ProcessSignal.sigint);
        expect(await session, 0);
      },
    );

    test(
      'when the runner emits events, '
      'then each is printed as one line',
      () async {
        final session = attachWithLogStream(
          server.socketPath,
          out: sink,
          interrupts: interrupts.stream,
        );
        await _waitFor(() => sink.lines.isNotEmpty);
        sink.lines.clear();

        runner
          ..emit(
            ServerLogEvent(
              LogEntry(
                time: DateTime.utc(2026, 8, 25),
                level: LogLevel.warning,
                message: 'Careful.',
                scope: LogScope.root('server'),
              ),
            ),
          )
          ..emit(
            const FlutterLineEvent(appId: 'admin', line: 'Reloaded.'),
          );
        await _waitFor(
          () => sink.lines.any((l) => l.contains('[WARNING] Careful.')),
        );

        expect(sink.lines, contains(contains('[WARNING] Careful.')));
        expect(sink.lines, contains('[admin] Reloaded.'));

        interrupts.add(ProcessSignal.sigint);
        await session;
      },
    );

    test(
      'when the pod prints a line its structured log also carries, '
      'then the line is rendered once',
      () async {
        runner
          ..stage = RunnerStage.running
          ..logHistory = [
            LogEntry(
              time: DateTime.utc(2026, 8, 25),
              level: LogLevel.info,
              message: 'Server listening.',
              scope: LogScope.root('server'),
            ),
          ]
          ..serverLines = ['2026-08-25T00:00:00.000Z [INFO] Server listening.'];

        final session = attachWithLogStream(
          server.socketPath,
          out: sink,
          interrupts: interrupts.stream,
        );
        await _waitFor(
          () => sink.lines.any((l) => l.contains('Server listening.')),
        );

        expect(
          sink.lines.where((l) => l.contains('Server listening.')),
          hasLength(1),
        );

        runner
          ..emit(const ServerLineEvent('[INFO] Booted.', duplicatesEntry: true))
          ..emit(
            ServerLogEvent(
              LogEntry(
                time: DateTime.utc(2026, 8, 25),
                level: LogLevel.info,
                message: 'Booted.',
                scope: LogScope.root('server'),
              ),
            ),
          );
        await _waitFor(() => sink.lines.any((l) => l.contains('Booted.')));

        expect(sink.lines.where((l) => l.contains('Booted.')), hasLength(1));

        interrupts.add(ProcessSignal.sigint);
        expect(await session, 0);
      },
    );

    test(
      'when the pod printed a line before its structured log was live, '
      'then the line is rendered, because it is the only copy',
      () async {
        final session = attachWithLogStream(
          server.socketPath,
          out: sink,
          interrupts: interrupts.stream,
        );
        await _waitFor(() => sink.lines.isNotEmpty);
        sink.lines.clear();

        runner.emit(const ServerLineEvent('Connecting to the database...'));
        await _waitFor(
          () => sink.lines.any((l) => l.contains('Connecting to the database')),
        );

        expect(sink.lines, contains('Connecting to the database...'));

        interrupts.add(ProcessSignal.sigint);
        expect(await session, 0);
      },
    );

    test(
      'when it attaches to a stack that failed to build with watch mode off, '
      'then it leaves with one rather than streaming a server that is never coming up',
      () async {
        runner
          ..stage = RunnerStage.degraded
          ..isRunning = false
          ..watchModeEnabled = false;

        final session = attachWithLogStream(
          server.socketPath,
          out: sink,
          interrupts: interrupts.stream,
        );

        expect(await session, 1);
      },
    );

    test(
      'when the stack fails to build in watch mode, '
      'then it keeps streaming, because the file watcher recovers',
      () async {
        final session = attachWithLogStream(
          server.socketPath,
          out: sink,
          interrupts: interrupts.stream,
        );
        await _waitFor(() => sink.lines.isNotEmpty);

        runner.emit(
          const StageChangedEvent(RunnerStage.degraded, isRunning: false),
        );
        await _waitFor(
          () => sink.lines.any((l) => l.contains('failed to build')),
        );

        interrupts.add(ProcessSignal.sigint);
        expect(await session, 0);
      },
    );

    test(
      'when the runner stops with a non-zero exit code, '
      'then the session leaves with it, so CI sees the server failed',
      () async {
        final session = attachWithLogStream(
          server.socketPath,
          out: sink,
          interrupts: interrupts.stream,
        );
        await _waitFor(() => sink.lines.isNotEmpty);

        runner.emit(
          const StageChangedEvent(
            RunnerStage.stopping,
            isRunning: false,
            exitCode: 3,
          ),
        );

        expect(await session, 3);
      },
    );

    test(
      'when the runner stops without naming an exit code, '
      'then the session leaves with zero',
      () async {
        final session = attachWithLogStream(
          server.socketPath,
          out: sink,
          interrupts: interrupts.stream,
        );
        await _waitFor(() => sink.lines.isNotEmpty);

        runner.emit(
          const StageChangedEvent(RunnerStage.stopping, isRunning: false),
        );

        expect(await session, 0);
      },
    );

    test(
      'when the runner is killed without announcing that it is stopping, '
      'then the session gives up and leaves with one',
      () async {
        final session = attachWithLogStream(
          server.socketPath,
          out: sink,
          interrupts: interrupts.stream,
          reconnectDeadline: const Duration(milliseconds: 200),
        );
        await _waitFor(() => sink.lines.isNotEmpty);

        await server.close();

        expect(await session, 1);
        expect(sink.lines, contains('--- the runner is gone ---'));
      },
    );

    test(
      'when interrupted, '
      'then it detaches with exit code zero and leaves the runner running',
      () async {
        var stops = 0;
        runner.onStop = () async => stops++;

        final session = attachWithLogStream(
          server.socketPath,
          out: sink,
          interrupts: interrupts.stream,
        );
        await _waitFor(() => sink.lines.isNotEmpty);

        interrupts.add(ProcessSignal.sigint);

        expect(await session, 0);
        expect(stops, 0);
      },
    );
  });
}

/// An [IOSink] that records the lines written to it.
class _RecordingSink implements IOSink {
  final List<String> lines = [];

  @override
  void writeln([Object? object = '']) => lines.add('$object');

  @override
  void write(Object? object) => lines.add('$object');

  @override
  Encoding encoding = utf8;

  @override
  void add(List<int> data) => lines.add(utf8.decode(data));

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<void> addStream(Stream<List<int>> stream) async {}

  @override
  Future<void> close() async {}

  @override
  Future<void> get done => Future.value();

  @override
  Future<void> flush() async {}

  @override
  void writeAll(Iterable<Object?> objects, [String separator = '']) =>
      lines.add(objects.join(separator));

  @override
  void writeCharCode(int charCode) => lines.add(String.fromCharCode(charCode));
}

/// Polls [condition] until it holds; the renderer's input crosses a socket.
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
