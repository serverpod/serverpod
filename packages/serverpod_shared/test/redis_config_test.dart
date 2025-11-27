import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  var runMode = 'development';
  // Setting the serverId to null as the default value.
  // ignore: avoid_init_to_null
  var serverId = null;
  var passwords = {'serviceSecret': 'longpasswordthatisrequired'};

  test(
    'Given a Serverpod config with api server configuration when loading from Map then redis configuration is null.',
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

      expect(config.redis, isNull);
    },
  );

  test(
    'Given a Serverpod config with redis configuration without password when loading from Map then exception is thrown.',
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

      expect(
        () => ServerpodConfig.loadFromMap(
          runMode,
          serverId,
          passwords,
          loadYaml(serverpodConfig),
        ),
        throwsA(
          isA<PasswordMissingException>()
              .having(
                (e) => e.passwordName,
                'passwordName',
                equals('redis'),
              )
              .having(
                (e) => e.envVarName,
                'envVarName',
                equals('SERVERPOD_PASSWORD_redis'),
              ),
        ),
      );
    },
  );

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
  host: localhost
''';

      expect(
        () => ServerpodConfig.loadFromMap(
          runMode,
          serverId,
          {...passwords, 'redis': 'password'},
          loadYaml(serverpodConfig),
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            equals(
              'Exception: redis is missing required configuration for port.',
            ),
          ),
        ),
      );
    },
  );

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
      expect(config.redis?.user, isNull);
      expect(config.redis?.requireSsl, isFalse);
      expect(config.redis?.enabled, isTrue);
    },
  );

  test(
    'Given a Serverpod config with only the api server configuration but the environment variables containing the config for redis when loading from Map then the redis config is created.',
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
        },
      );

      expect(config.redis?.host, 'localhost');
      expect(config.redis?.port, 6379);
    },
  );

  test(
    'Given a Serverpod config map with half the values and the environment variables the other half for redis when loading from Map then configuration then the redis config is created',
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
        },
      );

      expect(config.redis?.host, 'localhost');
      expect(config.redis?.port, 6379);
    },
  );

  test(
    'Given a Serverpod config map with all the values and the environment variables for redis when loading from Map then the config is overridden by the environment variables.',
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
          },
        },
        environment: {
          'SERVERPOD_REDIS_HOST': 'remotehost',
          'SERVERPOD_REDIS_PORT': '6380',
        },
      );

      expect(config.redis?.host, 'remotehost');
      expect(config.redis?.port, 6380);
    },
  );

  test(
    'Given a Serverpod config with only the api server configuration but the environment variables containing the optional redis variable require ssl then the redis config takes the value from the env.',
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
          'SERVERPOD_REDIS_REQUIRE_SSL': 'true',
        },
      );

      expect(config.redis?.requireSsl, true);
    },
  );

  test(
    'Given a Serverpod config with only the api server configuration but the environment variables containing the optional redis variable user then the redis config takes the value from the env.',
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
          'SERVERPOD_REDIS_USER': 'admin',
        },
      );

      expect(config.redis?.user, 'admin');
    },
  );

  test(
    'Given a Serverpod config with only the api server configuration but the environment variables containing the optional redis variable enabled then the redis config takes the value from the env.',
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
          'SERVERPOD_REDIS_ENABLED': 'true',
        },
      );

      expect(config.redis?.enabled, true);
    },
  );

  test(
    'Given a Serverpod config with redis configuration including user when loading from Map then the redis config is set correctly.',
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
  user: testuser
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        {...passwords, 'redis': 'password'},
        loadYaml(serverpodConfig),
      );

      expect(config.redis?.user, equals('testuser'));
    },
  );

  test(
    'Given a Serverpod config with redis configuration including requireSsl when loading from Map then the redis config is set correctly.',
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

      expect(config.redis?.requireSsl, isTrue);
    },
  );

  test(
    'Given a Serverpod config with redis configuration including enabled when loading from Map then the redis config is set correctly.',
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
  enabled: true
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        {...passwords, 'redis': 'password'},
        loadYaml(serverpodConfig),
      );

      expect(config.redis?.enabled, isTrue);
    },
  );

  test(
    'Given a Serverpod config with both config file and environment variables for redis optional fields when loading from Map then the environment variable overrides the config file.',
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
  user: configuser
  requireSsl: false
  enabled: false
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        {...passwords, 'redis': 'password'},
        loadYaml(serverpodConfig),
        environment: {
          'SERVERPOD_REDIS_USER': 'envuser',
          'SERVERPOD_REDIS_REQUIRE_SSL': 'true',
          'SERVERPOD_REDIS_ENABLED': 'true',
        },
      );

      expect(config.redis?.user, equals('envuser'));
      expect(config.redis?.requireSsl, isTrue);
      expect(config.redis?.enabled, isTrue);
    },
  );

  test(
    'Given a Serverpod config with redis configuration where enabled=false when loading from Map then redis configuration is null.',
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
  enabled: false
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        {...passwords, 'redis': 'password'},
        loadYaml(serverpodConfig),
      );

      expect(config.redis, isNull);
    },
  );

  test(
    'Given a Serverpod config with redis configuration but SERVERPOD_REDIS_ENABLED=false in environment when loading from Map then redis configuration is null.',
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
  enabled: true
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        {...passwords, 'redis': 'password'},
        loadYaml(serverpodConfig),
        environment: {
          'SERVERPOD_REDIS_ENABLED': 'false',
        },
      );

      expect(config.redis, isNull);
    },
  );

  test(
    'Given a Serverpod config with redis configuration without the enabled field when loading from Map then redis configuration defaults to enabled.',
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

      expect(config.redis, isNotNull);
      expect(config.redis?.enabled, isTrue);
    },
  );

  test(
    'Given a Serverpod config with redis configuration where enabled=false and no password provided when loading from Map then no PasswordMissingException is thrown and redis configuration is null.',
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
  enabled: false
''';

      // This should not throw a PasswordMissingException
      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords, // No redis password provided
        loadYaml(serverpodConfig),
      );

      expect(config.redis, isNull);
    },
  );

  test(
    'Given a Serverpod config with redis configuration where enabled=true explicitly when loading from Map then redis configuration is created normally.',
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
  enabled: true
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        {...passwords, 'redis': 'password'},
        loadYaml(serverpodConfig),
      );

      expect(config.redis, isNotNull);
      expect(config.redis?.host, 'localhost');
      expect(config.redis?.port, 6379);
      expect(config.redis?.password, 'password');
      expect(config.redis?.enabled, isTrue);
    },
  );
}
