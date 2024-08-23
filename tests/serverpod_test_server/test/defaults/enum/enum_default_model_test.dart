import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultModel' enum fields",
    () {
      test(
        'when an object of the class is created, then the "byNameEnumDefaultModel" field should match the default enum value',
        () {
          var object = EnumDefaultModel();
          expect(
            object.byNameEnumDefaultModel,
            equals(ByNameEnum.byName1),
          );
        },
      );

      test(
        'when an object of the class is created, then the "byNameEnumDefaultModelNull" field should match the default enum value',
        () {
          var object = EnumDefaultModel();
          expect(
            object.byNameEnumDefaultModelNull,
            equals(ByNameEnum.byName2),
          );
        },
      );

      test(
        'when an object of the class is created, then the "byIndexEnumDefaultModel" field should match the default enum value',
        () {
          var object = EnumDefaultModel();
          expect(
            object.byIndexEnumDefaultModel,
            equals(ByIndexEnum.byIndex1),
          );
        },
      );

      test(
        'when an object of the class is created, then the "byIndexEnumDefaultModelNull" field should match the default enum value',
        () {
          var object = EnumDefaultModel();
          expect(
            object.byIndexEnumDefaultModelNull,
            equals(ByIndexEnum.byIndex2),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "byNameEnumDefaultModel", then the field value should match the provided enum value',
        () {
          var object = EnumDefaultModel(
            byNameEnumDefaultModel: ByNameEnum.byName2,
          );
          expect(
            object.byNameEnumDefaultModel,
            equals(ByNameEnum.byName2),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "byNameEnumDefaultModelNull", then the field value should match the provided enum value',
        () {
          var object = EnumDefaultModel(
            byNameEnumDefaultModelNull: ByNameEnum.byName1,
          );
          expect(
            object.byNameEnumDefaultModelNull,
            equals(ByNameEnum.byName1),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "byIndexEnumDefaultModel", then the field value should match the provided enum value',
        () {
          var object = EnumDefaultModel(
            byIndexEnumDefaultModel: ByIndexEnum.byIndex2,
          );
          expect(
            object.byIndexEnumDefaultModel,
            equals(ByIndexEnum.byIndex2),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "byIndexEnumDefaultModelNull", then the field value should match the provided enum value',
        () {
          var object = EnumDefaultModel(
            byIndexEnumDefaultModelNull: ByIndexEnum.byIndex1,
          );
          expect(
            object.byIndexEnumDefaultModelNull,
            equals(ByIndexEnum.byIndex1),
          );
        },
      );
    },
  );
}
