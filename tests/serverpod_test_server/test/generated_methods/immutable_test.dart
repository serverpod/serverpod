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
      },
    );

    test(
      'Given two immutable objects with different values when comparing equality then equality comparison returns false',
      () {
        final firstObject = ImmutableObject(variable: 'value1');
        final secondObject = ImmutableObject(variable: 'value2');
        expect(firstObject, isNot(equals(secondObject)));
      },
    );

    test(
      'Given two immutable objects each containing identical lists when comparing equality then equality comparison returns true',
      () {
        final firstObject = ImmutableObjectWithList(
          listVariable: ['a', 'b', 'c'],
        );
        final secondObject = ImmutableObjectWithList(
          listVariable: ['a', 'b', 'c'],
        );
        expect(firstObject, equals(secondObject));
      },
    );

    test(
      'Given two immutable objects each containing different lists when comparing equality then equality comparison returns false',
      () {
        final firstObject = ImmutableObjectWithList(
          listVariable: ['a', 'b', 'c'],
        );
        final secondObject = ImmutableObjectWithList(
          listVariable: ['a', 'b', 'd'],
        );
        expect(firstObject, isNot(equals(secondObject)));
      },
    );

    test(
      'Given two immutable objects each containing identical maps when comparing equality then equality comparison returns true',
      () {
        final firstObject = ImmutableObjectWithMap(
          mapVariable: {'k1': 'v1', 'k2': 'v2'},
        );
        final secondObject = ImmutableObjectWithMap(
          mapVariable: {'k1': 'v1', 'k2': 'v2'},
        );
        expect(firstObject, equals(secondObject));
      },
    );

    test(
      'Given two immutable objects each containing different maps when comparing equality then equality comparison returns false',
      () {
        final firstObject = ImmutableObjectWithMap(
          mapVariable: {'k1': 'v1', 'k2': 'v2'},
        );
        final secondObject = ImmutableObjectWithMap(
          mapVariable: {'k1': 'v1', 'k2': 'DIFFERENT'},
        );
        expect(firstObject, isNot(equals(secondObject)));
      },
    );

    test(
      'Given two immutable objects each containing identical records when comparing equality then equality comparison returns true',
      () {
        final firstObject = ImmutableObjectWithRecord(
          recordVariable: (1, 'value'),
        );
        final secondObject = ImmutableObjectWithRecord(
          recordVariable: (1, 'value'),
        );
        expect(firstObject, equals(secondObject));
      },
    );

    test(
      'Given two immutable objects each containing different records when comparing equality then equality comparison returns false',
      () {
        final firstObject = ImmutableObjectWithRecord(
          recordVariable: (1, 'value1'),
        );
        final secondObject = ImmutableObjectWithRecord(
          recordVariable: (1, 'value2'),
        );
        expect(firstObject, isNot(equals(secondObject)));
      },
    );

    test(
      'Given two immutable objects containing identical immutable objects when comparing equality then equality comparison returns true',
      () {
        final firstObject = ImmutableObjectWithImmutableObject(
          immutableVariable: ImmutableObject(variable: 'value'),
        );
        final secondObject = ImmutableObjectWithImmutableObject(
          immutableVariable: ImmutableObject(variable: 'value'),
        );
        expect(firstObject, equals(secondObject));
      },
    );

    test(
      'Given two immutable objects containing different immutable objects when comparing equality then equality comparison returns false',
      () {
        final firstObject = ImmutableObjectWithImmutableObject(
          immutableVariable: ImmutableObject(variable: 'value1'),
        );
        final secondObject = ImmutableObjectWithImmutableObject(
          immutableVariable: ImmutableObject(variable: 'value2'),
        );
        expect(firstObject, isNot(equals(secondObject)));
      },
    );

    test(
      'Given two identical immutable objects with no fields when comparing equality then equality comparison returns true',
      () {
        final firstObject = ImmutableObjectWithNoFields();
        final secondObject = ImmutableObjectWithNoFields();
        expect(firstObject, equals(secondObject));
      },
    );

    test(
      'Given two immutable objects with multiple identical fields when comparing equality then equality comparison returns true',
      () {
        final firstObject = ImmutableObjectWithMultipleFields(
          anInt: 1,
          aString: 'value',
          aBool: true,
          aDouble: 1.0,
        );
        final secondObject = ImmutableObjectWithMultipleFields(
          anInt: 1,
          aString: 'value',
          aBool: true,
          aDouble: 1.0,
        );
        expect(firstObject, equals(secondObject));
      },
    );

    test(
      'Given two immutable objects with multiple different fields when comparing equality then equality comparison returns false',
      () {
        final firstObject = ImmutableObjectWithMultipleFields(
          anInt: 1,
          aString: 'value1',
          aBool: true,
          aDouble: 1.0,
        );
        final secondObject = ImmutableObjectWithMultipleFields(
          anInt: 1,
          aString: 'value2',
          aBool: true,
          aDouble: 1.0,
        );
        expect(firstObject, isNot(equals(secondObject)));
      },
    );

    test(
      'Given two immutable child objects with identical fields when comparing equality then equality comparison returns true',
      () {
        final firstObject = ImmutableChildObject(
          variable: 'value',
          childVariable: 'childValue',
        );
        final secondObject = ImmutableChildObject(
          variable: 'value',
          childVariable: 'childValue',
        );
        expect(firstObject, equals(secondObject));
      },
    );

    test(
      'Given two immutable child objects with different fields when comparing equality then equality comparison returns false',
      () {
        final firstObject = ImmutableChildObject(
          variable: 'value1',
          childVariable: 'childValue',
        );
        final secondObject = ImmutableChildObject(
          variable: 'value2',
          childVariable: 'childValue',
        );
        expect(firstObject, isNot(equals(secondObject)));
      },
    );

    test(
      'Given an immutable object and a immutable child object with identical fields when comparing equality then equality comparison returns false',
      () {
        final firstObject = ImmutableObject(variable: 'value');
        final secondObject = ImmutableChildObjectWithNoAdditionalFields(
          variable: 'value',
        );
        expect(firstObject, isNot(equals(secondObject)));
      },
    );
  });

  group('copyWith', () {
    group(
      'Given an immutable object when creating a copy with a new scalar value',
      () {
        late ImmutableObject original;
        late ImmutableObject copy;

        setUp(() {
          original = ImmutableObject(variable: 'original');
          copy = original.copyWith(variable: 'updated');
        });

        test('then the copy has the updated value', () {
          expect(copy.variable, equals('updated'));
        });

        test('then the original remains unchanged', () {
          expect(original.variable, equals('original'));
        });

        test('then the copy and original are not equal', () {
          expect(copy, isNot(equals(original)));
        });
      },
    );

    group(
      'Given an immutable object containing a list when creating a copy with a new list',
      () {
        late ImmutableObjectWithList original;
        late ImmutableObjectWithList copy;

        setUp(() {
          original = ImmutableObjectWithList(listVariable: ['a', 'b']);
          copy = original.copyWith(listVariable: ['x', 'y']);
        });

        test('then the copy has the updated list', () {
          expect(copy.listVariable, equals(['x', 'y']));
        });

        test('then the original remains unchanged', () {
          expect(original.listVariable, equals(['a', 'b']));
        });

        test('then the copy and original are not equal', () {
          expect(copy, isNot(equals(original)));
        });
      },
    );

    group(
      'Given an immutable object containing a map when creating a copy with a new map',
      () {
        late ImmutableObjectWithMap original;
        late ImmutableObjectWithMap copy;

        setUp(() {
          original = ImmutableObjectWithMap(mapVariable: {'k': 'v'});
          copy = original.copyWith(mapVariable: {'k': 'new'});
        });

        test('then the copy has the updated map', () {
          expect(copy.mapVariable, equals({'k': 'new'}));
        });

        test('then the original remains unchanged', () {
          expect(original.mapVariable, equals({'k': 'v'}));
        });

        test('then the copy and original are not equal', () {
          expect(copy, isNot(equals(original)));
        });
      },
    );

    group(
      'Given an immutable object containing a record when creating a copy with a new record',
      () {
        late ImmutableObjectWithRecord original;
        late ImmutableObjectWithRecord copy;

        setUp(() {
          original = ImmutableObjectWithRecord(recordVariable: (1, 'a'));
          copy = original.copyWith(recordVariable: (2, 'b'));
        });

        test('then the copy has the updated record', () {
          expect(copy.recordVariable, equals((2, 'b')));
        });

        test('then the original remains unchanged', () {
          expect(original.recordVariable, equals((1, 'a')));
        });

        test('then the copy and original are not equal', () {
          expect(copy, isNot(equals(original)));
        });
      },
    );

    group(
      'Given an immutable object containing another immutable object when creating a copy with a new immutable object',
      () {
        late ImmutableObjectWithImmutableObject original;
        late ImmutableObjectWithImmutableObject copy;

        setUp(() {
          original = ImmutableObjectWithImmutableObject(
            immutableVariable: ImmutableObject(variable: 'original'),
          );
          copy = original.copyWith(
            immutableVariable: ImmutableObject(variable: 'updated'),
          );
        });

        test('then the copy has the updated immutable object', () {
          expect(copy.immutableVariable.variable, equals('updated'));
        });

        test('then the original remains unchanged', () {
          expect(original.immutableVariable.variable, equals('original'));
        });

        test('then the copy and original are not equal', () {
          expect(copy, isNot(equals(original)));
        });
      },
    );

    group(
      'Given an immutable object with multiple fields when creating a copy with some updated fields',
      () {
        late ImmutableObjectWithMultipleFields original;
        late ImmutableObjectWithMultipleFields copy;

        setUp(() {
          original = ImmutableObjectWithMultipleFields(
            anInt: 1,
            aString: 'original',
            aBool: true,
            aDouble: 1.0,
          );
          copy = original.copyWith(
            aString: 'updated',
            aBool: false,
          );
        });

        test('then the copy has the updated fields', () {
          expect(copy.anInt, equals(1));
          expect(copy.aString, equals('updated'));
          expect(copy.aBool, equals(false));
          expect(copy.aDouble, equals(1.0));
        });

        test('then the original remains unchanged', () {
          expect(original.anInt, equals(1));
          expect(original.aString, equals('original'));
          expect(original.aBool, equals(true));
          expect(original.aDouble, equals(1.0));
        });

        test('then the copy and original are not equal', () {
          expect(copy, isNot(equals(original)));
        });
      },
    );

    group(
      'Given an immutable child object when creating a copy with a new scalar value',
      () {
        late ImmutableChildObject original;
        late ImmutableChildObject copy;

        setUp(() {
          original = ImmutableChildObject(
            variable: 'original',
            childVariable: 'childOriginal',
          );
          copy = original.copyWith(variable: 'updated');
        });

        test('then the copy has the updated value', () {
          expect(copy.variable, equals('updated'));
        });

        test('then the copy retains the original childVariable', () {
          expect(copy.childVariable, equals('childOriginal'));
        });

        test('then the original remains unchanged', () {
          expect(original.variable, equals('original'));
          expect(original.childVariable, equals('childOriginal'));
        });

        test('then the copy and original are not equal', () {
          expect(copy, isNot(equals(original)));
        });
      },
    );
  });
}
