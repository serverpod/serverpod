import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

class _Protocol extends SerializationManager {}

void main() {
  var protocol = _Protocol();

  group('int target type', () {
    test(
      'Given an integer value when deserialized as int then it is returned.',
      () {
        var value = 42;

        expect(protocol.deserialize(value, int), value);
      },
    );

    test(
      'Given a null value when deserialized as int? then null is returned.',
      () {
        Object? value;

        expect(protocol.deserialize(value, getType<int?>()), isNull);
      },
    );

    test(
      'Given a String value when deserialized as int then a TypeError is thrown.',
      () {
        var value = 'not an int';

        expect(
          () => protocol.deserialize(value, int),
          throwsA(isA<TypeError>()),
        );
      },
    );

    test(
      'Given a double value when deserialized as int then a TypeError is thrown.',
      () {
        var value = 1.5;

        expect(
          () => protocol.deserialize(value, int),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });

  group('String target type', () {
    test(
      'Given a String value when deserialized as String then it is returned.',
      () {
        var value = 'value';

        expect(protocol.deserialize(value, String), value);
      },
    );

    test(
      'Given a null value when deserialized as String? then null is returned.',
      () {
        Object? value;

        expect(protocol.deserialize(value, getType<String?>()), isNull);
      },
    );

    test(
      'Given a non-String value when deserialized as String then a TypeError is thrown.',
      () {
        var value = 42;

        expect(
          () => protocol.deserialize(value, String),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });
}
