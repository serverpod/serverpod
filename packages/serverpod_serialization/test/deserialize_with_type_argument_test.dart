import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

class _Protocol extends SerializationManager {}

void main() {
  var protocol = _Protocol();

  group('Given deserialize is called with a Type argument and dynamic T', () {
    test('when deserializing an int as int then the int is returned.', () {
      expect(protocol.deserialize(42, int), 42);
    });

    test('when deserializing null as int? then null is returned.', () {
      expect(protocol.deserialize(null, getType<int?>()), isNull);
    });

    test('when deserializing a String as int then a TypeError is thrown.', () {
      expect(
        () => protocol.deserialize('not an int', int),
        throwsA(isA<TypeError>()),
      );
    });

    test('when deserializing a double as int then a TypeError is thrown.', () {
      expect(
        () => protocol.deserialize(1.5, int),
        throwsA(isA<TypeError>()),
      );
    });

    test(
      'when deserializing a String as String then the String is returned.',
      () {
        expect(protocol.deserialize('value', String), 'value');
      },
    );

    test('when deserializing null as String? then null is returned.', () {
      expect(protocol.deserialize(null, getType<String?>()), isNull);
    });

    test('when deserializing an int as String then a TypeError is thrown.', () {
      expect(
        () => protocol.deserialize(42, String),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
