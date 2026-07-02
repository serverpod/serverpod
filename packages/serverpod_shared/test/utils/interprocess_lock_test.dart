import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_shared/process_io.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late String lockPath;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('interprocess_lock_test');
    lockPath = p.join(tempDir.path, 'test.lock');
  });

  tearDown(() {
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  test('acquire creates the lock file and release removes it', () async {
    var lock = await InterProcessLock.acquire(
      lockPath,
      staleWhen: const StaleLockPolicy.never(),
    );
    expect(File(lockPath).existsSync(), isTrue);

    await lock.release();
    expect(File(lockPath).existsSync(), isFalse);
  });

  test('release is idempotent', () async {
    var lock = await InterProcessLock.acquire(
      lockPath,
      staleWhen: const StaleLockPolicy.never(),
    );
    await lock.release();
    await lock.release();
    expect(File(lockPath).existsSync(), isFalse);
  });

  test('a second acquire blocks while the first is held, then succeeds '
      'once released', () async {
    var first = await InterProcessLock.acquire(
      lockPath,
      staleWhen: const StaleLockPolicy.never(),
    );

    await expectLater(
      InterProcessLock.acquire(
        lockPath,
        staleWhen: const StaleLockPolicy.never(),
        timeout: const Duration(milliseconds: 200),
      ),
      throwsA(isA<TimeoutException>()),
    );

    await first.release();

    var second = await InterProcessLock.acquire(
      lockPath,
      staleWhen: const StaleLockPolicy.never(),
    );
    expect(File(lockPath).existsSync(), isTrue);
    await second.release();
  });

  test('age policy reclaims a lock left behind past the age cap', () async {
    File(lockPath).writeAsStringSync('held');
    File(lockPath).setLastModifiedSync(
      DateTime.now().subtract(const Duration(minutes: 10)),
    );

    var lock = await InterProcessLock.acquire(
      lockPath,
      staleWhen: const StaleLockPolicy.age(Duration(minutes: 2)),
      timeout: const Duration(seconds: 2),
    );
    expect(File(lockPath).existsSync(), isTrue);
    await lock.release();
  });

  test(
    'processLiveness policy reclaims a lock whose holder process is gone',
    () async {
      // A PID far above any real process table entry is unassigned, so the
      // holder reads as dead and the lock is reclaimed immediately.
      File(lockPath).writeAsStringSync('2147483646');

      var lock = await InterProcessLock.acquire(
        lockPath,
        staleWhen: const StaleLockPolicy.processLiveness(
          staleAfter: Duration(minutes: 2),
        ),
        timeout: const Duration(seconds: 2),
      );
      expect(File(lockPath).existsSync(), isTrue);
      await lock.release();
    },
  );

  test('release does not delete a lock reclaimed by another holder', () async {
    var lock = await InterProcessLock.acquire(
      lockPath,
      staleWhen: const StaleLockPolicy.never(),
    );

    // Simulate another acquirer reclaiming and re-taking the lock by
    // overwriting it with a different token.
    File(lockPath).writeAsStringSync('999999999:other');

    await lock.release();
    expect(File(lockPath).existsSync(), isTrue);
    expect(File(lockPath).readAsStringSync(), '999999999:other');
  });

  test(
    'heartbeat keeps a held lock from being reclaimed past the age cap',
    () async {
      // Dart reads mtime back at whole-second resolution (dart-lang/sdk#51937),
      // so the cap and wait stay above one second to exercise the heartbeat.
      var lock = await InterProcessLock.acquire(
        lockPath,
        staleWhen: const StaleLockPolicy.age(Duration(seconds: 2)),
        heartbeatInterval: const Duration(milliseconds: 250),
      );

      // Wait past the age cap. The heartbeat keeps the modified time fresh, so a
      // competing acquire must still see the lock as live and time out (without
      // the heartbeat the lock would now be reclaimable).
      await Future<void>.delayed(const Duration(milliseconds: 2500));

      await expectLater(
        InterProcessLock.acquire(
          lockPath,
          staleWhen: const StaleLockPolicy.age(Duration(seconds: 2)),
          timeout: const Duration(milliseconds: 800),
        ),
        throwsA(isA<TimeoutException>()),
      );

      await lock.release();
    },
  );

  test(
    'withLock runs the action while holding the lock and releases after',
    () async {
      var ran = false;
      await InterProcessLock.withLock(
        lockPath,
        staleWhen: const StaleLockPolicy.never(),
        () async {
          ran = true;
          expect(File(lockPath).existsSync(), isTrue);
        },
      );
      expect(ran, isTrue);
      expect(File(lockPath).existsSync(), isFalse);
    },
  );

  test('withLock releases the lock even when the action throws', () async {
    await expectLater(
      InterProcessLock.withLock(
        lockPath,
        staleWhen: const StaleLockPolicy.never(),
        () async => throw StateError('boom'),
      ),
      throwsStateError,
    );
    expect(File(lockPath).existsSync(), isFalse);
  });
}
