import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/builders/runtime_settings_builder.dart';
import 'package:serverpod_test_server/test_util/logging_utils.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var client = Client('http://localhost:8080/');
  late Serverpod server;
  late Session session;

  group(
    'Given a session with slow method call when logging is enabled',
    () {
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
        'Given a slow method call when session is logged then time field should be set to start time not end time.',
        () async {
          var settings = RuntimeSettingsBuilder().build();
          await server.updateRuntimeSettings(settings);

          // Call a slow method that takes 500ms
          await client.logging.slowMethod(500);

          var logs = await LoggingUtil.findAllLogs(session);

          expect(logs, hasLength(1));

          var sessionLogEntry = logs.first.sessionLogEntry;

          // The time field should be the start time (not the end time)
          // If duration is set, then the session has completed
          expect(sessionLogEntry.duration, isNotNull);

          // The time field should represent the start time
          // Since the method took ~500ms, the difference between time and touched
          // should be approximately equal to the duration
          var timeDifference = sessionLogEntry.touched.difference(
            sessionLogEntry.time,
          );
          var durationInMillis = (sessionLogEntry.duration! * 1000).round();

          // Allow for some variance (within 100ms)
          expect(
            timeDifference.inMilliseconds,
            closeTo(durationInMillis, 100),
            reason:
                'time field should be the start time, not the end time. '
                'Expected difference: $durationInMillis ms, '
                'Actual difference: ${timeDifference.inMilliseconds} ms',
          );
        },
      );
    },
  );
}
