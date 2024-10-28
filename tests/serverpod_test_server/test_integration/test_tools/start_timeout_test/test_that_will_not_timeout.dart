import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given that runMode is set to test when calling withServerpod',
    serverpodStartTimeout: Duration(seconds: 4),
    runMode: ServerpodRunMode.test,
    (sessionBuilder, endpoints) {
      test('then set up will not timeout and dummy test passes', () async {
        expect(true, true);
      });
    },
  );
}
