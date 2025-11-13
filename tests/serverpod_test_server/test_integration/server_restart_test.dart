import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/mock_stdout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  late Serverpod serverpod;

  setUp(() {
    serverpod = IntegrationTestServer.create();
  });

  tearDown(() async {
    await serverpod.shutdown(exitProcess: false);
  });

  test(
    'Given a running Serverpod server when it is shutdown and restarted then it can be successfully started again.',
    () async {
      await serverpod.start();

      await serverpod.shutdown(exitProcess: false);

      await expectLater(serverpod.start(), completes);
    },
  );

  test(
    'Given a running Serverpod server when it is shutdown and started then database request can be made.',
    () async {
      await serverpod.start();

      await serverpod.shutdown(exitProcess: false);
      await serverpod.start();

      var session = await serverpod.createSession();
      // ignore: invalid_use_of_internal_member
      await expectLater(session.db.testConnection(), completion(true));
    },
  );

  test(
    'Given a running Serverpod server when it is shutdown and started then no error is written to stderr.',
    () async {
      var record = MockStdout();
      await IOOverrides.runZoned(() async {
        await serverpod.start();

        await serverpod.shutdown(exitProcess: false);

        await expectLater(serverpod.start(), completes);
      }, stderr: () => record);

      expect(record.output, isEmpty);
    },
  );
}
