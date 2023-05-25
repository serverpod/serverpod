import 'package:serverpod_test_client/serverpod_test_client.dart'
    as test_client;
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import 'config.dart';

void main() {
  var client = test_client.Client(
    serverUrl,
  );

  setUp(() {});

  group('Exception tests', () {
    test('Sending normal primitive data', () async {
      expect(await client.exceptionTest.workingWithoutException(), 'Success');
    });
    test('Serialize and deserialize custom server exception type', () async {
      dynamic exception;
      try {
        await client.exceptionTest.throwExceptionWithData();
      } catch (e) {
        exception = e;
      }

      expect(exception.runtimeType, test_client.ExceptionWithData);
    });

    test('Serialize and deserialize custom server exception with data', () async {
      ExceptionWithData? exceptionWithData;
      try {
        await client.exceptionTest.throwExceptionWithData();
      } on test_client.ExceptionWithData catch (e) {
        exceptionWithData = e;
      }

      expect(exceptionWithData?.message, 'Throwing an exception');
      expect(exceptionWithData?.errorFields, [
        'first line error',
        'second line error',
      ]);
      expect(exceptionWithData?.someNullableField, 1);
    });
  });
}
