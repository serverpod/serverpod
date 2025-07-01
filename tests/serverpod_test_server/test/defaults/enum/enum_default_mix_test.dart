import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with mixed fields defaults",
    () {
      test(
        'when the field has both "default" and "defaultModel", then the field value should be the "defaultModel" value',
        () {
          var object = EnumDefaultMix();
          expect(
            object.byNameEnumDefaultAndDefaultModel,
            equals(ByNameEnum.byName2),
          );
        },
      );

      test(
        'when the field has both "default" and "defaultPersist", then the field value should be the "default" value',
        () {
          var object = EnumDefaultMix();
          expect(
            object.byNameEnumDefaultAndDefaultPersist,
            equals(ByNameEnum.byName1),
          );
        },
      );

      test(
        'when the field has both "defaultModel" and "defaultPersist", then the field value should be the "defaultModel" value',
        () {
          var object = EnumDefaultMix();
          expect(
            object.byNameEnumDefaultModelAndDefaultPersist,
            equals(ByNameEnum.byName1),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "byNameEnumDefaultAndDefaultModel", then the field value should match the provided value',
        () {
          var object = EnumDefaultMix(
            byNameEnumDefaultAndDefaultModel: ByNameEnum.byName1,
          );
          expect(
            object.byNameEnumDefaultAndDefaultModel,
            equals(ByNameEnum.byName1),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "byNameEnumDefaultAndDefaultPersist", then the field value should match the provided value',
        () {
          var object = EnumDefaultMix(
            byNameEnumDefaultAndDefaultPersist: ByNameEnum.byName2,
          );
          expect(
            object.byNameEnumDefaultAndDefaultPersist,
            equals(ByNameEnum.byName2),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "byNameEnumDefaultModelAndDefaultPersist", then the field value should match the provided value',
        () {
          var object = EnumDefaultMix(
            byNameEnumDefaultModelAndDefaultPersist: ByNameEnum.byName2,
          );
          expect(
            object.byNameEnumDefaultModelAndDefaultPersist,
            equals(ByNameEnum.byName2),
          );
        },
      );
    },
  );
}
