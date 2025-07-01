import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  var developmentRunMode = 'development';
  var productionRunMode = 'production';
  // Setting the serverId to null as the default value.
  // ignore: avoid_init_to_null
  var serverId = null;
  var passwords = {
    'serviceSecret': 'longpasswordthatisrequired',
    'database': 'dbpassword'
  };

  test(
    'Given a Serverpod config with "development" run mode missing sessionLogs configuration and no database when loading from Map then sessionLogs defaults to console text logging enabled and persistent logging disabled',
    () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''';

      var config = ServerpodConfig.loadFromMap(
        developmentRunMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.sessionLogs.persistentEnabled, isFalse);
      expect(config.sessionLogs.consoleEnabled, isTrue);
      expect(
        config.sessionLogs.consoleLogFormat,
        ConsoleLogFormat.text,
      );
    },
  );

  test(
    'Given a Serverpod config with "production" run mode missing sessionLogs configuration and no database when loading from Map then sessionLogs defaults to console json logging enabled and persistent logging disabled',
    () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''';

      var config = ServerpodConfig.loadFromMap(
        productionRunMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.sessionLogs.persistentEnabled, isFalse);
      expect(config.sessionLogs.consoleEnabled, isTrue);
      expect(
        config.sessionLogs.consoleLogFormat,
        ConsoleLogFormat.json,
      );
    },
  );

  test(
    'Given a Serverpod config with "development" run mode missing sessionLogs configuration and a database when loading from Map then sessionLogs defaults to persistent logging enabled and console text logging is enabled',
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
''';

      var config = ServerpodConfig.loadFromMap(
        developmentRunMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.sessionLogs.persistentEnabled, isTrue);
      expect(config.sessionLogs.consoleEnabled, isTrue);
      expect(
        config.sessionLogs.consoleLogFormat,
        ConsoleLogFormat.text,
      );
    },
  );

  test(
    'Given a Serverpod config with "production" run mode missing sessionLogs configuration and a database when loading from Map then sessionLogs defaults to persistent logging enabled and json console logging disabled',
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
''';

      var config = ServerpodConfig.loadFromMap(
        productionRunMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.sessionLogs.persistentEnabled, isTrue);
      expect(config.sessionLogs.consoleEnabled, isFalse);
      expect(
        config.sessionLogs.consoleLogFormat,
        ConsoleLogFormat.json,
      );
    },
  );

  test(
    'Given a Serverpod config with sessionLogs and no database when persistentEnabled is true then a StateError is thrown',
    () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
sessionLogs:
  persistentEnabled: true
''';

      expect(
        () => ServerpodConfig.loadFromMap(
          developmentRunMode,
          serverId,
          passwords,
          loadYaml(serverpodConfig),
          environment: {},
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains(
                'The `persistentEnabled` setting was enabled in the configuration, but this project was created without database support.'),
          ),
        ),
      );
    },
  );

  test(
    'Given a Serverpod config with sessionLogs and no database when persistentEnabled is false then it remains false',
    () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
sessionLogs:
  persistentEnabled: false
''';

      var config = ServerpodConfig.loadFromMap(
        developmentRunMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
        environment: {},
      );

      expect(config.sessionLogs.persistentEnabled, isFalse);
    },
  );

  test(
    'Given a Serverpod config with sessionLogs and database when persistentEnabled is true then persistentEnabled remains true',
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
''';

      var config = ServerpodConfig.loadFromMap(
        developmentRunMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.sessionLogs.persistentEnabled, isTrue);
    },
  );

  test(
    'Given a Serverpod config with sessionLogs when consoleEnabled is true then consoleEnabled remains true',
    () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
sessionLogs:
  consoleEnabled: true
''';

      var config = ServerpodConfig.loadFromMap(
        developmentRunMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.sessionLogs.consoleEnabled, isTrue);
    },
  );

  test(
    'Given a Serverpod config with sessionLogs and database when persistentEnabled is false then persistentEnabled remains false',
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
  consoleLogFormat: text
''';

      var config = ServerpodConfig.loadFromMap(
        developmentRunMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.sessionLogs.persistentEnabled, isFalse);
      expect(config.sessionLogs.consoleEnabled, isTrue);
      expect(config.sessionLogs.consoleLogFormat, ConsoleLogFormat.text);
    },
  );

  test(
    'Given a Serverpod config with sessionLogs and database when environment variables override them then sessionLogs config reflects the environment overrides',
    () {
      var config = ServerpodConfig.loadFromMap(
        developmentRunMode,
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
            'consoleLogFormat': 'text',
          },
        },
        environment: {
          'SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED': 'true',
          'SERVERPOD_SESSION_CONSOLE_LOG_ENABLED': 'false',
          'SERVERPOD_SESSION_CONSOLE_LOG_FORMAT': 'json',
        },
      );

      expect(config.sessionLogs.persistentEnabled, isTrue);
      expect(config.sessionLogs.consoleEnabled, isFalse);
      expect(config.sessionLogs.consoleLogFormat, ConsoleLogFormat.json);
    },
  );

  test(
    'Given a Serverpod config with an invalid console log format then argument error is thrown',
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
  consoleLogFormat: invalid_value
''';

      expect(
        () => ServerpodConfig.loadFromMap(
          developmentRunMode,
          serverId,
          passwords,
          loadYaml(serverpodConfig),
        ),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message',
            'Invalid console log format: "invalid_value". Valid values are: json, text')),
      );
    },
  );
}
