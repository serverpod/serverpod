import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'default' enum fields",
    () {
      test(
        'when an object of the class is created, then the "byNameEnumDefault" field should match the default enum value',
        () {
          var object = EnumDefault();
          expect(
            object.byNameEnumDefault,
            equals(ByNameEnum.byName1),
          );
        },
      );

      test(
        'when an object of the class is created, then the "byNameEnumDefaultNull" field should match the default enum value',
        () {
          var object = EnumDefault();
          expect(
            object.byNameEnumDefaultNull,
            equals(ByNameEnum.byName2),
          );
        },
      );

      test(
        'when an object of the class is created, then the "byIndexEnumDefault" field should match the default enum value',
        () {
          var object = EnumDefault();
          expect(
            object.byIndexEnumDefault,
            equals(ByIndexEnum.byIndex1),
          );
        },
      );

      test(
        'when an object of the class is created, then the "byIndexEnumDefaultNull" field should match the default enum value',
        () {
          var object = EnumDefault();
          expect(
            object.byIndexEnumDefaultNull,
            equals(ByIndexEnum.byIndex2),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "byNameEnumDefault", then the field value should match the provided enum value',
        () {
          var object = EnumDefault(
            byNameEnumDefault: ByNameEnum.byName2,
          );
          expect(
            object.byNameEnumDefault,
            equals(ByNameEnum.byName2),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "byNameEnumDefaultNull", then the field value should match the provided enum value',
        () {
          var object = EnumDefault(
            byNameEnumDefaultNull: ByNameEnum.byName1,
          );
          expect(
            object.byNameEnumDefaultNull,
            equals(ByNameEnum.byName1),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "byIndexEnumDefault", then the field value should match the provided enum value',
        () {
          var object = EnumDefault(
            byIndexEnumDefault: ByIndexEnum.byIndex2,
          );
          expect(
            object.byIndexEnumDefault,
            equals(ByIndexEnum.byIndex2),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "byIndexEnumDefaultNull", then the field value should match the provided enum value',
        () {
          var object = EnumDefault(
            byIndexEnumDefaultNull: ByIndexEnum.byIndex1,
          );
          expect(
            object.byIndexEnumDefaultNull,
            equals(ByIndexEnum.byIndex1),
          );
        },
      );
    },
  );
}
