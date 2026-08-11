@TestOn('browser')
library;

import 'package:serverpod_client/src/web_locks_cross_tab_lock.dart';
import 'package:test/test.dart';

import '../test_utils/test_serverpod_client.dart';

void main() {
  test(
    'Given a browser client with a URL prefix in the host '
    'when accessing authRefreshCrossTabLock '
    'then the lock name is scoped by origin and base path.',
    () {
      final client = TestServerpodClient(
        host: Uri.parse('http://localhost:8080/api/'),
      );
      addTearDown(client.close);

      final lock = client.authRefreshCrossTabLock;

      expect(
        (lock as WebLocksCrossTabLock).name,
        'serverpod-auth-refresh:http://localhost:8080/api',
      );
    },
  );

  test(
    'Given a browser client with the host at the domain root '
    'when accessing authRefreshCrossTabLock '
    'then the lock name ends with the root path.',
    () {
      final client = TestServerpodClient(
        host: Uri.parse('http://localhost:8080'),
      );
      addTearDown(client.close);

      final lock = client.authRefreshCrossTabLock;

      expect(
        (lock as WebLocksCrossTabLock).name,
        'serverpod-auth-refresh:http://localhost:8080/',
      );
    },
  );

  test(
    'Given a browser client '
    'when accessing authRefreshCrossTabLock twice '
    'then the same lock instance is returned.',
    () {
      final client = TestServerpodClient(
        host: Uri.parse('http://localhost:8080'),
      );
      addTearDown(client.close);

      expect(
        identical(
          client.authRefreshCrossTabLock,
          client.authRefreshCrossTabLock,
        ),
        isTrue,
      );
    },
  );
}
