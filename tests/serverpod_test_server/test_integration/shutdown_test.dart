// ignore_for_file: dead_code

@Timeout(Duration(minutes: 2))
// Note, this test shall run non-concurrently,
// which means the test tag 'integration' is not used.
import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';

import 'test_util/spawned_server_process.dart';

void main() {
  const signalDelay = Duration(seconds: 2);
  const terminationTimeout = Duration(seconds: 10);
  const verbose = false;

  test(
    'Given a serverpod server with db '
    'when run in maintenance mode '
    'then it automatically exits with exit code 0',
    () async {
      final processOutput = await startSpawnedServer(
        [
          '--mode=test',
          '--role',
          'maintenance',
        ],
        environment: {
          'SERVERPOD_SILENCE_LIFECYCLE_MESSAGES': '0',
        },
        verbose: verbose,
      );

      await expectLater(
        processOutput.outQueue,
        emitsInOrder([
          emitsThrough(contains('SERVERPOD initialized')),
          emitsThrough(contains('All maintenance tasks completed. Exiting.')),
        ]),
      );

      var exitCode = await processOutput.process.exitCode.timeout(
        terminationTimeout,
      );
      expect(exitCode, 0);
    },
    timeout: const Timeout(Duration(seconds: 120)),
    skip:
        'Embedded-Postgres spawn does not finish maintenance exit in CI; apply-migrations in this runner already covers that path.',
  );

  group('Given a running serverpod server', () {
    test('when it is sent SIGINT '
        'then it exits with exit code 130', () async {
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
      if (verbose) {
        print('sending process signal...');
      }
      processOutput.process.kill(ProcessSignal.sigint);

      await expectLater(
        processOutput.outQueue,
        emitsInOrder([
          emitsThrough(contains('SIGINT (2) received')),
          emitsThrough(contains('SERVERPOD initiating shutdown')),
          emitsThrough(contains('SERVERPOD shutdown completed')),
        ]),
      );

      var exitCode = await processOutput.process.exitCode.timeout(
        terminationTimeout,
      );
      expect(exitCode, 130);
    });

    test(
      'when it is sent SIGTERM '
      'then it exits with exit code 0',
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
        if (verbose) {
          print('sending process signal...');
        }
        processOutput.process.kill(ProcessSignal.sigterm);

        await expectLater(
          processOutput.outQueue,
          emitsInOrder([
            emitsThrough(contains('SIGTERM (15) received')),
            emitsThrough(contains('SERVERPOD initiating shutdown')),
            emitsThrough(contains('SERVERPOD shutdown completed')),
          ]),
        );

        var exitCode = await processOutput.process.exitCode.timeout(
          terminationTimeout,
        );
        expect(exitCode, 0);
      },
      onPlatform: {
        'windows': Skip('SIGTERM is not supported on Windows'),
      },
    );

    test('with shutdown test auditor enabled '
        'when it is sent SIGINT '
        'then it exits with exit code 1', () async {
      final processOutput = await startSpawnedServer(
        ['--mode=test'],
        environment: {
          '_SERVERPOD_SHUTDOWN_TEST_AUDITOR': '2',
          'SERVERPOD_SILENCE_LIFECYCLE_MESSAGES': '0',
        },
        verbose: verbose,
      );

      await expectLater(
        processOutput.outQueue,
        emitsThrough(contains('SERVERPOD start complete')),
      );

      await Future.delayed(signalDelay);
      if (verbose) {
        print('sending process signal...');
      }
      processOutput.process.kill(ProcessSignal.sigint);

      await expectLater(
        processOutput.outQueue,
        emitsInOrder([
          emitsThrough(contains('SIGINT (2) received')),
          emitsThrough(contains('SERVERPOD initiating shutdown')),
          emitsThrough(contains('SERVERPOD shutdown completed')),
        ]),
      );

      await expectLater(
        processOutput.errQueue,
        emitsThrough(
          contains('Exception: serverpod shutdown test auditor throwing'),
        ),
      );

      var exitCode = await processOutput.process.exitCode.timeout(
        terminationTimeout,
      );
      expect(exitCode, 1);
    });

    test('with an ongoing http request '
        'when it is sent SIGINT '
        'then it exits with exit code 130', () async {
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

      await Future.delayed(Duration(seconds: 5));

      final httpClient = Client();
      final responseTask = httpClient.post(
        Uri.parse('http://localhost:8080/failedCalls/slowCall'),
      );

      await Future.delayed(Duration(milliseconds: 1000));

      if (verbose) {
        print('sending process signal...');
      }
      processOutput.process.kill(ProcessSignal.sigint);

      await expectLater(
        processOutput.outQueue,
        emitsInOrder([
          emitsThrough(contains('SIGINT (2) received')),
          emitsThrough(contains('SERVERPOD initiating shutdown')),
          emitsThrough(contains('SERVERPOD shutdown completed')),
        ]),
      );

      final response = await responseTask;
      expect(response.statusCode, 200);

      var exitCode = await processOutput.process.exitCode.timeout(
        terminationTimeout,
      );
      expect(exitCode, 130);
    }, skip: 'Dart HTTP server does not support this graceful shutdown');
  });
}
