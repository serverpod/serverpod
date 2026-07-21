@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_database/embedded.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';

/// Exercises the PostgreSQL and SQLite test-database lifecycles with real file
/// system and database resources.
void main() {
  group('Given a freshly resolved embedded postmaster', () {
    late Directory tmpRoot;
    late ResolvedEmbeddedPostgres resolved;
    late TestDatabaseManager manager;

    setUp(() async {
      tmpRoot = Directory.systemTemp.createTempSync('sp_test_db_manager_');
      var config = PostgresDatabaseConfig.embedded(
        dataPath: '.serverpod/pgdata',
        name: 'serverpod_test',
      );
      resolved = (await startOrAttachEmbeddedPostgres(
        config,
        baseDirectory: tmpRoot,
      ))!;
      manager = TestDatabaseManager(resolved.connectivity);
    });

    tearDown(() async {
      await resolved.stop?.call();
      if (tmpRoot.existsSync()) tmpRoot.deleteSync(recursive: true);
    });

    Future<pg.Connection> connect(String name) => pg.Connection.open(
      pg.Endpoint(
        host: resolved.connectivity.host,
        port: resolved.connectivity.port,
        database: name,
        username: resolved.connectivity.user,
        password: resolved.connectivity.password,
        isUnixSocket: resolved.connectivity.isUnixSocket,
      ),
      settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
    );

    test(
      'when createEmptyDatabase runs twice '
      'then each database is empty and isolated from the other.',
      () async {
        var dbA = TestDatabaseManager.generateDatabaseName();
        var dbB = TestDatabaseManager.generateDatabaseName();
        await manager.createEmptyDatabase(dbA);
        await manager.createEmptyDatabase(dbB);
        expect(dbA, isNot(dbB));

        // Schema/data created in A must not leak into B.
        var connA = await connect(dbA);
        await connA.execute('CREATE TABLE widget (id integer primary key);');
        await connA.execute('INSERT INTO widget (id) VALUES (1);');
        await connA.close();

        var connB = await connect(dbB);
        await expectLater(
          connB.execute('SELECT id FROM widget;'),
          throwsA(isA<pg.ServerException>()),
          reason: 'database B must not see table created in A',
        );
        await connB.close();

        await manager.dropDatabase(dbA);
        await manager.dropDatabase(dbB);
      },
      timeout: const Timeout(Duration(seconds: 180)),
    );

    test(
      'when a database is dropped then it no longer exists.',
      () async {
        var db = TestDatabaseManager.generateDatabaseName();
        await manager.createEmptyDatabase(db);
        await manager.dropDatabase(db);

        await expectLater(
          connect(db),
          throwsA(isA<pg.ServerException>()),
          reason: 'connecting to a dropped database must fail',
        );
      },
      timeout: const Timeout(Duration(seconds: 180)),
    );
  });

  group('Given a project configured with a file-backed SQLite database,', () {
    late Directory serverDirectory;

    setUp(() async {
      serverDirectory = Directory.systemTemp.createTempSync(
        'sp_test_sqlite_manager_',
      );
      await _writeSqliteConfig(
        serverDirectory,
        filePath: p.join('sqlite_data', 'project.db'),
      );
    });

    tearDown(() {
      if (serverDirectory.existsSync()) {
        serverDirectory.deleteSync(recursive: true);
      }
    });

    test(
      'when one of two ephemeral databases is dropped, '
      'then only its database file and sidecars are removed.',
      () async {
        const firstName = 'sp_test_sqlite_first';
        const secondName = 'sp_test_sqlite_second';
        final first = await EphemeralTestDatabase.create(
          runMode: 'test',
          databaseName: firstName,
          serverDirectory: serverDirectory,
        );
        final second = await EphemeralTestDatabase.create(
          runMode: 'test',
          databaseName: secondName,
          serverDirectory: serverDirectory,
        );
        final firstPaths = _sqliteDatabasePaths(serverDirectory, firstName);
        final secondPaths = _sqliteDatabasePaths(serverDirectory, secondName);

        for (final path in [...firstPaths, ...secondPaths]) {
          File(path).createSync(recursive: true);
        }

        await first!.drop();

        expect(first.name, firstName);
        expect(second!.name, secondName);
        expect(firstPaths.map(File.new), everyElement(isNot(_exists)));
        expect(secondPaths.map(File.new), everyElement(_exists));
      },
    );
  });

  group('Given a project configured with an in-memory SQLite database,', () {
    late Directory serverDirectory;

    setUp(() async {
      serverDirectory = Directory.systemTemp.createTempSync(
        'sp_test_sqlite_manager_',
      );
      await _writeSqliteConfig(serverDirectory, filePath: ':memory:');
    });

    tearDown(() {
      if (serverDirectory.existsSync()) {
        serverDirectory.deleteSync(recursive: true);
      }
    });

    test(
      'when an ephemeral database is requested, '
      'then setup fails because Serverpod requires a file-backed database.',
      () async {
        await expectLater(
          EphemeralTestDatabase.create(
            runMode: 'test',
            databaseName: 'sp_test_sqlite_memory',
            serverDirectory: serverDirectory,
          ),
          throwsA(
            isA<StateError>().having(
              (error) => error.message,
              'message',
              "Serverpod does not support SQLite ':memory:' databases. "
                  'Configure a file-backed SQLite database instead.',
            ),
          ),
        );
      },
    );
  });
}

final _exists = isA<FileSystemEntity>().having(
  (entity) => entity.existsSync(),
  'exists',
  isTrue,
);

Future<void> _writeSqliteConfig(
  Directory serverDirectory, {
  required String filePath,
}) async {
  final configDirectory = Directory(p.join(serverDirectory.path, 'config'));
  await configDirectory.create(recursive: true);
  await File(p.join(configDirectory.path, 'test.yaml')).writeAsString('''
database:
  filePath: ${jsonEncode(filePath)}
''');
}

List<String> _sqliteDatabasePaths(
  Directory serverDirectory,
  String databaseName,
) {
  final databasePath = p.join(
    serverDirectory.path,
    'sqlite_data',
    '$databaseName.db',
  );
  return [
    for (final suffix in const ['', '-wal', '-shm', '-journal'])
      '$databasePath$suffix',
  ];
}
