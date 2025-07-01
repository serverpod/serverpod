// ignore_for_file: dead_code

@Timeout(Duration(minutes: 1))
// Note, this test shall run non-concurrently,
// which means the test tag 'integration' is not used.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  const signalDelay = Duration(seconds: 2);
  const terminationTimeout = Duration(seconds: 10);
  const verbose = true;

  test(
      'Given a serverpod server with db '
      'when run in maintenance mode '
      'then it automatically exits with exit code 0', () async {
    final processOutput = await startProcess(
      'dart',
      [
        'bin/main.dart',
        '--mode=test',
        '--role',
        'maintenance',
      ],
      verbose: verbose,
    );

    await expectLater(
      processOutput.outQueue,
      emitsThrough(contains('SERVERPOD initialized')),
    );

    await expectLater(
      processOutput.outQueue,
      emitsInOrder([
        emitsThrough(contains('All maintenance tasks completed. Exiting.')),
      ]),
    );

    var exitCode = await processOutput.process.exitCode;
    expect(exitCode, 0);
  }, timeout: const Timeout(Duration(seconds: 60)));

  group('Given a running serverpod server', () {
    test(
        'when it is sent SIGINT '
        'then it exits with exit code 130', () async {
      final processOutput = await startProcess(
        'dart',
        ['bin/main.dart', '--mode=test'],
        verbose: verbose,
      );

      await expectLater(
        processOutput.outQueue,
        emitsThrough(contains('SERVERPOD initialized')),
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
        'then it exits with exit code 143', () async {
      final processOutput = await startProcess(
        'dart',
        ['bin/main.dart', '--mode=test'],
        verbose: verbose,
      );

      await expectLater(
        processOutput.outQueue,
        emitsThrough(contains('SERVERPOD initialized')),
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
      expect(exitCode, 143);
    }, onPlatform: {
      'windows': Skip('SIGTERM is not supported on Windows'),
    });

    test(
        'with shutdown test auditor enabled '
        'when it is sent SIGINT '
        'then it exits with exit code 1', () async {
      final processOutput = await startProcess(
        'dart',
        ['bin/main.dart', '--mode=test'],
        environment: {
          '_SERVERPOD_SHUTDOWN_TEST_AUDITOR': '2',
        },
        verbose: verbose,
      );

      await expectLater(
        processOutput.outQueue,
        emitsThrough(contains('SERVERPOD initialized')),
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
        emitsInOrder([
          emitsThrough(contains('serverpod shutdown test auditor enabled')),
          emitsThrough(
              contains('Exception: serverpod shutdown test auditor throwing')),
        ]),
      );

      var exitCode = await processOutput.process.exitCode.timeout(
        terminationTimeout,
      );
      expect(exitCode, 1);
    });

    test(
        'with an ongoing http request '
        'when it is sent SIGINT '
        'then it exits with exit code 130', () async {
      final processOutput = await startProcess(
        'dart',
        ['bin/main.dart', '--mode=test'],
        verbose: verbose,
      );

      await expectLater(
        processOutput.outQueue,
        emitsThrough(contains('SERVERPOD initialized')),
      );

      await Future.delayed(Duration(seconds: 5));
      print('server should be up');

      final httpClient = Client();
      print('sending long-running request...');
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

      print('waiting for response...');
      final response = await responseTask;
      print('response received with code ${response.statusCode}');
      expect(response.statusCode, 200);

      var exitCode = await processOutput.process.exitCode.timeout(
        terminationTimeout,
      );
      expect(exitCode, 130);
    }, skip: 'Dart HTTP server does not support this graceful shutdown');
  });
}

typedef ProcessOutput = ({
  Process process,
  Stream<String> outQueue,
  Stream<String> errQueue,
});

Stream<String> _streamTransformer(
  Stream<List<int>> stream, {
  bool verbose = false,
  String? prefix,
}) {
  final startOfLine = prefix != null ? '$prefix: ' : '';
  return stream
      .transform(const Utf8Decoder())
      .transform(const LineSplitter())
      .map((line) {
    if (verbose) print('$startOfLine$line');
    return line;
  }).asBroadcastStream(
    onCancel: (controller) {
      if (verbose) print('<pausing ${prefix ?? ''} stream>');
      controller.pause();
    },
    onListen: (controller) async {
      if (controller.isPaused) {
        if (verbose) print('<resuming ${prefix ?? ''} stream>');
        controller.resume();
      }
    },
  );
}

Future<ProcessOutput> startProcess(
  String executable,
  List<String> arguments, {
  Map<String, String>? environment,
  bool verbose = false,
}) async {
  final process = await Process.start(
    executable,
    arguments,
    environment: environment,
  );
  final outQueue = _streamTransformer(
    process.stdout,
    prefix: 'stdout',
    verbose: verbose,
  );
  final errQueue = _streamTransformer(
    process.stderr,
    prefix: 'stderr',
    verbose: verbose,
  );

  // ensure output is drained and process is killed when test is done
  addTearDown(() {
    if (verbose) print('<process teardown>');
    outQueue.listen((s) {}, cancelOnError: true);
    errQueue.listen((s) {}, cancelOnError: true);

    process.kill(ProcessSignal.sigkill);
  });

  return (
    process: process,
    outQueue: outQueue,
    errQueue: errQueue,
  );
}
