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

  group('Given an unheld lock path', () {
    test(
      'when acquired '
      'then the lock file is created and release removes it',
      () async {
        var lock = await InterProcessLock.acquire(
          lockPath,
          staleWhen: const StaleLockPolicy.never(),
        );
        expect(File(lockPath).existsSync(), isTrue);

        await lock.release();
        expect(File(lockPath).existsSync(), isFalse);
      },
    );

    test(
      'when used via withLock '
      'then the lock is held during the action and released after',
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

    test(
      'when used via withLock and the action throws '
      'then the lock is still released',
      () async {
        await expectLater(
          InterProcessLock.withLock(
            lockPath,
            staleWhen: const StaleLockPolicy.never(),
            () async => throw StateError('boom'),
          ),
          throwsStateError,
        );
        expect(File(lockPath).existsSync(), isFalse);
      },
    );
  });

  group('Given a held lock', () {
    late InterProcessLock lock;

    setUp(() async {
      lock = await InterProcessLock.acquire(
        lockPath,
        staleWhen: const StaleLockPolicy.never(),
      );
    });

    tearDown(() => lock.release());

    test(
      'when released twice '
      'then the second release is a no-op',
      () async {
        await lock.release();
        await lock.release();
        expect(File(lockPath).existsSync(), isFalse);
      },
    );

    test(
      'when a second acquire is attempted '
      'then it times out until the lock is released',
      () async {
        await expectLater(
          InterProcessLock.acquire(
            lockPath,
            staleWhen: const StaleLockPolicy.never(),
            timeout: const Duration(milliseconds: 200),
          ),
          throwsA(isA<TimeoutException>()),
        );

        await lock.release();

        var second = await InterProcessLock.acquire(
          lockPath,
          staleWhen: const StaleLockPolicy.never(),
        );
        expect(File(lockPath).existsSync(), isTrue);
        await second.release();
      },
    );

    test(
      'when another holder has reclaimed and re-taken it '
      'then release does not delete their lock file',
      () async {
        // Simulate another acquirer reclaiming and re-taking the lock by
        // overwriting it with a different token.
        File(lockPath).writeAsStringSync('999999999:other');

        await lock.release();
        expect(File(lockPath).existsSync(), isTrue);
        expect(File(lockPath).readAsStringSync(), '999999999:other');
      },
    );
  });

  group('Given a held lock refreshed by its heartbeat', () {
    late InterProcessLock lock;

    setUp(() async {
      // While we wait for the fix to dart-lang/sdk#51937 to land we use >1s staleWhen
      lock = await InterProcessLock.acquire(
        lockPath,
        staleWhen: const StaleLockPolicy.age(Duration(seconds: 2)),
        heartbeatInterval: const Duration(milliseconds: 250),
      );
    });

    tearDown(() => lock.release());

    test(
      'when a competing acquire waits past the age cap '
      'then it still times out',
      () async {
        // Wait past the age cap.
        await Future<void>.delayed(const Duration(milliseconds: 2500));

        await expectLater(
          InterProcessLock.acquire(
            lockPath,
            staleWhen: const StaleLockPolicy.age(Duration(seconds: 2)),
            timeout: const Duration(milliseconds: 800),
          ),
          throwsA(isA<TimeoutException>()),
        );
      },
    );
  });

  group('Given a lock file older than the age cap', () {
    setUp(() {
      File(lockPath).writeAsStringSync('held');
      File(lockPath).setLastModifiedSync(
        DateTime.now().subtract(const Duration(minutes: 10)),
      );
    });

    test(
      'when acquired with the age policy '
      'then it is reclaimed',
      () async {
        var lock = await InterProcessLock.acquire(
          lockPath,
          staleWhen: const StaleLockPolicy.age(Duration(minutes: 2)),
          timeout: const Duration(seconds: 2),
        );
        expect(File(lockPath).existsSync(), isTrue);
        await lock.release();
      },
    );
  });

  group('Given a lock file whose holder process is gone', () {
    setUp(() {
      // A PID far above any real process table entry, so the
      // holder reads as dead and the lock is reclaimed immediately.
      File(lockPath).writeAsStringSync('2147483646');
    });

    test(
      'when acquired with the processLiveness policy '
      'then it is reclaimed',
      () async {
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
  });
}
