import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultPersist' enum fields",
    () {
      test(
        'when an object of the class is created, then the "byNameEnumDefaultPersist" field should be null',
        () {
          var object = EnumDefaultPersist();
          expect(
            object.byNameEnumDefaultPersist,
            isNull,
          );
        },
      );

      test(
        'when an object of the class is created, then the "byIndexEnumDefaultPersist" field should be null',
        () {
          var object = EnumDefaultPersist();
          expect(
            object.byIndexEnumDefaultPersist,
            isNull,
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "byNameEnumDefaultPersist", then the field value should match the provided enum value',
        () {
          var object = EnumDefaultPersist(
            byNameEnumDefaultPersist: ByNameEnum.byName2,
          );
          expect(
            object.byNameEnumDefaultPersist,
            equals(ByNameEnum.byName2),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "byIndexEnumDefaultPersist", then the field value should match the provided enum value',
        () {
          var object = EnumDefaultPersist(
            byIndexEnumDefaultPersist: ByIndexEnum.byIndex2,
          );
          expect(
            object.byIndexEnumDefaultPersist,
            equals(ByIndexEnum.byIndex2),
          );
        },
      );
    },
  );
}
