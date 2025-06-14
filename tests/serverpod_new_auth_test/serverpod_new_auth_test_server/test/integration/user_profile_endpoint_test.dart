import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given no users', (final sessionBuilder, final endpoints) {
    test(
        'when calling "get Profile" with an unauthenticated user then an error, then an error is thrown',
        () async {
      await expectLater(
        () => endpoints.userProfile.get(sessionBuilder),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test(
        'when calling "get Profile" with an unauthenticated user then an error, then an error is thrown',
        () async {
      await expectLater(
        () => endpoints.userProfile.get(sessionBuilder),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });
  });
}
