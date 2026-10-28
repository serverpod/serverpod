@Tags(['integration'])
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
      final port = await _readPort(root);

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
      final port = await _readPort(root);

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
      final port = await _readPort(root);
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
    'Given a database started with detach enabled, '
    'when its owner exits, '
    'then a new process can still attach and query it.',
    () async {
      final owner = await _startOwner(root, [
        'test/test_util/parent_exit_owner.dart',
        'detach',
      ]);
      await _readPort(root);

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

Future<Process> _startOwner(Directory root, List<String> arguments) async {
  final owner = await Process.start(
    Platform.resolvedExecutable,
    arguments,
    environment: {'PG_TEST_ROOT': root.path},
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

Future<int> _readPort(Directory root) async {
  final ready = File(p.join(root.path, 'ready.json'));
  await _waitUntil(ready.existsSync);
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

Future<void> _waitUntil(FutureOr<bool> Function() condition) async {
  final deadline = DateTime.now().add(const Duration(seconds: 20));
  while (!await condition()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('Timed out waiting for database owner lifecycle');
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}
