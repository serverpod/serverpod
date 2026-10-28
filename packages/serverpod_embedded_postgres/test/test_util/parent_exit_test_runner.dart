import 'package:test/test.dart';

import 'parent_exit_owner.dart' as owner;

void main() {
  test('starts a shared postmaster for the test process', () async {
    await owner.startPostgres();
    // Like serverpod_test, leave the shared postmaster available to other
    // suites. Disposing this test isolate must not own database shutdown.
  });
}
