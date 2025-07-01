import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'default' fields",
    () {
      test(
        'when an object of the class is created, then the "intDefault" field should match the default value',
        () {
          var object = IntDefault();
          expect(object.intDefault, equals(10));
        },
      );

      test(
        'when an object of the class is created, then the "intDefaultNull" field should match the default value',
        () {
          var object = IntDefault();
          expect(object.intDefaultNull, equals(20));
        },
      );

      test(
        'when an object of the class is created with a specific value for "intDefault", then the field value should match the provided value',
        () {
          var object = IntDefault(intDefault: 15);
          expect(object.intDefault, equals(15));
        },
      );

      test(
        'when an object of the class is created with a specific value for "intDefaultNull", then the field value should match the provided value',
        () {
          var object = IntDefault(intDefaultNull: 25);
          expect(object.intDefaultNull, equals(25));
        },
      );
    },
  );
}
