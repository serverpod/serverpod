import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/builders/log_settings_builder.dart';
import 'package:serverpod_test_server/test_util/builders/runtime_settings_builder.dart';
import 'package:serverpod_test_server/test_util/custom_matcher.dart';
import 'package:serverpod_test_server/test_util/logging_utils.dart';
import 'package:serverpod_test_server/test_util/mock_stdout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

List<int> toLogLevelInts(List<LogLevel> levels) {
  return levels.map((e) => e.toJson()).toList();
}

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
      await session.close();
      await server.shutdown(exitProcess: false);
    });

    test(
        'Given a log settings that enables all logging when calling a noop method then a single log entry is created.',
        () async {
      var settings = RuntimeSettingsBuilder().build();
      await server.updateRuntimeSettings(settings);

      await client.logging.emptyMethod();

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.sessionLogEntry.endpoint, 'logging');
      expect(logs.first.sessionLogEntry.method, 'emptyMethod');
    });

    test(
        'Given a restricted log setting when calling a noop method then no log entries are created.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(
            LogSettingsBuilder().withLoggingTurnedDown().build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.emptyMethod();

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, isEmpty);
    });

    test(
        'Given a log setting that enables slow session logging when calling a slow method then a single log entry is created.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(
            LogSettingsBuilder()
                .withLoggingTurnedDown()
                .withLogSlowSessions(true)
                .withSlowSessionDuration(0.5)
                .build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.emptyMethod();
      await client.logging.slowMethod(500);

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.sessionLogEntry.endpoint, 'logging');
      expect(logs.first.sessionLogEntry.method, 'slowMethod');
    });

    test(
        'Given a log setting that enables failed session logging when calling a method that throws then a single log entry is created.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(
            LogSettingsBuilder()
                .withLoggingTurnedDown()
                .withLogFailedSessions(true)
                .build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.emptyMethod();

      try {
        await client.logging.failingMethod();
      } catch (_) {}

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.sessionLogEntry.endpoint, 'logging');
      expect(logs.first.sessionLogEntry.method, 'failingMethod');
    });

    test(
        'Given a log setting that enables slow query logging when calling a slow query method then a single log entry is created.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(
            LogSettingsBuilder()
                .withLoggingTurnedDown()
                .withLogSlowSessions(true)
                .withSlowQueryDuration(0.5)
                .build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.emptyMethod();
      await client.logging.slowQueryMethod(1);

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.sessionLogEntry.endpoint, 'logging');
      expect(logs.first.sessionLogEntry.method, 'slowQueryMethod');
    });

    test(
        'Given a log setting that enables all logs when calling a method executing a query then a query log is created',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(
            LogSettingsBuilder().build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.queryMethod(1);

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.queries, hasLength(1));
      expect(logs.first.sessionLogEntry.numQueries, 1);
    });

    test(
        'Given a log setting that enables all logs when calling a method executing several queries then a log for each query is created',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(
            LogSettingsBuilder().build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.queryMethod(4);

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.queries, hasLength(4));
      expect(logs.first.sessionLogEntry.numQueries, 4);
    });

    test(
        'Given a log setting that turns off all database query logging when calling a method executing several queries then the number of queries are still counted.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(
            LogSettingsBuilder()
                .withLoggingTurnedDown()
                .withLogAllSessions(true)
                .build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.queryMethod(4);

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.queries, isEmpty);
      expect(logs.first.sessionLogEntry.numQueries, 4);
    });

    test(
        'Given a log setting that enables failed query logging when calling a method executing an invalid query then a single log entry is created.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(
            LogSettingsBuilder()
                .withLoggingTurnedDown()
                .withLogFailedQueries(true)
                .build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.emptyMethod();

      try {
        await client.logging.failedQueryMethod();
      } catch (_) {}

      await Future.delayed(Duration(milliseconds: 100));

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.sessionLogEntry.endpoint, 'logging');
      expect(logs.first.sessionLogEntry.method, 'failedQueryMethod');
    });

    test(
        'Given a log setting with everything turned on when calling a method logging a message then the log including the message log is written.',
        () async {
      var settings = RuntimeSettingsBuilder().build();

      await server.updateRuntimeSettings(settings);

      await client.logging.log('message', [LogLevel.debug.toJson()]);

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.sessionLogEntry.endpoint, 'logging');
      expect(logs.first.sessionLogEntry.method, 'log');

      expect(logs.first.logs, hasLength(1));
    });

    test(
        'Given a log setting with everything turned on when calling a method logging a message then the logs messageId is null.',
        () async {
      var settings = RuntimeSettingsBuilder().build();

      await server.updateRuntimeSettings(settings);

      await client.logging.log('message', [LogLevel.debug.toJson()]);

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, isNotEmpty);

      expect(logs.first.logs, isNotEmpty);
      expect(logs.first.logs.first.messageId, isNull);
    });

    test(
        'Given a log setting with everything turned on but only accepting info level and below when calling a method logging a message then the log is written but only includes the info level message.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(
            LogSettingsBuilder().withLogLevel(LogLevel.info).build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging
          .log('message', toLogLevelInts([LogLevel.debug, LogLevel.info]));

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.sessionLogEntry.endpoint, 'logging');
      expect(logs.first.sessionLogEntry.method, 'log');

      expect(logs.first.logs, hasLength(1));
      expect(logs.first.logs.first.logLevel, LogLevel.info);
    });

    test(
        'Given a log setting with everything turned on but only accepting warning level and below when calling a method logging a message then the log is written but only includes the warning level message.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(
            LogSettingsBuilder().withLogLevel(LogLevel.warning).build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.log(
        'message',
        toLogLevelInts([
          LogLevel.debug,
          LogLevel.info,
          LogLevel.warning,
        ]),
      );

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.sessionLogEntry.endpoint, 'logging');
      expect(logs.first.sessionLogEntry.method, 'log');

      expect(logs.first.logs, hasLength(1));
      expect(logs.first.logs.first.logLevel, LogLevel.warning);
    });

    test(
        'Given a log setting with everything turned on but only accepting error level and below when calling a method logging a message then the log is written but only includes the error level message.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(
            LogSettingsBuilder().withLogLevel(LogLevel.error).build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.log(
        'message',
        toLogLevelInts([
          LogLevel.debug,
          LogLevel.info,
          LogLevel.warning,
          LogLevel.error,
        ]),
      );

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.sessionLogEntry.endpoint, 'logging');
      expect(logs.first.sessionLogEntry.method, 'log');

      expect(logs.first.logs, hasLength(1));
      expect(logs.first.logs.first.logLevel, LogLevel.error);
    });

    test(
        'Given a log setting with everything turned on but only accepting fatal level and below when calling a method logging a message then the log is written but only includes the fatal level message.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(
            LogSettingsBuilder().withLogLevel(LogLevel.fatal).build(),
          )
          .build();

      await server.updateRuntimeSettings(settings);

      await client.logging.log(
        'message',
        toLogLevelInts([
          LogLevel.debug,
          LogLevel.info,
          LogLevel.warning,
          LogLevel.error,
          LogLevel.fatal,
        ]),
      );

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));

      expect(logs.first.sessionLogEntry.endpoint, 'logging');
      expect(logs.first.sessionLogEntry.method, 'log');

      expect(logs.first.logs, hasLength(1));
      expect(logs.first.logs.first.logLevel, LogLevel.fatal);
    });
  });

  group('JSON Stdout logger -', () {
    late MockStdout record;

    setUp(() async {
      record = MockStdout();

      server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: ServerConfig(
            port: 8080,
            publicHost: 'localhost',
            publicPort: 8080,
            publicScheme: 'http',
          ),
          sessionLogs: SessionLogConfig(
            persistentEnabled: false,
            consoleEnabled: true,
            consoleLogFormat: ConsoleLogFormat.json,
          ),
        ),
      );

      await IOOverrides.runZoned(() async {
        await server.start();
      }, stdout: () => record);
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
    });

    group(
        'Given a log settings that enable all logging and the serverpod config does not have a database config when calling a noop method ',
        () {
      setUp(() async {
        var settings = RuntimeSettingsBuilder().build();
        await server.updateRuntimeSettings(settings);

        await client.logging.emptyMethod();
      });

      test('then two entries are pushed to stdout.', () {
        expect(record.output, containsCount('"endpoint":"logging"', 2));
        expect(record.output, containsCount('"method":"emptyMethod"', 2));
      });

      test('then a session open entry is pushed to stdout.', () {
        // "isOpen" is true as long as the session is open.
        expect(record.output, containsCount('"isOpen":true', 1));
      });

      test('then a session closed entry is pushed to stdout.', () {
        // "isOpen" is false when the session is closed and "duration" is set.
        expect(record.output, containsCount('"isOpen":false', 1));
        expect(record.output, containsCount('"duration"', 1));
      });
    });
  });

  group('Text Stdout logger -', () {
    late MockStdout record;

    setUp(() async {
      record = MockStdout();

      server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: ServerConfig(
            port: 8080,
            publicHost: 'localhost',
            publicPort: 8080,
            publicScheme: 'http',
          ),
          sessionLogs: SessionLogConfig(
            persistentEnabled: false,
            consoleEnabled: true,
            consoleLogFormat: ConsoleLogFormat.text,
          ),
        ),
      );

      await IOOverrides.runZoned(() async {
        await server.start();
      }, stdout: () => record);
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
    });

    group(
        'Given a log settings that enable all logging to the text logger when calling a noop method ',
        () {
      setUp(() async {
        var settings = RuntimeSettingsBuilder().build();
        await server.updateRuntimeSettings(settings);

        await client.logging.emptyMethod();
      });

      test('then a single text log entry is pushed to stdout in text format.',
          () {
        expect(
          record.output,
          containsCount(
            '${'METHOD'.padRight(14)} logging.emptyMethod',
            1,
          ),
        );
      });
    });
  });
}
