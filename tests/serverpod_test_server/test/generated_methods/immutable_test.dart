import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Equals behavior', () {
    test(
        'Given an immutable object when comparing to other object with same value then objects should be equal',
        () {
      final firstObject = ImmutableObject(variable: 'value');
      final secondObject = ImmutableObject(variable: 'value');
      expect(firstObject == secondObject, true);
    });

    test(
        'Given an immutable object when comparing to other object with different value then objects should not be equal',
        () {
      final firstObject = ImmutableObject(variable: 'value1');
      final secondObject = ImmutableObject(variable: 'value2');
      expect(firstObject == secondObject, false);
    });

    test(
        'Given an immutable object with list when comparing to other object with same list then objects should be equal',
        () {
      final firstObject =
          ImmutableObjectWithList(listVariable: ['a', 'b', 'c']);
      final secondObject =
          ImmutableObjectWithList(listVariable: ['a', 'b', 'c']);
      expect(firstObject == secondObject, true);
    });

    test(
        'Given an immutable object with list when comparing to other object with different list then objects should not be equal',
        () {
      final firstObject =
          ImmutableObjectWithList(listVariable: ['a', 'b', 'c']);
      final secondObject =
          ImmutableObjectWithList(listVariable: ['a', 'b', 'd']);
      expect(firstObject == secondObject, false);
    });

    test(
        'Given an immutable object with map when comparing to other object with same map then objects should be equal',
        () {
      final firstObject =
          ImmutableObjectWithMap(mapVariable: {'k1': 'v1', 'k2': 'v2'});
      final secondObject =
          ImmutableObjectWithMap(mapVariable: {'k1': 'v1', 'k2': 'v2'});
      expect(firstObject == secondObject, true);
    });

    test(
        'Given an immutable object with map when comparing to other object with different map then objects should not be equal',
        () {
      final firstObject =
          ImmutableObjectWithMap(mapVariable: {'k1': 'v1', 'k2': 'v2'});
      final secondObject =
          ImmutableObjectWithMap(mapVariable: {'k1': 'v1', 'k2': 'DIFFERENT'});
      expect(firstObject == secondObject, false);
    });
  });

  group('copyWith', () {
    test('copyWith on ImmutableObject returns a new object with updated value',
        () {
      final original = ImmutableObject(variable: 'original');
      final copy = original.copyWith(variable: 'updated');
      expect(copy.variable, 'updated');
      expect(original.variable, 'original');
      expect(copy == original, false);
    });

    test(
        'copyWith on ImmutableObjectWithList returns a new object with updated list',
        () {
      final original = ImmutableObjectWithList(listVariable: ['a', 'b']);
      final copy = original.copyWith(listVariable: ['x', 'y']);
      expect(copy.listVariable, ['x', 'y']);
      expect(original.listVariable, ['a', 'b']);
      expect(copy == original, false);
    });

    test(
        'copyWith on ImmutableObjectWithMap returns a new object with updated map',
        () {
      final original = ImmutableObjectWithMap(mapVariable: {'k': 'v'});
      final copy = original.copyWith(mapVariable: {'k': 'new'});
      expect(copy.mapVariable, {'k': 'new'});
      expect(original.mapVariable, {'k': 'v'});
      expect(copy == original, false);
    });
  });
}
