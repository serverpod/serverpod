// ignore_for_file: dead_code

@Timeout(Duration(minutes: 3))
// Note, this test shall run non-concurrently,
// which means the test tag 'integration' is not used.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_shared/process_io.dart';
import 'package:test/test.dart';

// This suite runs the server in-process on the host (no Docker), so it is
// reachable at localhost - unlike the Dockerised e2e suites' config.dart URLs.
const _serverUrl = 'http://localhost:8080/';

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
  // The first `dart bin/main.dart` spawn compiles the kernel and builds its
  // native assets (sqlite3) cold - and `dart test` is concurrently rebuilding
  // those for its own isolates - so under sharded, CPU-saturated CI that first
  // boot can exceed 30s (later spawns reuse the build and start fast). This
  // suite assumes non-concurrent execution; give the cold start headroom so it
  // doesn't flake. Still well under the 3-minute @Timeout.
  const startupTimeout = Duration(seconds: 90);
  const verbose = false;

  group(
    'Given a running serverpod server with lifecycle messages silenced',
    () {
      late Process process;
      late List<String> stdoutLines;
      late List<String> stderrLines;

      setUp(() async {
        final processOutput = await startProcess(
          'dart',
          ['bin/main.dart', '--mode=production'],
          environment: {
            'SERVERPOD_SILENCE_LIFECYCLE_MESSAGES': '1',
          },
          verbose: verbose,
        );

        process = processOutput.process;

        stdoutLines = <String>[];
        stderrLines = <String>[];
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
      });

      test('when starting the server '
          'then it does not print startup lifecycle messages', () async {
        await _waitForServerToStart(timeout: startupTimeout);
        await Future.delayed(signalDelay);

        expect(stdoutLines.where(_isStartupLifecycleMessage), isEmpty);

        process.kill(ProcessSignal.sigint);

        var exitCode = await process.exitCode.timeout(terminationTimeout);
        expect(exitCode, 130);
      });

      test('when shutting down the server '
          'then it does not print lifecycle messages', () async {
        await _waitForServerToStart(timeout: startupTimeout);
        await Future.delayed(signalDelay);
        process.kill(ProcessSignal.sigint);

        var exitCode = await process.exitCode.timeout(terminationTimeout);
        expect(exitCode, 130);

        expect(stdoutLines.where(_isLifecycleMessage), isEmpty);
      });
    },
  );

  group(
    'Given a running serverpod server with lifecycle messages enabled',
    () {
      late Process process;
      late List<String> stdoutLines;
      late List<String> stderrLines;

      setUp(() async {
        final processOutput = await startProcess(
          'dart',
          ['bin/main.dart', '--mode=production'],
          environment: {
            'SERVERPOD_SILENCE_LIFECYCLE_MESSAGES': '0',
          },
          verbose: verbose,
        );

        process = processOutput.process;
        stdoutLines = <String>[];
        stderrLines = <String>[];
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
      });

      test('when starting the server '
          'then it prints lifecycle messages', () async {
        await _waitForServerToStart(timeout: startupTimeout);
        await Future.delayed(signalDelay);

        expect(stdoutLines.where(_isLifecycleMessage), isNotEmpty);

        process.kill(ProcessSignal.sigint);

        var exitCode = await process.exitCode.timeout(terminationTimeout);
        expect(exitCode, 130);
      });

      test('when shutting down the server '
          'then it prints lifecycle messages', () async {
        await _waitForServerToStart(timeout: startupTimeout);
        await Future.delayed(signalDelay);
        process.kill(ProcessSignal.sigint);

        var exitCode = await process.exitCode.timeout(terminationTimeout);
        expect(exitCode, 130);

        expect(stdoutLines.where(_isLifecycleMessage), isNotEmpty);
      });
    },
  );
}

bool _isLifecycleMessage(String line) {
  return _lifecycleMessages.any(line.contains);
}

bool _isStartupLifecycleMessage(String line) {
  return _startupLifecycleMessages.any(line.contains);
}

Future<void> _waitForServerToStart({
  required Duration timeout,
}) async {
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    final client = HttpClient();

    try {
      final request = await client.getUrl(Uri.parse(_serverUrl));
      final response = await request.close();
      await response.drain<void>();
      return;
    } on SocketException {
      await Future.delayed(const Duration(milliseconds: 250));
    } finally {
      client.close(force: true);
    }
  }

  fail('Serverpod server did not start within $timeout.');
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
      })
      .asBroadcastStream(
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
    // Spawn the real SDK binary (resolved through version-manager shims like
    // puro/fvm): shell shims do not forward the signals these tests send, so
    // the exit-code assertions would time out and leak the spawned server.
    executable == 'dart' ? dartExecutablePath : executable,
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
