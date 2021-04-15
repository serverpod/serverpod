import 'package:test/test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart' as service;
import 'package:serverpod_client/src/auth_key_manager.dart';

void main() {
  var client = Client('http://localhost:8080/');
  var serviceClient = service.Client(
      'https://localhost:8081/',
      authenticationKeyManager: ServiceKeyManager('0', 'password'),
  );

  group('Logging', () {
    test('Set runtime settings', () async {
      // Log everything
      var settings = service.RuntimeSettings(
        logAllCalls: true,
        logSlowCalls: true,
        logFailedCalls: false,
        logAllQueries: true,
        logSlowQueries: true,
        logFailedQueries: true,
        logMalformedCalls: true,
        slowCallDuration: 1.0,
        slowQueryDuration: 1.0,
        logLevel: service.LogLevel.debug.index,
      );

      await serviceClient.insights.setRuntimeSettings(settings);

      settings = await serviceClient.insights.getRuntimeSettings();
      expect(settings.logFailedCalls, equals(false));

      settings.logFailedCalls = true;
      await serviceClient.insights.setRuntimeSettings(settings);
      settings = await serviceClient.insights.getRuntimeSettings();
      expect(settings.logFailedCalls, equals(true));
    });

    test('Clear logs', () async {
      // Make sure there is at least 10 log entries
      for (int i = 0; i < 10; i += 1) {
        await client.logging.logInfo('Log test $i');
      }

      service.SessionLogResult logResult = await serviceClient.insights.getSessionLog(10);
      expect(logResult.sessionLog.length, equals(10));

      await serviceClient.insights.clearAllLogs();

      logResult = await serviceClient.insights.getSessionLog(10);
      // Expect 1 entry as the clean logs call will be logged
      expect(logResult.sessionLog.length, equals(1));
    });

    test('Log entry', () async {
      await client.logging.logInfo('test');

      var logResult = await serviceClient.insights.getSessionLog(1);
      expect(logResult.sessionLog.length, equals(1));

      expect(logResult.sessionLog[0].messageLog.length, equals(1));
      expect(logResult.sessionLog[0].messageLog[0].message, equals('test'));
    });
  });
}



class ServiceKeyManager extends AuthenticationKeyManager {
  final String name;
  final String serviceSecret;

  ServiceKeyManager(this.name, this.serviceSecret);

  Future<String> get() async {
    return 'name:$serviceSecret';
  }
  Future<Null> put(String key) async {
  }
}