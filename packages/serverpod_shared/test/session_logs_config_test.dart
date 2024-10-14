import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  var runMode = 'development';
  var serverId = 'default';
  var passwords = {
    'serviceSecret': 'longpasswordthatisrequired',
    'database': 'dbpassword'
  };

  test(
    'Given a Serverpod config missing sessionLogs configuration when loading from Map then sessionLogs is null.',
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

      expect(config.sessionLogs, isNull);
    },
  );

  test(
    'Given a Serverpod config with sessionLogs and no database when persistentEnabled is true then it is overridden to false.',
    () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
sessionLogs:
  persistentEnabled: true
  consoleEnabled: false
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
        environment: {},
      );

      expect(config.sessionLogs?.persistentEnabled, isFalse);
      expect(config.sessionLogs?.consoleEnabled, isFalse);
    },
  );

  test(
    'Given a Serverpod config with sessionLogs and no database when persistentEnabled is false then it remains false.',
    () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
sessionLogs:
  persistentEnabled: false
  consoleEnabled: true
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
        environment: {},
      );

      expect(config.sessionLogs?.persistentEnabled, isFalse);
      expect(config.sessionLogs?.consoleEnabled, isTrue);
    },
  );

  test(
    'Given a Serverpod config with sessionLogs and database when persistentEnabled is true then persistentEnabled remains true.',
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
  user: testUser
sessionLogs:
  persistentEnabled: true
  consoleEnabled: false
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.sessionLogs?.persistentEnabled, isTrue);
      expect(config.sessionLogs?.consoleEnabled, isFalse);
    },
  );

  test(
    'Given a Serverpod config with sessionLogs and database when persistentEnabled is false then persistentEnabled remains false.',
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
  user: testUser
sessionLogs:
  persistentEnabled: false
  consoleEnabled: true
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.sessionLogs?.persistentEnabled, isFalse);
      expect(config.sessionLogs?.consoleEnabled, isTrue);
    },
  );

  test(
    'Given a Serverpod config with sessionLogs and database when environment variables override them then sessionLogs config reflects the environment overrides.',
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
          'database': {
            'host': 'localhost',
            'port': 5432,
            'name': 'testDb',
            'user': 'testUser',
          },
          'sessionLogs': {
            'persistentEnabled': false,
            'consoleEnabled': true,
          },
        },
        environment: {
          'SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED': 'true',
          'SERVERPOD_SESSION_CONSOLE_LOG_ENABLED': 'false',
        },
      );

      expect(config.sessionLogs?.persistentEnabled, isTrue);
      expect(config.sessionLogs?.consoleEnabled, isFalse);
    },
  );
}
