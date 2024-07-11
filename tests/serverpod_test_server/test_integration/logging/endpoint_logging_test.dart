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

  setUp(() async {
    server = IntegrationTestServer.create();
    await server.start();
    session = await server.createSession(enableLogging: false);

    await LoggingUtil.clearAllLogs(session);
  });

  tearDown(() async {
    await await session.close();
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
}
