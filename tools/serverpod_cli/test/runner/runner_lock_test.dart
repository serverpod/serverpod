import 'dart:io';

import 'package:serverpod_cli/src/runner/runner_lock.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_shared/serverpod_shared.dart' show FileEx;
import 'package:test/test.dart';

void main() {
  group('Given a server package directory,', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('rlt');
    });

    tearDown(() async {
      await tempDir.deleteIfExists(recursive: true);
    });

    test(
      'when the lock is taken, '
      'then the lock file lives at .dart_tool/serverpod/runner.lock',
      () async {
        final lock = await RunnerLock.acquire(tempDir.path);
        addTearDown(lock.release);

        expect(lock.lockPath, serverpodRunnerLockPath(tempDir.path));
        expect(File(lock.lockPath).existsSync(), isTrue);
      },
    );

    test(
      'when a second runner process tries to take it, '
      'then it fails rather than queueing behind the first',
      () async {
        final holder = await _spawnLockHolder(tempDir.path);
        addTearDown(() async {
          holder.kill(ProcessSignal.sigkill);
          await holder.exitCode;
        });

        await expectLater(
          RunnerLock.acquire(tempDir.path).timeout(const Duration(seconds: 5)),
          throwsA(isA<RunnerLockedException>()),
        );
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'when another process holds the lock only briefly, '
      'then acquiring waits it out instead of failing',
      () async {
        final holder = await _spawnLockHolder(tempDir.path);
        addTearDown(() async {
          holder.kill(ProcessSignal.sigkill);
          await holder.exitCode;
        });

        final acquired = RunnerLock.acquire(
          tempDir.path,
          patience: const Duration(seconds: 5),
        );
        await Future<void>.delayed(const Duration(milliseconds: 100));
        holder.kill(ProcessSignal.sigkill);

        final lock = await acquired;
        addTearDown(lock.release);
        expect(lock.lockPath, serverpodRunnerLockPath(tempDir.path));
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'when the first runner releases, '
      'then a second can take the lock',
      () async {
        final first = await RunnerLock.acquire(tempDir.path);
        await first.release();

        final second = await RunnerLock.acquire(tempDir.path);
        addTearDown(second.release);

        expect(second.lockPath, serverpodRunnerLockPath(tempDir.path));
      },
    );

    test(
      'when release is called twice, '
      'then the second call is a no-op',
      () async {
        final lock = await RunnerLock.acquire(tempDir.path);

        await lock.release();

        await expectLater(lock.release(), completes);
      },
    );

    test(
      'when the holding process dies without releasing, '
      'then the kernel drops the lock and the next runner takes it',
      () async {
        final holder = await _spawnLockHolder(tempDir.path);
        addTearDown(() async {
          holder.kill(ProcessSignal.sigkill);
          await holder.exitCode;
        });
        await expectLater(
          RunnerLock.acquire(tempDir.path),
          throwsA(isA<RunnerLockedException>()),
        );

        holder.kill(ProcessSignal.sigkill);
        await holder.exitCode;

        final lock = await RunnerLock.acquire(tempDir.path);
        addTearDown(lock.release);
        expect(lock.lockPath, serverpodRunnerLockPath(tempDir.path));
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}

/// Locks [serverDir] from another process, since POSIX locks are per process.
Future<Process> _spawnLockHolder(String serverDir) async {
  final lockPath = serverpodRunnerLockPath(serverDir);
  await File(lockPath).parent.create(recursive: true);

  final script = File('$serverDir/hold_lock.dart');
  await script.writeAsString('''
import 'dart:io';
Future<void> main(List<String> args) async {
  final handle = await File(args.first).open(mode: FileMode.write);
  await handle.lock(FileLock.exclusive);
  stdout.writeln('locked');
  await stdout.flush();
  await Future<void>.delayed(const Duration(seconds: 30));
}
''');

  final holder = await Process.start(Platform.resolvedExecutable, [
    script.path,
    lockPath,
  ]);
  await holder.stdout.transform(const SystemEncoding().decoder).first;
  return holder;
}
