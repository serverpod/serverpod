import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Equals behavior', () {
    test(
        'Given two identical immutable objects when comparing equality then equality comparison returns true',
        () {
      final firstObject = ImmutableObject(variable: 'value');
      final secondObject = ImmutableObject(variable: 'value');
      expect(firstObject, equals(secondObject));
    });

    test(
        'Given two immutable objects with different values when comparing equality then equality comparison returns false',
        () {
      final firstObject = ImmutableObject(variable: 'value1');
      final secondObject = ImmutableObject(variable: 'value2');
      expect(firstObject, isNot(equals(secondObject)));
    });

    test(
        'Given two immutable objects each containing identical lists when comparing equality then equality comparison returns true',
        () {
      final firstObject =
          ImmutableObjectWithList(listVariable: ['a', 'b', 'c']);
      final secondObject =
          ImmutableObjectWithList(listVariable: ['a', 'b', 'c']);
      expect(firstObject, equals(secondObject));
    });

    test(
        'Given two immutable objects each containing different lists when comparing equality then equality comparison returns false',
        () {
      final firstObject =
          ImmutableObjectWithList(listVariable: ['a', 'b', 'c']);
      final secondObject =
          ImmutableObjectWithList(listVariable: ['a', 'b', 'd']);
      expect(firstObject, isNot(equals(secondObject)));
    });

    test(
        'Given two immutable objects each containing identical maps when comparing equality then equality comparison returns true',
        () {
      final firstObject =
          ImmutableObjectWithMap(mapVariable: {'k1': 'v1', 'k2': 'v2'});
      final secondObject =
          ImmutableObjectWithMap(mapVariable: {'k1': 'v1', 'k2': 'v2'});
      expect(firstObject, equals(secondObject));
    });

    test(
        'Given two immutable objects each containing different maps when comparing equality then equality comparison returns false',
        () {
      final firstObject =
          ImmutableObjectWithMap(mapVariable: {'k1': 'v1', 'k2': 'v2'});
      final secondObject =
          ImmutableObjectWithMap(mapVariable: {'k1': 'v1', 'k2': 'DIFFERENT'});
      expect(firstObject, isNot(equals(secondObject)));
    });
  });

  group('copyWith', () {
    test(
        'Given an immutable object when creating a copy with a new scalar value then returned object has updated value original remains unchanged and objects are not equal',
        () {
      final original = ImmutableObject(variable: 'original');
      final copy = original.copyWith(variable: 'updated');
      expect(copy.variable, equals('updated'));
      expect(original.variable, equals('original'));
      expect(copy, isNot(equals(original)));
    });

    test(
        'Given an immutable object containing a list when creating a copy with a new list then returned object has updated list original remains unchanged and objects are not equal',
        () {
      final original = ImmutableObjectWithList(listVariable: ['a', 'b']);
      final copy = original.copyWith(listVariable: ['x', 'y']);
      expect(copy.listVariable, equals(['x', 'y']));
      expect(original.listVariable, equals(['a', 'b']));
      expect(copy, isNot(equals(original)));
    });

    test(
        'Given an immutable object containing a map when creating a copy with a new map then returned object has updated map original remains unchanged and objects are not equal',
        () {
      final original = ImmutableObjectWithMap(mapVariable: {'k': 'v'});
      final copy = original.copyWith(mapVariable: {'k': 'new'});
      expect(copy.mapVariable, equals({'k': 'new'}));
      expect(original.mapVariable, equals({'k': 'v'}));
      expect(copy, isNot(equals(original)));
    });
  });
}
