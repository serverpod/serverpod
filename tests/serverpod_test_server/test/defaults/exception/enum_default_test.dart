import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given an exception with 'default' fields",
    () {
      test(
        'when an exception is created, then the "defaultMessage" field should match the default value',
        () {
          var exception = DefaultException();
          expect(
            exception.defaultMessage,
            equals('Default error message'),
          );
        },
      );

      test(
        'when an exception is created, then the "defaultModelMessage" field should match the default value',
        () {
          var exception = DefaultException();
          expect(
            exception.defaultModelMessage,
            equals('Default model error message'),
          );
        },
      );

      test(
        'when an exception is created with a specific value for "defaultMessage", then the field value should match the provided value',
        () {
          var exception = DefaultException(
            defaultMessage: 'Custom error message',
          );
          expect(
            exception.defaultMessage,
            equals('Custom error message'),
          );
        },
      );

      test(
        'when an exception is created with a specific value for "defaultModelMessage", then the field value should match the provided value',
        () {
          var exception = DefaultException(
            defaultModelMessage: 'Custom model error message',
          );
          expect(
            exception.defaultModelMessage,
            equals('Custom model error message'),
          );
        },
      );
    },
  );
}
