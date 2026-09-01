import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/runner/line_sink.dart';
import 'package:serverpod_cli/src/runner/runner_log_file.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_shared/log.dart' show LogEntry, LogLevel, LogScope;
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  group('Given a runner log file,', () {
    late Directory tempDir;
    late String logPath;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('rlf');
      logPath = '${tempDir.path}/runner.log';
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test(
      'when writing past the size cap, '
      'then the lines written across the rotation are all kept',
      () async {
        final file = RunnerLogFile(path: logPath, maxBytes: 200);
        await file.open();

        for (var i = 0; i < 40; i++) {
          file.writeLine('line $i');
        }
        await file.close();

        final kept = [
          if (File('$logPath.1').existsSync())
            await File('$logPath.1').readAsString(),
          await File(logPath).readAsString(),
        ].join();

        for (var i = 0; i < 40; i++) {
          expect(kept, contains('line $i\n'), reason: 'line $i was dropped');
        }
      },
    );

    test(
      'when the previous generation cannot be replaced, '
      'then the log keeps growing in place rather than dropping lines',
      () async {
        final blocker = Directory('$logPath.1');
        await blocker.create();
        await File('${blocker.path}/keep').writeAsString('');

        final file = RunnerLogFile(path: logPath, maxBytes: 200);
        await file.open();
        for (var i = 0; i < 80; i++) {
          file.writeLine('line $i');
        }
        await file.close();

        final kept = await File(logPath).readAsString();
        for (var i = 0; i < 80; i++) {
          expect(kept, contains('line $i\n'), reason: 'line $i was dropped');
        }
      },
    );

    test(
      'when the file cannot be written, '
      'then neither writing across a rotation nor closing throws or leaks',
      () async {
        // A directory at the path fails every write the way a full disk does:
        // lazily, on the sink, after the open succeeded.
        await Directory(logPath).create();
        final file = RunnerLogFile(path: logPath, maxBytes: 20);
        await file.open();

        for (var i = 0; i < 10; i++) {
          file.writeLine('line $i is long enough to cross the cap');
        }
        await file.close();
      },
    );

    test(
      'when the sink failed but the file is writable again at exit, '
      'then the exit-path line is still appended',
      () async {
        await Directory(logPath).create();
        final file = RunnerLogFile(path: logPath);
        await file.open();
        file.writeLine('lost');
        await pumpEventQueue();
        await Directory(logPath).delete();
        await file.close();

        file.writeLine('the exit-path error');

        expect(
          await File(logPath).readAsString(),
          contains('the exit-path error\n'),
        );
      },
    );

    test(
      'when a line is written after the file is closed, '
      'then it still reaches the file, being what a failing runner leaves',
      () async {
        final file = RunnerLogFile(path: logPath);
        await file.open();
        file.writeLine('before close');
        await file.close();

        file.writeLine('the exit-path error');

        expect(
          await File(logPath).readAsLines(),
          ['before close', 'the exit-path error'],
        );
      },
    );

    test(
      'when a line is written before the file is opened, '
      'then closing flushes it rather than dropping it',
      () async {
        final file = RunnerLogFile(path: logPath);
        file.writeLine('written too early');
        await file.open();
        await file.close();

        expect(
          await File(logPath).readAsString(),
          contains('written too early'),
        );
      },
    );

    test(
      'when a multi-byte character straddles two byte chunks, '
      'then it is decoded whole rather than throwing',
      () async {
        final file = RunnerLogFile(path: logPath);
        await file.open();
        final sink = LineSink(file.writeLine);

        final bytes = utf8.encode('héllo\n');
        sink.add(bytes.sublist(0, 2));
        sink.add(bytes.sublist(2));

        await sink.close();
        await file.close();

        expect(await File(logPath).readAsString(), 'héllo\n');
      },
    );
  });

  group('Given a runner log file the CLI logger writes to,', () {
    late Directory tempDir;
    late String logPath;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('rlw');
      logPath = '${tempDir.path}/runner.log';
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test(
      'when a scope opens and closes, '
      'then every line starts with a timestamp, the file being grepped by it',
      () async {
        final file = RunnerLogFile(path: logPath);
        await file.open();
        final writer = RunnerLogFileWriter(file);
        final scope = LogScope(
          id: 's1',
          label: 'Starting the server',
          startTime: DateTime.utc(2026, 4, 10, 12),
        );

        await writer.openScope(scope);
        await writer.log(
          LogEntry(
            time: DateTime.utc(2026, 4, 10, 12, 0, 1),
            level: LogLevel.info,
            message: 'A line.',
            scope: scope,
          ),
        );
        await writer.closeScope(
          scope,
          success: false,
          duration: const Duration(milliseconds: 12),
          error: 'It did not build.',
        );
        await file.close();

        expect(
          await File(logPath).readAsLines(),
          everyElement(matches(RegExp(r'^\d{4}-\d{2}-\d{2}T'))),
        );
      },
    );
  });

  group('Given a project whose server package is a subdirectory,', () {
    setUp(() async {
      await d.dir('project', [
        d.dir('my_project_server', [
          d.file('pubspec.yaml', '''
name: my_project_server
dependencies:
  serverpod: ^2.0.0
'''),
        ]),
      ]).create();
    });

    test(
      'when the runner opens its log without being told the directory, '
      'then it lands beside the manifest rather than beside the cwd',
      () async {
        final serverRootDir = await GeneratorConfig.resolveServerRootDir(
          '',
          interactive: false,
          startDir: Directory(p.join(d.sandbox, 'project')),
        );

        expect(
          p.canonicalize(serverRootDir),
          p.canonicalize(p.join(d.sandbox, 'project', 'my_project_server')),
        );
        expect(
          p.canonicalize(RunnerLogFile.forServer(serverRootDir).path),
          p.canonicalize(serverpodRunnerLogPath(serverRootDir)),
        );
      },
    );
  });
}
