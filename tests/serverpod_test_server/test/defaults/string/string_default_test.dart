import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'default' fields",
    () {
      test(
        'when an object of the class is created, then the "stringDefault" field should match the default value',
        () {
          var object = StringDefault();
          expect(
            object.stringDefault,
            equals('This is a default value'),
          );
        },
      );

      test(
        'when an object of the class is created, then the "stringDefaultNull" field should match the default value',
        () {
          var object = StringDefault();
          expect(
            object.stringDefaultNull,
            equals('This is a default null value'),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "stringDefault", then the field value should match the provided value',
        () {
          var object = StringDefault(
            stringDefault: 'A specific value',
          );
          expect(
            object.stringDefault,
            equals('A specific value'),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "stringDefaultNull", then the field value should match the provided value',
        () {
          var object = StringDefault(
            stringDefaultNull: 'A specific null value',
          );
          expect(
            object.stringDefaultNull,
            equals('A specific null value'),
          );
        },
      );

      test(
        'when an object is created from JSON with missing "stringDefault" key, then the field should have the default value.',
        () {
          var object = StringDefault.fromJson({});
          expect(
            object.stringDefault,
            equals('This is a default value'),
          );
        },
      );

      test(
        'when an object is created from JSON with missing "stringDefaultNull" key, then the field should have the default value.',
        () {
          var object = StringDefault.fromJson({});
          expect(
            object.stringDefaultNull,
            equals('This is a default null value'),
          );
        },
      );

      test(
        'when an object is created from JSON with explicit values, then the fields should match the provided values.',
        () {
          var object = StringDefault.fromJson({
            'stringDefault': 'Custom value',
            'stringDefaultNull': 'Custom null value',
          });
          expect(
            object.stringDefault,
            equals('Custom value'),
          );
          expect(
            object.stringDefaultNull,
            equals('Custom null value'),
          );
        },
      );
    },
  );
}
