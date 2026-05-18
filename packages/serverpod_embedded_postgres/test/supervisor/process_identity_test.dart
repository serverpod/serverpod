import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_embedded_postgres/src/supervisor/process_identity.dart';
import 'package:test/test.dart';

void main() {
  late Directory tmp;
  late File pidFile;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('process_identity_test_');
    pidFile = File(p.join(tmp.path, 'postgres.pid'));
  });

  tearDown(() {
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
  });

  group('Given a ProcessIdentity', () {
    test(
      'when written via writeAtomic then read returns an equal record.',
      () {
        var written = ProcessIdentity(
          pid: 1234,
          executable: '/abs/postgres',
          dataDir: '/abs/pgdata',
          startedAt: DateTime.utc(2026, 5, 7, 10),
          supervisorPid: 5678,
          supervisorExecutable: '/usr/bin/dart',
        );

        ProcessIdentity.writeAtomic(pidFile, written);
        var read = ProcessIdentity.read(pidFile)!;

        expect(read.pid, written.pid);
        expect(read.executable, written.executable);
        expect(read.dataDir, written.dataDir);
        expect(read.startedAt, written.startedAt);
        expect(read.supervisorPid, written.supervisorPid);
        expect(read.supervisorExecutable, written.supervisorExecutable);
      },
    );

    test('when read on a missing file then null is returned.', () {
      expect(ProcessIdentity.read(pidFile), isNull);
    });

    test(
      'when read on a corrupt JSON pidfile then null is returned (no throw).',
      () {
        pidFile.writeAsStringSync('not-json');

        expect(ProcessIdentity.read(pidFile), isNull);
      },
    );

    test(
      'when read on a JSON pidfile missing required fields '
      'then null is returned.',
      () {
        pidFile.writeAsStringSync('{"pid": 1234}');

        expect(ProcessIdentity.read(pidFile), isNull);
      },
    );
  });

  group('Given verifyIdentity', () {
    test(
      'when the recorded pid is not running then notRunning is returned.',
      () {
        // PID 999999 is virtually certain to not be a live process.
        var dead = ProcessIdentity(
          pid: 999999,
          executable: '/nope/postgres',
          dataDir: '/nope/pgdata',
          startedAt: DateTime.now().toUtc(),
          supervisorPid: 12345,
          supervisorExecutable: '/usr/bin/dart',
        );

        expect(verifyIdentity(dead), IdentityMatch.notRunning);
      },
    );

    test(
      'when the recorded pid is alive but the running process is not our '
      'postgres then foreign is returned.',
      () {
        // Use the current Dart process - it's alive but its identity does
        // not match the fake postmaster we claim, on any platform.
        var ours = ProcessIdentity(
          pid: pid,
          executable: '/fake/postgres',
          dataDir: '/fake/pgdata',
          startedAt: DateTime.now().toUtc(),
          supervisorPid: 12345,
          supervisorExecutable: '/usr/bin/dart',
        );

        expect(verifyIdentity(ours), IdentityMatch.foreign);
      },
    );
  });
}
