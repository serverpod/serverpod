import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultModel' fields",
    () {
      test(
        'when an object of the class is created, then the "stringDefaultModel" field should match the default value',
        () {
          var object = StringDefaultModel();
          expect(
            object.stringDefaultModel,
            equals('This is a default model value'),
          );
        },
      );

      test(
        'when an object of the class is created, then the "stringDefaultModelNull" field should match the default value',
        () {
          var object = StringDefaultModel();
          expect(
            object.stringDefaultModelNull,
            equals('This is a default model null value'),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "stringDefaultModel", then the field value should match the provided value',
        () {
          var object = StringDefaultModel(
            stringDefaultModel: 'A specific value',
          );
          expect(
            object.stringDefaultModel,
            equals('A specific value'),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "stringDefaultModelNull", then the field value should match the provided value',
        () {
          var object = StringDefaultModel(
            stringDefaultModelNull: 'Another specific value',
          );
          expect(
            object.stringDefaultModelNull,
            equals('Another specific value'),
          );
        },
      );
    },
  );
}
