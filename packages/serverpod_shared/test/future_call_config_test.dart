import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  var runMode = 'development';
  // Setting the serverId to null as the default value.
  // ignore: avoid_init_to_null
  var serverId = null;
  var passwords = {
    'serviceSecret': 'longpasswordthatisrequired',
    'database': 'dbpassword',
  };

  test(
    'Given a Serverpod config missing futureCall configuration when loading from Map then futureCall defaults to default values',
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

      expect(
        config.futureCall.concurrencyLimit,
        equals(FutureCallConfig.defaultFutureCallConcurrencyLimit),
      );
      expect(
        config.futureCall.scanInterval.inMilliseconds,
        equals(FutureCallConfig.defaultFutureCallScanIntervalMs),
      );
    },
  );

  test(
    'Given a Serverpod config with futureCall configuration when loading from Map then futureCall uses configured values',
    () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
futureCall:
  concurrencyLimit: 5
  scanInterval: 2000
  scanBrokenFutureCalls: false
  deleteBrokenFutureCalls: true
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.futureCall.concurrencyLimit, equals(5));
      expect(
        config.futureCall.scanInterval,
        equals(const Duration(milliseconds: 2000)),
      );
      expect(config.futureCall.scanBrokenFutureCalls, isFalse);
      expect(config.futureCall.deleteBrokenFutureCalls, isTrue);
    },
  );

  test(
    'Given a Serverpod config with futureCall when environment variables override them then futureCall config reflects the environment overrides',
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
          'futureCall': {
            'concurrencyLimit': 5,
            'scanInterval': 2000,
            'scanBrokenFutureCalls': false,
            'deleteBrokenFutureCalls': false,
          },
        },
        environment: {
          'SERVERPOD_FUTURE_CALL_CONCURRENCY_LIMIT': '10',
          'SERVERPOD_FUTURE_CALL_SCAN_INTERVAL': '3000',
          'SERVERPOD_SCAN_BROKEN_FUTURE_CALLS': 'true',
          'SERVERPOD_DELETE_BROKEN_FUTURE_CALLS': 'true',
        },
      );

      expect(config.futureCall.concurrencyLimit, equals(10));
      expect(
        config.futureCall.scanInterval,
        equals(const Duration(milliseconds: 3000)),
      );
      expect(config.futureCall.scanBrokenFutureCalls, isTrue);
      expect(config.futureCall.deleteBrokenFutureCalls, isTrue);
    },
  );

  test(
    'Given invalid environment variable values for futureCall config then throws Exception',
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
            'SERVERPOD_FUTURE_CALL_CONCURRENCY_LIMIT': 'invalid',
          },
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(
              'Invalid value (invalid) for SERVERPOD_FUTURE_CALL_CONCURRENCY_LIMIT.',
            ),
          ),
        ),
      );
    },
  );

  test(
    'Given partial environment variable overrides for futureCall config then only specified values are overridden',
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
          'futureCall': {
            'concurrencyLimit': 5,
            'scanInterval': 2000,
            'deleteBrokenFutureCalls': true,
          },
        },
        environment: {
          'SERVERPOD_FUTURE_CALL_CONCURRENCY_LIMIT': '10',
          'SERVERPOD_SCAN_BROKEN_FUTURE_CALLS': 'false',
        },
      );

      expect(config.futureCall.concurrencyLimit, equals(10));
      expect(
        config.futureCall.scanInterval,
        equals(const Duration(milliseconds: 2000)),
      );
      expect(config.futureCall.scanBrokenFutureCalls, isFalse);
      expect(config.futureCall.deleteBrokenFutureCalls, isTrue);
    },
  );

  test(
    'Given a Serverpod config with only concurrencyLimit configured when loading from Map then scanInterval uses default value',
    () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
futureCall:
  concurrencyLimit: 5
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.futureCall.concurrencyLimit, equals(5));
      expect(
        config.futureCall.scanInterval.inMilliseconds,
        equals(FutureCallConfig.defaultFutureCallScanIntervalMs),
      );
    },
  );

  test(
    'Given a Serverpod config with only scanInterval configured when loading from Map then concurrencyLimit uses default value',
    () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
futureCall:
  scanInterval: 2000
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(
        config.futureCall.concurrencyLimit,
        equals(FutureCallConfig.defaultFutureCallConcurrencyLimit),
      );
      expect(
        config.futureCall.scanInterval,
        equals(const Duration(milliseconds: 2000)),
      );
    },
  );

  test(
    'Given a negative concurrencyLimit when loading from Map then sets concurrencyLimit to null (unlimited concurrency)',
    () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
futureCall:
  concurrencyLimit: -1
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.futureCall.concurrencyLimit, isNull);
    },
  );

  test(
    'Given a null concurrencyLimit when loading from Map then allows unlimited concurrency',
    () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
futureCall:
  concurrencyLimit: null
  scanInterval: 2000
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.futureCall.concurrencyLimit, isNull);
      expect(
        config.futureCall.scanInterval,
        equals(const Duration(milliseconds: 2000)),
      );
    },
  );

  test(
    'Given an invalid scanInterval in environment variable when loading from Map then throws Exception',
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
            'SERVERPOD_FUTURE_CALL_SCAN_INTERVAL': 'invalid',
          },
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(
              'Invalid value (invalid) for SERVERPOD_FUTURE_CALL_SCAN_INTERVAL',
            ),
          ),
        ),
      );
    },
  );

  test(
    'Given a Serverpod config without scanBrokenFutureCalls and deleteBrokenFutureCalls configured '
    'when loading from Map then they both use default values',
    () {
      var serverpodConfig = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
futureCall:
  scanInterval: 2000
''';

      var config = ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        loadYaml(serverpodConfig),
      );

      expect(config.futureCall.scanBrokenFutureCalls, isNull);
      expect(config.futureCall.deleteBrokenFutureCalls, isFalse);
    },
  );
}
