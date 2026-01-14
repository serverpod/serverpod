import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given a model with enhanced enum fields', () {
    test(
      'when deserializing then enhanced enum properties are preserved',
      () {
        final object = ObjectWithEnumEnhanced(
          byIndex: TestEnumEnhanced.one,
          byName: TestEnumEnhancedByName.one,
          byIndexList: [TestEnumEnhanced.two, TestEnumEnhanced.three],
          byNameList: [],
        );

        final json = object.toJson();
        final restored = ObjectWithEnumEnhanced.fromJson(json);

        expect(restored.byIndex, TestEnumEnhanced.one);
        expect(restored.byIndex.shortName, '1');
        expect(restored.byIndex.priority, 10);
        expect(restored.byIndexList.length, 2);
        expect(restored.byIndexList[0].priority, 0); // default value
      },
    );
  });

  group('Given a model with nullable enhanced enum field set to null', () {
    test(
      'when deserializing then it deserializes as null',
      () {
        final object = ObjectWithEnumEnhanced(
          byIndex: TestEnumEnhanced.one,
          byName: TestEnumEnhancedByName.one,
          nullableByIndex: null,
          byIndexList: [],
          byNameList: [],
        );

        final json = object.toJson();
        final restored = ObjectWithEnumEnhanced.fromJson(json);

        expect(restored.nullableByIndex, isNull);
      },
    );
  });

  group('Given a model with nullable enhanced enum field set to a value', () {
    test(
      'when deserializing then properties are accessible',
      () {
        final object = ObjectWithEnumEnhanced(
          byIndex: TestEnumEnhanced.one,
          byName: TestEnumEnhancedByName.one,
          nullableByIndex: TestEnumEnhanced.three,
          byIndexList: [],
          byNameList: [],
        );

        final json = object.toJson();
        final restored = ObjectWithEnumEnhanced.fromJson(json);

        expect(restored.nullableByIndex, TestEnumEnhanced.three);
        expect(restored.nullableByIndex?.description, 'The third value');
      },
    );
  });
}
