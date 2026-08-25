import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/runner/runner_log_file.dart';
import 'package:test/test.dart';

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
      'when a multi-byte character straddles two byte chunks, '
      'then it is decoded whole rather than throwing',
      () async {
        final file = RunnerLogFile(path: logPath);
        await file.open();
        final sink = RunnerLogFileSink(file);

        final bytes = utf8.encode('héllo\n');
        sink.add(bytes.sublist(0, 2));
        sink.add(bytes.sublist(2));

        await sink.close();
        await file.close();

        expect(await File(logPath).readAsString(), 'héllo\n');
      },
    );
  });
}
