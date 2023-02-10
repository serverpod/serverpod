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
    test('Working without exception', () async {
      expect(await client.exceptionTest.workingWithoutException(), 'Success');
    });
    test('Working with SerializableException', () async {
      dynamic exception;
      try {
        await client.exceptionTest.throwSerializableException();
      } catch (e) {
        exception = e;
      }

      expect(exception is test_client.SerializableException, true);
    });

    test('Working with ExceptionWithData exception', () async {
      dynamic exception;
      try {
        await client.exceptionTest.throwExceptionWithData();
      } catch (e) {
        exception = e;
      }

      expect(exception is test_client.ExceptionWithData, true);
    });

    test('Catch specific type', () async {
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
