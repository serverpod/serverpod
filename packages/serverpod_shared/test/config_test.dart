import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

// These tests uses the yaml package to parse the yaml configuration and then convert
// then to a Map.
// This was to better reflect the actual configuration of the ServerpodConfig.
void main() {
  test(
      'Given Serverpod config missing api server configuration when loading from Map then exception is thrown.',
      () {
    expect(
      () => ServerpodConfig.loadFromMap('', '', {}, {}),
      throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        equals('Exception: apiServer is missing in config'),
      )),
    );
  });

  test(
      'Given Serverpod config with api server configuration missing required port when loading from Map then exception is thrown.',
      () {
    var serverpodConfig = '''
apiServer:
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''';

    expect(
      () => ServerpodConfig.loadFromMap(
        '',
        '',
        {},
        loadYaml(serverpodConfig),
      ),
      throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        equals(
            'Exception: apiServer is missing required configuration for port.'),
      )),
    );
  });

  test(
      'Given Serverpod config with api server with wrong port type when loading from Map then exception is thrown.',
      () {
    var serverpodConfig = '''
apiServer:
  port: '8080'
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''';

    expect(
      () => ServerpodConfig.loadFromMap(
        '',
        '',
        {},
        loadYaml(serverpodConfig),
      ),
      throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        equals(
            'Exception: apiServer configuration has invalid type for port. Expected int, got String.'),
      )),
    );
  });

  group(
      'Given Serverpod config with api server configuration when loading from Map then',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''';

    const runMode = 'myRunMode';
    const serverId = 'myServerId';
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      {'serviceSecret': 'longpasswordthatisrequired'},
      loadYaml(serverpodConfig),
    );

    test('Run mode matches supplied value.', () {
      expect(config.runMode, runMode);
    });

    test('Server id matches supplied value.', () {
      expect(config.serverId, serverId);
    });

    test('Api server configuration is set.', () {
      expect(config.apiServer.port, 8080);
      expect(config.apiServer.publicHost, 'localhost');
      expect(config.apiServer.publicPort, 8080);
      expect(config.apiServer.publicScheme, 'http');
    });

    test('Insights server configuration is null.', () {
      expect(config.insightsServer, isNull);
    });

    test('Web server configuration is null.', () {
      expect(config.webServer, isNull);
    });

    test('Max request size is default value.', () {
      expect(config.maxRequestSize, 524288);
    });

    test('Service secret is set.', () {
      expect(config.serviceSecret, 'longpasswordthatisrequired');
    });

    test('Database configuration is null.', () {
      expect(config.database, isNull);
    });

    test('Redis configuration is null.', () {
      expect(config.redis, isNull);
    });
  });

  test(
      'Given Serverpod config with insights server configuration when loading from Map then insights server configuration is set.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
insightsServer:
  port: 8081
  publicHost: localhost
  publicPort: 8081
  publicScheme: http
''';

    var config = ServerpodConfig.loadFromMap(
      '',
      '',
      {},
      loadYaml(serverpodConfig),
    );

    expect(config.insightsServer?.port, 8081);
    expect(config.insightsServer?.publicHost, 'localhost');
    expect(config.insightsServer?.publicPort, 8081);
    expect(config.insightsServer?.publicScheme, 'http');
  });

  test(
      'Given Serverpod config with web server configuration when loading from Map then web server configuration is set.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
webServer:
  port: 8082
  publicHost: localhost
  publicPort: 8082
  publicScheme: http
''';

    var config = ServerpodConfig.loadFromMap(
      '',
      '',
      {},
      loadYaml(serverpodConfig),
    );

    expect(config.webServer?.port, 8082);
    expect(config.webServer?.publicHost, 'localhost');
    expect(config.webServer?.publicPort, 8082);
    expect(config.webServer?.publicScheme, 'http');
  });

  test(
      'Given Serverpod config with max request size when loading from Map then max request size configuration matches supplied value.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
maxRequestSize: 1048576
''';

    var config = ServerpodConfig.loadFromMap(
      '',
      '',
      {},
      loadYaml(serverpodConfig),
    );

    expect(config.maxRequestSize, 1048576);
  });

  test(
      'Given Serverpod config with database configuration without password when loading from Map then exception is thrown.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
database:
  host: localhost
  port: 5432
  name: testDb
  user: test
''';

    expect(
      () => ServerpodConfig.loadFromMap(
        '',
        '',
        {},
        loadYaml(serverpodConfig),
      ),
      throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        equals('Exception: Missing database password.'),
      )),
    );
  });

  test(
      'Given Serverpod config with database configuration missing required field when loading from Map then exception is thrown.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
database:
  host: localhost
  name: testDb
  user: test
''';

    expect(
      () => ServerpodConfig.loadFromMap(
        '',
        '',
        {'database': 'password'},
        loadYaml(serverpodConfig),
      ),
      throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        equals(
            'Exception: database is missing required configuration for port.'),
      )),
    );
  });

  test(
      'Given Serverpod config with database configuration when loading from Map then database configuration is set.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
database:
  host: localhost
  port: 5432
  name: testDb
  user: test
''';

    var config = ServerpodConfig.loadFromMap(
      '',
      '',
      {'database': 'password'},
      loadYaml(serverpodConfig),
    );

    expect(config.database?.host, 'localhost');
    expect(config.database?.port, 5432);
    expect(config.database?.name, 'testDb');
    expect(config.database?.user, 'test');
    expect(config.database?.password, 'password');
    expect(config.database?.requireSsl, isFalse);
    expect(config.database?.isUnixSocket, isFalse);
  });

  test(
      'Given Serverpod config with redis configuration missing required field when loading from Map then exception is thrown.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
redis:
  port: 6379
''';

    expect(
      () => ServerpodConfig.loadFromMap(
        '',
        '',
        {},
        loadYaml(serverpodConfig),
      ),
      throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        equals('Exception: redis is missing required configuration for host.'),
      )),
    );
  });

  test(
      'Given Serverpod config with redis configuration without when loading from Map then redis configuration is set.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
redis:
  host: localhost
  port: 6379
''';

    var config = ServerpodConfig.loadFromMap(
      '',
      '',
      {'redis': 'password'},
      loadYaml(serverpodConfig),
    );

    expect(config.redis?.host, 'localhost');
    expect(config.redis?.port, 6379);
    expect(config.redis?.password, 'password');
    expect(config.redis?.enabled, isFalse);
  });
}
