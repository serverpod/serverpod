import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with mixed fields defaults",
    () {
      test(
        'when the field has both "default" and "defaultModel", then the field value should be the "defaultModel" value',
        () {
          var object = StringDefaultMix();
          expect(
            object.stringDefaultAndDefaultModel,
            equals('This is a default model value'),
          );
        },
      );

      test(
        'when the field has both "default" and "defaultPersist", then the field value should be the "default" value',
        () {
          var object = StringDefaultMix();
          expect(
            object.stringDefaultAndDefaultPersist,
            equals('This is a default value'),
          );
        },
      );

      test(
        'when the field has both "defaultModel" and "defaultPersist", then the field value should be the "defaultModel" value',
        () {
          var object = StringDefaultMix();
          expect(
            object.stringDefaultModelAndDefaultPersist,
            equals('This is a default value'),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "stringDefaultAndDefaultModel", then the field value should match the provided value',
        () {
          var object = StringDefaultMix(
            stringDefaultAndDefaultModel: 'A specific value',
          );
          expect(
            object.stringDefaultAndDefaultModel,
            equals('A specific value'),
          );
        },
      );
    },
  );
}
