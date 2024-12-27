import 'package:test/test.dart';

import '../serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given no test tag override when test is run',
    (sessionBuilder, endpoints) {
      test('then dummy test passes', () async {
        expect(true, true);
      });
    },
  );
}
