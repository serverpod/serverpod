import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/builders/log_settings_builder.dart';
import 'package:serverpod_test_server/test_util/builders/runtime_settings_builder.dart';
import 'package:serverpod_test_server/test_util/logging_utils.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  var client = Client('http://localhost:8080/');
  late Serverpod server;
  late Session session;

  setUp(() async {
    server = IntegrationTestServer.create();
    await server.start();

    session = await server.createSession(enableLogging: false);
    await LoggingUtil.clearAllLogs(session);
  });

  tearDown(() async {
    await session.close();
    await server.shutdown(exitProcess: false);
  });

  test(
    'Given that the log settings are turned down but there is an override for the endpoint to allow all logging when calling a method then a log is written.',
    () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(LogSettingsBuilder().withLoggingTurnedDown().build())
          .withLogSettingsOverride(
            endpoint: 'logging',
            logSettings: LogSettingsBuilder().build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.emptyMethod();

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.sessionLogEntry.endpoint, 'logging');
    },
  );

  test(
    'Given that the log settings are turned down but there is an override for the endpoint to allow all logging when calling another endpoint then no log is written.',
    () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(LogSettingsBuilder().withLoggingTurnedDown().build())
          .withLogSettingsOverride(
            endpoint: 'authentication',
            logSettings: LogSettingsBuilder().build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.emptyMethod();

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, isEmpty);
    },
  );

  test(
    'Given that the log settings are turned down but there is an override for the endpoint and method to allow all logging when calling a method then a log is written.',
    () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(LogSettingsBuilder().withLoggingTurnedDown().build())
          .withLogSettingsOverride(
            endpoint: 'logging',
            method: 'emptyMethod',
            logSettings: LogSettingsBuilder().build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.emptyMethod();

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.sessionLogEntry.endpoint, 'logging');
      expect(logs.first.sessionLogEntry.method, 'emptyMethod');
    },
  );

  test(
    'Given that the log settings are turned down but there is an override for the endpoint and method to allow all logging when calling another method then not log is written.',
    () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(LogSettingsBuilder().withLoggingTurnedDown().build())
          .withLogSettingsOverride(
            endpoint: 'logging',
            method: 'slowMethod',
            logSettings: LogSettingsBuilder().build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.emptyMethod();

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, isEmpty);
    },
  );
}
