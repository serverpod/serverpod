import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_embedded_postgres/serverpod_config_mapping.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  group('Given a UDS endpoint', () {
    final endpoint = pg.Endpoint(
      host: '/tmp/serverpod/run/.s.PGSQL.5432',
      isUnixSocket: true,
      database: 'unused',
      username: 'postgres',
    );

    test(
      'when mapped to DatabaseConfig then source is embedded and the '
      'is_unix_socket flag round-trips.',
      () {
        var config = databaseConfigForEmbeddedPostgres(
          endpoint: endpoint,
          databaseName: 'projectname',
          username: 'fallback',
        );

        expect(config.host, '/tmp/serverpod/run/.s.PGSQL.5432');
        expect(config.isUnixSocket, isTrue);
        expect(config.user, 'postgres'); // endpoint.username wins.
        expect(config.name, 'projectname');
        expect(config.source, DatabaseSource.embedded);
        expect(config.password, '');
      },
    );

    test(
      'when mapped to env overlay then the SERVERPOD_DATABASE_* variables '
      'are filled in and source is embedded.',
      () {
        var env = envOverlayForEmbeddedPostgres(
          endpoint: endpoint,
          databaseName: 'projectname',
          username: 'fallback',
        );

        expect(
          env[ServerpodEnv.databaseHost.envVariable],
          '/tmp/serverpod/run/.s.PGSQL.5432',
        );
        expect(env[ServerpodEnv.databaseIsUnixSocket.envVariable], 'true');
        expect(env[ServerpodEnv.databaseSource.envVariable], 'embedded');
        expect(env[ServerpodEnv.databaseName.envVariable], 'projectname');
        expect(env[ServerpodEnv.databaseUser.envVariable], 'postgres');
        expect(env[ServerpodPassword.databasePassword.envVariable], '');
      },
    );
  });

  group('Given a TCP endpoint with password', () {
    final endpoint = pg.Endpoint(
      host: '127.0.0.1',
      port: 49152,
      database: 'unused',
      username: 'postgres',
      password: 'sup3r-s3cret',
    );

    test(
      'when mapped to env overlay then password and port are forwarded.',
      () {
        var env = envOverlayForEmbeddedPostgres(
          endpoint: endpoint,
          databaseName: 'projectname',
          username: 'fallback',
        );

        expect(env[ServerpodEnv.databasePort.envVariable], '49152');
        expect(
          env[ServerpodPassword.databasePassword.envVariable],
          'sup3r-s3cret',
        );
        expect(env[ServerpodEnv.databaseIsUnixSocket.envVariable], 'false');
      },
    );

    test(
      'when endpoint.username is null then DatabaseConfig falls back to the '
      'caller-supplied username.',
      () {
        var bare = pg.Endpoint(
          host: '127.0.0.1',
          port: 49152,
          database: 'unused',
        );

        var config = databaseConfigForEmbeddedPostgres(
          endpoint: bare,
          databaseName: 'projectname',
          username: 'fallback',
        );

        expect(config.user, 'fallback');
      },
    );
  });
}
