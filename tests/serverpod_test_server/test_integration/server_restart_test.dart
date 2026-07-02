import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/mock_stdout.dart';
import 'package:serverpod_test_server/test_util/redis_probe.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  final redisSkip = await redisSkipReason();

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
      await serverpod.startWithDatabase();

      await serverpod.shutdown(exitProcess: false);

      await expectLater(serverpod.startWithDatabase(), completes);
    },
  );

  test(
    'Given a running Serverpod server when it is shutdown and started then database request can be made.',
    () async {
      await serverpod.startWithDatabase();

      await serverpod.shutdown(exitProcess: false);
      await serverpod.startWithDatabase();

      var session = await serverpod.createSession();
      // ignore: invalid_use_of_internal_member
      await expectLater(session.db.testConnection(), completion(true));
    },
  );

  test(
    'Given a running Serverpod server when it is shutdown and started then no error is written to stderr.',
    // The empty-stderr assertion needs the configured redis reachable - the
    // server logs connect failures to stderr otherwise.
    skip: redisSkip,
    () async {
      var record = MockStdout();
      await IOOverrides.runZoned(() async {
        await serverpod.startWithDatabase();

        await serverpod.shutdown(exitProcess: false);

        await expectLater(serverpod.startWithDatabase(), completes);
      }, stderr: () => record);

      expect(record.output, isEmpty);
    },
  );
}
