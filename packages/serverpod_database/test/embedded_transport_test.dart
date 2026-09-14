import 'package:serverpod_database/embedded.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  PostgresDatabaseConfig config({required String password, int port = 8090}) =>
      PostgresDatabaseConfig(
        host: 'localhost',
        port: port,
        user: 'postgres',
        password: password,
        name: 'projectname',
        dataPath: '.serverpod/pgdata',
      );

  test(
    'Given an embedded database config with an empty password, '
    'when the transport is derived, '
    'then only the Unix socket is served',
    () {
      expect(embeddedTransportFor(config(password: '')), isA<UnixTransport>());
    },
  );

  test(
    'Given an embedded database config with a password and port 8090, '
    'when the transport is derived, '
    'then the Unix socket and scram TCP on port 8090 are served',
    () {
      expect(
        embeddedTransportFor(config(password: 'secret', port: 8090)),
        isA<DualTransport>()
            .having((t) => t.port, 'port', 8090)
            .having((t) => t.password, 'password', 'secret'),
      );
    },
  );
}
