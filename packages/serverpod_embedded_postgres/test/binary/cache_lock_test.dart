import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_embedded_postgres/src/binary/cache_lock.dart';
import 'package:test/test.dart';

void main() {
  late Directory tmp;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('cache_lock_test_');
  });

  tearDown(() {
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
  });

  group('Given a cache root', () {
    // Mutex semantics are RandomAccessFile.lock's responsibility (and on
    // POSIX, fcntl locks are per-process so two same-process acquires are
    // not a meaningful test anyway). Phase 2e's integration test exercises
    // the lock in a real two-isolate / two-process scenario. These checks
    // pin our wiring around that primitive.

    test(
      'when withLock is called on a missing dir then the dir and .lock file '
      'are created.',
      () async {
        var missing = Directory(p.join(tmp.path, 'does-not-exist-yet'));

        await CacheLock.withLock(missing, () async {
          expect(missing.existsSync(), isTrue);
          expect(File(p.join(missing.path, '.lock')).existsSync(), isTrue);
        });
      },
    );

    test('when the action throws then the lock is released.', () async {
      // After release, a second withLock should resolve immediately (i.e.
      // not deadlock on a left-over lock holder). We assert this with a
      // short timeout - if release was missed, the second acquire would
      // hang and timeout.
      var first = CacheLock.withLock(tmp, () async {
        throw StateError('boom');
      });

      await expectLater(first, throwsStateError);

      await CacheLock.withLock(
        tmp,
        () async {},
      ).timeout(const Duration(seconds: 2));
    });
  });
}
