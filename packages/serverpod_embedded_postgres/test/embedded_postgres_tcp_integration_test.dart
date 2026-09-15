@Tags(['integration'])
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:test/test.dart';

import 'test_util/select_one.dart';

/// TCP transport end-to-end. Validates ephemeral port allocation, the
/// per-launch role password, and scram-sha-256 auth via package:postgres.
void main() {
  late Directory tmpRoot;

  setUp(() {
    tmpRoot = Directory.systemTemp.createTempSync('embedded_pg_tcp_');
  });

  tearDown(() {
    if (tmpRoot.existsSync()) tmpRoot.deleteSync(recursive: true);
  });

  group('Given TcpTransport with port=0,', () {
    test(
      'when start runs '
      'then a non-zero ephemeral port is allocated, connection.execute roundtrips via TCP, and the libpq URI carries user:password.',
      () async {
        var pgDataDir = Directory(p.join(tmpRoot.path, '.serverpod', 'pgdata'));

        var pg_ = await EmbeddedPostgres.start(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            transport: const TcpTransport(),
            detach: true,
          ),
        );

        expect(
          pg_.endpoint.port,
          greaterThan(0),
          reason: 'ephemeral port must be resolved before exposing endpoint',
        );
        expect(pg_.endpoint.host, '127.0.0.1');
        expect(pg_.endpoint.password, isNotNull);
        expect(
          pg_.endpoint.password!.length,
          greaterThan(8),
          reason: 'auto-generated password must be non-trivial',
        );

        // libpq URI carries user:password@host:port/db
        var uri = pg_.connectionUri;
        expect(uri.scheme, 'postgres');
        expect(uri.userInfo, contains(pg_.endpoint.password!));

        var conn = await pg.Connection.open(
          pg_.endpoint,
          settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
        );
        var rs = await conn.execute('SELECT 1');
        expect(rs.first.first, 1);
        await conn.close();

        await pg_.stop();
      },
      timeout: const Timeout(Duration(seconds: 120)),
    );

    test(
      'when start runs twice in a row, '
      'then the second launch authenticates with its own new password',
      () async {
        var pgDataDir = Directory(p.join(tmpRoot.path, '.serverpod', 'pgdata'));

        var first = await EmbeddedPostgres.start(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            transport: const TcpTransport(),
            detach: true,
          ),
        );
        var pwFirst = first.endpoint.password!;
        await first.stop();

        var second = await EmbeddedPostgres.start(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            transport: const TcpTransport(),
            detach: true,
          ),
        );
        expect(
          second.endpoint.password,
          isNot(pwFirst),
          reason: 'nothing is persisted, so each launch gets a new password',
        );

        var conn = await pg.Connection.open(
          second.endpoint,
          settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
        );
        var rs = await conn.execute('SELECT 1');
        expect(rs.first.first, 1);
        await conn.close();

        await second.stop();
      },
      timeout: const Timeout(Duration(seconds: 180)),
    );

    test(
      'when an explicit password is provided via TcpTransport, '
      'then it is used',
      () async {
        var pgDataDir = Directory(p.join(tmpRoot.path, '.serverpod', 'pgdata'));
        var explicit = 'super-secret-dev-pw';

        var pg_ = await EmbeddedPostgres.start(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            transport: TcpTransport(password: explicit),
            detach: true,
          ),
        );

        expect(pg_.endpoint.password, explicit);

        await pg_.stop();
      },
      timeout: const Timeout(Duration(seconds: 120)),
    );

    test(
      'when an explicit password is provided via TcpTransport, '
      'then no postgres.password file is written next to the data directory',
      () async {
        final pgDataDir = Directory(
          p.join(tmpRoot.path, '.serverpod', 'pgdata'),
        );

        final pg_ = await EmbeddedPostgres.start(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            transport: const TcpTransport(password: 'super-secret-dev-pw'),
            detach: true,
          ),
        );
        addTearDown(pg_.stop);

        expect(
          File(
            p.join(tmpRoot.path, '.serverpod', 'postgres.password'),
          ).existsSync(),
          isFalse,
        );
      },
      timeout: const Timeout(Duration(seconds: 120)),
    );
  });

  test(
    'Given a stopped cluster started with one TcpTransport password, '
    'when it is restarted with another password, '
    'then the new password authenticates over TCP',
    () async {
      final pgDataDir = Directory(p.join(tmpRoot.path, '.serverpod', 'pgdata'));
      final first = await EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: pgDataDir,
          databaseName: 'projectname',
          transport: const TcpTransport(password: 'first-password'),
          detach: true,
        ),
      );
      await first.stop();

      final second = await EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: pgDataDir,
          databaseName: 'projectname',
          transport: const TcpTransport(password: 'rotated-password'),
          detach: true,
        ),
      );
      addTearDown(second.stop);

      expect(await selectOne(second.endpoint), 1);
    },
    timeout: const Timeout(Duration(seconds: 180)),
  );
}
