import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

class _TestProtocol extends SerializationManager {}

void main() {
  var protocol = _TestProtocol();

  group('Given a null value with dynamic type', () {
    test(
      'when deserializing with explicit dynamic type parameter then null is returned',
      () {
        final result = protocol.deserialize<dynamic>(null);
        expect(result, isNull);
      },
    );

    test(
      'when deserializing with explicit dynamic type argument then null is returned',
      () {
        final result = protocol.deserialize<dynamic>(null, dynamic);
        expect(result, isNull);
      },
    );
  });

  group('Given a primitive value with dynamic type', () {
    test(
      'when deserializing an integer then the integer is returned',
      () {
        final result = protocol.deserialize<dynamic>(42);
        expect(result, 42);
      },
    );

    test(
      'when deserializing a double then the double is returned',
      () {
        final result = protocol.deserialize<dynamic>(3.14);
        expect(result, 3.14);
      },
    );

    test(
      'when deserializing a string then the string is returned',
      () {
        final result = protocol.deserialize<dynamic>('hello');
        expect(result, 'hello');
      },
    );

    test(
      'when deserializing a boolean then the boolean is returned',
      () {
        final result = protocol.deserialize<dynamic>(true);
        expect(result, isTrue);
      },
    );
  });

  group('Given a List value with dynamic type', () {
    test(
      'when deserializing a List<dynamic> with explicit dynamic type then the list is returned',
      () {
        final input = <dynamic>[1, 'two', true];
        final result = protocol.deserialize<dynamic>(input);
        expect(result, input);
      },
    );

    test(
      'when deserializing a List<int> with explicit dynamic type then the list is returned',
      () {
        final input = [1, 2, 3];
        final result = protocol.deserialize<dynamic>(input);
        expect(result, input);
      },
    );

    test(
      'when deserializing a nested List with explicit dynamic type then the nested list is returned',
      () {
        final input = [
          [1, 2],
          [3, 4],
        ];
        final result = protocol.deserialize<dynamic>(input);
        expect(result, input);
      },
    );
  });

  group('Given a Map value with dynamic type', () {
    test(
      'when deserializing a Map<String, dynamic> with explicit dynamic type then the map is returned',
      () {
        final input = <String, dynamic>{'key': 'value', 'count': 42};
        final result = protocol.deserialize<dynamic>(input);
        expect(result, input);
      },
    );

    test(
      'when deserializing a Map<String, dynamic> with null values with explicit dynamic type then the map is returned',
      () {
        final input = <String, dynamic>{'key': null, 'count': 0};
        final result = protocol.deserialize<dynamic>(input);
        expect(result, input);
      },
    );

    test(
      'when deserializing a Map with nested List values with explicit dynamic type then the map is returned',
      () {
        final input = <String, dynamic>{
          'items': [1, 2, 3],
          'name': 'test',
        };
        final result = protocol.deserialize<dynamic>(input);
        expect(result, input);
      },
    );
  });

  group('Given a List value passed directly to deserialize', () {
    test(
      'when deserializing a List without a type parameter then the list is returned',
      () {
        final input = [1, 2, 3];
        final result = protocol.deserialize(input);
        expect(result, input);
      },
    );

    test(
      'when deserializing an empty List then an empty list is returned',
      () {
        final input = <dynamic>[];
        final result = protocol.deserialize(input);
        expect(result, isEmpty);
      },
    );
  });

  group('Given a Map value passed directly to deserialize', () {
    test(
      'when deserializing a Map without a type parameter then the map is returned',
      () {
        final input = {'a': 1, 'b': 2};
        final result = protocol.deserialize(input);
        expect(result, input);
      },
    );

    test(
      'when deserializing an empty Map then an empty map is returned',
      () {
        final input = <String, dynamic>{};
        final result = protocol.deserialize(input);
        expect(result, isEmpty);
      },
    );
  });

  group(
    'Given a Map<String, dynamic> field where values are already-decoded JSON containers',
    () {
      test(
        'when deserializing a value that is a List with dynamic type argument then no exception is thrown',
        () {
          final listValue = [1, 2, 3];
          expect(
            () => protocol.deserialize<dynamic>(listValue, dynamic),
            returnsNormally,
          );
        },
      );

      test(
        'when deserializing a value that is a Map with dynamic type argument then no exception is thrown',
        () {
          final mapValue = {'nested': 'value'};
          expect(
            () => protocol.deserialize<dynamic>(mapValue, dynamic),
            returnsNormally,
          );
        },
      );

      test(
        'when deserializing a null value with dynamic type argument then no exception is thrown',
        () {
          expect(
            () => protocol.deserialize<dynamic>(null, dynamic),
            returnsNormally,
          );
        },
      );
    },
  );
}
