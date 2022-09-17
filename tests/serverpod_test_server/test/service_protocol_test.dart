import 'package:serverpod_service_client/serverpod_service_client.dart'
    as service;
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

Future<void> setupTestData(Client client) async {
  await client.basicDatabase.deleteAllSimpleTestData();
  await client.basicDatabase.createSimpleTestData(100);
}

void main() {
  var client = Client('http://serverpod_test_server:8080/');
  var serviceClient = service.Client(
    'http://serverpod_test_server:8081/',
    authenticationKeyManager: ServiceKeyManager('0', 'password'),
  );

  group('Logging', () {
    test('Set runtime settings', () async {
      // Log everything
      var settings = service.RuntimeSettings(
        logSettings: service.LogSettings(
          logAllSessions: true,
          logSlowSessions: true,
          logFailedSessions: false,
          logStreamingSessionsContinuously: true,
          logAllQueries: true,
          logSlowQueries: true,
          logFailedQueries: true,
          slowSessionDuration: 1.0,
          slowQueryDuration: 1.0,
          logLevel: service.LogLevel.debug.index,
        ),
        logMalformedCalls: true,
        logServiceCalls: false,
        logSettingsOverrides: [],
      );

      await serviceClient.insights.setRuntimeSettings(settings);

      await Future.delayed(const Duration(seconds: 1));

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
      for (var i = 0; i < 10; i += 1) {
        await client.logging.logInfo('Log test $i');
      }

      var logResult = await serviceClient.insights.getSessionLog(10, null);
      expect(logResult.sessionLog.length, equals(10));

      await serviceClient.insights.clearAllLogs();

      logResult = await serviceClient.insights.getSessionLog(10, null);
      expect(logResult.sessionLog.length, equals(0));
    });

    test('Log entry', () async {
      await client.logging.logInfo('test');

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      expect(logResult.sessionLog[0].logs.length, equals(1));
      expect(logResult.sessionLog[0].logs[0].message, equals('test'));
    });

    test('All log levels', () async {
      await client.logging.logDebugAndInfoAndError('debug', 'info', 'error');

      // Writing of logs may still be going on after the call has returned,
      // wait a second to make sure the log has been flushed to the database
      await Future.delayed(const Duration(seconds: 1));

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      logResult.sessionLog[0].logs.sort((a, b) => a.order - b.order);

      expect(logResult.sessionLog[0].logs.length, equals(3));
      expect(logResult.sessionLog[0].logs[0].message, equals('debug'));
      expect(logResult.sessionLog[0].logs[1].message, equals('info'));
      expect(logResult.sessionLog[0].logs[2].message, equals('error'));
    });

    test('Long log message', () async {
      await client.logging.logInfo(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.');
    });

    test('Error log level', () async {
      // Set log level to error
      var settings = service.RuntimeSettings(
        logSettings: service.LogSettings(
          logAllSessions: true,
          logSlowSessions: true,
          logFailedSessions: true,
          logStreamingSessionsContinuously: true,
          logAllQueries: true,
          logSlowQueries: true,
          logFailedQueries: true,
          slowSessionDuration: 1.0,
          slowQueryDuration: 1.0,
          logLevel: service.LogLevel.error.index,
        ),
        logSettingsOverrides: [],
        logMalformedCalls: true,
        logServiceCalls: false,
      );
      await serviceClient.insights.setRuntimeSettings(settings);

      await client.logging.logDebugAndInfoAndError('debug', 'info', 'error');

      // Writing of logs may still be going on after the call has returned,
      // wait a second to make sure the log has been flushed to the database
      await Future.delayed(const Duration(seconds: 1));

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      // Debug and info logs should be ignored
      expect(logResult.sessionLog[0].logs.length, equals(1));
      expect(logResult.sessionLog[0].logs[0].message, equals('error'));
    });

    test('Query log', () async {
      await client.logging.twoQueries();

      // Writing of logs may still be going on after the call has returned,
      // wait a second to make sure the log has been flushed to the database
      await Future.delayed(const Duration(seconds: 1));

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      expect(logResult.sessionLog[0].queries.length, equals(2));
    });

    test('Transaction query log', () async {
      await setupTestData(client);
      await client.transactionsDatabase.updateInsertDelete(50, 500, 0);
      await Future.delayed(const Duration(seconds: 1));

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      expect(logResult.sessionLog[0].queries.length, equals(4));
    });

    test('Disabled logging', () async {
      await client.logging.logInfo('test');
      await Future.delayed(const Duration(seconds: 1));

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));
      expect(
          logResult.sessionLog[0].sessionLogEntry.endpoint, equals('logging'));
      expect(logResult.sessionLog[0].sessionLogEntry.method, equals('logInfo'));

      await client.logging.logInfo('test');
      await Future.delayed(const Duration(seconds: 1));
      await client.loggingDisabled.logInfo('test');
      await Future.delayed(const Duration(seconds: 1));

      logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));
      expect(
          logResult.sessionLog[0].sessionLogEntry.endpoint, equals('logging'));
      expect(logResult.sessionLog[0].sessionLogEntry.method, equals('logInfo'));
    });

    test('Future call logging', () async {
      // Set log level to info
      var settings = service.RuntimeSettings(
        logSettings: service.LogSettings(
          logAllSessions: true,
          logSlowSessions: true,
          logFailedSessions: true,
          logStreamingSessionsContinuously: true,
          logAllQueries: true,
          logSlowQueries: true,
          logFailedQueries: true,
          slowSessionDuration: 1.0,
          slowQueryDuration: 1.0,
          logLevel: service.LogLevel.info.index,
        ),
        logMalformedCalls: true,
        logServiceCalls: false,
        logSettingsOverrides: [],
      );
      await serviceClient.insights.setRuntimeSettings(settings);

      await client.futureCalls.makeFutureCall(SimpleData(num: 42));

      // Make sure that the future call has been executed
      // The check for future calls is made very 5 s and future call is set for
      // 1 s. Largest possible delay should be 6 s.
      await Future.delayed(const Duration(seconds: 6));

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      expect(logResult.sessionLog[0].logs.length, equals(1));
      expect(logResult.sessionLog[0].logs[0].message, equals('42'));
      expect(
          logResult.sessionLog[0].sessionLogEntry.method, equals('testCall'));
    });

    test('Slow call logging', () async {
      await client.failedCalls.slowCall();

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));
      expect(logResult.sessionLog[0].sessionLogEntry.slow, equals(true));
    });

    test('Exception logging', () async {
      await client.failedCalls.caughtException();
      await Future.delayed(const Duration(seconds: 1));

      var logResult = await serviceClient.insights.getSessionLog(1, null);

      logResult.sessionLog[0].logs.sort((a, b) => a.order - b.order);

      expect(logResult.sessionLog.length, equals(1));
      expect(logResult.sessionLog[0].logs.length, equals(3));
      expect(logResult.sessionLog[0].logs[0].error, isNotNull);
      expect(logResult.sessionLog[0].logs[0].stackTrace, isNotNull);
      expect(logResult.sessionLog[0].logs[2].error, isNull);
      expect(logResult.sessionLog[0].logs[2].stackTrace, isNull);
    });

    test('Logging in stream', () async {
      // Set log level to info
      var settings = service.RuntimeSettings(
        logSettings: service.LogSettings(
          logAllSessions: true,
          logSlowSessions: true,
          logFailedSessions: true,
          logStreamingSessionsContinuously: true,
          logAllQueries: true,
          logSlowQueries: true,
          logFailedQueries: true,
          slowSessionDuration: 1.0,
          slowQueryDuration: 1.0,
          logLevel: service.LogLevel.info.index,
        ),
        logMalformedCalls: true,
        logServiceCalls: false,
        logSettingsOverrides: [],
      );
      await serviceClient.insights.setRuntimeSettings(settings);

      await client.openStreamingConnection();

      for (var i = 0; i < 5; i += 1) {
        await client.streamingLogging.sendStreamMessage(SimpleData(num: 42));
      }

      await client.streamingLogging.sendStreamMessage(SimpleData(num: -1));

      for (var i = 0; i < 5; i += 1) {
        await client.streamingLogging.sendStreamMessage(SimpleData(num: 42));
      }

      await Future.delayed(const Duration(seconds: 1));

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));
      expect(logResult.sessionLog[0].sessionLogEntry.isOpen, equals(true));
      // We should have logged one entry when opening the stream and 11 when
      // sending messages.
      expect(logResult.sessionLog[0].logs.length, equals(12));

      // Expect 11 messages to have been sent
      expect(logResult.sessionLog[0].messages.length, equals(11));
      logResult.sessionLog[0].messages.sort((a, b) => a.order - b.order);

      // Expect us to find an exception in the 6th logged message
      expect(logResult.sessionLog[0].messages[5].error, isNotNull);
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

List<List<bool>> performIteration(List<List<bool>> board) {
  return [];
}
