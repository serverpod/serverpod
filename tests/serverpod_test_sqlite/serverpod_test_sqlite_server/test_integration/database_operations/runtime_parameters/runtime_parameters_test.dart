import 'package:serverpod_test_sqlite_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given server with runtime parameters builder', () {
    final serverBuilder = () => IntegrationTestServer(
      runtimeParametersBuilder: (params) => [],
    );

    test(
      'when creating the server '
      'then an exception is thrown since SQLite does not support SET runtime parameters.',
      () {
        // NOTE: The ideal would be to use throwsUnsupportedError, but the
        // Serverpod start catches it first and exits the process.
        expect(serverBuilder, isNot(completes));
      },
    );
  });
}
