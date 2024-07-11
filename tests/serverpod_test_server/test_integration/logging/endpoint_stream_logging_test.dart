import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/builders/log_settings_builder.dart';
import 'package:serverpod_test_server/test_util/builders/runtime_settings_builder.dart';
import 'package:serverpod_test_server/test_util/logging_utils.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var client = Client('http://localhost:8080/');
  late Serverpod server;
  late Session session;

  group('Database logger -', () {
    setUp(() async {
      server = IntegrationTestServer.create();
      await server.start();

      session = await server.createSession(enableLogging: false);
      await LoggingUtil.clearAllLogs(session);
    });

    tearDown(() async {
      await client.closeStreamingConnection();
      await await session.close();
      await server.shutdown(exitProcess: false);
    });

    test(
        'Given that continuous logging is turned on when sending a stream message without closing the connection then the log is created.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(LogSettingsBuilder()
              .withLogStreamingSessionsContinuously(true)
              .build())
          .build();
      await server.updateRuntimeSettings(settings);
      await client.openStreamingConnection(
        disconnectOnLostInternetConnection: false,
      );

      await client.logging.sendStreamMessage(Types());

      // Wait for the log to be written
      await Future.delayed(Duration(milliseconds: 100));

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));
      expect(logs.first.messages, hasLength(1));
    });

    test(
        'Given that continuous logging is turned off when sending a stream message without closing the connection no log entries are created.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(LogSettingsBuilder()
              .withLogStreamingSessionsContinuously(false)
              .build())
          .build();
      await server.updateRuntimeSettings(settings);
      await client.openStreamingConnection(
        disconnectOnLostInternetConnection: false,
      );

      await client.logging.sendStreamMessage(Types());

      // Wait for the log to be written
      await Future.delayed(Duration(milliseconds: 100));

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, isEmpty);
    });

    test(
        'Given that continuous logging is turned off when sending a stream message and then closing the connection a log entry is created containing the message.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(LogSettingsBuilder()
              .withLogStreamingSessionsContinuously(false)
              .build())
          .build();

      await server.updateRuntimeSettings(settings);
      await client.openStreamingConnection(
        disconnectOnLostInternetConnection: false,
      );

      await client.logging.sendStreamMessage(Types());
      await client.closeStreamingConnection();

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));
      expect(logs.first.messages, hasLength(1));
    });
  });
}
