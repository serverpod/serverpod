import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given a model with enhanced enum fields', () {
    test(
        'when serializing and deserializing then enhanced enum properties are preserved',
        () {
      var object = ObjectWithEnumEnhanced(
        testEnumEnhanced: TestEnumEnhanced.one,
        enumEnhancedList: [TestEnumEnhanced.two, TestEnumEnhanced.three],
      );

      var json = object.toJson();
      var restored = ObjectWithEnumEnhanced.fromJson(json);

      expect(restored.testEnumEnhanced, TestEnumEnhanced.one);
      expect(restored.testEnumEnhanced.shortName, '1');
      expect(restored.testEnumEnhanced.priority, 10);
      expect(restored.enumEnhancedList.length, 2);
      expect(restored.enumEnhancedList[0].priority, 0);
    });

    test('when nullable enhanced enum is null then it deserializes as null',
        () {
      var object = ObjectWithEnumEnhanced(
        testEnumEnhanced: TestEnumEnhanced.one,
        nullableEnumEnhanced: null,
        enumEnhancedList: [],
      );

      var json = object.toJson();
      var restored = ObjectWithEnumEnhanced.fromJson(json);

      expect(restored.nullableEnumEnhanced, isNull);
    });

    test(
        'when nullable enhanced enum has value then properties are accessible',
        () {
      var object = ObjectWithEnumEnhanced(
        testEnumEnhanced: TestEnumEnhanced.one,
        nullableEnumEnhanced: TestEnumEnhanced.three,
        enumEnhancedList: [],
      );

      var json = object.toJson();
      var restored = ObjectWithEnumEnhanced.fromJson(json);

      expect(restored.nullableEnumEnhanced, TestEnumEnhanced.three);
      expect(restored.nullableEnumEnhanced?.description, 'The third value');
    });
  });
}
