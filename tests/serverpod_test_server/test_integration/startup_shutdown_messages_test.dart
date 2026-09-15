// ignore_for_file: dead_code

@Timeout(Duration(minutes: 3))
// Note, this test shall run non-concurrently,
// which means the test tag 'integration' is not used.
import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';

import 'test_util/spawned_server_process.dart';

// `--mode=test` (ephemeral ports). Wait for start to finish (HTTP bound and
// the database pool up) before SIGINT: embedded-Postgres FFI does not
// deliver signals. Silenced tests use SERVERPOD_TEST_READY_FILE instead.

const _startupLifecycleMessages = [
  'SERVERPOD version:',
  'SERVERPOD initialized',
];

const _shutdownLifecycleMessages = [
  'SIGINT (2) received',
  'SERVERPOD initiating shutdown',
  'SERVERPOD shutdown completed',
];

const _lifecycleMessages = [
  ..._startupLifecycleMessages,
  ..._shutdownLifecycleMessages,
];

void main() {
  const signalDelay = Duration(seconds: 2);
  const terminationTimeout = Duration(seconds: 10);
  const verbose = false;

  test(
    'Given a running serverpod server with lifecycle messages silenced '
    'when it starts and is sent SIGINT '
    'then it prints no lifecycle messages and exits with exit code 130',
    () async {
      final readyFile = _readyFile();
      final processOutput = await startSpawnedServer(
        ['--mode=test'],
        environment: {
          'SERVERPOD_SILENCE_LIFECYCLE_MESSAGES': '1',
          'SERVERPOD_TEST_READY_FILE': readyFile.path,
        },
        verbose: verbose,
      );

      final stdoutLines = <String>[];
      final stderrLines = <String>[];
      final stdoutSubscription = processOutput.outQueue.listen(
        stdoutLines.add,
      );
      final stderrSubscription = processOutput.errQueue.listen(
        stderrLines.add,
      );
      addTearDown(() async {
        await stdoutSubscription.cancel();
        await stderrSubscription.cancel();
      });

      await _waitForReadyFile(
        process: processOutput.process,
        readyFile: readyFile,
        stdoutLines: stdoutLines,
        stderrLines: stderrLines,
      );
      await Future.delayed(signalDelay);

      expect(stdoutLines.where(_isStartupLifecycleMessage), isEmpty);

      processOutput.process.kill(ProcessSignal.sigint);

      final exitCode = await processOutput.process.exitCode.timeout(
        terminationTimeout,
      );
      expect(exitCode, 130);
      expect(stdoutLines.where(_isLifecycleMessage), isEmpty);
    },
  );

  test(
    'Given a running serverpod server with lifecycle messages enabled '
    'when it starts and is sent SIGINT '
    'then it prints lifecycle messages and exits with exit code 130',
    () async {
      final processOutput = await startSpawnedServer(
        ['--mode=test'],
        environment: {
          'SERVERPOD_SILENCE_LIFECYCLE_MESSAGES': '0',
        },
        verbose: verbose,
      );

      await expectLater(
        processOutput.outQueue,
        emitsThrough(contains('SERVERPOD start complete')),
      );

      await Future.delayed(signalDelay);
      processOutput.process.kill(ProcessSignal.sigint);

      await expectLater(
        processOutput.outQueue,
        emitsInOrder([
          emitsThrough(contains('SIGINT (2) received')),
          emitsThrough(contains('SERVERPOD initiating shutdown')),
          emitsThrough(contains('SERVERPOD shutdown completed')),
        ]),
      );

      final exitCode = await processOutput.process.exitCode.timeout(
        terminationTimeout,
      );
      expect(exitCode, 130);
    },
  );
}

bool _isLifecycleMessage(String line) {
  return _lifecycleMessages.any(line.contains);
}

bool _isStartupLifecycleMessage(String line) {
  return _startupLifecycleMessages.any(line.contains);
}

File _readyFile() {
  final file = File(
    '${Directory.systemTemp.path}/serverpod-lifecycle-ready-'
    '${pid}-${DateTime.now().microsecondsSinceEpoch}',
  );
  addTearDown(() {
    if (file.existsSync()) {
      file.deleteSync();
    }
  });
  return file;
}

Future<void> _waitForReadyFile({
  required Process process,
  required File readyFile,
  required List<String> stdoutLines,
  required List<String> stderrLines,
}) async {
  const timeout = Duration(minutes: 2, seconds: 30);
  final endTime = DateTime.now().add(timeout);
  var exited = false;
  unawaited(
    process.exitCode.then((_) {
      exited = true;
    }),
  );

  while (DateTime.now().isBefore(endTime)) {
    if (exited) {
      fail(
        'Serverpod process exited with ${await process.exitCode} '
        'before it was ready.\n'
        'stdout:\n${stdoutLines.join('\n')}\n'
        'stderr:\n${stderrLines.join('\n')}',
      );
    }
    if (readyFile.existsSync()) {
      return;
    }
    await Future.delayed(const Duration(milliseconds: 50));
  }

  fail(
    'Serverpod server did not start within $timeout.\n'
    'stdout:\n${stdoutLines.join('\n')}\n'
    'stderr:\n${stderrLines.join('\n')}',
  );
}
