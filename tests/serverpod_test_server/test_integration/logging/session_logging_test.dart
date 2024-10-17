import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/builders/runtime_settings_builder.dart';
import 'package:serverpod_test_server/test_util/logging_utils.dart';
import 'package:serverpod_test_server/test_util/mock_stdout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var runMode = 'production';

  group('Given persistent logging is enabled and console logging is disabled',
      () {
    late Serverpod server;
    late Session session;
    late MockStdout record;

    setUp(() async {
      record = MockStdout();

      server = IntegrationTestServer.create(
        config: ServerpodConfig(
          runMode: runMode,
          apiServer: ServerConfig(
            port: 8080,
            publicHost: 'localhost',
            publicPort: 8080,
            publicScheme: 'http',
          ),
          database: DatabaseConfig(
            host: 'postgres',
            port: 5432,
            user: 'postgres',
            password: 'password',
            name: 'serverpod_test',
          ),
          sessionLogs: SessionLogConfig(
            persistentEnabled: true,
            consoleEnabled: false,
          ),
        ),
      );
      await server.start();
      session = await server.createSession(enableLogging: false);
      await LoggingUtil.clearAllLogs(session);
    });

    tearDown(() async {
      await session.close();
      await server.shutdown(exitProcess: false);
    });

    test(
        'when a log is written then it should be stored in the database and not in stdout.',
        () async {
      var settings = RuntimeSettingsBuilder().build();
      await server.updateRuntimeSettings(settings);

      await IOOverrides.runZoned(
        () async {
          var testSession = await server.createSession(enableLogging: true);
          testSession.log('Test message');
          await testSession.close();
        },
        stdout: () => record,
      );

      var logs = await LoggingUtil.findAllLogs(session);
      expect(logs, hasLength(1));
      expect(logs.first.logs.first.message, 'Test message');

      expect(record.output.contains('Test message'), isFalse);
    });

    test('when logging is disabled at runtime, then no log should be written.',
        () async {
      var settings = RuntimeSettingsBuilder().build();
      await server.updateRuntimeSettings(settings);

      await IOOverrides.runZoned(
        () async {
          var testSession = await server.createSession(enableLogging: false);
          testSession.log('Test message');
          await testSession.close();
        },
        stdout: () => record,
      );

      var logs = await LoggingUtil.findAllLogs(session);
      expect(logs, isEmpty);

      expect(record.output.contains('Test message'), isFalse);
    });
  });

  group('Given persistent logging is disabled and console logging is enabled',
      () {
    late Serverpod server;
    late Session session;
    late MockStdout record;
    setUp(() async {
      record = MockStdout();

      server = IntegrationTestServer.create(
        config: ServerpodConfig(
          runMode: runMode,
          apiServer: ServerConfig(
            port: 8080,
            publicHost: 'localhost',
            publicPort: 8080,
            publicScheme: 'http',
          ),
          database: DatabaseConfig(
            host: 'postgres',
            port: 5432,
            user: 'postgres',
            password: 'password',
            name: 'serverpod_test',
          ),
          sessionLogs: SessionLogConfig(
            persistentEnabled: false,
            consoleEnabled: true,
          ),
        ),
      );
      await server.start();
      session = await server.createSession(enableLogging: false);
      await LoggingUtil.clearAllLogs(session);
    });

    tearDown(() async {
      await session.close();
      await server.shutdown(exitProcess: false);
    });

    test(
        'when a log is written then it should not be stored in the database but should appear in stdout.',
        () async {
      var settings = RuntimeSettingsBuilder().build();
      await server.updateRuntimeSettings(settings);

      await IOOverrides.runZoned(
        () async {
          var testSession = await server.createSession(enableLogging: true);
          testSession.log('Test message for console');
          await testSession.close();
        },
        stdout: () => record,
      );

      var logs = await LoggingUtil.findAllLogs(session);
      expect(logs, isEmpty);

      expect(record.output.contains('Test message for console'), isTrue);
    });
  });

  group('Given both persistent and console logging are disabled', () {
    late Serverpod server;
    late Session session;
    late MockStdout record;
    setUp(() async {
      record = MockStdout();

      server = IntegrationTestServer.create(
        config: ServerpodConfig(
          runMode: runMode,
          apiServer: ServerConfig(
            port: 8080,
            publicHost: 'localhost',
            publicPort: 8080,
            publicScheme: 'http',
          ),
          database: DatabaseConfig(
            host: 'postgres',
            port: 5432,
            user: 'postgres',
            password: 'password',
            name: 'serverpod_test',
          ),
          sessionLogs: SessionLogConfig(
            persistentEnabled: false,
            consoleEnabled: false,
          ),
        ),
      );
      await server.start();
      session = await server.createSession(enableLogging: false);
      await LoggingUtil.clearAllLogs(session);
    });

    tearDown(() async {
      await session.close();
      await server.shutdown(exitProcess: false);
    });

    test(
        'when a log is written then no log should be written to the database or stdout.',
        () async {
      var settings = RuntimeSettingsBuilder().build();
      await server.updateRuntimeSettings(settings);

      await IOOverrides.runZoned(
        () async {
          var testSession = await server.createSession(enableLogging: true);
          testSession.log('Test message');
          await testSession.close();
        },
        stdout: () => record,
      );

      var logs = await LoggingUtil.findAllLogs(session);
      expect(logs, isEmpty);

      expect(record.output.contains('Test message'), isFalse);
    });
  });

  group(
      'Given persistent logging is enabled but the database support is not available',
      () {
    test(
        'when the server is started, then a StateError should be thrown due to lack of database support',
        () async {
      expect(
        () => IntegrationTestServer.create(
          config: ServerpodConfig(
            runMode: runMode,
            apiServer: ServerConfig(
              port: 8080,
              publicHost: 'localhost',
              publicPort: 8080,
              publicScheme: 'http',
            ),
            sessionLogs: SessionLogConfig(
              persistentEnabled: true,
              consoleEnabled: false,
            ),
          ),
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
    });
  });
}
