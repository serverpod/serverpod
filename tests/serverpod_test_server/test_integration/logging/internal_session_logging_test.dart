import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/builders/runtime_settings_builder.dart';
import 'package:serverpod_test_server/test_util/logging_utils.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
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
      'Given an internal session with logging enabled when calling log then a log is written.',
      () async {
        var settings = RuntimeSettingsBuilder().build();
        await server.updateRuntimeSettings(settings);

        var testSession = await server.createSession(enableLogging: true);

        testSession.log('Test message');
        await testSession.close();

        var logs = await LoggingUtil.findAllLogs(session);

        expect(logs, hasLength(1));
        expect(logs.first.logs, hasLength(1));

        expect(logs.first.logs.first.message, 'Test message');
      },
    );

    test(
      'Given an internal session with logging disabled but the log settings on the highest level when calling log then no log is written.',
      () async {
        var settings = RuntimeSettingsBuilder().build();
        await server.updateRuntimeSettings(settings);

        var testSession = await server.createSession(enableLogging: false);

        testSession.log('Test message');

        await testSession.close();

        var logs = await LoggingUtil.findAllLogs(session);

        expect(logs, isEmpty);
      },
    );
  });
}
