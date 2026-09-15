@Tags(['integration'])
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import 'test_util/select_one.dart';

/// DualTransport end-to-end: one postmaster serving the trusted Unix socket
/// and scram-sha-256 loopback TCP at the same time.
void main() {
  late Directory tmpRoot;
  late Directory pgDataDir;

  setUp(() {
    tmpRoot = Directory.systemTemp.createTempSync('embedded_pg_dual_');
    pgDataDir = Directory(p.join(tmpRoot.path, '.serverpod', 'pgdata'));
  });

  tearDown(() {
    if (tmpRoot.existsSync()) tmpRoot.deleteSync(recursive: true);
  });

  Future<EmbeddedPostgres> startWith(Transport transport) =>
      EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: pgDataDir,
          databaseName: 'projectname',
          transport: transport,
          detach: true,
        ),
      );

  test(
    'Given a fresh project layout and a DualTransport with a password, '
    'when the cluster is started, '
    'then the socket endpoint and the TCP endpoint both answer queries',
    () async {
      var pg_ = await startWith(
        const DualTransport(password: 'dev-db-password'),
      );
      try {
        expect(pg_.endpoint.isUnixSocket, isTrue);
        expect(pg_.endpoint.password, isNull);
        expect(pg_.tcpEndpoint, isNotNull);
        expect(pg_.tcpEndpoint!.host, '127.0.0.1');
        expect(pg_.tcpEndpoint!.port, greaterThan(0));
        expect(pg_.tcpEndpoint!.password, 'dev-db-password');
        expect(
          pg_.tcpConnectionUri.toString(),
          'postgres://postgres:dev-db-password@127.0.0.1:'
          '${pg_.tcpEndpoint!.port}/projectname',
        );

        expect(await selectOne(pg_.endpoint), 1);
        expect(await selectOne(pg_.tcpEndpoint!), 1);
      } finally {
        await pg_.stop();
      }
    },
    skip: !hasUnixSocketSupport(),
    timeout: const Timeout(Duration(seconds: 120)),
  );

  test(
    'Given a fresh project layout and a DualTransport without a password, '
    'when the cluster is started, '
    'then a generated password authenticates over TCP',
    () async {
      var pg_ = await startWith(const DualTransport());
      try {
        expect(pg_.tcpEndpoint!.password!.length, greaterThan(8));
        expect(await selectOne(pg_.tcpEndpoint!), 1);
      } finally {
        await pg_.stop();
      }
    },
    skip: !hasUnixSocketSupport(),
    timeout: const Timeout(Duration(seconds: 120)),
  );

  test(
    'Given a cluster whose superuser has no password, '
    'when it is restarted with DualTransport and a configured password, '
    'then the configured password authenticates over TCP',
    () async {
      var unix = await startWith(const UnixTransport());
      var conn = await pg.Connection.open(
        unix.endpoint,
        settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
      );
      await conn.execute('ALTER ROLE postgres PASSWORD NULL');
      await conn.close();
      await unix.stop();

      var dual = await startWith(
        const DualTransport(password: 'rotated-password'),
      );
      try {
        expect(dual.tcpEndpoint!.password, 'rotated-password');
        expect(await selectOne(dual.tcpEndpoint!), 1);
      } finally {
        await dual.stop();
      }
    },
    skip: !hasUnixSocketSupport(),
    timeout: const Timeout(Duration(seconds: 180)),
  );

  test(
    'Given a loopback port held by another process, '
    'when a cluster is started on that port without ephemeralPortFallback, '
    'then PortInUseException names that port',
    () async {
      var holder = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      try {
        await expectLater(
          EmbeddedPostgres.start(
            EmbeddedPostgresOptions(
              dataDir: pgDataDir,
              databaseName: 'projectname',
              transport: DualTransport(port: holder.port, password: 'pw'),
              ephemeralPortFallback: false,
              detach: true,
            ),
          ),
          throwsA(
            isA<PortInUseException>().having(
              (e) => e.port,
              'port',
              holder.port,
            ),
          ),
        );
      } finally {
        await holder.close();
      }
    },
    skip: !hasUnixSocketSupport(),
    timeout: const Timeout(Duration(seconds: 120)),
  );

  test(
    'Given a loopback port held by another process, '
    'when a cluster is started on that port with ephemeralPortFallback, '
    'then TCP answers queries on another port',
    () async {
      final holder = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(holder.close);

      final pg_ = await EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: pgDataDir,
          databaseName: 'projectname',
          transport: DualTransport(port: holder.port, password: 'pw'),
          ephemeralPortFallback: true,
          detach: true,
        ),
      );
      addTearDown(pg_.stop);

      expect(pg_.tcpEndpoint!.port, isNot(holder.port));
      expect(await selectOne(pg_.tcpEndpoint!), 1);
    },
    skip: !hasUnixSocketSupport(),
    timeout: const Timeout(Duration(seconds: 120)),
  );

  test(
    'Given a cluster that fell back from a held port to an ephemeral one, '
    'when it is attached by its data directory, '
    'then the attached TCP endpoint names the port it listens on',
    () async {
      final holder = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(holder.close);
      final pg_ = await EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: pgDataDir,
          databaseName: 'projectname',
          transport: DualTransport(port: holder.port, password: 'pw'),
          ephemeralPortFallback: true,
          detach: true,
        ),
      );
      addTearDown(pg_.stop);

      final attached = await EmbeddedPostgres.attach(pgDataDir, password: 'pw');

      expect(attached.tcpEndpoint!.port, pg_.tcpEndpoint!.port);
    },
    skip: !hasUnixSocketSupport(),
    timeout: const Timeout(Duration(seconds: 120)),
  );

  test(
    'Given a detached DualTransport postmaster, '
    'when its data directory is reattached, '
    'then the socket endpoint is preferred and TCP keeps its port and password',
    () async {
      var started = await startWith(
        const DualTransport(password: 'dev-db-password'),
      );
      var origPort = started.tcpEndpoint!.port;

      var attached = await EmbeddedPostgres.attach(
        pgDataDir,
        password: 'dev-db-password',
      );
      try {
        expect(attached.endpoint.isUnixSocket, isTrue);
        expect(attached.tcpEndpoint!.port, origPort);
        expect(attached.tcpEndpoint!.password, 'dev-db-password');
        expect(await selectOne(attached.endpoint), 1);
        expect(await selectOne(attached.tcpEndpoint!), 1);
      } finally {
        await attached.stop();
      }
    },
    skip: !hasUnixSocketSupport(),
    timeout: const Timeout(Duration(seconds: 180)),
  );

  test(
    'Given a stopped cluster without a role named missing_role, '
    'when it is started with DualTransport as missing_role, '
    'then the start fails because the role does not exist',
    () async {
      var unix = await startWith(const UnixTransport());
      await unix.stop();

      await expectLater(
        EmbeddedPostgres.start(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            username: 'missing_role',
            transport: const DualTransport(password: 'secret-password'),
          ),
        ),
        throwsA(
          isA<InitializeDatabaseException>().having(
            (e) => e.message,
            'message',
            contains('role "missing_role" does not exist'),
          ),
        ),
      );
    },
    skip: !hasUnixSocketSupport(),
    timeout: const Timeout(Duration(seconds: 180)),
  );

  test(
    'Given a stopped cluster without a role named missing_role, '
    'when it is started with DualTransport as missing_role, '
    'then the startup error does not contain the DualTransport password',
    () async {
      var unix = await startWith(const UnixTransport());
      await unix.stop();

      await expectLater(
        EmbeddedPostgres.start(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            username: 'missing_role',
            transport: const DualTransport(password: 'secret-password'),
          ),
        ),
        throwsA(
          isA<InitializeDatabaseException>().having(
            (e) => e.message,
            'message',
            isNot(contains('secret-password')),
          ),
        ),
      );
    },
    skip: !hasUnixSocketSupport(),
    timeout: const Timeout(Duration(seconds: 180)),
  );

  test(
    'Given a running DualTransport postmaster, '
    'when startOrAttach joins it with DualTransport on another port, '
    'then the port in postgresql.conf stays the running one',
    () async {
      var running = await startWith(
        const DualTransport(password: 'dev-db-password'),
      );
      try {
        var runningPort = running.tcpEndpoint!.port;
        var otherPort = await _freeLoopbackPort();

        await EmbeddedPostgres.startOrAttach(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            transport: DualTransport(
              port: otherPort,
              password: 'dev-db-password',
            ),
          ),
        );

        var conf = File(
          p.join(pgDataDir.path, 'postgresql.conf'),
        ).readAsStringSync();
        expect(conf, contains('\nport = $runningPort\n'));
      } finally {
        await running.stop();
      }
    },
    skip: !hasUnixSocketSupport(),
    timeout: const Timeout(Duration(seconds: 180)),
  );
}

Future<int> _freeLoopbackPort() async {
  var socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
  var port = socket.port;
  await socket.close();
  return port;
}
