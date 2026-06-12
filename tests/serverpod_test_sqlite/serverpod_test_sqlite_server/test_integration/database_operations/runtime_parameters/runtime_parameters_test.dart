import 'package:serverpod_shared/log.dart';
import 'package:serverpod_test_sqlite_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given server with runtime parameters builder, '
    'when creating the server, '
    'then a warning is logged since SQLite does not support SET runtime parameters.',
    () async {
      final testWriter = TestLogWriter();
      logWriter.add(testWriter);
      addTearDown(() => logWriter.remove(testWriter));

      IntegrationTestServer(
        runtimeParametersBuilder: (params) => [],
      );

      await log.flush();

      var warnings = testWriter.entries
          .where((e) => e.level == LogLevel.warning)
          .map((e) => e.message)
          .toList();

      expect(
        warnings,
        contains(
          'Runtime parameters are not supported on SQLite and will be ignored.',
        ),
      );
    },
  );
}
