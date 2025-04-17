// ignore_for_file: dead_code

@Timeout(Duration(minutes: 1))
@Skip(
    'These tests are disabled because they are flaky, tracked by this issue: https://github.com/serverpod/serverpod/issues/3431')

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';

void main() {
  const signalDelay = Duration(seconds: 2);
  const terminationTimeout = Duration(seconds: 10);
  const verbose = false;

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

    processOutput.outQueue.rest.listen((s) {});
    processOutput.errQueue.rest.listen((s) {});
    var exitCode = await processOutput.process.exitCode;
    expect(exitCode, 0);
  }, tags: [defaultIntegrationTestTag]);

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

      processOutput.outQueue.rest.listen((s) {});
      processOutput.errQueue.rest.listen((s) {});
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

      processOutput.outQueue.rest.listen((s) {});
      processOutput.errQueue.rest.listen((s) {});
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

      processOutput.outQueue.rest.listen((s) {});
      processOutput.errQueue.rest.listen((s) {});
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
      processOutput.outQueue.rest.listen((s) {});
      processOutput.errQueue.rest.listen((s) {});

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

      processOutput.outQueue.rest.listen((s) {});
      processOutput.errQueue.rest.listen((s) {});
      var exitCode = await processOutput.process.exitCode.timeout(
        terminationTimeout,
      );
      expect(exitCode, 130);
    }, skip: 'Dart HTTP server does not support this graceful shutdown');
  }, tags: [defaultIntegrationTestTag]);
}

typedef ProcessOutput = ({
  Process process,
  StreamQueue<String> outQueue,
  StreamQueue<String> errQueue,
});

Stream<String> _streamToLines(
  Stream<List<int>> stream, {
  bool verbose = false,
  String? prefix,
}) {
  var lines = stream
      .transform(Utf8Decoder())
      .expand((str) => str.split('\n').where((l) => l.isNotEmpty));
  if (!verbose) {
    return lines;
  }
  return lines.map((line) {
    print('${prefix != null ? '$prefix: ' : ''}$line');
    return line;
  });
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

  // ensure process is killed when test is done
  addTearDown(() {
    process.kill(ProcessSignal.sigkill);
  });

  return (
    process: process,
    outQueue: StreamQueue<String>(_streamToLines(
      process.stdout,
      verbose: verbose,
      prefix: 'stdout',
    )),
    errQueue: StreamQueue<String>(_streamToLines(
      process.stderr,
      verbose: verbose,
      prefix: 'stderr',
    )),
  );
}
