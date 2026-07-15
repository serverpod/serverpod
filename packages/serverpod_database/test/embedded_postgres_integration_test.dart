@Tags(['integration'])
library;

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
    'Given a server config with a password from passwords.yaml and an embedded PostgreSQL cluster created by the database pool manager,',
    () {
      const databasePassword = 'passwords-yaml-database-password';
      late Directory serverDir;
      late PostgresDatabaseConfig databaseConfig;
      DatabasePoolManager? poolManager;
      EmbeddedPostgres? embeddedPostgres;
      pg.Connection? connection;

      setUp(() async {
        serverDir = Directory.systemTemp.createTempSync(
          'serverpod_database_embedded_postgres_',
        );
        var configDir = Directory(p.join(serverDir.path, 'config'))
          ..createSync();
        File(p.join(configDir.path, 'development.yaml')).writeAsStringSync('''
database:
  host: localhost
  port: 5432
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
              databaseConfig,
              serverDirectory: serverDir,
            );

        await poolManager!.started;
        await poolManager!.stop();
        poolManager = null;
      });

      tearDown(() async {
        await connection?.close();
        await embeddedPostgres?.stop();
        await poolManager?.stop();
        if (serverDir.existsSync()) {
          serverDir.deleteSync(recursive: true);
        }
      });

      test(
        'when the cluster is reopened over TCP, '
        'then the configured password authenticates.',
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
          expect(embeddedPostgres!.endpoint.password, databasePassword);

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

  group(
    'Given an embedded PostgreSQL config with an empty password,',
    () {
      late Directory serverDir;
      late PostgresDatabaseConfig databaseConfig;
      ResolvedEmbeddedPostgres? resolvedPostgres;
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

      tearDown(() async {
        await connection?.close();
        await embeddedPostgres?.stop();
        await resolvedPostgres?.stop?.call();
        if (serverDir.existsSync()) {
          serverDir.deleteSync(recursive: true);
        }
      });

      test(
        'when the cluster is reopened over TCP, '
        'then a generated non-empty password authenticates.',
        () async {
          resolvedPostgres = await startOrAttachEmbeddedPostgres(
            databaseConfig,
            baseDirectory: serverDir,
          );
          await resolvedPostgres!.stop?.call();
          resolvedPostgres = null;

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
}

class _TestSerializationManager extends DatabaseSerializationManager {
  @override
  String getModuleName() => 'test';

  @override
  Table? getTableForType(Type t) => null;

  @override
  List<TableDefinition> getTargetTableDefinitions() => const [];
}
