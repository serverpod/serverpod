// ignore_for_file: deprecated_member_use

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
      client.close();
      await session.close();
      await server.shutdown(exitProcess: false);
    });

    test(
      'Given that continuous logging is turned on when sending a stream message without closing the connection then the log is created.',
      () async {
        var settings = RuntimeSettingsBuilder()
            .withLogSettings(
              LogSettingsBuilder()
                  .withLogStreamingSessionsContinuously(true)
                  .build(),
            )
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
      },
    );

    test(
      'Given that continuous logging is turned on when sending a stream message and closing the connection then the log is created.',
      () async {
        var settings = RuntimeSettingsBuilder()
            .withLogSettings(
              LogSettingsBuilder()
                  .withLogStreamingSessionsContinuously(true)
                  .build(),
            )
            .build();
        await server.updateRuntimeSettings(settings);
        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        await client.logging.sendStreamMessage(Types());

        await client.closeStreamingConnection();

        // Wait for the log to be written
        await Future.delayed(Duration(milliseconds: 100));

        var logs = await LoggingUtil.findAllLogs(session);

        expect(logs, hasLength(1));
        expect(logs.first.messages, hasLength(1));
      },
    );

    test(
      'Given that continuous logging is turned on when sending a stream message and closing the connection then the log is created.',
      () async {
        var settings = RuntimeSettingsBuilder()
            .withLogSettings(
              LogSettingsBuilder()
                  .withLogStreamingSessionsContinuously(true)
                  .build(),
            )
            .build();
        await server.updateRuntimeSettings(settings);
        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        await client.logging.sendStreamMessage(Types());
        await client.logging.sendStreamMessage(Types());

        await client.closeStreamingConnection();

        // Wait for the log to be written
        await Future.delayed(Duration(milliseconds: 100));

        var logs = await LoggingUtil.findAllLogs(session);

        expect(logs, hasLength(1));
        expect(logs.first.messages, hasLength(2));
      },
    );

    test(
      'Given that continuous logging is turned on when sending several stream messages without closing the connection then the logs are created with different message ids.',
      () async {
        var settings = RuntimeSettingsBuilder()
            .withLogSettings(
              LogSettingsBuilder()
                  .withLogStreamingSessionsContinuously(true)
                  .build(),
            )
            .build();
        await server.updateRuntimeSettings(settings);
        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        await client.logging.sendStreamMessage(Types());
        await client.logging.sendStreamMessage(Types());

        // Wait for the log to be written
        await Future.delayed(Duration(milliseconds: 100));

        var logs = await LoggingUtil.findAllLogs(session);

        expect(logs, isNotEmpty);
        expect(logs.first.messages, isNotEmpty);

        expect(logs.first.messages.first.messageId, 0);
        expect(logs.first.messages.last.messageId, 1);
      },
    );

    test(
      'Given that continuous logging is turned on when sending a stream message and writing a log without closing then a messageId is attached to each log message.',
      () async {
        var settings = RuntimeSettingsBuilder()
            .withLogSettings(
              LogSettingsBuilder()
                  .withLogStreamingSessionsContinuously(true)
                  .build(),
            )
            .build();
        await server.updateRuntimeSettings(settings);
        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        await client.streamLogging.sendStreamMessage(Types());
        await client.streamLogging.sendStreamMessage(Types());

        // Wait for the log to be written
        await Future.delayed(Duration(milliseconds: 100));

        var logs = await LoggingUtil.findAllLogs(session);

        expect(logs, isNotEmpty);
        expect(logs.first.messages, isNotEmpty);
        expect(logs.first.logs, isNotEmpty);

        expect(logs.first.logs.first.messageId, 0);
        expect(logs.first.logs.last.messageId, 1);
      },
    );

    test(
      'Given that continuous logging is turned on when sending a stream message and writing a log without closing the stream then a query log is written.',
      () async {
        var settings = RuntimeSettingsBuilder()
            .withLogSettings(
              LogSettingsBuilder()
                  .withLogStreamingSessionsContinuously(true)
                  .build(),
            )
            .build();
        await server.updateRuntimeSettings(settings);
        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        await client.streamQueryLogging.sendStreamMessage(Types());

        // Wait for the log to be written
        await Future.delayed(Duration(milliseconds: 100));

        var logs = await LoggingUtil.findAllLogs(session);

        expect(logs, hasLength(1));
        expect(logs.first.messages, hasLength(1));
        expect(logs.first.queries, hasLength(1));
      },
    );

    test(
      'Given that continuous logging is turned on when sending a stream message and writing a log without closing the stream then the query logs has the messageId set.',
      () async {
        var settings = RuntimeSettingsBuilder()
            .withLogSettings(
              LogSettingsBuilder()
                  .withLogStreamingSessionsContinuously(true)
                  .build(),
            )
            .build();
        await server.updateRuntimeSettings(settings);
        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        await client.streamQueryLogging.sendStreamMessage(Types());
        await client.streamQueryLogging.sendStreamMessage(Types());

        // Wait for the log to be written
        await Future.delayed(Duration(milliseconds: 100));

        var logs = await LoggingUtil.findAllLogs(session);

        expect(logs, isNotEmpty);
        expect(logs.first.messages, isNotEmpty);
        expect(logs.first.queries, isNotEmpty);

        expect(logs.first.queries.first.messageId, 0);
        expect(logs.first.queries.last.messageId, 1);
      },
    );

    test(
      'Given that continuous logging is turned off when sending a stream message without closing the connection no log entries are created.',
      () async {
        var settings = RuntimeSettingsBuilder()
            .withLogSettings(
              LogSettingsBuilder()
                  .withLogStreamingSessionsContinuously(false)
                  .build(),
            )
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
      },
    );

    test(
      'Given that continuous logging is turned off when sending a stream message and then closing the connection a log entry is created containing the message.',
      () async {
        var settings = RuntimeSettingsBuilder()
            .withLogSettings(
              LogSettingsBuilder()
                  .withLogStreamingSessionsContinuously(false)
                  .build(),
            )
            .build();

        await server.updateRuntimeSettings(settings);
        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        await client.logging.sendStreamMessage(Types());
        await client.closeStreamingConnection();

        // Wait for the log to be written
        await Future.delayed(Duration(milliseconds: 100));

        var logs = await LoggingUtil.findAllLogs(session);

        expect(logs, hasLength(1));
        expect(logs.first.messages, hasLength(1));
      },
    );

    test(
      'Given that all logging is turned down when sending a stream message and then closing the connection no logs are written.',
      () async {
        var settings = RuntimeSettingsBuilder()
            .withLogSettings(
              LogSettingsBuilder().withLoggingTurnedDown().build(),
            )
            .build();

        await server.updateRuntimeSettings(settings);
        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        await client.logging.sendStreamMessage(Types());
        await client.closeStreamingConnection();

        // Wait for the log to potentially be written
        await Future.delayed(Duration(milliseconds: 100));

        var logs = await LoggingUtil.findAllLogs(session);

        expect(logs, isEmpty);
      },
    );

    test(
      'Given that all logging is turned down when but an override for the endpoint when sending a stream message to that endpoint and then closing the connection the logs are written.',
      () async {
        var settings = RuntimeSettingsBuilder()
            .withLogSettings(
              LogSettingsBuilder().withLoggingTurnedDown().build(),
            )
            .withLogSettingsOverride(
              endpoint: 'logging',
              logSettings: LogSettingsBuilder().build(),
            )
            .build();

        await server.updateRuntimeSettings(settings);
        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        await client.logging.sendStreamMessage(Types());
        await client.closeStreamingConnection();

        // Wait for the log to be written
        await Future.delayed(Duration(milliseconds: 100));

        var logs = await LoggingUtil.findAllLogs(session);

        expect(logs, hasLength(1));
        expect(logs.first.messages, hasLength(1));
      },
    );

    test(
      'Given that all logging is turned down when but an override for the endpoint when sending a stream message to another endpoint and then closing the connection no logs are written.',
      () async {
        var settings = RuntimeSettingsBuilder()
            .withLogSettings(
              LogSettingsBuilder().withLoggingTurnedDown().build(),
            )
            .withLogSettingsOverride(
              endpoint: 'authentication',
              logSettings: LogSettingsBuilder().build(),
            )
            .build();

        await server.updateRuntimeSettings(settings);
        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );

        await client.logging.sendStreamMessage(Types());
        await client.closeStreamingConnection();

        // Wait for the log to be written
        await Future.delayed(Duration(milliseconds: 100));

        var logs = await LoggingUtil.findAllLogs(session);

        expect(logs, isEmpty);
      },
    );
  });
}
