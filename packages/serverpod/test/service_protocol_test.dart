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
      // Make sure there is at least one log entry
      await client.logging.logInfo('Log test');

      service.SessionLogResult logResult = await serviceClient.insights.getSessionLog(1);
      expect(logResult.sessionLog.length, equals(1));

      await serviceClient.insights.clearAllLogs();

      logResult = await serviceClient.insights.getSessionLog(1);
      expect(logResult.sessionLog.length, equals(0));
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