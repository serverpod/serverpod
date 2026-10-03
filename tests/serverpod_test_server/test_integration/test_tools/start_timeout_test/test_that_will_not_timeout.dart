import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given that runMode is set to test when calling withServerpod',
    // Starting Serverpod creates this group's database and applies the full
    // schema, which takes seconds - how many depends on the machine. This case
    // only asserts that a timeout long enough to cover startup does not fire,
    // so the timeout must stay well clear of any machine-speed bound.
    serverpodStartTimeout: Duration(seconds: 30),
    runMode: ServerpodRunMode.test,
    (sessionBuilder, endpoints) {
      test('then set up will not timeout and dummy test passes', () async {
        expect(true, true);
      });
    },
  );
}
