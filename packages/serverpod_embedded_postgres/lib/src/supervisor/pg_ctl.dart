import 'dart:io';

import 'package:path/path.dart' as p;

/// Returns the `pg_ctl` executable beside a recorded `postgres` executable.
File pgCtlForPostgresExecutable(String postgresExecutable) {
  final fileName = Platform.isWindows ? 'pg_ctl.exe' : 'pg_ctl';
  return File(p.join(p.dirname(postgresExecutable), fileName));
}

/// Asks PostgreSQL to stop the cluster and waits for shutdown to complete.
///
/// This is required on Windows, where `dart:io` ignores the requested process
/// signal and terminates only the postmaster. That can leave backend processes
/// alive with open files in [dataDir].
Future<bool> stopWithPgCtl({
  required File pgCtl,
  required Directory dataDir,
  required Duration timeout,
  String mode = 'fast',
}) async {
  if (!pgCtl.existsSync()) return false;

  String dataPath;
  try {
    dataPath = p.normalize(dataDir.absolute.resolveSymbolicLinksSync());
  } on FileSystemException {
    dataPath = p.normalize(p.absolute(dataDir.path));
  }

  final timeoutSeconds = (timeout.inMilliseconds + 999) ~/ 1000;
  try {
    final result = await Process.run(pgCtl.path, [
      'stop',
      '-D',
      dataPath,
      '-m',
      mode,
      '-w',
      '-t',
      '${timeoutSeconds < 1 ? 1 : timeoutSeconds}',
      '-s',
    ]);
    return result.exitCode == 0;
  } on ProcessException {
    return false;
  }
}
