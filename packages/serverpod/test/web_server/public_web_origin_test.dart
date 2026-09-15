import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  ServerConfig config({
    String scheme = 'https',
    String host = 'example.com',
    int port = 443,
  }) => ServerConfig(
    port: 8080,
    publicScheme: scheme,
    publicHost: host,
    publicPort: port,
  );

  test(
    'Given https on port 443 '
    'when building a public web origin '
    'then the port is omitted.',
    () {
      expect(
        publicWebOrigin(config(), '/auth/google/callback').toString(),
        'https://example.com/auth/google/callback',
      );
    },
  );

  test(
    'Given http on port 80 '
    'when building a public web origin '
    'then the port is omitted.',
    () {
      expect(
        publicWebOrigin(
          config(scheme: 'http', port: 80),
          '/auth/login',
        ).toString(),
        'http://example.com/auth/login',
      );
    },
  );

  test(
    'Given https on a non-default port '
    'when building a public web origin '
    'then the port is included.',
    () {
      expect(
        publicWebOrigin(config(port: 8443), '/account').toString(),
        'https://example.com:8443/account',
      );
    },
  );
}
