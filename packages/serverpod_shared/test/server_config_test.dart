import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  group('Given a server config with an ephemeral bind port,', () {
    test(
      'when the public port is zero as well, '
      'then both follow the port the server bound',
      () {
        final config = ServerConfig(
          port: 0,
          publicScheme: 'http',
          publicHost: 'localhost',
          publicPort: 0,
        ).withResolvedPort(54321);

        expect(config.port, 54321);
        expect(config.publicPort, 54321);
      },
    );

    test(
      'when the public port is configured, '
      'then it stays, since a proxy advertises a port the server does not bind',
      () {
        final config = ServerConfig(
          port: 0,
          publicScheme: 'https',
          publicHost: 'api.example.com',
          publicPort: 443,
        ).withResolvedPort(54321);

        expect(config.port, 54321);
        expect(config.publicPort, 443);
      },
    );
  });
}
