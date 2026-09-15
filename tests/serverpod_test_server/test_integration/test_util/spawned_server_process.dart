import 'dart:convert';
import 'dart:io';

import 'package:serverpod_shared/process_io.dart';
import 'package:test/test.dart';

typedef ProcessOutput = ({
  Process process,
  Stream<String> outQueue,
  Stream<String> errQueue,
});

/// Starts the test server so SIGINT reaches the VM.
///
/// Spawn `bin/main.dart` through [dartExecutablePath]. Shell shims and a
/// precompiled kernel either drop signals or skip native-asset hooks
/// (embedded Postgres then hangs in FFI and never handles SIGINT).
/// [util/run_tests_integration] runs these files with the rest of the shard
/// so the child can attach to an already-running postmaster.
Future<ProcessOutput> startSpawnedServer(
  List<String> arguments, {
  Map<String, String>? environment,
  bool verbose = false,
}) async {
  final process = await Process.start(
    dartExecutablePath,
    ['bin/main.dart', ...arguments],
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

  // Keep a listener for the life of the test so [asBroadcastStream] does
  // not pause when `expectLater` cancels. A pause while the child exits
  // drops the completion line and the suite waits out its 120s timeout.
  final outListen = outQueue.listen((_) {}, cancelOnError: true);
  final errListen = errQueue.listen((_) {}, cancelOnError: true);

  addTearDown(() {
    outListen.cancel();
    errListen.cancel();
    process.kill(ProcessSignal.sigkill);
  });

  return (
    process: process,
    outQueue: outQueue,
    errQueue: errQueue,
  );
}

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
      .asBroadcastStream();
}
