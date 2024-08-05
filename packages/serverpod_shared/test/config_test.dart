import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

// These tests uses the yaml package to parse the yaml configuration and then convert
// then to a Map.
// This was to better reflect the actual configuration of the ServerpodConfig.
void main() {
  var runMode = 'development';
  var serverId = 'default';
  var passwords = {'serviceSecret': 'longpasswordthatisrequired'};

  test(
      'Given a Serverpod config missing api server configuration when loading from Map then exception is thrown.',
      () {
    expect(
      () => ServerpodConfig.loadFromMap(runMode, serverId, passwords, {}),
      throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        equals('Serverpod API server configuration is missing.'),
      )),
    );
  });

  test(
      'Given a Serverpod config with api server configuration missing required port when loading from Map then exception is thrown.',
      () {
    var serverpodConfig = '''
apiServer:
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''';

    expect(
      () => ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
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
      'Given a Serverpod config with api server with wrong port type when loading from Map then exception is thrown.',
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
        runMode,
        serverId,
        passwords,
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
      'Given a Serverpod config with api server configuration when loading from Map then',
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
    const passwords = {'serviceSecret': 'LONG_PASSWORD_THAT_IS_REQUIRED'};

    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      loadYaml(serverpodConfig),
    );

    test('Run mode matches supplied value.', () {
      expect(config.runMode, 'myRunMode');
    });

    test('Server id matches supplied value.', () {
      expect(config.serverId, 'myServerId');
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
      expect(config.serviceSecret, 'LONG_PASSWORD_THAT_IS_REQUIRED');
    });

    test('Database configuration is null.', () {
      expect(config.database, isNull);
    });

    test('Redis configuration is null.', () {
      expect(config.redis, isNull);
    });
  });

  test(
      'Given a Serverpod config with insights server configuration when loading from Map then insights server configuration is set.',
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
      runMode,
      serverId,
      passwords,
      loadYaml(serverpodConfig),
    );

    expect(config.insightsServer?.port, 8081);
    expect(config.insightsServer?.publicHost, 'localhost');
    expect(config.insightsServer?.publicPort, 8081);
    expect(config.insightsServer?.publicScheme, 'http');
  });

  test(
      'Given a Serverpod config with web server configuration when loading from Map then web server configuration is set.',
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
      runMode,
      serverId,
      passwords,
      loadYaml(serverpodConfig),
    );

    expect(config.webServer?.port, 8082);
    expect(config.webServer?.publicHost, 'localhost');
    expect(config.webServer?.publicPort, 8082);
    expect(config.webServer?.publicScheme, 'http');
  });

  test(
      'Given a Serverpod config with max request size when loading from Map then max request size configuration matches supplied value.',
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
      runMode,
      serverId,
      passwords,
      loadYaml(serverpodConfig),
    );

    expect(config.maxRequestSize, 1048576);
  });

  test(
      'Given a Serverpod config with database configuration without password when loading from Map then exception is thrown.',
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
        runMode,
        serverId,
        passwords,
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
      'Given a Serverpod config with database configuration missing required field when loading from Map then exception is thrown.',
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
        runMode,
        serverId,
        {...passwords, 'database': 'password'},
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
      'Given a Serverpod config with database configuration when loading from Map then database configuration is set.',
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
      runMode,
      serverId,
      {...passwords, 'database': 'password'},
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
      'Given a Serverpod config with redis configuration missing required field when loading from Map then exception is thrown.',
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
        serverId,
        runMode,
        passwords,
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
      'Given a Serverpod config with redis configuration when loading from Map then redis configuration is set.',
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
      runMode,
      serverId,
      {...passwords, 'redis': 'password'},
      loadYaml(serverpodConfig),
    );

    expect(config.redis?.host, 'localhost');
    expect(config.redis?.port, 6379);
    expect(config.redis?.password, 'password');
    expect(config.redis?.enabled, isFalse);
  });

  test(
      'Given an empty Serverpod config map but with the environment variables set for the api server when loading from Map then the configuration is created.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      {},
      environment: {
        'SERVERPOD_API_SERVER_PORT': '8080',
        'SERVERPOD_API_SERVER_PUBLIC_HOST': 'localhost',
        'SERVERPOD_API_SERVER_PUBLIC_PORT': '8080',
        'SERVERPOD_API_SERVER_PUBLIC_SCHEME': 'http',
      },
    );

    expect(config.apiServer.port, 8080);
    expect(config.apiServer.publicHost, 'localhost');
    expect(config.apiServer.publicPort, 8080);
    expect(config.apiServer.publicScheme, 'http');
  });

  test(
      'Given a Serverpod config map that is empty but the environment variables are set to the wrong type for the api server when loading from Map then an exception is thrown.',
      () {
    expect(
      () => ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        {},
        environment: {
          'SERVERPOD_API_SERVER_PORT': 'invalid',
          'SERVERPOD_API_SERVER_PUBLIC_HOST': 'localhost',
          'SERVERPOD_API_SERVER_PUBLIC_PORT': '8080',
          'SERVERPOD_API_SERVER_PUBLIC_SCHEME': 'http',
        },
      ),
      throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        equals(
            'Exception: Invalid value (invalid) for SERVERPOD_API_SERVER_PORT.'),
      )),
    );
  });

  test(
      'Given a Serverpod config map with half the values and the environment variables the other half for the api server when loading from Map then configuration then the config is created.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      {
        'apiServer': {
          'publicPort': 8080,
          'publicScheme': 'http',
        },
      },
      environment: {
        'SERVERPOD_API_SERVER_PORT': '8080',
        'SERVERPOD_API_SERVER_PUBLIC_HOST': 'localhost',
      },
    );

    expect(config.apiServer.port, 8080);
    expect(config.apiServer.publicHost, 'localhost');
    expect(config.apiServer.publicPort, 8080);
    expect(config.apiServer.publicScheme, 'http');
  });

  test(
      'Given a Serverpod config map with all the values and the environment variables for the api server when loading from Map then the config is overridden by the environment variables.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
      },
      environment: {
        'SERVERPOD_API_SERVER_PORT': '8090',
        'SERVERPOD_API_SERVER_PUBLIC_HOST': 'example.com',
        'SERVERPOD_API_SERVER_PUBLIC_PORT': '8090',
        'SERVERPOD_API_SERVER_PUBLIC_SCHEME': 'https',
      },
    );

    expect(config.apiServer.port, 8090);
    expect(config.apiServer.publicHost, 'example.com');
    expect(config.apiServer.publicPort, 8090);
    expect(config.apiServer.publicScheme, 'https');
  });

  test(
      'Given a Serverpod config with only the api server configuration but the environment variables containing the max request size when loading from Map then the max request size is set.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
      },
      environment: {
        'SERVERPOD_MAX_REQUEST_SIZE': '1048576',
      },
    );

    expect(config.maxRequestSize, 1048576);
  });

  test(
      'Given a Serverpod config with only the api server configuration but the environment variables containing the config for the web server when loading from Map then the web server config is created.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
      },
      environment: {
        'SERVERPOD_WEB_SERVER_PORT': '8081',
        'SERVERPOD_WEB_SERVER_PUBLIC_HOST': 'localhost',
        'SERVERPOD_WEB_SERVER_PUBLIC_PORT': '8081',
        'SERVERPOD_WEB_SERVER_PUBLIC_SCHEME': 'http',
      },
    );

    expect(config.webServer?.port, 8081);
    expect(config.webServer?.publicHost, 'localhost');
    expect(config.webServer?.publicPort, 8081);
    expect(config.webServer?.publicScheme, 'http');
  });

  test(
      'Given a Serverpod config map with half the values and the environment variables the other half for the web server when loading from Map then configuration then the web config is created',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
        'webServer': {
          'publicPort': 8081,
          'publicScheme': 'http',
        },
      },
      environment: {
        'SERVERPOD_WEB_SERVER_PORT': '8081',
        'SERVERPOD_WEB_SERVER_PUBLIC_HOST': 'localhost',
      },
    );

    expect(config.webServer?.port, 8081);
    expect(config.webServer?.publicHost, 'localhost');
    expect(config.webServer?.publicPort, 8081);
    expect(config.webServer?.publicScheme, 'http');
  });

  test(
      'Given a Serverpod config map with all the values and the environment variables for the api server when loading from Map then the config is overridden by the environment variables.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
        'webServer': {
          'port': 8081,
          'publicHost': 'localhost',
          'publicPort': 8081,
          'publicScheme': 'http',
        },
      },
      environment: {
        'SERVERPOD_WEB_SERVER_PORT': '8090',
        'SERVERPOD_WEB_SERVER_PUBLIC_HOST': 'example.com',
        'SERVERPOD_WEB_SERVER_PUBLIC_PORT': '8090',
        'SERVERPOD_WEB_SERVER_PUBLIC_SCHEME': 'https',
      },
    );

    expect(config.webServer?.port, 8090);
    expect(config.webServer?.publicHost, 'example.com');
    expect(config.webServer?.publicPort, 8090);
    expect(config.webServer?.publicScheme, 'https');
  });

  test(
      'Given a Serverpod config with only the api server configuration but the environment variables containing the config for the insights server when loading from Map then the insights server config is created.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
      },
      environment: {
        'SERVERPOD_INSIGHTS_SERVER_PORT': '8081',
        'SERVERPOD_INSIGHTS_SERVER_PUBLIC_HOST': 'localhost',
        'SERVERPOD_INSIGHTS_SERVER_PUBLIC_PORT': '8081',
        'SERVERPOD_INSIGHTS_SERVER_PUBLIC_SCHEME': 'http',
      },
    );

    expect(config.insightsServer?.port, 8081);
    expect(config.insightsServer?.publicHost, 'localhost');
    expect(config.insightsServer?.publicPort, 8081);
    expect(config.insightsServer?.publicScheme, 'http');
  });

  test(
      'Given a Serverpod config map with half the values and the environment variables the other half for the insights server when loading from Map then configuration then the insights config is created',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
        'insightsServer': {
          'publicPort': 8081,
          'publicScheme': 'http',
        },
      },
      environment: {
        'SERVERPOD_INSIGHTS_SERVER_PORT': '8081',
        'SERVERPOD_INSIGHTS_SERVER_PUBLIC_HOST': 'localhost',
      },
    );

    expect(config.insightsServer?.port, 8081);
    expect(config.insightsServer?.publicHost, 'localhost');
    expect(config.insightsServer?.publicPort, 8081);
    expect(config.insightsServer?.publicScheme, 'http');
  });

  test(
      'Given a Serverpod config map with all the values and the environment variables for the insights server when loading from Map then the config is overridden by the environment variables.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
        'insightsServer': {
          'port': 8081,
          'publicHost': 'localhost',
          'publicPort': 8081,
          'publicScheme': 'http',
        },
      },
      environment: {
        'SERVERPOD_INSIGHTS_SERVER_PORT': '8090',
        'SERVERPOD_INSIGHTS_SERVER_PUBLIC_HOST': 'example.com',
        'SERVERPOD_INSIGHTS_SERVER_PUBLIC_PORT': '8090',
        'SERVERPOD_INSIGHTS_SERVER_PUBLIC_SCHEME': 'https',
      },
    );

    expect(config.insightsServer?.port, 8090);
    expect(config.insightsServer?.publicHost, 'example.com');
    expect(config.insightsServer?.publicPort, 8090);
    expect(config.insightsServer?.publicScheme, 'https');
  });

  test(
      'Given a Serverpod config with only the api server configuration but the environment variables containing the config for the database when loading from Map then the database config is created.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      {...passwords, 'database': 'password'},
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
      },
      environment: {
        'SERVERPOD_DATABASE_HOST': 'localhost',
        'SERVERPOD_DATABASE_PORT': '5432',
        'SERVERPOD_DATABASE_NAME': 'serverpod',
        'SERVERPOD_DATABASE_USER': 'admin',
      },
    );

    expect(config.database?.host, 'localhost');
    expect(config.database?.port, 5432);
    expect(config.database?.name, 'serverpod');
    expect(config.database?.user, 'admin');
  });

  test(
      'Given a Serverpod config map with half the values and the environment variables the other half for the database when loading from Map then configuration then the database config is created',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      {...passwords, 'database': 'password'},
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
        'database': {
          'port': 5432,
          'name': 'serverpod',
        },
      },
      environment: {
        'SERVERPOD_DATABASE_HOST': 'localhost',
        'SERVERPOD_DATABASE_USER': 'admin',
      },
    );

    expect(config.database?.host, 'localhost');
    expect(config.database?.port, 5432);
    expect(config.database?.name, 'serverpod');
    expect(config.database?.user, 'admin');
  });

  test(
      'Given a Serverpod config map with all the values and the environment variables for the database when loading from Map then the config is overridden by the environment variables.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      {...passwords, 'database': 'password'},
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
        'database': {
          'host': 'localhost',
          'port': 5432,
          'name': 'serverpod',
          'user': 'admin',
        },
      },
      environment: {
        'SERVERPOD_DATABASE_HOST': 'remotehost',
        'SERVERPOD_DATABASE_PORT': '5433',
        'SERVERPOD_DATABASE_NAME': 'remote_serverpod',
        'SERVERPOD_DATABASE_USER': 'remote_admin',
      },
    );

    expect(config.database?.host, 'remotehost');
    expect(config.database?.port, 5433);
    expect(config.database?.name, 'remote_serverpod');
    expect(config.database?.user, 'remote_admin');
  });

  test(
      'Given a Serverpod config with only the api server configuration but the environment variables containing the optional database variable require ssl then the database config takes the value from the env.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      {...passwords, 'database': 'password'},
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
      },
      environment: {
        'SERVERPOD_DATABASE_HOST': 'localhost',
        'SERVERPOD_DATABASE_PORT': '5432',
        'SERVERPOD_DATABASE_NAME': 'serverpod',
        'SERVERPOD_DATABASE_USER': 'admin',
        'SERVERPOD_DATABASE_REQUIRE_SSL': 'true',
      },
    );

    expect(config.database?.requireSsl, true);
  });

  test(
      'Given a Serverpod config with only the api server configuration but the environment variables containing the optional database variable require ssl set to an invalid value then an exception is thrown.',
      () {
    expect(
      () => ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        {...passwords, 'database': 'password'},
        {
          'apiServer': {
            'port': 8080,
            'publicHost': 'localhost',
            'publicPort': 8080,
            'publicScheme': 'http',
          },
        },
        environment: {
          'SERVERPOD_DATABASE_HOST': 'localhost',
          'SERVERPOD_DATABASE_PORT': '5432',
          'SERVERPOD_DATABASE_NAME': 'serverpod',
          'SERVERPOD_DATABASE_USER': 'admin',
          'SERVERPOD_DATABASE_REQUIRE_SSL': 'INVALID',
        },
      ),
      throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        equals(
            'Exception: Invalid value (INVALID) for SERVERPOD_DATABASE_REQUIRE_SSL.'),
      )),
    );
  });

  test(
      'Given a Serverpod config with only the api server configuration but the environment variables containing the optional database variable isUnixSocket then the database config takes the value from the env.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      {...passwords, 'database': 'password'},
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
      },
      environment: {
        'SERVERPOD_DATABASE_HOST': 'localhost',
        'SERVERPOD_DATABASE_PORT': '5432',
        'SERVERPOD_DATABASE_NAME': 'serverpod',
        'SERVERPOD_DATABASE_USER': 'admin',
        'SERVERPOD_DATABASE_IS_UNIX_SOCKET': 'true',
      },
    );

    expect(config.database?.isUnixSocket, true);
  });

  test(
      'Given a Serverpod config with only the api server configuration but the environment variables containing the config for the redis when loading from Map then the redis config is created.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      {...passwords, 'redis': 'password'},
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
      },
      environment: {
        'SERVERPOD_REDIS_HOST': 'localhost',
        'SERVERPOD_REDIS_PORT': '6379',
        'SERVERPOD_REDIS_USER': 'default',
      },
    );

    expect(config.redis?.host, 'localhost');
    expect(config.redis?.port, 6379);
    expect(config.redis?.user, 'default');
  });

  test(
      'Given a Serverpod config map with half the values and the environment variables the other half for the redis when loading from Map then configuration then the redis config is created',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      {...passwords, 'redis': 'password'},
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
        'redis': {
          'port': 6379,
        },
      },
      environment: {
        'SERVERPOD_REDIS_HOST': 'localhost',
        'SERVERPOD_REDIS_USER': 'default',
      },
    );

    expect(config.redis?.host, 'localhost');
    expect(config.redis?.port, 6379);
    expect(config.redis?.user, 'default');
  });

  test(
      'Given a Serverpod config map with all the values and the environment variables for the redis when loading from Map then the config is overridden by the environment variables.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      {...passwords, 'redis': 'password'},
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
        'redis': {
          'host': 'localhost',
          'port': 6379,
          'user': 'default',
        },
      },
      environment: {
        'SERVERPOD_REDIS_HOST': 'remotehost',
        'SERVERPOD_REDIS_PORT': '6380',
        'SERVERPOD_REDIS_USER': 'remote_user',
      },
    );

    expect(config.redis?.host, 'remotehost');
    expect(config.redis?.port, 6380);
    expect(config.redis?.user, 'remote_user');
  });

  test(
      'Given a Serverpod config with the redis enabled environment variable set when loading from Map then the redis configuration is enabled.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      {...passwords, 'redis': 'password'},
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
        'redis': {
          'host': 'localhost',
          'port': 6379,
          'user': 'default',
        },
      },
      environment: {
        'SERVERPOD_REDIS_ENABLED': 'true',
      },
    );

    expect(config.redis?.enabled, isTrue);
  });
}
