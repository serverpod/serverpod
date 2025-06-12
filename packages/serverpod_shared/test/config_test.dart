import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

// These tests uses the yaml package to parse the yaml configuration and then convert
// then to a Map.
// This was to better reflect the actual configuration of the ServerpodConfig.
void main() {
  var runMode = 'development';
  // Setting the serverId to null as the default value.
  // ignore: avoid_init_to_null
  var serverId = null;
  var passwords = {'serviceSecret': 'longpasswordthatisrequired'};

  test(
      'Given a Serverpod config missing api server configuration when loading from Map then default api server configuration is used.',
      () {
    var config = ServerpodConfig.loadFromMap(runMode, serverId, passwords, {});
    expect(config, isA<ServerpodConfig>());
    expect(config.apiServer.port, 8080);
    expect(config.apiServer.publicHost, 'localhost');
    expect(config.apiServer.publicPort, 8080);
    expect(config.apiServer.publicScheme, 'http');
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
        runMode,
        serverId,
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
  requireSsl: true
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
    expect(config.redis?.requireSsl, isTrue);
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
    expect(config.redis?.requireSsl, false);
  });

  test(
      'Given a Serverpod config with only the api server configuration but the environment variables containing the config for the redis with a required tls connection when loading from Map then the redis config is created.',
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
        'SERVERPOD_REDIS_REQUIRE_SSL': 'true',
      },
    );

    expect(config.redis?.host, 'localhost');
    expect(config.redis?.port, 6379);
    expect(config.redis?.user, 'default');
    expect(config.redis?.requireSsl, true);
  });
  test(
      'Given a Serverpod config with only the api server configuration but the environment variables containing the config for the redis with a invalid value for require ssl when loading from Map then an exception is thrown',
      () {
    expect(
        () => ServerpodConfig.loadFromMap(
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
                'SERVERPOD_REDIS_REQUIRE_SSL': 'INVALID',
              },
            ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          equals(
              'Exception: Invalid value (INVALID) for SERVERPOD_REDIS_REQUIRE_SSL.'),
        )));
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
    expect(config.redis?.requireSsl, false);
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

  test(
      'Given a Serverpod config with server id when loading from Map then serverId configuration matches supplied value.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
serverId: testServer1
''';

    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      loadYaml(serverpodConfig),
    );

    expect(config.serverId, 'testServer1');
  });

  test(
      'Given a Serverpod config with only the api server configuration but the environment variables containing the server id when loading from Map then the server id matches supplied value.',
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
        'SERVERPOD_SERVER_ID': 'testServer1',
      },
    );

    expect(config.serverId, 'testServer1');
  });

  test(
      'Given a Serverpod config with only the api server configuration but the server id given as an argument then the server id matches supplied value.',
      () {
    var config = ServerpodConfig.loadFromMap(
      runMode,
      'testServer1',
      passwords,
      {
        'apiServer': {
          'port': 8080,
          'publicHost': 'localhost',
          'publicPort': 8080,
          'publicScheme': 'http',
        },
      },
    );

    expect(config.serverId, 'testServer1');
  });

  test(
      'Given a Serverpod config with server id when loading from Map and the environment variables containing the server id but the server id given as an argument is the default value then the server id from environment takes the precedence.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
serverId: testServerIdFromConfig
''';

    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      loadYaml(serverpodConfig),
      environment: {
        'SERVERPOD_SERVER_ID': 'testServerIdFromEnv',
      },
    );

    expect(config.serverId, 'testServerIdFromEnv');
  });

  test(
      'Given a Serverpod config with server id when loading from Map and the environment variables containing the server id and the server id given as an argument is a custom defined value then the server id from the argument takes the precedence.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
serverId: testServerIdFromConfig
''';

    var config = ServerpodConfig.loadFromMap(
      runMode,
      'testServerIdFromArg',
      passwords,
      loadYaml(serverpodConfig),
      environment: {
        'SERVERPOD_SERVER_ID': 'testServerIdFromEnv',
      },
    );

    expect(config.serverId, 'testServerIdFromArg');
  });

  test(
      'Given a Serverpod config without futureCallExecutionEnabled when loading from Map then the futureCallExecutionEnabled is set to true.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''';

    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      loadYaml(serverpodConfig),
    );

    expect(config.futureCallExecutionEnabled, isTrue);
  });

  test(
      'Given a Serverpod config with futureCallExecutionEnabled set to false when loading from Map then the futureCallExecutionEnabled is set to false.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
futureCallExecutionEnabled: false
''';

    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      loadYaml(serverpodConfig),
    );

    expect(config.futureCallExecutionEnabled, isFalse);
  });

  test(
      'Given a Serverpod config without futureCallExecutionEnabled and environment contains SERVERPOD_DISABLE_FUTURE_CALL_EXECUTION set to false when loading from Map then the futureCallExecutionEnabled is set to false.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''';

    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      loadYaml(serverpodConfig),
      environment: {
        'SERVERPOD_FUTURE_CALL_EXECUTION_ENABLED': 'false',
      },
    );

    expect(config.futureCallExecutionEnabled, isFalse);
  });

  test(
      'Given a Serverpod config with futureCallExecutionEnabled set to false and environment contains SERVERPOD_FUTURE_CALL_EXECUTION_ENABLED set to true when loading from Map then the futureCallExecutionEnabled is set to true.',
      () {
    var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
futureCallExecutionEnabled: false
''';

    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      loadYaml(serverpodConfig),
      environment: {
        'SERVERPOD_FUTURE_CALL_EXECUTION_ENABLED': 'true',
      },
    );

    expect(config.futureCallExecutionEnabled, isTrue);
  });

  test(
      'Given a Serverpod config instance is created with runMode set to "development" when reading the consoleLogFormat then the consoleLogFormat is set to text',
      () {
    var config = ServerpodConfig(
      runMode: 'development',
      apiServer: ServerpodConfig.defaultConfig().apiServer,
    );

    expect(config.sessionLogs.consoleLogFormat, ConsoleLogFormat.text);
  });

  test(
      'Given a Serverpod config instance is created with runMode set to "production" when reading the consoleLogFormat then the consoleLogFormat is set to json',
      () {
    var config = ServerpodConfig(
      runMode: 'production',
      apiServer: ServerpodConfig.defaultConfig().apiServer,
    );

    expect(config.sessionLogs.consoleLogFormat, ConsoleLogFormat.json);
  });

  group('Given an empty Serverpod config map when loading from Map then', () {
    test('future call config uses default concurrency limit of 1', () {
      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        {},
        environment: {},
      );

      expect(config.futureCall.concurrencyLimit, 1);
      expect(config.futureCall.scanInterval.inMilliseconds, 5000);
      expect(config.apiServer.port, 8080);
      expect(config.apiServer.publicHost, 'localhost');
    });

    test(
        'API server uses defaults while other configs can still be parsed from environment',
        () {
      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        {...passwords, 'database': 'dbpass'},
        {},
        environment: {
          'SERVERPOD_DATABASE_HOST': 'localhost',
          'SERVERPOD_DATABASE_PORT': '5432',
          'SERVERPOD_DATABASE_NAME': 'testdb',
          'SERVERPOD_DATABASE_USER': 'testuser',
        },
      );

      // API server should use defaults (since no API config provided)
      expect(config.apiServer.port, 8080);
      expect(config.apiServer.publicHost, 'localhost');
      expect(config.apiServer.publicPort, 8080);
      expect(config.apiServer.publicScheme, 'http');

      // Other configs should still be parsed from environment
      expect(config.database?.host, 'localhost');
      expect(config.database?.port, 5432);
      expect(config.database?.name, 'testdb');
      expect(config.database?.user, 'testuser');
    });
  });

  group(
      'Given a Serverpod config with role configuration when loading from Map then',
      () {
    test('role defaults to monolith when no role is specified', () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.role, ServerpodRole.monolith);
    });

    test('role from environment variable is used', () {
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
          'SERVERPOD_SERVER_ROLE': 'serverless',
        },
      );

      expect(config.role, ServerpodRole.serverless);
    });

    test('role from command line args takes precedence over environment', () {
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
          'SERVERPOD_SERVER_ROLE': 'serverless',
        },
        commandLineArgs: {
          'role': ServerpodRole.maintenance,
        },
      );

      expect(config.role, ServerpodRole.maintenance);
    });

    test('invalid role from environment throws ArgumentError', () {
      expect(
        () => ServerpodConfig.loadFromMap(
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
            'SERVERPOD_SERVER_ROLE': 'invalid_role',
          },
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.toString(),
          'message',
          contains(
              'Invalid SERVERPOD_SERVER_ROLE from environment variable: invalid_role'),
        )),
      );
    });

    test('all valid roles are accepted from environment', () {
      final validRoles = ['monolith', 'serverless', 'maintenance'];
      final expectedRoles = [
        ServerpodRole.monolith,
        ServerpodRole.serverless,
        ServerpodRole.maintenance
      ];

      for (int i = 0; i < validRoles.length; i++) {
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
            'SERVERPOD_SERVER_ROLE': validRoles[i],
          },
        );

        expect(config.role, expectedRoles[i]);
      }
    });
  });

  group(
      'Given a Serverpod config with logging mode configuration when loading from Map then',
      () {
    test('logging mode defaults to normal when no logging mode is specified',
        () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.loggingMode, ServerpodLoggingMode.normal);
    });

    test('logging mode from environment variable is used', () {
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
          'SERVERPOD_LOGGING_MODE': 'verbose',
        },
      );

      expect(config.loggingMode, ServerpodLoggingMode.verbose);
    });

    test(
        'logging mode from command line args takes precedence over environment',
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
          'SERVERPOD_LOGGING_MODE': 'verbose',
        },
        commandLineArgs: {
          'loggingMode': ServerpodLoggingMode.normal,
        },
      );

      expect(config.loggingMode, ServerpodLoggingMode.normal);
    });

    test('invalid logging mode from environment throws ArgumentError', () {
      expect(
        () => ServerpodConfig.loadFromMap(
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
            'SERVERPOD_LOGGING_MODE': 'invalid_logging',
          },
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.toString(),
          'message',
          contains(
              'Invalid SERVERPOD_LOGGING_MODE from environment variable: invalid_logging'),
        )),
      );
    });

    test('all valid logging modes are accepted from environment', () {
      final validLoggingModes = ['normal', 'verbose'];
      final expectedLoggingModes = [
        ServerpodLoggingMode.normal,
        ServerpodLoggingMode.verbose
      ];

      for (int i = 0; i < validLoggingModes.length; i++) {
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
            'SERVERPOD_LOGGING_MODE': validLoggingModes[i],
          },
        );

        expect(config.loggingMode, expectedLoggingModes[i]);
      }
    });
  });

  group(
      'Given a Serverpod config with apply migrations configuration when loading from Map then',
      () {
    test('apply migrations defaults to false when not specified', () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.applyMigrations, isFalse);
    });

    test('apply migrations from environment variable is used when set to true',
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
          'SERVERPOD_APPLY_MIGRATIONS': 'true',
        },
      );

      expect(config.applyMigrations, isTrue);
    });

    test('apply migrations from environment variable is used when set to 1',
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
          'SERVERPOD_APPLY_MIGRATIONS': '1',
        },
      );

      expect(config.applyMigrations, isTrue);
    });

    test('apply migrations from environment variable is used when set to false',
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
          'SERVERPOD_APPLY_MIGRATIONS': 'false',
        },
      );

      expect(config.applyMigrations, isFalse);
    });

    test('apply migrations from environment variable is used when set to 0',
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
          'SERVERPOD_APPLY_MIGRATIONS': '0',
        },
      );

      expect(config.applyMigrations, isFalse);
    });

    test(
        'apply migrations from command line args takes precedence over environment',
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
          'SERVERPOD_APPLY_MIGRATIONS': 'false',
        },
        commandLineArgs: {
          'applyMigrations': true,
        },
      );

      expect(config.applyMigrations, isTrue);
    });

    test('invalid apply migrations from environment throws ArgumentError', () {
      expect(
        () => ServerpodConfig.loadFromMap(
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
            'SERVERPOD_APPLY_MIGRATIONS': 'invalid_value',
          },
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.toString(),
          'message',
          contains(
              'Invalid SERVERPOD_APPLY_MIGRATIONS from environment variable: invalid_value'),
        )),
      );
    });
  });

  group(
      'Given a Serverpod config with apply repair migration configuration when loading from Map then',
      () {
    test('apply repair migration defaults to false when not specified', () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.applyRepairMigration, isFalse);
    });

    test(
        'apply repair migration from environment variable is used when set to true',
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
          'SERVERPOD_APPLY_REPAIR_MIGRATION': 'true',
        },
      );

      expect(config.applyRepairMigration, isTrue);
    });

    test(
        'apply repair migration from environment variable is used when set to 1',
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
          'SERVERPOD_APPLY_REPAIR_MIGRATION': '1',
        },
      );

      expect(config.applyRepairMigration, isTrue);
    });

    test(
        'apply repair migration from environment variable is used when set to false',
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
          'SERVERPOD_APPLY_REPAIR_MIGRATION': 'false',
        },
      );

      expect(config.applyRepairMigration, isFalse);
    });

    test(
        'apply repair migration from environment variable is used when set to 0',
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
          'SERVERPOD_APPLY_REPAIR_MIGRATION': '0',
        },
      );

      expect(config.applyRepairMigration, isFalse);
    });

    test(
        'apply repair migration from command line args takes precedence over environment',
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
          'SERVERPOD_APPLY_REPAIR_MIGRATION': 'false',
        },
        commandLineArgs: {
          'applyRepairMigration': true,
        },
      );

      expect(config.applyRepairMigration, isTrue);
    });

    test('invalid apply repair migration from environment throws ArgumentError',
        () {
      expect(
        () => ServerpodConfig.loadFromMap(
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
            'SERVERPOD_APPLY_REPAIR_MIGRATION': 'invalid_value',
          },
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.toString(),
          'message',
          contains(
              'Invalid SERVERPOD_APPLY_REPAIR_MIGRATION from environment variable: invalid_value'),
        )),
      );
    });
  });

  group(
      'Given a Serverpod config with serverId configuration when loading from Map then',
      () {
    test(
        'serverId defaults to "default" when not specified and serverId arg is null',
        () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        null, // serverId is null
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.serverId, 'default');
    });

    test('serverId from config file is used when serverId arg is null', () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
serverId: configFileServerId
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        null, // serverId is null
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.serverId, 'configFileServerId');
    });

    test(
        'serverId from environment takes precedence over config file when serverId arg is null',
        () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
serverId: configFileServerId
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        null, // serverId is null
        passwords,
        loadYaml(serverpodConfig),
        environment: {
          'SERVERPOD_SERVER_ID': 'envServerId',
        },
      );

      expect(config.serverId, 'envServerId');
    });

    test(
        'serverId from command line arg takes precedence over all other sources',
        () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
serverId: configFileServerId
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        'cmdLineServerId', // serverId from command line
        passwords,
        loadYaml(serverpodConfig),
        environment: {
          'SERVERPOD_SERVER_ID': 'envServerId',
        },
      );

      expect(config.serverId, 'cmdLineServerId');
    });

    test('empty string serverId from command line arg is still used', () {
      var config = ServerpodConfig.loadFromMap(
        runMode,
        '', // empty string serverId
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
          'SERVERPOD_SERVER_ID': 'envServerId',
        },
      );

      expect(config.serverId, '');
    });
  });
}
