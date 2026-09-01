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
import '../../test_util/short_temp_dir.dart';
import '../../test_util/wait_for.dart';

void main() {
  group('Given a runner and a plain-text attach session,', () {
    late Directory tempDir;
    late RunnerSocketServer server;
    late FakeRunnerApi runner;
    late _RecordingSink sink;
    late StreamController<ProcessSignal> interrupts;

    setUp(() async {
      tempDir = await createShortTempDir('lrt');
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
        await waitFor(
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
        await waitFor(() => sink.lines.isNotEmpty);
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
        await waitFor(
          () => sink.lines.any((l) => l.contains('[WARNING] Careful.')),
        );

        expect(sink.lines, contains(contains('[WARNING] Careful.')));
        expect(sink.lines, contains('[admin] Reloaded.'));

        interrupts.add(ProcessSignal.sigint);
        await session;
      },
    );

    test(
      'when an app line arrives both as a printed line and as an entry, '
      'then it is rendered once, and one the app did not print still renders',
      () async {
        final session = attachWithLogStream(
          server.socketPath,
          out: sink,
          interrupts: interrupts.stream,
        );
        await waitFor(() => sink.lines.isNotEmpty);
        sink.lines.clear();

        LogEntry entry(String message) => LogEntry(
          time: DateTime.utc(2026, 8, 25),
          level: LogLevel.info,
          message: message,
          scope: LogScope.root('admin'),
        );
        runner
          ..emit(
            FlutterLogEntryEvent(appId: 'admin', entry: entry('Printed.')),
          )
          ..emit(const FlutterLineEvent(appId: 'admin', line: 'Printed.'))
          ..emit(
            FlutterLogEntryEvent(
              appId: 'admin',
              entry: entry('Logged.'),
              appendedToLines: true,
            ),
          );
        await waitFor(() => sink.lines.any((l) => l.contains('Logged.')));

        expect(sink.lines.where((l) => l.contains('Printed.')), [
          '[admin] Printed.',
        ]);
        expect(sink.lines, contains(contains('[INFO] Logged.')));

        interrupts.add(ProcessSignal.sigint);
        await session;
      },
    );

    test(
      'when an app announces that it is launching and, '
      'then that it is running, '
      'then the launch is rendered as launching, not as a stop',
      () async {
        final session = attachWithLogStream(
          server.socketPath,
          out: sink,
          interrupts: interrupts.stream,
        );
        await waitFor(() => sink.lines.isNotEmpty);
        sink.lines.clear();

        runner
          ..emit(
            const FlutterAppStateEvent(
              appId: 'admin',
              running: false,
              launching: true,
              launchStage: 'compiling',
            ),
          )
          ..emit(
            const FlutterAppStateEvent(
              appId: 'admin',
              running: true,
              launching: false,
              url: 'http://localhost:5555',
            ),
          );
        await waitFor(() => sink.lines.length >= 2);

        expect(sink.lines, [
          '[admin] launching (compiling)',
          '[admin] running at http://localhost:5555',
        ]);

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
        await waitFor(
          () => sink.lines.any((l) => l.contains('Server listening.')),
        );

        expect(
          sink.lines.where((l) => l.contains('Server listening.')),
          hasLength(1),
        );

        runner
          ..emit(const ServerLineEvent('[INFO] Booted.'))
          ..emit(
            ServerLogEvent(
              LogEntry(
                time: DateTime.utc(2026, 8, 25),
                level: LogLevel.info,
                message: 'Booted.',
                scope: LogScope.root('server'),
              ),
              duplicatesLine: true,
            ),
          );
        await waitFor(() => sink.lines.any((l) => l.contains('Booted.')));

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
        await waitFor(() => sink.lines.isNotEmpty);
        sink.lines.clear();

        runner.emit(const ServerLineEvent('Connecting to the database...'));
        await waitFor(
          () => sink.lines.any((l) => l.contains('Connecting to the database')),
        );

        expect(sink.lines, contains('Connecting to the database...'));

        runner.emit(
          ServerLogEvent(
            LogEntry(
              time: DateTime.utc(2026, 8, 25),
              level: LogLevel.info,
              message: 'Connecting to the database...',
              scope: LogScope.root('server'),
            ),
            duplicatesLine: true,
          ),
        );
        runner.emit(const ServerLineEvent('Connected.'));
        await waitFor(() => sink.lines.any((l) => l.contains('Connected.')));

        expect(
          sink.lines.where((l) => l.contains('Connecting to the database')),
          hasLength(1),
        );

        interrupts.add(ProcessSignal.sigint);
        expect(await session, 0);
      },
    );

    test(
      'when it attaches to a stack that failed to build with watch mode off, '
      'then it leaves with one rather than streaming a server never coming up',
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
      'when it attaches to a runner that is already stopping, '
      'then it leaves with the code the runner named',
      () async {
        runner
          ..stage = RunnerStage.stopping
          ..isRunning = false
          ..exitCode = 3;

        final session = attachWithLogStream(
          server.socketPath,
          out: sink,
          interrupts: interrupts.stream,
        );

        expect(await session, 3);
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
        await waitFor(() => sink.lines.isNotEmpty);

        runner.emit(
          const StageChangedEvent(RunnerStage.degraded),
        );
        await waitFor(
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
        await waitFor(() => sink.lines.isNotEmpty);

        runner.emit(
          const StageChangedEvent(
            RunnerStage.stopping,
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
        await waitFor(() => sink.lines.isNotEmpty);

        runner.emit(
          const StageChangedEvent(RunnerStage.stopping),
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
        await waitFor(() => sink.lines.isNotEmpty);

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
        await waitFor(() => sink.lines.isNotEmpty);

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
