@OnPlatform({
  'browser': Skip('Asserts the dart:io transport, which has no cookie jar'),
})
library;

import 'package:test/test.dart';

import 'test_utils/test_serverpod_client.dart';

void main() {
  late TestServerpodClient client;

  setUp(() {
    client = TestServerpodClient(host: Uri.parse('http://localhost:8080'));
  });

  tearDown(() => client.close());

  test(
    'Given a client on a transport without a cookie jar '
    'when cookie auth is enabled '
    'then it fails loudly at configuration time.',
    () {
      expect(
        () => client.cookieAuth = true,
        throwsA(isA<UnsupportedError>()),
      );
      expect(client.cookieAuth, isFalse);
    },
  );

  test(
    'Given a client on a platform without cross-tab locks '
    'when accessing authRefreshCrossTabLock '
    'then it is null.',
    () {
      expect(client.authRefreshCrossTabLock, isNull);
    },
  );
}
