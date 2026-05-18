@Tags(['integration'])
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:test/test.dart';

/// TCP transport end-to-end. Validates ephemeral port allocation,
/// password persistence, and scram-sha-256 auth via package:postgres.
void main() {
  late Directory tmpRoot;

  setUp(() {
    tmpRoot = Directory.systemTemp.createTempSync('embedded_pg_tcp_');
  });

  tearDown(() {
    if (tmpRoot.existsSync()) tmpRoot.deleteSync(recursive: true);
  });

  group('Given TcpTransport with port=0', () {
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
      'when start runs twice in a row '
      'then the persisted password is re-used (so the same Endpoint authenticates against the warm cluster).',
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
          pwFirst,
          reason: 'warm restart must re-use the persisted password',
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
      'when an explicit password is provided via TcpTransport '
      'then it is used (and persisted).',
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
        var pwFile = File(
          p.join(tmpRoot.path, '.serverpod', 'postgres.password'),
        );
        expect(pwFile.existsSync(), isTrue);
        expect(pwFile.readAsStringSync(), explicit);

        await pg_.stop();
      },
      timeout: const Timeout(Duration(seconds: 120)),
    );
  });
}
