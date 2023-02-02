import 'package:serverpod_test_client/serverpod_test_client.dart'
    as test_client;
import 'package:test/test.dart';

import 'config.dart';

void main() {
  var client = test_client.Client(
    serverUrl,
  );

  setUp(() {});

  group('Exception tests', () {
    const successUserId = 1;
    const failureUserId = -1;
    const unknownErrorUserId = 0;
    test('Working without exception', () async {
      expect(await client.exceptionApproach.checkUserExist(successUserId),
          'Success');
    });
    test('Working with ServerpodException exception', () async {
      expect(await client.exceptionApproach.checkUserExist(unknownErrorUserId),
          throwsA(const TypeMatcher<test_client.ServerpodException>()));
    });

    test('Working with UserNotFoundException exception', () async {
      expect(await client.exceptionApproach.checkUserExist(failureUserId),
          throwsA(const TypeMatcher<test_client.UserNotFound>()));
    });
  });
}
