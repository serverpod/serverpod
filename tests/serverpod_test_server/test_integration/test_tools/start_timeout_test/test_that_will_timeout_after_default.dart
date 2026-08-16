import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given that runMode is set to staging when calling withServerpod',
    // The staging config has intentionally been set to not find the database and provoke timeout.
    runMode: ServerpodRunMode.staging,
    (sessionBuilder, endpoints) {
      test(
        'then dummy test should not be run and exit code should be non-zero',
        () async {
          expect(true, true);
        },
      );
    },
  );
}
