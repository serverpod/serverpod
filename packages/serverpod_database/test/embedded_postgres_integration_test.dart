@Tags(['integration'])
library;

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_database/embedded.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Given a server config with a passwords.yaml password and a free port,',
    () {
      const databasePassword = 'passwords-yaml-database-password';
      late Directory serverDir;
      late int databasePort;
      late PostgresDatabaseConfig databaseConfig;
      DatabasePoolManager? poolManager;
      pg.Connection? connection;

      setUp(() async {
        serverDir = Directory.systemTemp.createTempSync(
          'serverpod_database_embedded_postgres_',
        );
        var portReservation = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        databasePort = portReservation.port;
        await portReservation.close();
        var configDir = Directory(p.join(serverDir.path, 'config'))
          ..createSync();
        File(p.join(configDir.path, 'development.yaml')).writeAsStringSync('''
database:
  host: localhost
  port: $databasePort
  name: serverpod_test
  user: postgres
  dataPath: .serverpod/pgdata
''');
        File(p.join(configDir.path, 'passwords.yaml')).writeAsStringSync('''
development:
  database: $databasePassword
''');

        var passwords = PasswordManager(
          runMode: 'development',
        ).loadPasswords(serverDir: serverDir.path);
        var config = ServerpodConfig.load(
          'development',
          null,
          passwords,
          serverDir: serverDir.path,
        );
        databaseConfig = config.database! as PostgresDatabaseConfig;
        poolManager =
            DatabaseProvider.forDialect(
              databaseConfig.dialect,
            ).createPoolManager(
              _TestSerializationManager(),
              null,
              databaseConfig.withResolvedLocalPath(serverDir.path),
            );
      });

      tearDown(() async {
        await connection?.close();
        await poolManager?.stop();
        if (serverDir.existsSync()) {
          serverDir.deleteSync(recursive: true);
        }
      });

      test(
        'when the database pool manager starts the embedded database, '
        'then the configured password authenticates over TCP on that port',
        () async {
          poolManager!.start();
          await poolManager!.started;

          connection = await pg.Connection.open(
            pg.Endpoint(
              host: '127.0.0.1',
              port: databasePort,
              database: databaseConfig.name,
              username: databaseConfig.user,
              password: databasePassword,
            ),
            settings: const pg.ConnectionSettings(
              sslMode: pg.SslMode.disable,
            ),
          );
          var result = await connection!.execute('SELECT 1');
          expect(result.first.first, 1);
        },
        timeout: const Timeout(Duration(seconds: 180)),
      );

      test(
        'when the database pool manager starts the embedded database, '
        'then its connection test passes',
        () async {
          poolManager!.start();
          await poolManager!.started;

          expect(await poolManager!.testConnection(), isTrue);
        },
        timeout: const Timeout(Duration(seconds: 180)),
      );

      group(
        'when the pool manager starts the database and it is resolved again,',
        () {
          late ResolvedEmbeddedPostgres resolved;

          setUp(() async {
            poolManager!.start();
            await poolManager!.started;
            resolved = (await startOrAttachEmbeddedPostgres(
              databaseConfig.withResolvedLocalPath(serverDir.path),
            ))!;
          });

          test(
            'then it is attached rather than launched',
            () {
              expect(resolved.launched, isFalse);
            },
            timeout: const Timeout(Duration(seconds: 180)),
          );

          test(
            'then its connectivity is the Unix socket',
            () {
              expect(resolved.connectivity.isUnixSocket, isTrue);
            },
            timeout: const Timeout(Duration(seconds: 180)),
          );
        },
      );
    },
  );

  group(
    'Given a cluster Serverpod started for a config with an empty password,',
    () {
      late Directory serverDir;
      late PostgresDatabaseConfig databaseConfig;
      EmbeddedPostgres? embeddedPostgres;
      pg.Connection? connection;

      setUp(() {
        serverDir = Directory.systemTemp.createTempSync(
          'serverpod_database_empty_password_',
        );
        databaseConfig = PostgresDatabaseConfig.embedded(
          dataPath: '.serverpod/pgdata',
          name: 'serverpod_test',
        );
      });

      setUp(() async {
        final resolved = await startOrAttachEmbeddedPostgres(
          databaseConfig.withResolvedLocalPath(serverDir.path),
        );
        await resolved!.stop?.call();
      });

      tearDown(() async {
        await connection?.close();
        await embeddedPostgres?.stop();
        if (serverDir.existsSync()) {
          serverDir.deleteSync(recursive: true);
        }
      });

      test(
        'when it is started over TCP without a password, '
        'then a generated non-empty password authenticates',
        () async {
          embeddedPostgres = await EmbeddedPostgres.start(
            EmbeddedPostgresOptions(
              dataDir: Directory(
                p.join(serverDir.path, databaseConfig.dataPath!),
              ),
              databaseName: databaseConfig.name,
              username: databaseConfig.user,
              transport: const TcpTransport(),
              detach: true,
            ),
          );
          expect(embeddedPostgres!.endpoint.password, isNotEmpty);

          connection = await pg.Connection.open(
            embeddedPostgres!.endpoint,
            settings: const pg.ConnectionSettings(
              sslMode: pg.SslMode.disable,
            ),
          );
          var result = await connection!.execute('SELECT 1');
          expect(result.first.first, 1);
        },
        timeout: const Timeout(Duration(seconds: 180)),
      );
    },
  );

  test(
    'Given an embedded PostgreSQL config whose port another process holds, '
    'when the database pool manager starts the embedded database, '
    'then it warns that the database listens on another TCP port',
    () async {
      final serverDir = Directory.systemTemp.createTempSync(
        'serverpod_database_held_port_',
      );
      addTearDown(() => serverDir.deleteSync(recursive: true));
      final dataDir = Directory(p.join(serverDir.path, '.serverpod', 'pgdata'));
      final holder = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(holder.close);
      final poolManager = DatabaseProvider.forDialect(DatabaseDialect.postgres)
          .createPoolManager(
            _TestSerializationManager(),
            null,
            PostgresDatabaseConfig(
              host: 'localhost',
              port: holder.port,
              user: 'postgres',
              password: 'held-port-password',
              name: 'serverpod_test',
              dataPath: dataDir.path,
            ),
          );
      addTearDown(poolManager.stop);

      await poolManager.started;

      final running = await EmbeddedPostgres.attach(
        dataDir,
        password: 'held-port-password',
      );
      final listeningPort = running.tcpEndpoint!.port;
      expect(
        embeddedPostgresPortFallbackWarning(poolManager),
        'Port ${holder.port} is held by another process, so the embedded '
        'database listens on TCP port $listeningPort instead. Tools set up '
        'for port ${holder.port} reach that other process. Stop it or change '
        'the database port in the config.',
      );
    },
    timeout: const Timeout(Duration(seconds: 180)),
  );

  group('Given an embedded database pool with a query still running,', () {
    late DatabasePoolManager poolManager;
    late Future<void> query;

    setUp(() async {
      // The Unix socket path must fit in 104 bytes, which macOS's temp does not.
      final serverDir = Directory(
        Platform.isWindows ? Directory.systemTemp.path : '/tmp',
      ).createTempSync('sp_busy_pool_');
      addTearDown(() => serverDir.deleteSync(recursive: true));
      poolManager = DatabaseProvider.forDialect(DatabaseDialect.postgres)
          .createPoolManager(
            _TestSerializationManager(),
            null,
            PostgresDatabaseConfig.embedded(
              dataPath: p.join(serverDir.path, '.serverpod', 'pgdata'),
              name: 'serverpod_test',
              maxConnectionCount: 2,
            ),
          );
      await poolManager.started;
      late Database database;
      database = DatabaseConstructor.create(
        session: _TestSession(() => database),
        poolManager: poolManager,
      );
      query = database.unsafeExecute('SELECT pg_sleep(10)');
      unawaited(query.then((_) {}, onError: (_) {}));
      while ((await database.unsafeQuery(
        "SELECT 1 FROM pg_stat_activity WHERE query = 'SELECT pg_sleep(10)'",
      )).isEmpty) {}
    });

    test(
      'when the pool is stopped, '
      'then the query completes',
      () async {
        final stopping = poolManager.stop();
        addTearDown(() => stopping);

        await expectLater(query, completes);
      },
      timeout: const Timeout(Duration(seconds: 180)),
    );

    test(
      'when the pool is force-stopped, '
      'then the stop completes before the query would have',
      () async {
        final stopping = forceStopDatabasePool(poolManager);
        addTearDown(() => stopping);

        await expectLater(
          stopping.timeout(const Duration(seconds: 5)),
          completes,
        );
      },
      timeout: const Timeout(Duration(seconds: 180)),
    );
  });
}

class _TestSerializationManager extends DatabaseSerializationManager {
  @override
  String getModuleName() => 'test';

  @override
  Table? getTableForType(Type t) => null;

  @override
  List<TableDefinition> getTargetTableDefinitions() => const [];
}

class _TestSession implements DatabaseSession {
  _TestSession(this._database);

  final Database Function() _database;

  @override
  Database get db => _database();

  @override
  Transaction? get transaction => null;

  @override
  LogQueryFunction? get logQuery => null;

  @override
  LogWarningFunction? get logWarning => null;
}
