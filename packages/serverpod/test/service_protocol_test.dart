import 'package:serverpod_service_client/serverpod_service_client.dart'
    as service;
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

Future<void> setupTestData(Client client) async {
  await client.basicDatabase.deleteAllSimpleTestData();
  await client.basicDatabase.createSimpleTestData(100);
}

void main() {
  Client client = Client('http://serverpod_test_server:8080/');
  service.Client serviceClient = service.Client(
    'http://serverpod_test_server:8081/',
    authenticationKeyManager: ServiceKeyManager('0', 'password'),
  );

  group('Logging', () {
    test('Set runtime settings', () async {
      // Log everything
      service.RuntimeSettings settings = service.RuntimeSettings(
        logSettings: service.LogSettings(
          logAllSessions: true,
          logSlowSessions: true,
          logFailedSessions: false,
          logAllQueries: true,
          logSlowQueries: true,
          logFailedQueries: true,
          slowSessionDuration: 1.0,
          slowQueryDuration: 1.0,
          logLevel: service.LogLevel.debug.index,
        ),
        logMalformedCalls: true,
        logServiceCalls: false,
        logSettingsOverrides: <service.LogSettingsOverride>[],
      );

      await serviceClient.insights.setRuntimeSettings(settings);

      settings = await serviceClient.insights.getRuntimeSettings();
      expect(settings.logSettings.logFailedSessions, equals(false));

      settings.logSettings.logFailedSessions = true;
      await serviceClient.insights.setRuntimeSettings(settings);
      settings = await serviceClient.insights.getRuntimeSettings();
      expect(settings.logSettings.logFailedSessions, equals(true));
    });

    test('Clear logs', () async {
      // Start by clearing logs
      await serviceClient.insights.clearAllLogs();

      // Make sure there is at least 10 log entries
      for (int i = 0; i < 10; i += 1) {
        await client.logging.logInfo('Log test $i');
      }

      service.SessionLogResult logResult =
          await serviceClient.insights.getSessionLog(10, null);
      expect(logResult.sessionLog.length, equals(10));

      await serviceClient.insights.clearAllLogs();

      logResult = await serviceClient.insights.getSessionLog(10, null);
      expect(logResult.sessionLog.length, equals(0));
    });

    test('Log entry', () async {
      await client.logging.logInfo('test');

      service.SessionLogResult logResult =
          await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      expect(logResult.sessionLog[0].messageLog.length, equals(1));
      expect(logResult.sessionLog[0].messageLog[0].message, equals('test'));
    });

    test('All log levels', () async {
      await client.logging.logDebugAndInfoAndError('debug', 'info', 'error');

      // Writing of logs may still be going on after the call has returned,
      // wait a second to make sure the log has been flushed to the database
      await Future<void>.delayed(const Duration(seconds: 1));

      service.SessionLogResult logResult =
          await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      expect(logResult.sessionLog[0].messageLog.length, equals(3));
      expect(logResult.sessionLog[0].messageLog[0].message, equals('debug'));
      expect(logResult.sessionLog[0].messageLog[1].message, equals('info'));
      expect(logResult.sessionLog[0].messageLog[2].message, equals('error'));
    });

    test('Error log level', () async {
      // Set log level to error
      service.RuntimeSettings settings = service.RuntimeSettings(
        logSettings: service.LogSettings(
          logAllSessions: true,
          logSlowSessions: true,
          logFailedSessions: true,
          logAllQueries: true,
          logSlowQueries: true,
          logFailedQueries: true,
          slowSessionDuration: 1.0,
          slowQueryDuration: 1.0,
          logLevel: service.LogLevel.error.index,
        ),
        logSettingsOverrides: <service.LogSettingsOverride>[],
        logMalformedCalls: true,
        logServiceCalls: false,
      );
      await serviceClient.insights.setRuntimeSettings(settings);

      await client.logging.logDebugAndInfoAndError('debug', 'info', 'error');

      // Writing of logs may still be going on after the call has returned,
      // wait a second to make sure the log has been flushed to the database
      await Future<void>.delayed(const Duration(seconds: 1));

      service.SessionLogResult logResult =
          await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      // Debug and info logs should be ignored
      expect(logResult.sessionLog[0].messageLog.length, equals(1));
      expect(logResult.sessionLog[0].messageLog[0].message, equals('error'));
    });

    test('Query log', () async {
      await client.logging.twoQueries();

      // Writing of logs may still be going on after the call has returned,
      // wait a second to make sure the log has been flushed to the database
      await Future<void>.delayed(const Duration(seconds: 1));

      service.SessionLogResult logResult =
          await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      expect(logResult.sessionLog[0].queries.length, equals(2));
    });

    test('Transaction query log', () async {
      await setupTestData(client);
      await client.transactionsDatabase.updateInsertDelete(50, 500, 0);
      await Future<void>.delayed(const Duration(seconds: 1));

      service.SessionLogResult logResult =
          await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      expect(logResult.sessionLog[0].queries.length, equals(4));
    });

    test('Disabled logging', () async {
      await client.logging.logInfo('test');
      await Future<void>.delayed(const Duration(seconds: 1));

      service.SessionLogResult logResult =
          await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));
      expect(
          logResult.sessionLog[0].sessionLogEntry.endpoint, equals('logging'));
      expect(logResult.sessionLog[0].sessionLogEntry.method, equals('logInfo'));

      await client.logging.logInfo('test');
      await Future<void>.delayed(const Duration(seconds: 1));
      await client.loggingDisabled.logInfo('test');
      await Future<void>.delayed(const Duration(seconds: 1));

      logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));
      expect(
          logResult.sessionLog[0].sessionLogEntry.endpoint, equals('logging'));
      expect(logResult.sessionLog[0].sessionLogEntry.method, equals('logInfo'));
    });

    test('Future call logging', () async {
      // Set log level to info
      service.RuntimeSettings settings = service.RuntimeSettings(
        logSettings: service.LogSettings(
          logAllSessions: true,
          logSlowSessions: true,
          logFailedSessions: true,
          logAllQueries: true,
          logSlowQueries: true,
          logFailedQueries: true,
          slowSessionDuration: 1.0,
          slowQueryDuration: 1.0,
          logLevel: service.LogLevel.info.index,
        ),
        logMalformedCalls: true,
        logServiceCalls: false,
        logSettingsOverrides: <service.LogSettingsOverride>[],
      );
      await serviceClient.insights.setRuntimeSettings(settings);

      await client.futureCalls.makeFutureCall(SimpleData(num: 42));

      // Make sure that the future call has been executed
      // The check for future calls is made very 5 s and future call is set for
      // 1 s. Largest possible delay should be 6 s.
      await Future<void>.delayed(const Duration(seconds: 6));

      service.SessionLogResult logResult =
          await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      expect(logResult.sessionLog[0].messageLog.length, equals(1));
      expect(logResult.sessionLog[0].messageLog[0].message, equals('42'));
      expect(
          logResult.sessionLog[0].sessionLogEntry.method, equals('testCall'));
    });
  });
}

class ServiceKeyManager extends AuthenticationKeyManager {
  final String name;
  final String serviceSecret;

  ServiceKeyManager(this.name, this.serviceSecret);

  @override
  Future<String> get() async {
    return 'name:$serviceSecret';
  }

  @override
  Future<void> put(String key) async {}

  @override
  Future<void> remove() async {}
}
