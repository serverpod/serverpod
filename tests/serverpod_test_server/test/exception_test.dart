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
    const unknownErrorUserId = 0;
    const failureUserId = -1;
    test('Working without exception', () async {
      expect(await client.exceptionApproach.checkUserExist(successUserId),
          'Success');
    });
    test('Working with ServerpodException exception', () async {
      dynamic exception;
      try {
        await client.exceptionApproach.checkUserExist(unknownErrorUserId);
      } catch (e) {
        exception = e;
      }

      expect(exception is test_client.ServerpodException, true);
    });

    test('Working with UserNotFoundException exception', () async {
      dynamic exception;
      try {
        await client.exceptionApproach.checkUserExist(failureUserId);
      } catch (e) {
        exception = e;
      }

      expect(exception is test_client.UserNotFound, true);
    });

    test('Catch specific type', () async {
      String message = '';
      try {
        await client.exceptionApproach.checkUserExist(failureUserId);
      } on test_client.UserNotFound catch (e) {
        message = e.message;
      }

      expect(message, 'User with id: $failureUserId not found');
    });
  });
}
