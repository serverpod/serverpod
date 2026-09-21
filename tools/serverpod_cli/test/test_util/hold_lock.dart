import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:test/test.dart';

/// Starts a process that holds the runner lock for [serverDir] until killed.
///
/// POSIX locks are per process. Teardown awaits the exit, as Windows cannot
/// delete a directory while the process holds a file in it.
Future<Process> holdLockFromAnotherProcess(String serverDir) async {
  await File(serverpodRunnerLockPath(serverDir)).parent.create(recursive: true);
  final script = File(p.join(serverDir, 'hold_lock.dart'));
  await script.writeAsString('''
import 'dart:io';
void main() async {
  final file = await File(${jsonEncode(serverpodRunnerLockPath(serverDir))})
      .open(mode: FileMode.writeOnlyAppend);
  await file.lock(FileLock.exclusive);
  stdout.writeln('locked');
  await stdin.first;
}
''');
  final process = await Process.start(Platform.resolvedExecutable, [
    script.path,
  ]);
  await process.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .firstWhere((line) => line == 'locked');
  addTearDown(() async {
    process.kill();
    await process.exitCode;
  });
  return process;
}
