@Tags(['integration'])
@Timeout(Duration(minutes: 2))
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:test/test.dart';

import 'test_util/select_one.dart';

void main() {
  late Directory root;

  setUpAll(() async {
    await EmbeddedPostgres.prefetch(defaultPostgresVersion);
  });

  setUp(() {
    root = Directory.systemTemp.createTempSync('pg parent exit ');
  });

  tearDown(() async {
    // Clean up even against the unfixed implementation, which leaks postgres.
    try {
      final postgres = await EmbeddedPostgres.attach(
        Directory(p.join(root.path, 'pgdata')),
        password: 'test-password',
      );
      await postgres.stop();
    } on AttachException {
      // The watchdog already stopped the postmaster.
    }
    root.deleteSync(recursive: true);
  });

  test(
    'Given a test process with a shared embedded database, '
    'when dart test finishes successfully, '
    'then another project can reuse its TCP port.',
    () async {
      final owner = await _startOwner(root, [
        'test',
        'test/test_util/parent_exit_test_runner.dart',
      ]);
      final port = await _readPort(root, owner);

      expect(await owner.exitCode.timeout(const Duration(seconds: 30)), 0);
      await _waitForPortRelease(port);

      final nextProject = Directory(p.join(root.path, 'second-project'));
      final postgres = await EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: Directory(p.join(nextProject.path, 'pgdata')),
          databaseName: 'other_project',
          transport: TcpTransport(port: port, password: 'test-password'),
        ),
      );
      addTearDown(postgres.stop);

      expect(await selectOne(postgres.endpoint), 1);
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'Given an embedded database owned by another process, '
    'when the owner is killed without running signal handlers, '
    'then the database releases its TCP port.',
    () async {
      final owner = await _startOwner(root, [
        'test/test_util/parent_exit_owner.dart',
        'wait',
      ]);
      final port = await _readPort(root, owner);

      owner.kill(ProcessSignal.sigkill);
      await owner.exitCode;
      await _waitForPortRelease(port);

      await _waitUntil(
        () => !File(p.join(root.path, 'pgdata', 'postmaster.pid')).existsSync(),
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'Given a shared database started by a disposable isolate, '
    'when that isolate exits while its VM remains alive, '
    'then the database stays usable until the VM exits.',
    () async {
      final owner = await _startOwner(root, [
        'test/test_util/parent_exit_owner.dart',
        'isolate',
      ]);
      final port = await _readPort(root, owner);
      await _waitUntil(
        () => File(p.join(root.path, 'isolate_exited')).existsSync(),
      );

      // Cross several watchdog intervals after the launching isolate is gone.
      await Future<void>.delayed(const Duration(seconds: 3));
      final attached = await EmbeddedPostgres.attach(
        Directory(p.join(root.path, 'pgdata')),
        password: 'test-password',
      );
      expect(await selectOne(attached.endpoint), 1);

      owner.stdin.writeln('exit');
      await owner.exitCode;
      await _waitForPortRelease(port);
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'Given a Linux host without ps on PATH, '
    'when the database owner exits, '
    'then the database still starts and releases its port.',
    () async {
      final emptyPath = Directory(p.join(root.path, 'bin'))..createSync();
      final owner = await _startOwner(
        root,
        ['test/test_util/parent_exit_owner.dart', 'wait'],
        environment: {'PATH': emptyPath.path},
      );
      final port = await _readPort(root, owner);

      owner.stdin.writeln('exit');
      expect(await owner.exitCode, 0);
      await _waitForPortRelease(port);
    },
    skip: !Platform.isLinux,
  );

  test(
    'Given a Linux host whose ps start dates change between reads, '
    'when the database owner later exits, '
    'then the database stays usable until that exit and releases its port.',
    () async {
      final tools = Directory(p.join(root.path, 'bin'))..createSync();
      final ps = File(p.join(tools.path, 'ps'))
        ..writeAsStringSync(
          '#!/bin/sh\n'
          // Each ps invocation changes the human-readable birth date, as a
          // realtime clock correction does, while keeping the argv untouched.
          '/bin/ps "\$@" | /bin/sed "s/[A-Z][a-z][a-z] [A-Z][a-z][a-z]/Clock step \$\$/"\n',
        );
      final chmod = await Process.run('chmod', ['+x', ps.path]);
      expect(chmod.exitCode, 0);
      final owner = await _startOwner(
        root,
        ['test/test_util/parent_exit_owner.dart', 'wait'],
        environment: {'PATH': '${tools.path}:${Platform.environment['PATH']}'},
      );
      final port = await _readPort(root, owner);

      await Future<void>.delayed(const Duration(seconds: 3));
      final attached = await EmbeddedPostgres.attach(
        Directory(p.join(root.path, 'pgdata')),
        password: 'test-password',
      );
      expect(await selectOne(attached.endpoint), 1);
      owner.kill(ProcessSignal.sigkill);
      await owner.exitCode;
      await _waitForPortRelease(port);
    },
    skip: !Platform.isLinux,
  );

  test(
    'Given a non-ASCII data path and the C locale on POSIX, '
    'when the database owner exits, '
    'then the database starts and releases its port.',
    () async {
      root.deleteSync();
      root = Directory.systemTemp.createTempSync('pg saída ');
      final owner = await _startOwner(
        root,
        ['test/test_util/parent_exit_owner.dart', 'wait'],
        environment: {'LC_ALL': 'C'},
      );
      final port = await _readPort(root, owner);

      owner.stdin.writeln('exit');
      expect(await owner.exitCode, 0);
      await _waitForPortRelease(port);
    },
    skip: Platform.isWindows,
  );

  test(
    'Given a binary cache path containing forward slashes and a dot segment, '
    'when the database owner exits, '
    'then the watchdog accepts the executable and releases its port.',
    () async {
      final owner = await _startOwner(root, [
        'test/test_util/parent_exit_owner.dart',
        'cache-path',
      ]);
      final port = await _readPort(root, owner);

      owner.stdin.writeln('exit');
      expect(await owner.exitCode, 0);
      await _waitForPortRelease(port);
    },
  );

  test(
    'Given a non-detached database borrowed by another OS process, '
    'when the launching process exits, '
    'then the borrowed database stops and the borrower can launch a replacement.',
    () async {
      final owner = await _startOwner(root, [
        'test/test_util/parent_exit_owner.dart',
        'wait',
      ]);
      final port = await _readPort(root, owner);
      final options = EmbeddedPostgresOptions(
        dataDir: Directory(p.join(root.path, 'pgdata')),
        databaseName: 'lifetime_test',
        transport: TcpTransport(port: port, password: 'test-password'),
      );
      final borrowed = await EmbeddedPostgres.startOrAttach(options);
      expect(borrowed.launched, isFalse);
      expect(await selectOne(borrowed.handle.endpoint), 1);

      owner.stdin.writeln('exit');
      expect(await owner.exitCode, 0);
      await _waitForPortRelease(port);
      await _waitUntil(() => !borrowed.handle.isRunning);
      expect(borrowed.handle.isRunning, isFalse);
      await expectLater(selectOne(borrowed.handle.endpoint), throwsException);
      final replacement = await EmbeddedPostgres.startOrAttach(options);
      addTearDown(replacement.handle.stop);

      expect(replacement.launched, isTrue);
      expect(await selectOne(replacement.handle.endpoint), 1);
    },
  );

  test(
    'Given a database started with detach enabled, '
    'when its owner exits, '
    'then a new process can still attach and query it.',
    () async {
      final owner = await _startOwner(root, [
        'test/test_util/parent_exit_owner.dart',
        'detach',
      ]);
      await _readPort(root, owner);

      owner.stdin.writeln('exit');
      expect(await owner.exitCode, 0);
      await Future<void>.delayed(const Duration(seconds: 3));
      final attached = await EmbeddedPostgres.attach(
        Directory(p.join(root.path, 'pgdata')),
        password: 'test-password',
      );

      expect(await selectOne(attached.endpoint), 1);
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}

Future<Process> _startOwner(
  Directory root,
  List<String> arguments, {
  Map<String, String> environment = const {},
}) async {
  final owner = await Process.start(
    Platform.resolvedExecutable,
    arguments,
    environment: {'PG_TEST_ROOT': root.path, ...environment},
  );
  final output = StringBuffer();
  owner.stdout.transform(utf8.decoder).listen(output.write);
  owner.stderr.transform(utf8.decoder).listen(output.write);
  addTearDown(() async {
    owner.kill(ProcessSignal.sigkill);
    await owner.exitCode;
  });
  unawaited(
    owner.exitCode.then((code) {
      if (code != 0) {
        printOnFailure('Database owner exited with $code: $output');
      }
    }),
  );
  return owner;
}

Future<int> _readPort(Directory root, Process owner) async {
  int? ownerExitCode;
  unawaited(
    owner.exitCode.then((code) {
      ownerExitCode = code;
    }),
  );
  final ready = File(p.join(root.path, 'ready.json'));
  await _waitUntil(() {
    if (ready.existsSync()) return true;
    if (ownerExitCode != null) {
      throw StateError(
        'Database owner exited before readiness: $ownerExitCode',
      );
    }
    return false;
  }, timeout: const Duration(seconds: 90));
  return (jsonDecode(ready.readAsStringSync()) as Map)['port'] as int;
}

Future<void> _waitForPortRelease(int port) async {
  await _waitUntil(() async {
    try {
      final socket = await ServerSocket.bind(
        InternetAddress.loopbackIPv4,
        port,
      );
      await socket.close();
      return true;
    } on SocketException {
      return false;
    }
  });
}

Future<void> _waitUntil(
  FutureOr<bool> Function() condition, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!await condition()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('Timed out waiting for database owner lifecycle');
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}
