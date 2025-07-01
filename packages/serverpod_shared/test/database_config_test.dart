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
      'Given a Serverpod config with api server configuration when loading from Map then database configuration is null.',
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

    expect(config.database, isNull);
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
    expect(config.database?.searchPaths, isNull);
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
      'Given a Serverpod config with only the api server configuration but the environment variables containing the optional database variable searchPaths then the database config takes the value from the env.',
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
        'SERVERPOD_DATABASE_SEARCH_PATHS': 'custom_path',
      },
    );

    expect(config.database?.searchPaths, isA<List<String>?>());
    expect(config.database?.searchPaths, equals(['custom_path']));
  });

  test(
      'Given a Serverpod config with database configuration including searchPaths when loading from Map then the database config is set correctly.',
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
  searchPaths: custom_path
''';

    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      {...passwords, 'database': 'password'},
      loadYaml(serverpodConfig),
    );

    expect(config.database?.searchPaths, equals(['custom_path']));
  });

  test(
      'Given a Serverpod config with both config file and environment variables for searchPaths when loading from Map then the environment variable overrides the config file.',
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
  searchPaths: config_file_path
''';

    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      {...passwords, 'database': 'password'},
      loadYaml(serverpodConfig),
      environment: {
        'SERVERPOD_DATABASE_SEARCH_PATHS': 'env_path',
      },
    );

    expect(config.database?.searchPaths, equals(['env_path']));
  });

  test(
      'Given a Serverpod config with a list of searchPaths when loading from Map then all search paths are parsed.',
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
  searchPaths: first_search_path, second_search_path, third_search_path
''';

    var config = ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      {...passwords, 'database': 'password'},
      loadYaml(serverpodConfig),
    );

    expect(
      config.database?.searchPaths,
      equals(['first_search_path', 'second_search_path', 'third_search_path']),
    );
  });

  test(
      'Given a SERVERPOD_DATABASE_SEARCH_PATHS with a list of searchPaths when loading from Map then all search paths are parsed.',
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
      environment: {
        'SERVERPOD_DATABASE_SEARCH_PATHS':
            'first_search_path, second_search_path, third_search_path',
      },
    );

    expect(
      config.database?.searchPaths,
      equals(['first_search_path', 'second_search_path', 'third_search_path']),
    );
  });
}
